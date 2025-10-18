
--SP 18Determine cuantos propietarios tienen licencia tipo A. 
CREATE OR ALTER PROCEDURE SP18_PropietariosConLicenciaTipoA
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
	SELECT TOP(1)SUM(MontoTotal),FechaPago
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
	SELECT TOP(1)COUNT(*), R.NumeroVivienda, R.IdCluster
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
	SELECT TOP(1)SUM(MontoTotal), DATEPART(MONTH, FechaPago)
	FROM Pago
	--WHERE DATEPART(MONTH, FechaPago)= 08
	GROUP BY DATEPART(MONTH, FechaPago)
	ORDER BY SUM(MontoTotal) DESC
END;


