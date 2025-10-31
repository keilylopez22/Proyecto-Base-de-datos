--1. Construya una consulta que muestre cuántos vehículos posee cada vivienda. El procedimiento
--almacenado debe recibir como parámetro la residencia que se desea consultar (la residencia está
--formada por clúster y residencia)
CREATE OR ALTER PROCEDURE SP1_VehiculosPorVivienda
@IdCluster INT,
@NumeroVivienda INT 
AS
BEGIN
	SELECT COUNT(*) OVER (PARTITION BY v.IdCluster, v.NumeroVivienda) AS CantidadVehiculosTotal, v.IdCluster, v.NumeroVivienda, l.Descripcion AS Linea, m.Descripcion AS Marca 
	FROM Vehiculo AS v
	INNER JOIN Linea l ON v.IdLinea = l.IdLinea
	INNER JOIN Marca m ON l.IdMarca = m.IdMarca
	WHERE v.IdCluster = @IdCluster AND v.NumeroVivienda = @NumeroVivienda
	--GROUP BY v.NumeroVivienda, v.IdCluster, l.Descripcion, m.Descripcion
END;

GO
--2.  Construya una consulta que muestre cuántos vehículos ingresan de visitante por hora. El
--procedimiento almacenado debe recibir como parámetro un rango de fechas (del, al) para
--construir el reporte para ese periodo de tiempo en específico
CREATE OR ALTER PROCEDURE SP2_VehiculosPorHora
@FechaInicio DATE ,
@FechaFin DATE
AS 
BEGIN
	SELECT DATEPART(HOUR, ra.FechaIngreso) AS Hora, COUNT(*) AS CantdadVehiculos 
	FROM RegistroAccesos AS ra
	WHERE ra.FechaIngreso BETWEEN @FechaInicio and @FechaFin AND ra.IdVehiculo IS NOT NULL
	GROUP BY DATEPART(HOUR, ra.FechaIngreso)

END;

GO
--3. Construir un reporte de viviendas. Debe mostrar, por clúster, las viviendas con sus propietarios y
--si tiene inquilinos mostrar el nombre de los inquilinos
CREATE OR ALTER PROCEDURE SP3_ReporteViviendas
AS
BEGIN
	SELECT v.IdCluster, v.NumeroVivienda, CONCAT(pe.PrimerNombre, ' ', pe.PrimerApellido, '') AS Propietrario, CONCAT(per.PrimerNombre, ' ', per.PrimerApellido, '') AS Inquilino 
	FROM Vivienda AS v
	INNER JOIN Propietario p ON v.IdPropietario = p.IdPropietario
	INNER JOIN Persona pe ON p.IdPersona = pe.IdPersona
	LEFT JOIN Residente r ON v.IdCluster = r.IdCluster AND v.NumeroVivienda = r.NumeroVivienda AND r.EsInquilino = 1
	INNER JOIN Persona per ON r.IdPersona = per.IdPersona
	ORDER BY v.IdCluster, v.NumeroVivienda 
END;

--4 Construir un procedimiento almacenado que muestre los vehículos que pertenecen a una persona
--que ingresa todos los días entre las 23 horas de un día y la 1 am del día siguiente. Debe recibir
--como parámetro las fechas (del, al).
GO
CREATE OR ALTER PROCEDURE SP4_VehiculosDePersonas 
@FechaInicio DATE,
@FechaFin  DATE
AS
BEGIN 
		SELECT CONCAT(p.PrimerNombre, ' ',P.PrimerApellido) AS NombreCompleto, m.Descripcion
		FROM RegistroAccesos AS ra
		INNER JOIN Residente AS r
		ON ra.IdResidente = r.IdResidente
		INNER JOIN Persona AS P 
		ON r.IdPersona = p.IdPersona
		INNER JOIN Vehiculo AS vh
		ON ra.IdVehiculo = vh.IdVehiculo
		INNER JOIN Linea AS l 
		ON vh.IdLinea = l.IdLinea 
		INNER JOIN Marca AS m 
		ON l.IdMarca = m.IdMarca
		WHERE ra.FechaIngreso >= @FechaInicio AND ra.FechaIngreso  < DATEADD(DAY,1, @FechaFin)
			  AND (DATEPART (HOUR, ra.FechaIngreso)= 23
			  OR  DATEPART(HOUR, ra.FechaIngreso) = 0 
			  OR  DATEPART(HOUR, ra.FechaIngreso)= 1)
		ORDER BY ra.FechaIngreso;
END;

GO
--5 Construya un procedimiento almacenado que reciba un periodo de tiempo y determine quién es
--el vecino que más ha pagado en ese período de tiempo
CREATE OR ALTER PROCEDURE SP5_VecinoPagoTiempo
@FechaInicio DATE,
@FechaFin DATE
AS
BEGIN
	SELECT TOP 1 CONCAT(per.PrimerNombre,' ', per.SegundoNombre,' ',per.PrimerApellido, ' ', per.SegundoApellido) AS Vecino, sum(p.MontoTotal) AS TotalPagado
	FROM Pago AS  p 
	INNER JOIN Recibo AS  r
	ON p.IdPago = r.IdPago
	INNER JOIN DetalleRecibo AS dr 
	ON dr.IdRecibo = r.IdRecibo
	INNER  JOIN CobroServicioVivienda AS csv
	ON dr.idCobroServicio = csv.idCobroServicio
	INNER JOIN Vivienda AS v
	ON csv.NumeroVivienda = v.NumeroVivienda
	AND csv.IdCluster = v.IdCluster
	INNER JOIN Propietario AS pro
	ON v.IdPropietario = PRO.IdPropietario
	INNER JOIN Persona AS per
	ON pro.IdPersona = per.IdPersona
	WHERE p.FechaPago BETWEEN @FechaInicio AND @FechaFin
	GROUP BY  per.PrimerNombre, per.SegundoNombre, per.PrimerApellido, per.SegundoApellido
	ORDER BY TotalPagado DESC	 
END;

GO
---- 6 Construya un procedimiento almacenado que muestre todos los propietarios de condominio
--Diana II que son casados y menores de 30 años.
CREATE OR ALTER PROCEDURE SP6_PropietariosCondomio 
AS
BEGIN 
		SELECT c.Descripcion, CONCAT(per.PrimerNombre, '', per.PrimerApellido) AS NombreCompleto, DATEDIFF (YEAR, per.FechaNacimiento, GETDATE()) AS Edad, per.EstadoCivil
		FROM Propietario AS Pro
		INNER JOIN Persona AS per ON pro.IdPersona = per.IdPersona
		INNER JOIN Vivienda AS v ON pro.IdPropietario = v.IdPropietario
		INNER JOIN Cluster AS c ON v.IdCluster = c.IdCluster
		WHERE C.Descripcion = 'Diana II'
		AND DATEDIFF (YEAR, per.FechaNacimiento, GETDATE())< 30
		AND (per.EstadoCivil = 'Casado' or per.EstadoCivil = 'Casada');
END;

GO
-- 7) Construya un procedimiento almacenado que determine quien es la persona 
--que mas ha sido presidente en una junta directiva.
CREATE OR ALTER PROCEDURE SP7_MasVecesPresidenteJD
AS
BEGIN
WITH CantidadVeces AS (
SELECT COUNT(*) AS Cantidad, CONCAT(p.PrimerNombre, ' ', p.PrimerApellido, ' ') AS Miembro, pjd.Nombre AS Puesto FROM Persona AS p
INNER JOIN Propietario pr ON p.IdPersona = pr.IdPersona
INNER JOIN MiembroJuntaDirectiva mjd ON pr.IdPropietario = mjd.IdPropietario
INNER JOIN PuestoJuntaDirectiva pjd ON mjd.idPuesto = pjd.idPuesto
INNER JOIN JuntaDirectiva jd ON mjd.IdJuntaDirectiva = jd.IdJuntaDirectiva
WHERE pjd.Nombre = 'Presidente' 
GROUP BY CONCAT(p.PrimerNombre, ' ', p.PrimerApellido, ' '), pjd.Nombre
)
SELECT * FROM CantidadVeces
WHERE Cantidad = (SELECT MAX(Cantidad) FROM CantidadVeces)
END;

GO
-- 8) Construya un procedimiento almacenado que determine quien es 
--la persona que nunca ha sido miembro de una junta directiva. 
CREATE OR ALTER PROCEDURE SP8_PersonasNoMiembrosJD
AS
BEGIN
SELECT CONCAT(p.PrimerNombre, ' ', p.PrimerApellido, ' ') AS Miembro, mjd.Estado FROM Persona AS p
LEFT JOIN Propietario pr ON p.IdPersona = pr.IdPersona
LEFT JOIN MiembroJuntaDirectiva mjd ON pr.IdPropietario = mjd.IdPropietario
WHERE mjd.IdJuntaDirectiva IS NULL
END;

GO
-- 9)Construya un procedimiento almacenado que dado un periodo tiempo 
--determine si un guardia ha trabajado más de 24 horas en un turno.
CREATE OR ALTER PROCEDURE SP9_GuardiasConMasDe24Horas
@FechaInicio DATE,
@FechaFin DATE,
@IdTurno INT
AS 
BEGIN

SELECT e.IdEmpleado, CONCAT(p.PrimerNombre, ' ', p.PrimerApellido, ' ') AS Empleado, pe.Nombre AS Puesto,t.Descripcion AS Turno ,COUNT(ta.IdTurno) AS CantidadTurnos, 
SUM(CASE 
WHEN t.HoraFin < t.HoraInicio 
THEN DATEDIFF(HOUR, t.HoraInicio, DATEADD(DAY, 1, t.HoraFin))
ELSE DATEDIFF(HOUR,t.HoraInicio, t.HoraFin )
END
) AS Horas FROM Turno AS t
INNER JOIN AsignacionTurno ta ON t.IdTurno = ta.IdTurno
INNER JOIN Empleado e ON ta.IdEmpleado = e.IdEmpleado
INNER JOIN PuestoEmpleado pe ON e.IdPuestoEmpleado = pe.IdPuestoEmpleado
INNER JOIN Persona p ON e.IdPersona = p.IdPersona
WHERE pe.Nombre = 'Guardia' AND ta.FechaAsignacion BETWEEN @FechaInicio AND @FechaFin AND t.IdTurno = @IdTurno
GROUP by e.IdEmpleado, pe.Nombre, p.PrimerNombre, p.PrimerApellido, t.Descripcion
HAVING COUNT(ta.IdTurno) > 3 OR SUM(CASE 
WHEN t.HoraFin < t.HoraInicio 
THEN DATEDIFF(HOUR, t.HoraInicio, DATEADD(DAY, 1, t.HoraFin))
ELSE DATEDIFF(HOUR,t.HoraInicio, t.HoraFin )
END
) > 24
END;

GO
-- 10) Construya una consulta que muestre cuantos guardias son hombres y cuantos son mujeres.
CREATE OR ALTER PROCEDURE SP10_CantidadGuardiasHombreMujeres
AS
BEGIN

SELECT p.Genero,pe.Nombre AS Puesto , COUNT(e.IdEmpleado) AS CantidadGenero FROM Persona AS p
INNER JOIN Empleado e ON p.IdPersona = e.IdPersona
INNER JOIN PuestoEmpleado pe on e.IdPuestoEmpleado = pe.IdPuestoEmpleado
WHERE pe.Nombre = 'Guardia'
GROUP BY p.Genero, pe.Nombre
END;

GO
-- 11) Determine quien es el vecino que mas veces ingresa y sale del condominio los dias domingo.
CREATE OR ALTER PROCEDURE SP11_VecinoConMasSalidasDomingo
AS
BEGIN

SELECT TOP 1 CONCAT(p.PrimerNombre, ' ', p.PrimerApellido, ' ') AS Vecino, COUNT(*) AS CantidadSalidasEntradas FROM Garita AS g
INNER JOIN RegistroAccesos ra ON g.IdGarita = ra.IdGarita
INNER JOIN Residente r ON ra.IdResidente = r.IdResidente
INNER JOIN Persona p ON r.IdPersona = p.IdPersona
INNER JOIN Cluster c ON g.IdCluster = c.IdCluster
WHERE DATEPART(WEEKDAY, ra.FechaIngreso) = '1' OR DATEPART(WEEKDAY, ra.FechaSalida) = '1'
GROUP BY p.PrimerNombre, p.PrimerApellido
ORDER BY CantidadSalidasEntradas
END;

GO
-- 12) Determine cual es la vivienda mas atrasada en los pagos de mantenimiento.
CREATE OR ALTER PROCEDURE SP12_ViviendaAtrasadaEnPagos
AS
BEGIN
SELECT TOP 1 v.NumeroVivienda, COUNT(*) PagosAusentes, MAX(csv.FechaCobro) AS UltimoCobro,MAX(DATEDIFF(DAY, csv.FechaCobro, GETDATE())) AS CantidadDiasAtrasado FROM Vivienda AS v
INNER JOIN CobroServicioVivienda csv ON v.NumeroVivienda = csv.NumeroVivienda
WHERE csv.EstadoPago = 'PENDIENTE'
GROUP BY  v.NumeroVivienda
ORDER BY CantidadDiasAtrasado DESC
END;

GO
-- SP 13 Determine cual es del dia del mes que mas dinero se recibe. 
CREATE OR ALTER PROCEDURE SP13_DiaDelMesConMayorIngreso
@Mes INT
AS
BEGIN
	IF @MES >12
	BEGIN
	RAISERROR('Mes Invalido', 16,1)
	RETURN 0;
	END;
	SELECT TOP(1)SUM(MontoTotal) AS MontoTotalMes,DAY(FechaPago) AS Dia, MONTH(FechaPago) AS Mes
	FROM Pago
	WHERE DATEPART(MONTH, FechaPago)= @Mes
	GROUP BY FechaPago
	ORDER BY SUM(MontoTotal) DESC
END;

GO 
--Determine cual es la residencia que mas recibos ha recibido.
CREATE OR ALTER PROCEDURE SP14_ResidenciaConMasRecibos
AS
BEGIN
	SELECT TOP(1)COUNT(*) AS CantidadRecibos, R.NumeroVivienda, R.IdCluster
	FROM Recibo AS R
	GROUP BY R.NumeroVivienda, R.IdCluster
	ORDER BY COUNT(*) DESC
END;

GO
--Construya un reporte que muestre por mes cuantos carros ingresaron por dia.
CREATE OR ALTER PROCEDURE SP15_ReporteVehiculosPorMesPorDia
@Mes INT
AS
BEGIN
	IF @Mes >12
	BEGIN
		RAISERROR('Mes Invalido',16,1)
		RETURN ;
	END;
	SELECT COUNT(*) AS 'Total Vehiculos', CAST(FechaIngreso AS DATE) AS Dia
	FROM RegistroAccesos AS R
	WHERE IdVehiculo IS NOT NULL AND DATEPART(MONTH, FechaIngreso )=@Mes
	GROUP BY CAST(FechaIngreso AS DATE)
END;

GO
--Identifique quien es la persona que mas visita el condominio.
CREATE OR ALTER PROCEDURE SP16_VisitanteMasFrecuente
AS
BEGIN 

	SELECT TOP(1)V.NombreCompleto AS Visitante,(COUNT(* ))AS Cantidad
	FROM RegistroAccesos AS R
	INNER JOIN Visitante AS V ON R.IdVisitante = V.IdVisitante
	GROUP BY V.IdVisitante, V.NombreCompleto
	ORDER BY COUNT(* ) DESC
END;

GO
--Determine si existen inquilinos que son propietarios. 
CREATE OR ALTER PROCEDURE SP17_inquilinosPropietarios
AS
BEGIN
	SELECT CONCAT(P.PrimerNombre, ' ',COALESCE( P.SegundoNombre, '') ,' ' ,P.PrimerApellido, ' ' ,COALESCE(P.SegundoApellido, '' )) AS Propietario, PR.IdPropietario, R.EsInquilino,
	V.NumeroVivienda, V.IdCluster
	FROM Persona AS P
	INNER JOIN Propietario AS PR ON P.IdPersona = PR.IdPersona
	INNER JOIN Residente AS R ON P.IdPersona = R.IdPersona
	INNER JOIN Vivienda AS V ON R.NumeroVivienda = V.NumeroVivienda AND R.IdCluster = V.IdCluster
	WHERE R.EsInquilino = 1
END;

GO
-- SP 18 Determine cuantos propietarios tienen licencia tipo A. 
CREATE OR ALTER  PROCEDURE SP18_PropietariosConLicenciaTipoA
AS
BEGIN
		SELECT COUNT(*) AS ' Total Propietarios',TD.Nombre AS Documento
		FROM Propietario AS PR
		INNER JOIN Persona AS P ON PR.IdPersona = P.IdPersona
		INNER JOIN DocumentoPersona AS DP ON P.IdPersona = DP.IdPersona
		INNER JOIN TipoDocumento AS TD ON DP.IdTipoDocumento = TD.IdTipoDocumento
		WHERE TD.Nombre ='Licencia Tipo A' 
		Group by TD.Nombre
END;

GO
--19. Prepare una consulta que muestre si una persona debe pagar 150 
--por sobrepasar la cantidad de carros permitida por vivienda. 
CREATE OR ALTER PROCEDURE SP19_ConsultarCantidadVehiculos
	@NumeroVivienda INT = NULL,
	@IdCluster INT = NULL
AS 
BEGIN
	SELECT
		v.NumeroVIVienda,
		v.IdCluster,
		COUNT(ve.IdVehiculo) AS CantidadVehiculos,
		CASE
			WHEN COUNT(ve.IdVehiculo) > 4 THEN 'Debe pagar la multa de 150 por sobrepasar el limite de vehiculos permitidos'
			ELSE 'No rebasa el limite de vehiculos permitidos'
		END AS EstadoPago,
		CASE
			WHEN COUNT(ve.IdVehiculo) > 4 THEN 150.00
			ELSE 0.00
		END AS MontoMulta
	FROM Vivienda AS v
	LEFT JOIN Vehiculo ve ON v.NumeroVivienda = ve.NumeroVivienda 
	AND v.IdCluster = ve.IdCluster
	WHERE 
		(@NumeroVivienda IS NULL OR v.NumeroVivienda = @NumeroVivienda)
		AND (@IdCluster IS NULL OR v.IdCluster = @IdCluster)
	GROUP BY v.NumeroVivienda, v.IdCluster
	HAVING COUNT(ve.IdVehiculo) > 4 OR @NumeroVivienda IS NOT NULL
	ORDER BY CantidadVehiculos DESC
END;

GO
--20. Cree un procedimiento almacenado que muestre cual es 
--la residencia que más visitas recibe en un periodo de tiempo dado. 
CREATE OR ALTER PROCEDURE SP20_ResidenciaMasVisitada
	@FechaInicio DATE,
	@FechaFin DATE
AS
BEGIN
	SELECT TOP 1
		r.NumeroVivienda,
		r.IdCluster,
		COUNT(ra.IdAcceso) AS TotalVisitas,
		P.PrimerNombre + ' ' + p.PrimerApellido AS ResidentePrincipal,
		c.Descripcion AS Cluster,
		(SELECT Descripcion FROM TipoVivienda WHERE IdTipoVivienda = v.IdTipoVivienda) AS TipoVivienda
	FROM RegistroAccesos AS ra
	INNER JOIN Residente AS r ON ra.IdResidente = r.IdResidente
	INNER JOIN Vivienda AS v ON r.NumeroVivienda = v.NumeroVivienda AND r.IdCluster = v.IdCluster
	INNER JOIN Persona AS p ON r.IdPersona = p.IdPersona
	INNER JOIN Cluster AS c ON r.IdCluster = c.IdCluster
	WHERE
		ra.FechaIngreso BETWEEN @FechaInicio AND @FechaFin
		AND ra.IdVisitante IS NOT NULL
	GROUP BY r.NumeroVivienda, r.IdCluster, p.PrimerNombre, p.PrimerApellido, c.Descripcion, v.IdTipoVivienda
	ORDER BY TotalVisitas DESC
END;
GO
-- 21. Cual es el concepto de multa mas utilizado en un periodo de tiempo dado. 
CREATE OR ALTER PROCEDURE SP21_ConceptoMultaMasUtilizado
	@FechaInicio DATE,
	@FechaFin DATE
AS 
BEGIN
	SELECT TOP 1
		tm. IdTipoMulta,
		tm.Nombre AS ConceptoMulta,
		COUNT(mv.IdMultaVivienda) AS CantidadMultas,
		tm.Monto AS MontoPorMulta,
		COUNT(mv.IdMultaVivienda) * tm.Monto AS TotalRecaudado
	FROM MultaVivienda AS mv
	INNER JOIN TipoMulta AS tm ON mv.IdTipoMulta = tm.IdTipoMulta
	WHERE
		mv.FechaInfraccion BETWEEN @FechaInicio AND @FechaFin
	GROUP BY tm.IdTipoMulta, tm.Nombre, tm.Monto
	ORDER BY CantidadMultas DESC
END;

GO
--22. Cuales son las casas pendientes de pagar multas.
CREATE OR ALTER PROCEDURE SP22_CasasPendientesPagoMultas
AS
BEGIN
	SELECT 
		mv.NumeroVivienda,
		mv.IdCluster,
		tm.Nombre AS ConceptoMulta,
		mv.Monto,
		mv.FechaInfraccion,
		mv.FechaRegistro,
		DATEDIFF(DAY, mv.FechaRegistro, GETDATE()) AS DiasPendiente,
		p.PrimerNombre + ' ' + p.PrimerApellido AS Propietario,
		p.Telefono
	FROM MultaVivienda AS mv
	INNER JOIN TipoMulta AS tm ON mv.IdTipoMulta = tm.IdTipoMulta
	INNER JOIN Vivienda AS v On mv.NumeroVivienda = v.NumeroVivienda 
	AND mv.IdCluster = v.IdCluster
	INNER JOIN Propietario AS pr ON v.IdPropietario = pr.IdPropietario
	INNER JOIN Persona AS p ON pr.IdPersona = p.IdPersona
	WHERE
		mv.EstadoPago = 'PENDIENTE'
	ORDER BY DiasPendiente DESC, mv.Monto DESC
END;

GO
 GO
-- 23. Cual es el mes del año donde han ocurrido mas multas por concepto de desorden. 
CREATE OR ALTER PROCEDURE SP23_MesMultasDesorden
	@Anio INT = NULL
AS
BEGIN
	SELECT TOP 1
		MONTH(mv.FechaInfraccion) AS Mes,
		DATENAME(MONTH, mv.FechaInfraccion) AS NombreMes,
		COUNT(*) AS CantidadMulta,
		'Ruido excesivo' AS ConceptoMulta,
		MAX(tm.Monto) AS MontoPorMulta,
		SUM(tm.Monto) AS TotalRecaudado
	FROM MultaVivienda AS mv
	INNER JOIN TipoMulta AS tm 
	ON mv.IdTipoMulta = tm.IdTipoMulta
	WHERE
		(@Anio IS NULL OR YEAR(mv.FechaInfraccion) = @Anio)
		AND tm.Nombre = 'Ruido excesivo'
	GROUP BY
		MONTH(mv.FechaInfraccion),
		DATENAME(MONTH, mv.FechaInfraccion)
	ORDER BY CantidadMulta DESC
END;

GO
--24. Cuanto se ha recaudado por concepto de multas. 
CREATE OR ALTER PROCEDURE SP_24TotalRecaudadoMultas
    @FechaInicio DATE = NULL,
    @FechaFin DATE = NULL
AS
BEGIN
    SELECT 
        COUNT(mv.IdMultaVivienda) AS TotalMultas,
        SUM(mv.Monto) AS TotalRecaudado,
        AVG(mv.Monto) AS PromedioPorMulta,
        SUM(CASE WHEN mv.EstadoPago = 'PAGADO' THEN mv.Monto ELSE 0 END) AS TotalPagado,
        SUM(CASE WHEN mv.EstadoPago = 'PENDIENTE' THEN mv.Monto ELSE 0 END) AS TotalPendiente,
        COUNT(CASE WHEN mv.EstadoPago = 'PAGADO' THEN 1 END) AS MultasPagadas,
        COUNT(CASE WHEN mv.EstadoPago = 'PENDIENTE' THEN 1 END) AS MultasPendientes
    FROM MultaVivienda mv
    WHERE 
        (@FechaInicio IS NULL OR mv.FechaInfraccion >= @FechaInicio)
        AND (@FechaFin IS NULL OR mv.FechaInfraccion <= @FechaFin)
END;

GO
--SP 25 Quien es el propietario con mas multas. 
CREATE OR ALTER PROCEDURE SP25_PropietarioConMasMultas
AS
BEGIN
SELECT TOP(1) COUNT(*) AS 'Cantidad De Multas',  CONCAT(PS.PrimerNombre,' ' ,PS.PrimerApellido) AS Propietario
FROM Propietario AS P
INNER JOIN Persona AS PS ON P.IdPersona = PS.IdPersona
INNER JOIN Vivienda AS V ON P.IdPropietario = V.IdPropietario
INNER JOIN MultaVivienda AS MV ON V.NumeroVivienda = MV.NumeroVivienda AND V.IdCluster = MV.IdCluster
GROUP BY P.IdPropietario, CONCAT(PS.PrimerNombre,' ', PS.PrimerApellido)
ORDER BY COUNT(*) DESC
END;

GO

--SP INVENTADO
--Cual es el mes que mas dinero se recibio.
CREATE OR ALTER PROCEDURE SP_IN
AS
BEGIN
	SELECT TOP(1)SUM(MontoTotal), DATEPART(MONTH, FechaPago)--FechaPago
	FROM Pago
	--WHERE DATEPART(MONTH, FechaPago)= 08
	GROUP BY DATEPART(MONTH, FechaPago)  --FechaPago
	ORDER BY SUM(MontoTotal) DESC
END;


