const mysql = require("mysql2");

const db = mysql.createConnection({
    host: process.env.DB_HOST || "localhost",
    user: process.env.DB_USER || "root",
    password: process.env.DB_PASSWORD || "albusa3idii.1",
    database: process.env.DB_NAME || "autosage_db",
    port: process.env.DB_PORT || 3306
});

db.connect(err => {
    if (err) console.log("MySQL connection error:", err);
    else console.log("MySQL Connected...");
});

module.exports = db;
