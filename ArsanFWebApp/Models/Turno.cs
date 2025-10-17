namespace ArsanWebApp.Models;

public class Turno
{
    public int IdTurno { get; set; }
    public string? Descripcion { get; set; }
    public DateTime HoraInicio { get; set; }
    public DateTime HoraFin { get; set; }
}