CREATE PROCEDURE SPActualizarPropietario
    @IdPropietario INT,
    @IdPersona INT
AS
BEGIN
        UPDATE Propietario
            SET IdPersona = @IdPersona
            WHERE IdPropietario = @IdPropietario;

        SELECT @IdPropietario 
   
END;

EXEC SPActualizarPropietario
@IdPropietario = 31,
@IdPersona =10

