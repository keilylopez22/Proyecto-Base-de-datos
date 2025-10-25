using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services
{
    public class ServicioService
    {
        private readonly string _connectionString;

        public ServicioService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("SqlServerConnection")
                ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
        }

   
        public async Task InsertarAsync(Servicio servicio)
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            using var cmd = new SqlCommand("SP_InsertarServicio", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@Nombre", servicio.Nombre);
            cmd.Parameters.AddWithValue("@Tarifa", servicio.Tarifa);

            await cmd.ExecuteNonQueryAsync();
        }

        public async Task<Servicio?> BuscarPorIdAsync(int id)
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            using var cmd = new SqlCommand("SP_BuscarServicioId", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IdServicio", id);

            using var reader = await cmd.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                return new Servicio
                {
                    IdServicio = Convert.ToInt32(reader["IdServicio"]),
                    Nombre = reader["Nombre"].ToString() ?? string.Empty,
                    Tarifa = Convert.ToDecimal(reader["Tarifa"])
                };
            }
            return null;
        }

        public async Task<List<Servicio>> ObtenerTodosAsync()
        {
            var lista = new List<Servicio>();
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            using var cmd = new SqlCommand("SELECT IdServicio, Nombre, Tarifa FROM Servicio", conn);
            using var reader = await cmd.ExecuteReaderAsync();

            while (await reader.ReadAsync())
            {
                lista.Add(new Servicio
                {
                    IdServicio = Convert.ToInt32(reader["IdServicio"]),
                    Nombre = reader["Nombre"].ToString() ?? string.Empty,
                    Tarifa = Convert.ToDecimal(reader["Tarifa"])
                });
            }

            return lista;
        }

   
        public async Task<bool> ActualizarAsync(Servicio servicio)
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            using var cmd = new SqlCommand("SP_ActualizarServicio", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@IdServicio", servicio.IdServicio);
            cmd.Parameters.AddWithValue("@Nombre", servicio.Nombre);
            cmd.Parameters.AddWithValue("@Tarifa", servicio.Tarifa);

            var result = await cmd.ExecuteNonQueryAsync();
            return result > 0;
        }
        public async Task<bool> EliminarAsync(int id)
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            using var cmd = new SqlCommand("SP_EliminarServicio", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IdServicio", id);

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
        public async Task<List<Servicio>> ListarServicioAsync()
        {
            var lista = new List<Servicio>();
            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("SELECT IdServicio, Nombre FROM Servicio", conn);
            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                lista.Add(new Servicio
                {
                    IdServicio = Convert.ToInt32(reader[ "IdServicio"]),
                    Nombre = reader["Nombre"] as string
                });
            }
            return lista;
        }

        public async Task<List<Vivienda>> ListarviviendaAsync()
        {
            var lista = new List<Vivienda>();
            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("SELECT NumeroVivienda, IdCluster, IdTipoVivienda, IdPropietario FROM Vivienda", conn);
            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                lista.Add(new Vivienda
                {
                    NumeroVivienda = Convert.ToInt32("NumeroVivienda"),
                    IdCluster = Convert.ToInt32("IdCluster"),
                    IdTipoVivienda = Convert.ToInt32("IdTipoVivienda"),
                    IdPropietario = Convert.ToInt32("IdPropietario")
                });
            }
            return lista;
        }
    }
}
