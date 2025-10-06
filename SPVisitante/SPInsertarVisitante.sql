-- 1. Insertar en Visitante
CREATE OR ALTER PROCEDURE InsertarVisitante
    @FechaEntrada DATETIME,
    @FechaSalida DATETIME,
    @TipoDocumento VARCHAR(50),
    @NumeroDocumento VARCHAR(50),
    @IdPersona INT,
    @IdCluster INT,
    @NumeroVivienda INT,
    @IdGarita INT,
    @IdEmpleado INT
AS
BEGIN
    -- Validar el tipo de documento
    IF @TipoDocumento NOT IN ('DPI', 'Licencia')
    BEGIN
        RAISERROR('Tipo de documento debe ser DPI o Licencia', 16, 1)
        RETURN -1
    END
    
    INSERT INTO Visitante (FechaEntrada, FechaSalida, TipoDocumento, NumeroDocumento, IdPersona, IdCluster, NumeroVivienda, IdGarita, IdEmpleado)
    VALUES (@FechaEntrada, @FechaSalida, @TipoDocumento, @NumeroDocumento, @IdPersona, @IdCluster, @NumeroVivienda, @IdGarita, @IdEmpleado)
    
    RETURN SCOPE_IDENTITY()
END;

EXEC InsertarVisitante
    @FechaEntrada = '2025-10-11 10:00:00',
    @FechaSalida = '2025-10-11 12:00:00',
    @TipoDocumento = 'DPI',
    @NumeroDocumento = 'DPI-99998888777',
    @IdPersona = 11,
    @IdCluster = 1,
    @NumeroVivienda = 15,
    @IdGarita = 1,
    @IdEmpleado = 1;