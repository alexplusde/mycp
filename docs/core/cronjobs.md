# cronjobs

Quelle: https://redaxo.org/doku/main/cronjobs

# Cronjobs

- [Einführung](#einfuehrung)

- [Zweck des Cronjob-AddOns](#zweck)

- [Anwendungsfälle](#anwendungsfaelle)

- [Installation und Konfiguration](#installation)

- [Cronjob erstellen](#cronjob-erstellen)

- [Grundeinstellungen](#grundeinstellungen)

- [Name](#name)

- [Beschreibung](#beschreibung)

- [Status](#status)

- [Ausführungseinstellungen](#ausfuehrungseinstellungen)

- [Umgebung](#umgebung)

- [Ausführungszeitpunkt](#ausfuehrungszeitpunkt)

- [Intervall](#intervall)

- [Funktionalität](#funktionalitaet)

- [Typ](#typ)

- [Typspezifische Parameter](#typspezifische-parameter)

- [Ausführungsumgebungen im Detail](#umgebungen-detail)

- [Skript-Umgebung (empfohlen)](#skript-umgebung)

- [Frontend-Umgebung](#frontend-umgebung)

- [Backend-Umgebung](#backend-umgebung)

- [Server-Cronjob einrichten](#server-cronjob)

- [Eigene Cronjob-Typen entwickeln](#eigene-typen)

- [Grundlagen](#grundlagen-entwicklung)

- [Schritt-für-Schritt-Anleitung](#anleitung)

- [Praktisches Beispiel](#praktisches-beispiel)

- [Parameterfeld-Typen](#parameterfeld-typen)

- [Erweiterte Funktionen](#erweiterte-funktionen)

- [Debugging und Logging](#debugging)

- [API-Referenz](#api-referenz)

- [rex_cronjob Klasse](#rex-cronjob-klasse)

- [rex_cronjob_manager Klasse](#rex-cronjob-manager-klasse)

- [Parameterfeld-Definitionen](#parameterfeld-definitionen)

- [Best Practices](#best-practices)

- [Troubleshooting](#troubleshooting)

## Einführung

### Zweck des Cronjob-AddOns

Das Cronjob-AddOn ermöglicht die automatisierte, zeitgesteuerte Ausführung von Aufgaben in REDAXO. Es ist Teil der REDAXO-Basisinstallation, muss jedoch bei Bedarf separat installiert werden. Mit diesem AddOn können beliebig viele Cronjobs definiert werden, die gemäß individuellen Zeitplänen ausgeführt werden.

### Anwendungsfälle

Typische Einsatzgebiete für Cronjobs:

- **Wartungsaufgaben**: Regelmäßige Datenbank-Optimierung und Bereinigung

- **Content-Management**: Zeitgesteuertes Veröffentlichen oder Archivieren von Artikeln

- **Backup-Routinen**: Automatische Datenbank- und Datei-Backups

- **Synchronisation**: Abgleich mit externen Systemen (RSS-Feeds, APIs)

- **Benachrichtigungen**: Versand von E-Mail-Reports oder Newsletter

- **Datenverarbeitung**: Import/Export von Daten, Bildoptimierung

- **Monitoring**: Überwachung von System-Metriken und Alarmierung

## Installation und Konfiguration

- **Installation**: Das Cronjob-AddOn über den Installer aktivieren

- **Konfiguration**: Unter `AddOns > Cronjob` die Verwaltungsoberfläche aufrufen

- **Server-Cronjob**: Für optimale Performance einen Server-Cronjob einrichten (siehe [Server-Cronjob einrichten](#server-cronjob))

## Cronjob erstellen

### Grundeinstellungen

#### Name

Ein aussagekräftiger Name für den Cronjob, z.B. `Tägliches Backup`, `RSS-Feed Import` oder `Cache-Bereinigung`.

#### Beschreibung

Eine detaillierte Beschreibung der Aufgabe. Diese hilft bei der späteren Wartung und Dokumentation.

#### Status

- **Aktiviert**: Cronjob wird gemäß Zeitplan ausgeführt

- **Deaktiviert**: Cronjob wird pausiert (Standard: aktiviert)

### Ausführungseinstellungen

#### Umgebung

Die Umgebung bestimmt, wodurch der Cronjob ausgelöst wird:

Umgebung
Auslöser
Empfohlen für

**Skript**
Server-Cronjob
Zeitkritische und regelmäßige Aufgaben

**Frontend**
Seitenaufruf im Frontend
Unkritische, seltene Aufgaben

**Backend**
Aktivität im Backend
Administrative Aufgaben

**Wichtig**: Die Umgebung `Skript` sollte nicht gleichzeitig mit `Frontend` oder `Backend` aktiviert werden (außer zu Testzwecken).

#### Ausführungszeitpunkt

Nur für Frontend/Backend-Umgebung relevant:

- **Beginn**: Vor dem Seitenaufbau (kann zu Verzögerungen führen)

- **Ende**: Nach dem Seitenaufbau (empfohlen)

#### Intervall

Definiert die Häufigkeit der Ausführung:

- Minütlich, stündlich, täglich, wöchentlich, monatlich

- Benutzerdefinierte Intervalle möglich

- Standard: Täglich nach 0:00 Uhr

### Funktionalität

#### Typ

Verfügbare Standard-Typen:

- **PHP-Code**: Direkter PHP-Code

- **PHP-Callback**: Funktions- oder Methodenaufruf

- **URL-Aufruf**: HTTP-Request an eine URL

AddOns können weitere Typen bereitstellen:

- **Datenbankexport** (Backup-AddOn)

- **Search it: Reindexieren** (Search it-AddOn)

- Weitere projektspezifische Typen

#### Typspezifische Parameter

Je nach gewähltem Typ stehen unterschiedliche Eingabemöglichkeiten zur Verfügung:

**PHP-Code**:

`// Beispiel: Cache leeren
rex_delete_cache();
echo "Cache wurde geleert";`
``n

**PHP-Callback**:

`// Beispiel: Statische Methode
MyClass::myMethod`
``n

**URL-Aufruf**:

`https://example.com/webhook`
``n

## Ausführungsumgebungen im Detail

### Skript-Umgebung (empfohlen)

**Vorteile:**

- Unabhängig von Seitenaufrufen

- Zuverlässige, zeitgenaue Ausführung

- Keine Performance-Beeinträchtigung für Besucher

- Ideal für ressourcenintensive Aufgaben

**Nachteile:**

- Erfordert Zugriff auf Server-Cronjobs

- Keine Session-Informationen verfügbar

### Frontend-Umgebung

**Vorteile:**

- Kein Server-Zugriff erforderlich

- Zugriff auf Frontend-Session

**Nachteile:**

- Abhängig von Besucheraufkommen

- Kann Ladezeiten beeinflussen

- Unregelmäßige Ausführung möglich

### Backend-Umgebung

**Vorteile:**

- Manuelle Ausführung möglich

- Zugriff auf Backend-Session

- Gut für administrative Aufgaben

**Nachteile:**

- Nur bei Backend-Aktivität

- Nicht für zeitkritische Aufgaben geeignet

### Server-Cronjob einrichten

Für die Skript-Umgebung muss ein Server-Cronjob konfiguriert werden:

**1. Crontab öffnen:**

`crontab -e`
``n

**2. Cronjob hinzufügen:**

`# Jede Minute ausführen (empfohlen)
* * * * * /usr/bin/php /pfad/zu/redaxo/bin/console cronjob:run

# Alle 5 Minuten ausführen
*/5 * * * * /usr/bin/php /pfad/zu/redaxo/bin/console cronjob:run

# Stündlich ausführen
0 * * * * /usr/bin/php /pfad/zu/redaxo/bin/console cronjob:run`
``n

**Wichtig**: Das Server-Intervall sollte kleiner oder gleich dem kleinsten REDAXO-Cronjob-Intervall sein.

## Eigene Cronjob-Typen entwickeln

### Grundlagen

Um einen eigenen Cronjob-Typ zu erstellen, muss eine PHP-Klasse von `rex_cronjob` abgeleitet werden. Diese definiert die Funktionalität und stellt Konfigurationsfelder bereit.

### Schritt-für-Schritt-Anleitung

#### 1. Cronjob-Klasse erstellen

Erstelle eine PHP-Datei in `/redaxo/src/addons/mein_addon/lib/cronjob/`:

`<?php

class rex_cronjob_mein_typ extends rex_cronjob
{
    public function execute()
    {
        try {
            // Hauptfunktionalität implementieren
            $this->setMessage('Erfolgreich ausgeführt');
            return true;
        } catch (Exception $e) {
            $this->setMessage('Fehler: ' . $e->getMessage());
            return false;
        }
    }

    public function getTypeName()
    {
        return 'Mein Cronjob-Typ';
    }

    public function getParamFields()
    {
        return [
            [
                'label' => 'Parameter',
                'name' => 'mein_parameter',
                'type' => 'text',
                'notice' => 'Beschreibung des Parameters'
            ]
        ];
    }
}`
``n

#### 2. Typ registrieren

In der `boot.php` des AddOns:

`<?php
if (rex_addon::get('cronjob')->isAvailable()) {
    rex_cronjob_manager::registerType('rex_cronjob_mein_typ');
}`
``n

### Praktisches Beispiel

**Newsletter-Abonnenten-Benachrichtigung:**

`<?php

class rex_cronjob_subscriber_notification extends rex_cronjob
{
    public function execute()
    {
        $email = $this->getParam('notification_email');
        $table = $this->getParam('subscriber_table', 'rex_newsletter_user');
        $last_check = $this->getParam('last_check_timestamp', 0);

        if (empty($email)) {
            $this->setMessage('Keine E-Mail-Adresse konfiguriert');
            return false;
        }

        try {
            // Neue Abonnenten finden
            $sql = rex_sql::factory();
            $sql->setQuery(
                "SELECT * FROM {$table} 
                 WHERE createdate > :last_check 
                 AND status = 1",
                ['last_check' => date('Y-m-d H:i:s', $last_check)]
            );

            $new_subscribers = $sql->getArray();

            if (count($new_subscribers) > 0) {
                // E-Mail senden
                $this->sendNotification($email, $new_subscribers);
                $this->setMessage(count($new_subscribers) . ' neue Abonnenten gefunden');
            } else {
                $this->setMessage('Keine neuen Abonnenten');
            }

            // Zeitstempel aktualisieren
            $this->setParam('last_check_timestamp', time());

            return true;

        } catch (Exception $e) {
            $this->setMessage('Fehler: ' . $e->getMessage());
            return false;
        }
    }

    private function sendNotification($email, $subscribers)
    {
        if (!rex_addon::get('phpmailer')->isAvailable()) {
            throw new Exception('PHPMailer nicht verfügbar');
        }

        $mail = new rex_mailer();
        $mail->addAddress($email);
        $mail->Subject = 'Neue Newsletter-Abonnenten: ' . count($subscribers);

        $body = "Neue Abonnenten:\n\n";
        foreach ($subscribers as $subscriber) {
            $body .= "- {$subscriber['email']} ({$subscriber['createdate']})\n";
        }

        $mail->Body = $body;

        if (!$mail->send()) {
            throw new Exception('E-Mail-Versand fehlgeschlagen');
        }
    }

    public function getTypeName()
    {
        return 'Newsletter-Abonnenten-Benachrichtigung';
    }

    public function getParamFields()
    {
        return [
            [
                'label' => 'Benachrichtigungs-E-Mail',
                'name' => 'notification_email',
                'type' => 'text',
                'attributes' => ['type' => 'email'],
                'notice' => 'E-Mail für Benachrichtigungen'
            ],
            [
                'label' => 'Tabelle',
                'name' => 'subscriber_table',
                'type' => 'text',
                'default' => 'rex_newsletter_user'
            ],
            [
                'name' => 'last_check_timestamp',
                'type' => 'hidden',
                'default' => 0
            ]
        ];
    }
}`
``n

### Parameterfeld-Typen

#### Text-Eingabefeld

`[
    'label' => 'Textfeld',
    'name' => 'text_param',
    'type' => 'text',
    'default' => 'Standardwert',
    'notice' => 'Hilfetext',
    'attributes' => [
        'placeholder' => 'Platzhalter',
        'maxlength' => 255,
        'required' => 'required'
    ]
]`
``n

#### Textarea

`[
    'label' => 'Mehrzeiliger Text',
    'name' => 'textarea_param',
    'type' => 'textarea',
    'attributes' => ['rows' => 10, 'cols' => 50]
]`
``n

#### Auswahlfeld (Select)

`[
    'label' => 'Auswahl',
    'name' => 'select_param',
    'type' => 'select',
    'options' => [
        'option1' => 'Erste Option',
        'option2' => 'Zweite Option'
    ],
    'default' => 'option1'
]`
``n

#### Checkbox (als Select)

`[
    'label' => 'Aktiviert',
    'name' => 'checkbox_param',
    'type' => 'select',
    'options' => ['0' => 'Nein', '1' => 'Ja'],
    'default' => '1'
]`
``n

#### Verstecktes Feld

`[
    'name' => 'hidden_param',
    'type' => 'hidden',
    'default' => 'interner_wert'
]`
``n

### Erweiterte Funktionen

#### Umgebungen einschränken

`public function getEnvironments()
{
    // Nur in Skript-Umgebung verfügbar
    return ['script'];
}`
``n

#### Parameter zur Laufzeit ändern

`public function execute()
{
    $counter = (int) $this->getParam('counter', 0);
    $counter++;

    // Arbeit durchführen...

    // Counter für nächste Ausführung speichern
    $this->setParam('counter', $counter);

    $this->setMessage("Ausführung #{$counter} erfolgreich");
    return true;
}`
``n

### Debugging und Logging

`public function execute()
{
    $debug = [];

    try {
        // Schritt 1
        $debug[] = 'Daten geladen';

        // Schritt 2
        $debug[] = 'Verarbeitung abgeschlossen';

        // Bei Erfolg
        $this->setMessage('Erfolgreich: ' . implode(' > ', $debug));
        return true;

    } catch (Exception $e) {
        // Bei Fehler
        $this->setMessage(
            'Fehler nach: ' . implode(' > ', $debug) . 
            ' - ' . $e->getMessage()
        );
        return false;
    }
}`
``n

## API-Referenz

### rex_cronjob Klasse

#### Abstrakte Methoden (müssen implementiert werden)

Methode
Rückgabe
Beschreibung

`execute()`
`bool`
Hauptfunktionalität des Cronjobs

#### Optionale Methoden

Methode
Rückgabe
Beschreibung

`getTypeName()`
`string`
Anzeigename im Backend

`getParamFields()`
`array`
Konfigurationsfelder

`getEnvironments()`
`array`
Verfügbare Umgebungen

#### Parameter-Methoden

Methode
Parameter
Beschreibung

`setParam($key, $value)`
string, mixed
Einzelnen Parameter setzen

`getParam($key, $default)`
string, mixed
Parameter abrufen

`setParams($params)`
array
Alle Parameter setzen

`getParams()`
-
Alle Parameter abrufen

#### Nachrichten-Methoden

Methode
Parameter
Beschreibung

`setMessage($message)`
string
Status-Nachricht setzen

`getMessage()`
-
Nachricht abrufen

`hasMessage()`
-
Prüft ob Nachricht vorhanden

### rex_cronjob_manager Klasse

Methode
Parameter
Beschreibung

`registerType($class)`
string
Neuen Typ registrieren

`getTypes()`
-
Alle Typen abrufen

`factory($class)`
string
Instanz erstellen

### Parameterfeld-Definitionen

#### Grundstruktur

`[
    'label' => 'Bezeichnung',      // Pflicht: Anzeigename
    'name' => 'parameter_name',    // Pflicht: Interner Name
    'type' => 'text',              // Pflicht: Feldtyp
    'default' => '',               // Optional: Standardwert
    'notice' => '',                // Optional: Hilfetext
    'attributes' => [],            // Optional: HTML-Attribute
    'options' => []                // Nur für type='select'
]`
``n

#### HTML5-Eingabetypen

Über das `attributes` Array können HTML5-Typen gesetzt werden:

`// E-Mail
['attributes' => ['type' => 'email']]

// Nummer
['attributes' => ['type' => 'number', 'min' => 0, 'max' => 100]]

// Datum
['attributes' => ['type' => 'date']]

// URL
['attributes' => ['type' => 'url']]`
``n

## Best Practices

### Performance

- **Skript-Umgebung verwenden** für zeitkritische Aufgaben

- **Ressourcenintensive Aufgaben** in kleinere Teile aufteilen

- **Timeouts beachten** und ggf. erhöhen

- **Datenbankabfragen optimieren** (Indizes nutzen)

### Fehlerbehandlung

- **Try-Catch-Blöcke** verwenden

- **Aussagekräftige Fehlermeldungen** zurückgeben

- **Logging** für kritische Operationen implementieren

- **Transaktionen** bei Datenbankoperationen nutzen

### Sicherheit

- **Eingaben validieren** bei Parametern

- **Berechtigungen prüfen** bei sensiblen Operationen

- **Prepared Statements** für Datenbankabfragen

- **Externe APIs** mit Timeouts absichern

### Wartbarkeit

- **Sprechende Namen** für Cronjobs und Parameter

- **Dokumentation** in Beschreibungsfeldern

- **Versionierung** bei eigenen Typen

- **Internationalisierung** über Sprachdateien

## Troubleshooting

### Cronjob wird nicht ausgeführt

**Mögliche Ursachen:**

- Cronjob ist deaktiviert

- Server-Cronjob nicht eingerichtet

- Falsches Intervall konfiguriert

- PHP-Fehler im Code

**Lösungsansätze:**

- Status prüfen (aktiviert?)

- Server-Cronjob testen: `/pfad/zu/redaxo/bin/console cronjob:run`

- Error-Log prüfen

- Manuell im Backend ausführen (Test)

### Performance-Probleme

**Optimierungen:**

- Große Datenmengen in Batches verarbeiten

- Datenbankabfragen mit LIMIT versehen

- Caching implementieren

- Auf Skript-Umgebung umstellen

### E-Mail-Versand funktioniert nicht

**Prüfpunkte:**

- PHPMailer-AddOn installiert und konfiguriert?

- SMTP-Einstellungen korrekt?

- Spam-Filter prüfen

- Test-Mail über PHPMailer-AddOn senden

### Debugging aktivieren

`public function execute()
{
    // Debug-Modus
    if ($this->getParam('debug_mode')) {
        rex_logger::factory()->log('info', 'Cronjob Start', [
            'params' => $this->getParams(),
            'time' => date('Y-m-d H:i:s')
        ]);
    }

    // Cronjob-Logik...

    return true;
}`
``n
                
                            [**Artikel bearbeiten](https://github.com/redaxo/docs/edit/main/cronjobs.md)
