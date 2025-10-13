-- Generado por Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   en:        2025-10-12 21:10:27 CLST
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE afp (
    id_afp     NUMBER(2) NOT NULL,
    nombre_afp VARCHAR2(100)
);

ALTER TABLE afp ADD CONSTRAINT afp_pk PRIMARY KEY ( id_afp );

CREATE TABLE asignacion_turno (
    fecha                  DATE NOT NULL,
    rol                    VARCHAR2(50) NOT NULL,
    empleado_id_empleado   NUMBER(6) NOT NULL,
    turno_id_turno         NUMBER(1) NOT NULL,
    maquina_numero_maquina NUMBER(4) NOT NULL
);

ALTER TABLE asignacion_turno ADD CONSTRAINT asignacion_turno_pk PRIMARY KEY ( empleado_id_empleado );

CREATE TABLE comuna (
    id_comuna        NUMBER(4) NOT NULL,
    nombre_comuna    CHAR(100) NOT NULL,
    region_id_region NUMBER(3) NOT NULL
);

ALTER TABLE comuna ADD CONSTRAINT comuna_pk PRIMARY KEY ( id_comuna );

CREATE TABLE empleado (
    id_empleado                    NUMBER(6) NOT NULL,
    rut                            VARCHAR2(12) NOT NULL,
    nombres                        VARCHAR2(100) NOT NULL,
    apellidos                      VARCHAR2(100) NOT NULL,
    fecha_contratacion             DATE NOT NULL,
    sueldo_base                    NUMBER(9) NOT NULL,
    estado_activo                  CHAR(1),
    planta_id_planta               NUMBER(2) NOT NULL,
    afp_id_afp                     NUMBER(2) NOT NULL,
    sistema_salud_id_sistema_salud NUMBER(2) NOT NULL
);

COMMENT ON COLUMN empleado.estado_activo IS
    'DF:''S'', CK:''S'',''N''';

ALTER TABLE empleado ADD CONSTRAINT empleado_pk PRIMARY KEY ( id_empleado );

CREATE TABLE jefe_turno (
    empleado_id          NUMBER(6) NOT NULL,
    area_responsabilidad VARCHAR2(100) NOT NULL,
    max_operarios        NUMBER(3) NOT NULL,
    empleado_id_empleado NUMBER(6) NOT NULL
);

CREATE UNIQUE INDEX jefe_turno__idx ON
    jefe_turno (
        empleado_id_empleado
    ASC );

ALTER TABLE jefe_turno ADD CONSTRAINT jefe_turno_pk PRIMARY KEY ( empleado_id );

CREATE TABLE maquina (
    numero_maquina                         NUMBER(4) NOT NULL,
    nombre                                 VARCHAR2(100),
    estado_activo                          CHAR(1) NOT NULL,
    planta_id_planta                       NUMBER(2) NOT NULL, 
--  ERROR: Column name length exceeds maximum allowed length(30) 
    "TIPO_MAQUINA_ID_TIPO_MAQUINA:_NUMBER" NUMBER(2) NOT NULL
);

COMMENT ON COLUMN maquina.estado_activo IS
    'DF:''S'', CK:''S'',''N''';

ALTER TABLE maquina ADD CONSTRAINT maquina_pk PRIMARY KEY ( numero_maquina );

CREATE TABLE operario (
    categoria_proceso    VARCHAR2(50),
    certificacion        VARCHAR2(100) NOT NULL,
    horas_standard_turno NUMBER(2),
    empleado_id_empleado NUMBER(6) NOT NULL
);

COMMENT ON COLUMN operario.categoria_proceso IS
    'Categoría: ''Caliente'', ''Frío'', ''Inspección''';

ALTER TABLE operario ADD CONSTRAINT operario_pk PRIMARY KEY ( empleado_id_empleado );

CREATE TABLE orden_mantencion (
    id_orden               NUMBER(6) NOT NULL,
    fecha_programada       DATE NOT NULL,
    fecha_ejecucion        DATE NOT NULL,
    descripcion_trabajo    VARCHAR2(500) NOT NULL,
    maquina_numero_maquina NUMBER(4) NOT NULL
);

ALTER TABLE orden_mantencion ADD CONSTRAINT orden_mantencion_pk PRIMARY KEY ( id_orden );

CREATE TABLE planta (
    id_planta        NUMBER(2) NOT NULL,
    nombre_planta    VARCHAR2(100) NOT NULL,
    direccion        VARCHAR2(200) NOT NULL,
    comuna_id_comuna NUMBER(4) NOT NULL
);

ALTER TABLE planta ADD CONSTRAINT planta_pk PRIMARY KEY ( id_planta );

CREATE TABLE region (
    id_region     NUMBER(3) NOT NULL,
    nombre_region VARCHAR2(100) NOT NULL
);

ALTER TABLE region ADD CONSTRAINT region_pk PRIMARY KEY ( id_region );

CREATE TABLE sistema_salud (
    id_sistema_salud NUMBER(2) NOT NULL,
    nombre_sistema   VARCHAR2(100) NOT NULL
);

ALTER TABLE sistema_salud ADD CONSTRAINT sistema_salud_pk PRIMARY KEY ( id_sistema_salud );

CREATE TABLE tecnico_mantencion (
    especialidad              VARCHAR2(50) NOT NULL,
    nivel_certificacion       VARCHAR2(50) NOT NULL,
    tiempo_respuesta_standard NUMBER(3) NOT NULL,
    empleado_id_empleado      NUMBER(6) NOT NULL
);

COMMENT ON COLUMN tecnico_mantencion.especialidad IS
    'Especialidad: ''Eléctrica'', ''Mecánica'', ''Instrumentación''';

ALTER TABLE tecnico_mantencion ADD CONSTRAINT tecnico_mantencion_pk PRIMARY KEY ( empleado_id_empleado );

CREATE TABLE tipo_maquina (
    "ID_TIPO_MAQUINA:_NUMBER" NUMBER(2) NOT NULL,
    nombre_tipo               VARCHAR2(100) NOT NULL
);

ALTER TABLE tipo_maquina ADD CONSTRAINT tipo_maquina_pk PRIMARY KEY ( "ID_TIPO_MAQUINA:_NUMBER" );

CREATE TABLE turno (
    id_turno     NUMBER(1) NOT NULL,
    nombre_turno VARCHAR2(50) NOT NULL,
    hora_inicio  CHAR(5) NOT NULL,
    hora_fin     CHAR(5) NOT NULL
);

COMMENT ON COLUMN turno.nombre_turno IS
    'Nombre: ''Mañana'', ''Tarde'', ''Noche''';

ALTER TABLE turno ADD CONSTRAINT turno_pk PRIMARY KEY ( id_turno );

ALTER TABLE asignacion_turno
    ADD CONSTRAINT asignacion_turno_empleado_fk FOREIGN KEY ( empleado_id_empleado )
        REFERENCES empleado ( id_empleado );

ALTER TABLE asignacion_turno
    ADD CONSTRAINT asignacion_turno_maquina_fk FOREIGN KEY ( maquina_numero_maquina )
        REFERENCES maquina ( numero_maquina );

ALTER TABLE asignacion_turno
    ADD CONSTRAINT asignacion_turno_turno_fk FOREIGN KEY ( turno_id_turno )
        REFERENCES turno ( id_turno );

ALTER TABLE comuna
    ADD CONSTRAINT comuna_region_fk FOREIGN KEY ( region_id_region )
        REFERENCES region ( id_region );

ALTER TABLE empleado
    ADD CONSTRAINT empleado_afp_fk FOREIGN KEY ( afp_id_afp )
        REFERENCES afp ( id_afp );

ALTER TABLE empleado
    ADD CONSTRAINT empleado_planta_fk FOREIGN KEY ( planta_id_planta )
        REFERENCES planta ( id_planta );

ALTER TABLE empleado
    ADD CONSTRAINT empleado_sistema_salud_fk FOREIGN KEY ( sistema_salud_id_sistema_salud )
        REFERENCES sistema_salud ( id_sistema_salud );

ALTER TABLE jefe_turno
    ADD CONSTRAINT jefe_turno_empleado_fk FOREIGN KEY ( empleado_id_empleado )
        REFERENCES empleado ( id_empleado );

ALTER TABLE maquina
    ADD CONSTRAINT maquina_planta_fk FOREIGN KEY ( planta_id_planta )
        REFERENCES planta ( id_planta );

ALTER TABLE maquina
    ADD CONSTRAINT maquina_tipo_maquina_fk FOREIGN KEY ( "TIPO_MAQUINA_ID_TIPO_MAQUINA:_NUMBER" )
        REFERENCES tipo_maquina ( "ID_TIPO_MAQUINA:_NUMBER" );

ALTER TABLE operario
    ADD CONSTRAINT operario_empleado_fk FOREIGN KEY ( empleado_id_empleado )
        REFERENCES empleado ( id_empleado );

ALTER TABLE orden_mantencion
    ADD CONSTRAINT orden_mantencion_maquina_fk FOREIGN KEY ( maquina_numero_maquina )
        REFERENCES maquina ( numero_maquina );

-- Error - Foreign Key ORDEN_MANTENCION_TECNICO_MANTENCION_FK has no columns

ALTER TABLE planta
    ADD CONSTRAINT planta_comuna_fk FOREIGN KEY ( comuna_id_comuna )
        REFERENCES comuna ( id_comuna );

ALTER TABLE tecnico_mantencion
    ADD CONSTRAINT tecnico_mantencion_empleado_fk FOREIGN KEY ( empleado_id_empleado )
        REFERENCES empleado ( id_empleado );



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            14
-- CREATE INDEX                             1
-- ALTER TABLE                             28
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   2
-- WARNINGS                                 0
