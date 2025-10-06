--Actualizar ListaNegra
CREATE OR ALTER PROCEDURE ActualizarListaNegra
    @IdListaNegra INT,
    @Causa VARCHAR(100),
    @FechaDeclaradoNoGrato DATE,
    @IdVehiculo INT,
    @IdVisitante INT
AS
BEGIN
    UPDATE ListaNegra 
    SET Causa = @Causa,
        FechaDeclaradoNoGrato = @FechaDeclaradoNoGrato,
        IdVehiculo = @IdVehiculo,
        IdVisitante = @IdVisitante
    WHERE IdListaNegra = @IdListaNegra
    
    RETURN @@ROWCOUNT
END;

EXEC ActualizarListaNegra
    @IdListaNegra = 1,
    @Causa = 'Incumplimiento grave de normas de vivienda',
    @FechaDeclaradoNoGrato = '2025-09-15',
    @IdVehiculo = 2,
    @IdVisitante = 2;