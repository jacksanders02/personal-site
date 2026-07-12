FROM node:22-alpine AS build
WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build the Astro site
RUN npm run build

# Production stage
FROM nginx:alpine AS runtime

# Copy built files from builder
COPY --from=build /app/dist /usr/share/nginx/html