# Stage 1: Build
FROM node:18-alpine as builder

WORKDIR /app

COPY package*.json ./

# Install dependencies
RUN npm install

COPY . .

RUN npm run build

# Stage 2: Serve
FROM node:18-slim

WORKDIR /app

# Copy only necessary files from the builder stage
COPY --from=builder /app/build ./build

RUN npm install -g serve

# Command to run application
CMD ["serve", "-s", "build"]

# Expose the port that the app will run on
EXPOSE 3000
