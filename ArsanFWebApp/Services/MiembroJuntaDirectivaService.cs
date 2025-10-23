using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services;

public class MiembroJuntaDirectivaService
{
    private readonly string _connectionString;
    private readonly JuntaDirectivaService _juntaDirectivaService;
    private readonly PropietarioService _propietarioService;
    private readonly PuestoJuntaDirectivaService _puestoService;

    public MiembroJuntaDirectivaService(
        IConfiguration configuration,
        JuntaDirectivaService juntaDirectivaService,
        PropietarioService propietarioService,
        PuestoJuntaDirectivaService puestoService)
    {
        _connectionString = configuration.GetConnectionString("sqlServerConnection")
            ?? throw new InvalidOperationException("Cadena de conexión 'sqlServerConnection' no encontrada.");
        _juntaDirectivaService = juntaDirectivaService;
        _propietarioService = propietarioService;
        _puestoService = puestoService;
    }


    public async Task<List<MiembroJuntaDirectiva>> ObtenerTodosAsync()
    {
        var lista = new List<MiembroJuntaDirectiva>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_SelectAllMiembrosJD", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new MiembroJuntaDirectiva
            {
                IdMiembro = Convert.ToInt32(reader["IdMiembro"]),
                Estado = reader["Estado"] as string,
                FechaInicio = DateOnly.FromDateTime(Convert.ToDateTime(reader["FechaInicio"])),
                FechaFin = DateOnly.FromDateTime(Convert.ToDateTime(reader["FechaFin"])),

                Cluster = reader["Cluster"] as string,
                Puesto = reader["Puesto"] as string,
                Propietario = reader["Propietario"] as string
            });
        }
        return lista;
    }

   
    public async Task<MiembroJuntaDirectiva?> BuscarPorIdAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_BuscarMiembroJDPK", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdMiembro", id);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return new MiembroJuntaDirectiva
            {
                IdMiembro = id,
                IdJuntaDirectiva = Convert.ToInt32(reader["IdJuntaDirectiva"]),
                IdPropietario = Convert.ToInt32(reader["IdPropietario"]),
                IdPuesto = Convert.ToInt32(reader["idPuesto"]), // ← nombre exacto del SP
                FechaInicio = DateOnly.FromDateTime(Convert.ToDateTime(reader["FechaInicio"])),
                FechaFin = DateOnly.FromDateTime(Convert.ToDateTime(reader["FechaFin"])),

            };
        }
        return null;
    }

  
    public async Task<int> InsertarAsync(MiembroJuntaDirectiva miembro)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_InsertarMiembroJD", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@Estado", (object?)miembro.Estado ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@FechaInicio", miembro.FechaInicio.ToDateTime(TimeOnly.MinValue));
        cmd.Parameters.AddWithValue("@FechaFin", miembro.FechaFin.ToDateTime(TimeOnly.MinValue));
        cmd.Parameters.AddWithValue("@IdJuntaDirectiva", miembro.IdJuntaDirectiva);
        cmd.Parameters.AddWithValue("@IdPropietario", miembro.IdPropietario);
        cmd.Parameters.AddWithValue("@IdPuestoJuntaDirectiva", miembro.IdPuesto); // ← nombre del parámetro del SP

        var result = await cmd.ExecuteScalarAsync();
        return Convert.ToInt32(result);
    }

    public async Task<bool> ActualizarAsync(MiembroJuntaDirectiva miembro)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ActualizarMiembroJD", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdMiembro", miembro.IdMiembro);
        cmd.Parameters.AddWithValue("@Estado", (object?)miembro.Estado ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@FechaInicio", miembro.FechaInicio.ToDateTime(TimeOnly.MinValue));
        cmd.Parameters.AddWithValue("@FechaFin", miembro.FechaFin.ToDateTime(TimeOnly.MinValue));
        cmd.Parameters.AddWithValue("@IdJuntaDirectiva", miembro.IdJuntaDirectiva);
        cmd.Parameters.AddWithValue("@IdPropietario", miembro.IdPropietario);
        cmd.Parameters.AddWithValue("@IdPuesto", miembro.IdPuesto); // ← nombre del parámetro del SP

        var result = await cmd.ExecuteScalarAsync();
        return result != null;
    }

   
    public async Task<(bool exito, string mensaje)> EliminarAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_EliminarMiembroJD", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdMiembroJD", id);

        try
        {
            await cmd.ExecuteNonQueryAsync();
            return (true, "Miembro eliminado correctamente.");
        }
        catch (SqlException ex) when (ex.Message.Contains("No se puede eliminar el miembro"))
        {
            return (false, ex.Message);
        }
    }


    public async Task<List<JuntaDirectiva>> ObtenerJuntasDirectivasAsync() =>
        await _juntaDirectivaService.ObtenerTodasAsync();

    public async Task<List<Propietario>> ObtenerPropietariosAsync() =>
        await _propietarioService.ObtenerTodosAsync( 1, int.MaxValue).ContinueWith(t => t.Result.items);

    public async Task<List<PuestoJuntaDirectiva>> ObtenerPuestosAsync() =>
        await _puestoService.ObtenerTodosAsync();
}