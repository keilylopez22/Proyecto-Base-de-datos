CREATE PROCEDURE SPInsertarPuestoJD
    @Nombre VARCHAR(15),
    @Descripcion VARCHAR(100)
AS
BEGIN
    INSERT INTO PuestoJuntaDirectiva (Nombre, Descripcion)
    VALUES (@Nombre, @Descripcion);
    
    SELECT SCOPE_IDENTITY() AS IdPuesto;
END;
EXEC SPInsertarPuestoJD
    @Nombre = 'Presidente',
    @Descripcion = 'Preside las reuniones y representa a la junta directiva en actos oficiales.';

SELECT * FROM PuestoJuntaDirectiva





