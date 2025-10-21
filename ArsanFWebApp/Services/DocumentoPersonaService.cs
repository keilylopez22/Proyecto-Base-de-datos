using System.Data;
using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;

namespace ArsanWebApp.Services
{
    public class DocumentoPersonaService
    {
        private readonly string _connectionString;

        public DocumentoPersonaService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("SqlServerConnection")
                ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
        }

        // Obtener documentos con paginación y búsqueda
        public async Task<List<DocumentoPersona>> ObtenerAsync(int pagina, int registrosPorPagina, int? numeroDocumento, int? idTipoDocumento)
        {
            var lista = new List<DocumentoPersona>();

            using var conn = new SqlConnection(_connectionString);
            var query = @"
                SELECT dp.NumeroDocumento, dp.IdTipoDocumento, dp.IdPersona, dp.Observaciones,
                       td.Nombre AS TipoDocumentoNombre,
                       CONCAT(p.PrimerNombre, ' ', p.PrimerApellido) AS NombrePersona
                FROM DocumentoPersona dp
                INNER JOIN TipoDocumento td ON dp.IdTipoDocumento = td.IdTipoDocumento
                INNER JOIN Persona p ON dp.IdPersona = p.IdPersona
                WHERE (@NumeroDocumento IS NULL OR dp.NumeroDocumento = @NumeroDocumento)
                  AND (@IdTipoDocumento IS NULL OR dp.IdTipoDocumento = @IdTipoDocumento)
                ORDER BY dp.IdPersona
                OFFSET @Offset ROWS FETCH NEXT @Limit ROWS ONLY;";

            using var cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@Offset", (pagina - 1) * registrosPorPagina);
            cmd.Parameters.AddWithValue("@Limit", registrosPorPagina);
            cmd.Parameters.AddWithValue("@NumeroDocumento", (object?)numeroDocumento ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@IdTipoDocumento", (object?)idTipoDocumento ?? DBNull.Value);

            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();

            while (await reader.ReadAsync())
            {
                lista.Add(new DocumentoPersona
                {
                    NumeroDocumento = reader.GetInt32(reader.GetOrdinal("NumeroDocumento")),
                    IdTipoDocumento = reader.GetInt32(reader.GetOrdinal("IdTipoDocumento")),
                    IdPersona = reader.GetInt32(reader.GetOrdinal("IdPersona")),
                    Observaciones = reader["Observaciones"] as string,
                    TipoDocumentoNombre = reader["TipoDocumentoNombre"] as string,
                    NombrePersona = reader["NombrePersona"] as string
                });
            }

            return lista;
        }

        // Contar documentos (para paginación)
        public async Task<int> ContarAsync(int? numeroDocumento, int? idTipoDocumento)
        {
            using var conn = new SqlConnection(_connectionString);
            var query = @"SELECT COUNT(*) FROM DocumentoPersona dp
                          WHERE (@NumeroDocumento IS NULL OR dp.NumeroDocumento = @NumeroDocumento)
                            AND (@IdTipoDocumento IS NULL OR dp.IdTipoDocumento = @IdTipoDocumento)";
            using var cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@NumeroDocumento", (object?)numeroDocumento ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@IdTipoDocumento", (object?)idTipoDocumento ?? DBNull.Value);

            await conn.OpenAsync();
            return (int)await cmd.ExecuteScalarAsync();
        }

        // Buscar por ID
        public async Task<DocumentoPersona?> BuscarPorIdAsync(int idTipoDocumento, int idPersona)
        {
            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("SP_BuscarDocumentoPersonaPorId", conn)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@IdTipoDocumento", idTipoDocumento);
            cmd.Parameters.AddWithValue("@IdPersona", idPersona);

            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();

            if (await reader.ReadAsync())
            {
                return new DocumentoPersona
                {
                    NumeroDocumento = reader.GetInt32(reader.GetOrdinal("NumeroDocumento")),
                    IdTipoDocumento = idTipoDocumento,
                    IdPersona = idPersona,
                    Observaciones = reader["Observaciones"] as string,
                    TipoDocumentoNombre = reader["TipoDocumento"] as string,
                    NombrePersona = reader["Persona"] as string
                };
            }
            return null;
        }

        // Crear documento (usa SP)
        public async Task<string?> CrearAsync(DocumentoPersona doc)
        {
            try
            {
                using var conn = new SqlConnection(_connectionString);
                using var cmd = new SqlCommand("SP_InsertarDocumentoPersona", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };

                cmd.Parameters.AddWithValue("@NumeroDocumento", doc.NumeroDocumento);
                cmd.Parameters.AddWithValue("@IdTipoDocumento", doc.IdTipoDocumento);
                cmd.Parameters.AddWithValue("@IdPersona", doc.IdPersona);
                cmd.Parameters.AddWithValue("@Observaciones", doc.Observaciones ?? (object)DBNull.Value);

                await conn.OpenAsync();
                await cmd.ExecuteNonQueryAsync();
                return null;
            }
            catch (SqlException ex)
            {
                return ex.Message;
            }
        }

        // Actualizar documento
        public async Task<string?> ActualizarAsync(DocumentoPersona doc)
        {
            try
            {
                using var conn = new SqlConnection(_connectionString);
                using var cmd = new SqlCommand("SP_ActualizarDocumentoPersona", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@IdTipoDocumento", doc.IdTipoDocumento);
                cmd.Parameters.AddWithValue("@IdPersona", doc.IdPersona);
                cmd.Parameters.AddWithValue("@NumeroDocumento", doc.NumeroDocumento);
                cmd.Parameters.AddWithValue("@Observaciones", doc.Observaciones ?? (object)DBNull.Value);

                await conn.OpenAsync();
                await cmd.ExecuteNonQueryAsync();
                return null;
            }
            catch (SqlException ex)
            {
                return ex.Message;
            }
        }

        // Eliminar documento
        public async Task<string?> EliminarAsync(int idTipoDocumento, int idPersona)
        {
            try
            {
                using var conn = new SqlConnection(_connectionString);
                using var cmd = new SqlCommand("SP_EliminarDocumentoPersona", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@IdTipoDocumento", idTipoDocumento);
                cmd.Parameters.AddWithValue("@IdPersona", idPersona);

                await conn.OpenAsync();
                await cmd.ExecuteNonQueryAsync();
                return null;
            }
            catch (SqlException ex)
            {
                return ex.Message;
            }
        }
    }
}
