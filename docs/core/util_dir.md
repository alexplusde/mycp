# rex_dir

**Verzeichnis-Operationen (Erstellen, Kopieren, Löschen, Schreibrechte)**

**Keywords:** directory, folder, mkdir, copy, delete, permissions

---

## Methodenübersicht

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `create()` | `string $dir`, `bool $recursive = true` | `bool` | Verzeichnis erstellen (rekursiv) |
| `isWritable()` | `string $dir` | `bool` | Prüft Schreibrechte |
| `copy()` | `string $srcdir`, `string $dstdir` | `bool` | Verzeichnis kopieren (rekursiv) |
| `delete()` | `string $dir`, `bool $deleteSelf = true` | `bool` | Verzeichnis löschen (rekursiv) |
| `deleteFiles()` | `string $dir`, `bool $recursive = true` | `bool` | Nur Dateien löschen (Ordner bleiben) |
| `deleteIterator()` | `Traversable $iterator` | `bool` | Löschen via Iterator |

---

## Praxisbeispiele

### Verzeichnis erstellen

```php
// Einfach
rex_dir::create(rex_path::addonData('myaddon', 'uploads'));

// Rekursiv (Default)
rex_dir::create(rex_path::addonData('myaddon', 'cache/subfolder'));

// Nicht-rekursiv (Parent muss existieren)
rex_dir::create('/path/to/dir', false);

// Permissions werden automatisch gesetzt via rex::getDirPerm()
// Standard: 0775
```

### Schreibrechte prüfen

```php
$dir = rex_path::addonData('myaddon');

if (rex_dir::isWritable($dir)) {
    // Verzeichnis ist beschreibbar
    rex_file::put($dir . 'test.txt', 'content');
} else {
    echo rex_view::error('Verzeichnis nicht beschreibbar: ' . $dir);
}

// Vor Datei-Operationen prüfen
if (!rex_dir::isWritable(rex_path::cache())) {
    throw new rex_exception('Cache-Verzeichnis nicht beschreibbar!');
}
```

### Verzeichnis kopieren

```php
// Komplettes Verzeichnis mit Unterverzeichnissen
$src = rex_path::addonData('myaddon', 'templates');
$dst = rex_path::addonData('myaddon', 'templates_backup');

if (rex_dir::copy($src, $dst)) {
    echo rex_view::success('Backup erstellt.');
} else {
    echo rex_view::error('Backup fehlgeschlagen.');
}

// Addon-Daten sichern
$addonData = rex_path::addonData('myaddon');
$backup = rex_path::data('backups/myaddon_' . date('Y-m-d'));
rex_dir::copy($addonData, $backup);
```

### Verzeichnis löschen

```php
// Komplettes Verzeichnis löschen
rex_dir::delete(rex_path::addonData('myaddon', 'temp'));

// Nur Inhalt löschen, Verzeichnis behalten
rex_dir::delete(rex_path::cache('myaddon'), false);

// Cache leeren
rex_dir::delete(rex_path::addonCache('myaddon'));

// Vor Deinstallation aufräumen
rex_dir::delete(rex_path::addonData('myaddon'));
```

### Nur Dateien löschen

```php
// Alle Dateien im Verzeichnis löschen, Unterordner bleiben
rex_dir::deleteFiles(rex_path::cache('myaddon'));

// Nicht-rekursiv (nur direkte Dateien)
rex_dir::deleteFiles(rex_path::media('temp'), false);

// Cache-Dateien löschen, Struktur behalten
$cacheDir = rex_path::addonCache('myaddon');
rex_dir::deleteFiles($cacheDir, true);
```

### Iterator-basiertes Löschen

```php
// Nur alte Dateien löschen (älter als 7 Tage)
$iterator = rex_finder::factory(rex_path::cache('logs'))
    ->filesOnly()
    ->ignoreSystemStuff(false);

foreach ($iterator as $file) {
    if (filemtime($file) < strtotime('-7 days')) {
        rex_file::delete($file);
    }
}

// Oder mit deleteIterator()
$oldFiles = rex_finder::factory(rex_path::cache('temp'))
    ->filesOnly()
    ->filter(function($file) {
        return filemtime($file) < strtotime('-30 days');
    });

rex_dir::deleteIterator($oldFiles);
```

### Addon-Installation

```php
// install.php
$addon = rex_addon::get('myaddon');

// Verzeichnisse erstellen
$dirs = [
    'cache',
    'uploads',
    'exports',
    'logs'
];

foreach ($dirs as $dir) {
    $path = $addon->getDataPath($dir);
    if (!rex_dir::create($path)) {
        throw new rex_functional_exception('Verzeichnis konnte nicht erstellt werden: ' . $path);
    }
}
```

### Addon-Deinstallation

```php
// uninstall.php
$addon = rex_addon::get('myaddon');

// Alle Daten löschen
rex_dir::delete($addon->getDataPath());
rex_dir::delete($addon->getCachePath());

// Addon-Assets löschen
rex_dir::delete($addon->getAssetsPath());
```

### Cache-Management

```php
// Addon-Cache leeren
public static function clearCache()
{
    $cacheDir = rex_path::addonCache('myaddon');
    
    if (rex_dir::delete($cacheDir, false)) {
        // Verzeichnis neu erstellen
        rex_dir::create($cacheDir);
        return true;
    }
    return false;
}

// Gesamten REDAXO-Cache leeren
rex_dir::delete(rex_path::cache(), false);
rex_dir::create(rex_path::cache());
```

### Backup-Rotation

```php
// Alte Backups löschen (> 5 Tage)
$backupDir = rex_path::data('backups');
$finder = rex_finder::factory($backupDir)
    ->dirsOnly()
    ->filter(function($dir) {
        return filemtime($dir) < strtotime('-5 days');
    });

rex_dir::deleteIterator($finder);

// Neues Backup erstellen
$newBackup = $backupDir . '/' . date('Y-m-d_H-i-s');
rex_dir::create($newBackup);
```

### Export-Verzeichnis vorbereiten

```php
// Export-Ordner erstellen und leeren
$exportDir = rex_path::addonData('myaddon', 'exports');

if (!rex_dir::create($exportDir)) {
    throw new rex_exception('Export-Verzeichnis konnte nicht erstellt werden.');
}

// Alte Exports löschen
rex_dir::deleteFiles($exportDir);

// Export durchführen
$exportFile = $exportDir . '/export_' . date('Y-m-d') . '.csv';
rex_file::put($exportFile, $csvContent);
```

### Upload-Handling

```php
// Upload-Verzeichnis vorbereiten
$uploadDir = rex_path::addonData('myaddon', 'uploads/' . date('Y-m'));

if (!rex_dir::create($uploadDir)) {
    echo rex_view::error('Upload-Verzeichnis konnte nicht erstellt werden.');
    exit;
}

if (!rex_dir::isWritable($uploadDir)) {
    echo rex_view::error('Upload-Verzeichnis ist nicht beschreibbar.');
    exit;
}

// Upload durchführen
if (isset($_FILES['upload'])) {
    $filename = rex_string::normalize($_FILES['upload']['name']);
    $target = $uploadDir . '/' . $filename;
    move_uploaded_file($_FILES['upload']['tmp_name'], $target);
}
```

### Temp-Verzeichnis aufräumen

```php
// Temp-Dateien älter als 1 Stunde löschen
$tempDir = rex_path::addonData('myaddon', 'temp');

$finder = rex_finder::factory($tempDir)
    ->filesOnly()
    ->filter(function($file) {
        return filemtime($file) < strtotime('-1 hour');
    });

rex_dir::deleteIterator($finder);
```

### Verzeichnis-Check vor Operationen

```php
public static function ensureDirectory($path)
{
    if (!is_dir($path)) {
        if (!rex_dir::create($path)) {
            throw new rex_exception('Verzeichnis konnte nicht erstellt werden: ' . $path);
        }
    }
    
    if (!rex_dir::isWritable($path)) {
        throw new rex_exception('Verzeichnis ist nicht beschreibbar: ' . $path);
    }
    
    return true;
}

// Verwendung
ensureDirectory(rex_path::addonData('myaddon', 'cache'));
```

### Migration: Verzeichnis umbenennen

```php
// Altes Verzeichnis auf neues kopieren und löschen
$oldDir = rex_path::addonData('myaddon', 'old_name');
$newDir = rex_path::addonData('myaddon', 'new_name');

if (is_dir($oldDir)) {
    if (rex_dir::copy($oldDir, $newDir)) {
        rex_dir::delete($oldDir);
    }
}

// Oder einfach mit rename()
rename($oldDir, $newDir);
```

### Addon-Update

```php
// update.php
$addon = rex_addon::get('myaddon');

// Neue Verzeichnisse hinzufügen (ohne alte zu löschen)
$newDirs = [
    'logs',
    'exports'
];

foreach ($newDirs as $dir) {
    rex_dir::create($addon->getDataPath($dir));
}

// Cache leeren
rex_dir::delete($addon->getCachePath(), false);
rex_dir::create($addon->getCachePath());
```

---

**Permissions:**

- Standard-Permissions via `rex::getDirPerm()` (Default: `0775`)
- `rex::getDirPerm()` kann in `config.yml` überschrieben werden
- Windows: Permissions werden ignoriert

**Best Practices:**

- ✅ Immer `rex_path::addon*()` für konsistente Pfade verwenden
- ✅ `isWritable()` vor Datei-Operationen prüfen
- ✅ `create()` ist idempotent (gibt `true` wenn bereits existiert)
- ✅ `delete()` ist sicher (gibt `true` wenn nicht existiert)
- ⚠️ `deleteFiles()` löscht **nur** Dateien, Ordner bleiben
- ⚠️ `delete()` mit `$deleteSelf = false` löscht Inhalt, nicht den Ordner selbst
- ⚠️ Keine Symlinks ohne explizite Prüfung!

**Fehlerbehandlung:**

```php
if (!rex_dir::create($path)) {
    throw new rex_functional_exception('Verzeichnis konnte nicht erstellt werden: ' . $path);
}

if (!rex_dir::isWritable($path)) {
    throw new rex_functional_exception('Verzeichnis nicht beschreibbar: ' . $path);
}
```
