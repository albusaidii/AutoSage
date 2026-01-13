require("dotenv").config();

// =================================================
// IMPORTS
// =================================================
const express = require("express");
const cors = require("cors");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const crypto = require("crypto");

// OpenRouter fetch
const fetch = (...args) =>
  import("node-fetch").then(({ default: fetch }) => fetch(...args));

// =================================================
// APP SETUP
// =================================================
const app = express();
app.use(cors());
app.use(express.json());

// =================================================
// DATABASE
// =================================================
const db = require("./db");

db.connect((err) => {
  if (err) console.error("MySQL connection error:", err);
  else console.log("MySQL Connected...");
});

// =================================================
// MAINTENANCE MODE
// =================================================
app.use(async (req, res, next) => {
  try {
    const [rows] = await db.promise().query(
      "SELECT maintenance_mode FROM app_settings WHERE id=1"
    );

    if (rows[0].maintenance_mode === 1 && !req.path.startsWith("/api/admin")) {
      return res.status(503).json({
        message: "System is under maintenance. Please try again later.",
      });
    }

    next();
  } catch (err) {
    next();
  }
});

// =================================================
// ENV WARNINGS
// =================================================
if (!process.env.OPENROUTER_API_KEY)
  console.warn("OPENROUTER_API_KEY missing");

if (!process.env.JWT_SECRET)
  console.warn("JWT_SECRET missing");

// =================================================
// GREETING NOTIFICATIONS
// =================================================
async function sendGreetingNotification(user) {
  try {
    const [[settings]] = await db.promise().query(
      "SELECT notifications_enabled FROM app_settings WHERE id=1"
    );

    // Global notifications OFF → block everything
    if (settings.notifications_enabled !== 1) return;

    // User notifications OFF → block
    if (!user.notifications_enabled) return;

    const title = "Welcome to AutoSage 🚗";
    const message = `Hello ${user.name}, welcome to AutoSage! We’re excited to help you diagnose and manage your vehicle with ease.`;

    const [notifResult] = await db.promise().query(
      "INSERT INTO notifications (title, message, icon, icon_color) VALUES (?, ?, ?, ?)",
      [title, message, "notifications", "blue"]
    );

    await db.promise().query(
      "INSERT INTO user_notifications (user_id, notification_id) VALUES (?, ?)",
      [user.user_id, notifResult.insertId]
    );
  } catch (err) {
    console.error("Greeting notification error:", err);
  }
}


// =================================================
// AUTH ROUTES
// =================================================

// ---------- SIGNUP ----------
app.post("/api/signup", async (req, res) => {
  const { name, email, password, phone } = req.body;

  if (!name || !email || !password) {
    return res.status(400).json({ message: "Missing required fields" });
  }

  try {
    const hashed = await bcrypt.hash(password, 10);

    db.query(
      // FIX: initialize chatbot_used
      "INSERT INTO users (name, email, password_hash, phone, notifications_enabled, chatbot_used) VALUES (?, ?, ?, ?, 1, 0)",
      [name, email, hashed, phone || null],
      (err, result) => {
        if (err) {
          if (err.code === "ER_DUP_ENTRY") {
            return res.status(409).json({ message: "Email already exists" });
          }
          return res.status(500).json({ message: "Database error" });
        }

        const userId = result.insertId;

        const title = "Welcome to AutoSage 🚗";
        const message = `Hello ${name}, welcome to AutoSage! We’re excited to help you diagnose and manage your vehicle with ease.`;

        db.query(
          "INSERT INTO notifications (title, message, icon, icon_color) VALUES (?, ?, ?, ?)",
          [title, message, "celebration", "green"],
          (err2, notifResult) => {
            if (!err2) {
              db.query(
                "INSERT INTO user_notifications (user_id, notification_id) VALUES (?, ?)",
                [userId, notifResult.insertId]
              );
            }
          }
        );

        res.status(201).json({
          message: "User registered successfully",
          userId,
        });
      }
    );
  } catch {
    res.status(500).json({ message: "Server error" });
  }
});


// ---------- LOGIN ----------
app.post("/api/login", (req, res) => {
  const { email, password } = req.body;

  if (!email || !password)
    return res.status(400).json({ message: "Email and password required" });

  db.query("SELECT * FROM users WHERE email = ?", [email], async (err, rows) => {
    if (err) return res.status(500).json({ message: "DB error" });
    if (!rows.length) return res.status(404).json({ message: "User not found" });

    const user = rows[0];
    const match = await bcrypt.compare(password, user.password_hash);

    if (!match)
      return res.status(401).json({ message: "Incorrect password" });

    const token = jwt.sign(
      { id: user.user_id },
      process.env.JWT_SECRET || "autosage_secret",
      { expiresIn: "1h" }
    );

    res.json({
      status: true,
      token,
      user: {
        id: user.user_id,
        name: user.name,
        email: user.email,
        phone: user.phone,
      },
    });
  });
});

// =================================================
// FORGOT / RESET PASSWORD
// =================================================
app.post("/api/forgot-password", (req, res) => {
  const { email } = req.body;

  if (!email) return res.status(400).json({ message: "Email required" });

  db.query("SELECT user_id FROM users WHERE email = ?", [email], (err, rows) => {
    if (err) return res.status(500).json({ message: "DB error" });

    if (!rows.length) {
      return res.json({ message: "If email exists, reset token generated" });
    }

    const token = crypto.randomBytes(32).toString("hex");
    const expires = new Date(Date.now() + 15 * 60 * 1000);

    db.query(
      "INSERT INTO password_resets (user_id, token, expires_at) VALUES (?, ?, ?)",
      [rows[0].user_id, token, expires],
      () => res.json({ message: "Reset token generated", token, expires })
    );
  });
});

app.post("/api/reset-password", async (req, res) => {
  const { token, newPassword } = req.body;

  if (!token || !newPassword)
    return res.status(400).json({ message: "Missing fields" });

  db.query(
    "SELECT * FROM password_resets WHERE token = ? AND used = 0 AND expires_at > NOW()",
    [token],
    async (err, rows) => {
      if (!rows.length)
        return res.status(400).json({ message: "Invalid or expired token" });

      const hashed = await bcrypt.hash(newPassword, 10);

      db.query(
        "UPDATE users SET password_hash = ? WHERE user_id = ?",
        [hashed, rows[0].user_id],
        () => {
          db.query(
            "UPDATE password_resets SET used = 1 WHERE id = ?",
            [rows[0].id]
          );

          res.json({ message: "Password reset successful" });
        }
      );

     const title = "Password Changed";
     const message =
       "Your AutoSage account password was changed successfully. If this wasn’t you, contact support immediately.";

     db.query(
       "INSERT INTO notifications (title, message, icon, icon_color) VALUES (?, ?, ?, ?)",
       [title, message, "lock", "green"],
       (err2, notifResult) => {
         if (!err2) {
           db.query(
             "INSERT INTO user_notifications (user_id, notification_id) VALUES (?, ?)",
             [rows[0].user_id, notifResult.insertId]
           );
         }
       }
     );
    }
  );
});

// =================================================
// HISTORY
// =================================================
app.get("/api/history/:userId", (req, res) => {
  db.query(
    "SELECT * FROM history WHERE user_id = ? ORDER BY created_at DESC",
    [req.params.userId],
    (err, rows) => {
      if (err) return res.status(500).json({ message: "DB error" });
      res.json(rows);
    }
  );
});


// delete history item
app.delete("/api/history/item/:historyId", (req, res) => {
  const { historyId } = req.params;

  db.query(
    "DELETE FROM history WHERE history_id = ?",
    [historyId],
    (err, result) => {
      if (err) return res.status(500).json({ message: "DB error", err });
      if (!result.affectedRows)
        return res.status(404).json({ message: "History item not found" });

      res.json({ message: "History entry deleted" });
    }
  );
});


// =================================================
// PROFILE UPDATE
// =================================================
app.put("/api/profile/:userId", (req, res) => {
  const { name, email, phone } = req.body;
  const userId = req.params.userId;

  // Get old data first
  db.query(
    "SELECT name, email, phone FROM users WHERE user_id=?",
    [userId],
    (err, rows) => {
      if (err || !rows.length)
        return res.status(500).json({ message: "User not found" });

      const old = rows[0];
      const changes = [];

      if (name && name !== old.name) changes.push("name");
      if (email && email !== old.email) changes.push("email");
      if ((phone || null) !== old.phone) changes.push("phone number");

      db.query(
        "UPDATE users SET name=?, email=?, phone=? WHERE user_id=?",
        [name, email, phone || null, userId],
        (err2) => {
          if (err2) return res.status(500).json({ message: "Update failed" });

          //  NOTIFICATION IF ANY CHANGE
          if (changes.length) {
            const title = "Profile Updated";
            const message = `You updated your ${changes.join(", ")}.`;

            db.query(
              "INSERT INTO notifications (title, message, icon, icon_color) VALUES (?, ?, ?, ?)",
              [title, message, "person", "blue"],
              (err3, notifResult) => {
                if (!err3) {
                  db.query(
                    "INSERT INTO user_notifications (user_id, notification_id) VALUES (?, ?)",
                    [userId, notifResult.insertId]
                  );
                }
              }
            );
          }

          res.json({ message: "Profile updated" });
        }
      );
    }
  );
});

// =================================================
// DOWNLOAD USER DATA
// =================================================
app.get("/api/download-data/:userId", async (req, res) => {
  try {
    const [user] = await db.promise().query(
      "SELECT * FROM users WHERE user_id=?",
      [req.params.userId]
    );

    const [history] = await db.promise().query(
      "SELECT * FROM history WHERE user_id=?",
      [req.params.userId]
    );

    res.json({
      user: user[0],
      history,
      exported_at: new Date(),
    });
  } catch {
    res.status(500).json({ message: "Export failed" });
  }
});

// =================================================
// ACCOUNT DELETION (USER)
// =================================================
app.post("/api/request-deletion", (req, res) => {
  const { user_id } = req.body;

  db.query(
    `UPDATE users
     SET deletion_requested=1, deletion_requested_at=NOW(), deletion_approved=0
     WHERE user_id=?`,
    [user_id],
    (err, result) => {
      if (err) return res.status(500).json({ message: "Request failed" });
      if (!result.affectedRows)
        return res.status(404).json({ message: "User not found" });

      //  USER NOTIFICATION
      const title = "Account Deletion Requested";
      const message =
        "Your request to delete your AutoSage account has been submitted and is pending admin approval.";

      db.query(
        "INSERT INTO notifications (title, message, icon, icon_color) VALUES (?, ?, ?, ?)",
        [title, message, "warning", "orange"],
        (err2, notifResult) => {
          if (!err2) {
            db.query(
              "INSERT INTO user_notifications (user_id, notification_id) VALUES (?, ?)",
              [user_id, notifResult.insertId]
            );
          }
        }
      );

      res.json({ message: "Deletion request sent" });
    }
  );
});

// =================================================
// ADMIN – USER MANAGEMENT
// =================================================
app.get("/api/admin/users", (_, res) => {
  db.query("SELECT * FROM users ORDER BY user_id DESC", (_, rows) =>
    res.json(rows)
  );
});

app.post("/api/admin/users/:id/approve-deletion", async (req, res) => {
  const id = req.params.id;

  await db.promise().query("DELETE FROM history WHERE user_id=?", [id]);
  await db.promise().query("DELETE FROM users WHERE user_id=?", [id]);

  res.json({ message: "User deleted" });
});

app.post("/api/admin/users/:id/reject-deletion", (req, res) => {
  db.query(
    "UPDATE users SET deletion_requested=0 WHERE user_id=?",
    [req.params.id],
    () => res.json({ message: "Deletion rejected" })
  );
});

// =================================================
// NOTIFICATION SETTINGS
// =================================================
app.get("/api/settings/notifications/:userId", (req, res) => {
  const { userId } = req.params;

  db.query(
    "SELECT notifications_enabled FROM users WHERE user_id = ?",
    [userId],
    (err, rows) => {
      if (err) return res.status(500).json({ message: "DB error", error: err });
      if (!rows.length)
        return res.status(404).json({ message: "User not found" });

      res.json({ enabled: rows[0].notifications_enabled === 1 });
    }
  );
});

app.put("/api/settings/notifications/:userId", (req, res) => {
  const { userId } = req.params;
  const { enabled } = req.body;

  if (typeof enabled !== "boolean") {
    return res
      .status(400)
      .json({ message: "enabled must be boolean (true/false)" });
  }

  db.query(
    "UPDATE users SET notifications_enabled = ? WHERE user_id = ?",
    [enabled ? 1 : 0, userId],
    (err, result) => {
      if (err) return res.status(500).json({ message: "Update failed", err });
      if (!result.affectedRows)
        return res.status(404).json({ message: "User not found" });

      res.json({ message: "Notification preference updated", enabled });
    }
  );
});

// =================================================
// ADMIN: SEND NOTIFICATION
// =================================================
app.post("/api/admin/notifications/send", (req, res) => {
  const { title, message, icon, icon_color } = req.body;

  if (!title || !message) {
    return res
      .status(400)
      .json({ message: "title and message are required" });
  }

  db.query(
    "INSERT INTO notifications (title, message, icon, icon_color) VALUES (?, ?, ?, ?)",
    [title, message, icon || "notifications", icon_color || "blue"],
    (err, notifResult) => {
      if (err)
        return res
          .status(500)
          .json({ message: "Failed to create notification", err });

      const notificationId = notifResult.insertId;

      db.query(
        "SELECT user_id FROM users WHERE notifications_enabled = 1",
        (err2, users) => {
          if (err2)
            return res
              .status(500)
              .json({ message: "Failed to fetch users", err2 });

          if (!users.length)
            return res.json({
              message: "No users enabled notifications",
              delivered: 0,
            });

          const values = users.map((u) => [u.user_id, notificationId]);

          db.query(
            "INSERT INTO user_notifications (user_id, notification_id) VALUES ?",
            [values],
            (err3, insertResult) => {
              if (err3)
                return res.status(500).json({
                  message: "Failed to deliver notifications",
                  err3,
                });

              res.json({
                message: "Notification sent",
                notification_id: notificationId,
                delivered: insertResult.affectedRows,
              });
            }
          );
        }
      );
    }
  );
});



// =================================================
// USER: FETCH NOTIFICATIONS
// =================================================
app.get("/api/notifications/:userId", (req, res) => {
  const { userId } = req.params;

  db.query(
    "SELECT notifications_enabled FROM users WHERE user_id = ?",
    [userId],
    (err0, users) => {
      if (err0) return res.status(500).json({ message: "DB error", err0 });
      if (!users.length)
        return res.status(404).json({ message: "User not found" });

      if (users[0].notifications_enabled === 0) return res.json([]);

      const query = `
        SELECT
          un.id,
          un.is_read,
          n.notification_id,
          n.title,
          n.message,
          n.icon,
          n.icon_color,
          n.created_at
        FROM user_notifications un
        JOIN notifications n
          ON n.notification_id = un.notification_id
        WHERE un.user_id = ?
        ORDER BY n.created_at DESC
      `;

      db.query(query, [userId], (err, rows) => {
        if (err) return res.status(500).json({ message: "DB error", err });
        res.json(rows);
      });
    }
  );
});

// =================================================
// ADMIN — VIEW ALL FEEDBACK
// =================================================
app.get("/api/admin/feedback", (req, res) => {
  const query = `
    SELECT
      f.feedback_id,
      f.type,
      f.rating,
      f.message,
      f.is_reviewed,
      f.created_at,
      u.user_id,
      u.name,
      u.email
    FROM feedback f
    JOIN users u ON u.user_id = f.user_id
    ORDER BY f.created_at DESC
  `;

  db.query(query, (err, rows) => {
    if (err) {
      return res.status(500).json({ message: "DB error", err });
    }

    res.json(rows);
  });
});

// =================================================
// ADMIN — MARK FEEDBACK AS REVIEWED
// =================================================
app.put("/api/admin/feedback/:feedbackId/reviewed", (req, res) => {
  const { feedbackId } = req.params;

  db.query(
    "UPDATE feedback SET is_reviewed = 1 WHERE feedback_id = ?",
    [feedbackId],
    (err, result) => {
      if (err)
        return res.status(500).json({ message: "DB error", err });

      if (!result.affectedRows)
        return res.status(404).json({ message: "Feedback not found" });

      res.json({ message: "Feedback marked as reviewed" });
    }
  );
});


// =================================================
// USER: MARK NOTIFICATION AS READ (BY PAIR)
// =================================================
app.put("/api/notifications/:userId/:userNotificationId/read", (req, res) => {
  const { userId, userNotificationId } = req.params;

  db.query(
    "UPDATE user_notifications SET is_read = 1 WHERE id = ? AND user_id = ?",
    [userNotificationId, userId],
    (err, result) => {
      if (err) return res.status(500).json({ message: "Update failed", err });
      if (!result.affectedRows)
        return res.status(404).json({ message: "Notification not found" });

      res.json({ message: "Marked as read" });
    }
  );
});

// =================================================
// USER: MARK NOTIFICATION AS READ (BY ID ONLY)
// =================================================
app.put("/api/notifications/:userNotificationId/read", (req, res) => {
  const { userNotificationId } = req.params;

  db.query(
    "UPDATE user_notifications SET is_read = 1 WHERE id = ?",
    [userNotificationId],
    (err, result) => {
      if (err)
        return res
          .status(500)
          .json({ message: "Failed to mark as read", err });

      if (!result.affectedRows)
        return res.status(404).json({ message: "Notification not found" });

      res.json({ message: "Notification marked as read" });
    }
  );
});

// =================================================
// USER: FEEDBACK
// =================================================
app.post("/api/feedback", (req, res) => {
  const { user_id, type, rating, message } = req.body;

  if (!user_id || !message) {
    return res.status(400).json({ message: "Missing required fields" });
  }

  db.query(
    `INSERT INTO feedback (user_id, type, rating, message)
     VALUES (?, ?, ?, ?)`,
    [user_id, type || "chatbot", rating || null, message],
    (err) => {
      if (err) {
        return res.status(500).json({ message: "DB error", err });
      }

      res.json({ message: "Feedback submitted successfully" });
    }
  );
});



// =================================================
// USER — GET ACTIVE GARAGES
// =================================================
app.get("/api/garages", (req, res) => {
  db.query(
    "SELECT garage_id, name, address, phone, maps_url, is_active FROM garages",
    (err, rows) => {
      if (err) {
        return res.status(500).json({ message: "DB error", err });
      }
      res.json(rows);
    }
  );
});

// =================================================
// ADMIN — GARAGES CRUD
// =================================================

// Get all garages
app.get("/api/admin/garages", (req, res) => {
  db.query(
    "SELECT * FROM garages ORDER BY garage_id DESC",
    (err, rows) => {
      if (err) return res.status(500).json({ message: "DB error", err });
      res.json(rows);
    }
  );
});


// Add new garage
app.post("/api/admin/garages", (req, res) => {
  const { name, address, phone, maps_url } = req.body;

  if (!name || !address) {
    return res.status(400).json({ message: "name and address are required" });
  }

  db.query(
    "INSERT INTO garages (name, address, phone, maps_url, is_active) VALUES (?, ?, ?, ?, 1)",
    [name, address, phone || null, maps_url || null],
    (err, result) => {
      if (err) return res.status(500).json({ message: "DB error", err });
      res.json({ message: "Garage added", garage_id: result.insertId });
    }
  );
});

// Update garage
app.put("/api/admin/garages/:id", (req, res) => {
  const { name, address, phone, maps_url, is_active } = req.body;

  db.query(
    "UPDATE garages SET name=?, address=?, phone=?, maps_url=?, is_active=? WHERE garage_id=?",
    [name, address, phone || null, maps_url || null, is_active ? 1 : 0, req.params.id],
    (err, result) => {
      if (err) return res.status(500).json({ message: "DB error", err });
      if (!result.affectedRows) return res.status(404).json({ message: "Garage not found" });
      res.json({ message: "Garage updated" });
    }
  );
});

// Toggle active (enable/disable)
app.put("/api/admin/garages/:id/toggle", (req, res) => {
  db.query(
    "UPDATE garages SET is_active = IF(is_active=1,0,1) WHERE garage_id=?",
    [req.params.id],
    (err, result) => {
      if (err) return res.status(500).json({ message: "DB error", err });
      if (!result.affectedRows) return res.status(404).json({ message: "Garage not found" });
      res.json({ message: "Garage status toggled" });
    }
  );
});

// =================================================
// ADMIN — REPORTS SUMMARY
// =================================================
app.get("/api/admin/reports", async (req, res) => {
  try {
    const [[users]] = await db.promise().query(
      "SELECT COUNT(*) AS total FROM users"
    );

    const [severity] = await db.promise().query(
      "SELECT severity, COUNT(*) AS count FROM history GROUP BY severity"
    );

    const [[feedbackReviewed]] = await db.promise().query(
      "SELECT COUNT(*) AS count FROM feedback WHERE is_reviewed = 1"
    );

    const [[feedbackPending]] = await db.promise().query(
      "SELECT COUNT(*) AS count FROM feedback WHERE is_reviewed = 0"
    );

    const [[activeGarages]] = await db.promise().query(
      "SELECT COUNT(*) AS count FROM garages WHERE is_active = 1"
    );

    const [[disabledGarages]] = await db.promise().query(
      "SELECT COUNT(*) AS count FROM garages WHERE is_active = 0"
    );

    res.json({
      users: users.total,
      severity,
      feedback: {
        reviewed: feedbackReviewed.count,
        pending: feedbackPending.count,
      },
      garages: {
        active: activeGarages.count,
        disabled: disabledGarages.count,
      },
    });
  } catch (err) {
    res.status(500).json({ message: "Report error", err });
  }
});


// =================================================
// ADMIN — GET APP SETTINGS
// =================================================
app.get("/api/admin/app-settings", async (req, res) => {
  try {
    const [[settings]] = await db.promise().query(
      `SELECT
         chatbot_enabled,
         notifications_enabled,
         maintenance_mode,
         max_chatbot_length,
         max_history_entries
       FROM app_settings
       WHERE id = 1`
    );

    if (!settings) {
      return res.status(404).json({ message: "Settings not found" });
    }

    res.json({
      chatbot_enabled: settings.chatbot_enabled === 1,
      notifications_enabled: settings.notifications_enabled === 1,
      maintenance_mode: settings.maintenance_mode === 1,
      max_chatbot_length: settings.max_chatbot_length,
      max_history_entries: settings.max_history_entries,
    });
  } catch (err) {
    res.status(500).json({ message: "Failed to load settings", err });
  }
});



// =================================================
// ADMIN — UPDATE APP SETTINGS
// =================================================
app.put("/api/admin/app-settings", (req, res) => {
  const {
    chatbot_enabled,
    notifications_enabled,
    maintenance_mode,
    max_chatbot_length,
    max_history_entries,
  } = req.body;

  db.query(
    `UPDATE app_settings
     SET chatbot_enabled=?,
         notifications_enabled=?,
         maintenance_mode=?,
         max_chatbot_length=?,
         max_history_entries=?
     WHERE id=1`,
    [
      chatbot_enabled ? 1 : 0,
      notifications_enabled ? 1 : 0,
      maintenance_mode ? 1 : 0,
      max_chatbot_length,
      max_history_entries,
    ],
    (err) => {
      if (err) return res.status(500).json({ message: "DB error", err });
      res.json({ message: "Settings updated" });
    }
  );
});


// =================================================
// AI DIAGNOSIS (OpenRouter + DeepSeek) + service inquiries
// =================================================
app.post("/api/diagnose", async (req, res) => {
  const { user_id, message } = req.body;

  if (!user_id || !message) {
    return res.status(400).json({ error: "user_id and message are required" });
  }

  // Block messages that are only numbers
  if (/^\s*\d+\s*$/.test(message)) {
    return res.status(400).json({
      error: "Please describe your issue using words (not numbers only).",
    });
  }

  // GLOBAL CHATBOT SETTINGS CHECK
  const [[appSettings]] = await db.promise().query(
    "SELECT chatbot_enabled, max_chatbot_length FROM app_settings WHERE id=1"
  );

  // Block chatbot completely if disabled by admin
  if (appSettings.chatbot_enabled !== 1) {
    return res.status(403).json({
      error: "Chatbot is currently disabled by the administrator.",
    });
  }



 async function sendChatbotFeedbackIfFirstUse(userId) {
   const [rows] = await db
     .promise()
     .query(
       "SELECT chatbot_used, notifications_enabled FROM users WHERE user_id=?",
       [userId]
     );

   if (!rows.length) return;

   const user = rows[0];


   if (user.notifications_enabled !== 1) return;
   if ((user.chatbot_used ?? 0) !== 0) return;

   const [notifResult] = await db.promise().query(
     "INSERT INTO notifications (title, message, icon, icon_color) VALUES (?, ?, ?, ?)",
     [
       "We’d Love Your Feedback",
       "You just used AutoSage’s diagnostic assistant. Share your feedback on its accuracy in our Help & Support page.",
       "chat",
       "purple",
     ]
   );

   await db.promise().query(
     "INSERT INTO user_notifications (user_id, notification_id) VALUES (?, ?)",
     [userId, notifResult.insertId]
   );

   await db.promise().query(
     "UPDATE users SET chatbot_used=1 WHERE user_id=?",
     [userId]
   );

   console.log(" Chatbot feedback sent for user:", userId);
 }



  try {
    const response = await fetch("https://openrouter.ai/api/v1/chat/completions", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${process.env.OPENROUTER_API_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "deepseek/deepseek-chat",
        messages: [
          {
            role: "system",
            content: `
You are AutoSage, an automotive assistant.

You can handle TWO categories:
1) Diagnostic help: identify the most likely mechanical issue from symptoms.
2) Service inquiries: answer questions about automotive services (maintenance, inspections, common repairs, parts, costs in general terms, what to ask a garage, safety advice).

Return ONLY valid JSON in this format:
{
  "description": "Short answer (diagnosis or service response)",
  "severity": "Low | Medium | High",
  "status": "Pending"
}

Rules:
- Do NOT repeat the user's text.
- Keep description under 200 words.
- If it's a service inquiry (not a fault diagnosis), set severity to "Low" unless safety risk is clearly present.
- If the user describes a dangerous situation (e.g., brake failure), set severity to "High".
`,
          },
          { role: "user", content: message },
        ],
      }),
    });

    const data = await response.json();

    if (!response.ok) {
      return res.status(500).json({
        error: "AI request failed",
        details: data?.error || data,
      });
    }

    let aiText = data.choices?.[0]?.message?.content;
    if (!aiText) return res.status(500).json({ error: "Empty AI response" });

    aiText = aiText.replace(/```json|```/g, "").trim();

    let diagnosis;
    try {
      diagnosis = JSON.parse(aiText);
    } catch {
      return res.status(500).json({ error: "AI returned invalid JSON", raw: aiText });
    }

    const { description, severity, status } = diagnosis;

    // ENFORCE MAX CHATBOT RESPONSE LENGTH
    let finalDescription = description;

    if (
      appSettings.max_chatbot_length &&
      description.length > appSettings.max_chatbot_length
    ) {
      finalDescription = description.substring(
        0,
        appSettings.max_chatbot_length
      );
    }




    db.query(
      "INSERT INTO history (user_id, description, severity, status) VALUES (?, ?, ?, ?)",
      [user_id, finalDescription, severity, status],
      async (err2, result) => {
        if (err2) {
          return res.status(500).json({ error: "Database insert failed", details: err2 });
        }


        try {
          await sendChatbotFeedbackIfFirstUse(user_id);
        } catch (e) {
          console.error("Feedback notification error:", e);
        }

        res.json({
          diagnosis: {
            history_id: result.insertId,
            description,
            severity,
            status,
          },
        });
      }
    );

  } catch (e) {
    res.status(500).json({ error: "AI processing failed", details: e?.message });
  }
});

// =================================================
// START SERVER
// =================================================
const PORT = process.env.PORT || 3000;

app.listen(PORT, () =>
  console.log(`🚀 Server running on port ${PORT}`)
);
