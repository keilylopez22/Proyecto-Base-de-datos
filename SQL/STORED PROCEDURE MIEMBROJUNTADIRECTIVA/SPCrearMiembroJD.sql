CREATE  OR ALTER PROCEDURE SPInsertarMiembroJD
    @Estado VARCHAR(10),
    @FechaInicio DATE,
    @FechaFin DATE,
    @IdJuntaDirectiva INT,
    @IdPropietario INT,
    @IdPuestoJuntaDirectiva INT
AS
BEGIN
    INSERT INTO MiembroJuntaDirectiva (Estado,FechaInicio,FechaFin,IdJuntaDirectiva, IdPropietario, IdPuesto)
    VALUES (@Estado,@FechaInicio,@FechaFin, @IdJuntaDirectiva, @IdPropietario, @IdPuestoJuntaDirectiva)
    SELECT SCOPE_IDENTITY() AS 'IdMiembroJuntaDirectiva'
    
END;

EXEC SPInsertarMiembroJD
@Estado ='INACTIVO',
@FechaInicio ='2022-07-01',
@FechaFin ='2023-07-01',
@IdJuntaDirectiva =1,
@IdPropietario =1,
@IdPuestoJuntaDirectiva =1

SELECT * FROM MiembroJuntaDirectiva