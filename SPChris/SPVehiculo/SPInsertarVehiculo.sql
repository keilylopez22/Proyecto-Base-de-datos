CREATE OR ALTER PROCEDURE InsertarVehiculo
    @Año INT,
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
            RAISERROR('Error: Ya existe un vehículo con la placa %s', 16, 1, @Placa)
            RETURN -1
        END
        -- Aca es donde contamos cuantos vehículos tiene registrados cada vivienda
		-- y si se intenta registrar más de 4 lanzará el error
        DECLARE @CantidadVehiculos INT
        SELECT @CantidadVehiculos = COUNT(*) 
        FROM Vehiculo 
        WHERE NumeroVivienda = @NumeroVivienda AND IdCluster = @IdCluster
        IF @CantidadVehiculos >= 4
        BEGIN
            RAISERROR('Error: La vivienda %d del cluster %d ya tiene %d vehículos (máximo 4 permitidos)', 16, 1, @NumeroVivienda, @IdCluster, @CantidadVehiculos)
            RETURN -2
        END
        -- Aca vemos si la vivienda existe
        IF NOT EXISTS (SELECT 1 FROM Vivienda WHERE NumeroVivienda = @NumeroVivienda AND IdCluster = @IdCluster)
        BEGIN
            RAISERROR('Error: La vivienda %d en el cluster %d no existe', 16, 1, @NumeroVivienda, @IdCluster)
            RETURN -3
        END       
        -- Acá vemos si la linea y la marca existen, y que la linea pertenezca a la marca con la que se relaciono
        IF NOT EXISTS (SELECT 1 FROM Linea WHERE IdLinea = @IdLinea AND IdMarca = @IdMarca)
        BEGIN
            RAISERROR('Error: La línea %d no existe o no corresponde a la marca %d', 16, 1, @IdLinea, @IdMarca)
            RETURN -4
        END
		-- Aca ya terminaron las verificaciones y si el registro cumple se va a registrar
        INSERT INTO Vehiculo (Año, Placa, NumeroVivienda, IdCluster, IdLinea, IdMarca)
        VALUES (@Año, @Placa, @NumeroVivienda, @IdCluster, @IdLinea, @IdMarca)  
        COMMIT TRANSACTION
        DECLARE @NuevoId INT = SCOPE_IDENTITY()
        PRINT 'Vehículo insertado correctamente con ID: ' + CAST(@NuevoId AS VARCHAR(10))
        RETURN @NuevoId
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        PRINT 'Error: ' + @ErrorMessage
        RETURN -1
    END CATCH
END;

--Primer registro usando el SP insertar (No debería lanzar error)
EXEC InsertarVehiculo
    @Año = 2024,
    @Placa = 'NUEVA123',
    @NumeroVivienda = 101,
    @IdCluster = 1,
    @IdLinea = 1,
    @IdMarca = 1;

--La placa ya existe en la tabla, por lo que no deberia crear este registro
EXEC InsertarVehiculo
    @Año = 2024,
    @Placa = 'P123ABC',
    @NumeroVivienda = 102,
    @IdCluster = 1,
    @IdLinea = 1,
    @IdMarca = 1;

-- Insertamos datos con distinta placa para que no nos lance el error de que la placa ya existe,
-- Debemos insertar el mismo numero de vivienda y de cluster ya que es una llave compuesta, y cuando lleguemos
-- al quinto registro lanzara el error.
EXEC InsertarVehiculo @Año=2020, @Placa='V1', @NumeroVivienda=405, @IdCluster=4, @IdLinea=1, @IdMarca=1;
GO
EXEC InsertarVehiculo @Año=2021, @Placa='V2', @NumeroVivienda=405, @IdCluster=4, @IdLinea=2, @IdMarca=1;
GO
EXEC InsertarVehiculo @Año=2022, @Placa='V3', @NumeroVivienda=405, @IdCluster=4, @IdLinea=3, @IdMarca=3;
GO
EXEC InsertarVehiculo @Año=2023, @Placa='V4', @NumeroVivienda=405, @IdCluster=4, @IdLinea=4, @IdMarca=1;
GO
-- este es el quinto registro, debería lanzar el error de que se llego al maximo de vehiculos permitidos
	EXEC InsertarVehiculo
    @Año = 2024,
    @Placa = 'V5',
    @NumeroVivienda = 405,
    @IdCluster = 4,
    @IdLinea = 1,
    @IdMarca = 1;