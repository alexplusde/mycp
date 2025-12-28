# rex_config

**Persistente Konfigurationsspeicherung (Datenbank + File-Cache)**

**Keywords:** config, settings, namespace, cache, addon-settings

---

## Methodenübersicht

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `set()` | `string $namespace`, `string\|array $key`, `mixed $value = null` | `bool` | Wert speichern, `true` bei Überschreibung |
| `get()` | `string $namespace`, `string\|null $key = null`, `mixed $default = null` | `mixed\|array` | Wert lesen, Array bei `$key = null` |
| `has()` | `string $namespace`, `string\|null $key = null` | `bool` | Prüft ob Namespace/Key existiert |
| `remove()` | `string $namespace`, `string $key` | `bool` | Wert löschen |
| `removeNamespace()` | `string $namespace` | `bool` | Alle Werte eines Namespace löschen |
| `refresh()` | - | `void` | Neu laden aus DB (bei Änderungen außerhalb) |
| `save()` | - | `void` | Manuelles Speichern (automatisch bei Shutdown) |

---

## Praxisbeispiele

### Basis-Verwendung

```php
// Einzelnen Wert setzen
rex_config::set('myaddon', 'api_key', 'abc123');
rex_config::set('myaddon', 'timeout', 30);
rex_config::set('myaddon', 'enabled', true);

// Wert lesen
$apiKey = rex_config::get('myaddon', 'api_key'); // "abc123"
$timeout = rex_config::get('myaddon', 'timeout', 60); // 30 (oder 60 als Default)

// Prüfen ob Wert existiert
if (rex_config::has('myaddon', 'api_key')) {
    // Key vorhanden
}

// Wert löschen
rex_config::remove('myaddon', 'old_setting');
```

### Mehrere Werte auf einmal setzen

```php
// Array-Schreibweise
rex_config::set('myaddon', [
    'api_key' => 'abc123',
    'timeout' => 30,
    'enabled' => true,
    'options' => ['option1', 'option2']
]);

// Alle Werte eines Namespace lesen
$config = rex_config::get('myaddon'); // Komplettes Array
// ['api_key' => 'abc123', 'timeout' => 30, ...]
```

### Komplexe Datentypen

```php
// Arrays, Objekte (als JSON gespeichert)
rex_config::set('myaddon', 'categories', [1, 5, 12]);
rex_config::set('myaddon', 'settings', [
    'debug' => false,
    'cache_ttl' => 3600,
    'endpoints' => ['api1', 'api2']
]);

// Nested Arrays
$config = [
    'api' => [
        'key' => 'xxx',
        'secret' => 'yyy',
        'url' => 'https://api.example.com'
    ],
    'display' => [
        'items_per_page' => 20,
        'sort' => 'desc'
    ]
];
rex_config::set('myaddon', $config);

// Zugriff
$api = rex_config::get('myaddon', 'api');
$apiKey = $api['key']; // 'xxx'
```

### Package-Integration

```php
// Via rex_addon (Shortcut)
$addon = rex_addon::get('myaddon');

// Setzen
$addon->setConfig('api_key', 'abc123');
$addon->setConfig([
    'enabled' => true,
    'timeout' => 30
]);

// Lesen
$apiKey = $addon->getConfig('api_key');
$config = $addon->getConfig(); // Alle Werte

// Prüfen
if ($addon->hasConfig('api_key')) {
    // ...
}

// Löschen
$addon->removeConfig('old_setting');

// Intern ruft dies rex_config auf:
// $addon->setConfig('key', 'val') => rex_config::set('myaddon', 'key', 'val')
```

### Installations-Routine

```php
// install.php eines Addons
$addon = rex_addon::get('myaddon');

// Default-Config bei Installation
if (!$addon->hasConfig()) {
    $addon->setConfig([
        'api_key' => '',
        'timeout' => 30,
        'enabled' => false,
        'cache_ttl' => 3600,
        'debug' => false
    ]);
}
```

### Deinstallations-Routine

```php
// uninstall.php eines Addons
$addon = rex_addon::get('myaddon');

// Alle Config-Werte löschen
rex_config::removeNamespace('myaddon');

// Oder via Addon-API
// (entfernt auch Daten, aber nicht Config automatisch!)
```

### Backend-Settings-Formular

```php
// pages/settings.php
$addon = rex_addon::get('myaddon');

if (rex_request::isPOSTRequest()) {
    $apiKey = rex_post('api_key', 'string');
    $timeout = rex_post('timeout', 'int', 30);
    $enabled = rex_post('enabled', 'bool');
    
    $addon->setConfig('api_key', $apiKey);
    $addon->setConfig('timeout', $timeout);
    $addon->setConfig('enabled', $enabled);
    
    echo rex_view::success('Einstellungen gespeichert.');
}

$content = '
<form method="post">
    <fieldset>
        <legend>API-Einstellungen</legend>
        
        <div class="form-group">
            <label>API-Key</label>
            <input type="text" name="api_key" class="form-control" 
                   value="' . rex_escape($addon->getConfig('api_key')) . '">
        </div>
        
        <div class="form-group">
            <label>Timeout (Sekunden)</label>
            <input type="number" name="timeout" class="form-control" 
                   value="' . $addon->getConfig('timeout', 30) . '">
        </div>
        
        <div class="checkbox">
            <label>
                <input type="checkbox" name="enabled" value="1" 
                    ' . ($addon->getConfig('enabled') ? 'checked' : '') . '>
                Aktiviert
            </label>
        </div>
    </fieldset>
    
    <button type="submit" class="btn btn-save">Speichern</button>
</form>';

echo rex_view::content($content, 'Einstellungen');
```

### rex_config_form (Vereinfacht)

```php
// pages/settings.php mit rex_config_form
$form = rex_config_form::factory('myaddon');

$form->addFieldset('API-Einstellungen');

$field = $form->addTextField('api_key');
$field->setLabel('API-Key');

$field = $form->addTextField('timeout');
$field->setLabel('Timeout (Sekunden)');
$field->getValidator()->add('match', '/^\d+$/');

$field = $form->addCheckboxField('enabled');
$field->addOption('Aktiviert', 1);
$field->setLabel('Status');

echo $form->get();
```

### Caching-Verhalten

```php
// rex_config cached automatisch in Datei:
// rex_path::coreCache('config.cache')

// Bei Änderungen:
rex_config::set('myaddon', 'key', 'value');
// 1. Änderung wird in Memory gehalten
// 2. Bei Shutdown: Speichern in DB + Cache-File löschen
// 3. Nächster Request: Neu laden aus DB + Cache-File erstellen

// Manuelles Refresh (falls DB extern geändert wurde)
rex_config::refresh();

// Manuelles Speichern (normalerweise nicht nötig)
rex_config::save();
```

### Multi-Environment Config

```php
// Environment-spezifische Einstellungen
$env = rex::getEnvironment(); // 'frontend', 'backend', 'console'

rex_config::set('myaddon', 'debug_' . $env, true);

if (rex_config::get('myaddon', 'debug_' . rex::getEnvironment())) {
    // Debug aktiv für aktuelle Environment
}
```

### Migration / Import

```php
// Export aller Einstellungen
$allConfig = rex_config::get('myaddon');
$json = json_encode($allConfig, JSON_PRETTY_PRINT);
rex_file::put(rex_path::addonData('myaddon', 'config_backup.json'), $json);

// Import
$json = rex_file::get(rex_path::addonData('myaddon', 'config_backup.json'));
$config = json_decode($json, true);
rex_config::set('myaddon', $config);
```

### Namespace-Patterns

```php
// Addon-Config
rex_config::set('myaddon', 'key', 'value');

// Plugin-Config (gleicher Namespace wie Addon!)
rex_plugin::get('myaddon', 'myplugin')->setConfig('plugin_key', 'value');
// Intern: rex_config::set('myaddon', 'plugin_key', 'value')

// Separater Plugin-Namespace (manuell)
rex_config::set('myaddon/myplugin', 'key', 'value');

// Core-Config (über rex::setConfig)
rex::setConfig('server', 'https://example.com');
// Intern: rex_config::set('core', 'server', 'https://example.com')
```

---

**Speicherung:**

- Datenbank-Tabelle: `rex_config` (namespace, key, value als JSON)
- File-Cache: `rex_path::coreCache('config.cache')` (automatisch generiert)
- Auto-Save bei `register_shutdown_function()` (kein manuelles Speichern nötig)

**Best Practices:**

- ✅ Namespace = Addon-Name (Konsistenz)
- ✅ `setConfig()` / `getConfig()` via rex_addon nutzen (Shortcut)
- ✅ Defaults immer in `install.php` setzen
- ✅ `removeNamespace()` in `uninstall.php` aufrufen
- ⚠️ Keine Passwörter im Klartext (Verschlüsselung via `rex_encode()`)
- ⚠️ Große Datenmengen nicht in Config speichern (lieber eigene Tabelle)
