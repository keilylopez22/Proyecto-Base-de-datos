namespace ArsanWebApp.Models;

public class Persona
{
    public int IdPersona { get; set; }
    public string Cui { get; set; } = string.Empty; // UNIQUE
    public string PrimerNombre { get; set; } = string.Empty;
    public string? SegundoNombre { get; set; }
    public string PrimerApellido { get; set; } = string.Empty;
    public string? SegundoApellido { get; set; }
    public string? Telefono { get; set; }
    public char? Genero { get; set; }
    public string EstadoCivil { get; set; } = string.Empty; // SINGLE CHAR
}