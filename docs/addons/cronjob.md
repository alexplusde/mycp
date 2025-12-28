# Cronjob - Zeitgesteuerte Aufgaben | Keywords: Scheduler, Automatisierung, Tasks, Intervalle, Hintergrund, Cron, Automation

**Übersicht**: Führt wiederkehrende Aufgaben automatisch nach definierten Zeitintervallen aus. Ermöglicht Backup-Routinen, E-Mail-Versand, Datenbereinigung und andere zeitgesteuerte Prozesse ohne externe Cron-Konfiguration.

## Kern-Klassen

| Klasse | Beschreibung |
|--------|-------------|
| `rex_cronjob` | Abstract base class für eigene Cronjobs |
| `rex_cronjob_manager` | Verwaltet und führt Cronjobs aus |
| `rex_command_cronjob_run` | Console-Command für Cronjob-Ausführung |
| `rex_cronjob_form` | Backend-Formular für Cronjob-Konfiguration |

## rex_cronjob-Methoden

| Methode | Rückgabe | Beschreibung |
|---------|---------|-------------|
| `execute()` | bool | Führt den Cronjob aus (abstract) |
| `getMessage()` | string | Rückgabemeldung nach Ausführung |
| `setMessage($msg)` | void | Setzt Meldung für Protokoll |
| `setParam($key, $value)` | void | Parameter setzen |
| `getParam($key, $default)` | mixed | Parameter abrufen |
| `getTypeName()` | string | Name des Cronjob-Typs |
| `getType()` | string | Cronjob-Klasse |

## rex_cronjob_manager-Methoden

| Methode | Rückgabe | Beschreibung |
|---------|---------|-------------|
| `tryExecute($id)` | bool | Führt einen Cronjob aus |
| `check()` | void | Prüft und startet fällige Cronjobs |
| `getTypes()` | array | Alle registrierten Cronjob-Typen |
| `registerType($class)` | void | Neuen Cronjob-Typ registrieren |

## Standard-Cronjob-Typen

| Typ | Beschreibung |
|-----|-------------|
| `rex_cronjob_phpcode` | PHP-Code ausführen |
| `rex_cronjob_urlrequest` | URL aufrufen |
| `rex_cronjob_article_status` | Artikel-Status automatisch ändern |
| `rex_cronjob_optimize_tables` | Datenbank-Tabellen optimieren |

## Intervall-Typen

| Typ | Beschreibung |
|-----|-------------|
| `minutes` | Alle X Minuten (1-60) |
| `hours` | Alle X Stunden (0-23) |
| `days` | Alle X Tage / bestimmte Wochentage |
| `months` | Bestimmte Monate (1-12) |

## Umgebungen

| Umgebung | Beschreibung |
|---------|-------------|
| `backend` | Wird bei Backend-Aufrufen ausgeführt |
| `frontend` | Wird bei Frontend-Aufrufen ausgeführt |
| `script` | Wird nur per CLI/Console ausgeführt |

## Praxisbeispiele

### Beispiel 1: Eigenen Cronjob erstellen

```php
// redaxo/src/addons/myaddon/lib/cronjob/cleanup.php
class rex_cronjob_myaddon_cleanup extends rex_cronjob
{
    public function execute()
    {
        // Alte Datensätze löschen
        $sql = rex_sql::factory();
        $sql->setQuery('DELETE FROM ' . rex::getTable('my_table') . ' WHERE created < DATE_SUB(NOW(), INTERVAL 30 DAY)');
        
        $count = $sql->getRows();
        $this->setMessage($count . ' alte Einträge gelöscht');
        
        return true; // Erfolg
    }
    
    public function getTypeName()
    {
        return 'Alte Einträge löschen';
    }
}
```

### Beispiel 2: Cronjob mit Parametern

```php
class rex_cronjob_email_report extends rex_cronjob
{
    public function execute()
    {
        $recipient = $this->getParam('email');
        $subject = $this->getParam('subject', 'Täglicher Report');
        
        // Report erstellen
        $content = $this->generateReport();
        
        // E-Mail versenden
        $mail = new rex_mailer();
        $mail->addAddress($recipient);
        $mail->Subject = $subject;
        $mail->Body = $content;
        
        if ($mail->send()) {
            $this->setMessage('Report an ' . $recipient . ' versendet');
            return true;
        }
        
        $this->setMessage('Fehler beim Versenden: ' . $mail->ErrorInfo);
        return false;
    }
    
    public function getTypeName()
    {
        return 'E-Mail Report versenden';
    }
    
    private function generateReport()
    {
        return 'Statistik vom ' . date('d.m.Y');
    }
}
```

### Beispiel 3: Cronjob registrieren

```php
// In boot.php des Addons
if (rex_addon::get('cronjob')->isAvailable()) {
    rex_cronjob_manager::registerType('rex_cronjob_myaddon_cleanup');
    rex_cronjob_manager::registerType('rex_cronjob_email_report');
}
```

### Beispiel 4: Cronjob per Console ausführen

```bash
# Alle fälligen Cronjobs ausführen
php redaxo/bin/console cronjob:run

# Bestimmten Cronjob ausführen (interaktive Auswahl)
php redaxo/bin/console cronjob:run --job

# Bestimmten Cronjob nach ID ausführen
php redaxo/bin/console cronjob:run --job=5
```

### Beispiel 5: Cronjob mit Zeitplan erstellen (Backend)

Im Backend unter `System` > `Cronjob`:

- Typ: `Eigener Cronjob`
- Name: `Tägliche Bereinigung`
- Beschreibung: `Löscht alte Einträge`
- Intervall: Täglich um 03:00 Uhr
- Umgebung: `script` (nur Console)
- Status: Aktiv

### Beispiel 6: Backup-Cronjob konfigurieren

```php
class rex_cronjob_auto_backup extends rex_cronjob
{
    public function execute()
    {
        $backup = new rex_backup();
        $filename = 'auto_backup_' . date('Y-m-d_H-i-s') . '.tar.gz';
        
        try {
            $backup->create($filename);
            $this->setMessage('Backup erstellt: ' . $filename);
            
            // Alte Backups löschen (älter als 7 Tage)
            $this->cleanupOldBackups(7);
            
            return true;
        } catch (Exception $e) {
            $this->setMessage('Fehler: ' . $e->getMessage());
            return false;
        }
    }
    
    private function cleanupOldBackups($days)
    {
        $path = rex_path::backup();
        $files = glob($path . 'auto_backup_*.tar.gz');
        $cutoff = time() - ($days * 24 * 60 * 60);
        
        foreach ($files as $file) {
            if (filemtime($file) < $cutoff) {
                unlink($file);
            }
        }
    }
    
    public function getTypeName()
    {
        return 'Automatisches Backup';
    }
}
```

### Beispiel 7: Cache-Cleaner Cronjob

```php
class rex_cronjob_cache_cleaner extends rex_cronjob
{
    public function execute()
    {
        rex_delete_cache();
        
        $this->setMessage('Cache geleert');
        return true;
    }
    
    public function getTypeName()
    {
        return 'Cache bereinigen';
    }
}
```

### Beispiel 8: Sitemap-Generator Cronjob

```php
class rex_cronjob_sitemap_generator extends rex_cronjob
{
    public function execute()
    {
        if (!rex_addon::get('yrewrite')->isAvailable()) {
            $this->setMessage('YRewrite nicht verfügbar');
            return false;
        }
        
        // Sitemap generieren
        rex_yrewrite::generateSitemap();
        
        $this->setMessage('Sitemap aktualisiert');
        return true;
    }
    
    public function getTypeName()
    {
        return 'Sitemap generieren';
    }
}
```

### Beispiel 9: Cronjob mit API-Abfrage

```php
class rex_cronjob_weather_update extends rex_cronjob
{
    public function execute()
    {
        $apiKey = $this->getParam('api_key');
        $city = $this->getParam('city', 'Berlin');
        
        $url = "https://api.openweathermap.org/data/2.5/weather?q={$city}&appid={$apiKey}";
        $response = file_get_contents($url);
        
        if ($response) {
            $data = json_decode($response, true);
            
            // In Datenbank speichern
            $sql = rex_sql::factory();
            $sql->setTable(rex::getTable('weather'));
            $sql->setValue('temperature', $data['main']['temp']);
            $sql->setValue('description', $data['weather'][0]['description']);
            $sql->setValue('updated', date('Y-m-d H:i:s'));
            $sql->update();
            
            $this->setMessage('Wetter aktualisiert: ' . $data['weather'][0]['description']);
            return true;
        }
        
        $this->setMessage('API-Abfrage fehlgeschlagen');
        return false;
    }
    
    public function getTypeName()
    {
        return 'Wetter aktualisieren';
    }
}
```

### Beispiel 10: Datenbank-Optimierung

```php
class rex_cronjob_optimize_db extends rex_cronjob
{
    public function execute()
    {
        $sql = rex_sql::factory();
        $tables = $sql->getTables();
        $optimized = 0;
        
        foreach ($tables as $table) {
            $sql->setQuery('OPTIMIZE TABLE `' . $table . '`');
            $optimized++;
        }
        
        $this->setMessage($optimized . ' Tabellen optimiert');
        return true;
    }
    
    public function getTypeName()
    {
        return 'Datenbank optimieren';
    }
}
```

### Beispiel 11: Artikel automatisch veröffentlichen

```php
class rex_cronjob_publish_articles extends rex_cronjob
{
    public function execute()
    {
        $sql = rex_sql::factory();
        
        // Artikel mit Veröffentlichungsdatum in der Vergangenheit
        $sql->setQuery('
            SELECT id FROM ' . rex::getTable('article') . '
            WHERE status = 0 
            AND art_publish_date <= NOW()
            AND art_publish_date IS NOT NULL
        ');
        
        $count = 0;
        foreach ($sql as $row) {
            $article = rex_article::get($row->getValue('id'));
            if ($article) {
                $article->setStatus(1);
                $article->save();
                $count++;
            }
        }
        
        $this->setMessage($count . ' Artikel veröffentlicht');
        return true;
    }
    
    public function getTypeName()
    {
        return 'Artikel automatisch veröffentlichen';
    }
}
```

### Beispiel 12: Log-Dateien bereinigen

```php
class rex_cronjob_log_cleanup extends rex_cronjob
{
    public function execute()
    {
        $logPath = rex_path::log();
        $days = (int) $this->getParam('days', 30);
        $cutoff = time() - ($days * 24 * 60 * 60);
        
        $files = glob($logPath . '*.log');
        $deleted = 0;
        
        foreach ($files as $file) {
            if (filemtime($file) < $cutoff) {
                unlink($file);
                $deleted++;
            }
        }
        
        $this->setMessage($deleted . ' Log-Dateien gelöscht');
        return true;
    }
    
    public function getTypeName()
    {
        return 'Log-Dateien bereinigen';
    }
}
```

### Beispiel 13: YForm-Daten exportieren

```php
class rex_cronjob_yform_export extends rex_cronjob
{
    public function execute()
    {
        $tableName = $this->getParam('table_name');
        
        if (!$tableName) {
            $this->setMessage('Tabellenname fehlt');
            return false;
        }
        
        $table = rex_yform_manager_table::get($tableName);
        $data = $table->query()->find();
        
        // Als CSV exportieren
        $csv = fopen(rex_path::addonData('myaddon', 'export_' . date('Y-m-d') . '.csv'), 'w');
        
        // Header
        fputcsv($csv, array_keys($data[0]->getData()));
        
        // Daten
        foreach ($data as $row) {
            fputcsv($csv, $row->getData());
        }
        
        fclose($csv);
        
        $this->setMessage('Export erstellt mit ' . count($data) . ' Einträgen');
        return true;
    }
    
    public function getTypeName()
    {
        return 'YForm-Daten exportieren';
    }
}
```

### Beispiel 14: Newsletter-Versand

```php
class rex_cronjob_newsletter extends rex_cronjob
{
    public function execute()
    {
        $sql = rex_sql::factory();
        
        // Ausstehende Newsletter
        $sql->setQuery('
            SELECT * FROM ' . rex::getTable('newsletter') . '
            WHERE status = "pending" 
            AND send_date <= NOW()
            LIMIT 1
        ');
        
        if ($sql->getRows() == 0) {
            $this->setMessage('Keine ausstehenden Newsletter');
            return true;
        }
        
        $newsletter = $sql->getRow();
        $sent = $this->sendNewsletter($newsletter);
        
        $this->setMessage($sent . ' E-Mails versendet');
        return true;
    }
    
    private function sendNewsletter($newsletter)
    {
        // Newsletter versenden...
        return 100;
    }
    
    public function getTypeName()
    {
        return 'Newsletter versenden';
    }
}
```

### Beispiel 15: Externe System-Integration

```php
class rex_cronjob_sync_external extends rex_cronjob
{
    public function execute()
    {
        $apiUrl = $this->getParam('api_url');
        $apiKey = $this->getParam('api_key');
        
        // Daten abrufen
        $ch = curl_init($apiUrl);
        curl_setopt($ch, CURLOPT_HTTPHEADER, ['Authorization: Bearer ' . $apiKey]);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $response = curl_exec($ch);
        curl_close($ch);
        
        if ($response) {
            $data = json_decode($response, true);
            $synced = $this->syncData($data);
            
            $this->setMessage($synced . ' Datensätze synchronisiert');
            return true;
        }
        
        $this->setMessage('Synchronisation fehlgeschlagen');
        return false;
    }
    
    private function syncData($data)
    {
        // Daten verarbeiten...
        return count($data);
    }
    
    public function getTypeName()
    {
        return 'Externe Daten synchronisieren';
    }
}
```

### Beispiel 16: Image-Optimization Cronjob

```php
class rex_cronjob_optimize_images extends rex_cronjob
{
    public function execute()
    {
        $sql = rex_sql::factory();
        $sql->setQuery('SELECT filename FROM ' . rex::getTable('media') . ' WHERE updatedate >= DATE_SUB(NOW(), INTERVAL 1 DAY)');
        
        $optimized = 0;
        foreach ($sql as $row) {
            $file = rex_path::media($row->getValue('filename'));
            
            if (file_exists($file) && $this->isImage($file)) {
                // Bild optimieren
                $this->optimizeImage($file);
                $optimized++;
            }
        }
        
        $this->setMessage($optimized . ' Bilder optimiert');
        return true;
    }
    
    private function isImage($file)
    {
        $ext = strtolower(pathinfo($file, PATHINFO_EXTENSION));
        return in_array($ext, ['jpg', 'jpeg', 'png', 'gif']);
    }
    
    private function optimizeImage($file)
    {
        // Optimierung mit rex_media_manager oder externem Tool
    }
    
    public function getTypeName()
    {
        return 'Bilder optimieren';
    }
}
```

### Beispiel 17: Cronjob manuell auslösen

```php
// In einem Backend-Modul oder Script
$manager = rex_cronjob_manager::factory();
$cronjobId = 5;

if ($manager->tryExecute($cronjobId)) {
    echo 'Cronjob erfolgreich ausgeführt';
} else {
    echo 'Cronjob fehlgeschlagen';
}
```

### Beispiel 18: Cronjob-Status prüfen

```php
$sql = rex_sql::factory();
$sql->setQuery('SELECT * FROM ' . rex::getTable('cronjob') . ' WHERE id = ?', [5]);

if ($sql->getRows() > 0) {
    $status = $sql->getValue('status');
    $lastRun = $sql->getValue('execution_moment');
    $nextRun = $sql->getValue('nexttime');
    
    echo 'Status: ' . ($status == 1 ? 'Aktiv' : 'Inaktiv') . '<br>';
    echo 'Letzter Lauf: ' . date('d.m.Y H:i', $lastRun) . '<br>';
    echo 'Nächster Lauf: ' . date('d.m.Y H:i', $nextRun);
}
```

### Beispiel 19: Cronjob mit Extension Point

```php
// Vor/Nach Cronjob-Ausführung
rex_extension::register('CRONJOB_PRE_EXECUTE', function($ep) {
    $cronjob = $ep->getSubject();
    rex_logger::logNotice('cronjob', 'Cronjob startet: ' . $cronjob->getTypeName());
});

rex_extension::register('CRONJOB_POST_EXECUTE', function($ep) {
    $cronjob = $ep->getSubject();
    $success = $ep->getParam('success');
    
    rex_logger::logNotice('cronjob', 'Cronjob beendet: ' . $cronjob->getTypeName() . ' (' . ($success ? 'Erfolg' : 'Fehler') . ')');
});
```

### Beispiel 20: Cronjob-Historie anzeigen

```php
$sql = rex_sql::factory();
$sql->setQuery('
    SELECT name, status, execution_moment, nexttime 
    FROM ' . rex::getTable('cronjob') . ' 
    ORDER BY execution_moment DESC
');

echo '<table>';
echo '<tr><th>Name</th><th>Status</th><th>Letzter Lauf</th><th>Nächster Lauf</th></tr>';

foreach ($sql as $row) {
    echo '<tr>';
    echo '<td>' . $row->getValue('name') . '</td>';
    echo '<td>' . ($row->getValue('status') == 1 ? 'Aktiv' : 'Inaktiv') . '</td>';
    echo '<td>' . ($row->getValue('execution_moment') ? date('d.m.Y H:i', $row->getValue('execution_moment')) : '-') . '</td>';
    echo '<td>' . date('d.m.Y H:i', $row->getValue('nexttime')) . '</td>';
    echo '</tr>';
}

echo '</table>';
```

### Beispiel 21: Cronjob mit Timeout-Handling

```php
class rex_cronjob_long_task extends rex_cronjob
{
    public function execute()
    {
        $maxTime = (int) $this->getParam('max_time', 60);
        $startTime = time();
        $processed = 0;
        
        $sql = rex_sql::factory();
        $sql->setQuery('SELECT * FROM ' . rex::getTable('my_data') . ' WHERE processed = 0 LIMIT 1000');
        
        foreach ($sql as $row) {
            // Zeitlimit prüfen
            if (time() - $startTime > $maxTime) {
                break;
            }
            
            // Verarbeitung
            $this->processRow($row);
            $processed++;
        }
        
        $this->setMessage($processed . ' Einträge verarbeitet');
        return true;
    }
    
    private function processRow($row)
    {
        // Langwierige Verarbeitung...
        sleep(1);
    }
    
    public function getTypeName()
    {
        return 'Stapelverarbeitung mit Timeout';
    }
}
```

### Beispiel 22: Fehler-Benachrichtigung bei Cronjob-Fehler

```php
rex_extension::register('CRONJOB_POST_EXECUTE', function($ep) {
    $cronjob = $ep->getSubject();
    $success = $ep->getParam('success');
    
    if (!$success) {
        $mail = new rex_mailer();
        $mail->addAddress('admin@example.com');
        $mail->Subject = 'Cronjob-Fehler: ' . $cronjob->getTypeName();
        $mail->Body = 'Fehler: ' . $cronjob->getMessage();
        $mail->send();
    }
});
```

### Beispiel 23: Cronjob mit Fortschrittsanzeige

```php
class rex_cronjob_with_progress extends rex_cronjob
{
    public function execute()
    {
        $sql = rex_sql::factory();
        $total = $sql->getArray('SELECT COUNT(*) as count FROM ' . rex::getTable('my_data'))[0]['count'];
        
        $sql->setQuery('SELECT * FROM ' . rex::getTable('my_data'));
        $processed = 0;
        
        foreach ($sql as $row) {
            $this->processRow($row);
            $processed++;
            
            // Fortschritt speichern
            if ($processed % 100 == 0) {
                $progress = round(($processed / $total) * 100);
                $this->setMessage('Fortschritt: ' . $progress . '%');
            }
        }
        
        $this->setMessage('Verarbeitung abgeschlossen: ' . $processed . ' von ' . $total);
        return true;
    }
    
    private function processRow($row)
    {
        // Verarbeitung...
    }
    
    public function getTypeName()
    {
        return 'Verarbeitung mit Fortschritt';
    }
}
```

### Beispiel 24: Server-Health-Check Cronjob

```php
class rex_cronjob_health_check extends rex_cronjob
{
    public function execute()
    {
        $checks = [
            'Database' => $this->checkDatabase(),
            'Disk Space' => $this->checkDiskSpace(),
            'Memory' => $this->checkMemory(),
        ];
        
        $failed = array_filter($checks, function($v) { return !$v; });
        
        if (count($failed) > 0) {
            $this->setMessage('Fehler: ' . implode(', ', array_keys($failed)));
            
            // Admin benachrichtigen
            $this->notifyAdmin($failed);
            
            return false;
        }
        
        $this->setMessage('Alle Checks erfolgreich');
        return true;
    }
    
    private function checkDatabase()
    {
        try {
            $sql = rex_sql::factory();
            $sql->setQuery('SELECT 1');
            return true;
        } catch (Exception $e) {
            return false;
        }
    }
    
    private function checkDiskSpace()
    {
        $free = disk_free_space(rex_path::base());
        $total = disk_total_space(rex_path::base());
        $percent = ($free / $total) * 100;
        
        return $percent > 10; // Mind. 10% frei
    }
    
    private function checkMemory()
    {
        $limit = ini_get('memory_limit');
        $usage = memory_get_usage(true);
        
        return $usage < (0.9 * $this->parseSize($limit));
    }
    
    private function parseSize($size)
    {
        $unit = strtoupper(substr($size, -1));
        $size = (int) substr($size, 0, -1);
        
        switch ($unit) {
            case 'G': return $size * 1024 * 1024 * 1024;
            case 'M': return $size * 1024 * 1024;
            case 'K': return $size * 1024;
            default: return $size;
        }
    }
    
    private function notifyAdmin($failed)
    {
        // E-Mail an Admin
    }
    
    public function getTypeName()
    {
        return 'Server Health Check';
    }
}
```

### Beispiel 25: Cronjob programmatisch erstellen

```php
// Neuen Cronjob anlegen
$sql = rex_sql::factory();
$sql->setTable(rex::getTable('cronjob'));
$sql->setValue('name', 'Tägliche Bereinigung');
$sql->setValue('type', 'rex_cronjob_myaddon_cleanup');
$sql->setValue('environment', '|1|'); // Backend
$sql->setValue('interval', '{"days":"all","hours":"03","minutes":"00"}');
$sql->setValue('status', 1);
$sql->setValue('createdate', date('Y-m-d H:i:s'));
$sql->setValue('createuser', rex::getUser()->getLogin());
$sql->insert();
```

### Beispiel 26: Cronjob deaktivieren

```php
$cronjobId = 5;
$sql = rex_sql::factory();
$sql->setTable(rex::getTable('cronjob'));
$sql->setWhere(['id' => $cronjobId]);
$sql->setValue('status', 0);
$sql->update();
```

### Beispiel 27: Cronjob-Intervall ändern

```php
$cronjobId = 5;
$sql = rex_sql::factory();
$sql->setTable(rex::getTable('cronjob'));
$sql->setWhere(['id' => $cronjobId]);

// Täglich um 03:00 Uhr
$interval = json_encode([
    'days' => 'all',
    'hours' => '03',
    'minutes' => '00'
]);

$sql->setValue('interval', $interval);
$sql->update();
```

### Beispiel 28: Cronjob-Logging erweitern

```php
class rex_cronjob_with_logging extends rex_cronjob
{
    public function execute()
    {
        $this->log('Cronjob gestartet');
        
        try {
            // Aufgabe ausführen
            $result = $this->performTask();
            
            $this->log('Aufgabe erfolgreich: ' . $result);
            $this->setMessage('Erfolg: ' . $result);
            
            return true;
        } catch (Exception $e) {
            $this->log('Fehler: ' . $e->getMessage(), 'error');
            $this->setMessage('Fehler: ' . $e->getMessage());
            
            return false;
        }
    }
    
    private function log($message, $level = 'info')
    {
        rex_logger::factory()->log($level, $message, [], __FILE__, __LINE__);
    }
    
    private function performTask()
    {
        return 'Task completed';
    }
    
    public function getTypeName()
    {
        return 'Cronjob mit erweitertem Logging';
    }
}
```

### Beispiel 29: Cronjob-Abhängigkeiten prüfen

```php
class rex_cronjob_with_dependencies extends rex_cronjob
{
    public function execute()
    {
        // Prüfe ob andere Cronjobs zuerst laufen müssen
        if (!$this->checkDependencies()) {
            $this->setMessage('Abhängigkeiten nicht erfüllt');
            return false;
        }
        
        // Hauptaufgabe
        $this->performTask();
        
        $this->setMessage('Aufgabe abgeschlossen');
        return true;
    }
    
    private function checkDependencies()
    {
        $sql = rex_sql::factory();
        
        // Prüfe ob Backup-Job heute bereits gelaufen ist
        $sql->setQuery('
            SELECT execution_moment 
            FROM ' . rex::getTable('cronjob') . ' 
            WHERE name = "Backup" 
            AND DATE(FROM_UNIXTIME(execution_moment)) = CURDATE()
        ');
        
        return $sql->getRows() > 0;
    }
    
    private function performTask()
    {
        // Aufgabe...
    }
    
    public function getTypeName()
    {
        return 'Cronjob mit Abhängigkeiten';
    }
}
```

### Beispiel 30: Dynamisches Intervall basierend auf Last

```php
class rex_cronjob_adaptive extends rex_cronjob
{
    public function execute()
    {
        $load = sys_getloadavg()[0];
        
        // Bei hoher Last weniger häufig ausführen
        if ($load > 2.0) {
            $this->adjustInterval(60); // 60 Minuten
            $this->setMessage('Hohe Last erkannt, Intervall angepasst');
            return true;
        }
        
        // Bei niedriger Last häufiger ausführen
        if ($load < 0.5) {
            $this->adjustInterval(5); // 5 Minuten
        }
        
        // Normale Verarbeitung
        $this->performTask();
        
        $this->setMessage('Aufgabe abgeschlossen bei Load: ' . $load);
        return true;
    }
    
    private function adjustInterval($minutes)
    {
        $sql = rex_sql::factory();
        $sql->setTable(rex::getTable('cronjob'));
        $sql->setWhere(['type' => get_class($this)]);
        
        $interval = json_encode([
            'minutes' => (string) $minutes
        ]);
        
        $sql->setValue('interval', $interval);
        $sql->update();
    }
    
    private function performTask()
    {
        // Aufgabe...
    }
    
    public function getTypeName()
    {
        return 'Adaptiver Cronjob';
    }
}
```

**Integration**: Backend-System, Console-Commands, Extension Points (CRONJOB_PRE_EXECUTE, CRONJOB_POST_EXECUTE), rex_logger, rex_mailer, Backup-Addon, YForm, rex_sql, Externe APIs via CURL
