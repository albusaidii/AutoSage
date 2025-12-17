require("dotenv").config();

// ---------------------
// Imports
// ---------------------
const express = require("express");
const cors = require("cors");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

// OpenRouter / OpenAI-compatible fetch
const fetch = (...args) =>
  import("node-fetch").then(({ default: fetch }) => fetch(...args));

// ---------------------
// App setup
// ---------------------
const app = express();
app.use(cors());
app.use(express.json());

// ---------------------
// MySQL connection
// ---------------------
const db = require("./db");

db.connect((err) => {
  if (err) {
    console.error("MySQL connection error:", err);
  } else {
    console.log("MySQL Connected...");
  }
});

// ---------------------
// ENV check (important)
// ---------------------
if (!process.env.OPENROUTER_API_KEY) {
  console.warn("OPENROUTER_API_KEY is not set in .env file");
}

// =================================================
// AUTHENTICATION ROUTES
// =================================================

// ---------------------
// Signup
// ---------------------
app.post("/api/signup", async (req, res) => {
  const { name, email, password, phone } = req.body;

  if (!name || !email || !password) {
    return res
      .status(400)
      .json({ message: "Name, email, and password are required" });
  }

  try {
    const hashedPassword = await bcrypt.hash(password, 10);

    const query = `
      INSERT INTO users (name, email, password_hash, phone)
      VALUES (?, ?, ?, ?)
    `;

    db.query(
      query,
      [name, email, hashedPassword, phone || null],
      (err, result) => {
        if (err) {
          if (err.code === "ER_DUP_ENTRY") {
            return res.status(409).json({ message: "Email already exists" });
          }
          return res
            .status(500)
            .json({ message: "Database error", error: err });
        }

        res.status(201).json({
          message: "User registered successfully",
          userId: result.insertId,
        });
      }
    );
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
});

// ---------------------
// Login
// ---------------------
app.post("/api/login", (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res
      .status(400)
      .json({ message: "Email and password are required" });
  }

  const query = "SELECT * FROM users WHERE email = ?";

  db.query(query, [email], async (err, results) => {
    if (err)
      return res.status(500).json({ message: "Database error", error: err });

    if (results.length === 0)
      return res.status(404).json({ message: "User not found" });

    const user = results[0];
    const match = await bcrypt.compare(password, user.password_hash);

    if (!match)
      return res.status(401).json({ message: "Incorrect password" });

    const token = jwt.sign(
      { id: user.user_id, email: user.email },
      process.env.JWT_SECRET || "autosage_secret",
      { expiresIn: "1h" }
    );

    res.json({ message: "Login successful", token });
  });
});

// =================================================
// HISTORY ROUTES
// =================================================

// ---------------------
// Get history by user
// ---------------------
app.get("/api/history/:userId", (req, res) => {
  const userId = req.params.userId;

  const query = `
    SELECT history_id, user_id, description, severity, status, created_at
    FROM history
    WHERE user_id = ?
    ORDER BY created_at DESC
  `;

  db.query(query, [userId], (err, results) => {
    if (err) {
      return res.status(500).json({ message: "Database error", error: err });
    }
    res.json(results);
  });
});

// =================================================
// AI DIAGNOSIS (OpenRouter + DeepSeek)
// =================================================
app.post("/api/diagnose", async (req, res) => {
  const { user_id, message } = req.body;

  if (!user_id || !message) {
    return res.status(400).json({
      error: "user_id and message are required",
    });
  }

  try {
    const response = await fetch(
      "https://openrouter.ai/api/v1/chat/completions",
      {
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
              content:
                "You are an automotive diagnostic assistant. Respond ONLY in valid JSON with keys: description, severity (Low, Medium, High), status (Pending).",
            },
            {
              role: "user",
              content: message,
            },
          ],
        }),
      }
    );

    const data = await response.json();

    if (!data.choices || !data.choices[0]) {
      return res.status(500).json({
        error: "Invalid AI response",
        raw: data,
      });
    }

    let aiText = data.choices[0].message.content;

    // --- CLEAN MARKDOWN CODE BLOCKS ---
    aiText = aiText
      .replace(/```json/g, "")
      .replace(/```/g, "")
      .trim();

    let diagnosis;
    try {
      diagnosis = JSON.parse(aiText);
    } catch (err) {
      return res.status(500).json({
        error: "AI returned invalid JSON after cleanup",
        raw: aiText
      });
    }


    const { description, severity, status } = diagnosis;

    const insertQuery = `
      INSERT INTO history (user_id, description, severity, status)
      VALUES (?, ?, ?, ?)
    `;

    db.query(
      insertQuery,
      [user_id, description, severity, status],
      (err, result) => {
        if (err) {
          return res.status(500).json({
            error: "Database insert failed",
            details: err,
          });
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
  } catch (error) {
    res.status(500).json({
      error: "AI processing failed",
      details: error.message,
    });
  }
});

// =================================================
// START SERVER
// =================================================
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(` Server running on port ${PORT}`);
});
