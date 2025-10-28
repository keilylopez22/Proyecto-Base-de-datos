namespace ArsanWebApp.Models;

public class Visitante
{
    public int IdVisitante { get; set; }
    public string NombreCompleto { get; set; } = string.Empty;
    public string NumeroDocumento { get; set; } = string.Empty;
    public string? Telefono { get; set; }
    public string? MotivoVisita { get; set; }
    public int IdTipoDocumento { get; set; }
    public string? TipoDocumento { get; set; } 
    public string? NombreDocumento { get; set; }
}