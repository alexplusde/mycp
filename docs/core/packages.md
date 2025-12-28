# rex_package, rex_addon, rex_plugin

Keywords: Addons, Plugins, Package-Management, Install, Uninstall, Config, Properties, package.yml

## Übersicht

**rex_package**: Abstrakte Basisklasse für Addons+Plugins. Verwaltet Properties (`package.yml`), Config (DB via `rex_config`), Paths, Verfügbarkeit (install/status). Methoden: `getConfig()`, `setProperty()`, `isAvailable()`, `includeFile()`.

**rex_addon**: Repräsentiert Addon mit Plugins. Statische Methoden: `get($name)`, `exists($name)`, `getAvailableAddons()`. Plugin-Management: `getPlugin($name)`, `getAvailablePlugins()`.

**rex_plugin**: Plugin eines Addons. Ähnliche API wie rex_addon, zusätzlich `getAddon()`. Package-ID: `addonname/pluginname`.

## rex_package Methoden

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `get($packageId)` | `string` | `rex_package` | Gibt Addon/Plugin zurück (`myaddon` oder `myaddon/plugin`) |
| `require($packageId)` | `string` | `rex_package` | Wie `get()`, wirft Exception wenn nicht existiert |
| `exists($packageId)` | `string` | `bool` | Prüft ob Package existiert |
| `getPackageId()` | - | `string` | Vollständige ID (`addon` oder `addon/plugin`) |
| `getName()` | - | `string` | Name ohne Addon-Prefix (bei Plugins) |
| `getPath($file)` | `string` | `string` | Pfad zu Datei im Package |
| `getDataPath($file)` | `string` | `string` | Pfad zu `var/data/addons/{package}/` |
| `getCachePath($file)` | `string` | `string` | Pfad zu `var/cache/addons/{package}/` |
| `getAssetsPath($file)` | `string` | `string` | Pfad zu `assets/addons/{package}/` |
| `getAssetsUrl($file)` | `string` | `string` | URL zu Assets |
| `setConfig($key, $value)` | `string`, `mixed` | `bool` | Speichert Config in DB (persistent) |
| `getConfig($key, $default)` | `string`, `mixed` | `mixed` | Gibt Config-Wert zurück |
| `hasConfig($key)` | `string` | `bool` | Prüft ob Config existiert |
| `removeConfig($key)` | `string` | `bool` | Löscht Config-Eintrag |
| `setProperty($key, $value)` | `string`, `mixed` | `void` | Setzt Property (Laufzeit, nicht persistent) |
| `getProperty($key, $default)` | `string`, `mixed` | `mixed` | Gibt Property zurück (`package.yml` oder Runtime) |
| `hasProperty($key)` | `string` | `bool` | Prüft ob Property existiert |
| `removeProperty($key)` | `string` | `void` | Löscht Runtime-Property |
| `isAvailable()` | - | `bool` | Prüft ob installiert UND aktiviert (`status=1`) |
| `isInstalled()` | - | `bool` | Prüft ob installiert (`install=1`) |
| `getAuthor($default)` | `mixed` | `string` | Autor aus `package.yml` |
| `getVersion($format)` | `string` | `string` | Version (optional formatiert) |
| `getSupportPage($default)` | `mixed` | `string` | Support-URL aus `package.yml` |
| `includeFile($file, $context)` | `string`, `array` | `mixed` | Inkludiert Datei mit Context-Variablen |
| `loadProperties($force)` | `bool` | `void` | Lädt `package.yml` Properties |

## rex_addon Methoden (zusätzlich)

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `get($name)` | `string` | `rex_addon` | Gibt Addon zurück (immer Objekt, auch bei nicht-existierend) |
| `require($name)` | `string` | `rex_addon` | Wirft Exception wenn Addon nicht existiert |
| `exists($name)` | `string` | `bool` | Prüft ob Addon existiert |
| `getRegisteredAddons()` | - | `array` | Gibt alle registrierten Addons |
| `getAvailableAddons()` | - | `array` | Gibt installierte+aktivierte Addons |
| `getSetupAddons()` | - | `array` | Gibt Setup-relevante Addons (Safe Mode) |
| `getSystemPlugins()` | - | `array` | Gibt System-Plugins des Addons |
| `getAvailablePlugins()` | - | `array` | Gibt verfügbare Plugins |
| `getPlugin($name)` | `string` | `rex_plugin` | Gibt Plugin zurück |
| `requirePlugin($name)` | `string` | `rex_plugin` | Wirft Exception wenn Plugin fehlt |
| `pluginExists($name)` | `string` | `bool` | Prüft ob Plugin existiert |

## rex_plugin Methoden (zusätzlich)

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `get($addon, $plugin)` | `string`, `string` | `rex_plugin` | Gibt Plugin zurück |
| `require($addon, $plugin)` | `string`, `string` | `rex_plugin` | Wirft Exception wenn fehlt |
| `exists($addon, $plugin)` | `string`, `string` | `bool` | Prüft ob Plugin existiert |
| `getAddon()` | - | `rex_addon` | Gibt Parent-Addon zurück |

## Praxisbeispiele

### Addon holen

```php
// Addon-Objekt holen (existiert immer, auch wenn nicht installiert)
$addon = rex_addon::get('myaddon');

// Mit Exception wenn nicht existiert
try {
    $addon = rex_addon::require('myaddon');
} catch (RuntimeException $e) {
    echo 'Addon nicht vorhanden';
}

// Existenz prüfen
if (rex_addon::exists('myaddon')) {
    $addon = rex_addon::get('myaddon');
}
```

### Plugin holen

```php
// Plugin direkt
$plugin = rex_plugin::get('myaddon', 'myplugin');

// Über Addon
$addon = rex_addon::get('myaddon');
$plugin = $addon->getPlugin('myplugin');

// Plugin existiert?
if (rex_plugin::exists('myaddon', 'myplugin')) {
    $plugin = rex_plugin::get('myaddon', 'myplugin');
}

// Parent-Addon
$addon = $plugin->getAddon();
```

### Package via ID (Addon oder Plugin)

```php
// Universal: Addon ODER Plugin
$package = rex_package::get('myaddon'); // Addon
$package = rex_package::get('yform/manager'); // Plugin

// Package-ID
echo $package->getPackageId(); // "myaddon" oder "yform/manager"
```

### Verfügbarkeit prüfen

```php
// Installiert UND aktiviert?
if ($addon->isAvailable()) {
    // Addon kann genutzt werden
}

// Nur installiert? (egal ob aktiviert)
if ($addon->isInstalled()) {
    // Addon ist installiert
}

// Status-Property
$status = $addon->getProperty('status'); // true = online, false = offline
```

### Config (persistent, DB)

```php
// Config speichern (rex_config Tabelle)
$addon->setConfig('max_items', 100);
$addon->setConfig('api_key', 'abc123');

// Config abrufen
$maxItems = $addon->getConfig('max_items', 10); // Default: 10
$apiKey = $addon->getConfig('api_key');

// Existenz prüfen
if ($addon->hasConfig('api_key')) {
    echo 'API-Key vorhanden';
}

// Config löschen
$addon->removeConfig('old_setting');

// Alle Configs
$allConfig = $addon->getConfig(); // Array
```

### Properties (package.yml + Runtime)

```php
// Properties aus package.yml
$version = $addon->getProperty('version'); // "1.2.3"
$author = $addon->getAuthor(); // "Max Mustermann"
$supportPage = $addon->getSupportPage(); // "https://..."

// Runtime-Property setzen (nicht persistent!)
$addon->setProperty('temp_data', ['foo' => 'bar']);

// Property abrufen
$data = $addon->getProperty('temp_data');

// Existenz
if ($addon->hasProperty('temp_data')) {
    // ...
}
```

### Version abrufen

```php
// Einfach
$version = $addon->getVersion(); // "1.2.3"

// Formatiert
$version = $addon->getVersion('x.x'); // "1.2"
```

### Pfade

```php
// Addon-Verzeichnis
$path = $addon->getPath(); // "/pfad/src/addons/myaddon/"
$path = $addon->getPath('lib/MyClass.php'); // "/pfad/src/addons/myaddon/lib/MyClass.php"

// Data-Verzeichnis
$dataPath = $addon->getDataPath('uploads/'); // "/pfad/var/data/addons/myaddon/uploads/"

// Cache-Verzeichnis
$cachePath = $addon->getCachePath('temp.cache'); // "/pfad/var/cache/addons/myaddon/temp.cache"

// Assets-Verzeichnis
$assetsPath = $addon->getAssetsPath('script.js'); // "/pfad/assets/addons/myaddon/script.js"

// Assets-URL
$assetsUrl = $addon->getAssetsUrl('style.css'); // "/assets/addons/myaddon/style.css"
```

### Datei inkludieren

```php
// Datei mit Context-Variablen
$result = $addon->includeFile('lib/functions.php', [
    'foo' => 'bar',
    'count' => 42,
]);

// In der Datei: $foo und $count verfügbar
// extract($__context, EXTR_SKIP) macht Variablen verfügbar
```

### Addon-Liste

```php
// Alle registrierten Addons
$allAddons = rex_addon::getRegisteredAddons();

// Nur verfügbare (installed + status)
$availableAddons = rex_addon::getAvailableAddons();

foreach ($availableAddons as $addon) {
    echo $addon->getName() . ' ' . $addon->getVersion() . '<br>';
}

// Setup-Addons (Safe Mode)
$setupAddons = rex_addon::getSetupAddons();
```

### Plugin-Liste

```php
$addon = rex_addon::get('yform');

// Alle verfügbaren Plugins
$plugins = $addon->getAvailablePlugins();

foreach ($plugins as $plugin) {
    echo $plugin->getName() . '<br>';
}

// System-Plugins (auch bei Safe Mode)
$systemPlugins = $addon->getSystemPlugins();
```

### Abhängigkeiten prüfen

```php
// In boot.php: Andere Addons prüfen
if (rex_addon::get('media_manager')->isAvailable()) {
    // Media Manager verfügbar
}

if (rex_addon::get('yform')->isAvailable()) {
    $yform = rex_addon::get('yform');
    
    // Version prüfen
    if (rex_version::compare($yform->getVersion(), '4.1.0', '>=')) {
        // YForm >= 4.1.0
    }
}
```

### package.yml Beispiel

```yaml
package: myaddon
version: '1.2.3'
author: Max Mustermann
supportpage: https://example.com/support

page:
    title: 'translate:myaddon_title'
    icon: rex-icon fa-cog
    perm: myaddon[]

requires:
    redaxo: ^5.10
    packages:
        yform: ^4.0

pages:
    main:
        title: 'translate:myaddon_main'
    settings:
        title: 'translate:myaddon_settings'
        perm: admin[]
```

### Properties aus package.yml

```php
// Automatisch geladen bei Zugriff
$pages = $addon->getProperty('pages'); // Array aus package.yml
$requires = $addon->getProperty('requires'); // Requirements
$title = $addon->getProperty('page')['title']; // Page-Config
```

### boot.php Beispiel

```php
// boot.php wird bei isAvailable() geladen
$addon = rex_addon::get('myaddon');

// Lang-Files laden
rex_i18n::addDirectory($addon->getPath('lang'));

// Assets nur im Backend
if (rex::isBackend()) {
    rex_view::addCssFile($addon->getAssetsUrl('backend.css'));
    rex_view::addJsFile($addon->getAssetsUrl('backend.js'));
}

// Extension Points
rex_extension::register('PACKAGES_INCLUDED', function() use ($addon) {
    // Code nach Package-Loading
});
```

### install.php Beispiel

```php
// install.php wird beim Installieren ausgeführt
$addon = rex_addon::get('myaddon');

// Tabelle anlegen
rex_sql_table::get(rex::getTable('myaddon_data'))
    ->ensureColumn(new rex_sql_column('id', 'int(11)', false, null, 'auto_increment'))
    ->ensureColumn(new rex_sql_column('name', 'varchar(255)'))
    ->setPrimaryKey('id')
    ->ensure();

// Default-Config setzen
$addon->setConfig('max_items', 100);
$addon->setConfig('enabled', true);

return true; // Erfolg
// return false; // Fehler -> Install abbgebrochen
```

### uninstall.php Beispiel

```php
// uninstall.php wird beim Deinstallieren ausgeführ
// Tabellen löschen
rex_sql_table::get(rex::getTable('myaddon_data'))->drop();

// Config löschen (automatisch via rex_config::removeNamespace())
// Oder manuell:
$addon->removeConfig('max_items');
```

### update.php Beispiel

```php
// update.php wird bei Version-Update ausgeführt
$addon = rex_addon::get('myaddon');

// Alte Version ermitteln (aus DB, rex_addon Tabelle)
// Neue Spalte hinzufügen
if (version_compare($addon->getProperty('version'), '2.0.0', '>=')) {
    rex_sql_table::get(rex::getTable('myaddon_data'))
        ->ensureColumn(new rex_sql_column('status', 'tinyint(1)', false, '1'))
        ->ensure();
}
```

### Package-Files Konstanten

```php
// Datei-Konstanten
rex_package::FILE_PACKAGE;      // "package.yml"
rex_package::FILE_BOOT;          // "boot.php"
rex_package::FILE_INSTALL;       // "install.php"
rex_package::FILE_INSTALL_SQL;   // "install.sql"
rex_package::FILE_UNINSTALL;     // "uninstall.php"
rex_package::FILE_UNINSTALL_SQL; // "uninstall.sql"
rex_package::FILE_UPDATE;        // "update.php"
```

### Properties Cache laden

```php
// package.yml wird gecacht in var/cache/packages.cache
$addon->loadProperties(); // Lädt package.yml

// Force reload
$addon->loadProperties(true);
```

### Config für Shortcut-Zugriff

```php
// Eigene Wrapper-Klasse
class MyAddonConfig {
    private static function addon() {
        return rex_addon::get('myaddon');
    }
    
    public static function getMaxItems() {
        return (int) self::addon()->getConfig('max_items', 10);
    }
    
    public static function setMaxItems($value) {
        self::addon()->setConfig('max_items', $value);
    }
}

// Verwendung
$max = MyAddonConfig::getMaxItems();
```

### Data-Verzeichnis nutzen

```php
// Uploads speichern
$uploadDir = $addon->getDataPath('uploads/');

if (!is_dir($uploadDir)) {
    rex_dir::create($uploadDir);
}

move_uploaded_file($_FILES['file']['tmp_name'], $uploadDir . $filename);
```

### Cache-Verzeichnis nutzen

```php
// Temporäre Dateien
$tempFile = $addon->getCachePath('temp_' . uniqid() . '.json');
rex_file::put($tempFile, json_encode($data));

// Cache leeren
rex_dir::deleteFiles($addon->getCachePath());
```

### Conditional Plugin-Loading

```php
// In Addon boot.php: Plugin nur laden wenn verfügbar
$addon = rex_addon::get('myaddon');

if ($addon->pluginExists('advanced')) {
    $plugin = $addon->getPlugin('advanced');
    
    if ($plugin->isAvailable()) {
        // Plugin-spezifische Logik
    }
}
```

### Error-Handling bei Package-Access

```php
try {
    $package = rex_package::require('nonexistent/plugin');
} catch (RuntimeException $e) {
    rex_logger::logException($e);
    echo rex_view::error('Package nicht vorhanden');
}
```

### Addon-Update erkennen

```php
// In update.php: Aktuelle Version aus package.yml vs. DB
$currentVersion = $addon->getProperty('version'); // Neu (package.yml)

// Alte Version aus DB (rex_config oder custom)
$oldVersion = $addon->getConfig('installed_version', '1.0.0');

if (version_compare($currentVersion, $oldVersion, '>')) {
    // Update durchführen
    $addon->setConfig('installed_version', $currentVersion);
}
```

### Plugin-Pfade

```php
$plugin = rex_plugin::get('yform', 'manager');

// Plugin-Pfad
$path = $plugin->getPath(); // "/pfad/src/addons/yform/plugins/manager/"
$path = $plugin->getPath('lib/MyClass.php');

// Assets
$cssUrl = $plugin->getAssetsUrl('styles.css'); 
// "/assets/addons/yform/plugins/manager/styles.css"
```

### Package via splitId

```php
// splitId für manuelle Verarbeitung
[$addonId, $pluginId] = rex_package::splitId('yform/manager');
// $addonId = "yform", $pluginId = "manager"

[$addonId, $pluginId] = rex_package::splitId('myaddon');
// $addonId = "myaddon", $pluginId = null
```

### Autoload in Addon

```php
// Composer autoload in Addon
if (file_exists($autoload = $addon->getPath('vendor/autoload.php'))) {
    require_once $autoload;
}

// Eigene Autoload-Funktion
spl_autoload_register(function($class) use ($addon) {
    if (str_starts_with($class, 'MyAddon\\')) {
        $file = str_replace('\\', '/', substr($class, 8));
        require_once $addon->getPath('lib/' . $file . '.php');
    }
});
```
