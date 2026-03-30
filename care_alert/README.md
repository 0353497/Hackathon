# care_alert

Care Alert is een Flutter-applicatie gebouwd voor de hackathon.

## Projectstructuur

Dit is de belangrijkste mappenstructuur en waar elk onderdeel voor wordt gebruikt:

```text
care_alert/
|- lib/                        # Hoofdbroncode van de app
|  |- main.dart                # Startpunt van de app
|  |- domain/                  # Bedrijfslogica en applicatieregels
|  |  |- models/               # Datamodellen
|  |  |- providers/            # State-providers / services
|  |  |- utils/                # Gedeelde helpers en utilities
|  |- presentation/            # UI-laag
|  |  |- components/           # Herbruikbare widgets/componenten
|  |  |- pages/                # Schermniveau-pagina's
|- assets/
|  |- images/                  # Statische afbeeldingsbestanden
|- android/                    # Android-platformproject
|- ios/                        # iOS-platformproject
|- linux/                      # Linux-platformproject
|- macos/                      # macOS-platformproject
|- windows/                    # Windows-platformproject
|- web/                        # Web-platformbestanden
|- pubspec.yaml                # Dependencies, assets, app-metadata
|- analysis_options.yaml       # Lint- en analyzerregels
|- flutter_launcher_icons.yaml # Configuratie voor app-icoongeneratie
|- README.md                   # Projectdocumentatie
```

## Hoe Je Door De Code Navigeert

- Plaats nieuwe bedrijfslogica in de domeinlaag onder `lib/domain`.
- Plaats UI-widgets en schermen in `lib/presentation`.
- Houd app-opstart en route-initialisatie in `lib/main.dart`.
- Registreer en laad statische assets in `pubspec.yaml`.

## Notities Voor Contributors

- Probeer domain en presentation gescheiden te houden.
- Geef de voorkeur aan herbruikbare componenten in `lib/presentation/components` voordat je pagina-specifieke widgets maakt.
- Voeg alleen korte comments toe waar logica niet direct duidelijk is.


