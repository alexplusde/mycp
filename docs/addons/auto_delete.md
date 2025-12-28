# Auto Delete - Automatisches Löschen | Keywords: DSGVO, GDPR, Cleanup, Datenlöschung, Cronjobs, Datenschutz, Retention

**Übersicht**: Löscht automatisch alte Logs, Dateien und Datensätze nach festgelegten Zeitintervallen via Cronjob. Ermöglicht DSGVO-konforme Datenhaltung durch automatisierte Bereinigung von YForm-Tabellen, Ordnern und SQL-Tabellen.

## Cronjob-Typen

| Typ | Beschreibung |
|-----|-------------|
| `YForm` | Löscht Datensätze mit `datestamp_auto_delete` Feld |
| `Table` | Löscht alte Einträge aus beliebigen Tabellen |
| `Folder` | Bereinigt Dateien in Ordnern nach Alter |

## YForm-Feld: datestamp_auto_delete

| Parameter | Beschreibung |
|-----------|-------------|
| `name` | Feldname (z.B. `delete_date`) |
| `label` | Feld-Label |
| `format` | Datumsformat (Y-m-d H:i:s) |
| `no_db` | Nicht in DB speichern (0/1/2) |
| `offset` | Zeitoffset (z.B. `+6 months`, `+90 days`) |

## Offset-Beispiele

| Offset | Bedeutung |
|--------|-----------|
| `+30 days` | 30 Tage in Zukunft |
| `+6 months` | 6 Monate in Zukunft |
| `+1 year` | 1 Jahr in Zukunft |
| `+2 weeks` | 2 Wochen in Zukunft |
| `+90 days` | 90 Tage in Zukunft |

## Praxisbeispiele

### Beispiel 1: datestamp_auto_delete in YForm-Tabelle

```php
// YForm TableSet
value|datestamp_auto_delete|delete_date|Löschdatum|Y-m-d H:i:s|0|+6 months
```

### Beispiel 2: YForm-Cronjob konfigurieren

Im Backend unter `System` > `Cronjob`:

- **Typ**: YForm
- **Name**: Alte YForm-Einträge löschen
- **Beschreibung**: Löscht Einträge mit abgelaufenem delete_date
- **Intervall**: Täglich um 03:00 Uhr
- **Umgebung**: Script (nur Console)

### Beispiel 3: Eigenes Feld mit Offset erstellen

```php
// +90 Tage = 3 Monate
value|datestamp_auto_delete|expires_at|Verfallsdatum|Y-m-d H:i:s|1|+90 days
```

### Beispiel 4: Table-Cronjob für rex_Tabelle

```php
// Im Backend: System > Cronjob
// Typ: Table
// Parameter:
// - rex_table: rex_my_table
// - field: updatedate
// - interval: 6 (Monate)
```

### Beispiel 5: Bewerberdaten nach 6 Monaten löschen

```php
// YForm-Tabelle: rex_applications
value|datestamp_auto_delete|delete_after|Automatische Löschung|Y-m-d H:i:s|1|+6 months

// Cronjob: YForm
// Täglich prüfen und alte Bewerbungen löschen
```

### Beispiel 6: Folder-Cronjob für Logs

```php
// Im Backend: System > Cronjob
// Typ: Folder
// Parameter:
// - dir: /path/to/logs
// - days: 30
// Löscht Dateien älter als 30 Tage
```

### Beispiel 7: PHPMailer-Logs bereinigen

```php
// Cronjob: Folder
// dir: redaxo/data/addons/phpmailer/
// days: 7

// Löscht E-Mail-Logs älter als 7 Tage
```

### Beispiel 8: Temporäre Uploads löschen

```php
// YForm-Tabelle: rex_temp_uploads
value|datestamp_auto_delete|cleanup_date|Bereinigung|Y-m-d H:i:s|1|+1 day

// Cronjob läuft täglich und löscht alte Uploads
```

### Beispiel 9: Newsletter-Anmeldungen bereinigen

```php
// Nach 2 Jahren löschen
value|datestamp_auto_delete|delete_date|Löschdatum|Y-m-d H:i:s|1|+2 years

// DSGVO: Speicherfrist für Marketing-Daten
```

### Beispiel 10: Table-Cronjob für nicht-YForm-Tabellen

```php
// Tabelle: rex_custom_logs
// Feld: created_at
// Intervall: 3 Monate

$cronjob = new Alexplusde\AutoDelete\Cronjob\Table();
// Manuell ausführen via Code
```

### Beispiel 11: Offset mit strtotime-Format

```php
// Alle PHP strtotime-Formate funktionieren:
// +1 week
// +14 days
// +3 months
// +1 year
// first day of next month
// last day of this month

value|datestamp_auto_delete|delete_date|Löschdatum|Y-m-d H:i:s|1|first day of next month
```

### Beispiel 12: Programmatischer Zugriff

```php
// Datum abrufen
$entry = rex_yform_manager_dataset::query('rex_applications', $id)->findOne();
echo $entry->getValue('delete_after');
// Ausgabe: 2024-06-30 03:00:00
```

### Beispiel 13: Cronjob per Console ausführen

```bash
# Alle fälligen YForm-Löschungen ausführen
php redaxo/bin/console cronjob:run
```

### Beispiel 14: Multiple Tabellen mit YForm-Cronjob

```php
// Der YForm-Cronjob durchsucht ALLE YForm-Tabellen
// nach dem Feld "datestamp_auto_delete"

// Tabelle 1: rex_applications
value|datestamp_auto_delete|delete_date|Löschdatum|Y-m-d H:i:s|1|+6 months

// Tabelle 2: rex_temp_files
value|datestamp_auto_delete|delete_date|Löschdatum|Y-m-d H:i:s|1|+1 day

// Ein Cronjob löscht aus BEIDEN Tabellen
```

### Beispiel 15: Folder-Cronjob mit Unterordnern

```php
// Rekursiv alle Dateien in Unterordnern löschen
// Cronjob: Folder
// dir: redaxo/data/addons/myaddon/uploads/
// days: 90

// Löscht auch Dateien in /uploads/2024/, /uploads/temp/, etc.
```

### Beispiel 16: Sicherheit - nur ältere Logs

```php
// Table-Cronjob für rex_system_log
// Tabelle: rex_system_log
// Feld: createdate
// Intervall: 12 Monate

// Behält Logs der letzten 12 Monate
```

### Beispiel 17: DSGVO-konform: Kundendaten

```php
// Nach Vertragsende + 10 Jahre löschen
value|datestamp_auto_delete|legal_delete_date|Gesetzliche Löschung|Y-m-d H:i:s|1|+10 years

// Hinweis: Löschfristen an gesetzliche Aufbewahrungspflichten anpassen!
```

### Beispiel 18: Extension Point nutzen

```php
// Vor dem Löschen Extension Point auslösen
rex_extension::register('YFORM_DATA_DELETE', function($ep) {
    $dataset = $ep->getSubject();
    
    if ($dataset->getTableName() == 'rex_applications') {
        // Log erstellen, E-Mail versenden, etc.
        rex_logger::logNotice('auto_delete', 'Bewerbung gelöscht: ' . $dataset->getId());
    }
});
```

### Beispiel 19: Ordner-Cronjob für Medienpool-Kategorie

```php
// Cronjob: Folder
// dir: redaxo/media/temp/
// days: 14

// Löscht temporäre Medienpool-Dateien nach 2 Wochen
```

### Beispiel 20: Kombiniert mit YForm-Actions

```php
// In YForm-Formular
value|datestamp_auto_delete|auto_cleanup|Automatische Bereinigung|Y-m-d H:i:s|1|+30 days

action|db
action|tpl2email|...

// Nach 30 Tagen werden Formulareinträge automatisch gelöscht
```

### Beispiel 21: Nur Wert anzeigen, nicht speichern

```php
// no_db = 0: Speichern und anzeigen
// no_db = 1: Nur anzeigen, wenn leer
// no_db = 2: Nie speichern

value|datestamp_auto_delete|cleanup_info|Info|Y-m-d H:i:s|2|+90 days

// Zeigt Datum an, speichert aber nicht in DB
```

### Beispiel 22: Cronjob-Status prüfen

```php
$sql = rex_sql::factory();
$sql->setQuery('SELECT * FROM rex_cronjob WHERE type LIKE "%AutoDelete%"');

foreach ($sql as $row) {
    echo 'Cronjob: ' . $row->getValue('name');
    echo '<br>Status: ' . ($row->getValue('status') == 1 ? 'Aktiv' : 'Inaktiv');
    echo '<br>Letzter Lauf: ' . date('d.m.Y H:i', $row->getValue('execution_moment'));
}
```

### Beispiel 23: Manuelle Löschung testen

```php
// YForm Auto-Delete manuell ausführen
use Alexplusde\AutoDelete\AutoDelete;

AutoDelete::YForm();

// Führt Löschung für alle YForm-Tabellen aus
```

### Beispiel 24: Backup vor Löschung

```php
rex_extension::register('YFORM_DATA_DELETE', function($ep) {
    $dataset = $ep->getSubject();
    
    // Backup in separate Tabelle
    $backup = rex_sql::factory();
    $backup->setTable('rex_deleted_entries');
    $backup->setValue('original_id', $dataset->getId());
    $backup->setValue('table_name', $dataset->getTableName());
    $backup->setValue('data', json_encode($dataset->getData()));
    $backup->setValue('deleted_at', date('Y-m-d H:i:s'));
    $backup->insert();
});
```

### Beispiel 25: Verschiedene Löschfristen

```php
// Kurze Frist: Spam-Einträge
value|datestamp_auto_delete|spam_cleanup|Spam-Bereinigung|Y-m-d H:i:s|1|+7 days

// Mittlere Frist: Formulardaten
value|datestamp_auto_delete|form_cleanup|Formular-Bereinigung|Y-m-d H:i:s|1|+90 days

// Lange Frist: Archivdaten
value|datestamp_auto_delete|archive_cleanup|Archiv-Bereinigung|Y-m-d H:i:s|1|+5 years
```

**Integration**: Cronjob-Addon (registriert eigene Cronjob-Typen), YForm (datestamp_auto_delete Feld, YOrm Dataset-Deletion), Extension Points (YFORM_DATA_DELETE), rex_sql (Table-Cronjob), Dateisystem (Folder-Cronjob), Console (cronjob:run), GDPR/DSGVO-Compliance
