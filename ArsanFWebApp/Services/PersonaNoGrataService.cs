// Services/PersonaNoGrataService.cs
using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services;

public class PersonaNoGrataService
{
    private readonly string _connectionString;
    private readonly PersonaService _personaService;

    public PersonaNoGrataService(IConfiguration configuration, PersonaService personaService)
    {
        _connectionString = configuration.GetConnectionString("sqlServerConnection")
            ?? throw new InvalidOperationException("Cadena de conexión 'sqlServerConnection' no encontrada.");
        _personaService = personaService;
    }

    // LISTAR TODAS (con JOIN a Persona)
    public async Task<List<PersonaNoGrata>> ObtenerTodasAsync()
    {
        var lista = new List<PersonaNoGrata>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        // Usamos el SP de búsqueda por ID como base, pero creamos uno genérico si no existe
        using var cmd = new SqlCommand(@"
            SELECT pn.idPersonaNoGrata, p.PrimerNombre, p.PrimerApellido, 
                   pn.FechaInicio, pn.FechaFin, pn.Motivo, pn.IdPersona
            FROM PersonaNoGrata pn
            INNER JOIN Persona p ON pn.IdPersona = p.IdPersona", conn);

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new PersonaNoGrata
            {
                IdPersonaNoGrata = Convert.ToInt32(reader["idPersonaNoGrata"]),

                FechaInicio = DateOnly.FromDateTime(Convert.ToDateTime(reader["FechaInicio"])),
               
                FechaFin = DateOnly.FromDateTime(Convert.ToDateTime(reader["FechaFin"])),
                Motivo = reader["Motivo"] as string,
                IdPersona = Convert.ToInt32(reader["IdPersona"]),
                NombreCompleto = $"{reader["PrimerNombre"]} {reader["PrimerApellido"]}"
            });
        }
        return lista;
    }

    // BUSCAR POR ID
    public async Task<PersonaNoGrata?> BuscarPorIdAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_BuscarPeronaNoGrataPorId", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdPersonaNoGrata", id);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return new PersonaNoGrata
            {
                IdPersonaNoGrata = Convert.ToInt32(reader["idPersonaNoGrata"]),
                
                FechaInicio = DateOnly.FromDateTime(Convert.ToDateTime(reader["FechaInicio"])),
                FechaFin = DateOnly.FromDateTime(Convert.ToDateTime(reader["FechaFin"])),
                Motivo = reader["Motivo"] as string,
                IdPersona = Convert.ToInt32(reader["IdPersona"]),
                NombreCompleto = $"{reader["PrimerNombre"]} {reader["PrimerApellido"]}"
            };
        }
        return null;
    }

    // INSERTAR
    public async Task InsertarAsync(PersonaNoGrata persona)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_InsertarPersonaNoGrata", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@FechaInicio", persona.FechaInicio.ToDateTime(TimeOnly.MinValue));
        cmd.Parameters.AddWithValue("@FechFin", (object?)persona.FechaFin?.ToDateTime(TimeOnly.MinValue) ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@Motivo", (object?)persona.Motivo ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@IdPersona", persona.IdPersona);

        await cmd.ExecuteNonQueryAsync();
    }

    // ACTUALIZAR
    public async Task ActualizarAsync(PersonaNoGrata persona)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ActualizarPersonaNoGrata", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdPeronaNoGrata", persona.IdPersonaNoGrata);
        cmd.Parameters.AddWithValue("@FechaInicio", (object?)persona.FechaInicio.ToDateTime(TimeOnly.MinValue) ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@FechaFin", (object?)persona.FechaFin?.ToDateTime(TimeOnly.MinValue) ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@Motivo", (object?)persona.Motivo ?? DBNull.Value);

        await cmd.ExecuteNonQueryAsync();
    }

    // ELIMINAR
    public async Task<(bool exito, string mensaje)> EliminarAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_EliminarPersonaNoGrata", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdPersonaNoGrata", id);

        try
        {
            await cmd.ExecuteNonQueryAsync();
            return (true, "Persona eliminada correctamente de la lista de no gratos.");
        }
        catch (SqlException ex)
        {
            return (false, ex.Message);
        }
    }

    // Obtener lista de Personas para el dropdown
    public async Task<List<Persona>> ObtenerPersonasAsync() => 
        await _personaService.ObtenerTodasAsync();
}