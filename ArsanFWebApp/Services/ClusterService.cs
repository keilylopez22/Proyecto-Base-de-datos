using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services;

public class ClusterService
{
    private readonly string _connectionString;
    private readonly ResidencialService _residencialService;

    public ClusterService(IConfiguration configuration, ResidencialService residencialService)
    {
        _connectionString = configuration.GetConnectionString("SqlServerConnection")
            ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
        _residencialService = residencialService;
    }


    public async Task<List<Cluster>> ObtenerTodosAsync()
    {
        var lista = new List<Cluster>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_SelectAllClusters", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new Cluster
            {
                IdCluster = Convert.ToInt32(reader["IdCluster"]),
                Descripcion = reader["NombreCluster"] as string ?? string.Empty,
                Residencial = reader["Residencial"] as string
            });
        }
        return lista;
    }

    public async Task<Cluster?> BuscarPorIdAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_BuscarCluster", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdCluster", id);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return new Cluster
            {
                IdCluster = Convert.ToInt32(reader["IdCluster"]),
                Descripcion = reader["Descripcion"] as string ?? string.Empty,
                IdResidencial = Convert.ToInt32(reader["IdResidencial"])
            };
        }
        return null;
    }

 
    public async Task<int> InsertarAsync(Cluster cluster)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_InsertarCluster", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@Descripcion", cluster.Descripcion);
        cmd.Parameters.AddWithValue("@IdResidencial", cluster.IdResidencial);

        var result = await cmd.ExecuteScalarAsync();
        return Convert.ToInt32(result);
    }

 
    public async Task<bool> ActualizarAsync(Cluster cluster)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ActualizarCluster", conn); 
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdCluster", cluster.IdCluster);
        cmd.Parameters.AddWithValue("@Descripcion", cluster.Descripcion);

        var result = await cmd.ExecuteScalarAsync();
        return result != null;
    }

    
    public async Task<bool> EliminarAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_EliminarCluster", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdCluster", id);

        var result = await cmd.ExecuteScalarAsync();
        return result != null;
    }

   
    public async Task<List<Residencial>> ObtenerResidencialesAsync()
    {
        return await _residencialService.ObtenerTodosAsync();
    }
}