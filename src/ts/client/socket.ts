import { io, Socket } from "socket.io-client";

$(function () {
    const client = new ListenerClient();
});

class ListenerClient{
    private socket: Socket = io();
    constructor() {
        this.socket.on('connect', this.handleConnect);
        $('#runAgainButton').on('click', this.handleClick);
    }
    handleConnect() {
        console.log('Connected!');
        $('#console').html('&#x200B;'); // Zero-width space
    
        this.socket.on('new_message', function(message) {
            console.dir(message);
            $('#console').append(`${message}\n`);
        });

        this.socket.emit('start', {});
    };
    handleClick() {
        $('#console').html('&#x200B;'); // Zero-width space
        this.socket.emit('start', {});
    }
}