# Use an official Node.js runtime as the base image
# "alpine" is a very small version of Linux, great for containers


FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
