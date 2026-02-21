# 🎯 Guía Completa para Comenzar

Este documento te guía paso a paso sobre cómo usar este proyecto.

## 📋 Opciones por Caso de Uso

### 1. "Solo quiero ejecutarlo localmente"

→ Lee: **[QUICKSTART.md](QUICKSTART.md)** (5 minutos)

```bash
./scripts/setup.sh
```

---

### 2. "Quiero entender la configuración completa"

→ Lee: **[README.md](README.md)** (20 minutos)

Aprenderás:
- Qué es cada servicio
- Cómo cambiarpuertos
- Cómo hacer backups
- Cómo optimizar para producción

---

### 3. "Quiero desplegar en Digital Ocean"

→ Lee: **[DEPLOY_DIGITAL_OCEAN.md](DEPLOY_DIGITAL_OCEAN.md)** (30 minutos)

Aprenderás 3 opciones:
- **App Platform** (más fácil, hosted)
- **Droplet** (más control, más barato)
- **Docker Swarm** (escalable, múltiples máquinas)

---

### 4. "Tengo problemas con Docker"

→ Lee: **[TROUBLESHOOTING_DOCKER.md](TROUBLESHOOTING_DOCKER.md)**

Cubre:
- Errores comunes de descarga
- Problemas de espacio/recursos
- Soluciones paso a paso
- Opciones alternativas

---

### 5. "Quiero configurar Pipeline CI/CD"

→ Ver: **[.github/workflows/deploy.yml](.github/workflows/deploy.yml)**

Pasos:
1. Crear repositorio en GitHub
2. Crear Droplet en Digital Ocean
3. Agregar Secrets en GitHub
4. Push automático despliega

---

### 6. "Quiero contribuir/modificar"

→ Lee: **[CONTRIBUTING.md](CONTRIBUTING.md)**

---

### 7. "Quiero ver qué se hizo"

→ Lee: **[PROJECT_STATUS.md](PROJECT_STATUS.md)**

Contiene:
- Qué se completó
- Estructura del proyecto
- Próximos pasos
- Posibles problemas

---

## 🚀 Flujo Recomendado

### Primera Vez

```
1. Leer QUICKSTART.md
   ↓
2. Ejecutar ./scripts/setup.sh
   ↓
3. Acceder a http://localhost:5678
   ↓
4. Crear un workflow de prueba
```

### Para Llevar a Producción

```
1. Leer DEPLOY_DIGITAL_OCEAN.md
   ↓
2. Crear Droplet o App Platform
   ↓
3. Seguir pasos de configuración
   ↓
4. Configurar dominio + SSL
   ↓
5. Probar webhooks y workflows
```

### Para Automatizar Despliegues

```
1. Crear repo en GitHub
   ↓
2. Crear Droplet Digital Ocean
   ↓
3. Agregar secrets en GitHub
   ↓
4. Cada push a main despliega automáticamente
```

---

## 📁 Estructura de Archivos

```
Documentación General
├── README.md                          ← Leer primero (referencia)
├── QUICKSTART.md                      ← 5 minutos para comenzar
├── GETTING_STARTED.md                 ← Este archivo
├── PROJECT_STATUS.md                  ← Estado actual
└── CHANGELOG.md                       ← Cambios históricos

Documentación Específica
├── DEPLOY_DIGITAL_OCEAN.md            ← Despliegue producción
├── TROUBLESHOOTING_DOCKER.md          ← Solución de problemas
└── CONTRIBUTING.md                    ← Contribuciones

Configuración
├── docker-compose.yml                 ← Servicios
├── .env.example                       ← Template variables
├── .gitignore                         ← QUÉ no versionar
└── nginx/nginx.conf                   ← Reverse proxy

Automatización
├── scripts/setup.sh                   ← Instalar
├── scripts/stop.sh                    ← Detener
├── scripts/logs.sh                    ← Ver logs
├── scripts/backup.sh                  ← Hacer backup
├── scripts/healthcheck.sh             ← Verificar salud
├── scripts/update.sh                  ← Actualizar
└── .github/workflows/deploy.yml       ← CI/CD automático

Datos (gitignored)
├── data/
├── backups/
├── nginx/ssl/
└── .env
```

---

## 💡 Tips Importantes

### ✅ Hacer

- Cambiar contraseñas en `.env`
- Usar HTTPS en producción
- Hacer backups regulares
- Revisar logs periódicamente
- Actualizar Docker regularmente

### ❌ NO Hacer

- Committear `.env` a Git
- Exponer puertos de BD (5432, 6379) públicamente
- Usar contraseñas por defecto en producción
- Ignorar warnings de Docker
- Dejar logs sin revisar

---

## 🔗 Vinculación de Documentos

Cada documento está diseñado para ser independiente pero vinculado:

- `QUICKSTART.md` → `README.md` → Documentación específica
- `README.md` → `DEPLOY_DIGITAL_OCEAN.md` para ir a producción
- Cualquier problema → `TROUBLESHOOTING_DOCKER.md`
- Querer versionar → `CONTRIBUTING.md`

---

## 📞 Flujo de Ayuda

¿Problema? Sigue este orden:

1. **¿Qué error ves?**
   - Búscalo en `TROUBLESHOOTING_DOCKER.md`
   - Si no está ahí → `docker-compose logs -f`

2. **¿Necesitas configurar algo?**
   - Revisa `README.md` → Configuración

3. **¿Quieres desplegar?**
   - Lee `DEPLOY_DIGITAL_OCEAN.md`

4. **¿Nada de esto ayuda?**
   - Rev isa logs: `docker-compose logs -f n8n`
   - Verifica resources: `docker stats`

---

## 🎓 Aprendizaje Progresivo

### Nivel 1: "Quiero que funcione"
- Lee: QUICKSTART.md
- Tiempo: 5 minutos

### Nivel 2: "Quiero entender cómo funciona"  
- Lee: README.md
- Tiempo: 20 minutos

### Nivel 3: "Quiero llevarlo a producción"
- Lee: DEPLOY_DIGITAL_OCEAN.md
- Tiempo: 1 hora

### Nivel 4: "Quiero automatizar despliegues"
- Lee: .github/workflows/deploy.yml + DEPLOY_DIGITAL_OCEAN.md
- Tiempo: 2 horas

### Nivel 5: "Quiero contribuir/modificar"
- Lee: CONTRIBUTING.md + toda la doc
- Tiempo: abierto

---

## 💻 Comandos Rápidos

```bash
# Setup inicial
./scripts/setup.sh

# Ver que todo está corriendo
docker-compose ps

# Ver logs
docker-compose logs -f n8n

# Parar
docker-compose down

# Backup
./scripts/backup.sh

# Actualizar
./scripts/update.sh
```

---

## 🤔 Preguntas Frecuentes

**P: ¿Necesito pagar por algo?**  
R: No para desarrollo local. Para producción, Digital Ocean Droplet = $6-12/mes.

**P: ¿Qué es cada servicio?**  
R: Ver "Servicios" en README.md

**P: ¿Cómo cambio el puerto?**  
R: Edita `.env` y cambia `N8N_PORT=5678`

**P: ¿Cómo hago un backup?**  
R: Ejecuta `./scripts/backup.sh`

**P: ¿Cómo cambio contraseñas?**  
R: Edita `.env` antes de `docker-compose up`

**P: ¿Necesito SSL para desarrollo?**  
R: No, solo para producción. Mira DEPLOY_DIGITAL_OCEAN.md

---

**¿Listo? Comienza con → [QUICKSTART.md](QUICKSTART.md)** ⚡

