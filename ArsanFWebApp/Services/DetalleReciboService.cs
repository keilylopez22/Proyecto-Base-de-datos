using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services
{
    public class DetalleReciboService
    {
        private readonly string _connectionString;

        public DetalleReciboService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("SqlServerConnection")
                ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
        }

        public List<DetalleRecibo> BuscarPorIdRecibo(int idRecibo)
        {
            var lista = new List<DetalleRecibo>();

            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("SP_SelectAllDetalleRecibo", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IdReciboFilter", idRecibo);

            conn.Open();
            using var reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                // Manejo seguro para int
                int numeroVivienda = reader["NumeroVivienda"] != DBNull.Value 
                                    ? Convert.ToInt32(reader["NumeroVivienda"]) 
                                    : 0; 

                lista.Add(new DetalleRecibo
                {
                    IdDetalleRecibo = Convert.ToInt32(reader["IdDetalleRecibo"]),
                    IdRecibo = Convert.ToInt32(reader["IdRecibo"]),
                    NombreServicio = reader["Concepto"]?.ToString(),
                    MontoServicio = reader["MontoAplicado"] != DBNull.Value ? Convert.ToDecimal(reader["MontoAplicado"]) : (decimal?)null,
                    NumeroVivienda = numeroVivienda,
                    NombrePropietario = reader["NombreCompleto"]?.ToString(),
                    NombreCluster = reader["NombreCluster"]?.ToString()
                });
            }

            return lista;
        }

    }
}
