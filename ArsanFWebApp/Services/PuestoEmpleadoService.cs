using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services
{
    public class PuestoEmpleadoService
    {
        private readonly string _connectionString;

        public PuestoEmpleadoService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("SqlServerConnection")
                ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
        }

        public async Task<List<PuestoEmpleado>> ListarTodosAsync()
        {
            var lista = new List<PuestoEmpleado>();
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            using var cmd = new SqlCommand("SP_ListarTodosPuestosEmpleados", conn)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                lista.Add(new PuestoEmpleado
                {
                    IdPuestoEmpleado = Convert.ToInt32(reader["IdPuestoEmpleado"]),
                    Nombre = reader["Nombre"] as string ?? string.Empty,
                    Descripcion = reader["Descripcion"] as string
                });
            }

            return lista;
        }

        public async Task<PuestoEmpleado?> ObtenerPorIdAsync(int id)
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            using var cmd = new SqlCommand("SP_ObtenerPuestoEmpleadoPorId", conn)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@IdPuestoEmpleado", id);

            using var reader = await cmd.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                return new PuestoEmpleado
                {
                    IdPuestoEmpleado = Convert.ToInt32(reader["IdPuestoEmpleado"]),
                    Nombre = reader["Nombre"] as string ?? string.Empty,
                    Descripcion = reader["Descripcion"] as string
                };
            }

            return null;
        }

        public async Task<(bool Exito, string Mensaje)> InsertarAsync(PuestoEmpleado puesto)
        {
            try
            {
                using var conn = new SqlConnection(_connectionString);
                await conn.OpenAsync();

                using var cmd = new SqlCommand("SP_CrearPuestoEmpleado", conn)
                {
                    CommandType = System.Data.CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@Nombre", puesto.Nombre);
                cmd.Parameters.AddWithValue("@Descripcion", puesto.Descripcion ?? string.Empty);

                await cmd.ExecuteNonQueryAsync();
                return (true, "Puesto insertado correctamente.");
            }
            catch (SqlException ex)
            {
                return (false, ex.Message);
            }
        }

        public async Task<(bool Exito, string Mensaje)> ActualizarAsync(PuestoEmpleado puesto)
        {
            try
            {
                using var conn = new SqlConnection(_connectionString);
                await conn.OpenAsync();

                using var cmd = new SqlCommand("SP_ActualizarPuestoEmpleado", conn)
                {
                    CommandType = System.Data.CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@IdPuestoEmpleado", puesto.IdPuestoEmpleado);
                cmd.Parameters.AddWithValue("@Nombre", puesto.Nombre);
                cmd.Parameters.AddWithValue("@Descripcion", puesto.Descripcion ?? string.Empty);

                await cmd.ExecuteNonQueryAsync();
                return (true, "Puesto actualizado correctamente.");
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

                using var cmd = new SqlCommand("SP_EliminarPuestoEmpleado", conn)
                {
                    CommandType = System.Data.CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@IdPuestoEmpleado", id);

                await cmd.ExecuteNonQueryAsync();
                return (true, "Puesto eliminado correctamente.");
            }
            catch (SqlException ex)
            {
                return (false, ex.Message);
            }
        }
    }
}
