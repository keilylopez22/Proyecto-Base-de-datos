using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;
using Microsoft.AspNetCore.Mvc.Rendering; 

namespace ArsanWebApp.Services;

public class RegistroAccesosService
{
    private readonly string _connectionString;

    public RegistroAccesosService(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("SqlServerConnection")
            ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
    }

    // LISTAR TODOS CON PAGINACIÓN
    public async Task<(List<RegistroAcceso> registros, int totalCount)> ObtenerTodosPaginadoAsync(
        int pagina = 1, 
        int tamanoPagina = 10, 
        DateTime? fechaIngresoDesde = null, 
        DateTime? fechaIngresoHasta = null,
        int? idGaritaFilter = null,
        int? idEmpleadoFilter = null,
        string? tipoAccesoFilter = null
        , int? ViviendaDestino = null
        )
    {
        var lista = new List<RegistroAcceso>();
        int totalCount = 0;

        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        
        using var cmd = new SqlCommand("SP_SelectAllRegistroAcceso", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@PageIndex", pagina);
        cmd.Parameters.AddWithValue("@PageSize", tamanoPagina);
        cmd.Parameters.AddWithValue("@FechaIngresoDesde", fechaIngresoDesde ?? (object)DBNull.Value);
        cmd.Parameters.AddWithValue("@FechaIngresoHasta", fechaIngresoHasta ?? (object)DBNull.Value);
        cmd.Parameters.AddWithValue("@IdGaritaFilter", idGaritaFilter ?? (object)DBNull.Value);
        cmd.Parameters.AddWithValue("@IdEmpleadoFilter", idEmpleadoFilter ?? (object)DBNull.Value);
        cmd.Parameters.AddWithValue("@TipoAccesoFilter", tipoAccesoFilter ?? (object)DBNull.Value);
        cmd.Parameters.AddWithValue("@ViviendaDestino", ViviendaDestino ?? (object)DBNull.Value);
        

        using var reader = await cmd.ExecuteReaderAsync();
        
        while (await reader.ReadAsync())
        {
            lista.Add(new RegistroAcceso
            {
                IdAcceso = Convert.ToInt32(reader["IdAcceso"]),
                FechaIngreso = reader["FechaIngreso"] != DBNull.Value ? Convert.ToDateTime(reader["FechaIngreso"]) : null,
                FechaSalida = reader["FechaSalida"] != DBNull.Value ? Convert.ToDateTime(reader["FechaSalida"]) : null,
                Observaciones = reader["Observaciones"] as string ?? string.Empty,
                IdVehiculo = reader["IdVehiculo"] != DBNull.Value ? Convert.ToInt32(reader["IdVehiculo"]) : null,
                IdGarita = Convert.ToInt32(reader["IdGarita"]),
                IdVisitante = reader["IdVisitante"] != DBNull.Value ? Convert.ToInt32(reader["IdVisitante"]) : null,
                IdResidente = reader["IdResidente"] != DBNull.Value ? Convert.ToInt32(reader["IdResidente"]) : null,
                IdEmpleado = Convert.ToInt32(reader["IdEmpleado"]),
                IdClusterGarita = Convert.ToInt32(reader["IdClusterGarita"]),
                ClusterGarita = reader["ClusterGarita"] as string ?? string.Empty,
                TipoAcceso = reader["TipoAcceso"] as string ?? string.Empty,
                DescripcionAcceso = reader["DescripcionAcceso"] as string ?? string.Empty,
                ViviendaDestino = reader["ViviendaDestino"] != DBNull.Value ? Convert.ToInt32(reader["ViviendaDestino"]) : null,

            });
        } 

        if (await reader.NextResultAsync() && await reader.ReadAsync())
        {
            totalCount = Convert.ToInt32(reader["TotalCount"]);
        }

        return (lista, totalCount);
    }

    // BUSCAR POR ID
    public async Task<RegistroAcceso?> BuscarPorIdAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ConsultarPorIdRegistroAccesos", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdRegistroAcceso", id);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return new RegistroAcceso
            {
                IdAcceso = Convert.ToInt32(reader["IdAcceso"]),
                FechaIngreso = reader["FechaIngreso"] != DBNull.Value ? Convert.ToDateTime(reader["FechaIngreso"]) : null,
                FechaSalida = reader["FechaSalida"] != DBNull.Value ? Convert.ToDateTime(reader["FechaSalida"]) : null,
                Observaciones = reader["Observaciones"] as string ?? string.Empty,
                IdVehiculo = reader["IdVehiculo"] != DBNull.Value ? Convert.ToInt32(reader["IdVehiculo"]) : null,
                IdGarita = Convert.ToInt32(reader["IdGarita"]),
                IdVisitante = reader["IdVisitante"] != DBNull.Value ? Convert.ToInt32(reader["IdVisitante"]) : null,
                IdResidente = reader["IdResidente"] != DBNull.Value ? Convert.ToInt32(reader["IdResidente"]) : null,
                IdEmpleado = Convert.ToInt32(reader["IdEmpleado"])
            };
        }
        return null;
    }

    // OBTENER DATOS PARA DROPDOWNS
// OBTENER DATOS PARA DROPDOWNS
public async Task<List<GaritaDropdown>> ObtenerGaritasAsync()
{
    var lista = new List<GaritaDropdown>();
    using var conn = new SqlConnection(_connectionString);
    await conn.OpenAsync();

    using var cmd = new SqlCommand(@"
        SELECT g.IdGarita, c.Descripcion as ClusterDescripcion
        FROM Garita g
        INNER JOIN Cluster c ON g.IdCluster = c.IdCluster
    ", conn);

    using var reader = await cmd.ExecuteReaderAsync();
    while (await reader.ReadAsync())
    {
        lista.Add(new GaritaDropdown
        {
            IdGarita = Convert.ToInt32(reader["IdGarita"]),
            Descripcion = reader["ClusterDescripcion"] as string ?? string.Empty
        });
    }
    return lista;
}

    public async Task<List<EmpleadoDropdown>> ObtenerEmpleadosAsync()
    {
        var lista = new List<EmpleadoDropdown>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();

        using var cmd = new SqlCommand(@"
        SELECT e.IdEmpleado, p.PrimerNombre + ' ' + p.PrimerApellido as NombreCompleto
        FROM Empleado e
        INNER JOIN Persona p ON e.IdPersona = p.IdPersona
        WHERE e.Estado = 'ACTIVO'
    ", conn);

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new EmpleadoDropdown
            {
                IdEmpleado = Convert.ToInt32(reader["IdEmpleado"]),
                NombreCompleto = reader["NombreCompleto"] as string ?? string.Empty
            });
        }
        return lista;
    }

    public async Task<List<SelectListItem>> ObtenerVehiculosAsync()
    {
        var lista = new List<SelectListItem>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();

        using var cmd = new SqlCommand(@"
        SELECT IdVehiculo, Placa 
        FROM Vehiculo 
        ORDER BY Placa
    ", conn);

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new SelectListItem
            {
                Value = reader["IdVehiculo"].ToString(),
                Text = reader["Placa"] as string ?? string.Empty
            });
        }
        return lista;
    }

    public async Task<List<SelectListItem>> ObtenerVisitantesAsync()
    {
        var lista = new List<SelectListItem>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();

        using var cmd = new SqlCommand(@"
        SELECT IdVisitante, NombreCompleto 
        FROM Visitante 
        ORDER BY NombreCompleto
    ", conn);

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new SelectListItem
            {
                Value = reader["IdVisitante"].ToString(),
                Text = reader["NombreCompleto"] as string ?? string.Empty
            });
        }
        return lista;
    }

    public async Task<List<SelectListItem>> ObtenerResidentesAsync()
    {
        var lista = new List<SelectListItem>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();

        using var cmd = new SqlCommand(@"
        SELECT r.IdResidente, p.PrimerNombre + ' ' + p.PrimerApellido as NombreCompleto
        FROM Residente r
        INNER JOIN Persona p ON r.IdPersona = p.IdPersona
        ORDER BY NombreCompleto
    ", conn);

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new SelectListItem
            {
                Value = reader["IdResidente"].ToString(),
                Text = reader["NombreCompleto"] as string ?? string.Empty
            });
        }
        return lista;
    }

    // INSERTAR
    public async Task<(bool exito, string mensaje, int? id)> InsertarAsync(RegistroAcceso registro)
    {
        try
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("SP_InsertarRegistroAccesos", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@FechaIngreso", registro.FechaIngreso ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@FechaSalida", registro.FechaSalida ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@IdVehiculo", registro.IdVehiculo ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@IdGarita", registro.IdGarita);
            cmd.Parameters.AddWithValue("@IdVisitante", registro.IdVisitante ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@IdResidente", registro.IdResidente ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@IdEmpleado", registro.IdEmpleado);
            cmd.Parameters.AddWithValue("@ViviendaDestino", registro.ViviendaDestino ?? (object)DBNull.Value);

            var result = await cmd.ExecuteScalarAsync();
            var nuevoId = result != null ? Convert.ToInt32(result) : (int?)null;
            return (true, "Registro de acceso creado exitosamente.", nuevoId);
        }
        catch (SqlException ex)
        {
            return (false, $"Error: {ex.Message}", null);
        }
    }

    // ACTUALIZAR
    public async Task<(bool exito, string mensaje)> ActualizarAsync(RegistroAcceso registro)
    {
        try
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("SP_ActualizarRegistroAccesos", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IdRegistroAcceso", registro.IdAcceso);
            cmd.Parameters.AddWithValue("@FechaIngreso", registro.FechaIngreso ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@FechaSalida", registro.FechaSalida ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@IdVehiculo", registro.IdVehiculo ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@IdGarita", registro.IdGarita);
            cmd.Parameters.AddWithValue("@IdVisitante", registro.IdVisitante ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@IdResidente", registro.IdResidente ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@IdEmpleado", registro.IdEmpleado);
            cmd.Parameters.AddWithValue("@ViviendaDestino", registro.ViviendaDestino ?? (object)DBNull.Value);

            var rowsAffected = await cmd.ExecuteNonQueryAsync();
            return (rowsAffected > 0, rowsAffected > 0 ? "Registro actualizado." : "Registro no encontrado.");
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
            using var cmd = new SqlCommand("SP_EliminarRegistroAccesos", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IdRegistroAcceso", id);

            var rowsAffected = await cmd.ExecuteNonQueryAsync();
            return (rowsAffected > 0, rowsAffected > 0 ? "Registro eliminado." : "Registro no encontrado.");
        }
        catch (SqlException ex)
        {
            return (false, $"Error: {ex.Message}");
        }
    }
}

// Modelos auxiliares para dropdowns
public class GaritaDropdown
{
    public int IdGarita { get; set; }
    public string? Descripcion { get; set; }
}

public class EmpleadoDropdown
{
    public int IdEmpleado { get; set; }
    public string? NombreCompleto { get; set; }
}

public class VehiculoDropdown
{
    public int IdVehiculo { get; set; }
    public string? Placa { get; set; }
    public string? DescripcionCompleta { get; set; }
}