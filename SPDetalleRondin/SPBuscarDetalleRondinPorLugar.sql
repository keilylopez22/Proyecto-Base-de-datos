CREATE PROCEDURE SPBuscarDetalleRondinPorLugar
@Lugar VARCHAR(50)
AS 
BEGIN 
SELECT dtr.IdDetalleDelRondin, dtr.Lugar, dtr.Hora AS Fecha, e.IdEmpleado FROM DetalleDelRondin AS dtr
INNER JOIN Rondin r ON dtr.IdRondin = r.IdRondin
INNER JOIN Empleado e ON r.IdEmpleado = e.IdEmpleado
WHERE dtr.Lugar = @Lugar
END

EXEC SPBuscarDetalleRondinPorLugar
@Lugar = 'Garita'


