namespace ArsanWebApp.Models;

public class Linea
{
    public int IdLinea { get; set; }         // Parte de PK compuesta
    public string? Descripcion { get; set; }
    public int IdMarca { get; set; }         // Parte de PK compuesta
}