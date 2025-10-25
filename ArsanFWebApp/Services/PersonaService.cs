using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;


namespace ArsanWebApp.Services;

public class PersonaService
{
    private readonly string _connectionString;

    public PersonaService(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("SqlServerConnection")
            ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
    }

    public async Task<List<Persona>> ObtenerTodasAsync()
    {
        var personas = new List<Persona>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_SelectAllPersonas", conn);
        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            personas.Add(MapPersona(reader));
        }
        return personas;
    }

    public async Task<(List<Persona> Items, int TotalCount)> ObtenerPersonasPaginadoAsync(
    int pageIndex, 
    int pageSize, 
    string? cuiFilter = null, 
    string? nombreFilter = null)
{
    using var conn = new SqlConnection(_connectionString);
    await conn.OpenAsync();
    using var cmd = new SqlCommand("SP_ObtenerPersonasPaginado", conn);
    cmd.CommandType = System.Data.CommandType.StoredProcedure;
    cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
    cmd.Parameters.AddWithValue("@PageSize", pageSize);
    cmd.Parameters.AddWithValue("@CuiFilter", (object?)cuiFilter ?? DBNull.Value);
    cmd.Parameters.AddWithValue("@NombreFilter", (object?)nombreFilter ?? DBNull.Value);

    var personas = new List<Persona>();
    int totalCount = 0;

    using (var reader = await cmd.ExecuteReaderAsync())
    {
        
        while (await reader.ReadAsync())
        {
            personas.Add(new Persona
            {
                IdPersona = Convert.ToInt32(reader["IdPersona"]),
                Cui = reader["Cui"] as string ?? string.Empty,
                PrimerNombre = reader["PrimerNombre"] as string ?? string.Empty,
                SegundoNombre = reader["SegundoNombre"] as string,
                PrimerApellido = reader["PrimerApellido"] as string ?? string.Empty,
                SegundoApellido = reader["SegundoApellido"] as string,
                Telefono = reader["Telefono"] as string,
                Genero = reader["Genero"] as char?
            });
        }

        
        if (await reader.NextResultAsync())
        {
            if (await reader.ReadAsync())
            {
                totalCount = Convert.ToInt32(reader["TotalCount"]);
            }
        }
    }

    return (personas, totalCount);
}

    
    public async Task<Persona?> BuscarPorIdAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_BuscarPersona", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdPersona", id);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
            return MapPersona(reader);
        return null;
    }


    public async Task<int> InsertarAsync(Persona persona)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_InsertarPersona", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@Cui", persona.Cui);
        cmd.Parameters.AddWithValue("@PrimerNombre", persona.PrimerNombre);
        cmd.Parameters.AddWithValue("@SegundoNombre", (object?)persona.SegundoNombre ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@PrimerApellido", persona.PrimerApellido);
        cmd.Parameters.AddWithValue("@SegundoApellido", (object?)persona.SegundoApellido ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@Telefono", (object?)persona.Telefono ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@Genero", (object?)persona.Genero ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@FechaNacimiento", (object?)persona.FechaNacimiento ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@EstadoCivil", (object?)persona.EstadoCivil ?? DBNull.Value);

        var result = await cmd.ExecuteScalarAsync();
        return Convert.ToInt32(result);
    }

 
    public async Task<bool> ActualizarAsync(Persona persona)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ActualizarPersona", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdPersona", persona.IdPersona);
        cmd.Parameters.AddWithValue("@Cui", persona.Cui);
        cmd.Parameters.AddWithValue("@PrimerNombre", persona.PrimerNombre);
        cmd.Parameters.AddWithValue("@SegundoNombre", (object?)persona.SegundoNombre ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@PrimerApellido", persona.PrimerApellido);
        cmd.Parameters.AddWithValue("@SegundoApellido", (object?)persona.SegundoApellido ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@Telefono", (object?)persona.Telefono ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@Genero", (object?)persona.Genero ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@FechaNacimiento", (object?)persona.FechaNacimiento ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@EstadoCivil", (object?)persona.EstadoCivil ?? DBNull.Value);

        var result = await cmd.ExecuteScalarAsync();
        return result != null;
    }

 
    public async Task<bool> EliminarAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_EliminarPersona", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdPersona", id);

        var result = await cmd.ExecuteScalarAsync();
        return result != null;
    }



    private static Persona MapPersona(SqlDataReader reader)
    {
        return new Persona
        {
            IdPersona = Convert.ToInt32(reader["IdPersona"]),
            Cui = reader["Cui"] as string,
            PrimerNombre = reader["PrimerNombre"] as string,
            SegundoNombre = reader["SegundoNombre"] as string,
            PrimerApellido = reader["PrimerApellido"] as string,
            SegundoApellido = reader["SegundoApellido"] as string,
            Telefono = reader["Telefono"] as string,
            Genero = reader["Genero"] as char?,
            FechaNacimiento = reader["FechaNacimiento"] as DateOnly?,
            EstadoCivil = reader["EstadoCivil"] as string
        };
    }


}