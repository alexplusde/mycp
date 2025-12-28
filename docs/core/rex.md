# `rex`: Zentrale Klasse für System-Properties, Umgebung, Config

Verwende `rex` für System-Konfiguration, Umgebungsprüfung (Backend/Frontend), User-Zugriff und globale Properties.

## Umgebung prüfen

| Methode | Rückgabe | Verwendung |
|---------|----------|------------|
| `rex::isBackend()` | bool | Prüft ob Backend |
| `rex::isFrontend()` | bool | Prüft ob Frontend |
| `rex::getEnvironment()` | `'backend'`\|`'frontend'`\|`'console'` | Aktuelle Umgebung |
| `rex::isDebugMode()` | bool | Debug-Modus aktiv? |
| `rex::isSafeMode()` | bool | Safe-Mode aktiv? |
| `rex::isLiveMode()` | bool | Live-Modus aktiv? |

## Config (Datenbank, persistent)

| Methode | Zweck |
|---------|-------|
| `rex::setConfig($key, $value)` | Config in DB speichern |
| `rex::getConfig($key, $default)` | Config aus DB auslesen |
| `rex::hasConfig($key)` | Config-Key existiert? |
| `rex::removeConfig($key)` | Config-Key löschen |

## Properties (Runtime, nicht persistent)

| Methode | Zweck |
|---------|-------|
| `rex::setProperty($key, $value)` | Runtime-Property setzen |
| `rex::getProperty($key, $default)` | Runtime-Property auslesen |
| `rex::hasProperty($key)` | Property-Key existiert? |
| `rex::removeProperty($key)` | Property-Key löschen |

## Wichtige Properties

| Property | Typ | Bedeutung |
|----------|-----|-----------|
| `server` | string | Server-URL (mit Trailing Slash) |
| `servername` | string | Server-Name |
| `version` | string | REDAXO-Version |
| `lang` | string | Backend-Sprache |
| `table_prefix` | string | DB-Tabellen-Präfix (meist `rex_`) |
| `temp_prefix` | string | Temp-Tabellen-Präfix |
| `instname` | string | Installations-Name |
| `timezone` | string | PHP-Timezone |
| `user` | rex_user\|null | Aktueller Backend-User |
| `login` | rex_backend_login\|null | Login-Instanz |
| `debug` | array | Debug-Einstellungen |

## User & Login

| Methode | Rückgabe | Verwendung |
|---------|----------|------------|
| `rex::getUser()` | rex_user\|null | Aktueller User (kann null sein) |
| `rex::requireUser()` | rex_user | User (wirft Exception wenn nicht vorhanden) |
| `rex::getImpersonator()` | rex_user\|null | User der impersoniert |

## Datenbank-Tabellen

| Methode | Verwendung |
|---------|------------|
| `rex::getTablePrefix()` | Tabellen-Präfix (z.B. `rex_`) |
| `rex::getTable('mytable')` | Vollständiger Tabellenname (z.B. `rex_mytable`) |

## Praxisbeispiele

### Backend vs. Frontend unterscheiden

```php
if (rex::isBackend()) {
    // Nur im Backend
    $user = rex::getUser();
} else {
    // Nur im Frontend
    rex_login::startSession();
}
```

### Debug-Mode prüfen

```php
if (rex::isDebugMode()) {
    dump($data);
    rex_logger::logError(E_USER_NOTICE, 'Debug info', __FILE__, __LINE__);
}
```

### Config speichern und auslesen

```php
// In install.php oder boot.php
rex::setConfig('my_api_key', 'abc123');
rex::setConfig('max_items', 50);

// Später irgendwo im Code
$apiKey = rex::getConfig('my_api_key');
$maxItems = rex::getConfig('max_items', 10); // Default: 10
```

### Property setzen (nur für aktuelle Runtime)

```php
// Property für aktuellen Request setzen
rex::setProperty('custom_data', ['foo' => 'bar']);

// Später wieder abrufen
$data = rex::getProperty('custom_data', []);
```

### Tabellennamen mit Präfix

```php
$tableName = rex::getTable('my_addon_data');
// Ergebnis: 'rex_my_addon_data'

$sql = rex_sql::factory();
$sql->setQuery('SELECT * FROM ' . $tableName);
```

### Aktuellen User prüfen und verwenden

```php
if (rex::isBackend() && $user = rex::getUser()) {
    $userId = $user->getId();
    $username = $user->getValue('login');
    $email = $user->getValue('email');

    if ($user->isAdmin()) {
        // Nur für Admins
    }

    if ($user->hasPerm('addon[my_addon]')) {
        // User hat Berechtigung für AddOn
    }
}
```

### Safe-Mode für Addon-Entwicklung

```php
// AddOns werden im Safe-Mode nicht geladen
if (rex::isSafeMode()) {
    echo 'Läuft im Safe-Mode - AddOns deaktiviert';
    return;
}
```

### Server-URL verwenden

```php
$serverUrl = rex::getProperty('server');
// z.B. 'https://example.com/'

$fullUrl = $serverUrl . 'media/image.jpg';
// Ergebnis: 'https://example.com/media/image.jpg'
```

### Version prüfen für Kompatibilität

```php
$version = rex::getProperty('version');

if (version_compare($version, '5.17.0', '>=')) {
    // Code nur für REDAXO 5.17+
    $sort = rex_get('sort', ['name', 'date'], 'name');
}
```

### Timezone setzen

```php
// In boot.php
$timezone = rex::getProperty('timezone', 'Europe/Berlin');
date_default_timezone_set($timezone);
```

### Environment-spezifische Logik

```php
switch (rex::getEnvironment()) {
    case 'backend':
        // Backend-spezifischer Code
        break;
    case 'frontend':
        // Frontend-spezifischer Code
        break;
    case 'console':
        // CLI-spezifischer Code
        break;
}
```

### AddOn-Config mit rex::setConfig

```php
// In install.php
rex::setConfig('addon_installed', date('Y-m-d H:i:s'));
rex::setConfig('addon_version', '1.0.0');

// Mehrere Werte auf einmal setzen
rex::setConfig([
    'api_endpoint' => 'https://api.example.com',
    'api_timeout' => 30,
    'cache_lifetime' => 3600,
]);

// Später auslesen
$installed = rex::getConfig('addon_installed');
$version = rex::getConfig('addon_version');
```

## Wichtige Konstanten

```php
rex::CONFIG_NAMESPACE  // 'core'
```
