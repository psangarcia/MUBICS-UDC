drop table if exists sedes1 cascade;
drop table if exists sedes2 cascade;
drop table if exists sedes3 cascade;
drop table if exists laboratorios cascade;
drop table if exists servicios cascade;
drop table if exists servicios2 cascade;
drop table if exists equipamiento1 cascade;
drop table if exists equipamiento2 cascade;
drop table if exists eq_lab cascade;
drop table if exists proyectos cascade;
drop table if exists personal cascade;
drop table if exists inv_pro cascade;
drop table if exists trabajar_en cascade;

CREATE TABLE sedes1 (
    id_sede numeric(2,0),
    polígono character varying(14) UNIQUE,
    área numeric(3,0) NOT NULL,
    n_parcela numeric(2,0),
    CONSTRAINT sedes1_pkey PRIMARY KEY (id_sede),
    CONSTRAINT sedes1_polígono_fkey FOREIGN KEY (polígono) REFERENCES sedes2(polígono),
    CONSTRAINT sedes1_área_fkey FOREIGN KEY (área) REFERENCES sedes3(área)
);

INSERT INTO sedes1 (id_sede, polígono, área, n_parcela) VALUES (10, 'PLATEA', 111, 99);
INSERT INTO sedes1 (id_sede, polígono, área, n_parcela) VALUES (20, 'CELLA', 222, 98);
INSERT INTO sedes1 (id_sede, polígono, área, n_parcela) VALUES (30, 'VILLARQUEMADO', 333, 97);
INSERT INTO sedes1 (id_sede, polígono, área, n_parcela) VALUES (40, 'ALBARRACÍN', 444, 96);
INSERT INTO sedes1 (id_sede, polígono, área, n_parcela) VALUES (50, 'PERALES', 555, 95);
INSERT INTO sedes1 (id_sede, polígono, área, n_parcela) VALUES (60, 'ALFAMBRA', 666, 94);
INSERT INTO sedes1 (id_sede, polígono, área, n_parcela) VALUES (70, 'VILLAFELISA', 777, 93);
INSERT INTO sedes1 (id_sede, polígono, área, n_parcela) VALUES (80, 'CULLERA', 888, 92);

CREATE TABLE sedes2 (
    polígono character varying(14) UNIQUE,
    impuestos numeric(1,2) NOT NULL,
    CONSTRAINT sedes2_pkey PRIMARY KEY (polígono)
);

INSERT INTO sedes2 (polígono, impuestos) VALUES ('PLATEA', 0.20);
INSERT INTO sedes2 (polígono, impuestos) VALUES ('CELLA', 0.40);
INSERT INTO sedes2 (polígono, impuestos) VALUES ('VILLARQUEMADO', 0.21);
INSERT INTO sedes2 (polígono, impuestos) VALUES ('ALBARRACÍN', 0.25);
INSERT INTO sedes2 (polígono, impuestos) VALUES ('PERALES', 0.30);
INSERT INTO sedes2 (polígono, impuestos) VALUES ('ALFAMBRA', 0.50);
INSERT INTO sedes2 (polígono, impuestos) VALUES ('VILLAFELISA', 0.08);
INSERT INTO sedes2 (polígono, impuestos) VALUES ('CULLERA', 0.12);


CREATE TABLE sedes3 (
    área numeric(3,0) NOT NULL,
    precio numeric(4,0) NOT NULL,
    CONSTRAINT sedes3_pkey PRIMARY KEY (área)
);

INSERT INTO sedes3 (área, precio) VALUES (111, 200);
INSERT INTO sedes3 (área, precio) VALUES (222, 1000);
INSERT INTO sedes3 (área, precio) VALUES (333, 20);
INSERT INTO sedes3 (área, precio) VALUES (444, 2200);
INSERT INTO sedes3 (área, precio) VALUES (555, 190);
INSERT INTO sedes3 (área, precio) VALUES (666, 500);
INSERT INTO sedes3 (área, precio) VALUES (777, 800);
INSERT INTO sedes3 (área, precio) VALUES (888, 350);


CREATE TABLE laboratorios (
    id_lab numeric(2,0) NOT NULL,
    nombre character varying(14) UNIQUE,
    fecha_alta date,
    id_sede numeric(2,0),
    CONSTRAINT laboratorios_pkey PRIMARY KEY (id_lab),
    CONSTRAINT laboratorios_id_sede_fkey FOREIGN KEY(id_sede) REFERENCES sedes1(id_sede)
);

INSERT INTO laboratorios (id_lab, nombre, fecha_alta, id_sede) VALUES (01, 'GENOTIPADO1', to_date('17/07/19','dd/mm/yy'), 10);
INSERT INTO laboratorios (id_lab, nombre, fecha_alta, id_sede) VALUES (02, 'SECUENCIACIÓN1', to_date('01/08/19','dd/mm/yy'), 20);
INSERT INTO laboratorios (id_lab, nombre, fecha_alta, id_sede) VALUES (03, 'HIBRIDACIÓN', to_date('12/01/20','dd/mm/yy'), 30);
INSERT INTO laboratorios (id_lab, nombre, fecha_alta, id_sede) VALUES (04, 'SONDAS_PCR', to_date('01/07/19','dd/mm/yy'), 40);
INSERT INTO laboratorios (id_lab, nombre, fecha_alta, id_sede) VALUES (05, 'GENOTIPADO2', to_date('28/10/21','dd/mm/yy'), 50);
INSERT INTO laboratorios (id_lab, nombre, fecha_alta, id_sede) VALUES (06, 'MUESTREO', to_date('09/06/19','dd/mm/yy'), 60);
INSERT INTO laboratorios (id_lab, nombre, fecha_alta, id_sede) VALUES (07, 'SECUENCIACIÓN2', to_date('01/12/21','dd/mm/yy'), 70);
INSERT INTO laboratorios (id_lab, nombre, fecha_alta, id_sede) VALUES (08, 'BIOINFORMÁTICA', to_date('01/01/20','dd/mm/yy'), 80);


CREATE TABLE servicios (
    id_servicio numeric(2,0) NOT NULL,
    nombre_servicio character varying(28),
    tipo_muestras character varying(28),
    fecha_inicio date,
    id_lab numeric(2,0) NOT NULL,
    CONSTRAINT sevicios_pkey PRIMARY KEY (id_servicio),
    CONSTRAINT servicios_fecha_inicio_fkey FOREIGN KEY (fecha_inicio) REFERENCES servicios2(fecha_inicio),
    CONSTRAINT sevicios_id_lab_fkey FOREIGN KEY (id_lab) REFERENCES laboratorios(id_lab)
);

INSERT INTO servicios (id_servicio, nombre_servicio, tipo_muestras, fecha_inicio, id_lab) VALUES (40, 'GENOTIPADO MUESTRAS', 'HERBÁCEOS', to_date('17/07/19','dd/mm/yy'), 01);
INSERT INTO servicios (id_servicio, nombre_servicio, tipo_muestras, fecha_inicio, id_lab) VALUES (42, 'SECUENCIAR', 'DNA', to_date('01/08/19','dd/mm/yy'), 02);
INSERT INTO servicios (id_servicio, nombre_servicio, tipo_muestras, fecha_inicio, id_lab) VALUES (44, 'PREPARACIÓN OLIGOS PCR', 'DNA', to_date('12/01/20','dd/mm/yy'), 03);
INSERT INTO servicios (id_servicio, nombre_servicio, tipo_muestras, fecha_inicio, id_lab) VALUES (46, 'REACTIVOS PCR', 'REACTIVOS QUÍMICOS', to_date('01/07/19','dd/mm/yy'), 04);
INSERT INTO servicios (id_servicio, nombre_servicio, tipo_muestras, fecha_inicio, id_lab) VALUES (48, 'GENOTIPADO MUESTRAS', 'HERBÁCEOS', to_date('28/10/21','dd/mm/yy'), 05);
INSERT INTO servicios (id_servicio, nombre_servicio, tipo_muestras, fecha_inicio, id_lab) VALUES (50, 'RECOGIDA DE MUESTRAS', 'HERBÁCEOS', to_date('09/06/19','dd/mm/yy'), 06);
INSERT INTO servicios (id_servicio, nombre_servicio, tipo_muestras, fecha_inicio, id_lab) VALUES (52, 'SECUENCIAR', 'DNA', to_date('01/12/21','dd/mm/yy'), 07);
INSERT INTO servicios (id_servicio, nombre_servicio, tipo_muestras, fecha_inicio, id_lab) VALUES (54, 'ANÁLISIS DATOS', 'DATOS INFORMÁTICOS', to_date('01/01/20','dd/mm/yy'), 08);
#INSERT INTO servicios (id_servicio, nombre_servicio, tipo_muestras, fecha_inicio, id_lab) VALUES (56, 'JEFE LABORATORIO', NULL, to_date('01/07/19','dd/mm/yy'), );
#INSERT INTO servicios (id_servicio, nombre_servicio, tipo_muestras, fecha_inicio, id_lab) VALUES (58, 'JEFE EMPRESA', NULL, to_date('01/07/19','dd/mm/yy'), );

CREATE TABLE servicios2 (
    fecha_inicio date,
    fecha_fin date,
    gastos numeric(7,2),
    id_lab numeric(2,0) NOT NULL,
    CONSTRAINT servicios2_pkey PRIMARY KEY (fecha_inicio),
    CONSTRAINT sevicios2_id_lab_fkey FOREIGN KEY (id_lab) REFERENCES laboratorios(id_lab)
);

INSERT INTO servicios2 (fecha_inicio, fecha_fin, gastos, id_lab) VALUES (to_date('17/07/19','dd/mm/yy'), to_date('20/10/21','dd/mm/yy'), 2300.00, 01);
INSERT INTO servicios2 (fecha_inicio, fecha_fin, gastos, id_lab) VALUES (to_date('01/08/19','dd/mm/yy'), NULL, 3000.80, 02);
INSERT INTO servicios2 (fecha_inicio, fecha_fin, gastos, id_lab) VALUES (to_date('12/01/20','dd/mm/yy'), NULL, 5000.20, 03);
INSERT INTO servicios2 (fecha_inicio, fecha_fin, gastos, id_lab) VALUES (to_date('01/07/19','dd/mm/yy'), NULL, 9000.00, 04);
INSERT INTO servicios2 (fecha_inicio, fecha_fin, gastos, id_lab) VALUES (to_date('28/10/21','dd/mm/yy'), NULL, 300.00, 05);
INSERT INTO servicios2 (fecha_inicio, fecha_fin, gastos, id_lab) VALUES (to_date('09/06/19','dd/mm/yy'), NULL, 499.99, 06);
INSERT INTO servicios2 (fecha_inicio, fecha_fin, gastos, id_lab) VALUES (to_date('01/12/21','dd/mm/yy'), to_date('20/12/21','dd/mm/yy'), 230.50, 07);
INSERT INTO servicios2 (fecha_inicio, fecha_fin, gastos, id_lab) VALUES (to_date('01/01/20','dd/mm/yy'), NULL, 600.00, 08);


CREATE TABLE equipamiento1 (
    id_equipo numeric(3,0) NOT NULL,
    modelo character varying(14) UNIQUE,
    tipo character varying(30),
    CONSTRAINT equipamiento1_pkey PRIMARY KEY (id_equipo),
    CONSTRAINT equipamiento1_modelo_fkey FOREIGN KEY (modelo) REFERENCES equipamiento2(modelo)
);

INSERT INTO equipamiento1 (id_equipo, modelo, tipo) VALUES (101, 'AX47', 'SECUENCIADOR');
INSERT INTO equipamiento1 (id_equipo, modelo, tipo) VALUES (202, 'MM55', 'SECUENCIADOR');
INSERT INTO equipamiento1 (id_equipo, modelo, tipo) VALUES (303, 'AP99', 'TERMOCICLADOR');
INSERT INTO equipamiento1 (id_equipo, modelo, tipo) VALUES (404, 'PIP44', 'MICROPIPETA');
INSERT INTO equipamiento1 (id_equipo, modelo, tipo) VALUES (505, 'PIP56', 'MICROPIPETA');
INSERT INTO equipamiento1 (id_equipo, modelo, tipo) VALUES (606, 'AG100', 'KIT EXTRACCIÓN DNA');
INSERT INTO equipamiento1 (id_equipo, modelo, tipo) VALUES (707, 'PCR007', 'REACTIVOS PARA PCR');
INSERT INTO equipamiento1 (id_equipo, modelo, tipo) VALUES (808, 'TT88', 'GRADILLAS');
INSERT INTO equipamiento1 (id_equipo, modelo, tipo) VALUES (909, 'C09', 'PACK TUBOS DE ENSAYO');
INSERT INTO equipamiento1 (id_equipo, modelo, tipo) VALUES (007, 'INF2', 'ORDENADOR ÚLITMA GENERACIÓN');


CREATE TABLE equipamiento2 (
    modelo character varying(14),
    marca character varying(24),
    precio numeric(10,2),
    CONSTRAINT equipamiento2_pkey PRIMARY KEY (modelo)
);

INSERT INTO equipamiento2 (modelo, marca, precio) VALUES ('AX47', 'THERMO FISHER', 30000.00);
INSERT INTO equipamiento2 (modelo, marca, precio) VALUES ('MM55', 'ILLUMINA', 55000.00);
INSERT INTO equipamiento2 (modelo, marca, precio) VALUES ('AP99', 'THERMO FISHER', 80000.00);
INSERT INTO equipamiento2 (modelo, marca, precio) VALUES ('PIP44', 'FISHER SCIENTIFIC', 56.00);
INSERT INTO equipamiento2 (modelo, marca, precio) VALUES ('PIP56', 'TECNYLAB', 69.90);
INSERT INTO equipamiento2 (modelo, marca, precio) VALUES ('AG100', 'INVITROGEN', 135.00);
INSERT INTO equipamiento2 (modelo, marca, precio) VALUES ('PCR007', 'QUIAGEN', 320.00);
INSERT INTO equipamiento2 (modelo, marca, precio) VALUES ('TT88', 'THERMO FISHER', 32.00);
INSERT INTO equipamiento2 (modelo, marca, precio) VALUES ('C09', 'INVITROGEN', 45.00);
INSERT INTO equipamiento2 (modelo, marca, precio) VALUES ('INF2', 'ASUS', 2100.00);

CREATE TABLE eq_lab (
    id_lab numeric(2,0) NOT NULL REFERENCES laboratorios(id_lab),
    id_equipo numeric(2,0) NOT NULL REFERENCES equipamiento1(id_equipo),
    horas numeric(2,0) ,
    CONSTRAINT eq_lab_pkey PRIMARY KEY (id_lab, id_equipo)
);

INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (01, 101, 46);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (01, 404, 46);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (01, 606, 46);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (01, 707, 46);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (01, 808, 46);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (01, 909, 46);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (02, 202, 45);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (02, 404, 45);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (02, 606, 45);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (02, 707, 45);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (02, 808, 45);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (02, 909, 45);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (02, 007, 45);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (03, 404, 30);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (03, 505, 30);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (03, 707, 30);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (03, 303, 30);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (03, 808, 30);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (03, 909, 30);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (04, 303, 20);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (04, 505, 20);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (04, 707, 20);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (04, 808, 20);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (04, 909, 20);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (04, 007, 20);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (05, 202, 50);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (05, 404, 50);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (05, 606, 50);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (05, 707, 50);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (05, 808, 50);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (05, 909, 50);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (06, 808, 30);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (06, 007, 30);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (07, 202, 47);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (07, 404, 47);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (07, 606, 47);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (07, 707, 47);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (07, 808, 47);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (07, 909, 47);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (07, 007, 47);
INSERT INTO eq_lab (id_lab, id_equipo, horas) VALUES (08, 202, 40);


CREATE TABLE proyectos (
    id_pro numeric(2,0) NOT NULL,
    nombre character varying(60),
    presupuesto numeric(7,2),
    id_lab numeric(2,0) NOT NULL,
    CONSTRAINT proyectos_pkey PRIMARY KEY (id_pro),
    CONSTRAINT proyectos_id_lab_fkey FOREIGN KEY (id_lab) REFERENCES laboratorios(id_lab)
);

INSERT INTO proyectos (id_pro, nombre, presupuesto, id_lab) VALUES (61, 'GENOTIPACIÓN ESPECIES DE INTERÉS', 100000.00, 01);
INSERT INTO proyectos (id_pro, nombre, presupuesto, id_lab) VALUES (90, 'SECUENCIAR TODAS ESPECIES', 800000, 02);
INSERT INTO proyectos (id_pro, nombre, presupuesto, id_lab) VALUES (22, 'FORMAR SONDAS PCR 1', 40000, 03);
INSERT INTO proyectos (id_pro, nombre, presupuesto, id_lab) VALUES (10, 'FORMAR SONDAS PCR 2', 70000, 04);
INSERT INTO proyectos (id_pro, nombre, presupuesto, id_lab) VALUES (39, 'GENOTIPARCIÓN NUEVAS ESPECIES', 100000, 05);
INSERT INTO proyectos (id_pro, nombre, presupuesto, id_lab) VALUES (48, 'RECOGIDA DIVERSAS Y POTENCIALES ESPECIES', 15000, 06);
INSERT INTO proyectos (id_pro, nombre, presupuesto, id_lab) VALUES (09, 'SECUENCIAR VARIANTES DE ESPECIES DE INTERÉS', 75000, 07);
INSERT INTO proyectos (id_pro, nombre, presupuesto, id_lab) VALUES (55, 'DISEÑO DE SONDAS PCR Y ANÁLISIS DE DATOS', 10000, 08);


CREATE TABLE personal (
    DNI numeric(6,0) NOT NULL,
    nombre character varying(24) NOT NULL,
    rango character varying(20) NOT NULL,
    salario numeric(7,2),
    dirección character varying(34),
    provincia character varying(24),
    CP numeric (5,0),
    CONSTRAINT personal_pkey PRIMARY KEY (DNI) 
);

INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (111111, 'ALBERTO', 'BIOINFORMÁTICO', 3000.00, 'Avda. Juan Flórez, 47', 'CORUÑA', 15009);
INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (222222, 'CARMEN', 'GENETISTA', 2300.00, 'Calle Posse, 29', 'CORUÑA', 15009);
INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (333333, 'PEDRO', 'BIÓLOGO', 2200.00, 'Avda. Méndez Núñez, 7', 'CORUÑA', 15009);
INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (444444, 'ALTEA', 'BIOQUÍMICA', 2500.00, 'Avda. Juan Flórez, 27', 'CORUÑA', 15009);
INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (555555, 'ALICIA', 'TÉCNICO LAB', 1800.00, 'Avda. de Arteixo, 50', 'CORUÑA', 15009);
INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (666666, 'AGUSTÍN', 'BIOINFORMÁTICO', 3000.00, 'Rda. de Outeiro, 20', 'CORUÑA', 15009);
INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (777777, 'ROBERTO', 'BIOINFORMÁTICO', 3000.00, 'Calle Orzán, 27', 'CORUÑA', 15009);
INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (888888, 'ANDRÉS', 'GENETISTA', 2300.00, 'Avda. de Arteixo, 37', 'CORUÑA', 15009);
INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (999999, 'LUCÍA', 'GENETISTA', 2300.00, 'Rúa Nogueira, 3', 'SANTA CRUZ', 15179);
INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (111222, 'NEREA', 'BIOQUÍMICA', 2500.00, 'Praza Orense, 5', 'CORUÑA', 15009);
INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (222333, 'MARÍA', 'BIOQUÍMICA', 2500.00, 'Rda. Nelle, 12', 'CORUÑA', 15009);
INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (444555, 'ANA', 'TÉCNICA LAB', 1800.00, 'Avda. Juan Flórez, 08', 'CORUÑA', 15009);
INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (555666, 'NURIA', 'GENETISTA', 2300.00, 'Rda. de Outeiro, 09', 'CORUÑA', 15009);
INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (777888, 'INÉS', 'TÉCNICA LAB', 1800.00, 'Rda. Nelle 15', 'CORUÑA', 15009);
INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (999000, 'MÓNICA', 'BIÓLOGA', 2200.00, 'Calle Posse, 25', 'CORUÑA', 15009);
INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (123456, 'MARTA', 'BIOQUÍMICA', 2500.00, 'Calle Orzán, 29', 'CORUÑA', 15009);
INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (567890, 'EMILIO', 'TÉCNICO LAB', 1800.00, 'Rda. de Outeiro, 22', 'CORUÑA', 15009);
INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (987654, 'ANTONIO', 'TÉCNICO LAB', 1800.00, 'Calle Matadero, 10', 'CORUÑA', 15009);
INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (321654, 'NOELIA', 'BIOINFORMÁTIC', 3000.00, 'Calle Matadero, 10', 'CORUÑA', 15009);
INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (000007, 'PAULA', 'BIOQUÍMICA', 2500.00, 'Avda. Juan Flórez, 1', 'CORUÑA', 15009);
INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (111000, 'JAVIER', 'GENETISTA', 2300.00, 'Rda. Nelle, 44', 'CORUÑA', 15009);
INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (333000, 'ALEJANDRO', 'TÉCNICO LAB', 1800.00, 'Avda. Méndez Núñez, 8', 'CORUÑA', 15009);
INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (009009, 'SANDRA', 'BIOQUÍMICA', 2500.00, 'Calle Matadero, 2', 'CORUÑA', 15009);
INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (130031, 'NIEVES', 'GENETISTA', 2300.00, 'Praza Orense, 5', 'CORUÑA', 15009);
INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (086420, 'VICENTE', 'TÉCNICO LAB', 1800.00, 'Calle Posse, 19', 'CORUÑA', 15009);
INSERT INTO personal (DNI, nombre, rango, salario, dirección, provincia, CP) VALUES (889900, 'MIRANDA', 'BIOINFORMÁTICA', 3000.00, 'Avda. Arteixo, 78', 'CORUÑA', 15009);


CREATE TABLE inv_pro (
    DNI numeric(6,0) NOT NULL REFERENCES personal(DNI),
    id_pro numeric(2,0) NOT NULL REFERENCES proyectos(id_pro),
    horas numeric(2,0),
    CONSTRAINT inv_pro_pkey PRIMARY KEY (DNI, id_pro)
);

INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (111111, 55, 30);
INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (222222, 61, 40);
INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (333333, 48, 40);
INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (444444, 10, 40);
INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (555555, 48, 50);
INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (666666, 22, 46);
INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (777777, 55, 30);
INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (888888, 90, 42);
INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (999999, 55, 30);
INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (111222, 61, 40);
INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (222333, 22, 46);
INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (444555, 10, 40);
INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (555666, 10, 40);
INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (777888, 61, 40);
INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (999000, 48, 40);
INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (123456, 90, 42);
INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (567890, 22, 46);
INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (987654, 90, 42);
INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (321654, 90, 45);
INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (000007, 39, 48);
INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (111000, 39, 48);
INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (333000, 39, 48);
INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (009009, 09, 52);
INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (130031, 09, 52);
INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (086420, 09, 52);
INSERT INTO inv_pro (DNI, id_pro, horas) VALUES (889900, 09, 52);


CREATE TABLE trabajar_en (
    DNI numeric(6,0) NOT NULL REFERENCES personal(DNI),
    id_servicio numeric(2,0) NOT NULL REFERENCES servicios(id_servicio),
    horas numeric(2,0),
    CONSTRAINT trabajar_en_pkey PRIMARY KEY (DNI, id_servicio)
); 

INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (111111, 54, 50);
INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (222222, 40, 40);
INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (333333, 50, 40);
INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (444444, 46, 40);
INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (555555, 50, 40);
INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (666666, 44, 38);
INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (777777, 54, 50);
INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (888888, 42, 45);
INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (999999, 54, 50);
INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (111222, 40, 40);
INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (222333, 44, 38);
INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (444555, 46, 40);
INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (555666, 46, 40);
INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (777888, 40, 40);
INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (999000, 50, 40);
INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (123456, 42, 45);
INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (567890, 44, 38);
INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (987654, 42, 45);
INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (321654, 42, 45);
INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (000007, 48, 42);
INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (111000, 48, 42);
INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (333000, 48, 42);
INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (009009, 52, 52);
INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (130031, 52, 52);
INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (086420, 52, 52);
INSERT INTO trabajar_en (DNI, id_servicio, horas) VALUES (889900, 52, 52);


-- CUESTIONES:

-- 1. ¿Cuántas personas participan en cada proyecto? Muestra el nombre de proyecto.
select p.id_pro, t.nombre, count(a.DNI)
from personal a join inv_pro p on a.DNI=p.DNI join proyectos t on p.id_pro=t.id_pro
group by p.id_pro, t.nombre

-- 2. Muestra los proyectos que serán viables a un año vista teniendo en cuenta el salario de los empleados y los
-- gastos de cada proyecto sabiendo que el presupuesto para cada proyecto se incrementará en un 80% a lo largo del año. 
select o.id_pro, p.nombre, s.gastos, p.presupuesto, sum(salario) as salario, (sum(salario)*12 + s.gastos) as "gastos 1 año", (p.presupuesto*1.8 - (sum(salario)*12 + s.gastos)) as "dinero restante" 
from servicios2 s join proyectos p on s.id_lab=p.id_lab join inv_pro o on p.id_pro=o.id_pro join personal a on a.DNI=o.DNI
group by o.id_pro, p.nombre, s.gastos, p.presupuesto

-- 3. ¿Cuántas personas viven en las avenidas más transitadas de Coruña? (Avda. Juan Flórez y Rda. Nelle)
select count(DNI)
from personal
where dirección LIKE 'Avda. Juan Flórez%' OR dirección like 'Rda. Nelle%'

-- 4. ¿Qué materiales tiene cada laboratorio? Muestra también el modelo y el tipo de material.
select l.nombre as laboratorio, l.id_sede, l.id_lab, e.id_equipo, j.modelo, j.tipo
from laboratorios l join eq_lab e on l.id_lab=e.id_lab join equipamiento1 j on j.id_equipo=e.id_equipo
group by l.id_lab, e.id_lab, e.id_equipo, j.modelo, j.tipo
order by l.id_lab, e.id_lab

-- 5. A causa de un incendio ocurrido en septiemebre de 2020, el laboratorio 1 tuvo que cerrar.
-- ¿Hubo algún laboratorio que se abriera posterior a este que ofreciera el mismo tipo de servicio?
select a.id_lab, a.nombre_servicio, c.fecha_alta as "nuevo laboratorio", b.fecha_inicio as "inicio servicio", b.fecha_fin as "fin servicio"
from servicios a natural join servicios2 b  natural join laboratorios c
group by a.nombre_servicio, a.id_lab, b.fecha_inicio, c.fecha_alta
having a.nombre_servicio = 'GENOTIPADO MUESTRAS'

-- 6. Muestra el DNI y nombre de los empleados/as que más horas semanales hayan trabajado en cada proyecto.
select DNI, nombre
from personal p join inv_pro inv on p.DNI=inv.DNI  
where horas in (select max(horas)
				from inv_pro
				group by id_pro)

-- 7. Muestra todos los datos de aquellos empleados/as que más ganan para cada rango en la empresa.
select *
from personal p
where salario = (select max(salario)
				from personal
				where rango = p.rango)
order by salario, rango

-- 8. Muestra la marca del equipamiento que ha implicado la mayor inversión realizada por la empresa.
SELECT marca
FROM equipamiento2
GROUP BY marca
HAVING avg(precio) >= ALL (
		SELECT avg(precio) 
		FROM equipamiento2
		GROUP BY marca
		)

-- 9. Muestra, para cada servicio ofrecido por la empresa, su nombre y cuantas horas semanales dedican en total
-- aquellos trabajadores/as cuyo salario es superior al salario medio de la empresa.
SELECT s.nombre_servicio, sum(horas)
	FROM servicios s JOIN trabajar_en t ON s.id_servicio = t.id_servicio
	JOIN personal p ON t.DNI=p.DNI
	WHERE salario > (select avg(salario) from personal)

-- 10. Muestra los proyectos de la empresa donde hay por lo menos dos trabajadores/as implicados en ellos
SELECT id_pro
FROM inv_pro
GROUP BY id_pro
HAVING count(*)>=2








