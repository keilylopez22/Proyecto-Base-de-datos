namespace ArsanWebApp.Models;

public class TipoVivienda
{
    public int IdTipoVivienda { get; set; }
    public string? Descripcion { get; set; }
    public int? NumeroHabitaciones { get; set; }
    public int? SuperficieTotal { get; set; }
    public int? NumeroPisos { get; set; }
    public bool Estacionamiento { get; set; }
}