# 2. Automated Testing with Jest

## Why Test?

- Catch bugs before deployment
- CI/CD runs tests automatically
- Confidence when making changes

## Tools Used

| Tool | Purpose |
|------|---------|
| **Jest** | Test runner |
| **Supertest** | HTTP request testing |

## Test Structure

```javascript
const request = require('supertest');
const app = require('./server');

describe('GET /', () => {
    it('should return 200 OK', async () => {
        const res = await request(app).get('/');
        expect(res.statusCode).toEqual(200);
        expect(res.body.status).toBe('success');
    });
});
```

| Part | Meaning |
|------|---------|
| `describe()` | Group related tests |
| `it()` | Single test case |
| `expect()` | Check if value is correct |
| `request(app).get('/')` | Send fake HTTP request |

## Common Assertions

```javascript
expect(value).toBe(exact);           // Exact match
expect(value).toEqual(deepEquals);   // Deep equality
expect(obj).toHaveProperty('key');   // Property exists
expect(value).toBeTruthy();          // Is truthy
```

## Running Tests

```bash
npm test
```
