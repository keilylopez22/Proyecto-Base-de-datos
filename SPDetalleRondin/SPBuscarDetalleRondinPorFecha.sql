CREATE PROCEDURE SPBuscarDetalleRondinPorFecha
@Fecha DATE
AS 
BEGIN 
SELECT dtr.IdDetalleDelRondin, dtr.Lugar, dtr.Hora AS Fecha, e.IdEmpleado FROM DetalleDelRondin AS dtr
INNER JOIN Rondin r ON dtr.IdRondin = r.IdRondin
INNER JOIN Empleado e ON r.IdEmpleado = e.IdEmpleado
WHERE dtr.Hora = @Fecha
END

EXEC SPBuscarDetalleRondinPorFecha
@Fecha = '2025-10-03'


