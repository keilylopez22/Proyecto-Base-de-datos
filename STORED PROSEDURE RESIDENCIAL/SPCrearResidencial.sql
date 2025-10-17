CREATE PROCEDURE SPInsertarResidencial
    @Nombre VARCHAR(50)
AS
BEGIN
    INSERT INTO Residencial (Nombre)
    VALUES (@Nombre);

    
    SELECT SCOPE_IDENTITY() AS IdResidencial;
END;

EXEC SPInsertarResidencial 
@Nombre = 'Residencial El Roble';

SELECT * FROM Residencial 

