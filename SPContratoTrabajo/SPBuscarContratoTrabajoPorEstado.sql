CREATE PROCEDURE SPBuscarContratoTrabajoPorEstado
@Estado VARCHAR(20)
AS
BEGIN 
SELECT ct.IdNumeroContrato, ct.Estado FROM ContratoTrabajo AS ct
WHERE Estado = @Estado
END

EXEC SPBuscarContratoTrabajoPorEstado
@Estado = 'Finalizado'
