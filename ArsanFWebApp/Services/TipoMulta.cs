using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services
{
    public class TipoMultaService
    {
        private readonly string _connectionString;

        public TipoMultaService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("SqlServerConnection")
                ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
        }

        public async Task<int> InsertarAsync(TipoMulta tipoMulta)
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("SP_InsertarTipoMulta", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@Nombre", tipoMulta.Nombre ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@Monto", tipoMulta.Monto ?? (object)DBNull.Value);

            var result = await cmd.ExecuteScalarAsync();
            return Convert.ToInt32(result);
        }

          public async Task<TipoMulta?> BuscarPorIdAsync(int id)
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("SP_BuscarTipoMultaPorID", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IdTipoMulta", id);

            using var reader = await cmd.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                return new TipoMulta
                {
                    IdTipoMulta = Convert.ToInt32(reader["IdTipoMulta"]),
                    Nombre = reader["Nombre"].ToString(),
                    Monto = reader["Monto"] == DBNull.Value ? null : (decimal?)reader["Monto"]
                };
            }
            return null;
        }

  
        public async Task<List<TipoMulta>> ObtenerTodosAsync()
        {
            var lista = new List<TipoMulta>();
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("SELECT * FROM TipoMulta", conn);
            using var reader = await cmd.ExecuteReaderAsync();

            while (await reader.ReadAsync())
            {
                lista.Add(new TipoMulta
                {
                    IdTipoMulta = Convert.ToInt32(reader["IdTipoMulta"]),
                    Nombre = reader["Nombre"].ToString(),
                    Monto = reader["Monto"] == DBNull.Value ? null : (decimal?)reader["Monto"]
                });
            }
            return lista;
        }

     
        public async Task<bool> ActualizarAsync(TipoMulta tipoMulta)
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("SP_ActualizarTipoMulta", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@IdTipoMulta", tipoMulta.IdTipoMulta);
            cmd.Parameters.AddWithValue("@Nombre", tipoMulta.Nombre ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@Monto", tipoMulta.Monto ?? (object)DBNull.Value);

            var result = await cmd.ExecuteNonQueryAsync();
            return result > 0;
        }

        public async Task<bool> EliminarAsync(int id)
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("SP_EliminarTipoMulta", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IdTipoMulta", id);

            try
            {
                await cmd.ExecuteNonQueryAsync();
                return true;
            }
            catch (SqlException)
            {
                return false;
            }
        }

        public async Task<List<TipoMulta>> ListarAsync()
        {
            var lista = new List<TipoMulta>();

            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("SELECT IdTipoMulta, Nombre FROM TipoMulta", conn);
            await conn.OpenAsync();

            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                lista.Add(new TipoMulta
                {
                    IdTipoMulta = reader.GetInt32(reader.GetOrdinal("IdTipoMulta")),
                    Nombre = reader["Nombre"] as string
                });
            }

            return lista;
        }
    }
}
