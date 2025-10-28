namespace ArsanWebApp.Models;

public class Propietario
{
    public int IdPropietario { get; set; }
    public string Estado { get; set; } = string.Empty;
    public int IdPersona { get; set; }
    public string? NombreCompleto { get; set; }

    public Persona? Persona { get; set; }
   
}   