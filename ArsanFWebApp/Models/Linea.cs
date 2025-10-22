namespace ArsanWebApp.Models;

public class Linea
{
    public int IdLinea { get; set; }        
    public string? Descripcion { get; set; }
    public int IdMarca { get; set; }         
    public int IdMarca { get; set; }         // Parte de PK compuesta
    public string? Marca { get; set; }
}