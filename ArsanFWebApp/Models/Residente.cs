namespace ArsanWebApp.Models;

public class Residente
{
    public int IdResidente { get; set; }
    public int IdPersona { get; set; }
    public int NumeroVivienda { get; set; }
    public int IdCluster { get; set; }
    public bool EsInquilino { get; set; }
    public string? Estado { get; set; }
}