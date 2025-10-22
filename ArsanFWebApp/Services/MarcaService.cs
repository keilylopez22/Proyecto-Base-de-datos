using Microsoft.Extensions.Logging;
using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services;

public class MarcaService
{
    private readonly string _connectionString;
    private readonly ILogger<MarcaService>? _logger;

    public MarcaService(IConfiguration configuration, ILogger<MarcaService>? logger = null)
    {
        _connectionString = configuration.GetConnectionString("SqlServerConnection")
            ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
        _logger = logger;
    }

    // LISTAR TODAS
    public async Task<List<Marca>> ObtenerTodasAsync()
    {
       var marcas = new List<Marca>();

        if (string.IsNullOrWhiteSpace(_connectionString))
        {
            _logger?.LogError("Cadena de conexión vacía en MarcaService.ObtenerTodasAsync");
            throw new InvalidOperationException("Cadena de conexión no configurada.");
        }

        try
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            using var cmd = new SqlCommand("SELECT IdMarca, Descripcion FROM Marca", conn);
            using var reader = await cmd.ExecuteReaderAsync();

            while (await reader.ReadAsync())
            {
                marcas.Add(new Marca
                {
                    IdMarca = reader.GetInt32(0),
                    Descripcion = reader.IsDBNull(1) ? null : reader.GetString(1)
                });
            }
        }

        catch (Exception ex)
        {
            _logger?.LogError(ex, "Error en ObtenerTodasAsync");
            throw; // o return marcas; según comportamiento deseado
        }

        return marcas;
    }

    // BUSCAR POR ID
    public async Task<Marca?> BuscarPorIdAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ConsultarPorIdMarca", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdMarca", id);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return new Marca
            {
                IdMarca = Convert.ToInt32(reader["IdMarca"]),
                Descripcion = reader["Descripcion"] as string ?? string.Empty
            };
        }
        return null;
    }

    // BUSCAR POR DESCRIPCIÓN
    public async Task<List<Marca>> BuscarPorDescripcionAsync(string descripcion)
    {
        var lista = new List<Marca>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ConsultarPorDescripcionMarca", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@Descripcion", descripcion);

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
    public async Task<(bool exito, string mensaje, int? id)> InsertarAsync(Marca marca)
    {
        try
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("SP_InsertarMarca", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Descripcion", marca.Descripcion);

            var result = await cmd.ExecuteScalarAsync();
            var nuevoId = Convert.ToInt32(result);
            return (true, "Marca creada exitosamente.", nuevoId);
        }
        catch (SqlException ex)
        {
            return (false, $"Error: {ex.Message}", null);
        }
    }

    // ACTUALIZAR
    public async Task<(bool exito, string mensaje)> ActualizarAsync(Marca marca)
    {
        try
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("SP_ActualizarMarca", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IdMarca", marca.IdMarca);
            cmd.Parameters.AddWithValue("@Descripcion", marca.Descripcion);

            var rowsAffected = await cmd.ExecuteNonQueryAsync();
            return (rowsAffected > 0, rowsAffected > 0 ? "Marca actualizada." : "Marca no encontrada.");
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
            using var cmd = new SqlCommand("SP_EliminarMarca", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IdMarca", id);

            var result = await cmd.ExecuteScalarAsync();
            var returnValue = Convert.ToInt32(result);

            return returnValue switch
            {
                1 => (true, "Marca eliminada correctamente."),
                0 => (false, "No se encontró la marca."),
                -1 => (false, "No se puede eliminar: existen líneas asociadas."),
                _ => (false, "Error desconocido.")
            };
        }
        catch (SqlException ex)
        {
            return (false, $"Error: {ex.Message}");
        }
    }
}