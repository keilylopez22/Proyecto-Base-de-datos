using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services;

public class ResidencialService
{
    private readonly string _connectionString;

    public ResidencialService(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("SqlServerConnection")
            ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
    }

   
    public async Task<List<Residencial>> ObtenerTodosAsync()
    {
        var lista = new List<Residencial>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_SelectAllResidenciales", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new Residencial
            {
                IdResidencial = Convert.ToInt32(reader["IdResidencial"]),
                Nombre = reader["Nombre"] as string ?? string.Empty
            });
        }
        return lista;
    }

    public async Task<Residencial?> BuscarPorIdAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_SelectAllResidenciales", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            if (Convert.ToInt32(reader["IdResidencial"]) == id)
            {
                return new Residencial
                {
                    IdResidencial = id,
                    Nombre = reader["Nombre"] as string ?? string.Empty
                };
            }
        }
        return null;
    }

   
    public async Task<int> InsertarAsync(Residencial residencial)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_InsertarResidencial", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@Nombre", residencial.Nombre);

        var result = await cmd.ExecuteScalarAsync();
        return Convert.ToInt32(result);
    }

    public async Task<bool> ActualizarAsync(Residencial residencial)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ActualizarResidencial", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdResidencial", residencial.IdResidencial);
        cmd.Parameters.AddWithValue("@Nombre", residencial.Nombre);

        var rowsAffected = await cmd.ExecuteNonQueryAsync();
        return rowsAffected > 0;
    }

   
    public async Task<bool> EliminarAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_EliminarResidencial", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdResidencial", id);

        var rowsAffected = await cmd.ExecuteNonQueryAsync();
        return rowsAffected > 0;
    }
}