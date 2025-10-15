CREATE OR ALTER PROCEDURE InsertarVehiculo
    @A�o INT,
    @Placa VARCHAR(10),
    @NumeroVivienda INT,
    @IdCluster INT,
    @IdLinea INT,
    @IdMarca INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION 
        -- En esta parte vemos si la placa ya esta registrada o no.
        IF EXISTS (SELECT 1 FROM Vehiculo WHERE Placa = @Placa)
        BEGIN
            RAISERROR('Error: Ya existe un veh�culo con la placa %s', 16, 1, @Placa)
            RETURN -1
        END
        -- Aca es donde contamos cuantos veh�culos tiene registrados cada vivienda
		-- y si se intenta registrar m�s de 4 lanzar� el error
        DECLARE @CantidadVehiculos INT
        SELECT @CantidadVehiculos = COUNT(*) 
        FROM Vehiculo 
        WHERE NumeroVivienda = @NumeroVivienda AND IdCluster = @IdCluster
        IF @CantidadVehiculos >= 4
        BEGIN
            RAISERROR('Error: La vivienda %d del cluster %d ya tiene %d veh�culos (m�ximo 4 permitidos)', 16, 1, @NumeroVivienda, @IdCluster, @CantidadVehiculos)
            RETURN -2
        END
        -- Aca vemos si la vivienda existe
        IF NOT EXISTS (SELECT 1 FROM Vivienda WHERE NumeroVivienda = @NumeroVivienda AND IdCluster = @IdCluster)
        BEGIN
            RAISERROR('Error: La vivienda %d en el cluster %d no existe', 16, 1, @NumeroVivienda, @IdCluster)
            RETURN -3
        END       
        -- Ac� vemos si la linea y la marca existen, y que la linea pertenezca a la marca con la que se relaciono
        IF NOT EXISTS (SELECT 1 FROM Linea WHERE IdLinea = @IdLinea AND IdMarca = @IdMarca)
        BEGIN
            RAISERROR('Error: La l�nea %d no existe o no corresponde a la marca %d', 16, 1, @IdLinea, @IdMarca)
            RETURN -4
        END
		-- Aca ya terminaron las verificaciones y si el registro cumple se va a registrar
        INSERT INTO Vehiculo (A�o, Placa, NumeroVivienda, IdCluster, IdLinea, IdMarca)
        VALUES (@A�o, @Placa, @NumeroVivienda, @IdCluster, @IdLinea, @IdMarca)  
        COMMIT TRANSACTION
        DECLARE @NuevoId INT = SCOPE_IDENTITY()
        PRINT 'Veh�culo insertado correctamente con ID: ' + CAST(@NuevoId AS VARCHAR(10))
        RETURN @NuevoId
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        PRINT 'Error: ' + @ErrorMessage
        RETURN -1
    END CATCH
END;

--Primer registro usando el SP insertar (No deber�a lanzar error)
EXEC InsertarVehiculo
    @A�o = 2024,
    @Placa = 'NUEVA123',
    @NumeroVivienda = 101,
    @IdCluster = 1,
    @IdLinea = 1,
    @IdMarca = 1;

--La placa ya existe en la tabla, por lo que no deberia crear este registro
EXEC InsertarVehiculo
    @A�o = 2024,
    @Placa = 'P123ABC',
    @NumeroVivienda = 102,
    @IdCluster = 1,
    @IdLinea = 1,
    @IdMarca = 1;

-- Insertamos datos con distinta placa para que no nos lance el error de que la placa ya existe,
-- Debemos insertar el mismo numero de vivienda y de cluster ya que es una llave compuesta, y cuando lleguemos
-- al quinto registro lanzara el error.
EXEC InsertarVehiculo @A�o=2020, @Placa='V1', @NumeroVivienda=405, @IdCluster=4, @IdLinea=1, @IdMarca=1;
GO
EXEC InsertarVehiculo @A�o=2021, @Placa='V2', @NumeroVivienda=405, @IdCluster=4, @IdLinea=2, @IdMarca=1;
GO
EXEC InsertarVehiculo @A�o=2022, @Placa='V3', @NumeroVivienda=405, @IdCluster=4, @IdLinea=3, @IdMarca=3;
GO
EXEC InsertarVehiculo @A�o=2023, @Placa='V4', @NumeroVivienda=405, @IdCluster=4, @IdLinea=4, @IdMarca=1;
GO
-- este es el quinto registro, deber�a lanzar el error de que se llego al maximo de vehiculos permitidos
	EXEC InsertarVehiculo
    @A�o = 2024,
    @Placa = 'V5',
    @NumeroVivienda = 405,
    @IdCluster = 4,
    @IdLinea = 1,
    @IdMarca = 1;