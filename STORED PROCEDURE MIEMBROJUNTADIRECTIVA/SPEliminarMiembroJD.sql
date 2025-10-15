CREATE  OR ALTER PROCEDURE SPEliminarMiembroJD
@IdMiembroJD INT
AS
BEGIN

    IF EXISTS (SELECT * 
        FROM MiembroJuntaDirectiva 
        WHERE IdMiembro = @IdMiembroJD And Estado = 'ACTIVO')
        BEGIN
        
            RAISERROR('No se puede eliminar el miembro porque aun esta activo.', 16, 1);
            RETURN 0;
        END
    DELETE FROM MiembroJuntaDirectiva
    WHERE
        IdMiembro =@IdMiembroJD 
        
END;

EXEC SPEliminarMiembroJD
@IdMiembroJD = 10

SELECT * FROM MiembroJuntaDirectiva




