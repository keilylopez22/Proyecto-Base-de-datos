using System.Data;
using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services
{
    public class AsignacionTurnoService
    {
        private readonly string _connectionString;

        public AsignacionTurnoService(IConfiguration config)
        {
            _connectionString = config.GetConnectionString("SqlServerConnection")
                ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
        }

        private AsignacionTurno Map(SqlDataReader dr)
        {
            return new AsignacionTurno
            {
                IdAsignacionTurno = Convert.ToInt32(dr["IdAsignacionTurno"]),
                IdEmpleado = Convert.ToInt32(dr["IdEmpleado"]),
                IdTurno = Convert.ToInt32(dr["IdTurno"]),
                FechaAsignacion = dr["FechaAsignacion"] == DBNull.Value ? default(DateTime) : Convert.ToDateTime(dr["FechaAsignacion"]),
                NombreEmpleado = null, // Ya no mapeamos
                NombreTurno = null     // Ya no mapeamos
            };
        }

        public async Task<(List<AsignacionTurno> lista, int total)> ObtenerTodosAsync(
            int pagina,
            int tamanioPagina,
            int? idEmpleado = null,
            int? idTurno = null,
            DateTime? fechaFilter = null)
        {
            var lista = new List<AsignacionTurno>();
            int total = 0;

            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            using var cmd = new SqlCommand("SP_SelectAllAsignacionDeTurno", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@PageIndex", pagina);
            cmd.Parameters.AddWithValue("@PageSize", tamanioPagina);
            cmd.Parameters.AddWithValue("@IdEmpleado", idEmpleado.HasValue ? idEmpleado.Value : (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@IdTurno", idTurno.HasValue ? idTurno.Value : (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@FechaFilter", fechaFilter.HasValue ? fechaFilter.Value : (object)DBNull.Value);

            using var reader = await cmd.ExecuteReaderAsync();

            while (await reader.ReadAsync())
                lista.Add(Map(reader));

            if (await reader.NextResultAsync() && await reader.ReadAsync())
                total = Convert.ToInt32(reader["TotalCount"]);

            return (lista, total);
        }

        public async Task<AsignacionTurno?> BuscarPorIdAsync(int id)
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            using var cmd = new SqlCommand("SP_ObtenerAsignacionTurnoPorId", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IdAsignacionTurno", id);

            using var reader = await cmd.ExecuteReaderAsync();
            if (await reader.ReadAsync())
                return Map(reader);

            return null;
        }

        public async Task CrearAsync(AsignacionTurno asignacion)
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            using var cmd = new SqlCommand("SP_CrearAsignacionTurno", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@FechaAsignacion", asignacion.FechaAsignacion == default ? DBNull.Value : asignacion.FechaAsignacion);
            cmd.Parameters.AddWithValue("@IdEmpleado", asignacion.IdEmpleado);
            cmd.Parameters.AddWithValue("@IdTurno", asignacion.IdTurno);

            await cmd.ExecuteNonQueryAsync();
        }

        public async Task ActualizarAsync(AsignacionTurno asignacion)
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            using var cmd = new SqlCommand("SP_ActualizarAsignacionTurno", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IdAsignacionTurno", asignacion.IdAsignacionTurno);
            cmd.Parameters.AddWithValue("@FechaAsignacion", asignacion.FechaAsignacion == default ? DBNull.Value : asignacion.FechaAsignacion);
            cmd.Parameters.AddWithValue("@IdEmpleado", asignacion.IdEmpleado);
            cmd.Parameters.AddWithValue("@IdTurno", asignacion.IdTurno);

            await cmd.ExecuteNonQueryAsync();
        }

        public async Task EliminarAsync(int id)
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            using var cmd = new SqlCommand("SP_EliminarAsignacionTurno", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IdAsignacionTurno", id);

            await cmd.ExecuteNonQueryAsync();
        }
    }
}
