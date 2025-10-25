using ArsanWebApp.Models;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;

namespace ArsanWebApp.Services
{
    public class CobroServicioViviendaService
    {
        private readonly string _connectionString;

        public CobroServicioViviendaService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("SqlServerConnection") 
                ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
        }

        public async Task<(List<CobroServicioVivienda>, int)> ListarAsync(
            int pageIndex, int pageSize,
            string fechaFilter, string servicioFilter,
            int? numeroViviendaFilter, int? clusterFilter)
        {
            var lista = new List<CobroServicioVivienda>();
            int totalCount = 0;

            try
            {
                using var conn = new SqlConnection(_connectionString);
                using var cmd = new SqlCommand("SP_SelectAllCobroServicioVivienda", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };

                cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
                cmd.Parameters.AddWithValue("@PageSize", pageSize);
                cmd.Parameters.AddWithValue("@FechaCobroFilter", string.IsNullOrEmpty(fechaFilter) ? (object)DBNull.Value : DateTime.Parse(fechaFilter));
                cmd.Parameters.AddWithValue("@ServicioFilter", string.IsNullOrEmpty(servicioFilter) ? (object)DBNull.Value : servicioFilter);
                cmd.Parameters.AddWithValue("@NumeroViviendaFilter", numeroViviendaFilter ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@ClusterFilter", clusterFilter ?? (object)DBNull.Value);

                await conn.OpenAsync();
                using var reader = await cmd.ExecuteReaderAsync();

                while (await reader.ReadAsync())
                {
                    lista.Add(new CobroServicioVivienda
                    {
                        IdCobroServicio = Convert.ToInt32(reader["idCobroServicio"]),
                        FechaCobro = reader["FechaCobro"] == DBNull.Value ? null : DateOnly.FromDateTime(Convert.ToDateTime(reader["FechaCobro"])),
                        Monto = reader["Monto"] == DBNull.Value ? null : Convert.ToDecimal(reader["Monto"]),
                        MontoAplicado = reader["MontoAplicado"] == DBNull.Value ? null : Convert.ToDecimal(reader["MontoAplicado"]),
                        EstadoPago = reader["EstadoPago"] as string,
                        IdServicio = Convert.ToInt32(reader["IdServicio"]),
                        NombreServicio = reader["NombreServicio"] as string,
                        NumeroVivienda = Convert.ToInt32(reader["NumeroVivienda"]),
                        IdCluster = Convert.ToInt32(reader["IdCluster"]),
                        NombreCluster = reader["NombreCluster"] as string
                    });
                }

                if (await reader.NextResultAsync() && await reader.ReadAsync())
                {
                    totalCount = Convert.ToInt32(reader["TotalCount"]);
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error en ListarAsync: {ex.Message}", ex);
            }

            return (lista, totalCount);
        }

        public async Task<CobroServicioVivienda?> ObtenerPorIdAsync(int id)
        {
            try
            {
                using var conn = new SqlConnection(_connectionString);
                using var cmd = new SqlCommand("SP_BuscarCobroServicioPorViviendaPorId", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@idCobroServicio", id);

                await conn.OpenAsync();
                using var reader = await cmd.ExecuteReaderAsync();

                if (await reader.ReadAsync())
                {
                    return new CobroServicioVivienda
                    {
                        IdCobroServicio = Convert.ToInt32(reader["idCobroServicio"]),
                        FechaCobro = reader["FechaCobro"] == DBNull.Value ? null : DateOnly.FromDateTime(Convert.ToDateTime(reader["FechaCobro"])),
                        Monto = reader["Monto"] == DBNull.Value ? null : Convert.ToDecimal(reader["Monto"]),
                        MontoAplicado = reader["MontoAplicado"] == DBNull.Value ? null : Convert.ToDecimal(reader["MontoAplicado"]),
                        EstadoPago = reader["EstadoPago"] as string,
                        IdServicio = Convert.ToInt32(reader["IdServicio"]),
                        NumeroVivienda = Convert.ToInt32(reader["NumeroVivienda"]),
                        IdCluster = Convert.ToInt32(reader["IdCluster"])
                    };
                }

                return null;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error en ObtenerPorIdAsync: {ex.Message}", ex);
            }
        }

        public async Task InsertarAsync(CobroServicioVivienda c)
        {
            try
            {
                using var conn = new SqlConnection(_connectionString);
                using var cmd = new SqlCommand("SP_InsertarCobroServicioVivienda", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };

                cmd.Parameters.AddWithValue("@FechaCobro", c.FechaCobro.HasValue ? c.FechaCobro.Value.ToDateTime(TimeOnly.MinValue) : (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@Monto", c.Monto ?? 0);
                cmd.Parameters.AddWithValue("@MontoAplicado", c.MontoAplicado ?? 0);
                cmd.Parameters.AddWithValue("@EstadoPago", string.IsNullOrEmpty(c.EstadoPago) ? (object)DBNull.Value : c.EstadoPago);
                cmd.Parameters.AddWithValue("@IdServicio", c.IdServicio);
                cmd.Parameters.AddWithValue("@NumeroVivienda", c.NumeroVivienda);
                cmd.Parameters.AddWithValue("@IdCluster", c.IdCluster);

                await conn.OpenAsync();
                await cmd.ExecuteNonQueryAsync();
            }
            catch (Exception ex)
            {
                throw new Exception($"Error en InsertarAsync: {ex.Message}", ex);
            }
        }

        public async Task ActualizarAsync(CobroServicioVivienda c)
        {
            try
            {
                using var conn = new SqlConnection(_connectionString);
                using var cmd = new SqlCommand("SP_ActualizarCobroServicioVivienda", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };

                cmd.Parameters.AddWithValue("@idCobroServicio", c.IdCobroServicio);
                cmd.Parameters.AddWithValue("@FechaCobro", c.FechaCobro.HasValue ? c.FechaCobro.Value.ToDateTime(TimeOnly.MinValue) : (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@Monto", c.Monto ?? 0);
                cmd.Parameters.AddWithValue("@MontoAplicado", c.MontoAplicado ?? 0);
                cmd.Parameters.AddWithValue("@EstadoPago", string.IsNullOrEmpty(c.EstadoPago) ? (object)DBNull.Value : c.EstadoPago);
                cmd.Parameters.AddWithValue("@IdServicio", c.IdServicio);
                cmd.Parameters.AddWithValue("@NumeroVivienda", c.NumeroVivienda);
                cmd.Parameters.AddWithValue("@IdCluster", c.IdCluster);

                await conn.OpenAsync();
                await cmd.ExecuteNonQueryAsync();
            }
            catch (Exception ex)
            {
                throw new Exception($"Error en ActualizarAsync: {ex.Message}", ex);
            }
        }

        public async Task EliminarAsync(int id)
        {
            try
            {
                using var conn = new SqlConnection(_connectionString);
                using var cmd = new SqlCommand("SP_EliminarCobroServicioVivienda", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@idCobroServicioVivienda", id);

                await conn.OpenAsync();
                await cmd.ExecuteNonQueryAsync();
            }
            catch (Exception ex)
            {
                throw new Exception($"Error en EliminarAsync: {ex.Message}", ex);
            }
        }
    }
}
