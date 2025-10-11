# 🛫 Flight Booking System - Sistema de Reserva de Vuelos

## 📝 Descripción del Proyecto

Este es un proyecto de sistema web para gestión y reserva de vuelos desarrollado como parte de mi aprendizaje en DevOps y Cloud Computing. El sistema permite a los usuarios buscar vuelos, hacer reservas y gestionar sus bookings de manera sencilla.

La infraestructura completa está desplegada en AWS usando Terraform para automatizar todo, y la aplicación corre en contenedores Docker. Fue todo un reto pero aprendí muchísimo en el proceso.

---

## 🏗️ Arquitectura del Sistema

El proyecto está dividido en tres partes principales:

### **1. Infraestructura (Terraform)**
- **EC2**: Servidor Ubuntu t2.micro con Docker instalado
- **RDS**: Base de datos PostgreSQL 14.13
- **S3**: Bucket para archivos estáticos
- **Security Groups**: Configuración de firewall para cada servicio
- **IAM Roles**: Permisos para que EC2 acceda a S3
- **Elastic IP**: IP pública fija para el servidor

### **2. Backend (FastAPI + Python)**
- API REST con FastAPI
- SQLAlchemy para manejo de base de datos
- Endpoints para vuelos, clientes y reservas
- Documentación automática con Swagger

### **3. Frontend (Angular + TypeScript)**
- Aplicación web interactiva
- Componentes para búsqueda, listado y reserva de vuelos
- Comunicación con el backend mediante HTTP
- Diseño responsive con CSS

---

## 📂 Estructura del Proyecto

mi-sistema/
├── terraform/                    # Infraestructura como código
│   ├── providers.tf             # Configuración de AWS
│   ├── variables.tf             # Variables generales
│   ├── locals.tf                # Variables locales calculadas
│   ├── data.tf                  # Datos de AWS existentes
│   ├── ec2.tf                   # Configuración de EC2
│   ├── ec2_variables.tf         # Variables de EC2
│   ├── ec2_outputs.tf           # Outputs de EC2
│   ├── rds.tf                   # Configuración de RDS
│   ├── rds_variables.tf         # Variables de RDS
│   ├── rds_outputs.tf           # Outputs de RDS
│   ├── s3.tf                    # Configuración de S3
│   ├── s3_variables.tf          # Variables de S3
│   ├── s3_outputs.tf            # Outputs de S3
│   ├── security_groups_ec2.tf   # Security Group de EC2
│   ├── security_groups_rds.tf   # Security Group de RDS
│   ├── iam.tf                   # Roles y políticas IAM
│   ├── key_pair.tf              # Generación de llave SSH
│   ├── outputs.tf               # Outputs generales
│   ├── terraform.tfvars         # Valores de variables (NO subir a Git)
│   └── terraform.tfvars.example # Ejemplo de configuración
│
└── flight-booking-app/          # Aplicación
├── backend/                 # API Backend
│   ├── main.py             # Código principal de FastAPI
│   ├── requirements.txt    # Dependencias de Python
│   ├── Dockerfile          # Imagen Docker del backend
│   └── seed_data.py        # Datos de prueba
│
├── frontend/                # Aplicación web
│   ├── src/
│   │   ├── app/
│   │   │   ├── components/  # Componentes de Angular
│   │   │   ├── models/      # Modelos de datos
│   │   │   ├── services/    # Servicios HTTP
│   │   │   ├── app.module.ts
│   │   │   └── app-routing.module.ts
│   │   ├── environments/    # Configuración de ambientes
│   │   └── styles.css       # Estilos globales
│   ├── angular.json
│   ├── package.json
│   ├── Dockerfile          # Imagen Docker del frontend
│   └── nginx.conf          # Configuración de Nginx
│
└── docker-compose.yml       # Orquestación de contenedores

---

## 🛠️ Tecnologías Utilizadas

### **Infraestructura**
- **Terraform** v1.0+: Infraestructura como código
- **AWS**: Proveedor de nube (EC2, RDS, S3, IAM)

### **Backend**
- **Python** 3.11
- **FastAPI** 0.104.1: Framework web moderno
- **SQLAlchemy** 2.0.23: ORM para base de datos
- **PostgreSQL** 14.13: Base de datos relacional
- **Uvicorn**: Servidor ASGI
- **Pydantic**: Validación de datos

### **Frontend**
- **Angular** 16+: Framework de TypeScript
- **TypeScript**: Lenguaje de programación
- **RxJS**: Programación reactiva
- **HTML5 / CSS3**: Maquetado y estilos

### **DevOps**
- **Docker**: Contenedores
- **Docker Compose**: Orquestación local
- **Nginx**: Servidor web para el frontend
- **Git**: Control de versiones

---

## 📋 Requisitos Previos

Antes de empezar necesitas tener instalado:

- **Terraform** (v1.0 o superior)
- **AWS CLI** configurado con tus credenciales
- **Docker** y **Docker Compose**
- **Node.js** (v18+) y **npm**
- **Python** (v3.11+)
- **Angular CLI**: `npm install -g @angular/cli`
- Una cuenta de AWS con permisos para crear recursos

---

## 🚀 Instalación y Despliegue

### **Paso 1: Clonar el Repositorio**
```bash
git clone https://github.com/tu-usuario/flight-booking-system.git
cd flight-booking-system

### **Paso 2: Configurar Variables de Terraform**

cd terraform
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars

# Cambia esto por tu IP pública
my_ip = "TU_IP_PUBLICA/32"

# Para obtener tu IP pública:
curl ifconfig.me

### **Paso 3: Desplegar Infraestructura en AWS**
# Inicializar Terraform
terraform init

# Ver qué recursos se van a crear
terraform plan

# Crear la infraestructura (tarda ~15 minutos)
terraform apply

### **Paso 4: Guardar las Credenciales**

# Ver IP de EC2
terraform output ec2_public_ip

# Ver endpoint de RDS
terraform output rds_address

# Ver contraseña de RDS
terraform output -raw rds_password

# Ver todas las credenciales
terraform output connection_instructions

### **Paso 5: Configurar la Aplicación**

cd ../flight-booking-app

# Editar docker-compose.yml con las credenciales de RDS
nano docker-compose.yml
# Remplaza esto con tus credenciales :
- DATABASE_URL=postgresql://USUARIO:CONTRASEÑA@ENDPOINT_RDS:5432/flightbookingdb

md# 🛫 Flight Booking System - Sistema de Reserva de Vuelos

## 📝 Descripción del Proyecto

Este es un proyecto de sistema web para gestión y reserva de vuelos desarrollado como parte de mi aprendizaje en DevOps y Cloud Computing. El sistema permite a los usuarios buscar vuelos, hacer reservas y gestionar sus bookings de manera sencilla.

La infraestructura completa está desplegada en AWS usando Terraform para automatizar todo, y la aplicación corre en contenedores Docker. Fue todo un reto pero aprendí muchísimo en el proceso.

---

## 🏗️ Arquitectura del Sistema

El proyecto está dividido en tres partes principales:

### **1. Infraestructura (Terraform)**
- **EC2**: Servidor Ubuntu t2.micro con Docker instalado
- **RDS**: Base de datos PostgreSQL 14.13
- **S3**: Bucket para archivos estáticos
- **Security Groups**: Configuración de firewall para cada servicio
- **IAM Roles**: Permisos para que EC2 acceda a S3
- **Elastic IP**: IP pública fija para el servidor

### **2. Backend (FastAPI + Python)**
- API REST con FastAPI
- SQLAlchemy para manejo de base de datos
- Endpoints para vuelos, clientes y reservas
- Documentación automática con Swagger

### **3. Frontend (Angular + TypeScript)**
- Aplicación web interactiva
- Componentes para búsqueda, listado y reserva de vuelos
- Comunicación con el backend mediante HTTP
- Diseño responsive con CSS

---

## 📂 Estructura del Proyecto
mi-sistema/
├── terraform/                    # Infraestructura como código
│   ├── providers.tf             # Configuración de AWS
│   ├── variables.tf             # Variables generales
│   ├── locals.tf                # Variables locales calculadas
│   ├── data.tf                  # Datos de AWS existentes
│   ├── ec2.tf                   # Configuración de EC2
│   ├── ec2_variables.tf         # Variables de EC2
│   ├── ec2_outputs.tf           # Outputs de EC2
│   ├── rds.tf                   # Configuración de RDS
│   ├── rds_variables.tf         # Variables de RDS
│   ├── rds_outputs.tf           # Outputs de RDS
│   ├── s3.tf                    # Configuración de S3
│   ├── s3_variables.tf          # Variables de S3
│   ├── s3_outputs.tf            # Outputs de S3
│   ├── security_groups_ec2.tf   # Security Group de EC2
│   ├── security_groups_rds.tf   # Security Group de RDS
│   ├── iam.tf                   # Roles y políticas IAM
│   ├── key_pair.tf              # Generación de llave SSH
│   ├── outputs.tf               # Outputs generales
│   ├── terraform.tfvars         # Valores de variables (NO subir a Git)
│   └── terraform.tfvars.example # Ejemplo de configuración
│
└── flight-booking-app/          # Aplicación
├── backend/                 # API Backend
│   ├── main.py             # Código principal de FastAPI
│   ├── requirements.txt    # Dependencias de Python
│   ├── Dockerfile          # Imagen Docker del backend
│   └── seed_data.py        # Datos de prueba
│
├── frontend/                # Aplicación web
│   ├── src/
│   │   ├── app/
│   │   │   ├── components/  # Componentes de Angular
│   │   │   ├── models/      # Modelos de datos
│   │   │   ├── services/    # Servicios HTTP
│   │   │   ├── app.module.ts
│   │   │   └── app-routing.module.ts
│   │   ├── environments/    # Configuración de ambientes
│   │   └── styles.css       # Estilos globales
│   ├── angular.json
│   ├── package.json
│   ├── Dockerfile          # Imagen Docker del frontend
│   └── nginx.conf          # Configuración de Nginx
│
└── docker-compose.yml       # Orquestación de contenedores

---

## 🛠️ Tecnologías Utilizadas

### **Infraestructura**
- **Terraform** v1.0+: Infraestructura como código
- **AWS**: Proveedor de nube (EC2, RDS, S3, IAM)

### **Backend**
- **Python** 3.11
- **FastAPI** 0.104.1: Framework web moderno
- **SQLAlchemy** 2.0.23: ORM para base de datos
- **PostgreSQL** 14.13: Base de datos relacional
- **Uvicorn**: Servidor ASGI
- **Pydantic**: Validación de datos

### **Frontend**
- **Angular** 16+: Framework de TypeScript
- **TypeScript**: Lenguaje de programación
- **RxJS**: Programación reactiva
- **HTML5 / CSS3**: Maquetado y estilos

### **DevOps**
- **Docker**: Contenedores
- **Docker Compose**: Orquestación local
- **Nginx**: Servidor web para el frontend
- **Git**: Control de versiones

---

## 📋 Requisitos Previos

Antes de empezar necesitas tener instalado:

- **Terraform** (v1.0 o superior)
- **AWS CLI** configurado con tus credenciales
- **Docker** y **Docker Compose**
- **Node.js** (v18+) y **npm**
- **Python** (v3.11+)
- **Angular CLI**: `npm install -g @angular/cli`
- Una cuenta de AWS con permisos para crear recursos

---

## 🚀 Instalación y Despliegue

### **Paso 1: Clonar el Repositorio**
```bash
git clone https://github.com/tu-usuario/flight-booking-system.git
cd flight-booking-system
Paso 2: Configurar Variables de Terraform
cd terraform
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars
Edita las siguientes variables importantes:
hcl# Cambia esto por tu IP pública
my_ip = "TU_IP_PUBLICA/32"

# Puedes dejar el resto con los valores por defecto
project_name = "flight-booking"
environment  = "dev"
aws_region   = "us-east-1"
Para obtener tu IP pública:
curl ifconfig.me
Paso 3: Desplegar Infraestructura en AWS
# Inicializar Terraform
terraform init

# Ver qué recursos se van a crear
terraform plan

# Crear la infraestructura (tarda ~15 minutos)
terraform apply
Cuando pregunte, escribe yes y presiona Enter.
⏰ Nota: RDS puede tardar 10-15 minutos en crearse, es normal.
Paso 4: Guardar las Credenciales
Una vez que Terraform termine, guarda las credenciales:
# Ver IP de EC2
terraform output ec2_public_ip

# Ver endpoint de RDS
terraform output rds_address

# Ver contraseña de RDS
terraform output -raw rds_password

# Ver todas las credenciales
terraform output connection_instructions
Guarda estos datos en un archivo seguro (NO lo subas a Git).
Paso 5: Configurar la Aplicación
cd ../flight-booking-app

# Editar docker-compose.yml con las credenciales de RDS
nano docker-compose.yml
Reemplaza la línea DATABASE_URL con tus credenciales:
yaml- DATABASE_URL=postgresql://USUARIO:CONTRASEÑA@ENDPOINT_RDS:5432/flightbookingdb
Paso 6: Subir la Aplicación a EC2
# Comprimir el proyecto (sin node_modules para que sea más liviano)
cd ..
tar -czf flight-booking-app.tar.gz \
  --exclude='node_modules' \
  --exclude='.angular' \
  --exclude='dist' \
  flight-booking-app/

# Subir a EC2
scp -i terraform/flight-booking-key.pem \
  flight-booking-app.tar.gz \
  ubuntu@TU_IP_EC2:~/
Paso 7: Desplegar en EC2
# Conectarse a EC2
ssh -i terraform/flight-booking-key.pem ubuntu@TU_IP_EC2

# Descomprimir
tar -xzf flight-booking-app.tar.gz
cd flight-booking-app

# Levantar los contenedores
docker-compose up -d --build

# Ver los logs
docker-compose logs -f
Paso 8: Poblar Datos de Prueba
# Ejecutar el script de datos de prueba
docker exec -it flight-booking-backend python seed_data.py

🌐 Acceder a la Aplicación
Una vez desplegado, puedes acceder a:

Frontend: http://TU_IP_EC2
Backend API: http://TU_IP_EC2:5000
Documentación API: http://TU_IP_EC2:5000/docs


📊 Base de Datos
Modelo de Datos
El sistema tiene 3 tablas principales:
flights (Vuelos)

id: ID único
flight_number: Número de vuelo (ej: AA101)
origin: Ciudad de origen
destination: Ciudad de destino
departure_time: Hora de salida
arrival_time: Hora de llegada
price: Precio por pasajero
available_seats: Asientos disponibles
total_seats: Total de asientos
airline: Aerolínea

customers (Clientes)

id: ID único
name: Nombre completo
email: Correo electrónico (único)
phone: Teléfono
created_at: Fecha de registro

bookings (Reservas)

id: ID único
customer_id: Referencia al cliente
flight_id: Referencia al vuelo
booking_date: Fecha de la reserva
passengers: Número de pasajeros
total_price: Precio total
status: Estado (confirmed/cancelled)


🔌 API Endpoints
Vuelos

GET /flights/ - Listar todos los vuelos
GET /flights/{id} - Obtener un vuelo específico
POST /flights/ - Crear un nuevo vuelo
PUT /flights/{id} - Actualizar un vuelo
DELETE /flights/{id} - Eliminar un vuelo

Clientes

GET /customers/ - Listar todos los clientes
GET /customers/{id} - Obtener un cliente específico
POST /customers/ - Crear un nuevo cliente

Reservas

GET /bookings/ - Listar todas las reservas
GET /bookings/{id} - Obtener una reserva específica
POST /bookings/ - Crear una nueva reserva
DELETE /bookings/{id} - Cancelar una reserva
GET /customers/{id}/bookings - Obtener reservas de un cliente

Documentación interactiva: http://TU_IP_EC2:5000/docs

🧪 Pruebas
Probar el Backend
# Listar vuelos
curl http://TU_IP_EC2:5000/flights/

# Obtener un vuelo específico
curl http://TU_IP_EC2:5000/flights/1

# Health check
curl http://TU_IP_EC2:5000/health
Probar el Frontend
Simplemente abre tu navegador en http://TU_IP_EC2 y:

Busca vuelos desde la página principal
Haz clic en "Search Flights"
Selecciona un vuelo y haz clic en "Book Now"
Llena el formulario de reserva
Verifica tu reserva en "My Bookings"


🐳 Comandos Útiles de Docker
# Ver contenedores corriendo
docker ps

# Ver logs del backend
docker-compose logs -f backend

# Ver logs del frontend
docker-compose logs -f frontend

# Reiniciar todo
docker-compose restart

# Detener todo
docker-compose down

# Reconstruir e iniciar
docker-compose up -d --build

# Entrar al contenedor del backend
docker exec -it flight-booking-backend bash

# Entrar al contenedor del frontend
docker exec -it flight-booking-frontend sh

🛠️ Comandos de Terraform
# Ver estado actual
terraform show

# Ver outputs
terraform output

# Ver un output específico
terraform output ec2_public_ip

# Actualizar infraestructura después de cambios
terraform apply

# Destruir toda la infraestructura
terraform destroy

# Formatear archivos .tf
terraform fmt

# Validar configuración
terraform validate

🔒 Seguridad
Mejores Prácticas Implementadas

✅ Security Groups restrictivos (solo puertos necesarios)
✅ RDS no es accesible públicamente
✅ Credenciales almacenadas en AWS Secrets Manager
✅ Encriptación en reposo para RDS y S3
✅ IAM Roles con permisos mínimos necesarios
✅ SSH solo desde IP específica

⚠️ Para Producción
Este proyecto es de aprendizaje. Para producción necesitarías:

Implementar HTTPS con certificados SSL
Usar ALB (Application Load Balancer)
Implementar autenticación de usuarios (JWT)
Agregar rate limiting
Implementar backups automáticos
Usar RDS Multi-AZ
Agregar monitoring con CloudWatch
Implementar CI/CD con GitHub Actions


📝 Archivos Importantes
.gitignore
gitignore# Credenciales y archivos sensibles
*.pem
*.key
*.ppk
terraform.tfstate*
*.tfvars
.env

# Terraform
.terraform/
.terraform.lock.hcl

# Node
node_modules/
dist/

# Python
__pycache__/
venv/
terraform.tfvars.example
hcl# Copia este archivo como terraform.tfvars y edita los valores

project_name = "flight-booking"
environment  = "dev"
aws_region   = "us-east-1"
owner        = "Tu Nombre"

# IMPORTANTE: Cambia por tu IP pública
my_ip = "0.0.0.0/0"  # Para desarrollo, en producción usa tu IP específica

key_name = "flight-booking-key"

# EC2
ec2_instance_type    = "t2.micro"
ec2_root_volume_size = 20

# RDS
rds_instance_class    = "db.t3.micro"
rds_allocated_storage = 20
rds_engine_version    = "14.13"
rds_database_name     = "flightbookingdb"
rds_username          = "flightadmin"

# S3
s3_versioning_enabled = true

🐛 Troubleshooting
Problema: Terraform no encuentra outputs
Solución:
terraform refresh
terraform output
Problema: No puedo conectarme por SSH
Solución:
# Verificar permisos de la llave
chmod 400 flight-booking-key.pem

# Verificar IP en Security Group
# Debe coincidir con tu IP pública actual
Problema: RDS Connection Error
Solución:

Verifica que el Security Group de RDS permita conexiones desde EC2
Verifica que la URL de conexión en docker-compose.yml sea correcta
Verifica que las credenciales sean correctas

Problema: Frontend no carga
Solución:
# Ver logs del contenedor
docker-compose logs frontend

# Verificar que el puerto 80 esté abierto
sudo netstat -tulpn | grep :80

# Reconstruir el contenedor
docker-compose up -d --build frontend
Problema: Backend da error 500
Solución:
# Ver logs detallados
docker-compose logs backend

# Verificar conexión a RDS
docker exec -it flight-booking-backend python -c "from main import engine; engine.connect()"

💰 Costos Estimados
Para la configuración actual (todo en Free Tier elegible):

EC2 t2.micro: Gratis (750 horas/mes primer año)
RDS db.t3.micro: Gratis (750 horas/mes primer año)
S3: Gratis (5GB primer año)
Elastic IP: Gratis (mientras esté asociado a una instancia corriendo)
Data Transfer: Primeros 100GB gratis/mes

Total: $0/mes durante el primer año si te mantienes en Free Tier
Después del primer año: ~$15-20/mes

🗑️ Limpieza (Destruir Recursos)
⚠️ IMPORTANTE: Esto eliminará TODA la infraestructura
cd terraform

# Ver qué se va a destruir
terraform plan -destroy

# Destruir todo
terraform destroy
Escribe yes cuando te lo pida.
Esto eliminará:

Instancia EC2
Base de datos RDS (y sus snapshots si configuraste)
Bucket S3
Security Groups
IAM Roles
Key Pairs
Elastic IP


📚 Lo que Aprendí
Durante este proyecto aprendí:

✅ Cómo usar Terraform para crear infraestructura en AWS
✅ Configuración de Security Groups y networking en AWS
✅ Despliegue de aplicaciones con Docker y Docker Compose
✅ Desarrollo de APIs REST con FastAPI
✅ Desarrollo de SPAs con Angular
✅ Integración entre frontend, backend y base de datos
✅ Mejores prácticas de seguridad en AWS
✅ Gestión de secretos y credenciales
✅ Troubleshooting en ambientes cloud

Desafíos que Enfrenté

Versiones de PostgreSQL: AWS cambió las versiones disponibles y tuve que ajustar
Palabras reservadas en RDS: No se puede usar "admin" como usuario
Estructura de Angular: Aprendí la importancia de la estructura correcta del proyecto
Docker networking: Entender cómo se comunican los contenedores
Security Groups: Configurar correctamente los permisos de red