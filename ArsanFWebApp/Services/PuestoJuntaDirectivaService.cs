using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services;

public class PuestoJuntaDirectivaService
{
    private readonly string _connectionString;

    public PuestoJuntaDirectivaService(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("sqlServerConnection")
            ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
    }

    // LISTAR TODOS
    public async Task<List<PuestoJuntaDirectiva>> ObtenerTodosAsync()
    {
        var lista = new List<PuestoJuntaDirectiva>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_SelectAllPuestosJD", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new PuestoJuntaDirectiva
            {
                IdPuesto = Convert.ToInt32(reader["IdPuesto"]),
                Nombre = reader["Nombre"] as string ?? string.Empty,
                Descripcion = reader["Descripcion"] as string
            });
        }
        return lista;
    }

    // BUSCAR POR ID
    public async Task<PuestoJuntaDirectiva?> BuscarPorIdAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_BuscarPuestoJDPK", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdPuestoJuntaDirectiva", id);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return new PuestoJuntaDirectiva
            {
                IdPuesto = Convert.ToInt32(reader["IdPuesto"]),
                Nombre = reader["Nombre"] as string ?? string.Empty,
                Descripcion = reader["Descripcion"] as string
            };
        }
        return null;
    }

    // INSERTAR
    public async Task<int> InsertarAsync(PuestoJuntaDirectiva puesto)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_InsertarPuestoJD", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@Nombre", puesto.Nombre);
        cmd.Parameters.AddWithValue("@Descripcion", (object?)puesto.Descripcion ?? DBNull.Value);

        var result = await cmd.ExecuteScalarAsync();
        return Convert.ToInt32(result);
    }

    // ACTUALIZAR
    public async Task<bool> ActualizarAsync(PuestoJuntaDirectiva puesto)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ActualizarPuestoJD", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdPuestoJuntaDirectiva", puesto.IdPuesto);
        cmd.Parameters.AddWithValue("@Nombre", puesto.Nombre);
        cmd.Parameters.AddWithValue("@Descripcion", (object?)puesto.Descripcion ?? DBNull.Value);

        var result = await cmd.ExecuteScalarAsync();
        return result != null;
    }

    // ELIMINAR
    public async Task<(bool exito, string mensaje)> EliminarAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_EliminarPuestoJD", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdPuestoJuntaDirectiva", id);

        try
        {
            await cmd.ExecuteNonQueryAsync();
            return (true, "Puesto eliminado correctamente.");
        }
        catch (SqlException ex) when (ex.Message.Contains("No se puede eliminar el Puesto"))
        {
            return (false, ex.Message);
        }
    }
}