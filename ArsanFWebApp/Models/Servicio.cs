namespace ArsanWebApp.Models;

public class Servicio
{
    public int IdServicio { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public decimal Tarifa { get; set; }
}