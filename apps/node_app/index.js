const http = require('http');

const PORT = 4000;

let alternar = false;

const server = http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'text/plain; charset=utf-8' });
    
    // Alterna o estado a cada requisição que CHEGA ao Node.js
    alternar = !alternar;
    
    const textoA = "Texto 1: Primeira versão da mensagem em texto simples.";
    const textoB = "Texto 2: Segunda versão da mensagem após a expiração do cache!";
    
    const mensagemExibida = alternar ? textoA : textoB;
    
    res.end(`${mensagemExibida}\n`);
});

server.listen(PORT, '127.0.0.1', () => {
    console.log(`Servidor Node.js rodando em http://127.0.0.1:${PORT}`);
});
