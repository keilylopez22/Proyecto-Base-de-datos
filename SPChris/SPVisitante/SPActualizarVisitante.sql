CREATE OR ALTER PROCEDURE ActualizarVisitante
    @IdVisitante INT,
    @NombreCompleto VARCHAR(100),
    @NumeroDocumento VARCHAR(20),
    @Telefono VARCHAR(15),
    @MotivoVisita VARCHAR(100),
    @IdTipoDocumento INT
AS
BEGIN
    UPDATE Visitante 
    SET NombreCompleto = @NombreCompleto,
        NumeroDocumento = @NumeroDocumento,
        Telefono = @Telefono,
        MotivoVisita = @MotivoVisita,
        IdTipoDocumento = @IdTipoDocumento
    WHERE IdVisitante = @IdVisitante
    
    RETURN @@ROWCOUNT
END;

EXEC ActualizarVisitante 
    @IdVisitante = 1,
    @NombreCompleto = 'Juan Jose Lopez Hernandez Actualizado',
    @NumeroDocumento = '100459403124',
    @Telefono = '55123424',
    @MotivoVisita = 'Visita Familiar Actualizada',
    @IdTipoDocumento = 1;