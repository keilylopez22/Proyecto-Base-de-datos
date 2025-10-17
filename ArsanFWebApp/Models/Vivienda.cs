namespace ArsanWebApp.Models;

public class Vivienda
{
    public int NumeroVivienda { get; set; } // Parte de PK compuesta
    public int IdCluster { get; set; }      // Parte de PK compuesta
    public int IdTipoVivienda { get; set; }
    public int IdPropietario { get; set; }
}