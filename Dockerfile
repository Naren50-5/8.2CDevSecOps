# Use Node 18 LTS
FROM node:18.13.0

# Set working directory
WORKDIR /usr/src/goof

# Copy package.json and package-lock.json first to leverage Docker cache
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy the rest of the project files
COPY . .

# Create temporary directory if needed
RUN mkdir -p /tmp/extracted_files

# Expose ports
EXPOSE 3001 9229

# Start the app
ENTRYPOINT ["npm", "start"]