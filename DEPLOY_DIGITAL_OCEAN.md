# 🌊 Despliegue en Digital Ocean

Guía paso a paso para desplegar n8n en Digital Ocean.

## ⚠️ PROBLEMA: "No components detected"

Si al agregar el repositorio en Digital Ocean obtienes este error:

```
No components detected: Here are some things to check:
- Verify the repo contains supported file types
- If your app isn't in the root, enter the source directory
```

### SOLUCIÓN: Usar el Dockerfile incluido

El proyecto incluye un `Dockerfile` en la raíz que Digital Ocean detectará automáticamente si:

1. **Asegúrate de que el archivo existe:**
   ```bash
   git add Dockerfile .dockerignore app.yaml
   git commit -m "Add Docker configuration for Digital Ocean"
   git push origin main
   ```

2. **En Digital Ocean App Platform:**
   - Vuelve a desconectar y conectar el repositorio
   - O espera a que se refresque automáticamente
   - Digital Ocean debería detectar `Dockerfile` como tipo de construcción

3. **Si aún no detecta:**
   - Click en "Edit" → "Builder"
   - Cambia a: **"Dockerfile"**
   - Ruta del Dockerfile: `./Dockerfile`
   - Puerto HTTP: `5678`

---

## Opción 1: App Platform (Más Fácil ⭐ Recomendado)

### Ventajas
- ✅ Deployment automático desde Git
- ✅ SSL/HTTPS automático
- ✅ Escalado automático
- ✅ CDN integrado
- ✅ Sin gestionar infraestructura

### Paso 1: Preparar Repositorio

```bash
# Desde tu máquina local
cd /home/gabriel/IA-WorkFlows/code-n8n

# Inicializar git (si no está hecho)
git init

# Crear repositorio en GitHub
# Ir a https://github.com/new
# Nombre: n8n-docker
# NO inicializar con README

# Agregar remoto
git remote add origin https://github.com/TU_USUARIO/n8n-docker.git

# Agregar todos los archivos
git add .

# Primer commit
git commit -m "Initial n8n Docker setup"

# Push a main
git branch -M main
git push -u origin main
```

### Paso 2: Conectar a Digital Ocean

1. **Crear Aplicación**
   - Ir a: https://cloud.digitalocean.com/apps
   - Click: "Create App" → "GitHub"
   - Autorizar Digital Ocean
   - Seleccionar: `n8n-docker` repository
   - Branch: `main`

2. **Configurar Builder**
   - Type: **Dockerfile** (debe seleccionar esto explícitamente)
   - Source: `./Dockerfile` (ruta del archivo)
   - Dockerfile path: `Dockerfile`
   - Build context: `/` (raíz del repositorio)
   - Puerto HTTP: `5678`
   - **Importante**: Asegúrate de que "Dockerfile" esté seleccionado, NO "Buildpack"

3. **Configurar Variablesde Entorno**
   ```
   DB_USER=n8n
   DB_PASSWORD=GenerarContraseñaSegura123!
   DB_NAME=n8n
   N8N_USER=admin
   N8N_PASSWORD=GenerarContraseñaSegura456!
   N8N_HOST=n8n-XYZ.ondigitalocean.app
   N8N_PROTOCOL=https
   WEBHOOK_URL=https://n8n-XYZ.ondigitalocean.app
   TIMEZONE=UTC
   ```

4. **Seleccionar Plan**
   - Basic: $5/mes (suficiente para desarrollo)
   - Pro: $12/mes (mejor para producción)

5. **Deploy**
   - Click: "Create Resources"
   - Esperar completación (~10 minutos)

6. **Acceder**
   - URL: https://n8n-XYZ.ondigitalocean.app
   - Login con credenciales configuradas

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

