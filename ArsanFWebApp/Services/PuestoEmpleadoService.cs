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

    // Obtener todos
    public async Task<List<PuestoEmpleado>> ObtenerTodosAsync()
    {
        var lista = new List<PuestoEmpleado>();
        using var con = new SqlConnection(_connectionString);
        await con.OpenAsync();

        using var cmd = new SqlCommand("SELECT * FROM PuestoEmpleado ORDER BY IdPuestoEmpleado", con);
        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(MapPuestoEmpleado(reader));
        }
        return lista;
    }

    // Buscar por Id y/o nombre
    public async Task<List<PuestoEmpleado>> BuscarAsync(int? id = null, string? nombre = null)
    {
        var lista = new List<PuestoEmpleado>();
        using var con = new SqlConnection(_connectionString);
        await con.OpenAsync();

        var sql = "SELECT * FROM PuestoEmpleado WHERE 1=1";
        if (id.HasValue) sql += " AND IdPuestoEmpleado = @Id";
        if (!string.IsNullOrEmpty(nombre)) sql += " AND Nombre LIKE @Nombre + '%'";

        using var cmd = new SqlCommand(sql, con);
        if (id.HasValue) cmd.Parameters.AddWithValue("@Id", id.Value);
        if (!string.IsNullOrEmpty(nombre)) cmd.Parameters.AddWithValue("@Nombre", nombre);

        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
            lista.Add(MapPuestoEmpleado(reader));

        return lista;
    }

    // Buscar por Id
    public async Task<PuestoEmpleado?> BuscarPorIdAsync(int id)
    {
        using var con = new SqlConnection(_connectionString);
        await con.OpenAsync();

        using var cmd = new SqlCommand("SELECT * FROM PuestoEmpleado WHERE IdPuestoEmpleado = @Id", con);
        cmd.Parameters.AddWithValue("@Id", id);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
            return MapPuestoEmpleado(reader);
        return null;
    }

    // Crear
    public async Task CrearAsync(PuestoEmpleado puesto)
    {
        using var con = new SqlConnection(_connectionString);
        await con.OpenAsync();

        using var cmd = new SqlCommand("INSERT INTO PuestoEmpleado (Nombre, Descripcion) VALUES (@Nombre, @Descripcion)", con);
        cmd.Parameters.AddWithValue("@Nombre", puesto.Nombre ?? "");
        cmd.Parameters.AddWithValue("@Descripcion", puesto.Descripcion ?? "");

        await cmd.ExecuteNonQueryAsync();
    }

    // Actualizar
    public async Task ActualizarAsync(PuestoEmpleado puesto)
    {
        using var con = new SqlConnection(_connectionString);
        await con.OpenAsync();

        using var cmd = new SqlCommand("UPDATE PuestoEmpleado SET Nombre=@Nombre, Descripcion=@Descripcion WHERE IdPuestoEmpleado=@Id", con);
        cmd.Parameters.AddWithValue("@Id", puesto.IdPuestoEmpleado);
        cmd.Parameters.AddWithValue("@Nombre", puesto.Nombre ?? "");
        cmd.Parameters.AddWithValue("@Descripcion", puesto.Descripcion ?? "");

        await cmd.ExecuteNonQueryAsync();
    }

    // Eliminar
    public async Task EliminarAsync(int id)
    {
        using var con = new SqlConnection(_connectionString);
        await con.OpenAsync();

        using var cmd = new SqlCommand("DELETE FROM PuestoEmpleado WHERE IdPuestoEmpleado=@Id", con);
        cmd.Parameters.AddWithValue("@Id", id);

        await cmd.ExecuteNonQueryAsync();
    }
}
