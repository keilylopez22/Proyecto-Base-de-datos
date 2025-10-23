using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services;

public class TipoPagoService
{
    private readonly string _connectionString;

    public TipoPagoService(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("SqlServerConnection")
            ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
    }

    public async Task<List<TipoPago>> ObtenerTodosAsync()
    {
        var lista = new List<TipoPago>();
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SELECT idTipoPago, Nombre, Descripcion FROM TipoPago", conn);
        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            lista.Add(new TipoPago
            {
                IdTipoPago = Convert.ToInt32(reader["idTipoPago"]),
                Nombre = reader["Nombre"] as string ?? string.Empty,
                Descripcion = reader["Descripcion"] as string
            });
        }
        return lista;
    }

    public async Task<TipoPago?> BuscarPorIdAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_BuscarTipoPagoPorID", conn)
        {
            CommandType = System.Data.CommandType.StoredProcedure
        };
        cmd.Parameters.AddWithValue("@idTipoPago", id);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return new TipoPago
            {
                IdTipoPago = Convert.ToInt32(reader["idTipoPago"]),
                Nombre = reader["Nombre"] as string ?? string.Empty,
                Descripcion = reader["Descripcion"] as string
            };
        }
        return null;
    }

    public async Task<int> InsertarAsync(TipoPago tipoPago)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_InsertarTipoPago", conn)
        {
            CommandType = System.Data.CommandType.StoredProcedure
        };
        cmd.Parameters.AddWithValue("@Nombre", tipoPago.Nombre);
        cmd.Parameters.AddWithValue("@Descripcion", tipoPago.Descripcion ?? string.Empty);

        var result = await cmd.ExecuteScalarAsync();
        return Convert.ToInt32(result); 
    }


    public async Task<bool> ActualizarAsync(TipoPago tipoPago)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_ActualizarTipoPago", conn)
        {
            CommandType = System.Data.CommandType.StoredProcedure
        };
        cmd.Parameters.AddWithValue("@idTipoPago", tipoPago.IdTipoPago);
        cmd.Parameters.AddWithValue("@NuevoNombre", tipoPago.Nombre);
        cmd.Parameters.AddWithValue("@NuevaDescripcion", tipoPago.Descripcion ?? string.Empty);

        var result = await cmd.ExecuteNonQueryAsync();
        return result > 0;
    }

    public async Task<(bool Exito, string Mensaje)> EliminarAsync(int id)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_EliminarTipoPago", conn)
        {
            CommandType = System.Data.CommandType.StoredProcedure
        };
        cmd.Parameters.AddWithValue("@idTipoPago", id);

        try
        {
            await cmd.ExecuteNonQueryAsync();
            return (true, "El tipo de pago se eliminó correctamente.");
        }
        catch (SqlException ex)
        {
            return (false, ex.Message);
        }
    }


    public async Task<TipoPago?> BuscarPorNombreAsync(string nombre)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("BuscarTipoPagoPorNombre", conn)
        {
            CommandType = System.Data.CommandType.StoredProcedure
        };
        cmd.Parameters.AddWithValue("@Nombre", nombre);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return new TipoPago
            {
                Nombre = reader["Nombre"] as string ?? string.Empty,
                Descripcion = reader["Descripcion"] as string
            };
        }
        return null;
    }
}
