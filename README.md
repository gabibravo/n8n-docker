# 🔄 n8n - Docker Compose Setup

Configuración profesional de **n8n** (automatización de workflows) con Docker, PostgreSQL, Redis y Nginx.

## 📋 Contenido

- [Requisitos](#requisitos)
- [Instalación Rápida](#instalación-rápida)
- [Configuración](#configuración)
- [Uso](#uso)
- [Gestión de Servicios](#gestión-de-servicios)
- [Backup y Restauración](#backup-y-restauración)
- [Despliegue en Digital Ocean](#despliegue-en-digital-ocean)
- [Solución de Problemas](#solución-de-problemas)
- [Estructura del Proyecto](#estructura-del-proyecto)

---

## 📦 Requisitos

- Docker >= 20.10
- Docker Compose >= 1.29
- Git (para versionado y despliegue)
- 2GB+ RAM disponible
- 10GB+ almacenamiento disponible

### Verificar Instalación

```bash
docker --version
docker-compose --version
```

---

## 🚀 Instalación Rápida

### 1. Preparación Inicial

```bash
# Clonar o navegar al repositorio
cd /home/gabriel/IA-WorkFlows/code-n8n

# Crear archivo .env
cp .env.example .env

# Hacer scripts ejecutables
chmod +x scripts/*.sh
```

### 2. Editar Configuración

```bash
# Editar .env con valores seguros
nano .env
```

**Parámetros importantes a cambiar:**
- `DB_PASSWORD`: Contraseña segura para PostgreSQL
- `N8N_PASSWORD`: Contraseña segura para n8n
- `N8N_HOST`: Tu dominio (localhost para desarrollo)
- `WEBHOOK_URL`: URL de webhooks (igual a N8N_HOST)

### 3. Iniciar Servicios

```bash
# Opción 1: Usar script automatizado
./scripts/setup.sh

# Opción 2: Manual con docker-compose
docker-compose up -d
```

### 4. Verificar Estado

```bash
# Ver estado de servicios
docker-compose ps

# Ver logs de n8n
docker-compose logs -f n8n
```

### 5. Acceder a n8n

Abre tu navegador: **http://localhost:5678**

Credenciales por defecto (cambiar en .env):
- Usuario: `admin`
- Contraseña: (la configurada en .env)

---

## ⚙️ Configuración

### Archivo .env Detallado

```env
# PostgreSQL
DB_USER=n8n                          # Usuario de BD
DB_PASSWORD=changeme123!             # Contraseña segura (>12 caracteres)
DB_NAME=n8n                          # Nombre de BD
DB_PORT=5432                         # Puerto PostgreSQL

# Redis
REDIS_PORT=6379                      # Puerto Redis

# n8n
N8N_USER=admin                       # Usuario de login
N8N_PASSWORD=changeme123!            # Contraseña de login
N8N_HOST=localhost                   # Dominio/IP (ej: n8n.tudominio.com)
N8N_PORT=5678                        # Puerto interno
N8N_PROTOCOL=http                    # http o https
WEBHOOK_URL=http://localhost:5678    # URL base para webhooks

# Sistema
TIMEZONE=UTC                         # Zona horaria (ej: America/Buenos_Aires)
LOG_LEVEL=info                       # info, debug, warn, error
```

### Archivo docker-compose.yml

Incluye 4 servicios:

1. **PostgreSQL**: Base de datos principal
   - Puerto: 5432
   - Volumen: `postgres_data`

2. **Redis**: Caché y colas
   - Puerto: 6379
   - Volumen: `redis_data`

3. **n8n**: Aplicación principal
   - Puerto: 5678
   - Volumen: `n8n_data`

4. **Nginx**: Reverse proxy
   - Puertos: 80, 443
   - Config: `nginx/nginx.conf`

---

## 💻 Uso

### Comandos Básicos

```bash
# Iniciar servicios
docker-compose up -d

# Detener servicios
docker-compose down

# Ver estado
docker-compose ps

# Ver logs en tiempo real
docker-compose logs -f

# Ver logs de servicio específico
docker-compose logs -f n8n
docker-compose logs -f postgres
```

### Acceder a Servicios

```bash
# n8n Web UI
http://localhost:5678

# PostgreSQL (desde dentro del contenedor)
docker-compose exec postgres psql -U n8n -d n8n

# Redis CLI
docker-compose exec redis redis-cli
```

### Ejecutar Comandos en Contenedores

```bash
# Ver directorio n8n
docker-compose exec n8n ls -la /home/node/.n8n

# Reiniciar servicio
docker-compose restart n8n

# Entrar a bash en contenedor
docker-compose exec n8n bash
```

---

## 🛠️ Gestión de Servicios

### Scripts Disponibles

#### 1. Setup Automático (setup.sh)
```bash
./scripts/setup.sh
```
Verifica requisitos, copia .env, descarga imágenes e inicia servicios.

#### 2. Detener Servicios (stop.sh)
```bash
./scripts/stop.sh
```
Detiene todos los contenedores.

#### 3. Ver Logs (logs.sh)
```bash
# Logs de n8n (por defecto)
./scripts/logs.sh

# Logs de otro servicio
./scripts/logs.sh postgres
./scripts/logs.sh redis
```

#### 4. Backup (backup.sh)
```bash
./scripts/backup.sh
```
Crea backup de BD, n8n y Redis en carpeta `backups/`.

### Actualizaciones

```bash
# Descargar imagen más nueva
docker-compose pull n8n

# Recrear contenedor con nueva imagen
docker-compose up -d --force-recreate n8n

# Ver cambios
docker-compose logs -f n8n
```

### Limpieza

```bash
# Detener y eliminar contenedores
docker-compose down

# Eliminar volúmenes (⚠️ PÉRDIDA DE DATOS)
docker-compose down -v

# Eliminar imágenes descargadas
docker image prune -a
```

---

## 💾 Backup y Restauración

### Crear Backup

```bash
# Automático
./scripts/backup.sh

# Manual - PostgreSQL
docker-compose exec -T postgres pg_dump -U n8n n8n > backup_db.sql

# Manual - Volúmenes
docker run --rm -v n8n_data:/data -v $(pwd):/backup \
  alpine tar czf /backup/n8n_data.tar.gz /data
```

### Restaurar Backup

```bash
# Restaurar BD PostgreSQL
docker-compose exec -T postgres psql -U n8n n8n < backup_db.sql

# Restaurar volúmenes
docker run --rm -v n8n_data:/data -v $(pwd):/backup \
  alpine tar xzf /backup/n8n_data.tar.gz
```

---

## 🚀 Despliegue en Digital Ocean

### Opción 1: App Platform (Recomendado)

1. **Preparar Repositorio Git**
   ```bash
   git init
   git add .
   git commit -m "Initial n8n setup"
   git branch -M main
   git remote add origin https://github.com/tu-usuario/n8n-docker.git
   git push -u origin main
   ```

2. **Crear en Digital Ocean**
   - Ir a: https://cloud.digitalocean.com/apps
   - Click: "Create App"
   - Seleccionar: GitHub > Tu repositorio
   - Configurar:
     - **Name**: n8n
     - **Branch**: main
     - **Source Type**: Docker
     - **HTTP Port**: 5678
     - **Environment Variables**: Copiar desde .env

3. **Configurar Dominio**
   - En App Platform: Settings > Domain
   - Agregar tu dominio personalizado
   - Copiar registros CNAME a tu DNS

### Opción 2: Droplet + Docker (Manual)

1. **Crear Droplet**
   - Región: Cercana a ti
   - Imagen: Ubuntu 22.04 LTS
   - Plan: $6-12/mes (2GB+ RAM)
   - SSH Key: Agregala para acceso seguro

2. **Conectar y Configurar**
   ```bash
   # SSH al Droplet
   ssh root@tu_ip_droplet
   
   # Instalar Docker
   curl -fsSL https://get.docker.com -o get-docker.sh
   sh get-docker.sh
   
   # Instalar Docker Compose
   curl -L "https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-$(uname -s)-$(uname -m)" \
     -o /usr/local/bin/docker-compose
   chmod +x /usr/local/bin/docker-compose
   
   # Clonar repositorio
   git clone https://github.com/tu-usuario/n8n-docker.git
   cd n8n-docker
   
   # Copiar y editar .env
   cp .env.example .env
   nano .env  # Cambiar contraseñas y dominio
   
   # Iniciar
   ./scripts/setup.sh
   ```

3. **Configurar SSL con Let's Encrypt**
   ```bash
   # Instalar Certbot
   apt-get install -y certbot python3-certbot-nginx
   
   # Obtener certificado
   certbot certonly --standalone -d tu-dominio.com
   
   # Copiar certificados
   cp /etc/letsencrypt/live/tu-dominio.com/fullchain.pem nginx/ssl/cert.pem
   cp /etc/letsencrypt/live/tu-dominio.com/privkey.pem nginx/ssl/key.pem
   
   # Descomentar HTTPS en nginx.conf
   nano nginx/nginx.conf
   
   # Reiniciar nginx
   docker-compose restart nginx
   ```

4. **Configurar DNS**
   - En tu proveedor DNS: Crear registro A
   - Apuntador: `tu-dominio.com` → IP del Droplet

### Opción 3: Docker Swarm (Escalable)

```bash
# Inicializar Swarm
docker swarm init

# Editar docker-compose para modo Swarm
# Agregar 'mode: replicated' en servicios

# Desplegar
docker stack deploy -c docker-compose.yml n8n

# Ver estado
docker stack ps n8n
```

---

## 🔒 Seguridad en Producción

### Checklist Seguridad

- [ ] Cambiar todas las contraseñas en `.env`
- [ ] Configurar SSL/HTTPS
- [ ] Habilitar firewall (ufw en Linux)
- [ ] Configurar backups automáticos
- [ ] Usar variables de entorno seguras
- [ ] Limitar acceso SSH a IPs específicas
- [ ] Configurar monitoreo y alertas

### Comandos de Seguridad

```bash
# Firewall - permitir solo puertos necesarios
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp  # SSH
ufw allow 80/tcp  # HTTP
ufw allow 443/tcp # HTTPS
ufw enable

# Actualizar sistema
apt-get update && apt-get upgrade -y

# Ver variables de entorno (verificar sensibles)
docker-compose config | grep -E "PASSWORD|SECRET"
```

---

## 📊 Monitoreo

### Ver Recursos

```bash
# CPU, RAM, Almacenamiento
docker stats

# Detalles de volúmenes
docker volume ls
docker volume inspect n8n_data
```

### Logs de Errores

```bash
# Filtrar errores
docker-compose logs --tail=100 | grep -i error

# Error específico de servicio
docker-compose logs -f n8n | grep ERROR
```

---

## 🆘 Solución de Problemas

### n8n no inicia

```bash
# Ver logs detallados
docker-compose logs -f n8n

# Común: PostgreSQL no listo
# Solución: Esperar 30s y reiniciar n8n
docker-compose restart n8n

# Común: Puerto 5678 en uso
# Solución: Cambiar puerto en .env (N8N_PORT)
```

### Sin conexión a base de datos

```bash
# Verificar PostgreSQL
docker-compose exec postgres pg_isready -U n8n

# Verificar credenciales en .env
grep DB_ .env

# Reiniciar PostgreSQL
docker-compose restart postgres
```

### Webhooks no funcionan

```bash
# Verificar WEBHOOK_URL en .env
grep WEBHOOK_URL .env

# Debe ser la URL completa accesible públicamente
# Ej: https://tu-dominio.com (NO localhost)

# Verificar logging
docker-compose logs -f nginx
```

### Almacenamiento lleno

```bash
# Ver uso de volúmenes
docker system df

# Limpiar datos no usados
docker system prune -a --volumes
```

---

## 📁 Estructura del Proyecto

```
code-n8n/
├── docker-compose.yml      # Configuración de servicios
├── .env.example            # Variables de entorno (template)
├── .gitignore              # Archivos ignorados por Git
├── README.md               # Este archivo
│
├── nginx/
│   ├── nginx.conf          # Configuración del reverse proxy
│   └── ssl/                # Certificados SSL (no versionado)
│
├── scripts/
│   ├── setup.sh            # Script de instalación
│   ├── stop.sh             # Script para detener
│   ├── logs.sh             # Script para ver logs
│   └── backup.sh           # Script de backup
│
├── data/                   # Datos persistentes (no versionado)
│   ├── postgres_data/      # BD PostgreSQL
│   ├── redis_data/         # Cache Redis
│   └── n8n_data/           # Datos de n8n
│
└── backups/                # Backups (no versionado)
```

---

## 🔄 Workflow CI/CD en Digital Ocean

### Opción: GitHub Actions

Crear `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Digital Ocean

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Deploy to Droplet
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.DROPLET_IP }}
          username: root
          key: ${{ secrets.SSH_KEY }}
          script: |
            cd /root/n8n-docker
            git pull
            docker-compose pull
            docker-compose up -d
```

### Configurar Secrets en GitHub

1. Ir a: Settings > Secrets
2. Agregar:
   - `DROPLET_IP`: IP del Droplet
   - `SSH_KEY`: Tu clave SSH privada

---

## 📚 Recursos Útiles

- [n8n Documentación Oficial](https://docs.n8n.io)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [Digital Ocean Droplets](https://docs.digitalocean.com/products/droplets/)
- [Let's Encrypt](https://letsencrypt.org/)
- [Nginx Configuration](https://nginx.org/en/docs/)

---

## 📞 Soporte

**Si encuentras problemas:**

1. Revisar logs: `docker-compose logs -f`
2. Verificar .env está correctamente configurado
3. Asegurar que Docker esté corriendo: `docker ps`
4. Consultar documentación oficial de n8n

---

## 📄 Licencia

Este proyecto sigue la licencia de n8n y está disponible bajo términos open-source.

---

**Última actualización: febrero 2026** ✨

