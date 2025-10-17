CREATE PROCEDURE SPActualizarPropietario
    @IdPropietario INT,
    @Estado VARCHAR(20) ,
    @IdPersona INT
AS
BEGIN
        UPDATE Propietario
            SET IdPersona = @IdPersona, 
            Estado = @Estado
            WHERE IdPropietario = @IdPropietario;

        SELECT @IdPropietario 
   
END;

EXEC SPActualizarPropietario
@IdPropietario = 11,
@Estado = 'INACTIVO',
@IdPersona =9

SELECT * FROM Propietario
