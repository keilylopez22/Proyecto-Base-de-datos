using System.Data;
using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services
{
    public class VehiculoProhibidoService
    {
        private readonly string _connectionString;

        public VehiculoProhibidoService(IConfiguration config)
        {
            _connectionString = config.GetConnectionString("SqlServerConnection") 
                ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
        }

        private VehiculoProhibido Map(SqlDataReader dr)
        {
            return new VehiculoProhibido
            {
                IdVehiculoProhibido = Convert.ToInt32(dr["IdVehiculoProhibido"]),
                Fecha = dr["Fecha"] == DBNull.Value ? null : DateOnly.FromDateTime(Convert.ToDateTime(dr["Fecha"])),
                Motivo = dr["Motivo"] as string,
                IdVehiculo = Convert.ToInt32(dr["IdVehiculo"]),
                Placa = HasColumn(dr, "Placa") ? dr["Placa"] as string : null,
                Marca = HasColumn(dr, "Marca") ? dr["Marca"] as string : null
            };
        }

        private static bool HasColumn(SqlDataReader reader, string columnName)
        {
            for (int i = 0; i < reader.FieldCount; i++)
                if (string.Equals(reader.GetName(i), columnName, StringComparison.OrdinalIgnoreCase))
                    return true;
            return false;
        }

        public async Task<List<VehiculoProhibido>> ObtenerTodosAsync()
        {
            var lista = new List<VehiculoProhibido>();
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            var query = @"SELECT vp.IdVehiculoProhibido, vp.Fecha, vp.Motivo,
                                 v.IdVehiculo, v.Placa, m.Descripcion AS Marca
                          FROM VehiculoProhibido vp
                          INNER JOIN Vehiculo v ON vp.IdVehiculo = v.IdVehiculo
                          INNER JOIN Marca m ON v.IdMarca = m.IdMarca";

            using var cmd = new SqlCommand(query, conn);
            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
                lista.Add(Map(reader));

            return lista;
        }

        public async Task<VehiculoProhibido?> BuscarPorIdAsync(int id)
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            using var cmd = new SqlCommand("SP_BuscarVehiculoProhiubidoPorId", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IdVehiculoProhibido", id);

            using var reader = await cmd.ExecuteReaderAsync();
            if (await reader.ReadAsync())
                return Map(reader);

            return null;
        }

        public async Task<List<VehiculoProhibido>> BuscarPorFechaAsync(DateTime fecha)
        {
            var lista = new List<VehiculoProhibido>();
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            using var cmd = new SqlCommand("SP_BuscarVehiculoProhiubidoPorFecha", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Fecha", fecha);

            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
                lista.Add(Map(reader));

            return lista;
        }

        public async Task CrearAsync(VehiculoProhibido vp)
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            using var cmd = new SqlCommand("SP_InsertarVehiculoProhibido", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Fecha", vp.Fecha.HasValue ? vp.Fecha.Value.ToDateTime(TimeOnly.MinValue) : DBNull.Value);
            cmd.Parameters.AddWithValue("@Motivo", vp.Motivo ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@IdVehiculo", vp.IdVehiculo);

            await cmd.ExecuteNonQueryAsync();
        }

        public async Task ActualizarAsync(VehiculoProhibido vp)
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            using var cmd = new SqlCommand("SP_ActualizarVehiculoProhibido", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IdVehiculoProhibido", vp.IdVehiculoProhibido);
            cmd.Parameters.AddWithValue("@Fecha", vp.Fecha.HasValue ? vp.Fecha.Value.ToDateTime(TimeOnly.MinValue) : DBNull.Value);
            cmd.Parameters.AddWithValue("@Motivo", vp.Motivo ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@IdVehiculo", vp.IdVehiculo);

            await cmd.ExecuteNonQueryAsync();
        }

        public async Task EliminarAsync(int id)
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            using var cmd = new SqlCommand("SP_EliminarVehiculoProhibido", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IdVehiculoProhibido", id);

            await cmd.ExecuteNonQueryAsync();
        }
    }
}
