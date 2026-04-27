FROM node:20-alpine
WORKDIR /usr/src/app
COPY package.json ./
RUN npm install --omit=dev
COPY . .

# 1. Create the directories your app needs manually
# 2. Give 'appuser' ownership of the entire app directory
RUN addgroup -S appgroup && adduser -S appuser -G appgroup && \
    mkdir -p /usr/src/app/public/uploads && \
    chown -R appuser:appgroup /usr/src/app

# 3. Switch to the non-root user for security
USER appuser

EXPOSE 3000
CMD ["npm", "start"]