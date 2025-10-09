CREATE PROCEDURE SPInsertarPuestoJD
    @Nombre VARCHAR(15),
    @Descripcion VARCHAR(100)
AS
BEGIN
    INSERT INTO PuestoJuntaDirectiva (Nombre, Descripcion)
    VALUES (@Nombre, @Descripcion);
    
    SELECT SCOPE_IDENTITY() AS IdPuestoJuntaDirectiva;
END;





