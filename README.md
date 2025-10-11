# 🛫 Flight Booking System - Infraestructura AWS

Mi Infraestructura para un Sistema WEB de Gestión y Reserva de Vuelos.

## 📋 Contenido

- [Descripción](#descripción)
- [Arquitectura](#arquitectura)
- [Requisitos Previos](#requisitos-previos)
- [Instalación](#instalación)
- [Uso](#uso)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Variables](#variables)
- [Outputs](#outputs)
- [Seguridad](#seguridad)
- [Costos Estimados](#costos-estimados)
- [Troubleshooting](#troubleshooting)

## 📝 Descripción

Este proyecto despliega automáticamente toda la infraestructura necesaria en AWS:

- ✅ **EC2**: Servidor Ubuntu con Docker y Docker Compose instalados
- ✅ **RDS**: Base de datos PostgreSQL 15.4
- ✅ **S3**: Bucket para archivos estáticos con website hosting
- ✅ **Security Groups**: Firewall configurado para todos los servicios
- ✅ **IAM**: Roles y permisos para acceso seguro a S3
- ✅ **Key Pair**: Llave SSH generada automáticamente
- ✅ **Elastic IP**: IP pública estática para EC2

## 🏗️ Arquitectura
