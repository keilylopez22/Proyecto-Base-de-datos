// Services/ResidenteService.cs
using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services;

public class ResidenteService
{
    private readonly string _connectionString;
    private readonly PersonaService _personaService;
    private readonly ViviendaService _viviendaService;

    public ResidenteService(
        IConfiguration configuration,
        PersonaService personaService,
        ViviendaService viviendaService)
    {
        _connectionString = configuration.GetConnectionString("SqlServerConnection")
            ?? throw new InvalidOperationException("Cadena de conexión 'SqlServerConnection' no encontrada.");
        _personaService = personaService;
        _viviendaService = viviendaService;
    }

   
    public async Task<(List<Residente> Items, int TotalCount)> ObtenerResidentesAsync(
        int pageIndex,
        int pageSize,
        string? nombreFilter = null,
        bool? esInquilinoFilter = null,
        string? estadoFilter = null,
        string? clusterFilter = null,
        int? numeroViviendaFilter = null,
        string? generoFilter = null)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_SelectAllResidentes", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
        cmd.Parameters.AddWithValue("@PageSize", pageSize);
        cmd.Parameters.AddWithValue("@NombreResidenteFilter", (object?)nombreFilter ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@EsInquilinoFilter", (object?)esInquilinoFilter ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@EstadoFilter", (object?)estadoFilter ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@ClusterFilter", (object?)clusterFilter ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@NumeroViviendaFilter", (object?)numeroViviendaFilter ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@GeneroFilter", (object?)generoFilter ?? DBNull.Value);

        var residentes = new List<Residente>();
        int totalCount = 0;

        using (var reader = await cmd.ExecuteReaderAsync())
        {
            while (await reader.ReadAsync())
            {
                residentes.Add(new Residente
                {
                    IdResidente = Convert.ToInt32(reader["IdResidente"]),
                    IdPersona = Convert.ToInt32(reader["IdPersona"]),
                    NumeroVivienda = Convert.ToInt32(reader["NumeroVivienda"]),
                    IdCluster = Convert.ToInt32(reader["IdCluster"]),
                    EsInquilino = Convert.ToBoolean(reader["EsInquilino"]),
                    Estado = reader["Estado"] as string,
                    NombreCompleto = reader["NombreCompleto"] as string,
                    ClusterDescripcion = reader["ClusterDescripcion"] as string
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

        return (residentes, totalCount);
    }

   
    public async Task<Residente?> BuscarPorIdAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_BuscarResidentePorId", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdResidente", id);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return new Residente
            {
                IdResidente = Convert.ToInt32(reader["IdResidente"]),
                IdPersona = Convert.ToInt32(reader["IdPersona"]),
                NumeroVivienda = Convert.ToInt32(reader["NumeroVivienda"]),
                IdCluster = Convert.ToInt32(reader["IdCluster"]),
                EsInquilino = Convert.ToBoolean(reader["EsInquilino"]),
                Estado = reader["Estado"] as string,
                NombreCompleto = reader["NombreCompleto"] as string,
                ClusterDescripcion = reader["ClusterDescripcion"] as string
            };
        }
        return null;
    }

   
    public async Task<int> InsertarAsync(Residente residente)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_InsertarResidente", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdPersona", residente.IdPersona);
        cmd.Parameters.AddWithValue("@NumeroVivienda", residente.NumeroVivienda);
        cmd.Parameters.AddWithValue("@IdCluster", residente.IdCluster);
        cmd.Parameters.AddWithValue("@EsInquilino", residente.EsInquilino);
        cmd.Parameters.AddWithValue("@Estado", (object?)residente.Estado ?? DBNull.Value);

        var result = await cmd.ExecuteScalarAsync();
        return Convert.ToInt32(result);
    }

   
    public async Task<bool> ActualizarAsync(Residente residente)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ActualizarResidente", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdResidente", residente.IdResidente);
        cmd.Parameters.AddWithValue("@IdPersona", residente.IdPersona);
        cmd.Parameters.AddWithValue("@NumeroVivienda", residente.NumeroVivienda);
        cmd.Parameters.AddWithValue("@IdCluster", residente.IdCluster);
        cmd.Parameters.AddWithValue("@EsInquilino", residente.EsInquilino);
        cmd.Parameters.AddWithValue("@Estado", (object?)residente.Estado ?? DBNull.Value);

        var result = await cmd.ExecuteScalarAsync();
        return result != null;
    }

  
    public async Task<bool> EliminarAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_EliminarResidente", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdResidente", id);

        var result = await cmd.ExecuteScalarAsync();
        return result != null;
    }


    public async Task<List<Persona>> ObtenerPersonasAsync() => 
        await _personaService.ObtenerTodasAsync();

    public async Task<List<Vivienda>> ObtenerViviendasAsync() =>
        await _viviendaService.ObtenerTodasAsync();
}