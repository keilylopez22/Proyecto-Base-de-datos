using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services;

public class RegistroAccesosService
{
    private readonly string _connectionString;

    public RegistroAccesosService(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("SqlServerConnection")
            ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
    }

    // LISTAR TODOS
    public async Task<List<RegistroAccesos>> ObtenerTodosAsync()
    {
        var lista = new List<RegistroAccesos>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(@"
            SELECT ra.*, v.Placa, vis.NombreCompleto as Visitante, 
                   p.PrimerNombre + ' ' + p.PrimerApellido as Residente,
                   g.IdGarita, c.Descripcion as Cluster,
                   emp.PrimerNombre + ' ' + emp.PrimerApellido as Empleado
            FROM RegistroAccesos ra
            LEFT JOIN Vehiculo v ON ra.IdVehiculo = v.IdVehiculo
            LEFT JOIN Visitante vis ON ra.IdVisitante = vis.IdVisitante
            LEFT JOIN Residente r ON ra.IdResidente = r.IdResidente
            LEFT JOIN Persona p ON r.IdPersona = p.IdPersona
            LEFT JOIN Garita g ON ra.IdGarita = g.IdGarita
            LEFT JOIN Cluster c ON g.IdCluster = c.IdCluster
            LEFT JOIN Empleado e ON ra.IdEmpleado = e.IdEmpleado
            LEFT JOIN Persona emp ON e.IdPersona = emp.IdPersona
            ORDER BY ra.FechaIngreso DESC", conn);

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new RegistroAccesos
            {
                IdAcceso = Convert.ToInt32(reader["IdAcceso"]),
                FechaIngreso = Convert.ToDateTime(reader["FechaIngreso"]),
                FechaSalida = reader["FechaSalida"] as DateTime?,
                IdVehiculo = reader["IdVehiculo"] as int?,
                IdGarita = Convert.ToInt32(reader["IdGarita"]),
                IdVisitante = reader["IdVisitante"] as int?,
                IdResidente = reader["IdResidente"] as int?,
                IdEmpleado = Convert.ToInt32(reader["IdEmpleado"]),
                Placa = reader["Placa"] as string,
                Visitante = reader["Visitante"] as string,
                Residente = reader["Residente"] as string,
                Garita = $"Garita {reader["IdGarita"]}",
                Cluster = reader["Cluster"] as string,
                Empleado = reader["Empleado"] as string
            });
        }
        return lista;
    }

    // BUSCAR POR ID
    public async Task<RegistroAccesos?> BuscarPorIdAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ConsultarPorIdRegistroAccesos", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdRegistroAcceso", id);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return new RegistroAccesos
            {
                IdAcceso = Convert.ToInt32(reader["IdAcceso"]),
                FechaIngreso = Convert.ToDateTime(reader["FechaIngreso"]),
                FechaSalida = reader["FechaSalida"] as DateTime?,
                IdVehiculo = reader["IdVehiculo"] as int?,
                IdGarita = Convert.ToInt32(reader["IdGarita"]),
                IdVisitante = reader["IdVisitante"] as int?,
                IdResidente = reader["IdResidente"] as int?,
                IdEmpleado = Convert.ToInt32(reader["IdEmpleado"])
            };
        }
        return null;
    }

    // BUSCAR POR VEHÍCULO
    public async Task<List<RegistroAccesos>> BuscarPorVehiculoAsync(int idVehiculo)
    {
        var lista = new List<RegistroAccesos>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ConsultarPorVehiculoRegistroAccesos", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@IdVehiculo", idVehiculo);

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new RegistroAccesos
            {
                IdAcceso = Convert.ToInt32(reader["IdAcceso"]),
                FechaIngreso = Convert.ToDateTime(reader["FechaIngreso"]),
                FechaSalida = reader["FechaSalida"] as DateTime?,
                IdVehiculo = reader["IdVehiculo"] as int?,
                IdGarita = Convert.ToInt32(reader["IdGarita"]),
                IdVisitante = reader["IdVisitante"] as int?,
                IdResidente = reader["IdResidente"] as int?,
                IdEmpleado = Convert.ToInt32(reader["IdEmpleado"])
            });
        }
        return lista;
    }

    // BUSCAR POR FECHA DE INGRESO
    public async Task<List<RegistroAccesos>> BuscarPorFechaIngresoAsync(DateTime fecha)
    {
        var lista = new List<RegistroAccesos>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ConsultarPorFechaIngresoRegistroAccesos", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@Fecha", fecha.Date);

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new RegistroAccesos
            {
                IdAcceso = Convert.ToInt32(reader["IdAcceso"]),
                FechaIngreso = Convert.ToDateTime(reader["FechaIngreso"]),
                FechaSalida = reader["FechaSalida"] as DateTime?,
                IdVehiculo = reader["IdVehiculo"] as int?,
                IdGarita = Convert.ToInt32(reader["IdGarita"]),
                IdVisitante = reader["IdVisitante"] as int?,
                IdResidente = reader["IdResidente"] as int?,
                IdEmpleado = Convert.ToInt32(reader["IdEmpleado"])
            });
        }
        return lista;
    }

    // OBTENER DATOS PARA DROPDOWNS
    public async Task<List<Vehiculo>> ObtenerVehiculosAsync()
    {
        var lista = new List<Vehiculo>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SELECT IdVehiculo, Placa FROM Vehiculo", conn);

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new Vehiculo
            {
                IdVehiculo = Convert.ToInt32(reader["IdVehiculo"]),
                Placa = reader["Placa"] as string ?? string.Empty
            });
        }
        return lista;
    }

    public async Task<List<Visitante>> ObtenerVisitantesAsync()
    {
        var lista = new List<Visitante>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SELECT IdVisitante, NombreCompleto FROM Visitante", conn);

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new Visitante
            {
                IdVisitante = Convert.ToInt32(reader["IdVisitante"]),
                NombreCompleto = reader["NombreCompleto"] as string ?? string.Empty
            });
        }
        return lista;
    }

    public async Task<List<Residente>> ObtenerResidentesAsync()
    {
        var lista = new List<Residente>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(@"
            SELECT r.IdResidente, p.PrimerNombre + ' ' + p.PrimerApellido as NombreCompleto
            FROM Residente r
            INNER JOIN Persona p ON r.IdPersona = p.IdPersona", conn);

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new Residente
            {
                IdResidente = Convert.ToInt32(reader["IdResidente"]),
            });
        }
        return lista;
    }

    public async Task<List<Garita>> ObtenerGaritasAsync()
    {
        var lista = new List<Garita>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SELECT IdGarita, IdCluster FROM Garita", conn);

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new Garita
            {
                IdGarita = Convert.ToInt32(reader["IdGarita"]),
                IdCluster = Convert.ToInt32(reader["IdCluster"])
            });
        }
        return lista;
    }

    public async Task<List<Empleado>> ObtenerEmpleadosAsync()
    {
        var lista = new List<Empleado>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(@"
            SELECT e.IdEmpleado, p.PrimerNombre + ' ' + p.PrimerApellido as NombreCompleto
            FROM Empleado e
            INNER JOIN Persona p ON e.IdPersona = p.IdPersona", conn);

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new Empleado
            {
                IdEmpleado = Convert.ToInt32(reader["IdEmpleado"]),
                // Necesitarías agregar una propiedad NombreCompleto al modelo Empleado
            });
        }
        return lista;
    }

    // INSERTAR CON VALIDACIÓN DE PERSONA NO GRATA
    // ...existing code...
public async Task<(bool exito, string mensaje, int? id)> InsertarAsync(RegistroAccesos r)
{
    try
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();

        var dbName = (await new SqlCommand("SELECT DB_NAME()", conn).ExecuteScalarAsync())?.ToString() ?? "(unknown)";
        var serverName = (await new SqlCommand("SELECT @@SERVERNAME", conn).ExecuteScalarAsync())?.ToString() ?? "(unknown)";

        using (var chk = new SqlCommand("SELECT COUNT(1) FROM Garita WHERE IdGarita = @IdGarita", conn))
        {
            chk.Parameters.AddWithValue("@IdGarita", r.IdGarita);
            if (Convert.ToInt32(await chk.ExecuteScalarAsync()) == 0)
                return (false, $"Garita {r.IdGarita} no existe en {dbName}@{serverName}.", null);
        }

        if (r.IdVehiculo.HasValue)
        {
            using var chkV = new SqlCommand("SELECT COUNT(1) FROM Vehiculo WHERE IdVehiculo = @IdVehiculo", conn);
            chkV.Parameters.AddWithValue("@IdVehiculo", r.IdVehiculo.Value);
            if (Convert.ToInt32(await chkV.ExecuteScalarAsync()) == 0)
                return (false, $"Vehículo {r.IdVehiculo} no existe en {dbName}@{serverName}.", null);
        }

        if (r.IdVisitante.HasValue)
        {
            using var chkVis = new SqlCommand("SELECT COUNT(1) FROM Visitante WHERE IdVisitante = @IdVisitante", conn);
            chkVis.Parameters.AddWithValue("@IdVisitante", r.IdVisitante.Value);
            if (Convert.ToInt32(await chkVis.ExecuteScalarAsync()) == 0)
                return (false, $"Visitante {r.IdVisitante} no existe en {dbName}@{serverName}.", null);
        }

        if (r.IdResidente.HasValue)
        {
            using var chkRes = new SqlCommand("SELECT COUNT(1) FROM Residente WHERE IdResidente = @IdResidente", conn);
            chkRes.Parameters.AddWithValue("@IdResidente", r.IdResidente.Value);
            if (Convert.ToInt32(await chkRes.ExecuteScalarAsync()) == 0)
                return (false, $"Residente {r.IdResidente} no existe en {dbName}@{serverName}.", null);
        }

        if (r.IdEmpleado > 0)
        {
            using var chkEmp = new SqlCommand("SELECT COUNT(1) FROM Empleado WHERE IdEmpleado = @IdEmpleado", conn);
            chkEmp.Parameters.AddWithValue("@IdEmpleado", r.IdEmpleado);
            if (Convert.ToInt32(await chkEmp.ExecuteScalarAsync()) == 0)
                return (false, $"Empleado {r.IdEmpleado} no existe en {dbName}@{serverName}.", null);
        }

        // Insert
        using var cmd = new SqlCommand(@"
            INSERT INTO RegistroAccesos (FechaIngreso, FechaSalida, IdVehiculo, IdGarita, IdVisitante, IdResidente, IdEmpleado)
            OUTPUT INSERTED.IdAcceso
            VALUES (@FechaIngreso, @FechaSalida, @IdVehiculo, @IdGarita, @IdVisitante, @IdResidente, @IdEmpleado)
        ", conn);
        cmd.Parameters.AddWithValue("@FechaIngreso", r.FechaIngreso);
        cmd.Parameters.AddWithValue("@FechaSalida", (object?)r.FechaSalida ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@IdVehiculo", (object?)r.IdVehiculo ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@IdGarita", r.IdGarita);
        cmd.Parameters.AddWithValue("@IdVisitante", (object?)r.IdVisitante ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@IdResidente", (object?)r.IdResidente ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@IdEmpleado", r.IdEmpleado);

        var newId = await cmd.ExecuteScalarAsync();
        return (true, "Registro creado.", newId != null ? Convert.ToInt32(newId) : null);
    }
    catch (SqlException ex)
    {
        return (false, $"SQL Error: {ex.Message}", null);
    }
}

    // ACTUALIZAR
    public async Task<(bool exito, string mensaje)> ActualizarAsync(RegistroAccesos registro)
    {
        try
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("SP_ActualizarRegistroAccesos", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            
            cmd.Parameters.AddWithValue("@IdRegistroAcceso", registro.IdAcceso);
            cmd.Parameters.AddWithValue("@FechaIngreso", registro.FechaIngreso);
            cmd.Parameters.AddWithValue("@FechaSalida", registro.FechaSalida ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@IdVehiculo", registro.IdVehiculo ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@IdGarita", registro.IdGarita);
            cmd.Parameters.AddWithValue("@IdVisitante", registro.IdVisitante ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@IdResidente", registro.IdResidente ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@IdEmpleado", registro.IdEmpleado);

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

            var result = await cmd.ExecuteScalarAsync();
            var returnValue = Convert.ToInt32(result);

            return returnValue switch
            {
                1 => (true, "Registro de acceso eliminado correctamente."),
                0 => (false, "No se encontró el registro."),
                _ => (false, "Error desconocido.")
            };
        }
        catch (SqlException ex)
        {
            return (false, $"Error: {ex.Message}");
        }
    }
}