# 🌊 Despliegue en Digital Ocean

## ⚠️ RECOMENDACIÓN CRÍTICA

**App Platform tiene limitaciones severas con Docker-in-Docker (DinD).**

Este proyecto requiere **PostgreSQL + Redis + n8n + Nginx** = **Docker Compose necesario**.

### 🚀 SOLUCIÓN RECOMENDADA: **Usar Droplet** (no App Platform)

---

## Opción 1: Droplet + Docker Compose (✅ RECOMENDADO - Funciona Perfectamente)

### Ventajas
- ✅ Docker Compose funciona perfectamente
- ✅ Súper fácil de instalar (~10 minutos)
- ✅ Precio bajo ($6/mes)
- ✅ Control total
- ✅ Mejor rendimiento

### Paso 1: Crear el Droplet

1. **Ir a Digital Ocean Console**
   - https://cloud.digitalocean.com/droplets/new

2. **Configuración:**
   - **Region**: New York / San Francisco / Tokio (elige cercano a ti)
   - **OS Image**: Ubuntu 22.04 LTS (en "Distributions")
   - **Plan**: 2GB RAM / $6/mes - PERFECTO para n8n
   - **Authentication**: SSH Key (más seguro que contraseña)
   - **Hostname**: `n8n-server`

3. Click: "Create Droplet"
4. Espera 1-2 minutos
5. Copia la **IP del Droplet** asignada (ej: 123.45.67.89)

### Paso 2: Conectar al Droplet

```bash
# Usa la IP del paso anterior
ssh root@123.45.67.89

# En la primera conexión:
# Are you sure you want to continue connecting (yes/no)? yes
```

---

## Opción 2: Droplet + Docker (Más Control)

### Ventajas
- ✅ Control total
- ✅ Más barato ($5/mes)
- ✅ Customizable
- ✅ Mejor para producción

### Paso 1: Crear Droplet

1. **Ir a Digital Ocean Console**
   - https://cloud.digitalocean.com/droplets/new

2. **Configuración Recomendada**
   - **Region**: New York / San Francisco (cercano a usuarios)
   - **OS**: Ubuntu 22.04 LTS
   - **Plan**: 2GB RAM / $6/mes (o 4GB / $12/mes para producción)
   - **Storage**: 80GB (por defecto)
   - **Authentication**: SSH Key (crear o usar existente)
   - **Hostnames**: n8n
   - **VPC**: Default OK
   - **Monitoring**: Activar

3. **Crear**
   - Click: "Create Droplet"
   - Copiar IP: `aaa.bbb.ccc.ddd`

### Paso 2: Conexión Inicial

```bash
# Conectar vía SSH
ssh root@aaa.bbb.ccc.ddd

# Aceptar fingerprint: yes

# Cambiar contraseña si es necesario
passwd
```

### Paso 3: Instalar Docker

```bash
# Update del sistema
apt-get update
apt-get upgrade -y

# Instalar Docker desde script oficial
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Instalar Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verificar
docker --version
docker-compose --version

# Agregar usuario (opcional)
sudo usermod -aG docker $USER
```

### Paso 4: Preparar Proyecto

```bash
# Clonar repositorio
git clone https://github.com/TU_USUARIO/n8n-docker.git
cd n8n-docker

# Copiar .env
cp .env.example .env

# Editar configuración para producción
nano .env
```

**Actualizar en .env:**
```bash
N8N_HOST=tu-dominio.com            # O IP del Droplet
N8N_PROTOCOL=https                 # HTTPS en producción
WEBHOOK_URL=https://tu-dominio.com
DB_PASSWORD=ContraseñaSegura123!
N8N_PASSWORD=ContraseñaSegura456!
TIMEZONE=America/New_York           # Tu zona horaria
```

### Paso 5: Iniciar Servicios

```bash
# Hacer scripts ejecutables
chmod +x scripts/*.sh

# Iniciar
./scripts/setup.sh

# Verificar
docker-compose ps
```

### Paso 6: Configurar Dominio y DNS

**En Digital Ocean Console:**

1. **Networking → Domains**
   - Click: Add Domain
   - Ingresa: `tu-dominio.com`
   - Selecciona: Droplet que creaste

2. **En tu Registrador de Dominios** (Namecheap, GoDaddy, etc.):
   - Ir a DNS settings
   - Cambiar nameservers a:
     ```
     ns1.digitalocean.com
     ns2.digitalocean.com
     ns3.digitalocean.com
     ```

**Verificar DNS:**
```bash
nslookup tu-dominio.com
# Debe mostrar IP del Droplet
```

### Paso 7: SSL/HTTPS con Let's Encrypt

```bash
# Instalar Certbot
sudo apt-get install -y certbot python3-certbot-nginx

# Obtener certificado
sudo certbot certonly --standalone -d tu-dominio.com -d www.tu-dominio.com

# Copiar a proyecto
mkdir -p nginx/ssl
sudo cp /etc/letsencrypt/live/tu-dominio.com/fullchain.pem nginx/ssl/cert.pem
sudo cp /etc/letsencrypt/live/tu-dominio.com/privkey.pem nginx/ssl/key.pem
sudo chown $USER:$USER nginx/ssl/*

# Editar nginx.conf - descomentar sección HTTPS
nano nginx/nginx.conf
```

En `nginx.conf`, descomentar:
```nginx
server {
    listen 443 ssl http2;
    server_name tu-dominio.com;

    ssl_certificate /etc/nginx/ssl/cert.pem;
    ssl_certificate_key /etc/nginx/ssl/key.pem;
    ...
}
```

```bash
# Reiniciar Nginx
docker-compose restart nginx

# Renovación automática de certificados (cron job)
sudo crontab -e
# Agregar línea:
# 0 3 * * * certbot renew && cp /etc/letsencrypt/live/tu-dominio.com/*.pem /ruta/nginx/ssl/
```

### Paso 8: Firewall

```bash
# Habilitar UFW
sudo ufw enable

# Permitir SSH
sudo ufw allow 22/tcp

# Permitir HTTP
sudo ufw allow 80/tcp

# Permitir HTTPS
sudo ufw allow 443/tcp

# Denegar lo demás
sudo ufw default deny incoming

# Verificar
sudo ufw status
```

---

## Opción 3: Docker Swarm (Escalable)

Para múltiples Droplets con alta disponibilidad:

```bash
# En el Droplet manager
docker swarm init

# En otros Droplets worker
docker swarm join --token SWMTKN-... manager-ip:2377

# Desplegar stack
docker stack deploy -c docker-compose.yml n8n

# Monitorear
docker stack ps n8n
```

---

## Mantenimiento en Producción

### Backups Automáticos

```bash
# Agregar a crontab (cada día a las 2AM)
sudo crontab -e

# Agregar:
0 2 * * * cd /root/n8n-docker && ./scripts/backup.sh

# Guardar en Digital Ocean Spaces (S3-compatible)
# Editar backup.sh para subir a Spaces
```

### Monitoreo

```bash
# Habilitar en Digital Ocean Console
# Verificar: Droplet → Monitoring

# Comandos útiles
docker stats
docker-compose logs -f n8n
du -sh data/*
```

### Actualización de n8n

```bash
# Descargar última versión
docker-compose pull

# Reiniciar (con downtime mínimo)
docker-compose up -d --no-deps --build n8n

# Verificar logs
docker-compose logs -f n8n
```

---

## Costos Estimados

| Componente | Precio/mes | Notas |
|-----------|----------|-------|
| Droplet 2GB | $6-12 | Suficiente para pequeño-mediano |
| Droplet 4GB | $24 | Mejor para producción |
| App Platform (basic) | $5+ | Según uso |
| Dominio | $0-20 | Depende registrador |
| Backups | $0-5 | Si usas Spaces |
| **Total** | **$6-50** | Escala con necesidades |

---

## Tips de Seguridad

✅ **Hacer:**
- Usar contraseñas fuertes (>16 caracteres)
- Habilitar UFW firewall
- Usar SSH keys, no contraseñas
- Configurar SSL/HTTPS
- Hacer backups regularmente
- Mantener Docker actualizado

❌ **Evitar:**
- Exponer puertos 5432 (PostgreSQL), 6379 (Redis) públicamente
- Usar `.env` sin .gitignore
- Dejar contraseñas por defecto
- Desactivar firewall
- Ejecutar como root innecesariamente

---

## Troubleshooting

### Droplet lento después de despliegue
```bash
# Ver recursos
docker stats

# Aumentar plan o reducir workload
```

### SSL no funciona
```bash
# Verificar certificados
ls -la nginx/ssl/

# Reiniciar Nginx
docker-compose restart nginx

# Ver logs
docker-compose logs nginx
```

### n8n no accesible
```bash
# Verificar firewall
sudo ufw status

# Verificar puertos
sudo netstat -tlnp | grep LISTEN

# Permitir puerto 443 si falta
sudo ufw allow 443/tcp
```

---

## Soporte

- 📚 [Documentación n8n](https://docs.n8n.io)
- 🌊 [Digital Ocean Docs](https://docs.digitalocean.com/)
- 🐳 [Docker Docs](https://docs.docker.com/)

