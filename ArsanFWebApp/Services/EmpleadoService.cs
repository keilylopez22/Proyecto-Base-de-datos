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

        // Obtener filtrado y paginado
        public async Task<(List<Empleado> Items, int TotalCount)> ObtenerFiltradoPaginadoAsync(
            string? primerNombre, string? primerApellido, int? idPuesto, int? idEmpleado, int pagina = 1, int pageSize = 10)
        {
            var items = new List<Empleado>();
            using var con = new SqlConnection(_connectionString);
            await con.OpenAsync();

            var whereClauses = new List<string>();
            if (idEmpleado.HasValue) whereClauses.Add("e.IdEmpleado = @IdEmpleado");
            if (!string.IsNullOrWhiteSpace(primerNombre)) whereClauses.Add("p.PrimerNombre LIKE @PrimerNombre + '%'");
            if (!string.IsNullOrWhiteSpace(primerApellido)) whereClauses.Add("p.PrimerApellido LIKE @PrimerApellido + '%'");
            if (idPuesto.HasValue) whereClauses.Add("e.IdPuestoEmpleado = @IdPuesto");

            var whereSql = whereClauses.Count > 0 ? "WHERE " + string.Join(" AND ", whereClauses) : "";

            // Contar total
            var countSql = $@"SELECT COUNT(*) FROM Empleado e INNER JOIN Persona p ON e.IdPersona = p.IdPersona {whereSql};";
            using var countCmd = new SqlCommand(countSql, con);
            if (idEmpleado.HasValue) countCmd.Parameters.AddWithValue("@IdEmpleado", idEmpleado.Value);
            if (!string.IsNullOrWhiteSpace(primerNombre)) countCmd.Parameters.AddWithValue("@PrimerNombre", primerNombre);
            if (!string.IsNullOrWhiteSpace(primerApellido)) countCmd.Parameters.AddWithValue("@PrimerApellido", primerApellido);
            if (idPuesto.HasValue) countCmd.Parameters.AddWithValue("@IdPuesto", idPuesto.Value);

            var total = Convert.ToInt32(await countCmd.ExecuteScalarAsync());

            // Datos con paginación
            var offset = (pagina - 1) * pageSize;
            var sql = $@"
                SELECT e.IdEmpleado, e.FechaAlta, e.FechaBaja, e.Estado, e.IdPersona, e.IdPuestoEmpleado,
                       p.PrimerNombre + ' ' + p.PrimerApellido AS NombreCompleto
                FROM Empleado e
                INNER JOIN Persona p ON e.IdPersona = p.IdPersona
                {whereSql}
                ORDER BY e.IdEmpleado
                OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;";

            using var cmd = new SqlCommand(sql, con);
            if (idEmpleado.HasValue) cmd.Parameters.AddWithValue("@IdEmpleado", idEmpleado.Value);
            if (!string.IsNullOrWhiteSpace(primerNombre)) cmd.Parameters.AddWithValue("@PrimerNombre", primerNombre);
            if (!string.IsNullOrWhiteSpace(primerApellido)) cmd.Parameters.AddWithValue("@PrimerApellido", primerApellido);
            if (idPuesto.HasValue) cmd.Parameters.AddWithValue("@IdPuesto", idPuesto.Value);
            cmd.Parameters.AddWithValue("@Offset", offset);
            cmd.Parameters.AddWithValue("@PageSize", pageSize);

            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
                items.Add(MapEmpleado(reader));

            return (items, total);
        }

        // Buscar por ID
        public Empleado? BuscarPorId(int idEmpleado)
        {
            using var con = new SqlConnection(_connectionString);
            con.Open();

            string sql = @"
                SELECT e.IdEmpleado, e.FechaAlta, e.FechaBaja, e.Estado, e.IdPersona, e.IdPuestoEmpleado,
                       p.PrimerNombre + ' ' + p.PrimerApellido AS NombreCompleto
                FROM Empleado e
                INNER JOIN Persona p ON e.IdPersona = p.IdPersona
                WHERE e.IdEmpleado = @IdEmpleado";

            using var cmd = new SqlCommand(sql, con);
            cmd.Parameters.AddWithValue("@IdEmpleado", idEmpleado);

            using var dr = cmd.ExecuteReader();
            if (dr.Read()) return MapEmpleado(dr);
            return null;
        }

        // Insertar
        public void Insertar(Empleado empleado)
        {
            using var con = new SqlConnection(_connectionString);
            con.Open();

            string sql = @"
                INSERT INTO Empleado (FechaAlta, FechaBaja, Estado, IdPersona, IdPuestoEmpleado)
                VALUES (@FechaAlta, @FechaBaja, @Estado, @IdPersona, @IdPuestoEmpleado);";

            using var cmd = new SqlCommand(sql, con);
            cmd.Parameters.AddWithValue("@FechaAlta", empleado.FechaAlta.HasValue ? empleado.FechaAlta.Value.ToDateTime(TimeOnly.MinValue) : (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@FechaBaja", empleado.FechaBaja.HasValue ? empleado.FechaBaja.Value.ToDateTime(TimeOnly.MinValue) : (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@Estado", empleado.Estado ?? "");
            cmd.Parameters.AddWithValue("@IdPersona", empleado.IdPersona);
            cmd.Parameters.AddWithValue("@IdPuestoEmpleado", empleado.IdPuestoEmpleado);

            cmd.ExecuteNonQuery();
        }

        // Actualizar
        public void Actualizar(Empleado empleado)
        {
            using var con = new SqlConnection(_connectionString);
            con.Open();

            string sql = @"
                UPDATE Empleado
                SET FechaAlta=@FechaAlta, FechaBaja=@FechaBaja, Estado=@Estado,
                    IdPersona=@IdPersona, IdPuestoEmpleado=@IdPuestoEmpleado
                WHERE IdEmpleado=@IdEmpleado";

            using var cmd = new SqlCommand(sql, con);
            cmd.Parameters.AddWithValue("@IdEmpleado", empleado.IdEmpleado);
            cmd.Parameters.AddWithValue("@FechaAlta", empleado.FechaAlta.HasValue ? empleado.FechaAlta.Value.ToDateTime(TimeOnly.MinValue) : (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@FechaBaja", empleado.FechaBaja.HasValue ? empleado.FechaBaja.Value.ToDateTime(TimeOnly.MinValue) : (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@Estado", empleado.Estado ?? "");
            cmd.Parameters.AddWithValue("@IdPersona", empleado.IdPersona);
            cmd.Parameters.AddWithValue("@IdPuestoEmpleado", empleado.IdPuestoEmpleado);

            cmd.ExecuteNonQuery();
        }

        // Eliminar
        public void Eliminar(int idEmpleado)
        {
            using var con = new SqlConnection(_connectionString);
            con.Open();

            string sql = "DELETE FROM Empleado WHERE IdEmpleado=@IdEmpleado";
            using var cmd = new SqlCommand(sql, con);
            cmd.Parameters.AddWithValue("@IdEmpleado", idEmpleado);
            cmd.ExecuteNonQuery();
        }

        // Validar si puesto está ocupado
        public async Task<bool> EstaPuestoOcupadoAsync(int idPuestoEmpleado, int? excluirIdEmpleado = null)
        {
            using var con = new SqlConnection(_connectionString);
            await con.OpenAsync();

            var sql = "SELECT COUNT(1) FROM Empleado WHERE IdPuestoEmpleado = @IdPuesto" +
                      (excluirIdEmpleado.HasValue ? " AND IdEmpleado <> @IdEmpleado" : "");

            using var cmd = new SqlCommand(sql, con);
            cmd.Parameters.AddWithValue("@IdPuesto", idPuestoEmpleado);
            if (excluirIdEmpleado.HasValue) cmd.Parameters.AddWithValue("@IdEmpleado", excluirIdEmpleado.Value);

            var count = Convert.ToInt32(await cmd.ExecuteScalarAsync());
            return count > 0;
        }
    }
}
