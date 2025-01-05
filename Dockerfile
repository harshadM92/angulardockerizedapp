# Step 1: Build the Angular app using Node.js 20 image
FROM node:20 AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install the dependencies
RUN npm install

# Copy the rest of the Angular application files
COPY . .

# Build the Angular app for production
RUN npm run build --prod

# Step 2: Serve the app using a lightweight web server (nginx)
FROM nginx:alpine

# Copy the Angular app build output to nginx's public directory
COPY --from=build /app/dist/home-management/browser /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 to access the app
EXPOSE 80

# Start nginx to serve the Angular app
CMD ["nginx", "-g", "daemon off;"]