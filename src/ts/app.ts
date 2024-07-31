import express, { Application, Request, Response } from 'express';
import { createServer } from 'node:https';
import { join } from 'node:path';
import { Server } from 'socket.io';
import favicon from 'serve-favicon';

import { DataClient } from './cosmos'

import 'dotenv/config'

const app: Application = express();
const server = createServer({}, app);
const io = new Server(server);

app.get('/', (_: Request, res: Response) => {
  res.sendFile(join(__dirname, 'static', 'index.html'));
});

app.use(
  favicon(join(__dirname, 'static', 'favicon.ico'))
);

app.use(express.static('static'));

io.on('connection', (socket) => {
  console.log(`Connected: ${socket.id}`);

  socket.on('start', async (_) => {
    console.log('Started');
    await new DataClient().start((message: string) => {
      console.log(message);
      io.emit('new_message', message);
    });
  });
});

io.on('error', (_, error) => {
  console.log(`Error: ${error}`);
});

io.on('disconnect', (_, reason) => {
  console.log(`Disconnected: ${reason}`);
});

const port = process.env.PORT || 3000;
server.listen(port, () => {
  console.log(`Server running: \\:${port}`);
});