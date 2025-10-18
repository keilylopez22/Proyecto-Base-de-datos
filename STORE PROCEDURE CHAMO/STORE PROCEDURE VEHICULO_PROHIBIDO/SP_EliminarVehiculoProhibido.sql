CREATE OR ALTER PROCEDURE SP_EliminarVehiculoProhibido
@IdVehiculoProhibido INT
AS
BEGIN

SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM VehiculoProhibido WHERE IdVehiculoProhibido = @IdVehiculoProhibido)
BEGIN 
RAISERROR('El vehiculo dado no se encuentra en la lista de prohibidos',16,1)
RETURN
END

DELETE FROM VehiculoProhibido
WHERE IdVehiculoProhibido = @IdVehiculoProhibido
PRINT 'El vehiculo fue eliminado de la lista de prohibidos'
END

EXEC SP_EliminarVehiculoProhibido
@IdVehiculoProhibido = 1;