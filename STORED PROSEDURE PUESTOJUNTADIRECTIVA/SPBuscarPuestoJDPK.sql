CREATE OR ALTER PROCEDURE SPBuscarPuestoJDPK
    @IdPuestoJuntaDirectiva INT
AS
BEGIN
   
    SELECT
        PJD.IdPuesto,
        PJD.Nombre,
        PJD.Descripcion
    FROM PuestoJuntaDirectiva  AS PJD
    WHERE PJD.IdPuesto = @IdPuestoJuntaDirectiva;
END;

EXEC SPBuscarPuestoJDPK
@IdPuestoJuntaDirectiva = 2
