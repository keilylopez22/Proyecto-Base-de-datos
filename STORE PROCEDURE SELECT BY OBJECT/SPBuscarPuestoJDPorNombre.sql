CREATE OR ALTER  PROCEDURE SPBuscarPuestoJDPorNombre
    @Nombre VARCHAR(15)
AS
BEGIN
    SELECT
        PJD.IdPuestoJuntaDirectiva,
        PJD.Nombre,
        PJD.Descripcion
    FROM PuestoJuntaDirectiva AS PJD
    WHERE PJD.Nombre LIKE '%' + @Nombre + '%';
END

