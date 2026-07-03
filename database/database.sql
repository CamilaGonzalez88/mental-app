-- ============================================================================

DROP DATABASE IF EXISTS menteconecta_platform;
CREATE DATABASE menteconecta_platform
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE menteconecta_platform;

-- ============================================================================
-- TABLA: ROLES
-- ============================================================================
CREATE TABLE roles (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único del rol',
    nombre VARCHAR(100) NOT NULL UNIQUE COMMENT 'Nombre del rol',
    descripcion TEXT COMMENT 'Descripción del rol',
    permisos_json JSON COMMENT 'Permisos en formato JSON',
    estado ENUM('activo', 'inactivo') DEFAULT 'activo' COMMENT 'Estado del rol',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación',
    INDEX idx_nombre (nombre),
    INDEX idx_estado (estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Almacena roles del sistema (usuario, profesional, admin, moderador, etc)';

-- ============================================================================
-- TABLA: USUARIOS
-- ============================================================================
CREATE TABLE usuarios (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único del usuario',
    email VARCHAR(255) NOT NULL UNIQUE COMMENT 'Email único del usuario',
    password_hash VARCHAR(255) NOT NULL COMMENT 'Hash de contraseña (bcrypt)',
    nombres VARCHAR(100) NOT NULL COMMENT 'Nombres del usuario',
    apellidos VARCHAR(100) NOT NULL COMMENT 'Apellidos del usuario',
    fecha_nacimiento DATE COMMENT 'Fecha de nacimiento',
    genero ENUM('masculino', 'femenino', 'otro', 'prefiero_no_decir') COMMENT 'Género del usuario',
    estado_civil VARCHAR(50) COMMENT 'Estado civil',
    ciudad VARCHAR(100) COMMENT 'Ciudad de residencia',
    telefono VARCHAR(20) COMMENT 'Teléfono de contacto',
    bio TEXT COMMENT 'Biografía/descripción personal',
    estado ENUM('activo', 'inactivo', 'suspendido') DEFAULT 'activo' COMMENT 'Estado del usuario',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de registro',
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Última actualización',
    fecha_ultimo_login DATETIME COMMENT 'Última fecha de login',
    INDEX idx_email (email),
    INDEX idx_estado (estado),
    INDEX idx_fecha_creacion (fecha_creacion),
    FULLTEXT INDEX ft_nombres (nombres, apellidos)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Tabla principal de usuarios del sistema';

-- ============================================================================
-- TABLA: USUARIO_ROLES
-- ============================================================================
CREATE TABLE usuario_roles (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    usuario_id INT UNSIGNED NOT NULL COMMENT 'Referencia a usuario',
    rol_id INT UNSIGNED NOT NULL COMMENT 'Referencia a rol',
    fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de asignación',
    UNIQUE KEY uk_usuario_rol (usuario_id, rol_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (rol_id) REFERENCES roles(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_usuario_id (usuario_id),
    INDEX idx_rol_id (rol_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Asignación de roles a usuarios (relación N:M)';

-- ============================================================================
-- TABLA: DATOS_INICIALES_USUARIO
-- ============================================================================
CREATE TABLE datos_iniciales_usuario (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    usuario_id INT UNSIGNED NOT NULL UNIQUE COMMENT 'Referencia única a usuario',
    tiene_estres BOOLEAN DEFAULT FALSE COMMENT '¿Ha estado pasando estrés prolongado?',
    tiene_tristeza BOOLEAN DEFAULT FALSE COMMENT '¿Ha sentido tristeza frecuente?',
    se_siente_desorientado BOOLEAN DEFAULT FALSE COMMENT '¿Se ha sentido desorientado?',
    trabaja_actualmente BOOLEAN DEFAULT FALSE COMMENT '¿Actualmente trabaja?',
    tiene_red_apoyo BOOLEAN DEFAULT FALSE COMMENT '¿Cuenta con red de apoyo?',
    notas_adicionales TEXT COMMENT 'Notas adicionales del usuario',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de registro',
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_estres (tiene_estres),
    INDEX idx_tristeza (tiene_tristeza)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Segmentación inicial de usuarios para matchmaking y recomendaciones';

-- ============================================================================
-- TABLA: ESPECIALIDADES
-- ============================================================================
CREATE TABLE especialidades (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    nombre VARCHAR(150) NOT NULL UNIQUE COMMENT 'Nombre de especialidad',
    descripcion TEXT COMMENT 'Descripción detallada',
    INDEX idx_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Catálogo de especialidades profesionales';

-- ============================================================================
-- TABLA: PROFESIONALES
-- ============================================================================
CREATE TABLE profesionales (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    usuario_id INT UNSIGNED NOT NULL UNIQUE COMMENT 'Referencia a usuario',
    licencia_profesional VARCHAR(255) COMMENT 'Número de licencia/cédula',
    especialidad_principal_id INT UNSIGNED COMMENT 'Especialidad principal',
    descripcion_profesional LONGTEXT COMMENT 'Descripción profesional',
    es_voluntario BOOLEAN DEFAULT FALSE COMMENT '¿Es voluntario?',
    tarifa_sesion DECIMAL(10,2) COMMENT 'Tarifa por sesión en dólares',
    biografia_profesional TEXT COMMENT 'Biografía profesional extendida',
    anos_experiencia INT COMMENT 'Años de experiencia',
    idiomas VARCHAR(255) COMMENT 'Idiomas que habla',
    estado ENUM('activo', 'inactivo', 'suspendido') DEFAULT 'activo' COMMENT 'Estado',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de registro',
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Última actualización',
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (especialidad_principal_id) REFERENCES especialidades(id) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_estado (estado),
    INDEX idx_especialidad (especialidad_principal_id),
    INDEX idx_es_voluntario (es_voluntario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Perfil profesional en la plataforma (psicólogos, coaches, mentores, etc)';

-- ============================================================================
-- TABLA: DISPONIBILIDAD
-- Descripción: Disponibilidad para usuarios y profesionales
-- ============================================================================
CREATE TABLE disponibilidad (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    usuario_id INT UNSIGNED COMMENT 'Referencia a usuario (NULL si es profesional)',
    profesional_id INT UNSIGNED COMMENT 'Referencia a profesional (NULL si es usuario)',
    dia_semana ENUM('lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado', 'domingo') COMMENT 'Día de la semana',
    hora_inicio TIME COMMENT 'Hora de inicio',
    hora_fin TIME COMMENT 'Hora de fin',
    es_activa BOOLEAN DEFAULT TRUE COMMENT '¿Está disponible?',
    tipo_sesion ENUM('online', 'presencial', 'ambas') DEFAULT 'ambas' COMMENT 'Tipo de sesión disponible',
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (profesional_id) REFERENCES profesionales(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_usuario_id (usuario_id),
    INDEX idx_dia_semana (dia_semana)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Disponibilidad horaria de usuarios y profesionales';

-- ============================================================================
-- TABLA: PROBLEMAS_EMOCIONALES
-- ============================================================================
CREATE TABLE problemas_emocionales (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    nombre VARCHAR(150) NOT NULL UNIQUE COMMENT 'Nombre del problema',
    descripcion TEXT COMMENT 'Descripción detallada',
    estado ENUM('activo', 'inactivo') DEFAULT 'activo' COMMENT 'Estado',
    INDEX idx_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Catálogo de problemas emocionales (ansiedad, estrés, soledad, duelo, etc)';

-- ============================================================================
-- TABLA: PERSONAJES
-- ============================================================================
CREATE TABLE personajes (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    nombre VARCHAR(255) NOT NULL COMMENT 'Nombre del personaje',
    origen VARCHAR(255) COMMENT 'Origen/fuente del personaje',
    tipo_personaje ENUM('ficticio', 'historico', 'celebridad', 'serie', 'anime', 'videojuego') COMMENT 'Tipo de personaje',
    descripcion LONGTEXT COMMENT 'Descripción del personaje',
    historia_superacion LONGTEXT COMMENT 'Historia de superación del personaje',
    imagen_url VARCHAR(500) COMMENT 'URL de imagen del personaje',
    datos_fandom_json JSON COMMENT 'Datos extraídos de Fandom API',
    analisis_ia JSON COMMENT 'Análisis generado por IA',
    estado ENUM('activo', 'inactivo') DEFAULT 'activo' COMMENT 'Estado',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación',
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Última actualización',
    INDEX idx_tipo (tipo_personaje),
    INDEX idx_estado (estado),
    FULLTEXT INDEX ft_nombre (nombre, descripcion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Personajes que representan emociones y situaciones';

-- ============================================================================
-- TABLA: PERSONAJE_PROBLEMA
-- ============================================================================
CREATE TABLE personaje_problema (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    personaje_id INT UNSIGNED NOT NULL COMMENT 'Referencia a personaje',
    problema_id INT UNSIGNED NOT NULL COMMENT 'Referencia a problema',
    descripcion TEXT COMMENT 'Cómo el personaje vivió este problema',
    UNIQUE KEY uk_personaje_problema (personaje_id, problema_id),
    FOREIGN KEY (personaje_id) REFERENCES personajes(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (problema_id) REFERENCES problemas_emocionales(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_personaje_id (personaje_id),
    INDEX idx_problema_id (problema_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Vinculación entre personajes y problemas emocionales';

-- ============================================================================
-- TABLA: DIARIO_EMOCIONAL
-- ============================================================================
CREATE TABLE diario_emocional (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    usuario_id INT UNSIGNED NOT NULL COMMENT 'Referencia a usuario',
    fecha_entrada DATE NOT NULL COMMENT 'Fecha de la entrada',
    contenido LONGTEXT NOT NULL COMMENT 'Contenido escrito por el usuario',
    estado_privacidad ENUM('privado', 'profesional', 'compartido') DEFAULT 'privado' COMMENT 'Nivel de privacidad',
    acceso_profesionales JSON COMMENT 'IDs de profesionales con acceso',
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha/hora de creación',
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha/hora de actualización',
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY uk_usuario_fecha (usuario_id, fecha_entrada),
    INDEX idx_usuario_fecha (usuario_id, fecha_entrada),
    INDEX idx_estado_privacidad (estado_privacidad)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Entradas del diario emocional privado de usuarios';

-- ============================================================================
-- TABLA: EMOCION_DIA
-- ============================================================================
CREATE TABLE emocion_dia (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    diario_id INT UNSIGNED NOT NULL COMMENT 'Referencia a entrada de diario',
    personaje_id INT UNSIGNED COMMENT 'Personaje relacionado con la emoción',
    intensidad TINYINT UNSIGNED COMMENT 'Intensidad de 1 a 10',
    notas TEXT COMMENT 'Notas adicionales sobre la emoción',
    FOREIGN KEY (diario_id) REFERENCES diario_emocional(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (personaje_id) REFERENCES personajes(id) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_diario_id (diario_id),
    INDEX idx_personaje_id (personaje_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Emociones específicas vinculadas a personajes en cada entrada del diario';

-- ============================================================================
-- TABLA: CATEGORIAS_RECURSOS
-- ============================================================================
CREATE TABLE categorias_recursos (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    nombre VARCHAR(150) NOT NULL UNIQUE COMMENT 'Nombre de categoría',
    descripcion TEXT COMMENT 'Descripción',
    icono_url VARCHAR(500) COMMENT 'URL del icono',
    INDEX idx_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Categorías para clasificar recursos';

-- ============================================================================
-- TABLA: RECURSOS_DIGITALES
-- ============================================================================
CREATE TABLE recursos_digitales (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    titulo VARCHAR(255) NOT NULL COMMENT 'Título del recurso',
    descripcion LONGTEXT COMMENT 'Descripción detallada',
    tipo_contenido ENUM('articulo', 'video', 'podcast', 'libro', 'documento', 'infografia', 'otro') COMMENT 'Tipo de contenido',
    autor VARCHAR(255) COMMENT 'Autor del recurso',
    url_contenido VARCHAR(500) COMMENT 'URL al contenido',
    duracion_minutos INT UNSIGNED COMMENT 'Duración en minutos',
    imagen_portada_url VARCHAR(500) COMMENT 'URL de imagen de portada',
    es_premium BOOLEAN DEFAULT FALSE COMMENT '¿Es contenido premium?',
    precio DECIMAL(10,2) COMMENT 'Precio si es premium',
    codigo_afiliado VARCHAR(100) COMMENT 'Código de afiliado',
    url_afiliado VARCHAR(500) COMMENT 'URL afiliado',
    vistas INT UNSIGNED DEFAULT 0 COMMENT 'Número de vistas',
    estado ENUM('activo', 'inactivo', 'eliminado') DEFAULT 'activo' COMMENT 'Estado',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación',
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Última actualización',
    INDEX idx_tipo (tipo_contenido),
    INDEX idx_estado (estado),
    INDEX idx_es_premium (es_premium),
    FULLTEXT INDEX ft_titulo_descripcion (titulo, descripcion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Biblioteca digital con artículos, videos, podcasts, etc';

-- ============================================================================
-- TABLA: RECURSO_CATEGORIA
-- ============================================================================
CREATE TABLE recurso_categoria (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    recurso_id INT UNSIGNED NOT NULL COMMENT 'Referencia a recurso',
    categoria_id INT UNSIGNED NOT NULL COMMENT 'Referencia a categoría',
    UNIQUE KEY uk_recurso_categoria (recurso_id, categoria_id),
    FOREIGN KEY (recurso_id) REFERENCES recursos_digitales(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (categoria_id) REFERENCES categorias_recursos(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_recurso_id (recurso_id),
    INDEX idx_categoria_id (categoria_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Clasificación de recursos en múltiples categorías (relación N:M)';

-- ============================================================================
-- TABLA: RECURSOS_DESCARGADOS
-- ============================================================================
CREATE TABLE recursos_descargados (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    usuario_id INT UNSIGNED NOT NULL COMMENT 'Referencia a usuario',
    recurso_id INT UNSIGNED NOT NULL COMMENT 'Referencia a recurso',
    fecha_descarga TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de descarga',
    UNIQUE KEY uk_usuario_recurso (usuario_id, recurso_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (recurso_id) REFERENCES recursos_digitales(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_usuario_id (usuario_id),
    INDEX idx_fecha_descarga (fecha_descarga)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Registro de descargas de recursos por usuarios';

-- ============================================================================
-- TABLA: PROFESIONAL_ESPECIALIDAD
-- ============================================================================
CREATE TABLE profesional_especialidad (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    profesional_id INT UNSIGNED NOT NULL COMMENT 'Referencia a profesional',
    especialidad_id INT UNSIGNED NOT NULL COMMENT 'Referencia a especialidad',
    nivel_expertise ENUM('basico', 'intermedio', 'avanzado', 'experto') DEFAULT 'intermedio' COMMENT 'Nivel de expertise',
    UNIQUE KEY uk_profesional_especialidad (profesional_id, especialidad_id),
    FOREIGN KEY (profesional_id) REFERENCES profesionales(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (especialidad_id) REFERENCES especialidades(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_profesional_id (profesional_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Especialidades múltiples de cada profesional (relación N:M)';

-- ============================================================================
-- TABLA: SESIONES_MEDICAS
-- Descripción: Sesiones de telemedicina y medicina integrada
-- ============================================================================
CREATE TABLE sesiones_medicas (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    usuario_id INT UNSIGNED NOT NULL COMMENT 'Referencia a usuario',
    profesional_id INT UNSIGNED NOT NULL COMMENT 'Referencia a profesional',
    fecha_sesion DATETIME NOT NULL COMMENT 'Fecha y hora de sesión',
    duracion_minutos INT UNSIGNED DEFAULT 45 COMMENT 'Duración en minutos',
    tipo_sesion ENUM('online', 'presencial') DEFAULT 'online' COMMENT 'Tipo de sesión',
    estado_sesion ENUM('programada', 'en_progreso', 'completada', 'cancelada', 'no_asistio') DEFAULT 'programada' COMMENT 'Estado',
    url_videollamada VARCHAR(500) COMMENT 'URL generada para videollamada',
    token_videollamada VARCHAR(500) COMMENT 'Token de autenticación para videollamada',
    archivo_grabacion VARCHAR(500) COMMENT 'URL del archivo de grabación',
    consentimiento_grabacion BOOLEAN DEFAULT FALSE COMMENT '¿Consentimiento para grabar?',
    monto_pagado DECIMAL(10,2) COMMENT 'Monto pagado',
    notas_clinicas LONGTEXT COMMENT 'Notas clínicas de la sesión',
    diagnostico_preliminar TEXT COMMENT 'Diagnóstico preliminar (encriptado)',
    recomendaciones TEXT COMMENT 'Recomendaciones para el usuario',
    proxima_sesion DATETIME COMMENT 'Fecha de próxima sesión sugerida',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación de sesión',
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (profesional_id) REFERENCES profesionales(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_usuario_id (usuario_id),
    INDEX idx_profesional_id (profesional_id),
    INDEX idx_fecha_sesion (fecha_sesion),
    INDEX idx_estado_sesion (estado_sesion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Sesiones médicas con videollamada, fichas clínicas integradas y grabación segura';

-- ============================================================================
-- TABLA: VALORACIONES_PROFESIONAL
-- Descripción: Reseñas y valoraciones con comentarios
-- ============================================================================
CREATE TABLE valoraciones_profesional (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    sesion_medica_id INT UNSIGNED COMMENT 'Referencia a sesión médica completada',
    usuario_id INT UNSIGNED NOT NULL COMMENT 'Referencia a usuario evaluador',
    profesional_id INT UNSIGNED NOT NULL COMMENT 'Referencia a profesional evaluado',
    puntuacion DECIMAL(3,2) NOT NULL COMMENT 'Puntuación de 1 a 5',
    comentario TEXT COMMENT 'Comentario detallado de la valoración',
    aspectos_positivos TEXT COMMENT 'Aspectos positivos',
    aspectos_mejora TEXT COMMENT 'Aspectos a mejorar',
    recomendaria BOOLEAN DEFAULT TRUE COMMENT '¿Recomendaría al profesional?',
    fecha_valoracion TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de valoración',
    FOREIGN KEY (sesion_medica_id) REFERENCES sesiones_medicas(id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (profesional_id) REFERENCES profesionales(id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY uk_usuario_profesional_fecha (usuario_id, profesional_id, fecha_valoracion),
    INDEX idx_profesional_id (profesional_id),
    INDEX idx_puntuacion (puntuacion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Valoraciones y reseñas de profesionales por usuarios';

-- ============================================================================
-- TABLA: LOGROS
-- ============================================================================
CREATE TABLE logros (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    nombre VARCHAR(150) NOT NULL UNIQUE COMMENT 'Nombre del logro',
    descripcion TEXT COMMENT 'Descripción detallada',
    tipo_logro ENUM('registro', 'participacion', 'taller', 'recursos', 'objetivos', 'social') COMMENT 'Tipo de logro',
    puntos INT UNSIGNED DEFAULT 0 COMMENT 'Puntos asociados',
    icono_url VARCHAR(500) COMMENT 'URL del icono/insignia',
    condicion_logro JSON COMMENT 'Condición JSON para obtener logro',
    estado ENUM('activo', 'inactivo') DEFAULT 'activo' COMMENT 'Estado',
    INDEX idx_tipo_logro (tipo_logro)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Definición de logros, insignias y recompensas del sistema';

-- ============================================================================
-- TABLA: USUARIO_LOGROS
-- ============================================================================
CREATE TABLE usuario_logros (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    usuario_id INT UNSIGNED NOT NULL COMMENT 'Referencia a usuario',
    logro_id INT UNSIGNED NOT NULL COMMENT 'Referencia a logro',
    fecha_desbloqueado TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de desbloqueo',
    UNIQUE KEY uk_usuario_logro (usuario_id, logro_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (logro_id) REFERENCES logros(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_usuario_id (usuario_id),
    INDEX idx_fecha_desbloqueado (fecha_desbloqueado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Logros desbloqueados por cada usuario';

-- ============================================================================
-- TABLA: FOROS_TEMATICOS
-- ============================================================================
CREATE TABLE foros_tematicos (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    nombre VARCHAR(150) NOT NULL UNIQUE COMMENT 'Nombre del foro',
    descripcion LONGTEXT COMMENT 'Descripción del foro',
    categoria VARCHAR(100) COMMENT 'Categoría del foro',
    reglas_moderacion TEXT COMMENT 'Reglas de moderación',
    estado ENUM('activo', 'inactivo', 'suspendido') DEFAULT 'activo' COMMENT 'Estado',
    numero_miembros INT UNSIGNED DEFAULT 0 COMMENT 'Número de miembros',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación',
    INDEX idx_nombre (nombre),
    INDEX idx_estado (estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Foros temáticos de discusión';

-- ============================================================================
-- TABLA: FORO_TEMAS
-- ============================================================================
CREATE TABLE foro_temas (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    forum_id INT UNSIGNED NOT NULL COMMENT 'Referencia a foro',
    usuario_id INT UNSIGNED NOT NULL COMMENT 'Creador del tema',
    titulo VARCHAR(255) NOT NULL COMMENT 'Título del tema',
    contenido LONGTEXT COMMENT 'Contenido inicial del tema',
    numero_respuestas INT UNSIGNED DEFAULT 0 COMMENT 'Número de respuestas',
    vistas INT UNSIGNED DEFAULT 0 COMMENT 'Número de vistas',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación',
    fecha_ultima_actividad TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Última actividad',
    FOREIGN KEY (forum_id) REFERENCES foros_tematicos(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_forum_id (forum_id),
    INDEX idx_fecha_creacion (fecha_creacion),
    FULLTEXT INDEX ft_titulo_contenido (titulo, contenido)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Temas de discusión dentro de foros';

-- ============================================================================
-- TABLA: FORO_RESPUESTAS
-- ============================================================================
CREATE TABLE foro_respuestas (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    tema_id INT UNSIGNED NOT NULL COMMENT 'Referencia a tema',
    usuario_id INT UNSIGNED NOT NULL COMMENT 'Autor de respuesta',
    contenido LONGTEXT NOT NULL COMMENT 'Contenido de la respuesta',
    es_solucion BOOLEAN DEFAULT FALSE COMMENT '¿Marca como solución?',
    numero_votos_positivos INT UNSIGNED DEFAULT 0 COMMENT 'Votos positivos',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación',
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha de edición',
    FOREIGN KEY (tema_id) REFERENCES foro_temas(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_tema_id (tema_id),
    INDEX idx_usuario_id (usuario_id),
    INDEX idx_es_solucion (es_solucion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Respuestas a temas en foros';

-- ============================================================================
-- TABLA: MODERADORES
-- ============================================================================
CREATE TABLE moderadores (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    usuario_id INT UNSIGNED NOT NULL COMMENT 'Referencia a usuario',
    forum_id INT UNSIGNED NOT NULL COMMENT 'Referencia a foro',
    nivel_moderacion ENUM('basico', 'avanzado', 'supervisor') DEFAULT 'basico' COMMENT 'Nivel de moderación',
    fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de asignación',
    UNIQUE KEY uk_usuario_forum (usuario_id, forum_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (forum_id) REFERENCES foros_tematicos(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_forum_id (forum_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Asignación de moderadores a foros temáticos';

-- ============================================================================
-- TABLA: REPORTES_CONTENIDO
-- ============================================================================
CREATE TABLE reportes_contenido (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    usuario_id INT UNSIGNED NOT NULL COMMENT 'Usuario que reporta',
    tipo_contenido ENUM('post', 'comentario', 'tema_foro', 'respuesta_foro') COMMENT 'Tipo de contenido reportado',
    contenido_id INT UNSIGNED NOT NULL COMMENT 'ID del contenido reportado',
    motivo ENUM('ofensivo', 'spam', 'acoso', 'falso_danino', 'otro') COMMENT 'Motivo del reporte',
    descripcion TEXT COMMENT 'Descripción del problema',
    estado ENUM('pendiente', 'revisar', 'resuelto', 'desestimado') DEFAULT 'pendiente' COMMENT 'Estado del reporte',
    fecha_reporte TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha del reporte',
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_estado (estado),
    INDEX idx_fecha_reporte (fecha_reporte)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Sistema de reportes de contenido inapropiado';

-- ============================================================================
-- TABLA: TALLERES_GRUPALES
-- ============================================================================
CREATE TABLE talleres_grupales (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    titulo VARCHAR(255) NOT NULL COMMENT 'Título del taller',
    descripcion LONGTEXT COMMENT 'Descripción detallada',
    instructor_id INT UNSIGNED COMMENT 'Instructor profesional',
    tipo_taller ENUM('online', 'presencial', 'hibrido') DEFAULT 'online' COMMENT 'Tipo de taller',
    es_gratuito BOOLEAN DEFAULT FALSE COMMENT '¿Es gratuito?',
    precio DECIMAL(10,2) COMMENT 'Precio si no es gratuito',
    max_participantes INT UNSIGNED COMMENT 'Máximo de participantes',
    duracion_total_horas INT UNSIGNED COMMENT 'Duración total en horas',
    estado ENUM('planificado', 'en_curso', 'completado', 'cancelado') DEFAULT 'planificado' COMMENT 'Estado',
    fecha_inicio DATE COMMENT 'Fecha de inicio',
    fecha_fin DATE COMMENT 'Fecha de fin',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación',
    FOREIGN KEY (instructor_id) REFERENCES profesionales(id) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_estado (estado),
    INDEX idx_tipo_taller (tipo_taller),
    FULLTEXT INDEX ft_titulo (titulo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Talleres grupales (online y presenciales)';

-- ============================================================================
-- TABLA: TALLER_SESIONES
-- ============================================================================
CREATE TABLE taller_sesiones (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    taller_id INT UNSIGNED NOT NULL COMMENT 'Referencia a taller',
    numero_sesion INT UNSIGNED COMMENT 'Número secuencial de sesión',
    titulo_sesion VARCHAR(255) COMMENT 'Título de la sesión',
    descripcion_sesion TEXT COMMENT 'Descripción de esta sesión',
    fecha_sesion DATE NOT NULL COMMENT 'Fecha de la sesión',
    hora_inicio TIME COMMENT 'Hora de inicio',
    duracion_minutos INT UNSIGNED DEFAULT 60 COMMENT 'Duración en minutos',
    ubicacion_online VARCHAR(500) COMMENT 'URL para conexión online',
    ubicacion_presencial VARCHAR(500) COMMENT 'Dirección presencial',
    capacidad_actual INT UNSIGNED DEFAULT 0 COMMENT 'Participantes actuales',
    FOREIGN KEY (taller_id) REFERENCES talleres_grupales(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_taller_id (taller_id),
    INDEX idx_fecha_sesion (fecha_sesion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Sesiones individuales de los talleres grupales';

-- ============================================================================
-- TABLA: INSCRIPCION_TALLER
-- ============================================================================
CREATE TABLE inscripcion_taller (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    usuario_id INT UNSIGNED NOT NULL COMMENT 'Referencia a usuario',
    taller_id INT UNSIGNED NOT NULL COMMENT 'Referencia a taller',
    sesion_id INT UNSIGNED COMMENT 'Sesión específica si aplica',
    fecha_inscripcion TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de inscripción',
    estado ENUM('inscrito', 'completado', 'abandonado', 'suspendido') DEFAULT 'inscrito' COMMENT 'Estado',
    monto_pagado DECIMAL(10,2) COMMENT 'Monto pagado por inscripción',
    UNIQUE KEY uk_usuario_taller (usuario_id, taller_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (taller_id) REFERENCES talleres_grupales(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (sesion_id) REFERENCES taller_sesiones(id) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_usuario_id (usuario_id),
    INDEX idx_estado (estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Inscripción de usuarios en talleres grupales';

-- ============================================================================
-- TABLA: ASISTENCIA_TALLER
-- ============================================================================
CREATE TABLE asistencia_taller (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    inscripcion_id INT UNSIGNED NOT NULL COMMENT 'Referencia a inscripción',
    sesion_id INT UNSIGNED NOT NULL COMMENT 'Referencia a sesión',
    asistio BOOLEAN DEFAULT FALSE COMMENT '¿Asistió?',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de registro de asistencia',
    UNIQUE KEY uk_inscripcion_sesion (inscripcion_id, sesion_id),
    FOREIGN KEY (inscripcion_id) REFERENCES inscripcion_taller(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (sesion_id) REFERENCES taller_sesiones(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_sesion_id (sesion_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Registro de asistencia a sesiones de talleres';

-- ============================================================================
-- TABLA: PAGOS
-- ============================================================================
CREATE TABLE pagos (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    usuario_id INT UNSIGNED NOT NULL COMMENT 'Referencia a usuario',
    tipo_pago ENUM('sesion_profesional', 'taller', 'recurso_premium', 'suscripcion') COMMENT 'Tipo de pago',
    referencia_id INT UNSIGNED COMMENT 'ID de lo que se pagó',
    monto DECIMAL(10,2) NOT NULL COMMENT 'Monto pagado',
    moneda VARCHAR(3) DEFAULT 'USD' COMMENT 'Moneda',
    estado_pago ENUM('pendiente', 'pagado', 'fallido', 'reembolsado') DEFAULT 'pendiente' COMMENT 'Estado',
    metodo_pago ENUM('tarjeta_credito', 'paypal', 'transferencia', 'otro') COMMENT 'Método de pago',
    referencia_transaccion VARCHAR(255) COMMENT 'ID de transacción del gateway',
    fecha_pago TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de pago',
    fecha_reembolso TIMESTAMP COMMENT 'Fecha de reembolso si aplica',
    notas TEXT COMMENT 'Notas adicionales',
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_usuario_id (usuario_id),
    INDEX idx_estado_pago (estado_pago),
    INDEX idx_fecha_pago (fecha_pago)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Registro de todas las transacciones y pagos en la plataforma';

-- ============================================================================
-- TABLA: AFILIADOS
-- ============================================================================
CREATE TABLE afiliados (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    usuario_id INT UNSIGNED NOT NULL COMMENT 'Referencia a usuario afiliado',
    recurso_id INT UNSIGNED COMMENT 'Referencia a recurso',
    plataforma_afiliado VARCHAR(100) COMMENT 'Plataforma afiliada (Amazon, etc)',
    codigo_afiliado VARCHAR(255) COMMENT 'Código único de afiliado',
    url_afiliado_personalizada VARCHAR(500) COMMENT 'URL personalizada del afiliado',
    comision_porcentaje DECIMAL(5,2) DEFAULT 5.00 COMMENT 'Porcentaje de comisión',
    ingresos_generados DECIMAL(10,2) DEFAULT 0 COMMENT 'Ingresos totales generados',
    estado ENUM('activo', 'pausado', 'inactivo') DEFAULT 'activo' COMMENT 'Estado',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación',
    INDEX idx_usuario_id (usuario_id),
    INDEX idx_estado (estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Programa de afiliados para generación de ingresos pasivos';

-- ============================================================================
-- TABLA: SUPERVISIONES
-- ============================================================================
CREATE TABLE supervisiones (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    supervisor_id INT UNSIGNED NOT NULL COMMENT 'Profesional supervisor',
    profesional_id INT UNSIGNED NOT NULL COMMENT 'Profesional supervisado',
    tipo_supervision ENUM('individual', 'grupal', 'evaluacion') DEFAULT 'individual' COMMENT 'Tipo de supervisión',
    fecha_supervision DATE NOT NULL COMMENT 'Fecha de supervisión',
    duracion_minutos INT UNSIGNED COMMENT 'Duración en minutos',
    contenido LONGTEXT COMMENT 'Contenido de la supervisión',
    observaciones TEXT COMMENT 'Observaciones del supervisor',
    areas_mejora TEXT COMMENT 'Áreas de mejora identificadas',
    proxima_supervision DATE COMMENT 'Fecha próxima supervisión',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de registro',
    FOREIGN KEY (supervisor_id) REFERENCES profesionales(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (profesional_id) REFERENCES profesionales(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_supervisor_id (supervisor_id),
    INDEX idx_profesional_id (profesional_id),
    INDEX idx_fecha_supervision (fecha_supervision)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Sistema de supervisiones profesionales y evaluaciones';

-- ============================================================================
-- TABLA: CONVENIOS
-- ============================================================================
CREATE TABLE convenios (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    nombre_institucion VARCHAR(255) NOT NULL COMMENT 'Nombre de institución',
    tipo_convenio ENUM('clinica', 'universidad', 'centro_salud', 'organizacion_social', 'otro') COMMENT 'Tipo de convenio',
    descripcion LONGTEXT COMMENT 'Descripción del convenio',
    contacto_nombre VARCHAR(255) COMMENT 'Nombre de contacto',
    contacto_email VARCHAR(255) COMMENT 'Email de contacto',
    contacto_telefono VARCHAR(20) COMMENT 'Teléfono de contacto',
    beneficios_para_usuarios TEXT COMMENT 'Beneficios para usuarios de la plataforma',
    beneficios_para_institucion TEXT COMMENT 'Beneficios para la institución',
    estado ENUM('activo', 'pendiente', 'suspendido', 'finalizado') DEFAULT 'pendiente' COMMENT 'Estado',
    fecha_inicio DATE COMMENT 'Fecha de inicio del convenio',
    fecha_fin DATE COMMENT 'Fecha de vencimiento',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación',
    INDEX idx_estado (estado),
    FULLTEXT INDEX ft_nombre (nombre_institucion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Convenios con instituciones (clínicas, universidades, etc)';

-- ============================================================================
-- TABLA: BITACORA_AUDITORIA
-- ============================================================================
CREATE TABLE bitacora_auditoria (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'ID único',
    usuario_id INT UNSIGNED COMMENT 'Usuario que realizó la acción',
    tipo_accion VARCHAR(100) NOT NULL COMMENT 'Tipo de acción (CREATE, UPDATE, DELETE, etc)',
    tabla_afectada VARCHAR(100) NOT NULL COMMENT 'Nombre de tabla afectada',
    registro_id INT UNSIGNED COMMENT 'ID del registro afectado',
    descripcion TEXT COMMENT 'Descripción de la acción',
    datos_anteriores JSON COMMENT 'Datos anteriores (para UPDATE)',
    datos_nuevos JSON COMMENT 'Datos nuevos (para UPDATE)',
    ip_address VARCHAR(45) COMMENT 'Dirección IP del usuario',
    fecha_accion TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de acción',
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_usuario_id (usuario_id),
    INDEX idx_tabla_afectada (tabla_afectada),
    INDEX idx_fecha_accion (fecha_accion),
    INDEX idx_tipo_accion (tipo_accion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT 'Bitácora de auditoría para cumplimiento normativo y seguridad';

-- ============================================================================
-- CREAR ÍNDICES ADICIONALES PARA OPTIMIZACIÓN
-- ============================================================================
CREATE INDEX idx_usuarios_estado_fecha ON usuarios(estado, fecha_creacion);
CREATE INDEX idx_profesionales_tarifa ON profesionales(tarifa_sesion, estado);
CREATE INDEX idx_pagos_usuario_fecha ON pagos(usuario_id, fecha_pago);
CREATE INDEX idx_foro_temas_forum_fecha ON foro_temas(forum_id, fecha_creacion);
CREATE INDEX idx_diario_usuario_mes ON diario_emocional(usuario_id, YEAR(fecha_entrada), MONTH(fecha_entrada));
CREATE INDEX idx_sesiones_medicas_usuario ON sesiones_medicas(usuario_id, fecha_sesion);

-- ============================================================================
-- INSERTAR DATOS DE EJEMPLO AMPLIADOS
-- ============================================================================

-- Insertar roles
INSERT INTO roles (nombre, descripcion, permisos_json, estado) VALUES
('usuario', 'Usuario regular de la plataforma', JSON_OBJECT('crear_posts', true, 'comentar', true, 'leer_recursos', true), 'activo'),
('profesional', 'Profesional de salud (psicólogo, coach, etc)', JSON_OBJECT('crear_sesiones', true, 'ver_fichas', true, 'crear_recursos', true), 'activo'),
('voluntario', 'Profesional voluntario con sesiones limitadas', JSON_OBJECT('crear_sesiones', true, 'sesiones_max', 2), 'activo'),
('moderador', 'Moderador de comunidad y foros', JSON_OBJECT('eliminar_contenido', true, 'bannear_usuarios', true), 'activo'),
('admin', 'Administrador del sistema', JSON_OBJECT('all_permissions', true), 'activo'),
('supervisor', 'Supervisor de profesionales', JSON_OBJECT('supervisar', true, 'evaluar', true), 'activo');

-- Insertar usuarios (expandido)
INSERT INTO usuarios (email, password_hash, nombres, apellidos, fecha_nacimiento, genero, ciudad, estado) VALUES
('juan.garcia@example.com', '$2b$10$abcdefghijklmnopqrstuvwxyz', 'Juan', 'García', '1990-05-15', 'masculino', 'Santiago', 'activo'),
('maria.lopez@example.com', '$2b$10$abcdefghijklmnopqrstuvwxyz', 'María', 'López', '1995-08-22', 'femenino', 'Valparaíso', 'activo'),
('carlos.rodriguez@example.com', '$2b$10$abcdefghijklmnopqrstuvwxyz', 'Carlos', 'Rodríguez', '1988-03-10', 'masculino', 'Concepción', 'activo'),
('ana.martinez@example.com', '$2b$10$abcdefghijklmnopqrstuvwxyz', 'Ana', 'Martínez', '1985-07-18', 'femenino', 'Santiago', 'activo'),
('luis.perez@example.com', '$2b$10$abcdefghijklmnopqrstuvwxyz', 'Luis', 'Pérez', '1992-11-30', 'masculino', 'La Florida', 'activo'),
('sofia.diaz@example.com', '$2b$10$abcdefghijklmnopqrstuvwxyz', 'Sofía', 'Díaz', '1998-02-14', 'femenino', 'Ñuñoa', 'activo'),
('diego.torres@example.com', '$2b$10$abcdefghijklmnopqrstuvwxyz', 'Diego', 'Torres', '1987-09-05', 'masculino', 'Providencia', 'activo'),
('rosa.flores@example.com', '$2b$10$abcdefghijklmnopqrstuvwxyz', 'Rosa', 'Flores', '1993-06-20', 'femenino', 'Vitacura', 'activo'),
('pablo.silva@example.com', '$2b$10$abcdefghijklmnopqrstuvwxyz', 'Pablo', 'Silva', '1989-01-12', 'masculino', 'Carabineros', 'activo'),
('laura.morales@example.com', '$2b$10$abcdefghijklmnopqrstuvwxyz', 'Laura', 'Morales', '1996-04-08', 'femenino', 'Maipú', 'activo'),
('dr.alberto.silva@example.com', '$2b$10$abcdefghijklmnopqrstuvwxyz', 'Alberto', 'Silva', '1970-12-05', 'masculino', 'Santiago', 'activo'),
('coach.ana.terapia@example.com', '$2b$10$abcdefghijklmnopqrstuvwxyz', 'Ana Cecilia', 'Terapista', '1981-07-18', 'femenino', 'Santiago', 'activo'),
('psic.gonzalo@example.com', '$2b$10$abcdefghijklmnopqrstuvwxyz', 'Gonzalo', 'Ramírez', '1975-03-22', 'masculino', 'Las Condes', 'activo'),
('menta.carolina@example.com', '$2b$10$abcdefghijklmnopqrstuvwxyz', 'Carolina', 'Mendoza', '1988-10-15', 'femenino', 'Independencia', 'activo');

-- Asignar roles a usuarios
INSERT INTO usuario_roles (usuario_id, rol_id) VALUES
(1, 1), (2, 1), (3, 1), (4, 1), (5, 1),
(6, 1), (7, 1), (8, 1), (9, 1), (10, 1),
(11, 2), (12, 2), (13, 2), (14, 2);

-- Insertar datos iniciales de usuarios
INSERT INTO datos_iniciales_usuario (usuario_id, tiene_estres, tiene_tristeza, se_siente_desorientado, trabaja_actualmente, tiene_red_apoyo) VALUES
(1, TRUE, FALSE, TRUE, TRUE, TRUE),
(2, TRUE, TRUE, FALSE, TRUE, TRUE),
(3, FALSE, FALSE, TRUE, FALSE, FALSE),
(4, TRUE, FALSE, FALSE, TRUE, TRUE),
(5, FALSE, TRUE, TRUE, TRUE, FALSE),
(6, TRUE, TRUE, TRUE, TRUE, TRUE),
(7, FALSE, FALSE, FALSE, FALSE, TRUE),
(8, TRUE, FALSE, TRUE, TRUE, TRUE),
(9, FALSE, TRUE, FALSE, FALSE, FALSE),
(10, TRUE, TRUE, FALSE, TRUE, TRUE);

-- Insertar problemas emocionales
INSERT INTO problemas_emocionales (nombre, descripcion) VALUES
('Ansiedad', 'Preocupación excesiva y persistente'),
('Estrés', 'Tensión emocional por presiones'),
('Soledad', 'Sentimiento de aislamiento y desconexión'),
('Duelo', 'Pérdida y dolor emocional'),
('Baja autoestima', 'Falta de confianza en uno mismo'),
('Crisis vocacional', 'Confusión sobre dirección profesional'),
('Burnout', 'Agotamiento emocional y laboral'),
('Crecimiento personal', 'Búsqueda de desarrollo y mejora');

-- Insertar categorías de recursos
INSERT INTO categorias_recursos (nombre, descripcion) VALUES
('Gestión emocional', 'Recursos para manejar emociones'),
('Mindfulness', 'Técnicas de atención plena'),
('Autocuidado', 'Prácticas de cuidado personal'),
('Hábitos saludables', 'Desarrollo de hábitos positivos'),
('Equilibrio vida-trabajo', 'Balance entre personal y laboral'),
('Resiliencia', 'Capacidad de superación y recuperación'),
('Relaciones interpersonales', 'Mejora de vínculos con otros');

-- Insertar recursos de ejemplo (expandido)
INSERT INTO recursos_digitales (titulo, descripcion, tipo_contenido, autor, es_premium, precio) VALUES
('Introducción a Mindfulness', 'Guía completa para principiantes en meditación', 'articulo', 'Sistema Bienestar', FALSE, NULL),
('Meditación diaria 10 minutos', 'Meditación guiada para relajación profunda', 'video', 'Coach Maya', TRUE, 9.99),
('Podcast: Vidas Transformadas', 'Historias inspiradoras de superación personal', 'podcast', 'Red Bienestar', FALSE, NULL),
('Manual de Gestión del Estrés', 'Técnicas prácticas y efectivas comprobadas', 'documento', 'Dr. Roberto', TRUE, 14.99),
('Infografía: 7 Hábitos Saludables', 'Guía visual de buenos hábitos cotidianos', 'infografia', 'Sistema Bienestar', FALSE, NULL),
('El Arte de la Resiliencia', 'Libro sobre cómo superar adversidades', 'libro', 'Patricia González', TRUE, 19.99),
('Yoga para la Ansiedad', 'Video tutorial de 30 minutos de yoga', 'video', 'Instructor Luis', FALSE, NULL),
('Relaciones Sanas', 'Artículo sobre comunicación efectiva', 'articulo', 'Psicóloga Carla', FALSE, NULL),
('Podcast: Bienestar Mental', 'Episodios semanales sobre salud mental', 'podcast', 'Dr. Sistema', TRUE, 4.99),
('Diario de Gratitud Digital', 'Aplicación web para registro diario', 'documento', 'Tech Wellness', FALSE, NULL);

-- Insertar especialidades
INSERT INTO especialidades (nombre, descripcion) VALUES
('Psicología Clínica', 'Diagnóstico y tratamiento de trastornos'),
('Psicología Organizacional', 'Recursos humanos y bienestar laboral'),
('Coaching Vocacional', 'Orientación profesional y carrera'),
('Mindfulness', 'Meditación y atención plena'),
('Nutrición y Bienestar', 'Asesoramiento nutricional integral'),
('Terapia Complementaria', 'Terapias alternativas e integrativas'),
('Autoestima y Confianza', 'Desarrollo personal y seguridad'),
('Relaciones Interpersonales', 'Mejora de habilidades comunicativas');

-- Insertar profesionales (expandido)
INSERT INTO profesionales (usuario_id, licencia_profesional, especialidad_principal_id, es_voluntario, tarifa_sesion, anos_experiencia) VALUES
(11, 'LC-12345', 1, FALSE, 80.00, 15),
(12, 'LC-67890', 4, FALSE, 60.00, 8),
(13, 'LC-54321', 1, TRUE, 50.00, 5),
(14, 'LC-98765', 2, FALSE, 75.00, 10);

-- Insertar logros
INSERT INTO logros (nombre, descripcion, tipo_logro, puntos) VALUES
('Primer Paso', 'Completa tu primer registro', 'registro', 10),
('Diario Activo', 'Escribe en el diario 7 días consecutivos', 'registro', 50),
('Miembro Activo', 'Participa en 10 publicaciones', 'participacion', 30),
('Explorador', 'Descubre 5 personajes diferentes', 'recursos', 20),
('Aprendiz', 'Completa tu primer taller', 'taller', 100),
('Maestro', 'Completa 5 talleres', 'taller', 250),
('Conectado', 'Consigue 5 conexiones en la comunidad', 'social', 40),
('Inspirador', 'Recibe 50 reacciones positivas', 'social', 75);

-- Insertar foros temáticos
INSERT INTO foros_tematicos (nombre, descripcion, categoria) VALUES
('Ansiedad Universitaria', 'Espacio para estudiantes con estrés académico', 'salud_mental'),
('Gestión Emocional', 'Técnicas y estrategias para manejar emociones', 'desarrollo_personal'),
('TDAH en Adultos', 'Comunidad de apoyo para TDAH', 'salud_mental'),
('Autocuidado', 'Prácticas y hábitos de cuidado personal', 'bienestar'),
('Bienestar Laboral', 'Equilibrio entre trabajo y vida personal', 'trabajo'),
('Resiliencia y Superación', 'Historias y consejos sobre resiliencia', 'desarrollo_personal');

-- Insertar personajes de ejemplo
INSERT INTO personajes (nombre, origen, tipo_personaje, descripcion) VALUES
('Clark Kent/Superman', 'DC Comics', 'ficticio', 'Superhéroe que lucha con su identidad dual y el peso de las responsabilidades'),
('Nelson Mandela', 'Historia', 'historico', 'Líder que superó 27 años de encarcelamiento'),
('Oprah Winfrey', 'Personajes Reales', 'celebridad', 'Emprendedora que superó pobreza y discriminación'),
('Elliot Alderson', 'Mr. Robot', 'serie', 'Personaje con ansiedad social que busca propósito y justicia'),
('Luffy', 'One Piece', 'anime', 'Pirata determinado que busca sus sueños a pesar de los obstáculos'),
('Walter White', 'Breaking Bad', 'serie', 'Hombre ordinario que enfrenta enfermedad y transformación personal');

-- ============================================================================
-- VERIFICACIÓN FINAL (CORREGIDA)
-- ============================================================================
SELECT '✓ Base de datos versión 2.0 creada correctamente' AS mensaje;
SELECT CONCAT('Total de tablas: ', COUNT(*)) AS tabla_count 
FROM information_schema.tables 
WHERE table_schema = DATABASE();

-- ============================================================================
