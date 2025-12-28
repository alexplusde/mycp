# rex_logger

Keywords: Logging, PSR-3, Exception-Handling, Debug, Error-Logging, System-Log, var/log/system.log

## Übersicht

`rex_logger` implementiert PSR-3 Logger-Interface. Schreibt Exceptions, Fehler und Debug-Infos in `var/log/system.log`. Unterscheidet Log-Levels (emergency, alert, critical, error, warning, notice, info, debug). Shortcuts für Exceptions und PHP-Errors.

## Methoden

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `factory()` | - | `rex_logger` | Gibt Logger-Instanz zurück |
| `log($level, $message, $context)` | `string`, `string`, `array` | `void` | PSR-3 Standard-Log mit Context-Interpolation |
| `logException($exception)` | `Throwable` | `void` | Loggt Exception mit Stacktrace |
| `logError($errno, $errstr, $errfile, $errline)` | `int`, `string`, `string`, `int` | `void` | Loggt PHP-Error (E_WARNING, E_NOTICE etc.) |
| `emergency($message, $context)` | `string`, `array` | `void` | System ist nicht nutzbar |
| `alert($message, $context)` | `string`, `array` | `void` | Sofortiges Handeln erforderlich |
| `critical($message, $context)` | `string`, `array` | `void` | Kritische Bedingungen |
| `error($message, $context)` | `string`, `array` | `void` | Fehler ohne Systemausfall |
| `warning($message, $context)` | `string`, `array` | `void` | Warnung |
| `notice($message, $context)` | `string`, `array` | `void` | Hinweis |
| `info($message, $context)` | `string`, `array` | `void` | Informationen |
| `debug($message, $context)` | `string`, `array` | `void` | Debug-Informationen |

## Praxisbeispiele

### Exception loggen

```php
try {
    $addon = rex_addon::get('nonexistent');
} catch (rex_exception $e) {
    rex_logger::logException($e);
    echo rex_view::error('Addon nicht gefunden');
}

// Wird in var/log/system.log geschrieben:
// [YYYY-MM-DD HH:MM:SS] CRITICAL: rex_exception: Addon "nonexistent" nicht gefunden
// Stack trace: ...
```

### Addon Install/Uninstall Fehler

```php
// install.php
try {
    rex_sql_table::get('rex_myaddon_table')
        ->ensureColumn(new rex_sql_column('id', 'int(11)'))
        ->ensure();
} catch (Exception $e) {
    rex_logger::logException($e);
    return false; // Install fehlgeschlagen
}
```

### PHP-Error explizit loggen

```php
// Deprecated-Funktion nutzen, Error loggen
if (function_exists('old_function')) {
    rex_logger::logError(
        E_USER_DEPRECATED, 
        'old_function() is deprecated, use new_function()',
        __FILE__,
        __LINE__
    );
}
```

### PSR-3 Log-Levels

```php
$logger = rex_logger::factory();

// Emergency - System down
$logger->emergency('Database server offline');

// Alert - Sofortige Aktion nötig
$logger->alert('Disk space < 5%');

// Critical - Kritisch aber System läuft
$logger->critical('Payment gateway timeout');

// Error - Fehler in Addon
$logger->error('Failed to send email to user');

// Warning - Warnung
$logger->warning('Deprecated API endpoint called');

// Notice - Hinweis
$logger->notice('User login from new IP');

// Info - Information
$logger->info('Cronjob completed successfully');

// Debug - Entwickler-Infos
$logger->debug('Cache hit for key: article_123');
```

### Context-Interpolation

```php
$logger = rex_logger::factory();

// {placeholders} werden durch $context ersetzt
$logger->error('User {user_id} failed login attempt #{attempt}', [
    'user_id' => 42,
    'attempt' => 3,
]);

// Log: User 42 failed login attempt #3
```

### API-Call Fehler loggen

```php
function fetchExternalData($url) {
    try {
        $response = file_get_contents($url);
        if ($response === false) {
            throw new RuntimeException('HTTP request failed');
        }
        return json_decode($response);
    } catch (Exception $e) {
        rex_logger::logException($e);
        return null;
    }
}
```

### Datei-Upload Fehler

```php
$upload = rex_file::upload($_FILES['file'], $targetPath);

if (!$upload['success']) {
    rex_logger::factory()->error('File upload failed: {msg}', [
        'msg' => $upload['message'],
        'file' => $_FILES['file']['name'],
    ]);
    echo rex_view::error($upload['message']);
}
```

### Cronjob mit Logging

```php
class MyCronjob extends rex_cronjob {
    public function execute() {
        try {
            $processed = $this->processItems();
            rex_logger::factory()->info('Cronjob processed {count} items', [
                'count' => $processed,
            ]);
            return true;
        } catch (Exception $e) {
            rex_logger::logException($e);
            $this->setMessage($e->getMessage());
            return false;
        }
    }
}
```

### Pwned Password Check (yform_field)

```php
try {
    $response = file_get_contents("https://api.pwnedpasswords.com/...");
} catch (Exception $e) {
    rex_logger::logError(
        E_WARNING,
        'Failed to connect to pwnedpasswords.com',
        __FILE__,
        __LINE__
    );
}
```

### Bulk-Rework Fehlerbehandlung (uploader)

```php
foreach ($files as $file) {
    try {
        $this->processFile($file);
    } catch (Exception $e) {
        rex_logger::logException($e);
        continue; // Nächste Datei verarbeiten
    }
}
```

### Statistics Addon - IP2Geo Fehler

```php
try {
    $geo = $this->fetchGeoData($ip);
} catch (Exception $e) {
    rex_logger::logException($e);
    return ['country' => 'Unknown', 'city' => 'Unknown'];
}
```

### Media Manager - Responsive Fehler

```php
if (!file_exists($sourcePath)) {
    rex_logger::factory()->error('Source image not found: {path}', [
        'path' => $sourcePath,
        'media' => $mediaFile,
    ]);
    return false;
}
```

### MForm Handler Exception

```php
try {
    $value = $this->parseValue($_POST['field']);
} catch (InvalidArgumentException $e) {
    rex_logger::logException($e);
    $this->addError('Invalid field value');
}
```

### Project Manager Server Connection

```php
try {
    $client = new GuzzleHttp\Client();
    $response = $client->post($url, ['json' => $data]);
} catch (GuzzleHttp\Exception\RequestException $e) {
    rex_logger::logException($e);
    echo rex_view::error('Server nicht erreichbar');
}
```

### Debugging mit Context-Array

```php
$logger = rex_logger::factory();

$logger->debug('Article save attempt', [
    'article_id' => $article->getId(),
    'user' => rex::getUser()->getLogin(),
    'changes' => $article->getModifiedFields(),
    'timestamp' => date('Y-m-d H:i:s'),
]);
```

### Addon Boot Fehler

```php
// boot.php
try {
    if (!class_exists('SomeRequiredClass')) {
        throw new rex_exception('Required dependency missing');
    }
    $addon->includeFile('lib/autoload.php');
} catch (Exception $e) {
    rex_logger::logException($e);
}
```

### Log-File auslesen

```php
// var/log/system.log Inhalt lesen
$logFile = rex_path::log('system.log');
$lines = file($logFile, FILE_IGNORE_NEW_LINES);

// Letzte 50 Zeilen ausgeben
$recent = array_slice($lines, -50);
echo '<pre>' . implode("\n", $recent) . '</pre>';
```

### Custom Error Handler

```php
set_error_handler(function($errno, $errstr, $errfile, $errline) {
    rex_logger::logError($errno, $errstr, $errfile, $errline);
    return true; // Error handled
});

// Trigger error
trigger_error('Custom warning', E_USER_WARNING);
```

### Log-Rotation via Cronjob

```php
class LogRotateCronjob extends rex_cronjob {
    public function execute() {
        $logPath = rex_path::log('system.log');
        
        if (filesize($logPath) > 10 * 1024 * 1024) { // > 10MB
            $backupPath = rex_path::log('system_' . date('Y-m-d') . '.log');
            rename($logPath, $backupPath);
            
            rex_logger::factory()->info('Log rotated to {file}', [
                'file' => basename($backupPath),
            ]);
        }
        
        return true;
    }
}
```

### Conditional Logging (Debug-Mode)

```php
if (rex::isDebugMode()) {
    rex_logger::factory()->debug('Query executed: {sql}', [
        'sql' => $sql->getQuery(),
        'time' => $sql->getQueryTime() . 'ms',
    ]);
}
```

### Try-Catch in Extension Point

```php
rex_extension::register('PACKAGES_INCLUDED', function() {
    try {
        $config = rex_file::getCache('my_config.json');
        $parsed = json_decode($config, true);
        
        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new RuntimeException('Invalid JSON in config');
        }
        
        return $parsed;
    } catch (Exception $e) {
        rex_logger::logException($e);
        return [];
    }
});
```

### Batch-Processing mit Fehler-Tracking

```php
$errors = 0;
$success = 0;

foreach ($items as $item) {
    try {
        $this->processItem($item);
        $success++;
    } catch (Exception $e) {
        rex_logger::factory()->error('Item processing failed: {id}', [
            'id' => $item->getId(),
            'error' => $e->getMessage(),
        ]);
        $errors++;
    }
}

rex_logger::factory()->info('Batch complete: {success} success, {errors} errors', [
    'success' => $success,
    'errors' => $errors,
]);
```

### Performance-Logging

```php
$start = microtime(true);

// Lange Operation
$result = $this->heavyComputation();

$duration = microtime(true) - $start;

if ($duration > 1.0) {
    rex_logger::factory()->warning('Slow operation detected: {duration}s', [
        'duration' => round($duration, 2),
        'operation' => 'heavyComputation',
    ]);
}
```
