using System.Data;
using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;
using Microsoft.Extensions.Configuration;

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

        public async Task<(List<DocumentoPersona> Items, int TotalCount)> ObtenerYContarAsync(int pagina, int registrosPorPagina, int? numeroDocumento, int? idTipoDocumento)
        {
            var lista = new List<DocumentoPersona>();
            int totalCount = 0;

            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("SP_SelectAllDocumentoPersona", conn) 
            {
                CommandType = CommandType.StoredProcedure
            };
            
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
            
            if (await reader.NextResultAsync())
            {
                if (await reader.ReadAsync())
                {
                    totalCount = reader["TotalCount"] != DBNull.Value ? (int)reader["TotalCount"] : 0;
                }
            }

            return (lista, totalCount);
        }
        
    
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
                 cmd.Parameters.AddWithValue("@Observaciones", (object?)doc.Observaciones ?? DBNull.Value);

                 await conn.OpenAsync();
                 await cmd.ExecuteNonQueryAsync();
                 return null;
             }
             catch (SqlException ex)
             {
                 return ex.Message;
             }
        }

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
                 cmd.Parameters.AddWithValue("@Observaciones", (object?)doc.Observaciones ?? DBNull.Value);

                 await conn.OpenAsync();
                 await cmd.ExecuteNonQueryAsync();
                 return null;
             }
             catch (SqlException ex)
             {
                 return ex.Message;
             }
        }

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