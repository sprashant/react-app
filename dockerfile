# Use an official Node.js runtime as a build stage
FROM node:18 AS builder
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy the entire project and build the app
COPY . .
RUN yarn build

# Use Nginx as the production web server
FROM nginx:stable-alpine
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80 and start Nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
