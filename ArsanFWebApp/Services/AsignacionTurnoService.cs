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
                NombreEmpleado = HasColumn(dr, "NombreEmpleado") ? dr["NombreEmpleado"] as string : (HasColumn(dr, "Nombre Empleado") ? dr["Nombre Empleado"] as string : null),
                NombreTurno = HasColumn(dr, "Turno") ? dr["Turno"] as string : (HasColumn(dr, "NombreTurno") ? dr["NombreTurno"] as string : null)
            };
        }

        private static bool HasColumn(SqlDataReader reader, string columnName)
        {
            for (int i = 0; i < reader.FieldCount; i++)
            {
                if (string.Equals(reader.GetName(i), columnName, StringComparison.OrdinalIgnoreCase))
                    return true;
            }
            return false;
        }

        public async Task<List<AsignacionTurno>> ObtenerTodosAsync()
        {
            var lista = new List<AsignacionTurno>();

            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            var query = @"SELECT st.IdAsignacionTurno, st.IdEmpleado, st.IdTurno, st.FechaAsignacion,
                          p.PrimerNombre + ' ' + p.PrimerApellido AS [Nombre Empleado],
                          t.Descripcion AS Turno
                          FROM AsignacionTurno st
                          INNER JOIN Empleado e ON st.IdEmpleado = e.IdEmpleado
                          INNER JOIN Persona p ON e.IdEmpleado = p.IdPersona
                          INNER JOIN Turno t ON st.IdTurno = t.IdTurno";

            using var cmd = new SqlCommand(query, conn);
            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
                lista.Add(Map(reader));

            return lista;
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

        public async Task<List<AsignacionTurno>> BuscarPorEmpleadoAsync(int idEmpleado)
        {
            var lista = new List<AsignacionTurno>();

            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            using var cmd = new SqlCommand("SP_BuscarAsignacionTurnoPorEmplead", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IdEmpleado", idEmpleado);

            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
                lista.Add(Map(reader));

            return lista;
        }

        public async Task CrearAsync(AsignacionTurno asignacion)
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            using var cmd = new SqlCommand("SP_CrearAsignacionTurno", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@FechaAsignacion", asignacion.FechaAsignacion == default(DateTime) ? (object)DBNull.Value : asignacion.FechaAsignacion);
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
            cmd.Parameters.AddWithValue("@FechaAsignacion", asignacion.FechaAsignacion == default(DateTime) ? (object)DBNull.Value : asignacion.FechaAsignacion);
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
