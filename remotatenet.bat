<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Painel Wi-Fi Penedos (Sem Token)</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f5f7fb; margin: 0; padding: 20px; color: #333; }
        .container { max-width: 600px; margin: 0 auto; }
        h1 { text-align: center; color: #1a2a3a; font-size: 1.6rem; margin-bottom: 25px; }
        .card { background: white; border-radius: 12px; padding: 20px; margin-bottom: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); border: 1px solid #eef2f5; }
        .network-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #f5f7fb; padding-bottom: 12px; margin-bottom: 15px; }
        .network-title { margin: 0; font-size: 1.2rem; color: #2c3e50; }
        .pass-badge { background-color: #f1f3f5; padding: 4px 8px; border-radius: 4px; font-family: monospace; font-size: 0.9rem; color: #495057; }
        .device-row { display: flex; justify-content: space-between; align-items: center; padding: 10px 0; border-bottom: 1px solid #fafafa; }
        .device-row:last-child { border: none; }
        .device-info { font-size: 0.95rem; font-weight: 500; }
        .device-ip { font-size: 0.8rem; color: #888; }
        
        /* Interruptor de Bloqueio (Switch) */
        .switch { position: relative; display: inline-block; width: 46px; height: 24px; }
        .switch input { opacity: 0; width: 0; height: 0; }
        .slider { position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background-color: #e74c3c; transition: .3s; border-radius: 24px; }
        .slider:before { position: absolute; content: ""; height: 16px; width: 16px; left: 4px; bottom: 4px; background-color: white; transition: .3s; border-radius: 50%; }
        input:checked + .slider { background-color: #2ecc71; }
        input:checked + .slider:before { transform: translateX(22px); }
        
        .status-text { font-size: 0.75rem; font-weight: bold; margin-right: 8px; }
    </style>
</head>
<body>

<div class="container">
    <h1>Gestão de Acesso Wi-Fi - Penedos</h1>

    <!-- REDE 1: NET DECO-PENEDOS -->
    <div class="card">
        <div class="network-header">
            <h2 class="network-title">📶 NET DECO-PENEDOS</h2>
            <span class="pass-badge">Pass: 98765432</span>
        </div>
        
        <div class="device-row">
            <div>
                <div class="device-info">Consola de Jogos</div>
                <div class="device-ip">IP: 192.168.1.50</div>
            </div>
            <div style="display: flex; align-items: center;">
                <span id="txt-deco-consola" class="status-text" style="color: #2ecc71;">INTERNET ON</span>
                <label class="switch">
                    <input type="checkbox" id="switch-deco-consola" checked>
                    <span class="slider"></span>
                </label>
            </div>
        </div>

        <div class="device-row">
            <div>
                <div class="device-info">Smart TV Quarto</div>
                <div class="device-ip">IP: 192.168.1.51</div>
            </div>
            <div style="display: flex; align-items: center;">
                <span id="txt-deco-tv" class="status-text" style="color: #2ecc71;">INTERNET ON</span>
                <label class="switch">
                    <input type="checkbox" id="switch-deco-tv" checked>
                    <span class="slider"></span>
                </label>
            </div>
        </div>
    </div>

    <!-- REDE 2: NET M-PENEDOS -->
    <div class="card">
        <div class="network-header">
            <h2 class="network-title">📶 NET M-PENEDOS</h2>
            <span class="pass-badge">Pass: 98765432</span>
        </div>
        
        <div class="device-row">
            <div>
                <div class="device-info">Telemóvel Alvo</div>
                <div class="device-ip">IP: 192.168.1.80</div>
            </div>
            <div style="display: flex; align-items: center;">
                <span id="txt-m-tlm" class="status-text" style="color: #2ecc71;">INTERNET ON</span>
                <label class="switch">
                    <input type="checkbox" id="switch-m-tlm" checked>
                    <span class="slider"></span>
                </label>
            </div>
        </div>
    </div>
</div>

<script>
    // Configuração base do Router fornecida (192.168.1.88)
    const ROUTER_IP = "192.168.1.88";

    // Função que dispara o pedido HTTP real sem precisar de cabeçalho de Token
    async function enviarComandoWebhook(idWebhook, acao, idTextoStatus) {
        const textoStatus = document.getElementById(idTextoStatus);
        
        if (acao === "ligar") {
            textoStatus.innerText = "INTERNET ON";
            textoStatus.style.color = "#2ecc71";
        } else {
            textoStatus.innerText = "BLOQUEADO";
            textoStatus.style.color = "#e74c3c";
        }

        try {
            // O pedido via Webhook é feito via POST direto para o endpoint público do servidor
            await fetch(`http://${ROUTER_IP}:8123/api/webhook/${idWebhook}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ status: acao })
            });
        } catch (erro) {
            console.error("Erro ao comunicar via Webhook:", erro);
        }
    }

    // Ouvintes dos botões: cada um aponta para o ID de Webhook correspondente que criar na automação
    document.getElementById('switch-deco-consola').addEventListener('change', function() {
        const acao = this.checked ? "ligar" : "desligar";
        enviarComandoWebhook('webhook_consola_penedos', acao, 'txt-deco-consola');
    });

    document.getElementById('switch-deco-tv').addEventListener('change', function() {
        const acao = this.checked ? "ligar" : "desligar";
        enviarComandoWebhook('webhook_tv_penedos', acao, 'txt-deco-tv');
    });

    document.getElementById('switch-m-tlm').addEventListener('change', function() {
        const acao = this.checked ? "ligar" : "desligar";
        enviarComandoWebhook('webhook_telemovel_penedos', acao, 'txt-m-tlm');
    });
</script>

</body>
</html>
