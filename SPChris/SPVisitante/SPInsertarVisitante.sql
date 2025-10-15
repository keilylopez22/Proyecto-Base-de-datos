CREATE OR ALTER PROCEDURE InsertarVisitante
    @NombreCompleto VARCHAR(100),
    @NumeroDocumento VARCHAR(20),
    @Telefono VARCHAR(15),
    @MotivoVisita VARCHAR(100),
    @IdTipoDocumento INT
AS
BEGIN
    INSERT INTO Visitante (NombreCompleto, NumeroDocumento, Telefono, MotivoVisita, IdTipoDocumento)
    VALUES (@NombreCompleto, @NumeroDocumento, @Telefono, @MotivoVisita, @IdTipoDocumento)
    
    RETURN SCOPE_IDENTITY()
END;

EXEC InsertarVisitante
    @NombreCompleto = 'Maria Elena Garcia',
    @NumeroDocumento = '200123456789',
    @Telefono = '55123430',
    @MotivoVisita = 'Entrega de paquete',
    @IdTipoDocumento = 1;