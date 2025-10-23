using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services;

public class TipoViviendaService
{
    private readonly string _connectionString;

    public TipoViviendaService(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("SqlServerConnection")
            ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
    }

  
    public async Task<List<TipoVivienda>> ObtenerTodosAsync()
    {
        var lista = new List<TipoVivienda>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_SelectAllTiposVivienda", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(MapTipoVivienda(reader));
        }
        return lista;
    }

    public async Task<TipoVivienda?> BuscarPorIdAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_BuscarTipoVivienda", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdTipoVivienda", id);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
            return MapTipoVivienda(reader);
        return null;
    }

    public async Task<int> InsertarAsync(TipoVivienda tipo)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_InsertarTipoVivienda", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@Descripcion", (object?)tipo.Descripcion ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@NumeroHabitaciones", (object?)tipo.NumeroHabitaciones ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@SuperficieTotal", (object?)tipo.SuperficieTotal ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@NumeroPisos", (object?)tipo.NumeroPisos ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@Estacionamiento", (object?)tipo.Estacionamiento ?? DBNull.Value);

        var result = await cmd.ExecuteScalarAsync();
        return Convert.ToInt32(result);
    }


    public async Task<bool> ActualizarAsync(TipoVivienda tipo)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ActualizarTipoVivienda", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdTipoVivienda", tipo.IdTipoVivienda);
        cmd.Parameters.AddWithValue("@Descripcion", (object?)tipo.Descripcion ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@NumeroHabitaciones", (object?)tipo.NumeroHabitaciones ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@SuperficieTotal", (object?)tipo.SuperficieTotal ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@NumeroPisos", (object?)tipo.NumeroPisos ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@Estacionamiento", (object?)tipo.Estacionamiento ?? DBNull.Value);

        var result = await cmd.ExecuteScalarAsync();
        return result != null;
    }


    public async Task<bool> EliminarAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_EliminarTipoVivienda", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdTipoVivienda", id);

        var result = await cmd.ExecuteScalarAsync();
        return result != null;
    }

    private static TipoVivienda MapTipoVivienda(SqlDataReader reader)
{
    return new TipoVivienda
    {
        IdTipoVivienda = Convert.ToInt32(reader["IdTipoVivienda"]),
        Descripcion = reader["Descripcion"] as string,
        NumeroHabitaciones = reader["NumeroHabitaciones"] as int?,
        SuperficieTotal = reader["SuperficieTotal"] as int?,
        NumeroPisos = reader["NumeroPisos"] as int?,
        Estacionamiento = reader["Estacionamiento"] as bool? ?? false
    };
}
}