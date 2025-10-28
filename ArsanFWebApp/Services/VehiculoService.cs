using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services;

public class VehiculoService
{
    private readonly string _connectionString;

    public VehiculoService(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("SqlServerConnection")
            ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
    }

    // LISTAR TODOS
    public async Task<List<Vehiculo>> ObtenerTodosAsync()
    {
        var lista = new List<Vehiculo>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
            using var cmd = new SqlCommand(@"
        SELECT 
            v.IdVehiculo, v.Año, v.Placa, v.NumeroVivienda, v.IdCluster, v.IdLinea, v.IdMarca,
            l.Descripcion AS Linea, m.Descripcion AS Marca, CAST(v.NumeroVivienda AS NVARCHAR(50)) AS Vivienda, c.Descripcion AS Cluster
        FROM Vehiculo v
        LEFT JOIN Linea l ON v.IdLinea = l.IdLinea
        LEFT JOIN Marca m ON v.IdMarca = m.IdMarca
        LEFT JOIN Cluster c ON v.IdCluster = c.IdCluster
    ", conn);

    using var reader = await cmd.ExecuteReaderAsync();
    while (await reader.ReadAsync())
    {
        lista.Add(new Vehiculo
        {
            IdVehiculo = Convert.ToInt32(reader["IdVehiculo"]),
            Año = Convert.ToInt32(reader["Año"]),
            Placa = reader["Placa"] as string ?? string.Empty,
            NumeroVivienda = Convert.ToInt32(reader["NumeroVivienda"]),
            IdCluster = Convert.ToInt32(reader["IdCluster"]),
            IdLinea = Convert.ToInt32(reader["IdLinea"]),
            IdMarca = Convert.ToInt32(reader["IdMarca"]),

            // valores para la vista
            Linea = reader["Linea"] as string ?? string.Empty,
            Marca = reader["Marca"] as string ?? string.Empty,
            Vivienda = reader["Vivienda"] as string ?? string.Empty,
            Cluster = reader["Cluster"] as string ?? string.Empty
        });
    }
    return lista;
    }

    // Agregar este método para paginación
public async Task<(List<Vehiculo> vehiculos, int totalCount)> ObtenerTodosPaginadoAsync(
    int pagina = 1, 
    int tamanoPagina = 10, 
    int? anioFilter = null, 
    string? marcaFilter = null, 
    string? lineaFilter = null,
    string? placaFilter = null)
{
    var lista = new List<Vehiculo>();
    int totalCount = 0;

    using var conn = new SqlConnection(_connectionString);
    await conn.OpenAsync();
    
    using var cmd = new SqlCommand("SP_SelectAllVehiculo", conn);
    cmd.CommandType = System.Data.CommandType.StoredProcedure;
    cmd.Parameters.AddWithValue("@PageIndex", pagina);
    cmd.Parameters.AddWithValue("@PageSize", tamanoPagina);
    cmd.Parameters.AddWithValue("@AnioFilter", anioFilter ?? (object)DBNull.Value);
    cmd.Parameters.AddWithValue("@MarcaFilter", marcaFilter ?? (object)DBNull.Value);
    cmd.Parameters.AddWithValue("@LineaFilter", lineaFilter ?? (object)DBNull.Value);
    cmd.Parameters.AddWithValue("@PlacaFilter", placaFilter ?? (object)DBNull.Value);

    using var reader = await cmd.ExecuteReaderAsync();
    
    // Leer primera tabla (datos)
    while (await reader.ReadAsync())
    {
        lista.Add(new Vehiculo
        {
            IdVehiculo = Convert.ToInt32(reader["IdVehiculo"]),
            Año = Convert.ToInt32(reader["Año"]),
            Placa = reader["Placa"] as string ?? string.Empty,
            NumeroVivienda = Convert.ToInt32(reader["NumeroVivienda"]),
            IdCluster = Convert.ToInt32(reader["IdCluster"]),
            IdLinea = Convert.ToInt32(reader["IdLinea"]),
            IdMarca = Convert.ToInt32(reader["IdMarca"]),
            Linea = reader["Linea"] as string ?? string.Empty,
            Marca = reader["Marca"] as string ?? string.Empty,
            Vivienda = reader["NumeroVivienda"].ToString() ?? string.Empty,
            Cluster = reader["ClusterDescripcion"] as string ?? string.Empty
        });
    }

    // Leer segunda tabla (total count)
    if (await reader.NextResultAsync() && await reader.ReadAsync())
    {
        totalCount = Convert.ToInt32(reader["TotalCount"]);
    }

    return (lista, totalCount);
}


    // BUSCAR POR ID
    public async Task<Vehiculo?> BuscarPorIdAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(@"
        SELECT 
            v.IdVehiculo, v.Año, v.Placa, v.NumeroVivienda, v.IdCluster, v.IdLinea, v.IdMarca,
            l.Descripcion AS Linea, m.Descripcion AS Marca, c.Descripcion AS Cluster
        FROM Vehiculo v
        LEFT JOIN Linea l ON v.IdLinea = l.IdLinea
        LEFT JOIN Marca m ON v.IdMarca = m.IdMarca
        LEFT JOIN Cluster c ON v.IdCluster = c.IdCluster
        WHERE v.IdVehiculo = @IdVehiculo
    ", conn);
        cmd.Parameters.AddWithValue("@IdVehiculo", id);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return new Vehiculo
            {
                IdVehiculo = Convert.ToInt32(reader["IdVehiculo"]),
                Año = Convert.ToInt32(reader["Año"]),
                Placa = reader["Placa"] as string ?? string.Empty,
                NumeroVivienda = reader["NumeroVivienda"] != DBNull.Value ? Convert.ToInt32(reader["NumeroVivienda"]) : 0,
                IdCluster = reader["IdCluster"] != DBNull.Value ? Convert.ToInt32(reader["IdCluster"]) : 0,
                IdLinea = reader["IdLinea"] != DBNull.Value ? Convert.ToInt32(reader["IdLinea"]) : 0,
                IdMarca = reader["IdMarca"] != DBNull.Value ? Convert.ToInt32(reader["IdMarca"]) : 0,
                Linea = reader["Linea"] as string ?? string.Empty,
                Marca = reader["Marca"] as string ?? string.Empty,
                Vivienda = reader["NumeroVivienda"] != DBNull.Value ? reader["NumeroVivienda"].ToString() : string.Empty,
                Cluster = reader["Cluster"] as string ?? string.Empty
            };
        }
        return null;
    }

    // BUSCAR POR PLACA
    public async Task<Vehiculo?> BuscarPorPlacaAsync(string placa)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ConsultarPorPlacaVehiculo", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@Placa", placa);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return new Vehiculo
            {
                IdVehiculo = Convert.ToInt32(reader["IdVehiculo"]),
                Año = Convert.ToInt32(reader["Año"]),
                Placa = reader["Placa"] as string ?? string.Empty,
                NumeroVivienda = Convert.ToInt32(reader["NumeroVivienda"]),
                IdCluster = Convert.ToInt32(reader["IdCluster"]),
                IdLinea = Convert.ToInt32(reader["IdLinea"]),
                IdMarca = Convert.ToInt32(reader["IdMarca"])
            };
        }
        return null;
    }

    // OBTENER DATOS PARA DROPDOWNS
    public async Task<List<Linea>> ObtenerLineasAsync()
    {
        var lista = new List<Linea>();

        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();

        using var cmd = new SqlCommand(@"
            SELECT l.IdLinea, l.Descripcion, l.IdMarca, m.Descripcion AS Marca
            FROM Linea l
            LEFT JOIN Marca m ON l.IdMarca = m.IdMarca
        ", conn);

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new Linea
            {
                IdLinea = Convert.ToInt32(reader["IdLinea"]),
                Descripcion = reader["Descripcion"] as string ?? string.Empty,
                IdMarca = reader["IdMarca"] != DBNull.Value ? Convert.ToInt32(reader["IdMarca"]) : 0,
                Marca = reader["Marca"] as string ?? string.Empty
            });
        }

        return lista;
    }

    public async Task<List<Vivienda>> ObtenerViviendasAsync()
    {
        var lista = new List<Vivienda>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(@"
            SELECT v.NumeroVivienda, v.IdCluster, c.Descripcion as Cluster 
            FROM Vivienda v 
            INNER JOIN Cluster c ON v.IdCluster = c.IdCluster", conn);

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new Vivienda
            {
                NumeroVivienda = Convert.ToInt32(reader["NumeroVivienda"]),
                IdCluster = Convert.ToInt32(reader["IdCluster"]),
                Cluster = reader["Cluster"] as string
            });
        }
        return lista;
    }

    public async Task<List<Marca>> ObtenerMarcasAsync()
    {
        var lista = new List<Marca>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
    
        using var cmd = new SqlCommand("SELECT IdMarca, Descripcion FROM Marca", conn);
    
        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new Marca
            {
                IdMarca = Convert.ToInt32(reader["IdMarca"]),
                Descripcion = reader["Descripcion"] as string ?? string.Empty
            });
        }
        return lista;
    }

    // INSERTAR
    public async Task<(bool exito, string mensaje, int? id)> InsertarAsync(Vehiculo vehiculo)
    {
        try
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            var dbName = (await new SqlCommand("SELECT DB_NAME()", conn).ExecuteScalarAsync())?.ToString() ?? "(unknown)";
            var serverName = (await new SqlCommand("SELECT @@SERVERNAME", conn).ExecuteScalarAsync())?.ToString() ?? "(unknown)";

        using (var chkLineaDiag = new SqlCommand("SELECT COUNT(1) FROM Linea WHERE IdLinea = @IdLinea", conn))
        {
            chkLineaDiag.Parameters.AddWithValue("@IdLinea", vehiculo.IdLinea);
            var existe = Convert.ToInt32(await chkLineaDiag.ExecuteScalarAsync());
            if (existe == 0)
            {
                return (false, $"La línea con Id {vehiculo.IdLinea} NO existe en la base '{dbName}' del servidor '{serverName}'. Verifique la cadena de conexión de la aplicación.", null);
            }
        }

            if (vehiculo.IdLinea <= 0) return (false, "Selección de línea inválida.", null);
            if (vehiculo.IdCluster <= 0) return (false, "Selección de cluster inválida.", null);

            using (var chkLinea = new SqlCommand("SELECT IdMarca FROM Linea WHERE IdLinea = @IdLinea", conn))
            {
                chkLinea.Parameters.AddWithValue("@IdLinea", vehiculo.IdLinea);
                var marcaObj = await chkLinea.ExecuteScalarAsync();
                if (marcaObj == null || marcaObj == DBNull.Value)
                {
                   return (false, $"La línea con Id {vehiculo.IdLinea} no existe.", null);
                }

                // 1.a) opcional: validar que la línea corresponde a la marca seleccionada (si IdMarca viene del formulario)
                if (vehiculo.IdMarca != 0)
                {
                    var idMarcaLinea = Convert.ToInt32(marcaObj);
                    if (idMarcaLinea != vehiculo.IdMarca)
                    {
                        return (false, "La línea seleccionada no corresponde a la marca indicada.", null);
                    }
                }
            }
            using (var chkVivi = new SqlCommand("SELECT COUNT(1) FROM Vivienda WHERE NumeroVivienda = @NumeroVivienda AND IdCluster = @IdCluster", conn))
            {
                chkVivi.Parameters.AddWithValue("@NumeroVivienda", vehiculo.NumeroVivienda);
                chkVivi.Parameters.AddWithValue("@IdCluster", vehiculo.IdCluster);
                var existeVivi = Convert.ToInt32(await chkVivi.ExecuteScalarAsync()) > 0;
                if (!existeVivi)
                {
                    return (false, "Vivienda o cluster inválido.", null);
                }
            }
            using var cmd = new SqlCommand(@"
                INSERT INTO Vehiculo (Año, Placa, NumeroVivienda, IdCluster, IdLinea, IdMarca)
                OUTPUT INSERTED.IdVehiculo
                VALUES (@Año, @Placa, @NumeroVivienda, @IdCluster, @IdLinea, @IdMarca)
            ", conn);
            cmd.CommandType = System.Data.CommandType.Text;
            cmd.Parameters.AddWithValue("@Año", vehiculo.Año);
            cmd.Parameters.AddWithValue("@Placa", vehiculo.Placa  ?? string.Empty);
            cmd.Parameters.AddWithValue("@NumeroVivienda", vehiculo.NumeroVivienda);
            cmd.Parameters.AddWithValue("@IdCluster", vehiculo.IdCluster);
            cmd.Parameters.AddWithValue("@IdLinea", vehiculo.IdLinea);
            cmd.Parameters.AddWithValue("@IdMarca", vehiculo.IdMarca);

            var result = await cmd.ExecuteScalarAsync();
            var nuevoId = result != null ? Convert.ToInt32(result) : (int?)null;
            return (true, "Vehículo creado exitosamente.", nuevoId);
        }
        catch (SqlException ex)
        {
            var mensaje = ex.Message.Contains("placa") ? "La placa ya existe" :
                         ex.Message.Contains("máximo") ? "La vivienda ya tiene 4 vehículos" :
                         ex.Message.Contains("vivienda") ? "La vivienda no existe" :
                         ex.Message.Contains("línea") ? "La línea no corresponde a la marca" :
                         $"Error: {ex.Message}";
            return (false, mensaje, null);
        }
    }

    // ACTUALIZAR
    public async Task<(bool exito, string mensaje)> ActualizarAsync(Vehiculo vehiculo)
    {
        try
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            var dbName = (await new SqlCommand("SELECT DB_NAME()", conn).ExecuteScalarAsync())?.ToString() ?? "(unknown)";
            var serverName = (await new SqlCommand("SELECT @@SERVERNAME", conn).ExecuteScalarAsync())?.ToString() ?? "(unknown)";

            if (vehiculo.IdVehiculo <= 0) return (false, "Vehículo inválido.");
            if (vehiculo.IdLinea <= 0) return (false, "Selección de línea inválida.");
            if (vehiculo.IdCluster <= 0) return (false, "Selección de cluster inválida.");

            using (var chk = new SqlCommand("SELECT COUNT(1) FROM dbo.Linea WHERE IdLinea = @IdLinea", conn))
            {
                chk.Parameters.AddWithValue("@IdLinea", vehiculo.IdLinea);
                    var existe = Convert.ToInt32(await chk.ExecuteScalarAsync());
                    if (existe == 0)
                    {
                        return (false, $"La línea {vehiculo.IdLinea} NO existe en la base '{dbName}' del servidor '{serverName}'. Verifique la cadena de conexión.");
                    }
            }

            // 1) Validar que la línea exista
            using (var chkLinea = new SqlCommand("SELECT COUNT(1) FROM dbo.Linea WHERE IdLinea = @IdLinea", conn))
            {
                chkLinea.Parameters.AddWithValue("@IdLinea", vehiculo.IdLinea);
                var existeLinea = Convert.ToInt32(await chkLinea.ExecuteScalarAsync()) > 0;
                if (!existeLinea)
                {
                    return (false, $"La línea con Id {vehiculo.IdLinea} no existe. No se puede actualizar el vehículo.");
                }
            }

            // 2) Validar que la vivienda exista y pertenezca al cluster
            using (var chkVivi = new SqlCommand("SELECT COUNT(1) FROM dbo.Vivienda WHERE NumeroVivienda = @NumeroVivienda AND IdCluster = @IdCluster", conn))
            {
                chkVivi.Parameters.AddWithValue("@NumeroVivienda", vehiculo.NumeroVivienda);
                chkVivi.Parameters.AddWithValue("@IdCluster", vehiculo.IdCluster);
                var existeVivi = Convert.ToInt32(await chkVivi.ExecuteScalarAsync()) > 0;
                if (!existeVivi)
                {
                    return (false, "Vivienda o cluster inválido.");
                }
            }

            using var cmd = new SqlCommand(@"
                UPDATE Vehiculo
                SET Año = @Año,
                    Placa = @Placa,
                    NumeroVivienda = @NumeroVivienda,
                    IdCluster = @IdCluster,
                    IdLinea = @IdLinea,
                    IdMarca = @IdMarca
                WHERE IdVehiculo = @IdVehiculo
            ", conn);
            cmd.CommandType = System.Data.CommandType.Text;
            cmd.Parameters.AddWithValue("@IdVehiculo", vehiculo.IdVehiculo);
            cmd.Parameters.AddWithValue("@Año", vehiculo.Año);
            cmd.Parameters.AddWithValue("@Placa", vehiculo.Placa ?? string.Empty);
            cmd.Parameters.AddWithValue("@NumeroVivienda", vehiculo.NumeroVivienda);
            cmd.Parameters.AddWithValue("@IdCluster", vehiculo.IdCluster);
            cmd.Parameters.AddWithValue("@IdLinea", vehiculo.IdLinea);
            cmd.Parameters.AddWithValue("@IdMarca", vehiculo.IdMarca);

            var rowsAffected = await cmd.ExecuteNonQueryAsync();
            return (rowsAffected > 0, rowsAffected > 0 ? "Vehículo actualizado." : "Vehículo no encontrado.");
        }
        catch (SqlException ex)
        {
            var mensaje = ex.Message.Contains("FK_Linea") ? "La línea seleccionada no es válida (restricta por FK)." :
                          ex.Message.Contains("FK_Vivienda") ? "La vivienda/cluster no es válido." :
                          $"Error: {ex.Message}";
            return (false, mensaje);
        }
    }

    // ELIMINAR
    public async Task<(bool exito, string mensaje)> EliminarAsync(int id)
    {
        try
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("SP_EliminarVehiculo", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IdVehiculo", id);

            var result = await cmd.ExecuteScalarAsync();
            var returnValue = Convert.ToInt32(result);

            return returnValue switch
            {
                1 => (true, "Vehículo eliminado correctamente."),
                0 => (false, "No se encontró el vehículo."),
                -1 => (false, "No se puede eliminar: existen registros de acceso asociados."),
                _ => (false, "Error desconocido.")
            };
        }
        catch (SqlException ex)
        {
            return (false, $"Error: {ex.Message}");
        }
    }
}