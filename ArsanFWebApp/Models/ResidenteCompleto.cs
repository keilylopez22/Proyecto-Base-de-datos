using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

// Models/ResidenteCompleto.cs
namespace ArsanWebApp.Models
{
    public class ResidenteCompleto
    {
        public int IdResidente { get; set; }
        public int IdPersona { get; set; }
        public int NumeroVivienda { get; set; }
        public int IdCluster { get; set; }
        public bool EsInquilino { get; set; }
        public string? Estado { get; set; }

        // Datos de Persona
        public string PrimerNombre { get; set; } = string.Empty;
        public string? SegundoNombre { get; set; }
        public string PrimerApellido { get; set; } = string.Empty;
        public string? SegundoApellido { get; set; }

        // Datos de Cluster
        public string ClusterDescripcion { get; set; } = string.Empty;

        // Propiedad calculada (opcional)
        public string NombreCompleto => 
            $"{PrimerNombre} {(SegundoNombre ?? "")} {PrimerApellido} {(SegundoApellido ?? "")}".Trim();
    }
}