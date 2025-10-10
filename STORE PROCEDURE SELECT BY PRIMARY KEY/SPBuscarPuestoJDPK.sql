CREATE OR ALTER PROCEDURE SPBuscarPuestoJDPK
    @IdPuestoJuntaDirectiva INT
AS
BEGIN
   
    SELECT
        PJD.IdPuestoJuntaDirectiva,
        PJD.Nombre,
        PJD.Descripcion
    FROM PuestoJuntaDirectiva  AS PJD
    WHERE PJD.IdPuestoJuntaDirectiva = @IdPuestoJuntaDirectiva;
END;
