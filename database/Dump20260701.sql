-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: menteconecta_platform
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `afiliados`
--

DROP TABLE IF EXISTS `afiliados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `afiliados` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `usuario_id` int unsigned NOT NULL COMMENT 'Referencia a usuario afiliado',
  `recurso_id` int unsigned DEFAULT NULL COMMENT 'Referencia a recurso',
  `plataforma_afiliado` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Plataforma afiliada (Amazon, etc)',
  `codigo_afiliado` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Código único de afiliado',
  `url_afiliado_personalizada` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'URL personalizada del afiliado',
  `comision_porcentaje` decimal(5,2) DEFAULT '5.00' COMMENT 'Porcentaje de comisión',
  `ingresos_generados` decimal(10,2) DEFAULT '0.00' COMMENT 'Ingresos totales generados',
  `estado` enum('activo','pausado','inactivo') COLLATE utf8mb4_unicode_ci DEFAULT 'activo' COMMENT 'Estado',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación',
  PRIMARY KEY (`id`),
  KEY `idx_usuario_id` (`usuario_id`),
  KEY `idx_estado` (`estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Programa de afiliados para generación de ingresos pasivos';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `afiliados`
--

LOCK TABLES `afiliados` WRITE;
/*!40000 ALTER TABLE `afiliados` DISABLE KEYS */;
/*!40000 ALTER TABLE `afiliados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `asistencia_taller`
--

DROP TABLE IF EXISTS `asistencia_taller`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asistencia_taller` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `inscripcion_id` int unsigned NOT NULL COMMENT 'Referencia a inscripción',
  `sesion_id` int unsigned NOT NULL COMMENT 'Referencia a sesión',
  `asistio` tinyint(1) DEFAULT '0' COMMENT '¿Asistió?',
  `fecha_registro` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de registro de asistencia',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_inscripcion_sesion` (`inscripcion_id`,`sesion_id`),
  KEY `idx_sesion_id` (`sesion_id`),
  CONSTRAINT `asistencia_taller_ibfk_1` FOREIGN KEY (`inscripcion_id`) REFERENCES `inscripcion_taller` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `asistencia_taller_ibfk_2` FOREIGN KEY (`sesion_id`) REFERENCES `taller_sesiones` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Registro de asistencia a sesiones de talleres';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asistencia_taller`
--

LOCK TABLES `asistencia_taller` WRITE;
/*!40000 ALTER TABLE `asistencia_taller` DISABLE KEYS */;
/*!40000 ALTER TABLE `asistencia_taller` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bitacora_auditoria`
--

DROP TABLE IF EXISTS `bitacora_auditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bitacora_auditoria` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `usuario_id` int unsigned DEFAULT NULL COMMENT 'Usuario que realizó la acción',
  `tipo_accion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tipo de acción (CREATE, UPDATE, DELETE, etc)',
  `tabla_afectada` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre de tabla afectada',
  `registro_id` int unsigned DEFAULT NULL COMMENT 'ID del registro afectado',
  `descripcion` text COLLATE utf8mb4_unicode_ci COMMENT 'Descripción de la acción',
  `datos_anteriores` json DEFAULT NULL COMMENT 'Datos anteriores (para UPDATE)',
  `datos_nuevos` json DEFAULT NULL COMMENT 'Datos nuevos (para UPDATE)',
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Dirección IP del usuario',
  `fecha_accion` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de acción',
  PRIMARY KEY (`id`),
  KEY `idx_usuario_id` (`usuario_id`),
  KEY `idx_tabla_afectada` (`tabla_afectada`),
  KEY `idx_fecha_accion` (`fecha_accion`),
  KEY `idx_tipo_accion` (`tipo_accion`),
  CONSTRAINT `bitacora_auditoria_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bitácora de auditoría para cumplimiento normativo y seguridad';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bitacora_auditoria`
--

LOCK TABLES `bitacora_auditoria` WRITE;
/*!40000 ALTER TABLE `bitacora_auditoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `bitacora_auditoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categorias_recursos`
--

DROP TABLE IF EXISTS `categorias_recursos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorias_recursos` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `nombre` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre de categoría',
  `descripcion` text COLLATE utf8mb4_unicode_ci COMMENT 'Descripción',
  `icono_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'URL del icono',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`),
  KEY `idx_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Categorías para clasificar recursos';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias_recursos`
--

LOCK TABLES `categorias_recursos` WRITE;
/*!40000 ALTER TABLE `categorias_recursos` DISABLE KEYS */;
INSERT INTO `categorias_recursos` VALUES (1,'Gestión emocional','Recursos para manejar emociones',NULL),(2,'Mindfulness','Técnicas de atención plena',NULL),(3,'Autocuidado','Prácticas de cuidado personal',NULL),(4,'Hábitos saludables','Desarrollo de hábitos positivos',NULL),(5,'Equilibrio vida-trabajo','Balance entre personal y laboral',NULL),(6,'Resiliencia','Capacidad de superación y recuperación',NULL),(7,'Relaciones interpersonales','Mejora de vínculos con otros',NULL);
/*!40000 ALTER TABLE `categorias_recursos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `convenios`
--

DROP TABLE IF EXISTS `convenios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `convenios` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `nombre_institucion` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre de institución',
  `tipo_convenio` enum('clinica','universidad','centro_salud','organizacion_social','otro') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tipo de convenio',
  `descripcion` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Descripción del convenio',
  `contacto_nombre` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Nombre de contacto',
  `contacto_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Email de contacto',
  `contacto_telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Teléfono de contacto',
  `beneficios_para_usuarios` text COLLATE utf8mb4_unicode_ci COMMENT 'Beneficios para usuarios de la plataforma',
  `beneficios_para_institucion` text COLLATE utf8mb4_unicode_ci COMMENT 'Beneficios para la institución',
  `estado` enum('activo','pendiente','suspendido','finalizado') COLLATE utf8mb4_unicode_ci DEFAULT 'pendiente' COMMENT 'Estado',
  `fecha_inicio` date DEFAULT NULL COMMENT 'Fecha de inicio del convenio',
  `fecha_fin` date DEFAULT NULL COMMENT 'Fecha de vencimiento',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación',
  PRIMARY KEY (`id`),
  KEY `idx_estado` (`estado`),
  FULLTEXT KEY `ft_nombre` (`nombre_institucion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Convenios con instituciones (clínicas, universidades, etc)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `convenios`
--

LOCK TABLES `convenios` WRITE;
/*!40000 ALTER TABLE `convenios` DISABLE KEYS */;
/*!40000 ALTER TABLE `convenios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `datos_iniciales_usuario`
--

DROP TABLE IF EXISTS `datos_iniciales_usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `datos_iniciales_usuario` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `usuario_id` int unsigned NOT NULL COMMENT 'Referencia única a usuario',
  `tiene_estres` tinyint(1) DEFAULT '0' COMMENT '¿Ha estado pasando estrés prolongado?',
  `tiene_tristeza` tinyint(1) DEFAULT '0' COMMENT '¿Ha sentido tristeza frecuente?',
  `se_siente_desorientado` tinyint(1) DEFAULT '0' COMMENT '¿Se ha sentido desorientado?',
  `trabaja_actualmente` tinyint(1) DEFAULT '0' COMMENT '¿Actualmente trabaja?',
  `tiene_red_apoyo` tinyint(1) DEFAULT '0' COMMENT '¿Cuenta con red de apoyo?',
  `notas_adicionales` text COLLATE utf8mb4_unicode_ci COMMENT 'Notas adicionales del usuario',
  `fecha_registro` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de registro',
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuario_id` (`usuario_id`),
  KEY `idx_estres` (`tiene_estres`),
  KEY `idx_tristeza` (`tiene_tristeza`),
  CONSTRAINT `datos_iniciales_usuario_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Segmentación inicial de usuarios para matchmaking y recomendaciones';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `datos_iniciales_usuario`
--

LOCK TABLES `datos_iniciales_usuario` WRITE;
/*!40000 ALTER TABLE `datos_iniciales_usuario` DISABLE KEYS */;
INSERT INTO `datos_iniciales_usuario` VALUES (1,1,1,0,1,1,1,NULL,'2026-07-01 16:51:12'),(2,2,1,1,0,1,1,NULL,'2026-07-01 16:51:12'),(3,3,0,0,1,0,0,NULL,'2026-07-01 16:51:12'),(4,4,1,0,0,1,1,NULL,'2026-07-01 16:51:12'),(5,5,0,1,1,1,0,NULL,'2026-07-01 16:51:12'),(6,6,1,1,1,1,1,NULL,'2026-07-01 16:51:12'),(7,7,0,0,0,0,1,NULL,'2026-07-01 16:51:12'),(8,8,1,0,1,1,1,NULL,'2026-07-01 16:51:12'),(9,9,0,1,0,0,0,NULL,'2026-07-01 16:51:12'),(10,10,1,1,0,1,1,NULL,'2026-07-01 16:51:12');
/*!40000 ALTER TABLE `datos_iniciales_usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `diario_emocional`
--

DROP TABLE IF EXISTS `diario_emocional`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `diario_emocional` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `usuario_id` int unsigned NOT NULL COMMENT 'Referencia a usuario',
  `fecha_entrada` date NOT NULL COMMENT 'Fecha de la entrada',
  `contenido` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Contenido escrito por el usuario',
  `estado_privacidad` enum('privado','profesional','compartido') COLLATE utf8mb4_unicode_ci DEFAULT 'privado' COMMENT 'Nivel de privacidad',
  `acceso_profesionales` json DEFAULT NULL COMMENT 'IDs de profesionales con acceso',
  `creado_en` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha/hora de creación',
  `actualizado_en` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha/hora de actualización',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_usuario_fecha` (`usuario_id`,`fecha_entrada`),
  KEY `idx_usuario_fecha` (`usuario_id`,`fecha_entrada`),
  KEY `idx_estado_privacidad` (`estado_privacidad`),
  CONSTRAINT `diario_emocional_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Entradas del diario emocional privado de usuarios';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diario_emocional`
--

LOCK TABLES `diario_emocional` WRITE;
/*!40000 ALTER TABLE `diario_emocional` DISABLE KEYS */;
/*!40000 ALTER TABLE `diario_emocional` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `disponibilidad`
--

DROP TABLE IF EXISTS `disponibilidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disponibilidad` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `usuario_id` int unsigned DEFAULT NULL COMMENT 'Referencia a usuario (NULL si es profesional)',
  `profesional_id` int unsigned DEFAULT NULL COMMENT 'Referencia a profesional (NULL si es usuario)',
  `dia_semana` enum('lunes','martes','miercoles','jueves','viernes','sabado','domingo') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Día de la semana',
  `hora_inicio` time DEFAULT NULL COMMENT 'Hora de inicio',
  `hora_fin` time DEFAULT NULL COMMENT 'Hora de fin',
  `es_activa` tinyint(1) DEFAULT '1' COMMENT '¿Está disponible?',
  `tipo_sesion` enum('online','presencial','ambas') COLLATE utf8mb4_unicode_ci DEFAULT 'ambas' COMMENT 'Tipo de sesión disponible',
  PRIMARY KEY (`id`),
  KEY `profesional_id` (`profesional_id`),
  KEY `idx_usuario_id` (`usuario_id`),
  KEY `idx_dia_semana` (`dia_semana`),
  CONSTRAINT `disponibilidad_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `disponibilidad_ibfk_2` FOREIGN KEY (`profesional_id`) REFERENCES `profesionales` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Disponibilidad horaria de usuarios y profesionales';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `disponibilidad`
--

LOCK TABLES `disponibilidad` WRITE;
/*!40000 ALTER TABLE `disponibilidad` DISABLE KEYS */;
/*!40000 ALTER TABLE `disponibilidad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emocion_dia`
--

DROP TABLE IF EXISTS `emocion_dia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emocion_dia` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `diario_id` int unsigned NOT NULL COMMENT 'Referencia a entrada de diario',
  `personaje_id` int unsigned DEFAULT NULL COMMENT 'Personaje relacionado con la emoción',
  `intensidad` tinyint unsigned DEFAULT NULL COMMENT 'Intensidad de 1 a 10',
  `notas` text COLLATE utf8mb4_unicode_ci COMMENT 'Notas adicionales sobre la emoción',
  PRIMARY KEY (`id`),
  KEY `idx_diario_id` (`diario_id`),
  KEY `idx_personaje_id` (`personaje_id`),
  CONSTRAINT `emocion_dia_ibfk_1` FOREIGN KEY (`diario_id`) REFERENCES `diario_emocional` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `emocion_dia_ibfk_2` FOREIGN KEY (`personaje_id`) REFERENCES `personajes` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Emociones específicas vinculadas a personajes en cada entrada del diario';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emocion_dia`
--

LOCK TABLES `emocion_dia` WRITE;
/*!40000 ALTER TABLE `emocion_dia` DISABLE KEYS */;
/*!40000 ALTER TABLE `emocion_dia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `especialidades`
--

DROP TABLE IF EXISTS `especialidades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `especialidades` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `nombre` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre de especialidad',
  `descripcion` text COLLATE utf8mb4_unicode_ci COMMENT 'Descripción detallada',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`),
  KEY `idx_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Catálogo de especialidades profesionales';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `especialidades`
--

LOCK TABLES `especialidades` WRITE;
/*!40000 ALTER TABLE `especialidades` DISABLE KEYS */;
INSERT INTO `especialidades` VALUES (1,'Psicología Clínica','Diagnóstico y tratamiento de trastornos'),(2,'Psicología Organizacional','Recursos humanos y bienestar laboral'),(3,'Coaching Vocacional','Orientación profesional y carrera'),(4,'Mindfulness','Meditación y atención plena'),(5,'Nutrición y Bienestar','Asesoramiento nutricional integral'),(6,'Terapia Complementaria','Terapias alternativas e integrativas'),(7,'Autoestima y Confianza','Desarrollo personal y seguridad'),(8,'Relaciones Interpersonales','Mejora de habilidades comunicativas');
/*!40000 ALTER TABLE `especialidades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `foro_respuestas`
--

DROP TABLE IF EXISTS `foro_respuestas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `foro_respuestas` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `tema_id` int unsigned NOT NULL COMMENT 'Referencia a tema',
  `usuario_id` int unsigned NOT NULL COMMENT 'Autor de respuesta',
  `contenido` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Contenido de la respuesta',
  `es_solucion` tinyint(1) DEFAULT '0' COMMENT '¿Marca como solución?',
  `numero_votos_positivos` int unsigned DEFAULT '0' COMMENT 'Votos positivos',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación',
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha de edición',
  PRIMARY KEY (`id`),
  KEY `idx_tema_id` (`tema_id`),
  KEY `idx_usuario_id` (`usuario_id`),
  KEY `idx_es_solucion` (`es_solucion`),
  CONSTRAINT `foro_respuestas_ibfk_1` FOREIGN KEY (`tema_id`) REFERENCES `foro_temas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `foro_respuestas_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Respuestas a temas en foros';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `foro_respuestas`
--

LOCK TABLES `foro_respuestas` WRITE;
/*!40000 ALTER TABLE `foro_respuestas` DISABLE KEYS */;
/*!40000 ALTER TABLE `foro_respuestas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `foro_temas`
--

DROP TABLE IF EXISTS `foro_temas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `foro_temas` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `forum_id` int unsigned NOT NULL COMMENT 'Referencia a foro',
  `usuario_id` int unsigned NOT NULL COMMENT 'Creador del tema',
  `titulo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Título del tema',
  `contenido` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Contenido inicial del tema',
  `numero_respuestas` int unsigned DEFAULT '0' COMMENT 'Número de respuestas',
  `vistas` int unsigned DEFAULT '0' COMMENT 'Número de vistas',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación',
  `fecha_ultima_actividad` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Última actividad',
  PRIMARY KEY (`id`),
  KEY `usuario_id` (`usuario_id`),
  KEY `idx_forum_id` (`forum_id`),
  KEY `idx_fecha_creacion` (`fecha_creacion`),
  KEY `idx_foro_temas_forum_fecha` (`forum_id`,`fecha_creacion`),
  FULLTEXT KEY `ft_titulo_contenido` (`titulo`,`contenido`),
  CONSTRAINT `foro_temas_ibfk_1` FOREIGN KEY (`forum_id`) REFERENCES `foros_tematicos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `foro_temas_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Temas de discusión dentro de foros';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `foro_temas`
--

LOCK TABLES `foro_temas` WRITE;
/*!40000 ALTER TABLE `foro_temas` DISABLE KEYS */;
/*!40000 ALTER TABLE `foro_temas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `foros_tematicos`
--

DROP TABLE IF EXISTS `foros_tematicos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `foros_tematicos` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `nombre` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre del foro',
  `descripcion` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Descripción del foro',
  `categoria` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Categoría del foro',
  `reglas_moderacion` text COLLATE utf8mb4_unicode_ci COMMENT 'Reglas de moderación',
  `estado` enum('activo','inactivo','suspendido') COLLATE utf8mb4_unicode_ci DEFAULT 'activo' COMMENT 'Estado',
  `numero_miembros` int unsigned DEFAULT '0' COMMENT 'Número de miembros',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`),
  KEY `idx_nombre` (`nombre`),
  KEY `idx_estado` (`estado`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Foros temáticos de discusión';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `foros_tematicos`
--

LOCK TABLES `foros_tematicos` WRITE;
/*!40000 ALTER TABLE `foros_tematicos` DISABLE KEYS */;
INSERT INTO `foros_tematicos` VALUES (1,'Ansiedad Universitaria','Espacio para estudiantes con estrés académico','salud_mental',NULL,'activo',0,'2026-07-01 16:51:12'),(2,'Gestión Emocional','Técnicas y estrategias para manejar emociones','desarrollo_personal',NULL,'activo',0,'2026-07-01 16:51:12'),(3,'TDAH en Adultos','Comunidad de apoyo para TDAH','salud_mental',NULL,'activo',0,'2026-07-01 16:51:12'),(4,'Autocuidado','Prácticas y hábitos de cuidado personal','bienestar',NULL,'activo',0,'2026-07-01 16:51:12'),(5,'Bienestar Laboral','Equilibrio entre trabajo y vida personal','trabajo',NULL,'activo',0,'2026-07-01 16:51:12'),(6,'Resiliencia y Superación','Historias y consejos sobre resiliencia','desarrollo_personal',NULL,'activo',0,'2026-07-01 16:51:12');
/*!40000 ALTER TABLE `foros_tematicos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inscripcion_taller`
--

DROP TABLE IF EXISTS `inscripcion_taller`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inscripcion_taller` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `usuario_id` int unsigned NOT NULL COMMENT 'Referencia a usuario',
  `taller_id` int unsigned NOT NULL COMMENT 'Referencia a taller',
  `sesion_id` int unsigned DEFAULT NULL COMMENT 'Sesión específica si aplica',
  `fecha_inscripcion` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de inscripción',
  `estado` enum('inscrito','completado','abandonado','suspendido') COLLATE utf8mb4_unicode_ci DEFAULT 'inscrito' COMMENT 'Estado',
  `monto_pagado` decimal(10,2) DEFAULT NULL COMMENT 'Monto pagado por inscripción',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_usuario_taller` (`usuario_id`,`taller_id`),
  KEY `taller_id` (`taller_id`),
  KEY `sesion_id` (`sesion_id`),
  KEY `idx_usuario_id` (`usuario_id`),
  KEY `idx_estado` (`estado`),
  CONSTRAINT `inscripcion_taller_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `inscripcion_taller_ibfk_2` FOREIGN KEY (`taller_id`) REFERENCES `talleres_grupales` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `inscripcion_taller_ibfk_3` FOREIGN KEY (`sesion_id`) REFERENCES `taller_sesiones` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Inscripción de usuarios en talleres grupales';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inscripcion_taller`
--

LOCK TABLES `inscripcion_taller` WRITE;
/*!40000 ALTER TABLE `inscripcion_taller` DISABLE KEYS */;
/*!40000 ALTER TABLE `inscripcion_taller` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logros`
--

DROP TABLE IF EXISTS `logros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logros` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `nombre` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre del logro',
  `descripcion` text COLLATE utf8mb4_unicode_ci COMMENT 'Descripción detallada',
  `tipo_logro` enum('registro','participacion','taller','recursos','objetivos','social') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tipo de logro',
  `puntos` int unsigned DEFAULT '0' COMMENT 'Puntos asociados',
  `icono_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'URL del icono/insignia',
  `condicion_logro` json DEFAULT NULL COMMENT 'Condición JSON para obtener logro',
  `estado` enum('activo','inactivo') COLLATE utf8mb4_unicode_ci DEFAULT 'activo' COMMENT 'Estado',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`),
  KEY `idx_tipo_logro` (`tipo_logro`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Definición de logros, insignias y recompensas del sistema';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logros`
--

LOCK TABLES `logros` WRITE;
/*!40000 ALTER TABLE `logros` DISABLE KEYS */;
INSERT INTO `logros` VALUES (1,'Primer Paso','Completa tu primer registro','registro',10,NULL,NULL,'activo'),(2,'Diario Activo','Escribe en el diario 7 días consecutivos','registro',50,NULL,NULL,'activo'),(3,'Miembro Activo','Participa en 10 publicaciones','participacion',30,NULL,NULL,'activo'),(4,'Explorador','Descubre 5 personajes diferentes','recursos',20,NULL,NULL,'activo'),(5,'Aprendiz','Completa tu primer taller','taller',100,NULL,NULL,'activo'),(6,'Maestro','Completa 5 talleres','taller',250,NULL,NULL,'activo'),(7,'Conectado','Consigue 5 conexiones en la comunidad','social',40,NULL,NULL,'activo'),(8,'Inspirador','Recibe 50 reacciones positivas','social',75,NULL,NULL,'activo');
/*!40000 ALTER TABLE `logros` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `moderadores`
--

DROP TABLE IF EXISTS `moderadores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `moderadores` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `usuario_id` int unsigned NOT NULL COMMENT 'Referencia a usuario',
  `forum_id` int unsigned NOT NULL COMMENT 'Referencia a foro',
  `nivel_moderacion` enum('basico','avanzado','supervisor') COLLATE utf8mb4_unicode_ci DEFAULT 'basico' COMMENT 'Nivel de moderación',
  `fecha_asignacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de asignación',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_usuario_forum` (`usuario_id`,`forum_id`),
  KEY `idx_forum_id` (`forum_id`),
  CONSTRAINT `moderadores_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `moderadores_ibfk_2` FOREIGN KEY (`forum_id`) REFERENCES `foros_tematicos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Asignación de moderadores a foros temáticos';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `moderadores`
--

LOCK TABLES `moderadores` WRITE;
/*!40000 ALTER TABLE `moderadores` DISABLE KEYS */;
/*!40000 ALTER TABLE `moderadores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pagos`
--

DROP TABLE IF EXISTS `pagos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagos` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `usuario_id` int unsigned NOT NULL COMMENT 'Referencia a usuario',
  `tipo_pago` enum('sesion_profesional','taller','recurso_premium','suscripcion') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tipo de pago',
  `referencia_id` int unsigned DEFAULT NULL COMMENT 'ID de lo que se pagó',
  `monto` decimal(10,2) NOT NULL COMMENT 'Monto pagado',
  `moneda` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT 'USD' COMMENT 'Moneda',
  `estado_pago` enum('pendiente','pagado','fallido','reembolsado') COLLATE utf8mb4_unicode_ci DEFAULT 'pendiente' COMMENT 'Estado',
  `metodo_pago` enum('tarjeta_credito','paypal','transferencia','otro') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Método de pago',
  `referencia_transaccion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ID de transacción del gateway',
  `fecha_pago` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de pago',
  `fecha_reembolso` timestamp NULL DEFAULT NULL COMMENT 'Fecha de reembolso si aplica',
  `notas` text COLLATE utf8mb4_unicode_ci COMMENT 'Notas adicionales',
  PRIMARY KEY (`id`),
  KEY `idx_usuario_id` (`usuario_id`),
  KEY `idx_estado_pago` (`estado_pago`),
  KEY `idx_fecha_pago` (`fecha_pago`),
  KEY `idx_pagos_usuario_fecha` (`usuario_id`,`fecha_pago`),
  CONSTRAINT `pagos_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Registro de todas las transacciones y pagos en la plataforma';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagos`
--

LOCK TABLES `pagos` WRITE;
/*!40000 ALTER TABLE `pagos` DISABLE KEYS */;
/*!40000 ALTER TABLE `pagos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personaje_problema`
--

DROP TABLE IF EXISTS `personaje_problema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personaje_problema` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `personaje_id` int unsigned NOT NULL COMMENT 'Referencia a personaje',
  `problema_id` int unsigned NOT NULL COMMENT 'Referencia a problema',
  `descripcion` text COLLATE utf8mb4_unicode_ci COMMENT 'Cómo el personaje vivió este problema',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_personaje_problema` (`personaje_id`,`problema_id`),
  KEY `idx_personaje_id` (`personaje_id`),
  KEY `idx_problema_id` (`problema_id`),
  CONSTRAINT `personaje_problema_ibfk_1` FOREIGN KEY (`personaje_id`) REFERENCES `personajes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `personaje_problema_ibfk_2` FOREIGN KEY (`problema_id`) REFERENCES `problemas_emocionales` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Vinculación entre personajes y problemas emocionales';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personaje_problema`
--

LOCK TABLES `personaje_problema` WRITE;
/*!40000 ALTER TABLE `personaje_problema` DISABLE KEYS */;
/*!40000 ALTER TABLE `personaje_problema` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personajes`
--

DROP TABLE IF EXISTS `personajes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personajes` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `nombre` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre del personaje',
  `origen` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Origen/fuente del personaje',
  `tipo_personaje` enum('ficticio','historico','celebridad','serie','anime','videojuego') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tipo de personaje',
  `descripcion` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Descripción del personaje',
  `historia_superacion` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Historia de superación del personaje',
  `imagen_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'URL de imagen del personaje',
  `datos_fandom_json` json DEFAULT NULL COMMENT 'Datos extraídos de Fandom API',
  `analisis_ia` json DEFAULT NULL COMMENT 'Análisis generado por IA',
  `estado` enum('activo','inactivo') COLLATE utf8mb4_unicode_ci DEFAULT 'activo' COMMENT 'Estado',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación',
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Última actualización',
  PRIMARY KEY (`id`),
  KEY `idx_tipo` (`tipo_personaje`),
  KEY `idx_estado` (`estado`),
  FULLTEXT KEY `ft_nombre` (`nombre`,`descripcion`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Personajes que representan emociones y situaciones';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personajes`
--

LOCK TABLES `personajes` WRITE;
/*!40000 ALTER TABLE `personajes` DISABLE KEYS */;
INSERT INTO `personajes` VALUES (1,'Clark Kent/Superman','DC Comics','ficticio','Superhéroe que lucha con su identidad dual y el peso de las responsabilidades',NULL,NULL,NULL,NULL,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12'),(2,'Nelson Mandela','Historia','historico','Líder que superó 27 años de encarcelamiento',NULL,NULL,NULL,NULL,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12'),(3,'Oprah Winfrey','Personajes Reales','celebridad','Emprendedora que superó pobreza y discriminación',NULL,NULL,NULL,NULL,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12'),(4,'Elliot Alderson','Mr. Robot','serie','Personaje con ansiedad social que busca propósito y justicia',NULL,NULL,NULL,NULL,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12'),(5,'Luffy','One Piece','anime','Pirata determinado que busca sus sueños a pesar de los obstáculos',NULL,NULL,NULL,NULL,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12'),(6,'Walter White','Breaking Bad','serie','Hombre ordinario que enfrenta enfermedad y transformación personal',NULL,NULL,NULL,NULL,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12');
/*!40000 ALTER TABLE `personajes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `problemas_emocionales`
--

DROP TABLE IF EXISTS `problemas_emocionales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `problemas_emocionales` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `nombre` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre del problema',
  `descripcion` text COLLATE utf8mb4_unicode_ci COMMENT 'Descripción detallada',
  `estado` enum('activo','inactivo') COLLATE utf8mb4_unicode_ci DEFAULT 'activo' COMMENT 'Estado',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`),
  KEY `idx_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Catálogo de problemas emocionales (ansiedad, estrés, soledad, duelo, etc)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `problemas_emocionales`
--

LOCK TABLES `problemas_emocionales` WRITE;
/*!40000 ALTER TABLE `problemas_emocionales` DISABLE KEYS */;
INSERT INTO `problemas_emocionales` VALUES (1,'Ansiedad','Preocupación excesiva y persistente','activo'),(2,'Estrés','Tensión emocional por presiones','activo'),(3,'Soledad','Sentimiento de aislamiento y desconexión','activo'),(4,'Duelo','Pérdida y dolor emocional','activo'),(5,'Baja autoestima','Falta de confianza en uno mismo','activo'),(6,'Crisis vocacional','Confusión sobre dirección profesional','activo'),(7,'Burnout','Agotamiento emocional y laboral','activo'),(8,'Crecimiento personal','Búsqueda de desarrollo y mejora','activo');
/*!40000 ALTER TABLE `problemas_emocionales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profesional_especialidad`
--

DROP TABLE IF EXISTS `profesional_especialidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `profesional_especialidad` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `profesional_id` int unsigned NOT NULL COMMENT 'Referencia a profesional',
  `especialidad_id` int unsigned NOT NULL COMMENT 'Referencia a especialidad',
  `nivel_expertise` enum('basico','intermedio','avanzado','experto') COLLATE utf8mb4_unicode_ci DEFAULT 'intermedio' COMMENT 'Nivel de expertise',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_profesional_especialidad` (`profesional_id`,`especialidad_id`),
  KEY `especialidad_id` (`especialidad_id`),
  KEY `idx_profesional_id` (`profesional_id`),
  CONSTRAINT `profesional_especialidad_ibfk_1` FOREIGN KEY (`profesional_id`) REFERENCES `profesionales` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `profesional_especialidad_ibfk_2` FOREIGN KEY (`especialidad_id`) REFERENCES `especialidades` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Especialidades múltiples de cada profesional (relación N:M)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profesional_especialidad`
--

LOCK TABLES `profesional_especialidad` WRITE;
/*!40000 ALTER TABLE `profesional_especialidad` DISABLE KEYS */;
/*!40000 ALTER TABLE `profesional_especialidad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profesionales`
--

DROP TABLE IF EXISTS `profesionales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `profesionales` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `usuario_id` int unsigned NOT NULL COMMENT 'Referencia a usuario',
  `licencia_profesional` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Número de licencia/cédula',
  `especialidad_principal_id` int unsigned DEFAULT NULL COMMENT 'Especialidad principal',
  `descripcion_profesional` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Descripción profesional',
  `es_voluntario` tinyint(1) DEFAULT '0' COMMENT '¿Es voluntario?',
  `tarifa_sesion` decimal(10,2) DEFAULT NULL COMMENT 'Tarifa por sesión en dólares',
  `biografia_profesional` text COLLATE utf8mb4_unicode_ci COMMENT 'Biografía profesional extendida',
  `anos_experiencia` int DEFAULT NULL COMMENT 'Años de experiencia',
  `idiomas` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Idiomas que habla',
  `estado` enum('activo','inactivo','suspendido') COLLATE utf8mb4_unicode_ci DEFAULT 'activo' COMMENT 'Estado',
  `fecha_registro` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de registro',
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Última actualización',
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuario_id` (`usuario_id`),
  KEY `idx_estado` (`estado`),
  KEY `idx_especialidad` (`especialidad_principal_id`),
  KEY `idx_es_voluntario` (`es_voluntario`),
  KEY `idx_profesionales_tarifa` (`tarifa_sesion`,`estado`),
  CONSTRAINT `profesionales_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `profesionales_ibfk_2` FOREIGN KEY (`especialidad_principal_id`) REFERENCES `especialidades` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Perfil profesional en la plataforma (psicólogos, coaches, mentores, etc)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profesionales`
--

LOCK TABLES `profesionales` WRITE;
/*!40000 ALTER TABLE `profesionales` DISABLE KEYS */;
INSERT INTO `profesionales` VALUES (1,11,'LC-12345',1,NULL,0,80.00,NULL,15,NULL,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12'),(2,12,'LC-67890',4,NULL,0,60.00,NULL,8,NULL,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12'),(3,13,'LC-54321',1,NULL,1,50.00,NULL,5,NULL,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12'),(4,14,'LC-98765',2,NULL,0,75.00,NULL,10,NULL,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12');
/*!40000 ALTER TABLE `profesionales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recurso_categoria`
--

DROP TABLE IF EXISTS `recurso_categoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recurso_categoria` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `recurso_id` int unsigned NOT NULL COMMENT 'Referencia a recurso',
  `categoria_id` int unsigned NOT NULL COMMENT 'Referencia a categoría',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_recurso_categoria` (`recurso_id`,`categoria_id`),
  KEY `idx_recurso_id` (`recurso_id`),
  KEY `idx_categoria_id` (`categoria_id`),
  CONSTRAINT `recurso_categoria_ibfk_1` FOREIGN KEY (`recurso_id`) REFERENCES `recursos_digitales` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `recurso_categoria_ibfk_2` FOREIGN KEY (`categoria_id`) REFERENCES `categorias_recursos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Clasificación de recursos en múltiples categorías (relación N:M)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recurso_categoria`
--

LOCK TABLES `recurso_categoria` WRITE;
/*!40000 ALTER TABLE `recurso_categoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `recurso_categoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recursos_descargados`
--

DROP TABLE IF EXISTS `recursos_descargados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recursos_descargados` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `usuario_id` int unsigned NOT NULL COMMENT 'Referencia a usuario',
  `recurso_id` int unsigned NOT NULL COMMENT 'Referencia a recurso',
  `fecha_descarga` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de descarga',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_usuario_recurso` (`usuario_id`,`recurso_id`),
  KEY `recurso_id` (`recurso_id`),
  KEY `idx_usuario_id` (`usuario_id`),
  KEY `idx_fecha_descarga` (`fecha_descarga`),
  CONSTRAINT `recursos_descargados_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `recursos_descargados_ibfk_2` FOREIGN KEY (`recurso_id`) REFERENCES `recursos_digitales` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Registro de descargas de recursos por usuarios';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recursos_descargados`
--

LOCK TABLES `recursos_descargados` WRITE;
/*!40000 ALTER TABLE `recursos_descargados` DISABLE KEYS */;
/*!40000 ALTER TABLE `recursos_descargados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recursos_digitales`
--

DROP TABLE IF EXISTS `recursos_digitales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recursos_digitales` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `titulo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Título del recurso',
  `descripcion` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Descripción detallada',
  `tipo_contenido` enum('articulo','video','podcast','libro','documento','infografia','otro') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tipo de contenido',
  `autor` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Autor del recurso',
  `url_contenido` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'URL al contenido',
  `duracion_minutos` int unsigned DEFAULT NULL COMMENT 'Duración en minutos',
  `imagen_portada_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'URL de imagen de portada',
  `es_premium` tinyint(1) DEFAULT '0' COMMENT '¿Es contenido premium?',
  `precio` decimal(10,2) DEFAULT NULL COMMENT 'Precio si es premium',
  `codigo_afiliado` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Código de afiliado',
  `url_afiliado` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'URL afiliado',
  `vistas` int unsigned DEFAULT '0' COMMENT 'Número de vistas',
  `estado` enum('activo','inactivo','eliminado') COLLATE utf8mb4_unicode_ci DEFAULT 'activo' COMMENT 'Estado',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación',
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Última actualización',
  PRIMARY KEY (`id`),
  KEY `idx_tipo` (`tipo_contenido`),
  KEY `idx_estado` (`estado`),
  KEY `idx_es_premium` (`es_premium`),
  FULLTEXT KEY `ft_titulo_descripcion` (`titulo`,`descripcion`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Biblioteca digital con artículos, videos, podcasts, etc';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recursos_digitales`
--

LOCK TABLES `recursos_digitales` WRITE;
/*!40000 ALTER TABLE `recursos_digitales` DISABLE KEYS */;
INSERT INTO `recursos_digitales` VALUES (1,'Introducción a Mindfulness','Guía completa para principiantes en meditación','articulo','Sistema Bienestar',NULL,NULL,NULL,0,NULL,NULL,NULL,0,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12'),(2,'Meditación diaria 10 minutos','Meditación guiada para relajación profunda','video','Coach Maya',NULL,NULL,NULL,1,9.99,NULL,NULL,0,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12'),(3,'Podcast: Vidas Transformadas','Historias inspiradoras de superación personal','podcast','Red Bienestar',NULL,NULL,NULL,0,NULL,NULL,NULL,0,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12'),(4,'Manual de Gestión del Estrés','Técnicas prácticas y efectivas comprobadas','documento','Dr. Roberto',NULL,NULL,NULL,1,14.99,NULL,NULL,0,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12'),(5,'Infografía: 7 Hábitos Saludables','Guía visual de buenos hábitos cotidianos','infografia','Sistema Bienestar',NULL,NULL,NULL,0,NULL,NULL,NULL,0,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12'),(6,'El Arte de la Resiliencia','Libro sobre cómo superar adversidades','libro','Patricia González',NULL,NULL,NULL,1,19.99,NULL,NULL,0,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12'),(7,'Yoga para la Ansiedad','Video tutorial de 30 minutos de yoga','video','Instructor Luis',NULL,NULL,NULL,0,NULL,NULL,NULL,0,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12'),(8,'Relaciones Sanas','Artículo sobre comunicación efectiva','articulo','Psicóloga Carla',NULL,NULL,NULL,0,NULL,NULL,NULL,0,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12'),(9,'Podcast: Bienestar Mental','Episodios semanales sobre salud mental','podcast','Dr. Sistema',NULL,NULL,NULL,1,4.99,NULL,NULL,0,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12'),(10,'Diario de Gratitud Digital','Aplicación web para registro diario','documento','Tech Wellness',NULL,NULL,NULL,0,NULL,NULL,NULL,0,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12');
/*!40000 ALTER TABLE `recursos_digitales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reportes_contenido`
--

DROP TABLE IF EXISTS `reportes_contenido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reportes_contenido` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `usuario_id` int unsigned NOT NULL COMMENT 'Usuario que reporta',
  `tipo_contenido` enum('post','comentario','tema_foro','respuesta_foro') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tipo de contenido reportado',
  `contenido_id` int unsigned NOT NULL COMMENT 'ID del contenido reportado',
  `motivo` enum('ofensivo','spam','acoso','falso_danino','otro') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Motivo del reporte',
  `descripcion` text COLLATE utf8mb4_unicode_ci COMMENT 'Descripción del problema',
  `estado` enum('pendiente','revisar','resuelto','desestimado') COLLATE utf8mb4_unicode_ci DEFAULT 'pendiente' COMMENT 'Estado del reporte',
  `fecha_reporte` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha del reporte',
  PRIMARY KEY (`id`),
  KEY `usuario_id` (`usuario_id`),
  KEY `idx_estado` (`estado`),
  KEY `idx_fecha_reporte` (`fecha_reporte`),
  CONSTRAINT `reportes_contenido_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Sistema de reportes de contenido inapropiado';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reportes_contenido`
--

LOCK TABLES `reportes_contenido` WRITE;
/*!40000 ALTER TABLE `reportes_contenido` DISABLE KEYS */;
/*!40000 ALTER TABLE `reportes_contenido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único del rol',
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre del rol',
  `descripcion` text COLLATE utf8mb4_unicode_ci COMMENT 'Descripción del rol',
  `permisos_json` json DEFAULT NULL COMMENT 'Permisos en formato JSON',
  `estado` enum('activo','inactivo') COLLATE utf8mb4_unicode_ci DEFAULT 'activo' COMMENT 'Estado del rol',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`),
  KEY `idx_nombre` (`nombre`),
  KEY `idx_estado` (`estado`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Almacena roles del sistema (usuario, profesional, admin, moderador, etc)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'usuario','Usuario regular de la plataforma','{\"comentar\": true, \"crear_posts\": true, \"leer_recursos\": true}','activo','2026-07-01 16:51:12'),(2,'profesional','Profesional de salud (psicólogo, coach, etc)','{\"ver_fichas\": true, \"crear_recursos\": true, \"crear_sesiones\": true}','activo','2026-07-01 16:51:12'),(3,'voluntario','Profesional voluntario con sesiones limitadas','{\"sesiones_max\": 2, \"crear_sesiones\": true}','activo','2026-07-01 16:51:12'),(4,'moderador','Moderador de comunidad y foros','{\"bannear_usuarios\": true, \"eliminar_contenido\": true}','activo','2026-07-01 16:51:12'),(5,'admin','Administrador del sistema','{\"all_permissions\": true}','activo','2026-07-01 16:51:12'),(6,'supervisor','Supervisor de profesionales','{\"evaluar\": true, \"supervisar\": true}','activo','2026-07-01 16:51:12');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sesiones_medicas`
--

DROP TABLE IF EXISTS `sesiones_medicas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sesiones_medicas` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `usuario_id` int unsigned NOT NULL COMMENT 'Referencia a usuario',
  `profesional_id` int unsigned NOT NULL COMMENT 'Referencia a profesional',
  `fecha_sesion` datetime NOT NULL COMMENT 'Fecha y hora de sesión',
  `duracion_minutos` int unsigned DEFAULT '45' COMMENT 'Duración en minutos',
  `tipo_sesion` enum('online','presencial') COLLATE utf8mb4_unicode_ci DEFAULT 'online' COMMENT 'Tipo de sesión',
  `estado_sesion` enum('programada','en_progreso','completada','cancelada','no_asistio') COLLATE utf8mb4_unicode_ci DEFAULT 'programada' COMMENT 'Estado',
  `url_videollamada` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'URL generada para videollamada',
  `token_videollamada` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Token de autenticación para videollamada',
  `archivo_grabacion` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'URL del archivo de grabación',
  `consentimiento_grabacion` tinyint(1) DEFAULT '0' COMMENT '¿Consentimiento para grabar?',
  `monto_pagado` decimal(10,2) DEFAULT NULL COMMENT 'Monto pagado',
  `notas_clinicas` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Notas clínicas de la sesión',
  `diagnostico_preliminar` text COLLATE utf8mb4_unicode_ci COMMENT 'Diagnóstico preliminar (encriptado)',
  `recomendaciones` text COLLATE utf8mb4_unicode_ci COMMENT 'Recomendaciones para el usuario',
  `proxima_sesion` datetime DEFAULT NULL COMMENT 'Fecha de próxima sesión sugerida',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación de sesión',
  PRIMARY KEY (`id`),
  KEY `idx_usuario_id` (`usuario_id`),
  KEY `idx_profesional_id` (`profesional_id`),
  KEY `idx_fecha_sesion` (`fecha_sesion`),
  KEY `idx_estado_sesion` (`estado_sesion`),
  KEY `idx_sesiones_medicas_usuario` (`usuario_id`,`fecha_sesion`),
  CONSTRAINT `sesiones_medicas_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sesiones_medicas_ibfk_2` FOREIGN KEY (`profesional_id`) REFERENCES `profesionales` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Sesiones médicas con videollamada, fichas clínicas integradas y grabación segura';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sesiones_medicas`
--

LOCK TABLES `sesiones_medicas` WRITE;
/*!40000 ALTER TABLE `sesiones_medicas` DISABLE KEYS */;
/*!40000 ALTER TABLE `sesiones_medicas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supervisiones`
--

DROP TABLE IF EXISTS `supervisiones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supervisiones` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `supervisor_id` int unsigned NOT NULL COMMENT 'Profesional supervisor',
  `profesional_id` int unsigned NOT NULL COMMENT 'Profesional supervisado',
  `tipo_supervision` enum('individual','grupal','evaluacion') COLLATE utf8mb4_unicode_ci DEFAULT 'individual' COMMENT 'Tipo de supervisión',
  `fecha_supervision` date NOT NULL COMMENT 'Fecha de supervisión',
  `duracion_minutos` int unsigned DEFAULT NULL COMMENT 'Duración en minutos',
  `contenido` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Contenido de la supervisión',
  `observaciones` text COLLATE utf8mb4_unicode_ci COMMENT 'Observaciones del supervisor',
  `areas_mejora` text COLLATE utf8mb4_unicode_ci COMMENT 'Áreas de mejora identificadas',
  `proxima_supervision` date DEFAULT NULL COMMENT 'Fecha próxima supervisión',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de registro',
  PRIMARY KEY (`id`),
  KEY `idx_supervisor_id` (`supervisor_id`),
  KEY `idx_profesional_id` (`profesional_id`),
  KEY `idx_fecha_supervision` (`fecha_supervision`),
  CONSTRAINT `supervisiones_ibfk_1` FOREIGN KEY (`supervisor_id`) REFERENCES `profesionales` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `supervisiones_ibfk_2` FOREIGN KEY (`profesional_id`) REFERENCES `profesionales` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Sistema de supervisiones profesionales y evaluaciones';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supervisiones`
--

LOCK TABLES `supervisiones` WRITE;
/*!40000 ALTER TABLE `supervisiones` DISABLE KEYS */;
/*!40000 ALTER TABLE `supervisiones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taller_sesiones`
--

DROP TABLE IF EXISTS `taller_sesiones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `taller_sesiones` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `taller_id` int unsigned NOT NULL COMMENT 'Referencia a taller',
  `numero_sesion` int unsigned DEFAULT NULL COMMENT 'Número secuencial de sesión',
  `titulo_sesion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Título de la sesión',
  `descripcion_sesion` text COLLATE utf8mb4_unicode_ci COMMENT 'Descripción de esta sesión',
  `fecha_sesion` date NOT NULL COMMENT 'Fecha de la sesión',
  `hora_inicio` time DEFAULT NULL COMMENT 'Hora de inicio',
  `duracion_minutos` int unsigned DEFAULT '60' COMMENT 'Duración en minutos',
  `ubicacion_online` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'URL para conexión online',
  `ubicacion_presencial` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Dirección presencial',
  `capacidad_actual` int unsigned DEFAULT '0' COMMENT 'Participantes actuales',
  PRIMARY KEY (`id`),
  KEY `idx_taller_id` (`taller_id`),
  KEY `idx_fecha_sesion` (`fecha_sesion`),
  CONSTRAINT `taller_sesiones_ibfk_1` FOREIGN KEY (`taller_id`) REFERENCES `talleres_grupales` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Sesiones individuales de los talleres grupales';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taller_sesiones`
--

LOCK TABLES `taller_sesiones` WRITE;
/*!40000 ALTER TABLE `taller_sesiones` DISABLE KEYS */;
/*!40000 ALTER TABLE `taller_sesiones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `talleres_grupales`
--

DROP TABLE IF EXISTS `talleres_grupales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `talleres_grupales` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `titulo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Título del taller',
  `descripcion` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Descripción detallada',
  `instructor_id` int unsigned DEFAULT NULL COMMENT 'Instructor profesional',
  `tipo_taller` enum('online','presencial','hibrido') COLLATE utf8mb4_unicode_ci DEFAULT 'online' COMMENT 'Tipo de taller',
  `es_gratuito` tinyint(1) DEFAULT '0' COMMENT '¿Es gratuito?',
  `precio` decimal(10,2) DEFAULT NULL COMMENT 'Precio si no es gratuito',
  `max_participantes` int unsigned DEFAULT NULL COMMENT 'Máximo de participantes',
  `duracion_total_horas` int unsigned DEFAULT NULL COMMENT 'Duración total en horas',
  `estado` enum('planificado','en_curso','completado','cancelado') COLLATE utf8mb4_unicode_ci DEFAULT 'planificado' COMMENT 'Estado',
  `fecha_inicio` date DEFAULT NULL COMMENT 'Fecha de inicio',
  `fecha_fin` date DEFAULT NULL COMMENT 'Fecha de fin',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación',
  PRIMARY KEY (`id`),
  KEY `instructor_id` (`instructor_id`),
  KEY `idx_estado` (`estado`),
  KEY `idx_tipo_taller` (`tipo_taller`),
  FULLTEXT KEY `ft_titulo` (`titulo`),
  CONSTRAINT `talleres_grupales_ibfk_1` FOREIGN KEY (`instructor_id`) REFERENCES `profesionales` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Talleres grupales (online y presenciales)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `talleres_grupales`
--

LOCK TABLES `talleres_grupales` WRITE;
/*!40000 ALTER TABLE `talleres_grupales` DISABLE KEYS */;
/*!40000 ALTER TABLE `talleres_grupales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario_logros`
--

DROP TABLE IF EXISTS `usuario_logros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario_logros` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `usuario_id` int unsigned NOT NULL COMMENT 'Referencia a usuario',
  `logro_id` int unsigned NOT NULL COMMENT 'Referencia a logro',
  `fecha_desbloqueado` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de desbloqueo',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_usuario_logro` (`usuario_id`,`logro_id`),
  KEY `logro_id` (`logro_id`),
  KEY `idx_usuario_id` (`usuario_id`),
  KEY `idx_fecha_desbloqueado` (`fecha_desbloqueado`),
  CONSTRAINT `usuario_logros_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `usuario_logros_ibfk_2` FOREIGN KEY (`logro_id`) REFERENCES `logros` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Logros desbloqueados por cada usuario';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario_logros`
--

LOCK TABLES `usuario_logros` WRITE;
/*!40000 ALTER TABLE `usuario_logros` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_logros` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario_roles`
--

DROP TABLE IF EXISTS `usuario_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario_roles` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `usuario_id` int unsigned NOT NULL COMMENT 'Referencia a usuario',
  `rol_id` int unsigned NOT NULL COMMENT 'Referencia a rol',
  `fecha_asignacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de asignación',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_usuario_rol` (`usuario_id`,`rol_id`),
  KEY `idx_usuario_id` (`usuario_id`),
  KEY `idx_rol_id` (`rol_id`),
  CONSTRAINT `usuario_roles_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `usuario_roles_ibfk_2` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Asignación de roles a usuarios (relación N:M)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario_roles`
--

LOCK TABLES `usuario_roles` WRITE;
/*!40000 ALTER TABLE `usuario_roles` DISABLE KEYS */;
INSERT INTO `usuario_roles` VALUES (1,1,1,'2026-07-01 16:51:12'),(2,2,1,'2026-07-01 16:51:12'),(3,3,1,'2026-07-01 16:51:12'),(4,4,1,'2026-07-01 16:51:12'),(5,5,1,'2026-07-01 16:51:12'),(6,6,1,'2026-07-01 16:51:12'),(7,7,1,'2026-07-01 16:51:12'),(8,8,1,'2026-07-01 16:51:12'),(9,9,1,'2026-07-01 16:51:12'),(10,10,1,'2026-07-01 16:51:12'),(11,11,2,'2026-07-01 16:51:12'),(12,12,2,'2026-07-01 16:51:12'),(13,13,2,'2026-07-01 16:51:12'),(14,14,2,'2026-07-01 16:51:12');
/*!40000 ALTER TABLE `usuario_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único del usuario',
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Email único del usuario',
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Hash de contraseña (bcrypt)',
  `nombres` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombres del usuario',
  `apellidos` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Apellidos del usuario',
  `fecha_nacimiento` date DEFAULT NULL COMMENT 'Fecha de nacimiento',
  `genero` enum('masculino','femenino','otro','prefiero_no_decir') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Género del usuario',
  `estado_civil` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Estado civil',
  `ciudad` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Ciudad de residencia',
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Teléfono de contacto',
  `bio` text COLLATE utf8mb4_unicode_ci COMMENT 'Biografía/descripción personal',
  `estado` enum('activo','inactivo','suspendido') COLLATE utf8mb4_unicode_ci DEFAULT 'activo' COMMENT 'Estado del usuario',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de registro',
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Última actualización',
  `fecha_ultimo_login` datetime DEFAULT NULL COMMENT 'Última fecha de login',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_email` (`email`),
  KEY `idx_estado` (`estado`),
  KEY `idx_fecha_creacion` (`fecha_creacion`),
  KEY `idx_usuarios_estado_fecha` (`estado`,`fecha_creacion`),
  KEY `idx_usuario_email` (`email`),
  FULLTEXT KEY `ft_nombres` (`nombres`,`apellidos`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tabla principal de usuarios del sistema';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'juan.garcia@example.com','$2b$10$abcdefghijklmnopqrstuvwxyz','Juan','García','1990-05-15','masculino',NULL,'Santiago',NULL,NULL,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12',NULL),(2,'maria.lopez@example.com','$2b$10$abcdefghijklmnopqrstuvwxyz','María','López','1995-08-22','femenino',NULL,'Valparaíso',NULL,NULL,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12',NULL),(3,'carlos.rodriguez@example.com','$2b$10$abcdefghijklmnopqrstuvwxyz','Carlos','Rodríguez','1988-03-10','masculino',NULL,'Concepción',NULL,NULL,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12',NULL),(4,'ana.martinez@example.com','$2b$10$abcdefghijklmnopqrstuvwxyz','Ana','Martínez','1985-07-18','femenino',NULL,'Santiago',NULL,NULL,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12',NULL),(5,'luis.perez@example.com','$2b$10$abcdefghijklmnopqrstuvwxyz','Luis','Pérez','1992-11-30','masculino',NULL,'La Florida',NULL,NULL,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12',NULL),(6,'sofia.diaz@example.com','$2b$10$abcdefghijklmnopqrstuvwxyz','Sofía','Díaz','1998-02-14','femenino',NULL,'Ñuñoa',NULL,NULL,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12',NULL),(7,'diego.torres@example.com','$2b$10$abcdefghijklmnopqrstuvwxyz','Diego','Torres','1987-09-05','masculino',NULL,'Providencia',NULL,NULL,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12',NULL),(8,'rosa.flores@example.com','$2b$10$abcdefghijklmnopqrstuvwxyz','Rosa','Flores','1993-06-20','femenino',NULL,'Vitacura',NULL,NULL,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12',NULL),(9,'pablo.silva@example.com','$2b$10$abcdefghijklmnopqrstuvwxyz','Pablo','Silva','1989-01-12','masculino',NULL,'Carabineros',NULL,NULL,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12',NULL),(10,'laura.morales@example.com','$2b$10$abcdefghijklmnopqrstuvwxyz','Laura','Morales','1996-04-08','femenino',NULL,'Maipú',NULL,NULL,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12',NULL),(11,'dr.alberto.silva@example.com','$2b$10$abcdefghijklmnopqrstuvwxyz','Alberto','Silva','1970-12-05','masculino',NULL,'Santiago',NULL,NULL,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12',NULL),(12,'coach.ana.terapia@example.com','$2b$10$abcdefghijklmnopqrstuvwxyz','Ana Cecilia','Terapista','1981-07-18','femenino',NULL,'Santiago',NULL,NULL,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12',NULL),(13,'psic.gonzalo@example.com','$2b$10$abcdefghijklmnopqrstuvwxyz','Gonzalo','Ramírez','1975-03-22','masculino',NULL,'Las Condes',NULL,NULL,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12',NULL),(14,'menta.carolina@example.com','$2b$10$abcdefghijklmnopqrstuvwxyz','Carolina','Mendoza','1988-10-15','femenino',NULL,'Independencia',NULL,NULL,'activo','2026-07-01 16:51:12','2026-07-01 16:51:12',NULL);
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `valoraciones_profesional`
--

DROP TABLE IF EXISTS `valoraciones_profesional`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `valoraciones_profesional` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID único',
  `sesion_medica_id` int unsigned DEFAULT NULL COMMENT 'Referencia a sesión médica completada',
  `usuario_id` int unsigned NOT NULL COMMENT 'Referencia a usuario evaluador',
  `profesional_id` int unsigned NOT NULL COMMENT 'Referencia a profesional evaluado',
  `puntuacion` decimal(3,2) NOT NULL COMMENT 'Puntuación de 1 a 5',
  `comentario` text COLLATE utf8mb4_unicode_ci COMMENT 'Comentario detallado de la valoración',
  `aspectos_positivos` text COLLATE utf8mb4_unicode_ci COMMENT 'Aspectos positivos',
  `aspectos_mejora` text COLLATE utf8mb4_unicode_ci COMMENT 'Aspectos a mejorar',
  `recomendaria` tinyint(1) DEFAULT '1' COMMENT '¿Recomendaría al profesional?',
  `fecha_valoracion` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de valoración',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_usuario_profesional_fecha` (`usuario_id`,`profesional_id`,`fecha_valoracion`),
  KEY `sesion_medica_id` (`sesion_medica_id`),
  KEY `idx_profesional_id` (`profesional_id`),
  KEY `idx_puntuacion` (`puntuacion`),
  CONSTRAINT `valoraciones_profesional_ibfk_1` FOREIGN KEY (`sesion_medica_id`) REFERENCES `sesiones_medicas` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `valoraciones_profesional_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `valoraciones_profesional_ibfk_3` FOREIGN KEY (`profesional_id`) REFERENCES `profesionales` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Valoraciones y reseñas de profesionales por usuarios';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `valoraciones_profesional`
--

LOCK TABLES `valoraciones_profesional` WRITE;
/*!40000 ALTER TABLE `valoraciones_profesional` DISABLE KEYS */;
/*!40000 ALTER TABLE `valoraciones_profesional` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-01 13:00:54
