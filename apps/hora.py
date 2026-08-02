from flask import Flask, render_template_string
from datetime import datetime
from zoneinfo import ZoneInfo

app = Flask(__name__)

HTML_TEMPLATE = """
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Data e Horário do Servidor (Cached)</title>
    <style>
        body { font-family: sans-serif; background-color: #0f172a; color: #f8fafc; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .card { background-color: #1e293b; padding: 2.5rem; border-radius: 16px; text-align: center; border: 1px solid #334155; }
        h1 { color: #38bdf8; }
        .time { font-size: 3rem; font-weight: bold; color: #f43f5e; font-family: monospace; }
        .note { color: #94a3b8; margin-top: 15px; font-size: 0.9rem; }
    </style>
</head>
<body>
    <div class="card">
        <h1>🖥️ Servidor Python + Nginx Cache</h1>
        <div class="time">{{ hora }}</div>
        <p>Data: {{ data }} (GMT-3)</p>
        <div class="note">⚡ Cache configurado no Nginx para 1 minuto (60 segundos).</div>
    </div>
</body>
</html>
"""

@app.route('/')
def home():
    fuso_br = ZoneInfo("America/Sao_Paulo")
    agora = datetime.now(fuso_br)
    
    return render_template_string(
        HTML_TEMPLATE,
        data=agora.strftime('%d/%m/%Y'),
        hora=agora.strftime('%H:%M:%S')
    )

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000)
