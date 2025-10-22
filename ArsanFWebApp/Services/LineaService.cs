using Microsoft.Extensions.Logging;
using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services;

public class LineaService
{
    private readonly string _connectionString;
    private readonly ILogger<LineaService>? _logger;

     public LineaService(IConfiguration configuration, ILogger<LineaService>? logger = null)
    {
        _connectionString = configuration.GetConnectionString("SqlServerConnection")
             ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
        _logger = logger;
    }

    // LISTAR TODAS
    public async Task<List<Linea>> ObtenerTodasAsync()
    {
        var lista = new List<Linea>();

        if (string.IsNullOrWhiteSpace(_connectionString))
        {
            _logger?.LogError("Cadena de conexión vacía en LineaService.ObtenerTodasAsync");
            throw new InvalidOperationException("Cadena de conexión no configurada.");
        }

        try
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("SELECT IdLinea, Descripcion, IdMarca FROM Linea", conn);

            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                lista.Add(new Linea
                {
                    IdLinea = Convert.ToInt32(reader["IdLinea"]),
                    Descripcion = reader["Descripcion"] as string ?? string.Empty,
                    IdMarca = Convert.ToInt32(reader["IdMarca"])
                });
            }
        }
        catch (Exception ex)
        {
            _logger?.LogError(ex, "Error en ObtenerTodasAsync");
            throw;
        }

        return lista;
    }

    // BUSCAR POR ID
    public async Task<Linea?> BuscarPorIdAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ConsultarPorIdLinea", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdLinea", id);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return new Linea
            {
                IdLinea = Convert.ToInt32(reader["IdLinea"]),
                Descripcion = reader["Descripcion"] as string ?? string.Empty,
                IdMarca = Convert.ToInt32(reader["IdMarca"])
            };
        }
        return null;
    }

    // BUSCAR POR DESCRIPCIÓN
    public async Task<List<Linea>> BuscarPorDescripcionAsync(string descripcion)
    {
        var lista = new List<Linea>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ConsultarPorDescripcionLinea", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@Descripcion", descripcion);

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new Linea
            {
                IdLinea = Convert.ToInt32(reader["IdLinea"]),
                Descripcion = reader["Descripcion"] as string ?? string.Empty,
                IdMarca = Convert.ToInt32(reader["IdMarca"])
            });
        }
        return lista;
    }

    // BUSCAR POR MARCA
    public async Task<List<Linea>> BuscarPorMarcaAsync(int idMarca)
    {
        var lista = new List<Linea>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ConsultarPorMarcaLinea", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdMarca", idMarca);

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new Linea
            {
                IdLinea = Convert.ToInt32(reader["IdLinea"]),
                Descripcion = reader["Descripcion"] as string ?? string.Empty,
                IdMarca = Convert.ToInt32(reader["IdMarca"])
            });
        }
        return lista;
    }

    // OBTENER MARCAS PARA DROPDOWN
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
    public async Task<(bool exito, string mensaje, int? id)> InsertarAsync(Linea linea)
    {
        try
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("SP_InsertarLinea", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Descripcion", linea.Descripcion);
            cmd.Parameters.AddWithValue("@IdMarca", linea.IdMarca);

            var result = await cmd.ExecuteScalarAsync();
            var nuevoId = Convert.ToInt32(result);
            return (true, "Línea creada exitosamente.", nuevoId);
        }
        catch (SqlException ex)
        {
            return (false, $"Error: {ex.Message}", null);
        }
    }

    // ACTUALIZAR
    public async Task<(bool exito, string mensaje)> ActualizarAsync(Linea linea)
    {
        try
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("SP_ActualizarLinea", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IdLinea", linea.IdLinea);
            cmd.Parameters.AddWithValue("@Descripcion", linea.Descripcion);
            cmd.Parameters.AddWithValue("@IdMarca", linea.IdMarca);

            var rowsAffected = await cmd.ExecuteNonQueryAsync();
            return (rowsAffected > 0, rowsAffected > 0 ? "Línea actualizada." : "Línea no encontrada.");
        }
        catch (SqlException ex)
        {
            return (false, $"Error: {ex.Message}");
        }
    }

    // ELIMINAR
    public async Task<(bool exito, string mensaje)> EliminarAsync(int id)
    {
        try
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("SPEliminarLinea", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IdLinea", id);

            var result = await cmd.ExecuteScalarAsync();
            var returnValue = Convert.ToInt32(result);

            return returnValue switch
            {
                1 => (true, "Línea eliminada correctamente."),
                0 => (false, "No se encontró la línea."),
                -1 => (false, "No se puede eliminar: existen vehículos asociados."),
                _ => (false, "Error desconocido.")
            };
        }
        catch (SqlException ex)
        {
            return (false, $"Error: {ex.Message}");
        }
    }
}