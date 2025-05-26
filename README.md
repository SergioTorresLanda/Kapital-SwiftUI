#Prueba Técnica - Kapital Bank

##Véase la grabación publica del flujo completo: 
Comportsmiento online:   
https://drive.google.com/file/d/1Qfp_YueWafyKrqDPeYTGzd15u5RYAA2s/view?usp=sharing
Comportamiento offline: 
https://drive.google.com/file/d/1gI4wRJ6hm9oCBP4w6IT_0stX7LZ6aRRT/view?usp=sharing

-App de iOS moderna creada con SwiftUI, centrada en una arquitectura robusta, persistencia de datos y pruebas integrales.
-Esta aplicación permite a los usuarios explorar una colección de figuras Amiibo obtenidas de una API externa, ver sus detalles y administrar una lista de sus Amiibo favoritos usando almacenamiento local.

##**Tecnologías clave y principios arquitectónicos**

* **Entorno de desarrollo:** Desarrollado en **Xcode 15.3** (o una versión posterior compatible) para **iOS 17+**.
* **Interfaz de usuario:** Desarrollada íntegramente con **SwiftUI**, aprovechando su sintaxis declarativa para una experiencia de usuario ágil y moderna.
* **Arquitectura:**
* **MVVM (Modelo-Vista-Modelo de vista):** Promueve una clara separación de intereses, mejorando la mantenibilidad y la capacidad de prueba. Las vistas son ligeras y declarativas, mientras que los modelos de vista gestionan la lógica de presentación y la vinculación de datos.
* **Principios de arquitectura limpia:** El proyecto incorpora principios de arquitectura limpia, incluyendo:
* **Inversión de dependencias:** Se utilizan abstracciones (protocolos) para definir contratos entre capas (p. ej., `AmiiboRepositoryProtocol`), lo que permite implementaciones intercambiables (p. ej., servicios simulados para pruebas, fuentes de datos reales para producción).

* * **Separación de Responsabilidades:** La obtención de datos (`RemoteAmiiboDataSource`), la persistencia local (`LocalAmiiboDataSource`) y la lógica de negocio (`AmiiboRepository`, `MyViewModel`) están claramente separadas en diferentes capas y módulos (o archivos, en la estructura de este proyecto).
* **Persistencia de Datos:** Utiliza **SwiftData** (el moderno framework de persistencia de datos de Apple, sucesor de Core Data) para el almacenamiento local de los datos de Amiibo y el estado de favoritos. Esto garantiza que los datos estén disponibles sin conexión y persistan tras cada lanzamiento de la app.
* **Operaciones Asincrónicas:** Aprovecha la **Concurrencia de Swift (`async/await`)** para realizar operaciones asincrónicas eficientes y legibles, especialmente para solicitudes de red y obtención de datos, lo que garantiza una interfaz de usuario fluida. * **Pruebas:**
* **Pruebas unitarias:** Se incluyen pruebas unitarias completas para `MyViewModel` y sus interacciones con el `AmiiboRepository` simulado, lo que garantiza que la lógica empresarial principal funcione correctamente.
* **Pruebas de interfaz de usuario:** Se implementaron para verificar los flujos e interacciones críticas del usuario dentro de la aplicación, como marcar un amiibo como favorito y navegar a la lista de favoritos.

### **Aspectos destacados de la estructura del proyecto**

* `SomeAppswiftUIApp.swift`: Punto de entrada de la aplicación, responsable de configurar el `ModelContainer` para SwiftData.
* `ContentView.swift`: Vista principal, que muestra la lista de Amiibos y permite navegar a los favoritos.
* `FavoritesView.swift`: Muestra los Amiibos favoritos del usuario.
* `CardView.swift`: Componente de vista reutilizable de SwiftUI para mostrar información individual de los Amiibos.
* `MyViewModel.swift`: El ViewModel, responsable de gestionar la obtención de datos, la coordinación de la lógica de persistencia y la exposición de los datos a las vistas.
* `AmiiboRepository.swift`: Actúa como un orquestador central entre las fuentes de datos remotas y locales, implementando `AmiiboRepositoryProtocol`. 
* `RemoteAmiiboDataSource.swift`: Gestiona todas las solicitudes de red a la API de Amiibo.
* `LocalAmiiboDataSource.swift`: Gestiona todas las operaciones de SwiftData para la persistencia local.
* `AmiiboModel.swift`: Define la estructura de datos de `Amiibo` para las respuestas de la API.
* `ObjetoPersistencia.swift`: Define la clase `AmiiboObj` SwiftData `@Model` para la persistencia local.
* `SomeExtraView.swift` : Vista adicional para los detalles de Amiibo.
* `SomeAppswiftUITests.swift`: Contiene pruebas unitarias para `MyViewModel` y pruebas de interfaz de usuario para la funcionalidad integral.
* `SomeAppswiftUIUITests.swift`: Contiene una pruebas basica de UI para las principales interacciones que el usuario puede llevar a cabo con la interfaz.


