const request = require('supertest');
const app = require('./server'); // Import the app we just exported

describe('GET /', () => {
    it('should return 200 OK and a JSON message', async () => {
        const res = await request(app).get('/');

        // 1. Check the Status Code
        expect(res.statusCode).toEqual(200);

        // 2. Check the JSON body content
        expect(res.body.status).toBe('success');
        expect(res.body.message).toBe('Hello! This is a Seif and hossam and moaz response.');

        // Check that timestamp exists (we can't check exact time)
        expect(res.body).toHaveProperty('timestamp');
    });
});