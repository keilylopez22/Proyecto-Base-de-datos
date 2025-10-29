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
    // Verifica que existan
    IdPersona = HasColumn(dr, "IdPersona") ? Convert.ToInt32(dr["IdPersona"]) : 0,
    IdPuestoEmpleado = HasColumn(dr, "IdPuestoEmpleado") ? Convert.ToInt32(dr["IdPuestoEmpleado"]) : 0,

                NombreCompleto = HasColumn(dr, "NombreCompleto") ? dr["NombreCompleto"]?.ToString() : null
            };
        }

        // --- Método Paginado Corregido (Sincronizado con SP) ---
        public async Task<(List<Empleado> Items, int TotalCount)> ObtenerFiltradoPaginadoAsync(
            string? primerNombre, string? primerApellido, int? idPuesto, int? idEmpleado, int pagina = 1, int pageSize = 10)
        {
            var items = new List<Empleado>();
            int total = 0;

            // 1. Lógica para CONCATENAR NOMBRES (para @NombreEmpleadoFilter)
            string nombreCompletoFilter = null;
            if (!string.IsNullOrWhiteSpace(primerNombre) || !string.IsNullOrWhiteSpace(primerApellido))
            {
                nombreCompletoFilter = $"{primerNombre?.Trim()} {primerApellido?.Trim()}".Trim();
            }
            
            // 2. Lógica para FILTRO DE PUESTO (temporalmente se ignora el ID, ya que el SP espera el NOMBRE)
            // Se envía DBNull.Value para evitar errores.
            object puestoFilterValue = DBNull.Value; 

            using var con = new SqlConnection(_connectionString);
            // ¡ATENCIÓN!: Usando el nombre SP_SelectAllDeLosEmpleado
            using var cmd = new SqlCommand("SP_SelectAllDeLosEmpleado", con) 
            {
                CommandType = CommandType.StoredProcedure
            };

            // *** ENVÍO EXACTO DE 7 PARÁMETROS ***
            // Paginación (2)
            cmd.Parameters.AddWithValue("@PageIndex", pagina);
            cmd.Parameters.AddWithValue("@PageSize", pageSize);
            
            // Filtros de Fecha (2) - Enviados como NULL si no se usan
            cmd.Parameters.AddWithValue("@FechaAltaFilter", DBNull.Value);
            cmd.Parameters.AddWithValue("@FechaBajaFilter", DBNull.Value);
            cmd.Parameters.AddWithValue("@IdPuestoFilter", (object?)idPuesto ?? DBNull.Value);
            
            // Filtros de Contenido (3)
            cmd.Parameters.AddWithValue("@NombreEmpleadoFilter", string.IsNullOrEmpty(nombreCompletoFilter) ? (object)DBNull.Value : nombreCompletoFilter); 
            cmd.Parameters.AddWithValue("@PuestoFilter", puestoFilterValue); 
            cmd.Parameters.AddWithValue("@IdEmpleadoFilter", (object?)idEmpleado ?? DBNull.Value); 

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

        // --- Operaciones CRUD convertidas a Asíncronas ---

        public async Task<Empleado?> BuscarPorIdAsync(int idEmpleado)
        {
            using var con = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("SP_BuscarEmpleadoPorId", con)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@IdEmpleado", idEmpleado);

            await con.OpenAsync(); // Asíncrono
            using var dr = await cmd.ExecuteReaderAsync(); // Asíncrono
            if (await dr.ReadAsync()) // Asíncrono
            {
                return MapEmpleado(dr); 
            }
            return null;
        }

        public async Task InsertarAsync(Empleado empleado)
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

            await con.OpenAsync(); // Asíncrono
            await cmd.ExecuteNonQueryAsync(); // Asíncrono
        }
        
        public async Task ActualizarAsync(Empleado empleado)
        {
            using var con = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("SP_ActualizarLosEmpleados", con)
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
            // EmpleadoService.cs - Dentro de ActualizarAsync (SIN CAMBIOS RESPECTO AL ÚLTIMO CÓDIGO)

cmd.Parameters.AddWithValue("@IdPuestoEmpleado", empleado.IdPuestoEmpleado != 0 
                                     ? empleado.IdPuestoEmpleado 
                                     : (object)DBNull.Value); // Envía NULL solo si es 0.

            await con.OpenAsync(); // Asíncrono
            await cmd.ExecuteNonQueryAsync(); // Asíncrono
        }
        
        public async Task EliminarAsync(int idEmpleado)
        {
            using var con = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("SP_EliminarEmpleado", con)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@IdEmpleado", idEmpleado);

            await con.OpenAsync(); // Asíncrono
            await cmd.ExecuteNonQueryAsync(); // Asíncrono
        }

    }
}