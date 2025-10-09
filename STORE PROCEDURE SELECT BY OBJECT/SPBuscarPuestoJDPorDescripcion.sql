CREATE PROCEDURE SPBuscarPuestoJDPorDescripcion
    @PalabraClave VARCHAR(50)
AS
BEGIN
    
    SELECT
        PJD.IdPuestoJuntaDirectiva,
        PJD.Nombre,
        PJD.Descripcion
    FROM PuestoJuntaDirectiva PJD
    WHERE PJD.Descripcion LIKE '%' + @PalabraClave + '%';
END;
