using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services;

public class ViviendaService
{
    private readonly string _connectionString;
    private readonly ClusterService _clusterService;
    private readonly TipoViviendaService _tipoViviendaService;
    private readonly PropietarioService _propietarioService;

    public ViviendaService(
        IConfiguration configuration,
        ClusterService clusterService,
        TipoViviendaService tipoViviendaService,
        PropietarioService propietarioService)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection")
            ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
        _clusterService = clusterService;
        _tipoViviendaService = tipoViviendaService;
        _propietarioService = propietarioService;
    }

    // LISTAR TODOS (con JOINs)
    public async Task<List<Vivienda>> ObtenerTodasAsync()
    {
        var lista = new List<Vivienda>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_SelectAllViviendas", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new Vivienda
            {
                NumeroVivienda = Convert.ToInt32(reader["NumeroVivienda"]),
                IdCluster = Convert.ToInt32(reader["IdCluster"]), // No viene directamente, pero lo necesitamos para editar/eliminar
                Cluster = reader["Cluster"] as string,
                TipoVivienda = reader["TipoVivienda"] as string,
                Propietario = reader["Propietario"] as string
            });
        }
        return lista;
    }

    // BUSCAR POR CLAVE COMPUESTA
    public async Task<Vivienda?> BuscarPorClaveAsync(int numeroVivienda, int idCluster)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_BuscarVivienda", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@NumeroVivienda", numeroVivienda);
        cmd.Parameters.AddWithValue("@IdCluster", idCluster);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return new Vivienda
            {
                NumeroVivienda = Convert.ToInt32(reader["NumeroVivienda"]),
                IdCluster = Convert.ToInt32(reader["IdCluster"]),
                IdTipoVivienda = Convert.ToInt32(reader["IdTipoVivienda"]),
                IdPropietario = Convert.ToInt32(reader["IdPropietario"])
            };
        }
        return null;
    }

    // INSERTAR
    public async Task<int> InsertarAsync(Vivienda vivienda)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_CrearVivienda", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@NumeroVivienda", vivienda.NumeroVivienda);
        cmd.Parameters.AddWithValue("@IdCluster", vivienda.IdCluster);
        cmd.Parameters.AddWithValue("@IdTipoVivienda", vivienda.IdTipoVivienda);
        cmd.Parameters.AddWithValue("@IdPropietario", vivienda.IdPropietario);

        var result = await cmd.ExecuteScalarAsync();
        return Convert.ToInt32(result);
    }

    // ACTUALIZAR
    public async Task<bool> ActualizarAsync(Vivienda vivienda)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ActualizarVivivenda", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@NumeroVivienda", vivienda.NumeroVivienda);
        cmd.Parameters.AddWithValue("@IdCluster", vivienda.IdCluster);
        cmd.Parameters.AddWithValue("@IdPropietario", vivienda.IdPropietario);
        cmd.Parameters.AddWithValue("@IdTipoVivienda", vivienda.IdTipoVivienda);

        var rowsAffected = await cmd.ExecuteNonQueryAsync();
        return rowsAffected > 0;
    }

    // ELIMINAR
    public async Task<(bool exito, string mensaje)> EliminarAsync(int numeroVivienda, int idCluster)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_EliminarVivienda", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@NumeroVivienda", numeroVivienda);
        cmd.Parameters.AddWithValue("@IdCluster", idCluster);

        try
        {
            await cmd.ExecuteNonQueryAsync();
            return (true, "Vivienda eliminada correctamente.");
        }
        catch (SqlException ex) when (ex.Message.Contains("No se puede eliminar la vivienda"))
        {
            return (false, ex.Message);
        }
    }

    // Métodos para obtener listas de dependencias
    public async Task<List<Cluster>> ObtenerClustersAsync() => await _clusterService.ObtenerTodosAsync();
    public async Task<List<TipoVivienda>> ObtenerTiposViviendaAsync() => await _tipoViviendaService.ObtenerTodosAsync();
    public async Task<List<Propietario>> ObtenerPropietariosAsync() => await _propietarioService.ObtenerTodosAsync();
}