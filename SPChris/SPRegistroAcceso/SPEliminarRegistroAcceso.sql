CREATE OR ALTER PROCEDURE EliminarRegistroAccesos
    @IdRegistroAcceso INT
AS
BEGIN
    DELETE FROM RegistroAccesos WHERE IdAcceso = @IdRegistroAcceso
    
    RETURN @@ROWCOUNT
END;

EXEC EliminarRegistroAccesos @IdRegistroAcceso = 10;

select * from RegistroAccesos

--la tabla RegistroAcceso se puede eliminar sin verificar la integridad.