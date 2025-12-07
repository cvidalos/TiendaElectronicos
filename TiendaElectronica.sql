-- =============================================
-- BASE DE DATOS: TIENDA DE PRODUCTOS ELECTRÓNICOS
-- SISTEMA COMPLETO CON GESTIÓN DE COMPROBANTES
-- =============================================

-- Crear base de datos
USE master;
GO
DROP DATABASE IF EXISTS TiendaElectronica;
GO
CREATE DATABASE TiendaElectronica;
GO
USE TiendaElectronica;
GO

-- =============================================
-- ELIMINAR TABLAS SI EXISTEN (para recrear)
-- =============================================
IF OBJECT_ID('DetalleNotasDebito', 'U') IS NOT NULL DROP TABLE DetalleNotasDebito;
IF OBJECT_ID('NotasDebito', 'U') IS NOT NULL DROP TABLE NotasDebito;
IF OBJECT_ID('DetalleNotasCredito', 'U') IS NOT NULL DROP TABLE DetalleNotasCredito;
IF OBJECT_ID('NotasCredito', 'U') IS NOT NULL DROP TABLE NotasCredito;
IF OBJECT_ID('ComprobantesVenta', 'U') IS NOT NULL DROP TABLE ComprobantesVenta;
IF OBJECT_ID('NotasPedido', 'U') IS NOT NULL DROP TABLE NotasPedido;
IF OBJECT_ID('ComprobantesDeposito', 'U') IS NOT NULL DROP TABLE ComprobantesDeposito;
IF OBJECT_ID('HistorialEstadoPedido', 'U') IS NOT NULL DROP TABLE HistorialEstadoPedido;
IF OBJECT_ID('DetallePedido', 'U') IS NOT NULL DROP TABLE DetallePedido;
IF OBJECT_ID('Pedidos', 'U') IS NOT NULL DROP TABLE Pedidos;
IF OBJECT_ID('CarritoCompras', 'U') IS NOT NULL DROP TABLE CarritoCompras;
IF OBJECT_ID('ImagenesProducto', 'U') IS NOT NULL DROP TABLE ImagenesProducto;
IF OBJECT_ID('Productos', 'U') IS NOT NULL DROP TABLE Productos;
IF OBJECT_ID('Categorias', 'U') IS NOT NULL DROP TABLE Categorias;
IF OBJECT_ID('CuentasBancarias', 'U') IS NOT NULL DROP TABLE CuentasBancarias;
IF OBJECT_ID('EstadosPedido', 'U') IS NOT NULL DROP TABLE EstadosPedido;
IF OBJECT_ID('Usuarios', 'U') IS NOT NULL DROP TABLE Usuarios;
IF OBJECT_ID('Roles', 'U') IS NOT NULL DROP TABLE Roles;
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
GO

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
    TipoDocumento NVARCHAR(20), -- DNI, RUC, Pasaporte
    NumeroDocumento NVARCHAR(20),
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
GO

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
GO

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
    Precio DECIMAL(10,2) NOT NULL CHECK (Precio > 0),
    PrecioOferta DECIMAL(10,2) CHECK (PrecioOferta >= 0),
    Stock INT NOT NULL DEFAULT 0 CHECK (Stock >= 0),
    StockMinimo INT DEFAULT 5 CHECK (StockMinimo >= 0),
    Garantia NVARCHAR(100),
    Especificaciones NVARCHAR(MAX),
    FechaCreacion DATETIME DEFAULT GETDATE(),
    FechaModificacion DATETIME,
    Activo BIT DEFAULT 1,
    Destacado BIT DEFAULT 0,
    CONSTRAINT FK_Productos_Categorias FOREIGN KEY (CategoriaId) REFERENCES Categorias(CategoriaId)
);
GO

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
GO

-- =============================================
-- TABLA: Cuentas Bancarias
-- =============================================
CREATE TABLE CuentasBancarias (
    CuentaId INT PRIMARY KEY IDENTITY(1,1),
    Banco NVARCHAR(100) NOT NULL,
    TipoCuenta NVARCHAR(50) NOT NULL, -- Ahorros, Corriente
    NumeroCuenta NVARCHAR(50) NOT NULL,
    CCI NVARCHAR(50),
    Titular NVARCHAR(200) NOT NULL,
    Moneda NVARCHAR(10) DEFAULT 'PEN', -- PEN, USD
    Activo BIT DEFAULT 1,
    Orden INT DEFAULT 0
);
GO

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
GO

-- =============================================
-- TABLA: Pedidos
-- =============================================
CREATE TABLE Pedidos (
    PedidoId INT PRIMARY KEY IDENTITY(1,1),
    UsuarioId INT NOT NULL,
    EstadoId INT NOT NULL,
    TipoComprobante NVARCHAR(20) NOT NULL, -- 'Boleta', 'Factura'
    RazonSocial NVARCHAR(200), -- Solo para facturas
    RUC NVARCHAR(11), -- Solo para facturas
    DireccionFiscal NVARCHAR(255), -- Solo para facturas
    FechaPedido DATETIME DEFAULT GETDATE(),
    FechaActualizacion DATETIME DEFAULT GETDATE(),
    Total DECIMAL(10,2) NOT NULL CHECK (Total >= 0),
    Subtotal DECIMAL(10,2) NOT NULL CHECK (Subtotal >= 0),
    IGV DECIMAL(10,2) DEFAULT 0 CHECK (IGV >= 0), -- 18% en Perú
    CostoEnvio DECIMAL(10,2) DEFAULT 0 CHECK (CostoEnvio >= 0),
    DireccionEnvio NVARCHAR(255) NOT NULL,
    Ciudad NVARCHAR(100) NOT NULL,
    CodigoPostal NVARCHAR(10),
    Telefono NVARCHAR(20) NOT NULL,
    NotasCliente NVARCHAR(MAX),
    NotasInternas NVARCHAR(MAX),
    CONSTRAINT FK_Pedidos_Usuarios FOREIGN KEY (UsuarioId) REFERENCES Usuarios(UsuarioId),
    CONSTRAINT FK_Pedidos_Estados FOREIGN KEY (EstadoId) REFERENCES EstadosPedido(EstadoId)
);
GO

-- =============================================
-- TABLA: Detalle de Pedidos
-- =============================================
CREATE TABLE DetallePedido (
    DetalleId INT PRIMARY KEY IDENTITY(1,1),
    PedidoId INT NOT NULL,
    ProductoId INT NOT NULL,
    Cantidad INT NOT NULL CHECK (Cantidad > 0),
    PrecioUnitario DECIMAL(10,2) NOT NULL CHECK (PrecioUnitario >= 0),
    Subtotal DECIMAL(10,2) NOT NULL CHECK (Subtotal >= 0),
    CONSTRAINT FK_DetallePedido_Pedidos FOREIGN KEY (PedidoId) REFERENCES Pedidos(PedidoId) ON DELETE CASCADE,
    CONSTRAINT FK_DetallePedido_Productos FOREIGN KEY (ProductoId) REFERENCES Productos(ProductoId)
);
GO

-- =============================================
-- TABLA: Comprobantes de Depósito
-- =============================================
CREATE TABLE ComprobantesDeposito (
    ComprobanteDepositoId INT PRIMARY KEY IDENTITY(1,1),
    PedidoId INT NOT NULL,
    CuentaId INT, -- Cuenta bancaria a la que depositó
    NumeroOperacion NVARCHAR(50),
    FechaDeposito DATETIME,
    MontoDepositado DECIMAL(10,2) NOT NULL CHECK (MontoDepositado > 0),
    RutaComprobante NVARCHAR(500), -- Ruta de la imagen del depósito
    Validado BIT DEFAULT 0,
    FechaValidacion DATETIME,
    UsuarioValidadorId INT, -- Usuario que validó el depósito
    ObservacionesValidacion NVARCHAR(500),
    FechaRegistro DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_ComprobanteDeposito_Pedidos FOREIGN KEY (PedidoId) REFERENCES Pedidos(PedidoId),
    CONSTRAINT FK_ComprobanteDeposito_Cuenta FOREIGN KEY (CuentaId) REFERENCES CuentasBancarias(CuentaId),
    CONSTRAINT FK_ComprobanteDeposito_Usuario FOREIGN KEY (UsuarioValidadorId) REFERENCES Usuarios(UsuarioId)
);
GO

-- =============================================
-- TABLA: Notas de Pedido
-- =============================================
CREATE TABLE NotasPedido (
    NotaPedidoId INT PRIMARY KEY IDENTITY(1,1),
    PedidoId INT NOT NULL,
    NumeroNotaPedido NVARCHAR(20) NOT NULL UNIQUE, -- NP-2024-00001
    FechaEmision DATETIME DEFAULT GETDATE(),
    Estado NVARCHAR(20) DEFAULT 'Emitida', -- Emitida, Devuelta, Aceptada, Cancelada
    FechaDevolucion DATETIME,
    MotivoDevolucion NVARCHAR(500),
    FechaAceptacion DATETIME,
    Observaciones NVARCHAR(MAX),
    CONSTRAINT FK_NotasPedido_Pedidos FOREIGN KEY (PedidoId) REFERENCES Pedidos(PedidoId)
);
GO

-- =============================================
-- TABLA: Comprobantes de Venta (Boletas/Facturas)
-- =============================================
CREATE TABLE ComprobantesVenta (
    ComprobanteVentaId INT PRIMARY KEY IDENTITY(1,1),
    PedidoId INT NOT NULL,
    NotaPedidoId INT NOT NULL,
    TipoComprobante NVARCHAR(20) NOT NULL, -- 'Boleta', 'Factura'
    SerieComprobante NVARCHAR(10) NOT NULL, -- B001, F001
    NumeroComprobante NVARCHAR(20) NOT NULL, -- 00000001
    FechaEmision DATETIME DEFAULT GETDATE(),
    RazonSocial NVARCHAR(200),
    NumeroDocumento NVARCHAR(20), -- DNI o RUC
    DireccionCliente NVARCHAR(255),
    Subtotal DECIMAL(10,2) NOT NULL CHECK (Subtotal >= 0),
    IGV DECIMAL(10,2) NOT NULL CHECK (IGV >= 0),
    Total DECIMAL(10,2) NOT NULL CHECK (Total >= 0),
    Estado NVARCHAR(20) DEFAULT 'Emitida', -- Emitida, Anulada
    FechaAnulacion DATETIME,
    MotivoAnulacion NVARCHAR(500),
    RutaPDF NVARCHAR(500),
    CONSTRAINT FK_ComprobantesVenta_Pedidos FOREIGN KEY (PedidoId) REFERENCES Pedidos(PedidoId),
    CONSTRAINT FK_ComprobantesVenta_NotasPedido FOREIGN KEY (NotaPedidoId) REFERENCES NotasPedido(NotaPedidoId),
    CONSTRAINT UK_ComprobanteVenta UNIQUE (TipoComprobante, SerieComprobante, NumeroComprobante)
);
GO

-- =============================================
-- TABLA: Notas de Crédito
-- =============================================
CREATE TABLE NotasCredito (
    NotaCreditoId INT PRIMARY KEY IDENTITY(1,1),
    ComprobanteVentaId INT NOT NULL,
    PedidoId INT NOT NULL,
    SerieNotaCredito NVARCHAR(10) NOT NULL, -- NC01
    NumeroNotaCredito NVARCHAR(20) NOT NULL,
    TipoNota NVARCHAR(50) NOT NULL, -- 'Anulación', 'Descuento', 'Devolución', 'Bonificación'
    Motivo NVARCHAR(500) NOT NULL,
    FechaEmision DATETIME DEFAULT GETDATE(),
    Subtotal DECIMAL(10,2) NOT NULL CHECK (Subtotal >= 0),
    IGV DECIMAL(10,2) NOT NULL CHECK (IGV >= 0),
    Total DECIMAL(10,2) NOT NULL CHECK (Total >= 0),
    Estado NVARCHAR(20) DEFAULT 'Emitida',
    RutaPDF NVARCHAR(500),
    Observaciones NVARCHAR(MAX),
    CONSTRAINT FK_NotasCredito_ComprobantesVenta FOREIGN KEY (ComprobanteVentaId) REFERENCES ComprobantesVenta(ComprobanteVentaId),
    CONSTRAINT FK_NotasCredito_Pedidos FOREIGN KEY (PedidoId) REFERENCES Pedidos(PedidoId),
    CONSTRAINT UK_NotaCredito UNIQUE (SerieNotaCredito, NumeroNotaCredito)
);
GO

-- =============================================
-- TABLA: Detalle Notas de Crédito
-- =============================================
CREATE TABLE DetalleNotasCredito (
    DetalleNotaCreditoId INT PRIMARY KEY IDENTITY(1,1),
    NotaCreditoId INT NOT NULL,
    ProductoId INT NOT NULL,
    Cantidad INT NOT NULL CHECK (Cantidad > 0),
    PrecioUnitario DECIMAL(10,2) NOT NULL CHECK (PrecioUnitario >= 0),
    Subtotal DECIMAL(10,2) NOT NULL CHECK (Subtotal >= 0),
    Motivo NVARCHAR(500),
    CONSTRAINT FK_DetalleNotasCredito_NotasCredito FOREIGN KEY (NotaCreditoId) REFERENCES NotasCredito(NotaCreditoId) ON DELETE CASCADE,
    CONSTRAINT FK_DetalleNotasCredito_Productos FOREIGN KEY (ProductoId) REFERENCES Productos(ProductoId)
);
GO

-- =============================================
-- TABLA: Notas de Débito
-- =============================================
CREATE TABLE NotasDebito (
    NotaDebitoId INT PRIMARY KEY IDENTITY(1,1),
    ComprobanteVentaId INT NOT NULL,
    PedidoId INT NOT NULL,
    SerieNotaDebito NVARCHAR(10) NOT NULL, -- ND01
    NumeroNotaDebito NVARCHAR(20) NOT NULL,
    TipoNota NVARCHAR(50) NOT NULL, -- 'Intereses', 'Gastos adicionales', 'Penalidades'
    Motivo NVARCHAR(500) NOT NULL,
    FechaEmision DATETIME DEFAULT GETDATE(),
    Subtotal DECIMAL(10,2) NOT NULL CHECK (Subtotal >= 0),
    IGV DECIMAL(10,2) NOT NULL CHECK (IGV >= 0),
    Total DECIMAL(10,2) NOT NULL CHECK (Total > 0),
    Estado NVARCHAR(20) DEFAULT 'Emitida',
    RutaPDF NVARCHAR(500),
    Observaciones NVARCHAR(MAX),
    CONSTRAINT FK_NotasDebito_ComprobantesVenta FOREIGN KEY (ComprobanteVentaId) REFERENCES ComprobantesVenta(ComprobanteVentaId),
    CONSTRAINT FK_NotasDebito_Pedidos FOREIGN KEY (PedidoId) REFERENCES Pedidos(PedidoId),
    CONSTRAINT UK_NotaDebito UNIQUE (SerieNotaDebito, NumeroNotaDebito)
);
GO

-- =============================================
-- TABLA: Detalle Notas de Débito
-- =============================================
CREATE TABLE DetalleNotasDebito (
    DetalleNotaDebitoId INT PRIMARY KEY IDENTITY(1,1),
    NotaDebitoId INT NOT NULL,
    Concepto NVARCHAR(200) NOT NULL,
    Cantidad INT NOT NULL DEFAULT 1 CHECK (Cantidad > 0),
    PrecioUnitario DECIMAL(10,2) NOT NULL CHECK (PrecioUnitario >= 0),
    Subtotal DECIMAL(10,2) NOT NULL CHECK (Subtotal >= 0),
    CONSTRAINT FK_DetalleNotasDebito_NotasDebito FOREIGN KEY (NotaDebitoId) REFERENCES NotasDebito(NotaDebitoId) ON DELETE CASCADE
);
GO

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
GO

-- =============================================
-- TABLA: Carrito de Compras
-- =============================================
CREATE TABLE CarritoCompras (
    CarritoId INT PRIMARY KEY IDENTITY(1,1),
    UsuarioId INT NOT NULL,
    ProductoId INT NOT NULL,
    Cantidad INT NOT NULL DEFAULT 1 CHECK (Cantidad > 0),
    FechaAgregado DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Carrito_Usuarios FOREIGN KEY (UsuarioId) REFERENCES Usuarios(UsuarioId) ON DELETE CASCADE,
    CONSTRAINT FK_Carrito_Productos FOREIGN KEY (ProductoId) REFERENCES Productos(ProductoId)
);
GO

-- =============================================
-- INSERCIÓN DE DATOS INICIALES
-- =============================================

-- Roles
INSERT INTO Roles (NombreRol, Descripcion) VALUES
('Admin', 'Administrador del sistema con acceso total'),
('Mantenedor', 'Encargado de mantenimiento de productos y seguimiento de pedidos'),
('Cliente', 'Cliente de la tienda');
GO

-- Estados de Pedido
INSERT INTO EstadosPedido (NombreEstado, Descripcion, Orden, Color) VALUES
('Pendiente Pago', 'Esperando confirmación de depósito', 1, '#FFA500'),
('Pago Validado', 'Depósito confirmado, generando nota de pedido', 2, '#0066CC'),
('Nota Emitida', 'Nota de pedido emitida', 3, '#9966FF'),
('Preparando', 'Pedido siendo preparado para envío', 4, '#6633CC'),
('Enviado', 'Pedido enviado al cliente', 5, '#3399FF'),
('En Tránsito', 'Pedido en camino al destino', 6, '#00CCFF'),
('En Reparto', 'Pedido en reparto local', 7, '#FF9900'),
('Entregado Pendiente', 'Entregado, esperando confirmación del cliente', 8, '#FFCC00'),
('Aceptado', 'Cliente aceptó el pedido, generando comprobante', 9, '#00CC66'),
('Facturado', 'Comprobante de venta emitido', 10, '#009900'),
('Devuelto', 'Pedido devuelto por el cliente', 11, '#CC6600'),
('Cancelado', 'Pedido cancelado', 12, '#CC0000');
GO

-- Usuario Admin por defecto (Password: Admin123!)
-- NOTA: Este hash es de ejemplo, debes cambiarlo con tu sistema de hash real
INSERT INTO Usuarios (RolId, NombreUsuario, Email, PasswordHash, Nombres, Apellidos, TipoDocumento, NumeroDocumento, Telefono, Direccion, Ciudad) VALUES
(1, 'admin', 'admin@tiendaelectronica.com', 'AQAAAAEAACcQAAAAEHashTemporalParaEjemplo==', 'Administrador', 'Sistema', 'DNI', '12345678', '999999999', 'Av. Principal 123', 'Lima');
GO

-- Cuentas Bancarias
INSERT INTO CuentasBancarias (Banco, TipoCuenta, NumeroCuenta, CCI, Titular, Moneda, Orden) VALUES
('BCP - Banco de Crédito del Perú', 'Ahorros', '19312345678901', '00219312345678901234', 'Tienda Electrónica SAC', 'PEN', 1),
('Interbank', 'Corriente', '20012345678', '00320012345678012345', 'Tienda Electrónica SAC', 'PEN', 2),
('BBVA', 'Ahorros', '00112345678901', '01100112345678901234', 'Tienda Electrónica SAC', 'PEN', 3),
('Scotiabank', 'Ahorros', '30012345678', '00930012345678012345', 'Tienda Electrónica SAC', 'PEN', 4);
GO

-- Categorías
INSERT INTO Categorias (NombreCategoria, Descripcion) VALUES
('Smartphones', 'Teléfonos móviles y accesorios'),
('Laptops', 'Computadoras portátiles de última generación'),
('Tablets', 'Tablets y accesorios'),
('Audio', 'Audífonos, parlantes y equipos de audio premium'),
('Gaming', 'Consolas y accesorios para videojuegos'),
('Cámaras', 'Cámaras digitales y accesorios fotográficos'),
('Smartwatch', 'Relojes inteligentes y wearables'),
('Accesorios', 'Accesorios electrónicos diversos');
GO

-- =============================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- =============================================

CREATE INDEX IX_Usuarios_Email ON Usuarios(Email);
CREATE INDEX IX_Usuarios_RolId ON Usuarios(RolId);
CREATE INDEX IX_Usuarios_NumeroDocumento ON Usuarios(NumeroDocumento);
CREATE INDEX IX_Productos_CategoriaId ON Productos(CategoriaId);
CREATE INDEX IX_Productos_Activo ON Productos(Activo);
CREATE INDEX IX_Productos_Destacado ON Productos(Destacado);
CREATE INDEX IX_Productos_Stock ON Productos(Stock);
CREATE INDEX IX_Productos_Marca ON Productos(Marca);
CREATE INDEX IX_ImagenesProducto_ProductoId ON ImagenesProducto(ProductoId);
CREATE INDEX IX_ImagenesProducto_EsPrincipal ON ImagenesProducto(EsPrincipal);
CREATE INDEX IX_Pedidos_UsuarioId ON Pedidos(UsuarioId);
CREATE INDEX IX_Pedidos_EstadoId ON Pedidos(EstadoId);
CREATE INDEX IX_Pedidos_FechaPedido ON Pedidos(FechaPedido);
CREATE INDEX IX_DetallePedido_PedidoId ON DetallePedido(PedidoId);
CREATE INDEX IX_DetallePedido_ProductoId ON DetallePedido(ProductoId);
CREATE INDEX IX_ComprobantesDeposito_PedidoId ON ComprobantesDeposito(PedidoId);
CREATE INDEX IX_ComprobantesDeposito_Validado ON ComprobantesDeposito(Validado);
CREATE INDEX IX_NotasPedido_PedidoId ON NotasPedido(PedidoId);
CREATE INDEX IX_NotasPedido_Estado ON NotasPedido(Estado);
CREATE INDEX IX_ComprobantesVenta_PedidoId ON ComprobantesVenta(PedidoId);
CREATE INDEX IX_ComprobantesVenta_NotaPedidoId ON ComprobantesVenta(NotaPedidoId);
CREATE INDEX IX_NotasCredito_ComprobanteVentaId ON NotasCredito(ComprobanteVentaId);
CREATE INDEX IX_NotasDebito_ComprobanteVentaId ON NotasDebito(ComprobanteVentaId);
CREATE INDEX IX_HistorialEstado_PedidoId ON HistorialEstadoPedido(PedidoId);
CREATE INDEX IX_CarritoCompras_UsuarioId ON CarritoCompras(UsuarioId);
GO

-- =============================================
-- SCRIPT COMPLETADO EXITOSAMENTE
-- =============================================
PRINT 'Base de datos TiendaElectronica creada exitosamente';
PRINT 'Tablas creadas: 18';
PRINT 'Datos iniciales insertados';
PRINT 'Índices creados para optimización';
GO
