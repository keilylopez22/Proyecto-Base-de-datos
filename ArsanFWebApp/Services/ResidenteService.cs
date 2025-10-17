using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services
{
    public class ResidenteService
    {
        private readonly string _connectionString;

        public ResidenteService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("SqlServerConnection")
                ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
        }
        

        public async Task<List<ResidenteCompleto>> ObtenerResidentesAsync()
        {
            var residentes = new List<ResidenteCompleto>();
            Console.WriteLine("Conexión a la base de datos con cadena: " + _connectionString);
            using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();

            using var command = new SqlCommand("SP_ObtenerResidentes", connection);
            command.CommandType = System.Data.CommandType.StoredProcedure;

            using var reader = await command.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                var residente = new ResidenteCompleto
                {
                    IdResidente = reader.GetInt32(reader.GetOrdinal("IdResidente")),
                    IdPersona = reader.GetInt32(reader.GetOrdinal("IdPersona")),
                    NumeroVivienda = reader.GetInt32(reader.GetOrdinal("NumeroVivienda")),
                    IdCluster = reader.GetInt32(reader.GetOrdinal("IdCluster")),
                    EsInquilino = reader.GetBoolean(reader.GetOrdinal("EsInquilino")),
                    Estado = reader.IsDBNull(reader.GetOrdinal("Estado")) ? null : reader.GetString(reader.GetOrdinal("Estado")),

                    PrimerNombre = reader.GetString(reader.GetOrdinal("PrimerNombre")),
                    SegundoNombre = reader.IsDBNull(reader.GetOrdinal("SegundoNombre")) ? null : reader.GetString(reader.GetOrdinal("SegundoNombre")),
                    PrimerApellido = reader.GetString(reader.GetOrdinal("PrimerApellido")),
                    SegundoApellido = reader.IsDBNull(reader.GetOrdinal("SegundoApellido")) ? null : reader.GetString(reader.GetOrdinal("SegundoApellido")),

                    ClusterDescripcion = reader.GetString(reader.GetOrdinal("ClusterDescripcion"))
                };

                residentes.Add(residente);
            }

            return residentes;
        }
    }
}