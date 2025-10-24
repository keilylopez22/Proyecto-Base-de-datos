using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;
using System.Data;

namespace ArsanWebApp.Services;

public class PuestoEmpleadoService
{
    private readonly string _connectionString;

    public PuestoEmpleadoService(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("SqlServerConnection") 
            ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
    }

    private static PuestoEmpleado MapPuestoEmpleado(SqlDataReader reader)
    {
        return new PuestoEmpleado
        {
            IdPuestoEmpleado = Convert.ToInt32(reader["IdPuestoEmpleado"]),
            Nombre = reader["Nombre"] as string,
            Descripcion = reader["Descripcion"] as string
        };
    }

    // Listado con paginación
    public async Task<(List<PuestoEmpleado> Lista, int TotalCount)> ObtenerTodosAsync(int page = 1, int pageSize = 10, string nombreFilter = null)
    {
        var lista = new List<PuestoEmpleado>();
        int totalCount = 0;

        using var con = new SqlConnection(_connectionString);
        await con.OpenAsync();

        using var cmd = new SqlCommand("SP_SelectAllPuestoEmpleado", con)
        {
            CommandType = CommandType.StoredProcedure
        };

        cmd.Parameters.AddWithValue("@PageIndex", page);
        cmd.Parameters.AddWithValue("@PageSize", pageSize);
        cmd.Parameters.AddWithValue("@NombreFilter", string.IsNullOrEmpty(nombreFilter) ? (object)DBNull.Value : nombreFilter);

        using var reader = await cmd.ExecuteReaderAsync();

        while (await reader.ReadAsync())
            lista.Add(MapPuestoEmpleado(reader));

        if (await reader.NextResultAsync() && await reader.ReadAsync())
            totalCount = Convert.ToInt32(reader["TotalCount"]);

        return (lista, totalCount);
    }

    // Buscar por Id
    public async Task<PuestoEmpleado?> BuscarPorIdAsync(int id)
    {
        using var con = new SqlConnection(_connectionString);
        await con.OpenAsync();

        using var cmd = new SqlCommand("SP_ObtenerPuestoEmpleadoPorId", con)
        {
            CommandType = CommandType.StoredProcedure
        };
        cmd.Parameters.AddWithValue("@IdPuestoEmpleado", id);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
            return MapPuestoEmpleado(reader);

        return null;
    }

    // Buscar por nombre
    public async Task<List<PuestoEmpleado>> BuscarPorNombreAsync(string nombre)
    {
        var lista = new List<PuestoEmpleado>();
        using var con = new SqlConnection(_connectionString);
        await con.OpenAsync();

        using var cmd = new SqlCommand("SP_BuscarPuestoTrabajoPorNombre", con)
        {
            CommandType = CommandType.StoredProcedure
        };
        cmd.Parameters.AddWithValue("@Nombre", nombre);

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
            lista.Add(MapPuestoEmpleado(reader));

        return lista;
    }

    // Buscar por descripción
    public async Task<List<PuestoEmpleado>> BuscarPorDescripcionAsync(string descripcion)
    {
        var lista = new List<PuestoEmpleado>();
        using var con = new SqlConnection(_connectionString);
        await con.OpenAsync();

        using var cmd = new SqlCommand("PS_BuscarPuestoEmpleadoPorDescripcion", con)
        {
            CommandType = CommandType.StoredProcedure
        };
        cmd.Parameters.AddWithValue("@Descripcion", descripcion);

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
            lista.Add(MapPuestoEmpleado(reader));

        return lista;
    }

    // Crear
    public async Task CrearAsync(PuestoEmpleado puesto)
    {
        using var con = new SqlConnection(_connectionString);
        await con.OpenAsync();

        using var cmd = new SqlCommand("SP_CrearPuestoEmpleado", con)
        {
            CommandType = CommandType.StoredProcedure
        };
        cmd.Parameters.AddWithValue("@Nombre", puesto.Nombre ?? "");
        cmd.Parameters.AddWithValue("@Descripcion", puesto.Descripcion ?? "");

        await cmd.ExecuteNonQueryAsync();
    }

    // Actualizar
    public async Task ActualizarAsync(PuestoEmpleado puesto)
    {
        using var con = new SqlConnection(_connectionString);
        await con.OpenAsync();

        using var cmd = new SqlCommand("SP_ActualizarPuestoEmpleado", con)
        {
            CommandType = CommandType.StoredProcedure
        };
        cmd.Parameters.AddWithValue("@IdPuestoEmpleado", puesto.IdPuestoEmpleado);
        cmd.Parameters.AddWithValue("@Nombre", puesto.Nombre ?? "");
        cmd.Parameters.AddWithValue("@Descripcion", puesto.Descripcion ?? "");

        await cmd.ExecuteNonQueryAsync();
    }

    // Eliminar
    public async Task EliminarAsync(int id)
    {
        using var con = new SqlConnection(_connectionString);
        await con.OpenAsync();

        using var cmd = new SqlCommand("SP_EliminarPuestoEmpleado", con)
        {
            CommandType = CommandType.StoredProcedure
        };
        cmd.Parameters.AddWithValue("@IdPuestoEmpleado", id);

        await cmd.ExecuteNonQueryAsync();
    }
}
