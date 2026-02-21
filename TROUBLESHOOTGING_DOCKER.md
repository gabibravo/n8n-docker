# 🔧 Guía de Resolución de Problemas - Descarga de Imágenes

Si encuentras el error: `failed to register layer: Error processing tar file(exit status 1): archive/tar: invalid tar header`

## Soluciones en Orden de Prioridad

### Solución 1: Reiniciar Docker Daemon (Más Rápido)

```bash
# En Linux
sudo systemctl restart docker

# Esperar 10 segundos
sleep 10

# Reintentar
cd /home/gabriel/IA-WorkFlows/code-n8n
docker-compose pull
```

### Solución 2: Limpiar Caché de Docker

```bash
# Limpiar completamente
docker system prune -a --volumes -f

# Esperar 10 segundos
sleep 10

# Reintentar
docker-compose pull
```

### Solución 3: Aumentar Almacenamiento Docker

El error puede deberse a falta de espacio:

```bash
# Ver uso de espacio
df -h /var/lib/docker

# Si está lleno, eliminar imágenes no usadas
docker rmi $(docker images -q)

# Luego:
docker-compose pull
```

### Solución 4: Descargar Solo Imágenes Necesarias (Manual)

Si el pull automático falla, descarga cada una por separado:

```bash
docker pull postgres:16-alpine
docker pull redis:7-alpine  
docker pull nginx:alpine
docker pull n8nio/n8n:latest
```

### Solución 5: Usar Buildkit (Backend Moderno)

```bash
# Habilitar BuildKit
export DOCKER_BUILDKIT=1

# Reintentar
docker-compose pull
```

### Solución 6: Cambiar URL del Registry

Si tu DNS tiene problemas:

```bash
# Crear/editar /etc/docker/daemon.json
sudo nano /etc/docker/daemon.json

# Agregar:
{
    "registry-mirrors": ["https://mirror.gcr.io"],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "10m",
        "max-file": "3"
    }
}

# Reiniciar Docker
sudo systemctl restart docker
```

---

## Si Nada Funciona

### Opción A: Usar Docker Desktop / WSL2

- Reinstalar Docker con WSL2 backend
- Mejor compatibilidad y gestión automática

### Opción B: Usar Imágenes en Local

```bash
# Compilar tú mismo (si tienes tiempo)
git clone https://github.com/n8n-io/n8n.git
cd n8n
docker build -t n8n-custom:latest .

# Luego editar docker-compose.yml
# image: n8n-custom:latest
```

### Opción C: Usar Servidor Digital Ocean

Muchas veces el problema es local. Saltea Docker Local y despliega directamente en Digital Ocean donde funciona sin problemas.

---

## Diagnosticar el Problema

```bash
# Ver logs de Docker
sudo journalctl -u docker -n 50

# Ver estado del sistema de archivos
docker info | grep -E "Storage|Kernel"

# Verificar espacio disponible
du -sh /var/lib/docker/*

# Ver si hay procesos Docker pegados
docker ps -a
```

