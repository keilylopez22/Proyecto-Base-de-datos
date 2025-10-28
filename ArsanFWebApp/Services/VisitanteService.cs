using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services;

public class VisitanteService
{
    private readonly string _connectionString;

    public VisitanteService(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("SqlServerConnection")
            ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
    }

    // LISTAR TODOS
    public async Task<List<Visitante>> ObtenerTodosAsync()
    {
        var lista = new List<Visitante>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();

        using var cmd = new SqlCommand(@"
            SELECT 
                v.IdVisitante,
                v.NombreCompleto,
                v.NumeroDocumento,
                v.Telefono,
                v.MotivoVisita,
                v.IdTipoDocumento,
                t.Nombre AS TipoDocumento
            FROM Visitante v
            LEFT JOIN TipoDocumento t ON v.IdTipoDocumento = t.IdTipoDocumento
        ", conn);

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new Visitante
            {
                IdVisitante = Convert.ToInt32(reader["IdVisitante"]),
                NombreCompleto = reader["NombreCompleto"] as string ?? string.Empty,
                NumeroDocumento = reader["NumeroDocumento"] as string ?? string.Empty,
                Telefono = reader["Telefono"] != DBNull.Value ? reader["Telefono"].ToString() : string.Empty,
                MotivoVisita = reader["MotivoVisita"] as string ?? string.Empty,
                IdTipoDocumento = Convert.ToInt32(reader["IdTipoDocumento"]),
                TipoDocumento = reader["TipoDocumento"] as string ?? string.Empty
            });
        }
        return lista;
    }

    public async Task<(List<Visitante> visitantes, int totalCount)> ObtenerTodosPaginadoAsync(
    int pagina = 1, 
    int tamanoPagina = 10, 
    string? numeroDocumentoFilter = null, 
    string? nombreVisitanteFilter = null,
    int? idTipoDocumentoFilter = null)
{
    var lista = new List<Visitante>();
    int totalCount = 0;

    using var conn = new SqlConnection(_connectionString);
    await conn.OpenAsync();
    
    using var cmd = new SqlCommand("SP_SelectAllVisitante", conn);
    cmd.CommandType = System.Data.CommandType.StoredProcedure;
    cmd.Parameters.AddWithValue("@PageIndex", pagina);
    cmd.Parameters.AddWithValue("@PageSize", tamanoPagina);
    cmd.Parameters.AddWithValue("@NumeroDocumentoFilter", numeroDocumentoFilter ?? (object)DBNull.Value);
    cmd.Parameters.AddWithValue("@NombreVisitanteFilter", nombreVisitanteFilter ?? (object)DBNull.Value);
    cmd.Parameters.AddWithValue("@IdTipoDocumentoFilter", idTipoDocumentoFilter ?? (object)DBNull.Value);

    using var reader = await cmd.ExecuteReaderAsync();
    
    while (await reader.ReadAsync())
    {
        lista.Add(new Visitante
        {
            IdVisitante = Convert.ToInt32(reader["IdVisitante"]),
            NombreCompleto = reader["NombreCompleto"] as string ?? string.Empty,
            NumeroDocumento = reader["NumeroDocumento"] as string ?? string.Empty,
            Telefono = reader["Telefono"] != DBNull.Value ? reader["Telefono"].ToString() : string.Empty,
            MotivoVisita = reader["MotivoVisita"] as string ?? string.Empty,
            IdTipoDocumento = Convert.ToInt32(reader["IdTipoDocumento"]),
            NombreDocumento = reader["NombreDocumento"] as string ?? string.Empty
        });
    }

    if (await reader.NextResultAsync() && await reader.ReadAsync())
    {
        totalCount = Convert.ToInt32(reader["TotalCount"]);
    }

    return (lista, totalCount);
}

    // BUSCAR POR ID
    public async Task<Visitante?> BuscarPorIdAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ConsultarPorIdVisitante", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdVisitante", id);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return new Visitante
            {
                IdVisitante = Convert.ToInt32(reader["IdVisitante"]),
                NombreCompleto = reader["NombreCompleto"] as string ?? string.Empty,
                NumeroDocumento = reader["NumeroDocumento"] as string ?? string.Empty,
                Telefono = reader["Telefono"] != DBNull.Value ? reader["Telefono"].ToString() : string.Empty,
                MotivoVisita = reader["MotivoVisita"] as string ?? string.Empty,
                IdTipoDocumento = Convert.ToInt32(reader["IdTipoDocumento"])
            };
        }
        return null;
    }

    // BUSCAR POR DOCUMENTO
    public async Task<Visitante?> BuscarPorDocumentoAsync(string numeroDocumento)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ConsultarPorDocumentoVisitante", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@NumeroDocumento", numeroDocumento);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return new Visitante
            {
                IdVisitante = Convert.ToInt32(reader["IdVisitante"]),
                NombreCompleto = reader["NombreCompleto"] as string ?? string.Empty,
                NumeroDocumento = reader["NumeroDocumento"] as string ?? string.Empty,
                Telefono = reader["Telefono"] != DBNull.Value ? reader["Telefono"].ToString() : string.Empty,
                MotivoVisita = reader["MotivoVisita"] as string ?? string.Empty,
                IdTipoDocumento = Convert.ToInt32(reader["IdTipoDocumento"])
            };
        }
        return null;
    }

    // BUSCAR POR TIPO DOCUMENTO
    public async Task<List<Visitante>> BuscarPorTipoDocumentoAsync(int idTipoDocumento)
    {
        var lista = new List<Visitante>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ConsultarPorTipoDocumentoVisitante", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdTipoDocumento", idTipoDocumento);

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new Visitante
            {
                IdVisitante = Convert.ToInt32(reader["IdVisitante"]),
                NombreCompleto = reader["NombreCompleto"] as string ?? string.Empty,
                NumeroDocumento = reader["NumeroDocumento"] as string ?? string.Empty,
                Telefono = reader["Telefono"] != DBNull.Value ? reader["Telefono"].ToString() : string.Empty,
                MotivoVisita = reader["MotivoVisita"] as string ?? string.Empty,
                IdTipoDocumento = Convert.ToInt32(reader["IdTipoDocumento"])
            });
        }
        return lista;
    }

    // OBTENER TIPOS DE DOCUMENTO PARA DROPDOWN
    public async Task<List<TipoDocumento>> ObtenerTiposDocumentoAsync()
    {
        var lista = new List<TipoDocumento>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SELECT IdTipoDocumento, Nombre FROM TipoDocumento", conn);

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new TipoDocumento
            {
                IdTipoDocumento = Convert.ToInt32(reader["IdTipoDocumento"]),
                Nombre = reader["Nombre"] as string ?? string.Empty
            });
        }
        return lista;
    }

    // INSERTAR
    public async Task<(bool exito, string mensaje, int? id)> InsertarAsync(Visitante visitante)
    {
        try
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("SP_InsertarVisitante", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@NombreCompleto", visitante.NombreCompleto);
            cmd.Parameters.AddWithValue("@NumeroDocumento", visitante.NumeroDocumento);
            cmd.Parameters.AddWithValue("@Telefono", visitante.Telefono ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@MotivoVisita", visitante.MotivoVisita);
            cmd.Parameters.AddWithValue("@IdTipoDocumento", visitante.IdTipoDocumento);

            var result = await cmd.ExecuteScalarAsync();
            var nuevoId = Convert.ToInt32(result);
            return (true, "Visitante creado exitosamente.", nuevoId);
        }
        catch (SqlException ex)
        {
            return (false, $"Error: {ex.Message}", null);
        }
    }

    // ACTUALIZAR
    public async Task<(bool exito, string mensaje)> ActualizarAsync(Visitante visitante)
    {
        try
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("SP_ActualizarVisitante", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IdVisitante", visitante.IdVisitante);
            cmd.Parameters.AddWithValue("@NombreCompleto", visitante.NombreCompleto);
            cmd.Parameters.AddWithValue("@NumeroDocumento", visitante.NumeroDocumento);
            cmd.Parameters.AddWithValue("@Telefono", visitante.Telefono ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@MotivoVisita", visitante.MotivoVisita);
            cmd.Parameters.AddWithValue("@IdTipoDocumento", visitante.IdTipoDocumento);

            var rowsAffected = await cmd.ExecuteNonQueryAsync();
            return (rowsAffected > 0, rowsAffected > 0 ? "Visitante actualizado." : "Visitante no encontrado.");
        }
        catch (SqlException ex)
        {
            return (false, $"Error: {ex.Message}");
        }
    }

    // ELIMINAR
    public async Task<(bool exito, string mensaje)> EliminarAsync(int id)
    {
        try
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("SP_EliminarVisitante", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IdVisitante", id);

            var result = await cmd.ExecuteScalarAsync();
            var returnValue = Convert.ToInt32(result);

            return returnValue switch
            {
                1 => (true, "Visitante eliminado correctamente."),
                0 => (false, "No se encontró el visitante."),
                -1 => (false, "No se puede eliminar: existen registros de acceso asociados."),
                _ => (false, "Error desconocido.")
            };
        }
        catch (SqlException ex)
        {
            return (false, $"Error: {ex.Message}");
        }
    }
}