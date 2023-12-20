FROM node:20-alpine

WORKDIR /app

COPY . .

RUN npm ci

ENV PORT=3000

EXPOSE 3000

CMD ["npm", "run", "start"]