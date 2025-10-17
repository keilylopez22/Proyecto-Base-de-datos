CREATE  OR ALTER PROCEDURE SPBuscarPuestosPorPropietario
@IdPropietario INT
AS
BEGIN
    
    SELECT
		P.PrimerNombre,
        MJD.IdJuntaDirectiva,
       	PJD.Nombre AS Puesto
      
    FROM MiembroJuntaDirectiva MJD
	INNER JOIN Propietario AS PR ON MJD.IdPropietario = PR.IdPropietario
	INNER JOIN Persona AS P ON PR.IdPersona =  P.IdPersona
   	INNER JOIN PuestoJuntaDirectiva PJD ON MJD.IdPuesto= PJD.IdPuesto
    WHERE MJD.IdPropietario = @IdPropietario
    
END;
