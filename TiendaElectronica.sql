-- =============================================
-- BASE DE DATOS: TIENDA DE PRODUCTOS ELECTRÓNICOS
-- =============================================

CREATE DATABASE TiendaElectronica;
GO

USE TiendaElectronica;
GO

-- =============================================
-- TABLA: Roles
-- =============================================
CREATE TABLE Roles (
    RolId INT PRIMARY KEY IDENTITY(1,1),
    NombreRol NVARCHAR(50) NOT NULL UNIQUE,
    Descripcion NVARCHAR(200),
    FechaCreacion DATETIME DEFAULT GETDATE(),
    Activo BIT DEFAULT 1
);

-- =============================================
-- TABLA: Usuarios
-- =============================================
CREATE TABLE Usuarios (
    UsuarioId INT PRIMARY KEY IDENTITY(1,1),
    RolId INT NOT NULL,
    NombreUsuario NVARCHAR(50) NOT NULL UNIQUE,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    Nombres NVARCHAR(100) NOT NULL,
    Apellidos NVARCHAR(100) NOT NULL,
    Telefono NVARCHAR(20),
    Direccion NVARCHAR(255),
    Ciudad NVARCHAR(100),
    CodigoPostal NVARCHAR(10),
    Pais NVARCHAR(50) DEFAULT 'Perú',
    FechaRegistro DATETIME DEFAULT GETDATE(),
    UltimoAcceso DATETIME,
    Activo BIT DEFAULT 1,
    CONSTRAINT FK_Usuarios_Roles FOREIGN KEY (RolId) REFERENCES Roles(RolId)
);

-- =============================================
-- TABLA: Categorías
-- =============================================
CREATE TABLE Categorias (
    CategoriaId INT PRIMARY KEY IDENTITY(1,1),
    NombreCategoria NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(255),
    Activo BIT DEFAULT 1,
    FechaCreacion DATETIME DEFAULT GETDATE()
);

-- =============================================
-- TABLA: Productos
-- =============================================
CREATE TABLE Productos (
    ProductoId INT PRIMARY KEY IDENTITY(1,1),
    CategoriaId INT NOT NULL,
    NombreProducto NVARCHAR(200) NOT NULL,
    Descripcion NVARCHAR(MAX),
    Marca NVARCHAR(100),
    Modelo NVARCHAR(100),
    Precio DECIMAL(10,2) NOT NULL,
    PrecioOferta DECIMAL(10,2),
    Stock INT NOT NULL DEFAULT 0,
    StockMinimo INT DEFAULT 5,
    Garantia NVARCHAR(100),
    Especificaciones NVARCHAR(MAX),
    FechaCreacion DATETIME DEFAULT GETDATE(),
    FechaModificacion DATETIME,
    Activo BIT DEFAULT 1,
    Destacado BIT DEFAULT 0,
    CONSTRAINT FK_Productos_Categorias FOREIGN KEY (CategoriaId) REFERENCES Categorias(CategoriaId)
);

-- =============================================
-- TABLA: Imágenes de Productos
-- =============================================
CREATE TABLE ImagenesProducto (
    ImagenId INT PRIMARY KEY IDENTITY(1,1),
    ProductoId INT NOT NULL,
    RutaImagen NVARCHAR(500) NOT NULL,
    EsPrincipal BIT DEFAULT 0,
    Orden INT DEFAULT 0,
    FechaCarga DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_ImagenesProducto_Productos FOREIGN KEY (ProductoId) REFERENCES Productos(ProductoId) ON DELETE CASCADE
);

-- =============================================
-- TABLA: Estados de Pedido
-- =============================================
CREATE TABLE EstadosPedido (
    EstadoId INT PRIMARY KEY IDENTITY(1,1),
    NombreEstado NVARCHAR(50) NOT NULL UNIQUE,
    Descripcion NVARCHAR(200),
    Orden INT NOT NULL,
    Color NVARCHAR(20),
    Activo BIT DEFAULT 1
);

-- =============================================
-- TABLA: Pedidos
-- =============================================
CREATE TABLE Pedidos (
    PedidoId INT PRIMARY KEY IDENTITY(1,1),
    UsuarioId INT NOT NULL,
    EstadoId INT NOT NULL,
    FechaPedido DATETIME DEFAULT GETDATE(),
    FechaActualizacion DATETIME DEFAULT GETDATE(),
    Total DECIMAL(10,2) NOT NULL,
    Subtotal DECIMAL(10,2) NOT NULL,
    Impuesto DECIMAL(10,2) DEFAULT 0,
    CostoEnvio DECIMAL(10,2) DEFAULT 0,
    DireccionEnvio NVARCHAR(255) NOT NULL,
    Ciudad NVARCHAR(100) NOT NULL,
    CodigoPostal NVARCHAR(10),
    Telefono NVARCHAR(20) NOT NULL,
    NotasCliente NVARCHAR(MAX),
    NotasInternas NVARCHAR(MAX),
    CONSTRAINT FK_Pedidos_Usuarios FOREIGN KEY (UsuarioId) REFERENCES Usuarios(UsuarioId),
    CONSTRAINT FK_Pedidos_Estados FOREIGN KEY (EstadoId) REFERENCES EstadosPedido(EstadoId)
);

-- =============================================
-- TABLA: Detalle de Pedidos
-- =============================================
CREATE TABLE DetallePedido (
    DetalleId INT PRIMARY KEY IDENTITY(1,1),
    PedidoId INT NOT NULL,
    ProductoId INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    Subtotal DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_DetallePedido_Pedidos FOREIGN KEY (PedidoId) REFERENCES Pedidos(PedidoId) ON DELETE CASCADE,
    CONSTRAINT FK_DetallePedido_Productos FOREIGN KEY (ProductoId) REFERENCES Productos(ProductoId)
);

-- =============================================
-- TABLA: Historial de Estados del Pedido
-- =============================================
CREATE TABLE HistorialEstadoPedido (
    HistorialId INT PRIMARY KEY IDENTITY(1,1),
    PedidoId INT NOT NULL,
    EstadoId INT NOT NULL,
    UsuarioId INT NOT NULL,
    FechaCambio DATETIME DEFAULT GETDATE(),
    Comentario NVARCHAR(500),
    CONSTRAINT FK_HistorialEstado_Pedidos FOREIGN KEY (PedidoId) REFERENCES Pedidos(PedidoId) ON DELETE CASCADE,
    CONSTRAINT FK_HistorialEstado_Estados FOREIGN KEY (EstadoId) REFERENCES EstadosPedido(EstadoId),
    CONSTRAINT FK_HistorialEstado_Usuarios FOREIGN KEY (UsuarioId) REFERENCES Usuarios(UsuarioId)
);

-- =============================================
-- TABLA: Carrito de Compras
-- =============================================
CREATE TABLE CarritoCompras (
    CarritoId INT PRIMARY KEY IDENTITY(1,1),
    UsuarioId INT NOT NULL,
    ProductoId INT NOT NULL,
    Cantidad INT NOT NULL DEFAULT 1,
    FechaAgregado DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Carrito_Usuarios FOREIGN KEY (UsuarioId) REFERENCES Usuarios(UsuarioId) ON DELETE CASCADE,
    CONSTRAINT FK_Carrito_Productos FOREIGN KEY (ProductoId) REFERENCES Productos(ProductoId)
);

-- =============================================
-- INSERCIÓN DE DATOS INICIALES
-- =============================================

-- Roles
INSERT INTO Roles (NombreRol, Descripcion) VALUES
('Admin', 'Administrador del sistema con acceso total'),
('Mantenedor', 'Encargado de mantenimiento de productos y seguimiento de pedidos'),
('Cliente', 'Cliente de la tienda');

-- Estados de Pedido
INSERT INTO EstadosPedido (NombreEstado, Descripcion, Orden, Color) VALUES
('Pendiente', 'Pedido recibido, pendiente de procesamiento', 1, '#FFA500'),
('Confirmado', 'Pedido confirmado y en proceso', 2, '#0066CC'),
('Preparando', 'Pedido siendo preparado para envío', 3, '#9966FF'),
('Enviado', 'Pedido enviado al cliente', 4, '#3399FF'),
('En Tránsito', 'Pedido en camino al destino', 5, '#00CCFF'),
('En Reparto', 'Pedido en reparto local', 6, '#FF9900'),
('Entregado', 'Pedido entregado exitosamente', 7, '#00CC66'),
('Cancelado', 'Pedido cancelado', 8, '#CC0000'),
('Devuelto', 'Pedido devuelto por el cliente', 9, '#CC6600');

-- Usuario Admin por defecto (contraseña: Admin123!)
INSERT INTO Usuarios (RolId, NombreUsuario, Email, PasswordHash, Nombres, Apellidos, Telefono, Direccion, Ciudad) VALUES
(1, 'admin', 'admin@tienda.com', 'AQAAAAEAACcQAAAAEHashTemporalParaEjemplo==', 'Administrador', 'Sistema', '999999999', 'Av. Principal 123', 'Lima');

-- Categorías
INSERT INTO Categorias (NombreCategoria, Descripcion) VALUES
('Smartphones', 'Teléfonos móviles y accesorios'),
('Laptops', 'Computadoras portátiles'),
('Tablets', 'Tablets y accesorios'),
('Audio', 'Audífonos, parlantes y equipos de audio'),
('Gaming', 'Consolas y accesorios para videojuegos'),
('Cámaras', 'Cámaras digitales y accesorios'),
('Smartwatch', 'Relojes inteligentes y wearables'),
('Accesorios', 'Accesorios electrónicos diversos');

-- =============================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- =============================================

CREATE INDEX IX_Usuarios_Email ON Usuarios(Email);
CREATE INDEX IX_Usuarios_RolId ON Usuarios(RolId);
CREATE INDEX IX_Productos_CategoriaId ON Productos(CategoriaId);
CREATE INDEX IX_Productos_Activo ON Productos(Activo);
CREATE INDEX IX_ImagenesProducto_ProductoId ON ImagenesProducto(ProductoId);
CREATE INDEX IX_Pedidos_UsuarioId ON Pedidos(UsuarioId);
CREATE INDEX IX_Pedidos_EstadoId ON Pedidos(EstadoId);
CREATE INDEX IX_Pedidos_FechaPedido ON Pedidos(FechaPedido);
CREATE INDEX IX_DetallePedido_PedidoId ON DetallePedido(PedidoId);
CREATE INDEX IX_DetallePedido_ProductoId ON DetallePedido(ProductoId);
CREATE INDEX IX_HistorialEstado_PedidoId ON HistorialEstadoPedido(PedidoId);
CREATE INDEX IX_CarritoCompras_UsuarioId ON CarritoCompras(UsuarioId);

GO