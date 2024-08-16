# Use a multi-stage build to reduce final image size
# Stage 1: Build Stage
FROM node:16 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install project dependencies for production
RUN npm install --production

# Copy the rest of the application code to the container
COPY . .

# Build the React app
RUN npm run build


# Stage 2: Production Stage
FROM node:16-slim

# Set the working directory in the container
WORKDIR /app

# Copy the build files from the builder stage
COPY --from=builder /app/build ./build

# Install only production dependencies
COPY package*.json ./
RUN npm install --production

# Expose port 3000 for the React app
EXPOSE 3000

# Start the React app
CMD ["npm", "start"]

