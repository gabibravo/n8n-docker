# ⚡ Quick Start - 5 Minutos

## 🎯 Objetivo

Tener **n8n corriendo localmente** en 5 minutos con un comando.

---

## 1️⃣ Requisitos (1 minuto)

```bash
# Verificar que tienes instalado
docker --version        # >= 20.10
docker-compose --version # >= 1.29

# Si NO tienes Docker:
# Linux: curl -fsSL https://get.docker.com | sudo sh
# Windows/Mac: Descargar Docker Desktop
```

---

## 2️⃣ Clonar/Navegar (30 segundos)

Ya estás en el directorio correcto:

```bash
cd /home/gabriel/IA-WorkFlows/code-n8n
```

---

## 3️⃣ Crear Archivo .env (30 segundos)

```bash
cp .env.example .env

# Opcional: Editar contraseñas
nano .env
```

---

## 4️⃣ Iniciar Servicios (3 minutos)

### Opción A: Automática (Recomendado)

```bash
chmod +x scripts/*.sh
./scripts/setup.sh
```

### Opción B: Manual

```bash
docker-compose up -d
```

---

## 5️⃣ Verificar (1 minuto)

```bash
# Ver estado
docker-compose ps

# Deberías ver 4 servicios "Up"
```

---

## ✅ ¡Listo!

Abre en tu navegador:

### **http://localhost:5678**

**Credenciales**:
- Usuario: `admin`
- Contraseña: `n8n_admin_password_2024!` (o la de tu .env)

---

## 📚 Siguiente

### Para Desarrollo
→ Leer [README.md](README.md)

### Para Producción  
→ Leer [DEPLOY_DIGITAL_OCEAN.md](DEPLOY_DIGITAL_OCEAN.md)

### Si hay problemas
→ Leer [TROUBLESHOOTING_DOCKER.md](TROUBLESHOOTING_DOCKER.md)

---

## 🔴 Problema: Imagen n8n No Descarga

Si ves el error: `invalid tar header`

**Ejecuta en orden:**

```bash
# 1. Reiniciar Docker
sudo systemctl restart docker

# 2. Esperar
sleep 10

# 3. Limpiar caché
docker system prune -a -f

# 4. Reintentar al paso "Iniciar Servicios"
./scripts/setup.sh
```

Si sigue sin funcionar:
→ Lee [TROUBLESHOOTING_DOCKER.md](TROUBLESHOOTING_DOCKER.md) completo

---

## 📖 Comandos Útiles

```bash
# Ver logs en tiempo real
docker-compose logs -f n8n

# Detener
docker-compose down

# Reiniciar
docker-compose restart n8n

# Acceder a bash en contenedor
docker-compose exec n8n bash

# Backup
./scripts/backup.sh

# Health check
./scripts/healthcheck.sh
```

---

**¡Disfruta n8n! 🎉**

