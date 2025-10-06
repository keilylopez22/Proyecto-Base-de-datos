--Consultar por nombre de Garita
CREATE PROCEDURE ConsultarPorNombreGarita
    @NombreGarita VARCHAR(50)
AS
BEGIN
    SELECT * FROM Garita WHERE NombreGarita LIKE '%' + @NombreGarita + '%'
END;

EXEC ConsultarPorNombreGarita @NombreGarita = 'Principal'