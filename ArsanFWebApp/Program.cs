using ArsanWebApp.Services;
var builder = WebApplication.CreateBuilder(args);

var connectionString = builder.Configuration.GetConnectionString("SqlServerConnection");
Console.WriteLine($"Conexión a la base de datos con cadena: {connectionString}");

// Add services to the container.
builder.Services.AddControllersWithViews();
builder.Services.AddScoped<ResidenteService>();
builder.Services.AddScoped<ResidencialService>();
builder.Services.AddScoped<ClusterService>();
builder.Services.AddScoped<PersonaService>();
builder.Services.AddScoped<TipoViviendaService>();
builder.Services.AddScoped<PropietarioService>();
builder.Services.AddScoped<ViviendaService>();


var app = builder.Build();


// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseRouting();

app.UseAuthorization();

app.MapStaticAssets();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}")
    .WithStaticAssets();


app.Run();
