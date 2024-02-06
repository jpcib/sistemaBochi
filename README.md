# sistemaBochi

Consulta de acciones en escuelas dependientes del Ministerio de Educación de la Ciudad de Buenos Aires.

https://jpcib.github.io/sistemaBochi/

Instrucciones para actualización

El sistema contiene información sobre 1. Obras de infraestructura realizadas y en curso (DGINFE), 2. Acciones de mantenimiento escolar escolar (DGME), 3. Mobiliario entregado a las instituciones e 4. Instalación de espacios seguros.

1.  Las obras de infraestructura en curso y planificadas provienen de una base actualizada por la dginfe cuya infromación se compara con la base guardada en este sistema para actualizar status de obras en curso y agregar obras nuevas.
    1.  infra_wrangle_2024.R
2.  La base de mantenimiento escolar reemplazando el archivo pedido a la DG cada vez. La actualización que se pide es desde 2021 en adelante.
    1.  parse_mtom.R
3.  Mobiliario lo descargo directamente desde la base compartida en sheets para procesamiento local.
    1.  parse_mobiliario.R
4.  espacios seguros se actualiza desde una base en gogle sheets completada de manera manual por el área, y que descargo con un script
    1.  seguridad_wrangle.R
5.  Para actualizar el contenido de las paginas modificar los archivos correctos en cada chunk y correr el script source_pages_v2.R
6.  Por último, renderizar el contenido (en RStudio: Build -\> render website, o ctrl+shift+b)
7.  table_wrangle.R tiene la tabla buscador del menu original, solo correr si cambia la base de escuelas. La versión actual es base_completa_link_v6.csv
