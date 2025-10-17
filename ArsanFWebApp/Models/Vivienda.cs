namespace ArsanWebApp.Models;

public class Vivienda
{
    public int NumeroVivienda { get; set; } // Parte de PK compuesta
    public int IdCluster { get; set; }      // Parte de PK compuesta
    public int IdTipoVivienda { get; set; }
    public int IdPropietario { get; set; }

    // Propiedades para mostrar en listado (no están en la tabla)
    public string? Cluster { get; set; }
    public string? TipoVivienda { get; set; }
    public string? Propietario { get; set; }
}