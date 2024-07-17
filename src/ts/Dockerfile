FROM node:20-alpine

WORKDIR /app

COPY . .

RUN npm install

RUN npm install --global typescript

RUN tsc

ENV PORT=3000

EXPOSE 3000

CMD ["npm", "run", "start"]