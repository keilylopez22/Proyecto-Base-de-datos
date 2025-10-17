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
        IdPuesto = @IdPuestoJuntaDirectiva;
    SELECT @IdPuestoJuntaDirectiva
           
END;

EXEC SPActualizarPuestoJD
@IdPuestoJuntaDirectiva = 3,  
@Nombre = 'Tesorero',
@Descripcion = 'Encargado de las finanzas de la junta directiva'

SELECT * FROM PuestoJuntaDirectiva