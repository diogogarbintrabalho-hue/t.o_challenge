const http = require('http');

const PORT = 4000;

const server = http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'text/plain; charset=utf-8' });
    res.end('Aplicação Node.js rodando na EC2 - Resposta em texto simples.\n');
});

server.listen(PORT, '127.0.0.1', () => {
    console.log(`Servidor Node.js rodando em http://127.0.0.1:${PORT}`);
});
