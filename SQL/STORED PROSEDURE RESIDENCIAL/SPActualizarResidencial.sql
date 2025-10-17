CREATE OR ALTER PROCEDURE SPActualizarResidencial
@IdResidencial INT,
@Nombre VARCHAR(50)
AS
BEGIN
    UPDATE Residencial
    SET
        Nombre = @Nombre
    WHERE
        IdResidencial = @IdResidencial;
   
END;


EXEC SPActualizarResidencial
@IdResidencial = 2, 
@Nombre = 'Residencial El Roble Actualizado';

SELECT * FROM Residencial