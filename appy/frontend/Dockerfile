FROM node:22.9.0-alpine
WORKDIR /app
COPY package*.json ./
RUN --mount=type=cache,target="/root/.npm" \
    npm install
COPY . .
EXPOSE 8080
CMD ["node", "server.js"]
