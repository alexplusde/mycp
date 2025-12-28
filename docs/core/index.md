# index

Quelle: https://redaxo.org/doku/main

# Dokumentation REDAXO 5.16 – 5.18.x

Die REDAXO-Dokumentation ist der Startpunkt für die Installation und Redaktion einer REDAXO-Webpräsenz. Zudem finden Developer hier auch die erforderlichen Informationen zur Entwicklung eigener Lösungen.

**

Wir freuen uns sehr über Mitarbeit bei der REDAXO-Dokumentation. Derzeit arbeiten Peter Bickel, Thomas Skerbis, Wolfgang Bund und Alexander Walther an der Dokumentation.

Unterstützung wird immer benötigt; die Dokumentation wird in [GitHub gepflegt und erweitert](https://github.com/redaxo/docs), sodass sich alle beteiligen können. Neue Artikel oder Verbesserungen können gerne per Pull-Request oder Issues eingereicht werden.
[Zur Dokumentation auf GitHub](https://github.com/redaxo/docs).

## Neues in dieser Doku

**Sicherheit und Konfiguration**

- [REDAXO absichern](/doku/main/absichern): Umfassendes Kapitel zur Absicherung des Backends mit Live-Mode und Security AddOn

- [Live-Mode](/doku/main/absichern#livemode): Sicherheitsmodus für Live-Systeme zur Einschränkung von PHP-Code-Ausführung

- [Security AddOn](/doku/main/absichern#securityaddon): AddOn für erweiterte Backend-Sicherheit mit IP-Kontrolle und Benutzerprotokoll

- [MediaPool-Sicherheit](/doku/main/medienpool#mime-typen-sicherheit): MIME-Type-Prüfung und SVG-Bereinigung für sicheren Datei-Upload

- [Safe Mode Enhancement](/doku/main/configyml#safe-mode): Erweiterte Admin-Beschränkungen und globale Konfiguration

- [Datenbank-SSL](/doku/main/configyml#datenbank-ssl): Sichere Datenbankverbindungen mit Zertifikatsprüfung

- [Backend Login Policies](/doku/main/configyml#login-policies): Brute-Force-Schutz mit konfigurierbaren Limits und Verzögerungen

**Entwicklung und APIs**

- [`rex_file::append`](/doku/main/file#rexfile_append): Erweiterte Dokumentation der append-Methode zum Anhängen von Content an Dateien

- [Namespace-Unterstützung](/doku/main/api#namespace-registrierung): Explizite Registrierung für API-Funktionen und REX_VAR-Klassen

- [Request-Validierung](/doku/main/requests#explizite-werte): Validierung mit expliziten Werte-Arrays für rex_get() und rex_post()

- [Extension Points](/doku/main/extension-points#page-structure-orderby): Neuer Extension Point für benutzerdefinierte Struktursortierung

- [Template-Übersetzungen](/doku/main/templates#template-namen-uebersetzen): Automatische Übersetzung von Template-Namen mit translate:template_name Format

**Medien und Tools**

- [Video-Vorschau](/doku/main/media-manager#video-vorschau): Media Manager Integration mit ffmpeg für automatische Video-Thumbnails

- [Console Autocompletion](/doku/main/console#autocompletion): Integrierte Autovervollständigung für Package-, User- und Datenbank-Befehle

- [Formular-Validierung](/doku/main/formulare#erweiterte-validierung): Verbesserte Unique-Constraint-Validierung mit benutzerdefinierten Fehlermeldungen

## Übersicht der Kategorien

**Einleitung**

Grundlegende Informationen zur aktuellen Version, Aktualisierung, API

**Setup und Administration**

Installationsanleitung, erster Login, Passwort-Wiederherstellung

**Anwender**

Der Bereich für Anwender ist primär an Redakteurinnen und Redakteure gerichtet. Hier wird die Bedienung des Systems erläutert.

**Basis**

Grundlegende technische Informationen zum Aufbau einer REDAXO-Webpräsenz

**Service**

Informationen für Developer

**Weitere System AddOns / PlugIns**

Informationen zu System Addons

**AddOn-Entwicklung**

Entwicklung und Bereitstellung eigener AddOns

**Datenbank**

Datenbankabfragen, Tabellen ändern und Prioritäten
                [**Artikel bearbeiten](https://github.com/redaxo/docs/edit/main/intro.md)
