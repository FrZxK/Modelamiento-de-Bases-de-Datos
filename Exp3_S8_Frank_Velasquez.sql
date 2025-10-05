
-- CREACION DE TABLAS DEL MODELO:

-- Comuna
CREATE TABLE comuna (
    cod_comuna NUMBER(4) PRIMARY KEY,
    nombre_comuna VARCHAR2(100)
);

-- Marca
CREATE TABLE marca (
    cod_marca NUMBER(3) PRIMARY KEY,
    nombre_marca VARCHAR2(100) NOT NULL
);

-- Categoria
CREATE TABLE categoria (
    cod_categoria NUMBER(3) PRIMARY KEY,
    nombre_categoria VARCHAR2(255) NOT NULL
);

-- Salud
CREATE TABLE salud (
    id_salud NUMBER(4) PRIMARY KEY,
    nom_salud VARCHAR2(40) NOT NULL
);

-- Afp
CREATE TABLE afp (
    id_afp NUMBER(5) PRIMARY KEY,
    nom_afp VARCHAR2(255) NOT NULL
);

-- Medio_pago
CREATE TABLE medio_pago (
    id_mpago NUMBER(3) PRIMARY KEY,
    nombre_mpago VARCHAR2(50) NOT NULL
);

-- Proveedor
CREATE TABLE proveedor (
    id_proveedor NUMBER(8) PRIMARY KEY,
    nombre_proveedor VARCHAR2(150) NOT NULL,
    rd_proveedor VARCHAR2(10),
    telefono VARCHAR2(10),
    email VARCHAR2(200),
    direccion VARCHAR2(200),
    cod_comuna NUMBER(4),
    CONSTRAINT proveedor_fk_comuna FOREIGN KEY (cod_comuna) REFERENCES comuna(cod_comuna)
);

-- Empleado
CREATE TABLE empleado (
    id_empleado NUMBER(4) PRIMARY KEY,
    nombre_empleado VARCHAR2(10) NOT NULL,
    apellido_paterno VARCHAR2(25) NOT NULL,
    apellido_materno VARCHAR2(25) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    sueldo_base NUMBER(10) NOT NULL,
    bono_jefatura NUMBER(10),
    activo CHAR(1) NOT NULL,
    tipo_empleado VARCHAR2(25),
    cod_empleado NUMBER(4),
    cod_salud NUMBER(6),
    cod_afp NUMBER(6)
);

-- Producto
CREATE TABLE producto (
    id_producto NUMBER(4) PRIMARY KEY,
    nombre_producto VARCHAR2(100) NOT NULL,
    precio_unitario NUMBER,
    origen_nacional CHAR(1),
    stock_minimo NUMBER(3),
    active CHAR(1),
    cod_marca NUMBER(3),
    cod_categoria NUMBER(3),
    cod_proveedor NUMBER(8),
    CONSTRAINT producto_fk_marca FOREIGN KEY (cod_marca) REFERENCES marca(cod_marca),
    CONSTRAINT producto_fk_categoria FOREIGN KEY (cod_categoria) REFERENCES categoria(cod_categoria),
    CONSTRAINT producto_fk_proveedor FOREIGN KEY (cod_proveedor) REFERENCES proveedor(id_proveedor)
);

-- tabla venta
CREATE TABLE venta (
    id_venta NUMBER(4) PRIMARY KEY,
    fecha_venta DATE NOT NULL,
    total_venta NUMBER(10) NOT NULL,
    cod_mpago NUMBER(3),
    cod_empleado NUMBER(4),
    CONSTRAINT venta_fk_empleado FOREIGN KEY (cod_empleado) REFERENCES empleado(id_empleado),
    CONSTRAINT venta_fk_medio_pago FOREIGN KEY (cod_mpago) REFERENCES medio_pago(id_mpago)
);

-- Vendedor
CREATE TABLE vendedor (
    id_empleado NUMBER(4) PRIMARY KEY,
    comision_venta NUMBER(3,2),
    CONSTRAINT vendedor_fk_empleado FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
);

-- Administrativo
CREATE TABLE administrativo (
    id_empleado NUMBER(4) PRIMARY KEY,
    CONSTRAINT admin_fk_empleado FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
);

-- Detalle_venta
CREATE TABLE detalle_venta (
    cod_venta NUMBER(4),
    cod_producto NUMBER(4),
    cantidad NUMBER(7) NOT NULL,
    CONSTRAINT detalle_venta_pk PRIMARY KEY (cod_venta, cod_producto),
    CONSTRAINT det_venta_fk_venta FOREIGN KEY (cod_venta) REFERENCES venta(id_venta),
    CONSTRAINT det_venta_fk_producto FOREIGN KEY (cod_producto) REFERENCES producto(id_producto)
);


-- RESTRICCIONES DE CLAVES FORANEAS A EMPLEADO:

ALTER TABLE empleado 
ADD CONSTRAINT empleado_fk_salud FOREIGN KEY (cod_salud) REFERENCES salud(id_salud);

ALTER TABLE empleado 
ADD CONSTRAINT empleado_fk_afp FOREIGN KEY (cod_afp) REFERENCES afp(id_afp);

ALTER TABLE empleado 
ADD CONSTRAINT empleado_fk_empleado FOREIGN KEY (cod_empleado) REFERENCES empleado(id_empleado);



-- RESTRICCIONES, CHECK Y UNIQUE:

-- Sueldo base mínimo $400.000
ALTER TABLE empleado 
ADD CONSTRAINT ck_empleado_sueldo_minimo 
CHECK (sueldo_base >= 400000);

-- Comisión entre 0 y 0.25
ALTER TABLE vendedor 
ADD CONSTRAINT ck_vendedor_comision 
CHECK (comision_venta BETWEEN 0 AND 0.25);

-- Stock mínimo de al menos 3 unidades
ALTER TABLE producto 
ADD CONSTRAINT ck_producto_stock_minimo 
CHECK (stock_minimo >= 3);

-- Email único en proveedor
ALTER TABLE proveedor 
ADD CONSTRAINT un_proveedor_email 
UNIQUE (email);

-- Nombre único en marca
ALTER TABLE marca 
ADD CONSTRAINT un_marca_nombre 
UNIQUE (nombre_marca);

-- Cantidad mayor a 0 en detalle_venta
ALTER TABLE detalle_venta 
ADD CONSTRAINT ck_detalle_venta_cantidad 
CHECK (cantidad > 0);



-- CREACION DE SECUENCIAS

-- Secuencia para salud
CREATE SEQUENCE seq_salud
START WITH 2050
INCREMENT BY 10
NOCACHE
NOCYCLE;

-- Secuencia para empleado
CREATE SEQUENCE seq_empleado
START WITH 750
INCREMENT BY 3
NOCACHE
NOCYCLE;


-- POBLAMIENTO

-- Comuna
INSERT INTO comuna (cod_comuna, nombre_comuna) VALUES (1001, 'Santiago Centro');
INSERT INTO comuna (cod_comuna, nombre_comuna) VALUES (1002, 'Providencia');
INSERT INTO comuna (cod_comuna, nombre_comuna) VALUES (1003, 'Las Condes');

-- Marca
INSERT INTO marca (cod_marca, nombre_marca) VALUES (101, 'Lider');
INSERT INTO marca (cod_marca, nombre_marca) VALUES (102, 'Tottus');
INSERT INTO marca (cod_marca, nombre_marca) VALUES (103, 'Jumbo');

-- Categoria
INSERT INTO categoria (cod_categoria, nombre_categoria) VALUES (201, 'Abarrotes');
INSERT INTO categoria (cod_categoria, nombre_categoria) VALUES (202, 'Lácteos');
INSERT INTO categoria (cod_categoria, nombre_categoria) VALUES (203, 'Bebidas');

-- Salud
INSERT INTO salud (id_salud, nom_salud) VALUES (seq_salud.NEXTVAL, 'Fonasa');
INSERT INTO salud (id_salud, nom_salud) VALUES (seq_salud.NEXTVAL, 'Isapre Colmena');
INSERT INTO salud (id_salud, nom_salud) VALUES (seq_salud.NEXTVAL, 'Isapre Bannedica');
INSERT INTO salud (id_salud, nom_salud) VALUES (seq_salud.NEXTVAL, 'Isapre Cruz Blanca');

-- Afp
INSERT INTO afp (id_afp, nom_afp) VALUES (210, 'Habitat');
INSERT INTO afp (id_afp, nom_afp) VALUES (216, 'Cuprum');
INSERT INTO afp (id_afp, nom_afp) VALUES (222, 'Provida');
INSERT INTO afp (id_afp, nom_afp) VALUES (228, 'PlanVital');

-- Medio_pago
INSERT INTO medio_pago (id_mpago, nombre_mpago) VALUES (11, 'Efectivo');
INSERT INTO medio_pago (id_mpago, nombre_mpago) VALUES (12, 'Tarjeta Débito');
INSERT INTO medio_pago (id_mpago, nombre_mpago) VALUES (13, 'Tarjeta Crédito');
INSERT INTO medio_pago (id_mpago, nombre_mpago) VALUES (14, 'Cheque');

-- Proveedor
INSERT INTO proveedor (id_proveedor, nombre_proveedor, rd_proveedor, telefono, email, direccion, cod_comuna) 
VALUES (10001, 'Distribuidora Norte', '123456789', '912345678', 'norte@empresa.com', 'Av. Principal 123', 1001);

INSERT INTO proveedor (id_proveedor, nombre_proveedor, rd_proveedor, telefono, email, direccion, cod_comuna) 
VALUES (10002, 'Mayorista Sur', '987654321', '987654321', 'sur@empresa.com', 'Calle Secundaria 456', 1002);

-- Empleado
INSERT INTO empleado (id_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp) 
VALUES (750, 'Marcela', 'González', 'Pérez', TO_DATE('15-03-2022', 'DD-MM-YYYY'), 950000, 80000, 'S', 'Administrativo', NULL, 2050, 210);

INSERT INTO empleado (id_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp) 
VALUES (753, 'José', 'Muñoz', 'Ramírez', TO_DATE('10-07-2021', 'DD-MM-YYYY'), 900000, 75000, 'S', 'Administrativo', NULL, 2060, 216);

INSERT INTO empleado (id_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp) 
VALUES (756, 'Verónica', 'Soto', 'Alarcón', TO_DATE('05-01-2020', 'DD-MM-YYYY'), 880000, 70000, 'S', 'Vendedor', 750, 2060, 228);

INSERT INTO empleado (id_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp) 
VALUES (759, 'Luis', 'Reyes', 'Fuentes', TO_DATE('15-04-2025', 'DD-MM-YYYY'), 560000, NULL, 'S', 'Vendedor', 750, 2070, 228);

INSERT INTO empleado (id_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp) 
VALUES (762, 'Claudia', 'Fernández', 'Lagos', TO_DATE('15-04-2025', 'DD-MM-YYYY'), 600000, NULL, 'S', 'Vendedor', 753, 2070, 216);

INSERT INTO empleado (id_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp) 
VALUES (765, 'Carlos', 'Navarro', 'Vega', TO_DATE('01-05-2025', 'DD-MM-YYYY'), 610000, NULL, 'S', 'Administrativo', 753, 2060, 216);

INSERT INTO empleado (id_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp) 
VALUES (768, 'Javiera', 'Pino', 'Rojas', TO_DATE('10-05-2025', 'DD-MM-YYYY'), 650000, NULL, 'S', 'Administrativo', 750, 2050, 210);

INSERT INTO empleado (id_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp) 
VALUES (771, 'Diego', 'Mella', 'Contreras', TO_DATE('12-05-2025', 'DD-MM-YYYY'), 620000, NULL, 'S', 'Vendedor', 750, 2060, 216);

INSERT INTO empleado (id_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp) 
VALUES (774, 'Fernanda', 'Salas', 'Herrera', TO_DATE('18-05-2025', 'DD-MM-YYYY'), 570000, NULL, 'S', 'Vendedor', 753, 2070, 228);

INSERT INTO empleado (id_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp) 
VALUES (777, 'Tomás', 'Vidal', 'Espinosa', TO_DATE('01-06-2025', 'DD-MM-YYYY'), 530000, NULL, 'S', 'Vendedor', NULL, 2050, 222);

-- Producto
INSERT INTO producto (id_producto, nombre_producto, precio_unitario, origen_nacional, stock_minimo, active, cod_marca, cod_categoria, cod_proveedor) 
VALUES (1001, 'Arroz Grano Entero', 1250, 'S', 10, 'S', 101, 201, 10001);

INSERT INTO producto (id_producto, nombre_producto, precio_unitario, origen_nacional, stock_minimo, active, cod_marca, cod_categoria, cod_proveedor) 
VALUES (1002, 'Leche Entera', 850, 'S', 15, 'S', 102, 202, 10002);

-- Vendedor
INSERT INTO vendedor (id_empleado, comision_venta) VALUES (756, 0.15);
INSERT INTO vendedor (id_empleado, comision_venta) VALUES (759, 0.12);
INSERT INTO vendedor (id_empleado, comision_venta) VALUES (762, 0.18);
INSERT INTO vendedor (id_empleado, comision_venta) VALUES (771, 0.10);
INSERT INTO vendedor (id_empleado, comision_venta) VALUES (774, 0.14);
INSERT INTO vendedor (id_empleado, comision_venta) VALUES (777, 0.16);

-- Administrativo
INSERT INTO administrativo (id_empleado) VALUES (750);
INSERT INTO administrativo (id_empleado) VALUES (753);
INSERT INTO administrativo (id_empleado) VALUES (765);
INSERT INTO administrativo (id_empleado) VALUES (768);

-- Venta
INSERT INTO venta (id_venta, fecha_venta, total_venta, cod_mpago, cod_empleado) 
VALUES (5050, TO_DATE('12-05-2025', 'DD-MM-YYYY'), 225990, 12, 771);

INSERT INTO venta (id_venta, fecha_venta, total_venta, cod_mpago, cod_empleado) 
VALUES (5053, TO_DATE('25-10-2025', 'DD-MM-YYYY'), 524990, 13, 777);

INSERT INTO venta (id_venta, fecha_venta, total_venta, cod_mpago, cod_empleado) 
VALUES (5056, TO_DATE('17-02-2025', 'DD-MM-YYYY'), 466990, 11, 759);

-- Detalle venta
INSERT INTO detalle_venta (cod_venta, cod_producto, cantidad) VALUES (5050, 1001, 5);
INSERT INTO detalle_venta (cod_venta, cod_producto, cantidad) VALUES (5050, 1002, 3);
INSERT INTO detalle_venta (cod_venta, cod_producto, cantidad) VALUES (5053, 1001, 8);
INSERT INTO detalle_venta (cod_venta, cod_producto, cantidad) VALUES (5056, 1002, 10);

COMMIT;


-- INFORMES

-- Informe 1: sueldo total estimado con bono de jefatura
SELECT 
    id_empleado AS identificador,
    id_empleado || ' ' || nombre_empleado || ' ' || apellido_paterno || ' ' || apellido_materno AS "NOMBRE COMPLETO",
    sueldo_base AS salario,
    bono_jefatura AS bonificacion,
    (sueldo_base + NVL(bono_jefatura, 0)) AS "SALARIO SIMULADO"
FROM empleado
WHERE activo = 'S' 
    AND bono_jefatura IS NOT NULL
ORDER BY "SALARIO SIMULADO" DESC, apellido_paterno DESC;

-- Informe 2: empleados con sueldo entre $550.000 y $800.000 con posible aumento del 8%
SELECT 
    nombre_empleado || ' ' || apellido_paterno || ' ' || apellido_materno AS empleado,
    sueldo_base AS sueldo,
    (sueldo_base * 0.08) AS "POSIBLE AUMENTO",
    (sueldo_base * 1.08) AS "SUELDO SIMULADO"
FROM empleado
WHERE activo = 'S' 
    AND sueldo_base BETWEEN 550000 AND 800000
ORDER BY sueldo_base ASC;