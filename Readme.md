# Instrucciones
Ejecutar en el siguiente orden
1. Viviendas.sql
2. PAGOS.sql
3. TablasTurnos.sql
4. QueryVehiculos.sql
5. CorregirFK.sql
6. InsertTablasVivienda.sql
7. SPCrearVivienda.sql
8. SpActualizarVivienda.sql
9. SpEliminarVivienda.sql
10. BuscarViviendaporLLaves.sql
11. BuscarViviendaPorPropietario.sql
12. BuscarViviendaporTipoVivienda.sql
13. Ejecutar el archivo DropsVehiculos.sql
14. Ejecutar QueryVehiculos.sql
15. Ejecutar Inserts Vehiculos.sql
16. Jerarquia de eliminacion para un vehiculo asociado a otras tablas:
    # Eliminar el registro de ListaNegra
    # Eliminar el registro de RegistroVehiculos
    # Finalmente Eliminar el Vehiculo
    ## Si tratan de eliminar primero al vehículo, les lanzará un error,
    ## Ya que los SP de elminar de cada tabla protegen la integridad referencial(FK),
    ## Excepto ListaNegra y RegistroVehiculo.