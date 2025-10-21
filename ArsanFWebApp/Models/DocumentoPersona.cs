namespace ArsanWebApp.Models;

public class DocumentoPersona
{
    public int IdDocumentoPersona { get; set; }
    public int NumeroDocumento { get; set; }
    public int IdTipoDocumento { get; set; } // Parte de PK compuesta
    public int IdPersona { get; set; }       // Parte de PK compuesta
    public string? Observaciones { get; set; }
    public string? TipoDocumentoNombre { get; set; }
    public string? NombrePersona { get; set; }
}