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
                Motivo = dr["Motivo"]?.ToString(),
                IdVehiculo = Convert.ToInt32(dr["IdVehiculo"])
            };
        }

        public async Task<(List<VehiculoProhibido> Lista, int Total)> ObtenerTodosAsync(
            int pageIndex = 1, int pageSize = 5, string? placa = null, string? motivo = null, DateTime? fecha = null)
        {
            var lista = new List<VehiculoProhibido>();
            int total = 0;

            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            using var cmd = new SqlCommand("SP_SelectAllVehiculoProhibido", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
            cmd.Parameters.AddWithValue("@PageSize", pageSize);
            cmd.Parameters.AddWithValue("@FechaFilter", (object?)fecha ?? DBNull.Value);

            using var reader = await cmd.ExecuteReaderAsync();

            // Primer conjunto de resultados → lista
            while (await reader.ReadAsync())
                lista.Add(Map(reader));

            // Segundo conjunto de resultados → total
            if (await reader.NextResultAsync() && await reader.ReadAsync())
                total = Convert.ToInt32(reader["TotalCount"]);

            return (lista, total);
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
