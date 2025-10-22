using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services;

public class TipoDocumentoService
{
    private readonly string _connectionString;

    public TipoDocumentoService(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("SqlServerConnection")
            ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
    }

    // LISTAR TODOS
    public async Task<List<TipoDocumento>> ObtenerTodosAsync()
    {
        var lista = new List<TipoDocumento>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(@"
        SELECT IdTipoDocumento, Nombre
        FROM TipoDocumento
        ORDER BY Nombre
        ", conn);

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new TipoDocumento
            {
                IdTipoDocumento = Convert.ToInt32(reader["IdTipoDocumento"]),
                Nombre = reader["Nombre"] as string ?? string.Empty
            });
        }
        return lista;
    }

    // BUSCAR POR ID
    public async Task<TipoDocumento?> BuscarPorIdAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ConsultarPorIdTipoDoc", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdTipoDocumento", id);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return new TipoDocumento
            {
                IdTipoDocumento = Convert.ToInt32(reader["IdTipoDocumento"]),
                Nombre = reader["Nombre"] as string ?? string.Empty
            };
        }
        return null;
    }

    // BUSCAR POR NOMBRE
    public async Task<TipoDocumento?> BuscarPorNombreAsync(string nombre)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ConsultarPorNombreTipoDoc", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@Nombre", nombre);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return new TipoDocumento
            {
                IdTipoDocumento = Convert.ToInt32(reader["IdTipoDocumento"]),
                Nombre = reader["Nombre"] as string ?? string.Empty
            };
        }
        return null;
    }

    // INSERTAR
    public async Task<(bool exito, string mensaje, int? id)> InsertarAsync(TipoDocumento tipoDocumento)
    {
        try
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("SP_InsertarTipoDoc", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Nombre", tipoDocumento.Nombre);

            var result = await cmd.ExecuteScalarAsync();
            var nuevoId = Convert.ToInt32(result);
            return (true, "Tipo de documento creado exitosamente.", nuevoId);
        }
        catch (SqlException ex)
        {
            return (false, $"Error: {ex.Message}", null);
        }
    }

    // ACTUALIZAR
    public async Task<(bool exito, string mensaje)> ActualizarAsync(TipoDocumento tipoDocumento)
    {
        try
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("SP_ActualizarTipoDoc", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IdTipoDocumento", tipoDocumento.IdTipoDocumento);
            cmd.Parameters.AddWithValue("@Nombre", tipoDocumento.Nombre);

            var rowsAffected = await cmd.ExecuteNonQueryAsync();
            return (rowsAffected > 0, rowsAffected > 0 ? "Tipo de documento actualizado." : "Tipo de documento no encontrado.");
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
            using var cmd = new SqlCommand("SP_EliminarTipoDoc", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IdTipoDocumento", id);

            var result = await cmd.ExecuteScalarAsync();
            var returnValue = Convert.ToInt32(result);

            return returnValue switch
            {
                1 => (true, "Tipo de documento eliminado correctamente."),
                0 => (false, "No se encontró el tipo de documento."),
                -1 => (false, "No se puede eliminar: existen visitantes asociados."),
                _ => (false, "Error desconocido.")
            };
        }
        catch (SqlException ex)
        {
            return (false, $"Error: {ex.Message}");
        }
    }
}