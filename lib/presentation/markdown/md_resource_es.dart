import 'package:good_manager/presentation/markdown/md_bundle.dart';

class MarkdownResourceES {
  static const bundle = MarkdownBundle(
    whatNews: """
### Versión 1.0.92 - 12 oct 2026
* Totales de entrada y salida en la tarjeta de documentos de Inicio.
* Barra de resumen en Artículos, Historial, Documentos, Pagos, Tiendas, Proveedores y Clientes.
* El resumen de documentos y pagos sigue la pestaña seleccionada.
* El proveedor usa un icono de camión. El cliente usa un icono de usuarios.
* La ayuda y las notas de versión están en todos los idiomas de la app.

### Versión 1.0.91 - 08 oct 2026
* Importación y exportación de Excel en el menú de inventario.
* Acciones al mantener pulsado en los documentos recientes de Inicio.
* Acciones al mantener pulsado en los resultados de búsqueda.
* Categorías pasa a llamarse Categorías de pago en Ajustes.

### Versión 1.0.90 - 06 oct 2026
* Actualización de Inicio, Inventario, Pagos, Informes y Ajustes.
* Fotos para tiendas, grupos, clientes y proveedores.
* Actualización de listas, estados vacíos y la bienvenida.
* Traducciones mejoradas.
* Corrección de errores notificados.

### Versión 1.0.80 - 23 abr 2026
* Corrección de errores notificados.
* Guía para pasar a la versión en línea.
* Renovación de la interfaz.

### Versión 1.0.75 - 16 abr 2026
* Corrección de errores notificados.
* Nueva moneda.
* Corrección de códigos de barras duplicados.

### Versión 1.0.70 - 06 feb 2026
* Corrección de errores notificados.
* Nueva moneda.
* Actualización de la sincronización.
* Actualización del logotipo (versión en línea).

### Versión 1.0.65 - 20 sep 2025
* Corrección de errores notificados.
* Nuevo informe: información del artículo.

### Versión 1.0.60 - 09 sep 2025
* Corrección del inicio de sesión con Apple.
* Corrección de errores notificados.
* Ajustes de tema, idioma y moneda.
* Actualización del logotipo y los archivos al guardar un artículo.
* Actualización de la autenticación.
* Actualización de la interfaz.

### Versión 1.0.45 - 12 jul 2025
* Corrección de errores notificados.

### Versión 1.0.40 - 25 jul 2025
* Corrección del escaneo de códigos en Android.
* Corrección de la alerta de stock bajo al iniciar.
* Corrección de errores notificados.
* Idioma de la app en el menú.
* Actualización de la interfaz.

### Versión 1.0.30 - 30 may 2025
* Corrección de errores notificados.
* Cantidad mínima.
* Información de la empresa.
* Modo oscuro y bloqueo con código.
* Informe de reposición.

### Versión 1.0.25 - 14 abr 2025
* Corrección de errores notificados.
* Pagos.
* Carteras.
* 5 tipos de informe.

### Versión 1.0.8 - 06 dic 2024
* Corrección de errores notificados.
* Ajustes de lista en Artículos.
* Búsqueda actualizada en Artículos.
* Sincronización rápida.

### Versión 1.0.7 - 27 sep 2024
* Corrección de errores notificados.
* Compatibilidad con iOS.

### Versión 1.0.6 - 07 jul 2024
* Corrección de errores notificados.
* Creación rápida de documento al guardar un artículo.
* Historial del artículo.

### Versión 1.0.5 - 14 jun 2024
* Inicio de sesión y registro.
* Los datos del usuario se guardan en la nube.
* Corrección de errores notificados.

### Versión 1.0.4 - 18 abr 2024
* Corrección del desplazamiento en el detalle del informe.

### Versión 1.0.3 - 15 abr 2024
* Intervalo de fechas en los informes.
* Corrección de Seleccionar grupo.

### Versión 1.0.2 - 12 abr 2024
* Compatibilidad con Windows.
* Informe de lista de artículos.
* Exportación a PDF y CSV.
* Copia de seguridad y restauración.

### Versión 1.0.1 - 04 abr 2024
* La cantidad del documento pasa de entero a decimal.
* Sonido y vibración al escanear un código.
* Actualización a Material 3.

### Versión 1.0.0
* Primera versión.
""",
    helpDocuments: """
## Documentos

Los documentos registran la entrada o la salida de stock de una tienda.

### Entrada
- Cree un documento de entrada cuando la mercancía **llega** a la tienda.
- Las cantidades del documento se **suman** al stock.

### Salida
- Cree un documento de salida cuando la mercancía **sale** de la tienda (por ejemplo, una venta).
- Las cantidades del documento se **restan** del stock.

### Añadir artículos
- Elija artículos del catálogo, o
- **Escanee un código de barras** con la cámara.

### Escaneo por lotes
- Escanee códigos uno tras otro. Cada escaneo **añade el artículo y aumenta la cantidad en 1**.
- O escriba la cantidad **manualmente** después de cada escaneo.
- Elija el modo en **Ajustes**.

### Creación automática
- Un **artículo nuevo** añadido a un documento de entrada (con datos completos) se **guarda en el catálogo**.
- No puede añadir un artículo nuevo a un documento de salida. El artículo debe existir ya en el stock.

### Eliminar
- **Mantenga pulsado** un documento o una línea para eliminarlo.

> Eliminar un documento cambia el stock. Solo puede eliminar el documento **más reciente**. Eliminar uno anterior puede dejar las cantidades incorrectas.

### Filtrar y ordenar
- Use la barra de herramientas para **filtrar** u **ordenar** los documentos.
""",
    helpGoods: """
## Artículos

La pantalla Artículos es el catálogo de todo lo que hay en la tienda, incluido el stock actual.

Añada artículos a un documento desde esta lista. Si un artículo tiene código de barras, escanéelo con la cámara para añadirlo rápido.

> La cantidad en stock no se edita a mano. Se calcula a partir de los documentos.

### Acciones
- Al editar un artículo, pulse la **cámara** junto al código para escanear.
- **Mantenga pulsado** un artículo para eliminarlo.
- Use la barra de herramientas para **buscar** u **ordenar**.

### Creación automática
- No hace falta completar el catálogo antes.
- Cree un documento de entrada e introduzca un artículo nuevo. Se **guarda en el catálogo** automáticamente.
- La próxima vez puede añadirlo escaneando el código.
""",
    helpStores: """
## Tiendas

Use las tiendas para separar el stock por lugar (tienda, almacén, etc.).

### Stock por tienda
- Cada tienda tiene su **propio stock**.
- Cada documento pertenece a **una tienda**.

### Cambiar de tienda
- En **Inicio**, pulse el nombre o el avatar de la tienda para cambiar la tienda actual.

### Añadir y gestionar
- Abra **Tiendas** en Ajustes para añadir, editar o eliminar una tienda.

### Límites
- La versión gratuita admite hasta **2 tiendas**.
- Pase a **Stock Premium** para tener más. La suscripción incluye **7 días de prueba**.
""",
    helpSupplierCustomers: """
## Proveedores y clientes

Guarde los datos de proveedores y clientes en un solo lugar. Añádalos a mano o **impórtelos de Contactos**.

### Asignar a un documento
- En un documento de **entrada**, pulse **Proveedor**.
- En un documento de **salida**, pulse **Cliente**.

### Gestionar registros
- **Mantenga pulsado** un proveedor o un cliente para:
  - Ver los documentos relacionados
  - Eliminar el registro
""",
    helpPayments: """
## Pagos

Los pagos registran el dinero que entra y sale de una cartera.

### Entrada
- Registre cuando **recibe dinero** de un cliente.
- Suele vincularse a un documento de **salida**.
- Controla el dinero que entra.

### Salida
- Registre cuando **paga** a un proveedor.
- Suele vincularse a un documento de **entrada**.
- Controla el dinero que sale.

### Añadir un pago
- Abra **Pagos**, o añada un pago desde un documento.
- Elija **Entrada** o **Salida**.
- Indique **importe**, **fecha**, persona y notas opcionales.
- Vincule un **documento** cuando haga falta.

### Documentos vinculados
- Un pago vinculado indica para qué es el dinero.
- Un pago parcial marca el documento como **Parcial**.
- Un pago completo marca el documento como **Pagado**.

### Editar o eliminar
- **Mantenga pulsado** un pago para editarlo o eliminarlo.

> Eliminar un pago puede cambiar el estado de pago del documento.

### Filtrar y ordenar
- Use la barra de herramientas para **filtrar** u **ordenar** los pagos.
""",
    helpMinQuan: """
## Cantidad mínima

Defina una **cantidad mínima** en cada artículo para saber cuándo reponer.

### Qué es
- El stock más bajo que quiere conservar.
- Cuando el stock baja de ese número, el artículo aparece en el informe **Reposición** y en **Inicio** como stock bajo.

### Cómo definirla
- Abra un artículo al añadirlo o editarlo.
- Escriba un número en **Cantidad mín.** (por ejemplo, 5 o 10).

### Stock bajo
- Use el informe **Reposición** para ver los artículos por debajo del mínimo.
- Inicio también muestra **Sin stock** y **Stock bajo**.

### Actualizar
- Edite el artículo en cualquier momento para cambiar el mínimo.
- Ajústelo según la velocidad de venta o la temporada.

### Consejos
- Use un mínimo más alto para artículos de venta rápida o importantes.
- Revise los valores con regularidad para que las alertas sigan siendo útiles.
""",
  );
}
