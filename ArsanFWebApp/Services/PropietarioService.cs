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

    // LISTAR TODOS (con JOIN a Persona)
    public async Task<List<Propietario>> ObtenerTodosAsync()
    {
        var lista = new List<Propietario>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_SelectAllPropietarios", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new Propietario
            {
                IdPropietario = Convert.ToInt32(reader["IdPropietario"]),
                Estado = reader["Estado"] as string ?? string.Empty,
                IdPersona = Convert.ToInt32(reader["IdPersona"]),
                NombreCompleto = reader["NombreCompleto"] as string
            });
        }
        return lista;
    }

    // BUSCAR POR ID
    public async Task<Propietario?> BuscarPorIdAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_BuscarPropietario", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdPropiestario", id); // ⚠️ Nota: nombre del parámetro

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

    // INSERTAR
    public async Task<int> InsertarAsync(Propietario propietario)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("InsertarPropietario", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@Estado", propietario.Estado);
        cmd.Parameters.AddWithValue("@IdPersona", propietario.IdPersona);

        var result = await cmd.ExecuteScalarAsync();
        return Convert.ToInt32(result);
    }

    // ACTUALIZAR
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

    // ELIMINAR
    public async Task<bool> EliminarAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("PSEliminarPropietario", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdPropietario", id);

        var result = await cmd.ExecuteScalarAsync();
        return result != null;
    }

    // Obtener lista de Personas para el dropdown
    public async Task<List<Persona>> ObtenerPersonasAsync()
    {
        return await _personaService.ObtenerTodasAsync();
    }
}