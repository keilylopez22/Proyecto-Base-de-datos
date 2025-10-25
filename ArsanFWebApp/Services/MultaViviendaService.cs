using ArsanWebApp.Models;
using Microsoft.Data.SqlClient;

namespace ArsanWebApp.Services;

public class MultaViviendaService
{
    private readonly string _connectionString;

    public MultaViviendaService(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("SqlServerConnection") 
            ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
    }

    public async Task<(List<MultaVivienda>, int)> ListarAsync(int pageIndex, int pageSize, string? multaFilter, string? tipoFilter, int? numeroViviendaFilter, int? clusterFilter)
    {
        var lista = new List<MultaVivienda>();
        int totalCount = 0;

        using var conn = new SqlConnection(_connectionString);
        using var cmd = new SqlCommand("SP_SelectAllMultaVivienda", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;

        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", pageSize);
        cmd.Parameters.AddWithValue("@MultaViviendaFilter", (object?)multaFilter ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@TipoMultaFilter", (object?)tipoFilter ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@NumeroViviendaFilter", (object?)numeroViviendaFilter ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@ClusterFilter", (object?)clusterFilter ?? DBNull.Value);

        await conn.OpenAsync();

        using var reader = await cmd.ExecuteReaderAsync();

        while (await reader.ReadAsync())
        {
            lista.Add(new MultaVivienda
            {
                IdMultaVivienda = Convert.ToInt32(reader["IdMultaVivienda"]),
                Monto = reader["Monto"] != DBNull.Value ? Convert.ToDecimal(reader["Monto"]) : (decimal?)null,
                Observaciones = reader["Observaciones"] as string,
                FechaInfraccion = reader["FechaInfraccion"] != DBNull.Value ? DateOnly.FromDateTime((DateTime)reader["FechaInfraccion"]) : null,
                FechaRegistro = reader["FechaRegistro"] != DBNull.Value ? DateOnly.FromDateTime((DateTime)reader["FechaRegistro"]) : null,
                EstadoPago = reader["EstadoPago"] as string,
                IdTipoMulta = Convert.ToInt32(reader["IdTipoMulta"]),
                NombreTipoMulta = reader["NombreTipoMulta"] as string,
                NumeroVivienda = Convert.ToInt32(reader["NumeroVivienda"]),
                IdCluster = Convert.ToInt32(reader["IdCluster"]),
                NombreCluster = reader["NombreCluster"] as string
            });
        }

        if (await reader.NextResultAsync() && await reader.ReadAsync())
        {
            totalCount = Convert.ToInt32(reader["TotalCount"]);
        }

        return (lista, totalCount);
    }

    public async Task InsertarAsync(MultaVivienda m)
    {
        using var conn = new SqlConnection(_connectionString);
        using var cmd = new SqlCommand("SP_InsertarMultaVivienda", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;

        cmd.Parameters.AddWithValue("@Monto", m.Monto ?? 0);
        cmd.Parameters.AddWithValue("@Observaciones", (object?)m.Observaciones ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@FechaInfraccion", (object?)m.FechaInfraccion?.ToDateTime(new TimeOnly()) ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@FechaRegistro", (object?)m.FechaRegistro?.ToDateTime(new TimeOnly()) ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@EstadoPago", (object?)m.EstadoPago ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@IdTipoMulta", m.IdTipoMulta);
        cmd.Parameters.AddWithValue("@NumeroVivienda", m.NumeroVivienda);
        cmd.Parameters.AddWithValue("@IdCluster", m.IdCluster);

        await conn.OpenAsync();
        await cmd.ExecuteNonQueryAsync();
    }

    public async Task<MultaVivienda?> BuscarPorIdAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        using var cmd = new SqlCommand("SP_BuscarMultaViviendaPorId", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdMultaVivienda", id);

        await conn.OpenAsync();
        using var reader = await cmd.ExecuteReaderAsync();

        if (await reader.ReadAsync())
        {
            return new MultaVivienda
            {
                IdMultaVivienda = Convert.ToInt32(reader["IdMultaVivienda"]),
                Monto = reader["Monto"] != DBNull.Value ? Convert.ToDecimal(reader["Monto"]) : (decimal?)null,
                Observaciones = reader["Observaciones"] as string,
                FechaInfraccion = reader["FechaInfraccion"] != DBNull.Value ? DateOnly.FromDateTime((DateTime)reader["FechaInfraccion"]) : null,
                FechaRegistro = reader["FechaRegistro"] != DBNull.Value ? DateOnly.FromDateTime((DateTime)reader["FechaRegistro"]) : null,
                EstadoPago = reader["EstadoPago"] as string,
                IdTipoMulta = Convert.ToInt32(reader["IdTipoMulta"]),
                NumeroVivienda = Convert.ToInt32(reader["NumeroVivienda"]),
                IdCluster = Convert.ToInt32(reader["IdCluster"])
            };
        }
        return null;
    }

    public async Task ActualizarAsync(MultaVivienda m)
    {
        using var conn = new SqlConnection(_connectionString);
        using var cmd = new SqlCommand("SP_ActualizarMultaVivienda", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;

        cmd.Parameters.AddWithValue("@IdMultaVivienda", m.IdMultaVivienda);
        cmd.Parameters.AddWithValue("@Monto", m.Monto ?? 0);
        cmd.Parameters.AddWithValue("@Observaciones", (object?)m.Observaciones ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@FechaInfraccion", (object?)m.FechaInfraccion?.ToDateTime(new TimeOnly()) ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@FechaRegistro", (object?)m.FechaRegistro?.ToDateTime(new TimeOnly()) ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@EstadoPago", (object?)m.EstadoPago ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@IdTipoMulta", m.IdTipoMulta);
        cmd.Parameters.AddWithValue("@NumeroVivienda", m.NumeroVivienda);
        cmd.Parameters.AddWithValue("@IdCluster", m.IdCluster);

        await conn.OpenAsync();
        await cmd.ExecuteNonQueryAsync();
    }

    public async Task EliminarAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        using var cmd = new SqlCommand("SP_EliminarMultaVivienda", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdMultaVivienda", id);

        await conn.OpenAsync();
        await cmd.ExecuteNonQueryAsync();
    }
}
