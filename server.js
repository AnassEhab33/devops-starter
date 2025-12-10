const express = require('express');
const app = express();
const port = 3000;

// Define a route that returns JSON
app.get('/', (req, res) => {
    // .json() automatically sets the Content-Type header to application/json
    res.json({
        status: 'success',
        message: 'Hello! This is a JSON response.',
        timestamp: new Date()
    });
});

// Start the server only if this file is run directly
if (require.main === module) {
    app.listen(port, () => {
        console.log(`Server is running at http://localhost:${port}`);
    });
}

module.exports = app;