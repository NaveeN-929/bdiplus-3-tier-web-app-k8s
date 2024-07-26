# Stage 1: Build
FROM node:18-alpine as builder

WORKDIR /app

COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci --production

COPY . .

# Stage 2: Create a smaller image
FROM node:18-slim

WORKDIR /app

# Copy only necessary files from the builder stage
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/app.js ./

# Expose the port that the app will run on
EXPOSE 8080

# Command to run application
CMD ["node", "app.js"]
