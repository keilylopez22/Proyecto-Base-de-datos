// Services/GaritaService.cs
using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services;

public class GaritaService
{
    private readonly string _connectionString;
    private readonly ClusterService _clusterService;

    public GaritaService(IConfiguration configuration, ClusterService clusterService)
    {
        _connectionString = configuration.GetConnectionString("sqlServerConnection")
            ?? throw new InvalidOperationException("Cadena de conexión 'sqlServerConnection' no encontrada.");
        _clusterService = clusterService;
    }

    // LISTAR TODAS
    public async Task<List<Garita>> ObtenerTodasAsync()
    {
        var lista = new List<Garita>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ConsultarTodasGarita", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new Garita
            {
                IdGarita = Convert.ToInt32(reader["IdGarita"]),
                IdCluster = Convert.ToInt32(reader["IdCluster"]),
                Residencial = reader["Residencial"] as string
            });
        }
        return lista;
    }

    // BUSCAR POR ID
    public async Task<Garita?> BuscarPorIdAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ConsultarPorIdGarita", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdGarita", id);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return new Garita
            {
                IdGarita = Convert.ToInt32(reader["IdGarita"]),
                IdCluster = Convert.ToInt32(reader["IdCluster"])
            };
        }
        return null;
    }

    // INSERTAR
    public async Task<int> InsertarAsync(Garita garita)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_InsertarGarita", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdCluster", garita.IdCluster);

        var result = await cmd.ExecuteScalarAsync();
        return Convert.ToInt32(result);
    }

    // ACTUALIZAR
    public async Task<bool> ActualizarAsync(Garita garita)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ActualizarGarita", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdGarita", garita.IdGarita);
        cmd.Parameters.AddWithValue("@IdCluster", garita.IdCluster);

        var rowsAffected = await cmd.ExecuteScalarAsync();
        return Convert.ToInt32(rowsAffected) > 0;
    }

    // ELIMINAR
    public async Task<(bool exito, string mensaje)> EliminarAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_EliminarGarita", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdGarita", id);

        var result = await cmd.ExecuteScalarAsync();
        var returnValue = Convert.ToInt32(result);

        return returnValue switch
        {
            1 => (true, "Garita eliminada correctamente."),
            0 => (false, "No se encontró la garita."),
            _ => (false, "No se puede eliminar la garita porque tiene registros de acceso asociados.")
        };
    }

    // Obtener lista de Clusters para el dropdown
    public async Task<List<Cluster>> ObtenerClustersAsync() => 
        await _clusterService.ObtenerTodosAsync();
}