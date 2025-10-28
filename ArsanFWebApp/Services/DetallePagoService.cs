using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ArsanWebApp.Models;
using System.Data;
using System.Data.SqlClient;
namespace ArsanWebApp.Services
{
    // Services/DetallePagoService.cs
public class DetallePagoService
{
    private readonly string _connectionString;

    public DetallePagoService(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("SqlServerConnection") 
            ?? throw new InvalidOperationException("Cadena no encontrada.");
    }

    public async Task<int> InsertarAsync(DetallePago detalle)
    {
        using var conn = new SqlConnection(_connectionString);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SP_InsertarDetallePago", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@Monto", detalle.Monto);
        cmd.Parameters.AddWithValue("@IdTipoPago", detalle.IdTipoPago);
        cmd.Parameters.AddWithValue("@IdPago", detalle.IdPago);
        cmd.Parameters.AddWithValue("@Referencia", (object?)detalle.Referencia ?? DBNull.Value);

        var result = await cmd.ExecuteScalarAsync();
        return Convert.ToInt32(result);
    }
}
}