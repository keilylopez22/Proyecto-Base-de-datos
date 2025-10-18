using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services;

public class JuntaDirectivaService
{
    private readonly string _connectionString;
    private readonly ClusterService _clusterService;

    public JuntaDirectivaService(IConfiguration configuration, ClusterService clusterService)
    {
        _connectionString = configuration.GetConnectionString("sqlServerConnection")
            ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
        _clusterService = clusterService;
    }

    // LISTAR TODOS (con JOIN a Cluster)
    public async Task<List<JuntaDirectiva>> ObtenerTodasAsync()
    {
        var lista = new List<JuntaDirectiva>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_SelectAllJuntasDirectivas", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new JuntaDirectiva
            {
                IdJuntaDirectiva = Convert.ToInt32(reader["IdJuntaDirectiva"]),
                IdCluster = Convert.ToInt32(reader["IdCluster"]), // No viene directamente, pero lo necesitamos
                Cluster = reader["Cluster"] as string
            });
        }
        return lista;
    }

    // BUSCAR POR ID
    public async Task<JuntaDirectiva?> BuscarPorIdAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_BuscarJuntaDirectivaPK", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdJuntaDirectiva", id);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return new JuntaDirectiva
            {
                IdJuntaDirectiva = Convert.ToInt32(reader["IdJuntaDirectiva"]),
                IdCluster = Convert.ToInt32(reader["IdCluster"])
            };
        }
        return null;
    }

    // INSERTAR
    public async Task<int> InsertarAsync(JuntaDirectiva junta)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_InsertarJuntaDirectiva", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdCluster", junta.IdCluster);

        var result = await cmd.ExecuteScalarAsync();
        return Convert.ToInt32(result);
    }

    // ACTUALIZAR
    public async Task<bool> ActualizarAsync(JuntaDirectiva junta)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ActualizarJuntaDirectiva", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdJuntaDirectiva", junta.IdJuntaDirectiva);
        cmd.Parameters.AddWithValue("@IdCluster", junta.IdCluster);

        var result = await cmd.ExecuteScalarAsync();
        return result != null;
    }

    // ELIMINAR
    public async Task<(bool exito, string mensaje)> EliminarAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_EliminarJuntaDirectiva", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdJuntaDirectiva", id);

        try
        {
            await cmd.ExecuteNonQueryAsync();
            return (true, "Junta Directiva eliminada correctamente.");
        }
        catch (SqlException ex) when (ex.Message.Contains("No se puede eliminar la Junta Directiva"))
        {
            return (false, ex.Message);
        }
    }

    // Obtener lista de Clusters para el dropdown
    public async Task<List<Cluster>> ObtenerClustersAsync() => await _clusterService.ObtenerTodosAsync();
}