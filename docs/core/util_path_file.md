# `rex_path` und `rex_file`: Dateisystem-Pfade und Datei-Operationen

Verwende `rex_path` für sichere Pfadangaben und `rex_file` für Datei-Operationen.

## rex_path - Pfade generieren

### System-Pfade

| Methode | Pfad zu | Beispiel |
|---------|---------|----------|
| `rex_path::base($file)` | REDAXO-Root | `/var/www/html/` |
| `rex_path::frontend($file)` | Frontend (Document Root) | `/var/www/html/` |
| `rex_path::backend($file)` | Backend | `/var/www/html/redaxo/` |
| `rex_path::src($file)` | Core-Source | `/var/www/html/redaxo/src/` |
| `rex_path::core($file)` | Core-Ordner | `/var/www/html/redaxo/src/core/` |
| `rex_path::data($file)` | Core-Data | `/var/www/html/redaxo/data/` |
| `rex_path::cache($file)` | Cache | `/var/www/html/redaxo/cache/` |

### Addon/Plugin-Pfade

| Methode | Pfad zu |
|---------|---------|
| `rex_path::addon($addon, $file)` | Addon-Ordner |
| `rex_path::addonData($addon, $file)` | Addon-Data |
| `rex_path::addonCache($addon, $file)` | Addon-Cache |
| `rex_path::addonAssets($addon, $file)` | Addon-Assets (öffentlich) |
| `rex_path::plugin($addon, $plugin, $file)` | Plugin-Ordner |
| `rex_path::pluginData($addon, $plugin, $file)` | Plugin-Data |
| `rex_path::pluginAssets($addon, $plugin, $file)` | Plugin-Assets |

### Media/Assets

| Methode | Pfad zu |
|---------|---------|
| `rex_path::media($file)` | Medienpool | `/var/www/html/media/` |
| `rex_path::assets($file)` | Assets-Ordner | `/var/www/html/assets/` |
| `rex_path::coreAssets($file)` | Core-Assets | `/var/www/html/assets/core/` |

### Hilfsmethoden

| Methode | Zweck |
|---------|-------|
| `rex_path::basename($path)` | Dateiname ohne Pfad |
| `rex_path::absolute($path)` | Relativen Pfad in absoluten umwandeln |
| `rex_path::relative($path)` | Absoluten Pfad in relativen umwandeln |

## rex_file - Datei-Operationen

### Lesen/Schreiben

| Methode | Zweck | Rückgabe |
|---------|-------|----------|
| `rex_file::get($file)` | Datei-Inhalt lesen | string\|null |
| `rex_file::getOutput($file)` | PHP-Datei ausführen und Output zurückgeben | string |
| `rex_file::require($file)` | PHP-Datei einbinden und Rückgabewert | mixed |
| `rex_file::put($file, $content)` | Inhalt in Datei schreiben | bool |
| `rex_file::putCache($file, $content)` | PHP-Cache-Datei schreiben (mit opcache) | bool |

### Kopieren/Löschen

| Methode | Zweck |
|---------|-------|
| `rex_file::copy($src, $dest)` | Datei kopieren |
| `rex_file::move($src, $dest)` | Datei verschieben |
| `rex_file::delete($file)` | Datei löschen |

### Erweiterung/Mime-Type

| Methode | Zweck |
|---------|-------|
| `rex_file::extension($file)` | Datei-Erweiterung |
| `rex_file::mimeType($file)` | MIME-Type |

## Praxisbeispiele

### Addon-Data-Pfad

```php
// Datei in AddonData speichern
$file = rex_path::addonData('my_addon', 'config.json');
rex_file::put($file, json_encode($config));

// Später auslesen
$config = json_decode(rex_file::get($file), true);
```

### Media-Datei verarbeiten

```php
$media = rex_media::get('logo.png');
if ($media) {
    $filePath = rex_path::media($media->getFileName());
    $fileSize = filesize($filePath);
    $mimeType = rex_file::mimeType($filePath);
}
```

### Cache-Datei schreiben

```php
// PHP-Array als Cache speichern
$cacheFile = rex_path::addonCache('my_addon', 'data.cache');
$data = ['items' => [1, 2, 3], 'count' => 3];

rex_file::putCache($cacheFile, '<?php return ' . var_export($data, true) . ';');

// Cache laden
$cachedData = rex_file::require($cacheFile);
```

### Template/Fragment einbinden

```php
// Fragment mit Output
$fragment = new rex_fragment();
$fragment->setVar('title', 'Test');
$html = $fragment->parse('my-fragment.php');

// PHP-Template direkt ausführen
$templatePath = rex_path::addon('my_addon', 'views/template.php');
$output = rex_file::getOutput($templatePath);
```

### Datei-Upload in Addon-Data

```php
$file = rex_files('upload', 'array');

if (!empty($file['tmp_name'])) {
    $filename = rex_string::normalize($file['name']);
    $destination = rex_path::addonData('my_addon', 'uploads/' . $filename);
    
    rex_file::copy($file['tmp_name'], $destination);
}
```

### Config-Datei aus Addon laden

```php
$configFile = rex_path::addon('my_addon', 'config/settings.php');

if (file_exists($configFile)) {
    $settings = rex_file::require($configFile);
}
```

### Log-Datei schreiben

```php
$logFile = rex_path::addonData('my_addon', 'logs/app.log');
$logEntry = date('Y-m-d H:i:s') . ' - ' . $message . PHP_EOL;

rex_file::put($logFile, $logEntry, FILE_APPEND);
```

### Temporäre Dateien

```php
// In Cache schreiben (wird bei Cache-Clear gelöscht)
$tempFile = rex_path::addonCache('my_addon', 'temp_' . uniqid() . '.txt');
rex_file::put($tempFile, $data);

// Später aufräumen
rex_file::delete($tempFile);
```

### Datei-Extension prüfen

```php
$filename = 'document.pdf';
$ext = rex_file::extension($filename);  // 'pdf'

$allowed = ['jpg', 'png', 'gif'];
if (!in_array($ext, $allowed)) {
    throw new Exception('Invalid file type');
}
```

### Assets-Pfade für Frontend

```php
// CSS/JS im Template
<link href="<?= rex_url::addonAssets('my_addon', 'styles.css') ?>" rel="stylesheet">
<script src="<?= rex_url::addonAssets('my_addon', 'script.js') ?>"></script>

// Dateipfad prüfen
$cssFile = rex_path::addonAssets('my_addon', 'styles.css');
if (file_exists($cssFile)) {
    $lastModified = filemtime($cssFile);
}
```

### Export-Datei generieren

```php
$csv = "Name;Email\n";
$csv .= "Max;max@example.com\n";

$exportFile = rex_path::addonData('my_addon', 'exports/users_' . date('Y-m-d') . '.csv');
rex_file::put($exportFile, $csv);

// Download-Link
$downloadUrl = rex_url::addonData('my_addon', 'exports/' . basename($exportFile));
```

### Relative/Absolute Pfade

```php
$absolute = '/var/www/html/media/image.jpg';
$relative = rex_path::relative($absolute);  // 'media/image.jpg'

$relative = 'media/logo.png';
$absolute = rex_path::absolute($relative);  // '/var/www/html/media/logo.png'
```

### Datei von URL herunterladen

```php
$response = rex_socket::factoryUrl('https://example.com/data.json')->doGet();

if ($response->isOk()) {
    $file = rex_path::addonData('my_addon', 'downloaded.json');
    rex_file::put($file, $response->getBody());
}
```

### Backup erstellen

```php
$originalFile = rex_path::addonData('my_addon', 'important.json');
$backupFile = rex_path::addonData('my_addon', 'backups/important_' . date('Ymd_His') . '.json');

rex_file::copy($originalFile, $backupFile);
```

### Alte Cache-Dateien löschen

```php
$cacheDir = rex_path::addonCache('my_addon');
$files = glob($cacheDir . '*.cache');

foreach ($files as $file) {
    if (filemtime($file) < strtotime('-1 day')) {
        rex_file::delete($file);
    }
}
```

### PHP-Konfiguration generieren

```php
$config = [
    'api_key' => 'secret123',
    'endpoint' => 'https://api.example.com',
    'timeout' => 30,
];

$configFile = rex_path::addonData('my_addon', 'config.php');
$content = '<?php' . PHP_EOL;
$content .= 'return ' . var_export($config, true) . ';';

rex_file::put($configFile, $content);

// Laden
$loadedConfig = rex_file::require($configFile);
```

## Sicherheit

**Immer `rex_path::*()` verwenden statt manuellen Strings:**

```php
// ✅ RICHTIG
$file = rex_path::addonData('my_addon', $userInput);

// ❌ FALSCH (Path Traversal möglich!)
$file = '/var/www/data/' . $userInput;
```

**Dateien in `data/` oder `cache/` speichern, nicht im Addon-Ordner:**

```php
// ✅ RICHTIG
rex_path::addonData('my_addon', 'config.json')

// ❌ FALSCH (wird bei Updates überschrieben)
rex_path::addon('my_addon', 'config.json')
```

## rex_dir - Verzeichnis-Operationen

| Methode | Zweck |
|---------|-------|
| `rex_dir::create($dir)` | Verzeichnis rekursiv erstellen |
| `rex_dir::delete($dir)` | Verzeichnis rekursiv löschen |
| `rex_dir::copy($src, $dest)` | Verzeichnis kopieren |
| `rex_dir::deleteFiles($dir, $recursive)` | Nur Dateien löschen |

```php
// Verzeichnis erstellen
rex_dir::create(rex_path::addonData('my_addon', 'uploads'));

// Verzeichnis komplett löschen
rex_dir::delete(rex_path::addonCache('my_addon'));
```
