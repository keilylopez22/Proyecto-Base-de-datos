using ArsanWebApp.Models;
using System.Data;
using System.Data.SqlClient;

namespace ArsanWebApp.Services
{
    public class PagoService
    {
        private readonly string _connectionString;

        public PagoService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("SqlServerConnection") 
            ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
       }


        public (List<Pago> pagos, int totalCount) GetPagos(DateTime? fechaPagoFilter, decimal? montoFilter, string nombreTipoPagoFilter, int pageIndex = 1, int pageSize = 10)
        {
            var pagos = new List<Pago>();
            int totalCount = 0;

            using (var con = new SqlConnection(_connectionString))
            using (var cmd = new SqlCommand("SP_SelectAllPago", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
                cmd.Parameters.AddWithValue("@PageSize", pageSize);
                cmd.Parameters.AddWithValue("@FechaPagoFilter", (object)fechaPagoFilter ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@MontoTotalFilter", (object)montoFilter ?? DBNull.Value);
                //cmd.Parameters.AddWithValue("@NombreTipoPagoFilter", (object)nombreTipoPagoFilter ?? DBNull.Value);

                con.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        pagos.Add(new Pago
                        {
                            IdPago = Convert.ToInt32(reader["IdPago"]),
                            FechaPago = reader["FechaPago"] != DBNull.Value ? DateOnly.FromDateTime(Convert.ToDateTime(reader["FechaPago"])) : null,
                            MontoTotal = reader["MontoTotal"] != DBNull.Value ? Convert.ToDecimal(reader["MontoTotal"]) : (decimal?)null,
                            MontoLiquidado = reader["MontoLiquidado"] != DBNull.Value ? Convert.ToDecimal(reader["MontoLiquidado"]) : (decimal?)null,
                            Saldo = reader["Saldo"] != DBNull.Value ? Convert.ToDecimal(reader["Saldo"]) : (decimal?)null,
                            //IdTipoPago = Convert.ToInt32(reader["idTipoPago"]),
                            //Referencia = reader["Referencia"]?.ToString(),
                            //NombreTipoPago = reader["NombreTipoPago"]?.ToString()
                        });
                    }

                    if (reader.NextResult() && reader.Read())
                    {
                        totalCount = Convert.ToInt32(reader["TotalCount"]);
                    }
                }
            }

            return (pagos, totalCount);
        }

        public int CrearPago(Pago pago)
        {
            using (var con = new SqlConnection(_connectionString))
            using (var cmd = new SqlCommand("SP_InsertarPago", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@FechaPago", pago.FechaPago?.ToDateTime(TimeOnly.MinValue));
                cmd.Parameters.AddWithValue("@MontoTotal", pago.MontoTotal ?? 0);
                //cmd.Parameters.AddWithValue("@idTipoPago", pago.IdTipoPago);
                //cmd.Parameters.AddWithValue("@Referencia", pago.Referencia ?? "");

                con.Open();
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        public async Task<Pago> BuscarPorIdAsync(int id)
        {
            Pago pago = null;
            using (var con = new SqlConnection(_connectionString))
            using (var cmd = new SqlCommand("SP_BuscarPagoPorID", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@IdPago", id);
                con.Open();

                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        pago = new Pago
                        {
                            IdPago = Convert.ToInt32(reader["IdPago"]),
                            FechaPago = reader["FechaPago"] != DBNull.Value ? DateOnly.FromDateTime(Convert.ToDateTime(reader["FechaPago"])) : null,
                            MontoTotal = reader["MontoTotal"] != DBNull.Value ? Convert.ToDecimal(reader["MontoTotal"]) : (decimal?)null,
                            MontoLiquidado = reader["MontoLiquidado"] != DBNull.Value ? Convert.ToDecimal(reader["MontoLiquidado"]) : (decimal?)null,
                            Saldo = reader["Saldo"] != DBNull.Value ? Convert.ToDecimal(reader["Saldo"])    : (decimal?)null,
                            //IdTipoPago = Convert.ToInt32(reader["idTipoPago"]),
                            //Referencia = reader["Referencia"]?.ToString()
                        };
                    }
                }
            }
            return pago;
        }

        public Pago GetPagoById(int id)
        {
            Pago pago = null;
            using (var con = new SqlConnection(_connectionString))
            using (var cmd = new SqlCommand("SP_BuscarPagoPorID", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@IdPago", id);
                con.Open();

                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        pago = new Pago
                        {
                            IdPago = Convert.ToInt32(reader["IdPago"]),
                            FechaPago = reader["FechaPago"] != DBNull.Value ? DateOnly.FromDateTime(Convert.ToDateTime(reader["FechaPago"])) : null,
                            MontoTotal = reader["MontoTotal"] != DBNull.Value ? Convert.ToDecimal(reader["MontoTotal"]) : (decimal?)null,
                            //IdTipoPago = Convert.ToInt32(reader["idTipoPago"]),
                            //Referencia = reader["Referencia"]?.ToString()
                        };
                    }
                }
            }
            return pago;
        }

        public void ActualizarPago(Pago pago)
        {
            using (var con = new SqlConnection(_connectionString))
            using (var cmd = new SqlCommand("SP_ActualizarPagos", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@IdPago", pago.IdPago);
                cmd.Parameters.AddWithValue("@FechaPago", pago.FechaPago?.ToDateTime(TimeOnly.MinValue));
                cmd.Parameters.AddWithValue("@MontoTotal", pago.MontoTotal ?? 0);
                //cmd.Parameters.AddWithValue("@idTipoPago", pago.IdTipoPago);
                //cmd.Parameters.AddWithValue("@Referencia", pago.Referencia ?? "");

                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public void EliminarPago(int id)
        {
            using (var con = new SqlConnection(_connectionString))
            using (var cmd = new SqlCommand("SP_EliminarPago", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@IdPago", id);

                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public List<TipoPago> GetAllTipoPago()
        {
            var list = new List<TipoPago>();
            using (var con = new SqlConnection(_connectionString))
            using (var cmd = new SqlCommand("SELECT IdTipoPago, Nombre FROM TipoPago", con))
            {
                con.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new TipoPago
                        {
                            IdTipoPago = Convert.ToInt32(reader["IdTipoPago"]),
                            Nombre = reader["Nombre"].ToString()
                        });
                    }
                }
            }
            return list;
        }
    }
}
