--Insertar en ListaNegra
CREATE OR ALTER PROCEDURE InsertarListaNegra
    @Causa VARCHAR(100),
    @FechaDeclaradoNoGrato DATE,
    @IdVehiculo INT,
    @IdVisitante INT
AS
BEGIN
    INSERT INTO ListaNegra (Causa, FechaDeclaradoNoGrato, IdVehiculo, IdVisitante)
    VALUES (@Causa, @FechaDeclaradoNoGrato, @IdVehiculo, @IdVisitante)
    
    RETURN SCOPE_IDENTITY()
END;

EXEC InsertarListaNegra
    @Causa = 'Estacionamiento en áreas prohibidas',
    @FechaDeclaradoNoGrato = '2025-10-10',
    @IdVehiculo = 3,
    @IdVisitante = 3;