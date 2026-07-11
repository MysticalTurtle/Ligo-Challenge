# Ligo Challenge

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Este es el proyecto Ligo Challenge, desarrollado en Flutter con un enfoque en **Clean Architecture** y buenas prácticas de desarrollo.

Este proyecto fue generado utilizando [Very Good CLI][very_good_cli_link], una herramienta de línea de comandos que permite crear proyectos Flutter con una estructura escalable y siguiendo las mejores prácticas.

### Instalación de Very Good CLI 🛠️

Para instalar Very Good CLI, ejecuta:

```sh
dart pub global activate very_good_cli
```

Verifica la instalación:

```sh
very_good --version
```

---

## Estructura del Proyecto 📂

El código sigue los principios de Clean Architecture y está organizado por características (features) bajo el directorio `lib/`:

```
lib/
├── app/                  # Configuración global de la app, repositorios principales y temas
├── bootstrap/            # Configuración de inicio (BlocObserver, captura de errores)
├── core/                 # Componentes compartidos y utilidades transversales (Red, Storage, Routing)
│   ├── auth/             # Gestión transversal de sesión
│   ├── network/          # Cliente Dio y conectividad
│   ├── routing/          # Configuración de GoRouter
│   └── storage/          # Almacenamiento local (tokens)
└── features/             # Módulos y características de negocio
    ├── auth/             # Módulo de Autenticación
    └── movements/        # Módulo de Movimientos (Ingresos / Salidas)
```

Cada módulo (feature) está subdividido en capas:
- **`domain`**: Entidades y Casos de Uso (Usecases). Es la capa central, independiente de frameworks.
- **`data`**: Implementaciones de Repositorios, Modelos de datos y Data Sources (Mocks y APIs).
- **`application`**: Cubits encargados de gestionar el estado de la aplicación.
- **`presentation`**: Páginas, pantallas y componentes visuales.

---

## Funcionalidades Principales 🚀

1. **Autenticación**: Inicio y cierre de sesión, flujo persistente con almacenamiento seguro de tokens.
2. **Listado de Movimientos**: Visualización organizada de transacciones financieras.
3. **Búsqueda**: Función de búsqueda interactiva de movimientos por descripción.
4. **Filtros por Tipo**: Clasificación de movimientos como **Ingresos** o **Salidas**
5. **Detalle de Movimiento**: Vista detallada con información, montos formateados, íconos y colores condicionales según el tipo de movimiento.

---

## Credenciales de Acceso 🔐

El proyecto cuenta con un **mock implementado** para el sistema de autenticación. Para iniciar sesión, utiliza las siguientes credenciales:

- **DNI**: `12345678`
- **Contraseña**: `admin`

### Validación de Errores

Para probar la validación y manejo de errores de red:

1. Inicia sesión y entra a la pantalla de movimientos
1. Desactiva el internet
2. Intenta recargar la página
3. Aparecerá un mensaje de error por falta de conexión
4. Presiona el botón **"Reintentar"** para volver a intentar la operación

Esto te permitirá observar el comportamiento de la aplicación ante fallos de conectividad y la funcionalidad de reintento.

---

## Inyección de Dependencias (DI) 🔌

La inyección de dependencias en el proyecto se realiza utilizando los providers de la biblioteca `flutter_bloc` mediante **`MultiRepositoryProvider`**.

La inicialización y provisión de dependencias se centraliza en `lib/app/app_repositories.dart`:

- **Servicios e infraestructura**: `DioClient`, `TokenStorage` e `InternetConnectivity`.
- **Orígenes de Datos (Data Sources)**: `AuthRemoteDS` y `MovementsRemoteDS` (implementados mediante sus mocks correspondientes `AuthRemoteDSMock` y `MovementsRemoteDSMock` que reciben el cliente `Dio` de la capa de infraestructura).
- **Repositorios**: `AuthRepository` y `MovementsRepository` (implementados en `AuthRepositoryImpl` y `MovementsRepositoryImpl` recibiendo sus data sources e infraestructura inyectados desde el contexto).
- **Casos de Uso (Usecases)**: `LoginUsecase`, `LogoutUsecase` y `GetMovementsUsecase`.

Todos estos componentes se inyectan en el árbol de widgets para ser consumidos de manera eficiente en la capa de presentación mediante `context.read<T>()`, asegurando una separación clara entre la interfaz de usuario y la lógica de negocio.

---

## Manejo de Estado 🧠

Se utiliza **Cubit** a través del paquete `flutter_bloc` para gestionar de forma reactiva el estado de la UI:
- **`MovementsCubit`**: Controla el filtrado, la búsqueda y la carga del listado de movimientos.
- **`AuthBloc`**: Gestiona el flujo y los estados de la sesión del usuario (Autenticado, No Autenticado, Cargando).

---

## Cómo Ejecutar el Proyecto 🏁

Este proyecto soporta 3 entornos (Flavors):

- **development**
- **staging**
- **production**

Para compilar y ejecutar en el entorno deseado, utiliza los siguientes comandos:

```sh
# Entorno de Desarrollo
$ flutter run --flavor development --target lib/main_development.dart

# Entorno de Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Entorno de Producción
$ flutter run --flavor production --target lib/main_production.dart
```


---

## Ejecución de Pruebas 🧪

Para ejecutar todas las pruebas unitarias y de widgets con cobertura de código, corre el siguiente comando:

```sh
$ very_good test --coverage --test-randomize-ordering-seed random
```

Para ver el reporte de cobertura generado, puedes utilizar [lcov](https://github.com/linux-test-project/lcov).

Primero necesitas instalar `lcov` para acceder al comando `genhtml`:

En Windows:

```sh
sudo apt-get update
sudo apt-get install lcov
```

En macOS:

```sh
brew install lcov
```

Luego, genera y abre el reporte:

```sh
# Generar reporte HTML
$ genhtml coverage/lcov.info -o coverage/

# Abrir reporte en MacOS
$ open coverage/index.html
```

---

## Validación de Estilo y Bloc Lints 🔍

Este proyecto utiliza el paquete [bloc_lint](https://pub.dev/packages/bloc_lint) para asegurar las mejores prácticas en el uso de BLoCs.

Para validar linter y estilo de BLoC, ejecuta:

```bash
$ dart run bloc_tools:bloc lint .
```

También puedes utilizar la extensión oficial de Bloc en VSCode o Android Studio para un soporte en tiempo real.

---

[coverage_badge]: coverage_badge.svg
[internationalization_link]: https://docs.flutter.dev/ui/internationalization
[arb_documentation_link]: https://github.com/google/app-resource-bundle
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
