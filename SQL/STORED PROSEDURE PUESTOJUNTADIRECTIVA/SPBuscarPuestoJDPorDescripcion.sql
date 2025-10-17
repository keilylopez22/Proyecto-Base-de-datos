CREATE PROCEDURE SPBuscarPuestoJDPorDescripcion
    @PalabraClave VARCHAR(50)
AS
BEGIN
    
    SELECT
        PJD.IdPuesto,
        PJD.Nombre,
        PJD.Descripcion
    FROM PuestoJuntaDirectiva PJD
    WHERE PJD.Descripcion LIKE '%' + @PalabraClave + '%';
END;
