using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services
{
    public class EmpleadoService
    {
        private readonly string _connectionString;

        public EmpleadoService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("SqlServerConnection") 
                ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
        }

        private static Empleado MapEmpleado(SqlDataReader dr)
        {
            static bool HasColumn(SqlDataReader r, string name)
            {
                for (int i = 0; i < r.FieldCount; i++)
                    if (string.Equals(r.GetName(i), name, StringComparison.OrdinalIgnoreCase)) return true;
                return false;
            }

            return new Empleado
            {
                IdEmpleado = HasColumn(dr, "IdEmpleado") ? Convert.ToInt32(dr["IdEmpleado"]) : 0,
                FechaAlta = HasColumn(dr, "FechaAlta") && dr["FechaAlta"] != DBNull.Value ? DateOnly.FromDateTime(Convert.ToDateTime(dr["FechaAlta"])) : null,
                FechaBaja = HasColumn(dr, "FechaBaja") && dr["FechaBaja"] != DBNull.Value ? DateOnly.FromDateTime(Convert.ToDateTime(dr["FechaBaja"])) : null,
                
                Estado = HasColumn(dr, "Estado") ? dr["Estado"]?.ToString() : null,
                IdPersona = HasColumn(dr, "IdPersona") ? Convert.ToInt32(dr["IdPersona"]) : 0,
                IdPuestoEmpleado = HasColumn(dr, "IdPuestoEmpleado") ? Convert.ToInt32(dr["IdPuestoEmpleado"]) : 0,

                NombreCompleto = HasColumn(dr, "NombreCompleto") ? dr["NombreCompleto"]?.ToString() : null
            };
        }

        public async Task<(List<Empleado> Items, int TotalCount)> ObtenerFiltradoPaginadoAsync(
            string? primerNombre, string? primerApellido, int? idPuesto, int? idEmpleado, int pagina = 1, int pageSize = 10)
        {
            var items = new List<Empleado>();
            int total = 0;

            using var con = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("SP_SelectAllEmpleado", con)
            {
                CommandType = CommandType.StoredProcedure
            };

            cmd.Parameters.AddWithValue("@PageIndex", pagina);
            cmd.Parameters.AddWithValue("@PageSize", pageSize);
            
            cmd.Parameters.AddWithValue("@IdEmpleadoFilter", (object?)idEmpleado ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@PrimerNombreFilter", string.IsNullOrWhiteSpace(primerNombre) ? (object)DBNull.Value : primerNombre);
            cmd.Parameters.AddWithValue("@PrimerApellidoFilter", string.IsNullOrWhiteSpace(primerApellido) ? (object)DBNull.Value : primerApellido);
            cmd.Parameters.AddWithValue("@IdPuestoFilter", (object?)idPuesto ?? DBNull.Value);

            await con.OpenAsync();

            using (var reader = await cmd.ExecuteReaderAsync())
            {
                while (await reader.ReadAsync())
                    items.Add(MapEmpleado(reader));
                if (await reader.NextResultAsync())
                {
                    if (await reader.ReadAsync())
                    {
                        total = reader["TotalCount"] != DBNull.Value ? Convert.ToInt32(reader["TotalCount"]) : 0;
                    }
                }
            }
            return (items, total);
        }
        public Empleado? BuscarPorId(int idEmpleado)
        {
            using var con = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("SP_BuscarEmpleadoPorId", con)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@IdEmpleado", idEmpleado);

            con.Open();
            using var dr = cmd.ExecuteReader();
            if (dr.Read()) 
            {
                return MapEmpleado(dr); 
            }
            return null;
        }

        public void Insertar(Empleado empleado)
        {
            using var con = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("SP_InsertarEmpleado", con)
            {
                CommandType = CommandType.StoredProcedure
            };
            
            cmd.Parameters.AddWithValue("@FechaAlta", empleado.FechaAlta.HasValue ? empleado.FechaAlta.Value.ToDateTime(TimeOnly.MinValue) : (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@FechaBaja", empleado.FechaBaja.HasValue ? empleado.FechaBaja.Value.ToDateTime(TimeOnly.MinValue) : (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@Estado", empleado.Estado ?? "ACTIVO"); 
            cmd.Parameters.AddWithValue("@IdPersona", empleado.IdPersona);
            cmd.Parameters.AddWithValue("@IdPuestoEmpleado", empleado.IdPuestoEmpleado);

            con.Open();
            cmd.ExecuteNonQuery();
        }
        public void Actualizar(Empleado empleado)
        {
            using var con = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("SP_ActualizarEmpleados", con)
            {
                CommandType = CommandType.StoredProcedure
            };
            
            cmd.Parameters.AddWithValue("@IdEmpleado", empleado.IdEmpleado);
            cmd.Parameters.AddWithValue("@FechaAlta", empleado.FechaAlta.HasValue 
                                   ? empleado.FechaAlta.Value.ToDateTime(TimeOnly.MinValue) : (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@FechaBaja", empleado.FechaBaja.HasValue 
                                   ? empleado.FechaBaja.Value.ToDateTime(TimeOnly.MinValue) : (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@Estado", string.IsNullOrWhiteSpace(empleado.Estado) 
                                   ? (object)DBNull.Value : empleado.Estado);
            cmd.Parameters.AddWithValue("@IdPersona", empleado.IdPersona); 
            cmd.Parameters.AddWithValue("@IdPuestoEmpleado", empleado.IdPuestoEmpleado != 0 
                                   ? empleado.IdPuestoEmpleado : (object)DBNull.Value);

            con.Open();
            cmd.ExecuteNonQuery();
        }
        public void Eliminar(int idEmpleado)
        {
            using var con = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("SP_EliminarEmpleado", con)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@IdEmpleado", idEmpleado);

            con.Open();
            cmd.ExecuteNonQuery();
        }

    }
}