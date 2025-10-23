namespace ArsanWebApp.Models;

public class DocumentoPersona
{
    public int NumeroDocumento { get; set; }
    public int IdTipoDocumento { get; set; } 
    public int IdPersona { get; set; }       
    public string? Observaciones { get; set; }
}