# 6. Cloud Deployment (Render)

## Render = Free Cloud Hosting

Deploy your Docker image to the internet!

## Important Code Change

Use environment variable for PORT:

```javascript
const port = process.env.PORT || 3000;
```

Why? Cloud platforms set their own PORT!

## Deploy Steps

1. Create account at [render.com](https://render.com)
2. New → Web Service
3. "Deploy existing image from registry"
4. Enter: `docker.io/YOUR_USERNAME/devops-starter:latest`
5. Select Free tier
6. Create Web Service

## Result

Your app is live at: `https://your-app-name.onrender.com`

## Notes

- Free tier may sleep after inactivity
- Manual redeploy: Dashboard → Manual Deploy
- Environment variables: Settings → Environment
