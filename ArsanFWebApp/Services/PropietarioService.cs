using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services;

public class PropietarioService
{
    private readonly string _connectionString;
    private readonly PersonaService _personaService;

    public PropietarioService(IConfiguration configuration, PersonaService personaService)
    {
        _connectionString = configuration.GetConnectionString("SqlServerConnection")
            ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
        _personaService = personaService;
    }

  
    public async Task<(List<Propietario> items, int TotalCount)> ObtenerTodosAsync(
        int pageIndex,
        int pageSize,
        string? EstadoFilter = null,
        string? NombreFilter = null


    )
    {
        
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_SelectAllPropietarios", conn);

        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", pageSize);
        cmd.Parameters.AddWithValue("@EstadoFilter", (object?)EstadoFilter ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@NombreFilter", (object?)NombreFilter ?? DBNull.Value);

        var lista = new List<Propietario>();
        int totalCount = 0;

        using (var reader = await cmd.ExecuteReaderAsync())

        {
            while (await reader.ReadAsync())
                lista.Add(new Propietario
                {
                    IdPropietario = Convert.ToInt32(reader["IdPropietario"]),
                    Estado = reader["Estado"] as string ?? string.Empty,
                    IdPersona = Convert.ToInt32(reader["IdPersona"]),
                    NombreCompleto = reader["NombreCompleto"] as string
                });

            if (await reader.NextResultAsync()) 
            {
                if (await reader.ReadAsync())
                {
                    totalCount = Convert.ToInt32(reader["TotalCount"]);
                }
            }
        }

        return (lista, totalCount);
       
    }


    public async Task<Propietario?> BuscarPorIdAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_BuscarPropietario", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdPropiestario", id); 

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return new Propietario
            {
                IdPropietario = Convert.ToInt32(reader["IdPropietario"]),
                IdPersona = Convert.ToInt32(reader["IdPersona"]),
                NombreCompleto = reader["Propietario"] as string
            };
        }
        return null;
    }

  
    public async Task<int> InsertarAsync(Propietario propietario)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_InsertarPropietario", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@Estado", propietario.Estado);
        cmd.Parameters.AddWithValue("@IdPersona", propietario.IdPersona);

        var result = await cmd.ExecuteScalarAsync();
        return Convert.ToInt32(result);
    }


    public async Task<bool> ActualizarAsync(Propietario propietario)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ActualizarPropietario", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdPropietario", propietario.IdPropietario);
        cmd.Parameters.AddWithValue("@Estado", propietario.Estado);
        cmd.Parameters.AddWithValue("@IdPersona", propietario.IdPersona);

        var result = await cmd.ExecuteScalarAsync();
        return result != null;
    }

    public async Task<bool> EliminarAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_EliminarPropietario", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdPropietario", id);

        var result = await cmd.ExecuteScalarAsync();
        return result != null;
    }

 
    public async Task<List<Persona>> ObtenerPersonasAsync()
    {
        return await _personaService.ObtenerTodasAsync();
    }
}