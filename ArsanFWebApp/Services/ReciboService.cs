using System;
using System.Collections.Generic;
using Microsoft.Data.SqlClient;
using ArsanWebApp.Models;
using Azure;

namespace ArsanWebApp.Services
{
    public class ReciboService
    {
        private readonly string _connectionString;

        public ReciboService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("SqlServerConnection")
                ?? throw new InvalidOperationException("Cadena de conexión no encontrada.");
        }

        public async Task<(List<Recibo> items, int TotalCount)> ObtenerTodos(int PageIndex, int PageSize, DateTime? FechaEmisionFilter, int? IdPagoFilter,
            int? NumeroViviendaFilter, int? ClusterFilter)
        {
            var lista = new List<Recibo>();
            int TotalCount = 0;
            using var cn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("SP_SelectAllRecibo", cn)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@PageIndex", PageIndex);
            cmd.Parameters.AddWithValue("@PageSize", PageSize);
            cmd.Parameters.AddWithValue("@FechaEmisionFilter", (Object?)FechaEmisionFilter ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@IdPagoFilter", (Object?)IdPagoFilter ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@NumeroViviendaFilter", (Object?)NumeroViviendaFilter ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@ClusterFilter", (Object?)ClusterFilter ?? DBNull.Value);

            cn.Open();
            using (var reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    lista.Add(new Recibo
                    {
                        IdRecibo = Convert.ToInt32(reader["IdRecibo"]),
                        FechaEmision = reader["FechaEmision"] != DBNull.Value ? DateOnly.FromDateTime(Convert.ToDateTime(reader["FechaEmision"])) : null,
                        IdPago = Convert.ToInt32(reader["IdPago"]),
                        NumeroVivienda = Convert.ToInt32(reader["NumeroVivienda"]),
                        IdCluster = Convert.ToInt32(reader["IdCluster"]),
                        NombreCompleto = reader["NombreCompleto"] != DBNull.Value ? reader["NombreCompleto"].ToString() : "",
                        NombreCluster = reader["NombreCluster"] != DBNull.Value ? reader["NombreCluster"].ToString() : "",
                        MontoTotal = reader["MontoTotal"] != DBNull.Value ? Convert.ToDecimal(reader["MontoTotal"]) : 0m
                    });
                }
                TotalCount = reader.NextResult() && reader.Read() ? Convert.ToInt32(reader["TotalCount"]) : 0;
            }

            return (lista, TotalCount);
        }

        public async Task<List<dynamic>> ObtenerCobrosPendientesAsync(int numeroVivienda, int idCluster)
        {
            var lista = new List<dynamic>();
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("SP_SelectAllCobroServicioVivienda", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@NumeroViviendaFilter", numeroVivienda);
            cmd.Parameters.AddWithValue("@ClusterFilter", idCluster);
            cmd.Parameters.AddWithValue("@EstadoPago", "PENDIENTE");
            cmd.Parameters.AddWithValue("@PageIndex", 1);
            cmd.Parameters.AddWithValue("@PageSize", 1000);

            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                lista.Add(new
                {
                    idCobroServicio = Convert.ToInt32(reader["idCobroServicio"]),
                    monto = Convert.ToDecimal(reader["Monto"]),
                    nombreServicio = reader["NombreServicio"] as string
                });
            }
            return lista;
        }

        public async Task<List<dynamic>> ObtenerMultasPendientesAsync(int numeroVivienda, int idCluster)
        {
            var lista = new List<dynamic>();
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("SP_SelectAllMultaVivienda", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@NumeroViviendaFilter", numeroVivienda);
            cmd.Parameters.AddWithValue("@ClusterFilter", idCluster);
            cmd.Parameters.AddWithValue("@EstadoFilter", "PENDIENTE");
            cmd.Parameters.AddWithValue("@PageIndex", 1);
            cmd.Parameters.AddWithValue("@PageSize", 1000);

            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                lista.Add(new
                {
                    idMultaVivienda = Convert.ToInt32(reader["IdMultaVivienda"]),
                    monto = Convert.ToDecimal(reader["Monto"]),
                    nombreMulta = reader["NombreTipoMulta"] as string
                });
            }
            return lista;
        }


        public Recibo ObtenerPorId(int id)
        {
            Recibo recibo = null;

            using var cn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("SP_BuscarReciboPorId", cn)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@IdRecibo", id);

            cn.Open();
            using var reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                recibo = new Recibo
                {
                    IdRecibo = Convert.ToInt32(reader["IdRecibo"]),
                    FechaEmision = reader["FechaEmision"] != DBNull.Value ? DateOnly.FromDateTime(Convert.ToDateTime(reader["FechaEmision"])) : null,
                    IdPago = Convert.ToInt32(reader["IdPago"]),
                    NumeroVivienda = Convert.ToInt32(reader["NumeroVivienda"]),
                    IdCluster = Convert.ToInt32(reader["IdCluster"]),
                    NombreCompleto = reader["NombreCompleto"] != DBNull.Value ? reader["NombreCompleto"].ToString() : "",
                    NombreCluster = reader["NombreCluster"] != DBNull.Value ? reader["NombreCluster"].ToString() : "",
                    MontoTotal = reader["MontoTotal"] != DBNull.Value ? Convert.ToDecimal(reader["MontoTotal"]) : 0m

                };
            }

            return recibo;
        }

        public string ObtenerPropietario(int numeroVivienda, int idCluster)
        {
            using var cn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("SP_ObtenerPropietarioPorViviendaYCluster", cn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@NumeroVivienda", numeroVivienda);
            cmd.Parameters.AddWithValue("@IdCluster", idCluster);

            cn.Open();
            var result = cmd.ExecuteScalar();
            return result?.ToString();
        }

        public int Insertar(Recibo r)
        {
            using (var cn = new SqlConnection(_connectionString))
            using (var cmd = new SqlCommand("SP_InsertarRecibo", cn))
            {
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@FechaEmision", r.FechaEmision.HasValue ? r.FechaEmision.Value.ToDateTime(TimeOnly.MinValue) : DBNull.Value);
                cmd.Parameters.AddWithValue("@IdPago", r.IdPago);
                cmd.Parameters.AddWithValue("@NumeroVivienda", r.NumeroVivienda);
                cmd.Parameters.AddWithValue("@IdCluster", r.IdCluster);

                cn.Open();
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }


        public async Task<int> InsertarAsync(Recibo recibo)
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("SP_InsertarRecibo", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@FechaEmision", recibo.FechaEmision?.ToDateTime(TimeOnly.MinValue));
            cmd.Parameters.AddWithValue("@IdPago", recibo.IdPago);
            cmd.Parameters.AddWithValue("@NumeroVivienda", recibo.NumeroVivienda);
            cmd.Parameters.AddWithValue("@IdCluster", recibo.IdCluster);

            var result = await cmd.ExecuteScalarAsync();
            return Convert.ToInt32(result);
        }

        public void Actualizar(Recibo r)
        {
            using (var cn = new SqlConnection(_connectionString))
            using (var cmd = new SqlCommand("SP_ActualizarRecibo", cn))
            {
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@IdRecibo", r.IdRecibo);
                cmd.Parameters.AddWithValue("@FechaEmision", r.FechaEmision.HasValue ? r.FechaEmision.Value.ToDateTime(TimeOnly.MinValue) : DBNull.Value);
                cmd.Parameters.AddWithValue("@IdPago", r.IdPago);
                cmd.Parameters.AddWithValue("@NumeroVivienda", r.NumeroVivienda);
                cmd.Parameters.AddWithValue("@IdCluster", r.IdCluster);

                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }
}
