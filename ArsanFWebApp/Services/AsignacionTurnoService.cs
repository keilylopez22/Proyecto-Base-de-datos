using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services
{
    public class AsignacionTurnoService
    {
        private readonly string _connectionString;

        public AsignacionTurnoService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("SqlServerConnection")
                ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
        }

        public async Task<List<AsignacionTurno>> ListarTodosAsync()
        {
            var lista = new List<AsignacionTurno>();
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            using var cmd = new SqlCommand("SP_ListarTodosAsignacionesTurno", conn)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                lista.Add(new AsignacionTurno
                {
                    IdAsignacionTurno = Convert.ToInt32(reader["IdAsignacionTurno"]),
                    IdEmpleado = Convert.ToInt32(reader["IdEmpleado"]),
                    IdTurno = Convert.ToInt32(reader["IdTurno"]),
                    FechaAsignacion = Convert.ToDateTime(reader["FechaAsignacion"]),
                    TurnoDescripcion = reader["TurnoDescripcion"] as string,
                    NombreEmpleado = reader["NombreEmpleado"] as string
                });
            }

            return lista;
        }

        public async Task<(bool Exito, string Mensaje)> CrearAsync(AsignacionTurno asignacion)
        {
            try
            {
                using var conn = new SqlConnection(_connectionString);
                await conn.OpenAsync();

                using var cmd = new SqlCommand("SP_CrearAsignacionTurno", conn)
                {
                    CommandType = System.Data.CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@FechaAsignacion", asignacion.FechaAsignacion.Date);
                cmd.Parameters.AddWithValue("@IdEmpleado", asignacion.IdEmpleado);
                cmd.Parameters.AddWithValue("@IdTurno", asignacion.IdTurno);

                await cmd.ExecuteNonQueryAsync();
                return (true, "Asignación creada correctamente.");
            }
            catch (SqlException ex)
            {
                return (false, ex.Message);
            }
        }

        public async Task<(bool Exito, string Mensaje)> ActualizarAsync(AsignacionTurno asignacion)
        {
            try
            {
                using var conn = new SqlConnection(_connectionString);
                await conn.OpenAsync();

                using var cmd = new SqlCommand("SP_ActualizarAsignacionTurno", conn)
                {
                    CommandType = System.Data.CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@IdAsignacionTurno", asignacion.IdAsignacionTurno);
                cmd.Parameters.AddWithValue("@FechaAsignacion", asignacion.FechaAsignacion.Date);
                cmd.Parameters.AddWithValue("@IdEmpleado", asignacion.IdEmpleado);
                cmd.Parameters.AddWithValue("@IdTurno", asignacion.IdTurno);

                await cmd.ExecuteNonQueryAsync();
                return (true, "Asignación actualizada correctamente.");
            }
            catch (SqlException ex)
            {
                return (false, ex.Message);
            }
        }

        public async Task<(bool Exito, string Mensaje)> EliminarAsync(int id)
        {
            try
            {
                using var conn = new SqlConnection(_connectionString);
                await conn.OpenAsync();

                using var cmd = new SqlCommand("SP_EliminarAsignacionTurno", conn)
                {
                    CommandType = System.Data.CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@IdAsignacionTurno", id);

                await cmd.ExecuteNonQueryAsync();
                return (true, "Asignación eliminada correctamente.");
            }
            catch (SqlException ex)
            {
                return (false, ex.Message);
            }
        }

        public async Task<List<AsignacionTurno>> BuscarPorFechaAsync(DateTime fecha)
        {
            var todas = await ListarTodosAsync();
            return todas.Where(a => a.FechaAsignacion.Date == fecha.Date).ToList();
        }

        public async Task<List<AsignacionTurno>> BuscarPorEmpleadoAsync(int idEmpleado)
        {
            var todas = await ListarTodosAsync();
            return todas.Where(a => a.IdEmpleado == idEmpleado).ToList();
        }

        public async Task<AsignacionTurno?> ObtenerPorIdAsync(int id)
        {
            var todas = await ListarTodosAsync();
            return todas.FirstOrDefault(a => a.IdAsignacionTurno == id);
        }
    }
}
