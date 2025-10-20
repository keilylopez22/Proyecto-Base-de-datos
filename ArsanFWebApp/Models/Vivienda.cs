namespace ArsanWebApp.Models;

public class Vivienda
{
    public int NumeroVivienda { get; set; } 
    public int IdCluster { get; set; }      
    public int IdTipoVivienda { get; set; }
    public int IdPropietario { get; set; }

    
    public string? Cluster { get; set; }
    public string? TipoVivienda { get; set; }
    public string? Propietario { get; set; }
}