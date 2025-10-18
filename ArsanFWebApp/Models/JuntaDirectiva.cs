namespace ArsanWebApp.Models;

public class JuntaDirectiva
{
    public int IdJuntaDirectiva { get; set; }
    public int IdCluster { get; set; }
    public string? Cluster { get; set; } // Solo para mostrar en listado
}