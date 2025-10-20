using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services;

public class TurnoService
{
    private readonly string _connectionString;

    public TurnoService(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("sqlServerConnection")
            ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
    }

   
    public async Task<List<Turno>> ObtenerTodosAsync()
    {
        var lista = new List<Turno>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();

        var query = "SELECT IdTurno, Descripcion, HoraInicio, HoraFin FROM Turno";
        using var cmd = new SqlCommand(query, conn);

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new Turno
            {
                IdTurno = Convert.ToInt32(reader["IdTurno"]),
                Descripcion = reader["Descripcion"].ToString()!,
                HoraInicio = (DateTime)reader["HoraInicio"],
                HoraFin = (DateTime)reader["HoraFin"]
            });
        }
        return lista;
    }

 
    public async Task<Turno?> BuscarPorIdAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();

        using var cmd = new SqlCommand("SP_ObtenerTurnoPorId", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdTurno", id);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return new Turno
            {
                IdTurno = Convert.ToInt32(reader["IdTurno"]),
                Descripcion = reader["Descripcion"].ToString()!,
                HoraInicio = (DateTime)reader["HoraInicio"],
                HoraFin = (DateTime)reader["HoraFin"]
            };
        }
        return null;
    }
    public async Task InsertarAsync(Turno turno)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();

        using var cmd = new SqlCommand("SP_CrearTurno", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@Descripcion", turno.Descripcion);
        cmd.Parameters.AddWithValue("@HoraInicio", turno.HoraInicio);
        cmd.Parameters.AddWithValue("@HoraFin", turno.HoraFin);

        await cmd.ExecuteNonQueryAsync();
    }


    public async Task ActualizarAsync(Turno turno)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();

        using var cmd = new SqlCommand("SP_ActualizarTurno", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdTurno", turno.IdTurno);
        cmd.Parameters.AddWithValue("@Descripcion", turno.Descripcion);
        cmd.Parameters.AddWithValue("@HoraInicio", turno.HoraInicio);
        cmd.Parameters.AddWithValue("@HoraFin", turno.HoraFin);

        await cmd.ExecuteNonQueryAsync();
    }


    public async Task<(bool exito, string mensaje)> EliminarAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();

        using var cmd = new SqlCommand("SP_EliminarTurno", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdTurno", id);

        try
        {
            await cmd.ExecuteNonQueryAsync();
            return (true, "Turno eliminado correctamente.");
        }
        catch (SqlException ex)
        {
            return (false, ex.Message);
        }
    }
}
