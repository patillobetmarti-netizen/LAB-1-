-- Paso 1: Crear la base de datos
CREATE DATABASE TikTokDB;
USE TikTokDB;

-- Paso 2: Crear las tablas

-- Tabla de Usuarios
CREATE TABLE Usuarios (
    usuario_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    fecha_registro DATE,
    pais_origen VARCHAR(50) NOT NULL
);

-- Tabla de Videos
CREATE TABLE Videos (
    video_id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    titulo VARCHAR(100),
    descripcion TEXT,
    fecha_publicacion DATE,
    duracion_segundos INT,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id)
);

-- Tabla de Comentarios
CREATE TABLE Comentarios (
    comentario_id INT AUTO_INCREMENT PRIMARY KEY,
    video_id INT,
    usuario_id INT,
    texto TEXT NOT NULL,
    fecha_comentario DATE,
    FOREIGN KEY (video_id) REFERENCES Videos(video_id),
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id)
);

-- Tabla de Likes
CREATE TABLE Likes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,
    video_id INT,
    usuario_id INT,
    fecha_like DATE,
    FOREIGN KEY (video_id) REFERENCES Videos(video_id),
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id)
);

-- Tabla de Seguidores
CREATE TABLE Seguidores (
    seguidor_id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_sigue INT,
    usuario_seguido INT,
    fecha_seguimiento DATE,
    FOREIGN KEY (usuario_sigue) REFERENCES Usuarios(usuario_id),
    FOREIGN KEY (usuario_seguido) REFERENCES Usuarios(usuario_id)
);

-- Paso 3: Insertar datos de ejemplo

INSERT INTO Usuarios (nombre_usuario, email, fecha_registro, pais_origen)
VALUES 
('patricia', 'patricia@email.com', '2024-01-10', 'España'),
('judit', 'judit@email.com', '2024-02-12', 'España'),
('marc', 'marc@email.com', '2024-03-05', 'Francia');

INSERT INTO Videos (usuario_id, titulo, descripcion, fecha_publicacion, duracion_segundos)
VALUES
(1, 'Mi primer video', 'Un día en la montaña', '2024-04-01', 120),
(2, 'Receta fácil', 'Cómo hacer pasta en 5 minutos', '2024-04-05', 300),
(3, 'Entrenamiento', 'Rutina rápida de cardio', '2024-04-07', 180);

INSERT INTO Comentarios (video_id, usuario_id, texto, fecha_comentario)
VALUES
(1, 2, 'Qué bonito lugar!', '2024-04-02'),
(2, 1, 'Probaré esta receta!', '2024-04-06'),
(3, 2, 'Buenísimo!', '2024-04-08');

INSERT INTO Likes (video_id, usuario_id, fecha_like)
VALUES
(1, 2, '2024-04-02'),
(1, 3, '2024-04-03'),
(2, 1, '2024-04-06');

INSERT INTO Seguidores (usuario_sigue, usuario_seguido, fecha_seguimiento)
VALUES
(2, 1, '2024-04-01'),
(3, 1, '2024-04-02'),
(1, 2, '2024-04-03');

-- Paso 4: Consultas

-- Ver todos los usuarios
SELECT * FROM Usuarios;

-- Ver todos los videos
SELECT * FROM Videos;

-- Ver los comentarios
SELECT * FROM Comentarios;

-- Ver todos los likes
SELECT * FROM Likes;

-- Ver relaciones de seguimiento
SELECT * FROM Seguidores;

-- 3 queries extra (creatividad 😎)

-- 1. Ver cuántos likes tiene cada video
SELECT v.titulo, COUNT(l.like_id) AS total_likes
FROM Videos v
LEFT JOIN Likes l ON v.video_id = l.video_id
GROUP BY v.video_id;

-- 2. Ver qué usuario tiene más seguidores
SELECT u.nombre_usuario, COUNT(s.seguidor_id) AS total_seguidores
FROM Usuarios u
JOIN Seguidores s ON u.usuario_id = s.usuario_seguido
GROUP BY u.usuario_id
ORDER BY total_seguidores DESC
LIMIT 1;

-- 3. Ver los videos con sus comentarios
SELECT v.titulo, c.texto AS comentario, u.nombre_usuario AS comentado_por
FROM Comentarios c
JOIN Videos v ON c.video_id = v.video_id
JOIN Usuarios u ON c.usuario_id = u.usuario_id;