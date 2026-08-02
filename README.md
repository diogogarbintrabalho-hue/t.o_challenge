# Desafio

O objetivo desse repositório é armazenar os aquivos de provisionamento de infraestrutura como código (IaC) e de desenvilvimento de duas aplicações web simples.

Tarefas
 1. Criar duas aplicações
   1.1	Utilize linguagens diferentes.
   1.2 Cada aplicação deve ter duas rotas: Uma retornando um texto fixo. Outra retornando o horário atual do servidor.

__Foram criadas duas aplicações:__  

### Primeira 
**Código fonte** https://github.com/diogogarbintrabalho-hue/t.o_challenge/blob/main/apps/hora.py  

  Escrita em Python - retorna a data e horário do servidor  
  
**Link de acesso** (http://32.197.62.244/)  
<img width="1804" height="843" alt="image" src="https://github.com/user-attachments/assets/3e31cd12-aac4-4f60-9a6c-7bc83211350f" />  




### Segunda 
**Código fonte** https://github.com/diogogarbintrabalho-hue/t.o_challenge/tree/main/apps/node_app 

  Escrita em Nodejs - retorna um texto simples  
  
**Link de acesso** (http://32.197.62.244/node)  
<img width="667" height="151" alt="image" src="https://github.com/user-attachments/assets/b9da36a4-a094-4d52-81d4-fa80401c83aa" />  
<img width="645" height="128" alt="image" src="https://github.com/user-attachments/assets/2d537f11-0cce-4e01-bf0b-e1746937afe7" />  




 
 2.	Adicionar uma camada de cache, as respostas das aplicações devem ser cacheadas por diferentes tempos de expiração.  
   2.1	A primeira aplicação deve ter um cache de 10 segundos.  
   	
**Nota-se ao acessar a aplição que são apresentadas duas mensagens distintas, ronovando-se consecutivamente a cada 10 segundos. Isso identifica o funcionamento da camada de cache. Segue a configuração:**

```
 - name: Configurar Nginx com Caches das Aplicações
      copy:
        dest: /etc/nginx/sites-available/default
        content: |
          proxy_cache_path /var/cache/nginx/python levels=1:2 keys_zone=PYTHON_CACHE:10m max_size=500m inactive=60m use_temp_path=off;
          proxy_cache_path /var/cache/nginx/node levels=1:2 keys_zone=NODE_CACHE:10m max_size=500m inactive=60m use_temp_path=off;

          server {
              listen 80;
              server_name _;

              # Rota 1: Python (1 minuto)
              location / {
                  proxy_pass http://127.0.0.1:5000;
                  proxy_set_header Host $host;
                  proxy_set_header X-Real-IP $remote_addr;

                  proxy_cache PYTHON_CACHE;
                  proxy_cache_valid 200 1m;
                  add_header X-Cache-Status $upstream_cache_status;
              }

              # Rota 2: Node.js (10 segundos)
              location /node {
                  proxy_pass http://127.0.0.1:4000/;
                  proxy_set_header Host $host;
                  proxy_set_header X-Real-IP $remote_addr;

                  proxy_cache NODE_CACHE;
                  proxy_cache_valid 200 10s;
                  add_header X-Cache-Status $upstream_cache_status;
              }
          }
```

   2.2  A segunda aplicação deve ter um cache de 1 minuto.  
   
__Ao acessar a primeira aplicação é apresentado a data e horário atual do servidor, nota-se que ao atualizar a página, a informação se mantém imutável. Entretanto ao atualizar a página após 1 min o horário é modificado. O que caracteriza a camada de cache. Segue Configuração:__

``` 
 
 - name: Configurar Nginx com Cache de 1m na Aplicação Python
      copy:
        dest: /etc/nginx/sites-available/default
        content: |
          proxy_cache_path /var/cache/nginx/python levels=1:2 keys_zone=PYTHON_CACHE:10m max_size=500m inactive=60m use_temp_path=off;

          server {
              listen 80;
              server_name _;

              location / {
                  proxy_pass http://127.0.0.1:5000;
                  proxy_set_header Host $host;
                  proxy_set_header X-Real-IP $remote_addr;

                  proxy_cache PYTHON_CACHE;
                  proxy_cache_valid 200 1m;
                  add_header X-Cache-Status $upstream_cache_status;
              }
          }
```



 3. Facilitar a execução    
   3.1.	A infraestrutura deve ser fácil de iniciar e rodar com o menor número de comandos possível.    
    __Para este fim utilizei AWS, TerraForm, e Ansible. Através do terraform provisionei uma instância EC2 na AWS e com Ansible realizei a configuração das aplicações e pre requisitos necessários. Todos os arquivos de playbook e .tf do terraform, encontram-se neste repositório.__  

 4. Implementar observabilidade se possível  
    __No mesmo EC2 que foi configurado para hospedar as aplicações, realizei o deploy via Docker do Zabbix e Grafana para servir de observabilidade tanto das aplicações, quanto dos containers e da própria instância.__  
    ZABBIX: http://32.197.62.244/zabbix  
    GRAFANA: http://32.197.62.244:3000/
    
    <img width="2491" height="1079" alt="image" src="https://github.com/user-attachments/assets/ef0528e5-1e49-4012-ab61-a78d0a88cc1f" />

    

 5. Desenhar e analisar a infraestrutura
   5.1 Criar um diagrama representando a arquitetura.
   
 6. Identificar e sugerir pontos de melhoria.
   
 7. Atualizações  
   7.1 No desenho mostre como seriam fluxo de atualização de cada componente da infra e do código.  
   7.2 Identificar e sugerir pontos de melhoria.  


Entrega esperada
•	Código-fonte das aplicações e sua respectiva infra
•	Configuração da camada de cache.
•	Infraestrutura automatizada para fácil execução. 
•	Diagrama da infraestrutura com análise e sugestões de melhoria.
•	Sempre bom manter as boas práticas e organização no Git




