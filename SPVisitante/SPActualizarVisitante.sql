-- 3. Actualizar Visitante
CREATE OR ALTER PROCEDURE ActualizarVisitante
    @IdVisitante INT,
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
    
    UPDATE Visitante 
    SET FechaEntrada = @FechaEntrada,
        FechaSalida = @FechaSalida,
        TipoDocumento = @TipoDocumento,
        NumeroDocumento = @NumeroDocumento,
        IdPersona = @IdPersona,
        IdCluster = @IdCluster,
        NumeroVivienda = @NumeroVivienda,
        IdGarita = @IdGarita,
        IdEmpleado = @IdEmpleado
    WHERE IdVisitante = @IdVisitante
    
    RETURN @@ROWCOUNT
END;

EXEC ActualizarVisitante
    @IdVisitante = 1,
    @FechaEntrada = '2025-10-06 07:30:00',
    @FechaSalida = '2025-10-06 08:45:00',
    @TipoDocumento = 'DPI',
    @NumeroDocumento = 'DPI-11112222333',
    @IdPersona = 1,
    @IdCluster = 1,
    @NumeroVivienda = 11,
    @IdGarita = 1,
    @IdEmpleado = 1;