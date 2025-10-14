CREATE  OR ALTER PROCEDURE SPEliminarResidencial
    @IdResidencial INT
AS
BEGIN

    DELETE FROM Residencial
    WHERE IdResidencial = @IdResidencial;
    
END;

EXEC SPEliminarResidencial
@IdResidencial  = ;

SELECT * FROM Residencial