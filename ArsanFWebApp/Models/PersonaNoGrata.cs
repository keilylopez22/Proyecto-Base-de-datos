namespace ArsanWebApp.Models;

public class PersonaNoGrata
{
    public int IdPersonaNoGrata { get; set; }
    public DateOnly FechaInicio { get; set; }
    public DateOnly? FechaFin { get; set; }
    public string? Motivo { get; set; }
    public int IdPersona { get; set; }

    public String? NombreCompleto { get; set;}

}