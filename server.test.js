const request = require('supertest');
const { app, pool } = require('./server'); // Import app and pool

describe('GET /', () => {
    it('should return 200 OK and a JSON message', async () => {
        const res = await request(app).get('/');

        // 1. Check the Status Code
        expect(res.statusCode).toEqual(200);

        // 2. Check the JSON body content
        expect(res.body.status).toBe('success');
        expect(res.body.message).toBe('Hello! This is a Anass Einshouka Elgamed response.');

        // Check that timestamp exists (we can't check exact time)
        expect(res.body).toHaveProperty('timestamp');
    });
});

describe('GET /db', () => {
    it('should return 200 OK and a JSON message', async () => {
        const res = await request(app).get('/db');

        // 1. Check the Status Code
        expect(res.statusCode).toEqual(200);

        // 2. Check the JSON body content
        expect(res.body.status).toBe('success');
        expect(res.body.database).toBe('connected');
        // Check that time exists
        expect(res.body).toHaveProperty('time');
    });
});

// Close database connection after all tests
afterAll(async () => {
    if (pool) {
        await pool.end();
    }
});