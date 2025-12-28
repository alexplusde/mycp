# Package Manager

**Keywords:** Package Addon Plugin Install Uninstall Activate Manager Dependency Requirements

## Übersicht

Package-Manager für Installation, Deinstallation, Aktivierung und Dependency-Management von Addons/Plugins.

## Methoden

### rex_package_manager (Abstract Base)

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `::factory($package)` | rex_package | rex_addon_manager\|rex_plugin_manager | Factory (erkennt Addon/Plugin) |
| `install($installDump)` | bool | bool | Installiert Package (install.php + install.sql) |
| `uninstall($installDump)` | bool | bool | Deinstalliert Package (uninstall.php + uninstall.sql) |
| `activate()` | - | bool | Aktiviert Package (prüft Requirements) |
| `deactivate()` | - | bool | Deaktiviert Package (prüft Dependencies) |
| `delete()` | - | bool | Löscht Package-Dateien (deinstalliert vorher) |
| `getMessage()` | - | string | Letzte Statusmeldung (Erfolg/Fehler) |
| `checkRequirements()` | - | bool | Prüft Requirements (REDAXO-Version, Packages, PHP-Extensions) |
| `checkDependencies()` | - | bool | Prüft ob andere Packages abhängig sind |
| `checkConflicts()` | - | bool | Prüft Conflicts (incompatible Packages) |
| `::generatePackageOrder()` | - | void | Generiert package.order.cache.inc |
| `::synchronizeWithFileSystem()` | - | void | Scannt Filesystem nach neuen Packages |
| `::saveConfig()` | - | void | Speichert config.yml aller Packages |

### rex_addon_manager

Extends `rex_package_manager` für Addons - keine zusätzlichen Methoden.

### rex_plugin_manager

Extends `rex_package_manager` für Plugins - prüft zusätzlich ob Addon verfügbar.

## Praxisbeispiele

### Package installieren

```php
// Addon installieren
$addon = rex_addon::get('yform');
$manager = rex_package_manager::factory($addon);

if ($manager->install()) {
    echo $manager->getMessage(); // "Addon 'YForm' erfolgreich installiert"
} else {
    echo $manager->getMessage(); // Fehlermeldung
}

// Plugin installieren
$plugin = rex_plugin::get('yform', 'manager');
$manager = rex_package_manager::factory($plugin);

if ($manager->install()) {
    echo 'Plugin installiert';
} else {
    echo 'Fehler: ' . $manager->getMessage();
}
```

### Install ohne SQL-Dump

```php
// Installation ohne install.sql Import
$addon = rex_addon::get('myAddon');
$manager = rex_package_manager::factory($addon);

// $installDump = false
if ($manager->install(false)) {
    echo 'Installiert ohne SQL-Import';
}

// Nützlich wenn:
// - SQL manuell importiert wird
// - Nur PHP-Code ausgeführt werden soll
// - Custom Setup über install.php
```

### Package deinstallieren

```php
$addon = rex_addon::get('debug');
$manager = rex_package_manager::factory($addon);

if ($manager->uninstall()) {
    echo $manager->getMessage();
} else {
    echo 'Fehler: ' . $manager->getMessage();
}

// Schritte bei Uninstall:
// 1. Deaktivieren (falls aktiv)
// 2. uninstall.php ausführen
// 3. uninstall.sql importieren
// 4. Assets löschen
// 5. Cache löschen
// 6. rex_config-Namespace löschen
```

### Package aktivieren

```php
$addon = rex_addon::get('cronjob');
$manager = rex_package_manager::factory($addon);

if ($manager->activate()) {
    echo 'Aktiviert';
} else {
    echo 'Fehler: ' . $manager->getMessage();
    // z.B. "Requirements nicht erfüllt"
}

// Prüft vor Aktivierung:
// - Package ist installiert
// - Requirements erfüllt (REDAXO-Version, Dependencies, PHP-Extensions)
// - Keine Conflicts
```

### Package deaktivieren

```php
$addon = rex_addon::get('debug');
$manager = rex_package_manager::factory($addon);

if ($manager->deactivate()) {
    echo 'Deaktiviert';
} else {
    echo 'Fehler: ' . $manager->getMessage();
    // z.B. "Andere Packages sind abhängig"
}

// Prüft Dependencies:
// - Kein anderes Package benötigt dieses
// - Löscht Cache
// - Aktualisiert package.order
```

### Package löschen

```php
$addon = rex_addon::get('old_addon');
$manager = rex_package_manager::factory($addon);

if ($manager->delete()) {
    echo 'Gelöscht';
} else {
    echo 'Fehler: ' . $manager->getMessage();
}

// Workflow:
// 1. Falls installiert: Uninstall
// 2. Löscht komplettes Package-Verzeichnis
// 3. synchronizeWithFileSystem()
// 4. saveConfig()
```

### Requirements prüfen

```php
$addon = rex_addon::get('myAddon');
$manager = rex_package_manager::factory($addon);

if ($manager->checkRequirements()) {
    echo 'Requirements erfüllt';
} else {
    echo $manager->getMessage();
    // z.B. "REDAXO Version 5.15 erforderlich"
    // oder "PHP Extension 'gd' fehlt"
    // oder "Addon 'phpmailer' nicht installiert"
}

// Prüft (aus package.yml):
// - redaxo: '^5.15'
// - php: { version: '^8.0', extensions: ['gd', 'intl'] }
// - packages: { phpmailer: '^3.0', yform: '^4.0' }
```

### Dependencies prüfen

```php
$addon = rex_addon::get('phpmailer');
$manager = rex_package_manager::factory($addon);

if ($manager->checkDependencies()) {
    echo 'Kann deaktiviert werden';
} else {
    echo $manager->getMessage();
    // "Addon 'yform' ist abhängig von 'phpmailer'"
}

// Prüft ob andere Packages dieses Package in 'requires' haben
// Verhindert Deaktivierung wenn Dependencies existieren
```

### Conflicts prüfen

```php
$addon = rex_addon::get('my_new_addon');
$manager = rex_package_manager::factory($addon);

if ($manager->checkConflicts()) {
    echo 'Keine Conflicts';
} else {
    echo $manager->getMessage();
    // "Conflict mit Addon 'old_addon'"
}

// Prüft (aus package.yml):
// conflicts:
//     old_addon: '*'
//     competitor_addon: '>=2.0'
```

### Installation mit Error-Handling

```php
$addon = rex_addon::get('complex_addon');
$manager = rex_package_manager::factory($addon);

try {
    if ($manager->install()) {
        echo rex_view::success($manager->getMessage());
        
        // Post-Install Tasks
        rex_delete_cache();
        rex_addon::get('complex_addon')->setConfig('installed_at', time());
        
    } else {
        echo rex_view::error($manager->getMessage());
        
        // Log Fehler
        rex_logger::factory()->error('Installation failed', [
            'addon' => $addon->getName(),
            'error' => $manager->getMessage()
        ]);
    }
} catch (Exception $e) {
    echo rex_view::error('Exception: ' . $e->getMessage());
}
```

### Batch-Installation

```php
// Mehrere Addons installieren
$addons = ['phpmailer', 'yform', 'cronjob', 'yrewrite'];
$failed = [];

foreach ($addons as $addonName) {
    $addon = rex_addon::get($addonName);
    $manager = rex_package_manager::factory($addon);
    
    if (!$manager->install()) {
        $failed[$addonName] = $manager->getMessage();
    }
}

if ($failed) {
    echo 'Fehler bei: ' . implode(', ', array_keys($failed));
} else {
    echo 'Alle Addons installiert';
}
```

### Update-Script ausführen

```php
// Nach Addon-Update: Update-Script manuell triggern
$addon = rex_addon::get('yform');

// Update-Script existiert?
$updateScript = $addon->getPath('update.php');
if (file_exists($updateScript)) {
    // Backup current version
    $oldVersion = $addon->getVersion();
    
    // Execute update
    $addon->includeFile('update.php');
    
    // Check for errors
    if ($updateMsg = $addon->getProperty('updatemsg')) {
        echo 'Update-Fehler: ' . $updateMsg;
    } else {
        echo 'Updated von ' . $oldVersion . ' zu ' . $addon->getVersion();
    }
}
```

### Package-Order generieren

```php
// package.order.cache.inc neu generieren
rex_package_manager::generatePackageOrder();

// Erstellt Lade-Reihenfolge basierend auf Dependencies
// Wichtig nach:
// - Installation/Deinstallation
// - Aktivierung/Deaktivierung
// - Manuellen package.yml Änderungen
```

### Filesystem synchronisieren

```php
// Neue Addons im Filesystem erkennen
rex_package_manager::synchronizeWithFileSystem();

// Scannt:
// - redaxo/src/addons/
// - redaxo/src/addons/*/plugins/
// 
// Registriert neue Packages in $REX['ADDON']
// Wird automatisch aufgerufen nach delete()
```

### Config speichern

```php
// Alle package.yml schreiben
rex_package_manager::saveConfig();

// Schreibt für jedes Package:
// - status (true/false)
// - install (true/false)
// - version
// 
// In: redaxo/data/core/config.yml
```

### Installation mit Custom Requirements

```php
// In install.php: Eigene Requirements prüfen
// Vor Installation durch Manager

$addon = rex_addon::get('myAddon');

// Mindestens PHP 8.1?
if (version_compare(PHP_VERSION, '8.1', '<')) {
    $addon->setProperty('installmsg', 'PHP 8.1 oder höher erforderlich');
    return; // Stoppt Installation
}

// MySQL 5.7+?
$sql = rex_sql::factory();
$version = $sql->getDbVersion();
if (version_compare($version, '5.7', '<')) {
    $addon->setProperty('installmsg', 'MySQL 5.7+ erforderlich');
    return;
}

// Custom Check
if (!function_exists('imagick')) {
    $addon->setProperty('installmsg', 'ImageMagick PHP-Extension fehlt');
    return;
}

// Success-Message setzen (optional)
$addon->setProperty('successmsg', 'Bitte API-Key in den Einstellungen konfigurieren');
```

### Uninstall mit Cleanup

```php
// In uninstall.php: Gründliches Cleanup

$addon = rex_addon::get('myAddon');

// 1. Config löschen (wird automatisch gemacht)
// rex_config::removeNamespace('myAddon');

// 2. Custom Dateien löschen
rex_dir::delete(rex_path::addonData('myAddon', 'uploads/'));
rex_file::delete(rex_path::addonData('myAddon', 'cache.json'));

// 3. Cronjobs löschen (wenn Cronjob-Addon vorhanden)
if (rex_addon::get('cronjob')->isAvailable()) {
    $sql = rex_sql::factory();
    $sql->setQuery('DELETE FROM rex_cronjob WHERE environment = ?', ['myAddon']);
}

// 4. YForm-Tables löschen (wenn YForm vorhanden)
if (rex_addon::get('yform')->isAvailable()) {
    rex_yform_manager_table::deleteTable('rex_myAddon_items');
}

// 5. Media-Kategorie löschen
$sql = rex_sql::factory();
$sql->setQuery('DELETE FROM rex_media_category WHERE name = ?', ['myAddon']);

// Error setzen wenn nötig
if ($someError) {
    $addon->setProperty('installmsg', 'Fehler beim Cleanup');
}
```

### Plugin-Installation mit Addon-Check

```php
// Plugin installieren - prüft automatisch ob Addon verfügbar

$plugin = rex_plugin::get('yform', 'manager');
$manager = rex_package_manager::factory($plugin);

// Wirft Fehler wenn Addon nicht verfügbar:
// "Addon 'YForm' muss installiert und aktiviert sein"
if ($manager->install()) {
    echo 'Plugin installiert';
}
```

### Reinstallation

```php
// Package reinstallieren (Uninstall + Install)

$addon = rex_addon::get('myAddon');
$manager = rex_package_manager::factory($addon);

// 1. Uninstall
if (!$manager->uninstall()) {
    echo 'Uninstall fehlgeschlagen: ' . $manager->getMessage();
    exit;
}

// 2. Install
if (!$manager->install()) {
    echo 'Install fehlgeschlagen: ' . $manager->getMessage();
    exit;
}

echo 'Reinstallation erfolgreich';
```

### Installation in Extension Point

```php
// Package programmatisch nach anderem Package installieren

rex_extension::register('PACKAGES_INCLUDED', function() {
    // Wenn 'phpmailer' verfügbar, installiere 'myMailer'
    if (rex_addon::get('phpmailer')->isAvailable()) {
        $myMailer = rex_addon::get('myMailer');
        
        if (!$myMailer->isInstalled()) {
            $manager = rex_package_manager::factory($myMailer);
            $manager->install();
        }
    }
});
```

### Setup-Assistant

```php
// Multi-Step Setup-Prozess

class myAddon_setup {
    public static function install() {
        $addon = rex_addon::get('myAddon');
        $manager = rex_package_manager::factory($addon);
        
        // Step 1: Install
        if (!$manager->install()) {
            return ['success' => false, 'message' => $manager->getMessage()];
        }
        
        // Step 2: Default Config
        $addon->setConfig('api_key', '');
        $addon->setConfig('mode', 'test');
        
        // Step 3: Create Directories
        rex_dir::create($addon->getDataPath('uploads'));
        rex_dir::create($addon->getDataPath('cache'));
        
        // Step 4: Import Demo Data (optional)
        if ($_POST['import_demo']) {
            $sql = rex_sql::factory();
            $sql->setQuery('INSERT INTO rex_myAddon_items ...');
        }
        
        return ['success' => true, 'message' => 'Setup abgeschlossen'];
    }
}
```

### Upgrade-Migration

```php
// In update.php: Migration von alter zu neuer Version

$addon = rex_addon::get('myAddon');
$currentVersion = $addon->getVersion();
$savedVersion = $addon->getConfig('version', '1.0.0');

// Von 1.x zu 2.x
if (version_compare($savedVersion, '2.0.0', '<')) {
    // DB-Schema ändern
    $sql = rex_sql::factory();
    $sql->setQuery('ALTER TABLE rex_myAddon_items ADD COLUMN new_field VARCHAR(255)');
    
    // Config migrieren
    $oldValue = $addon->getConfig('old_setting');
    $addon->setConfig('new_setting', $oldValue);
    $addon->removeConfig('old_setting');
    
    // Daten migrieren
    rex_sql::factory()->setQuery('UPDATE rex_myAddon_items SET new_field = old_field');
}

// Von 2.0.x zu 2.1.x
if (version_compare($savedVersion, '2.1.0', '<')) {
    // Kleinere Änderungen
    $addon->setConfig('feature_enabled', true);
}

// Version speichern
$addon->setConfig('version', $currentVersion);
```

### System-Package-Schutz

```php
// System-Packages können nicht gelöscht werden

$backup = rex_addon::get('backup');

if ($backup->isSystemPackage()) {
    echo 'System-Package - Löschen nicht erlaubt';
}

$manager = rex_package_manager::factory($backup);
if (!$manager->delete()) {
    echo $manager->getMessage(); // "Systempackage darf nicht gelöscht werden"
}

// System-Packages (aus package.yml):
// system_package: true
```

### Package-Status-Report

```php
// Status aller Packages

$packages = rex_package::getAvailablePackages();
$report = [];

foreach ($packages as $package) {
    $manager = rex_package_manager::factory($package);
    
    $report[] = [
        'id' => $package->getPackageId(),
        'name' => $package->getName(),
        'version' => $package->getVersion(),
        'installed' => $package->isInstalled(),
        'available' => $package->isAvailable(),
        'system' => $package->isSystemPackage(),
        'requirements_ok' => $manager->checkRequirements(),
        'conflicts' => !$manager->checkConflicts()
    ];
}

// JSON ausgeben für Monitoring
echo json_encode($report, JSON_PRETTY_PRINT);
```

### Dependency-Graph

```php
// Package-Dependencies visualisieren

function getPackageDependencies($packageId) {
    $package = rex_package::get($packageId);
    $requires = $package->getProperty('requires', []);
    
    $deps = [];
    if (isset($requires['packages'])) {
        foreach ($requires['packages'] as $depId => $version) {
            $deps[$depId] = [
                'version' => $version,
                'installed' => rex_package::get($depId)->isAvailable(),
                'dependencies' => getPackageDependencies($depId) // Recursive
            ];
        }
    }
    
    return $deps;
}

$deps = getPackageDependencies('yform');
print_r($deps);

// Output:
// [
//     'phpmailer' => [
//         'version' => '^3.0',
//         'installed' => true,
//         'dependencies' => []
//     ]
// ]
```

### Installation Guard

```php
// Sichere Installation mit Rollback bei Fehler

function safeInstall($addonName) {
    $addon = rex_addon::get($addonName);
    $manager = rex_package_manager::factory($addon);
    
    // Backup current state
    $wasInstalled = $addon->isInstalled();
    $wasActive = $addon->isAvailable();
    
    try {
        // Attempt install
        if (!$manager->install()) {
            throw new Exception($manager->getMessage());
        }
        
        // Verify installation
        if (!$addon->isInstalled()) {
            throw new Exception('Installation verification failed');
        }
        
        // Run smoke tests
        if (!runSmokeTests($addon)) {
            throw new Exception('Smoke tests failed');
        }
        
        return true;
        
    } catch (Exception $e) {
        // Rollback
        if (!$wasInstalled) {
            $manager->uninstall();
        }
        if (!$wasActive) {
            $manager->deactivate();
        }
        
        rex_logger::factory()->error('Installation failed: ' . $e->getMessage());
        return false;
    }
}
```

### Asset-Management nach Installation

```php
// Nach Installation: Assets verarbeiten

$addon = rex_addon::get('myAddon');

// Assets wurden kopiert von:
// redaxo/src/addons/myAddon/assets/
// nach:
// assets/addons/myAddon/

// SCSS kompilieren
if (file_exists($addon->getAssetsPath('styles.scss'))) {
    $compiler = new ScssPhp\ScssPhp\Compiler();
    $css = $compiler->compile(file_get_contents($addon->getAssetsPath('styles.scss')));
    rex_file::put($addon->getAssetsPath('styles.css'), $css);
}

// JS minifizieren
if (file_exists($addon->getAssetsPath('script.js'))) {
    $minifier = new MatthiasMullie\Minify\JS($addon->getAssetsPath('script.js'));
    $minifier->minify($addon->getAssetsPath('script.min.js'));
}
```

### Aktivierung mit Late-Init

```php
// Package aktivieren nachdem alle anderen Packages geladen sind

rex_extension::register('PACKAGES_INCLUDED', function() {
    $addon = rex_addon::get('late_init_addon');
    
    if ($addon->isInstalled() && !$addon->isAvailable()) {
        $manager = rex_package_manager::factory($addon);
        
        if ($manager->activate()) {
            rex_logger::factory()->info('Late activation successful');
        }
    }
}, rex_extension::LATE);
```
