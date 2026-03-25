const express = require('express');
const { Pool } = require('pg');   // NEW: PostgreSQL client

const app = express();
const port = process.env.PORT || 3000;

// NEW: Database connection (only connect if DATABASE_URL is set)
const pool = process.env.DATABASE_URL
    ? new Pool({ connectionString: process.env.DATABASE_URL })
    : null;


// Define a route that returns JSON
app.get('/', (req, res) => {
    // .json() automatically sets the Content-Type header to application/json
    res.json({
        status: 'success',
        message: 'Hello! This is Anass El gamed response',
        timestamp: new Date()
    });
});

// NEW: Database health check route
app.get('/db', async (req, res) => {
    if (!pool) {
        return res.status(500).json({
            status: 'error',
            message: 'DATABASE_URL not configured'
        });
    }
    try {
        const result = await pool.query('SELECT NOW()');
        res.json({
            status: 'success',
            database: 'connected',
            time: result.rows[0].now
        });
    } catch (err) {
        res.status(500).json({
            status: 'error',
            message: err.message
        });
    }
});

// Start the server only if this file is run directly
if (require.main === module) {
    app.listen(port, () => {
        console.log(`Server is running at http://localhost:${port}`);
    });
}

module.exports = { app, pool };