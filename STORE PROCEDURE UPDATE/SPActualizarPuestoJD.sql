CREATE  OR ALTER PROCEDURE SPActualizarPuestoJD
    @IdPuestoJuntaDirectiva INT,
    @Nombre VARCHAR(15),
    @Descripcion VARCHAR(100)
AS
BEGIN
    
    UPDATE PuestoJuntaDirectiva
    SET
        Nombre = @Nombre,
        Descripcion = @Descripcion
    WHERE
        IdPuestoJuntaDirectiva = @IdPuestoJuntaDirectiva;
           
END;