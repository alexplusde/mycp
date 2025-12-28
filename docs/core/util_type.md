# rex_type

Keywords: Type Casting, Typprüfung, Variable Types, Validation, Assert, Safety, Strict Types

## Übersicht

`rex_type` bietet sichere Typ-Konvertierung und Validierung. Erweitert PHP-Casting um komplexe Typen: Arrays mit generischen Typen (`array[int]`), Whitelists, Shape-Validation, Callables. Nützlich für `rex_request`, `rex_config`, Session-Variablen. Wirft `InvalidArgumentException` bei ungültigen Typen.

## Methoden

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `cast($var, $vartype)` | `mixed`, `string\|callable\|array` | `mixed` | Konvertiert Variable zu Zieltyp |
| `notNull($value)` | `mixed` | `mixed` | Wirft Exception wenn `null`, sonst Rückgabe |
| `bool($value)` | `mixed` | `bool` | Validiert Boolean, wirft Exception bei anderem Typ |
| `nullOrBool($value)` | `mixed` | `bool\|null` | Wie `bool()`, erlaubt aber `null` |
| `string($value)` | `mixed` | `string` | Validiert String |
| `nullOrString($value)` | `mixed` | `string\|null` | Wie `string()`, erlaubt aber `null` |
| `int($value)` | `mixed` | `int` | Validiert Integer |
| `nullOrInt($value)` | `mixed` | `int\|null` | Wie `int()`, erlaubt aber `null` |
| `array($value)` | `mixed` | `array` | Validiert Array |
| `instanceOf($value, $class)` | `mixed`, `string` | `object` | Validiert Objekt-Typ (instanceof) |

## Praxisbeispiele

### Basis-Casting

```php
// String zu Integer
$id = rex_type::cast('123', 'int'); // 123

// String zu Boolean
$active = rex_type::cast('1', 'bool'); // true

// String zu Float
$price = rex_type::cast('19.99', 'float'); // 19.99

// Zu Array (leerer String wird [])
$items = rex_type::cast('', 'array'); // []
```

### rex_request nutzt rex_type::cast

```php
// Intern in rex_request::session()
if (isset($_SESSION[self::getSessionNamespace()][$varname])) {
    return rex_type::cast($_SESSION[...], $vartype);
} else {
    return rex_type::cast($default, $vartype);
}

// Verwendung
$userId = rex_request::session('user_id', 'int', 0);
```

### Array mit generischen Typen

```php
// Array[int] - alle Elemente zu int casten
$ids = rex_type::cast(['1', '2', '3'], 'array[int]');
// [1, 2, 3]

// Array[string]
$names = rex_type::cast([1, 2, 3], 'array[string]');
// ['1', '2', '3']

// Leere Eingabe wird []
$items = rex_type::cast('', 'array[int]'); // []
```

### Whitelist-Casting (One-Of)

```php
// Nur erlaubte Werte (erster Wert ist Fallback)
$status = rex_type::cast($_POST['status'], ['active', 'inactive', 'pending']);
// Wenn $_POST['status'] = 'deleted' -> 'active' (Fallback)

// Mit BackedEnum (PHP 8.1+)
enum Status: string {
    case Active = 'active';
    case Inactive = 'inactive';
}

$status = rex_type::cast($_POST['status'], [Status::Active, Status::Inactive]);
```

### Shape-Validation (Array-Structure)

```php
// Array mit definierter Struktur
$data = rex_type::cast($_POST, [
    ['name', 'string', ''],
    ['age', 'int', 0],
    ['email', 'string', ''],
]);

// Ergebnis: ['name' => '...', 'age' => 42, 'email' => '...']
// Fehlende Keys erhalten Default-Werte
```

### Callable als Vartype

```php
// Eigene Cast-Funktion
$timestamp = rex_type::cast('2024-01-01', function($value) {
    return strtotime($value);
});

// Trim + Lowercase
$tag = rex_type::cast('  MyTag  ', function($value) {
    return strtolower(trim($value));
});
```

### rex_config mit Type-Casting

```php
// wenns_sein_muss Addon
public static function getConfig($key, $default = '', $vartype = 'string') {
    if (rex_config::has('wenns_sein_muss', $key)) {
        return rex_type::cast(rex_config::get('wenns_sein_muss', $key), $vartype);
    }
    
    return rex_type::cast($default, $vartype);
}

// Verwendung
$maxItems = Wsm::getConfig('max_items', 10, 'int');
$enabled = Wsm::getConfig('enabled', false, 'bool');
```

### ycom_auth Session-Variablen

```php
private static function getSessionVar($key, $varType = '', $default = '') {
    $sessionVars = $_SESSION['ycom_auth'] ?? [];
    
    if (array_key_exists($key, $sessionVars)) {
        return rex_type::cast($sessionVars[$key], $varType);
    }
    
    return rex_type::cast($default, $varType);
}

// Verwendung
$userId = ycom_auth::getSessionVar('user_id', 'int', 0);
$isLoggedIn = ycom_auth::getSessionVar('logged_in', 'bool', false);
```

### notNull für strict Assertions

```php
// rex_be_controller - Page darf nicht null sein
return rex_type::notNull(self::getCurrentPageObject());

// Wirft InvalidArgumentException wenn null
$page = rex_type::notNull($this->getPage());

// Media Manager Effect
$inputFile = rex_type::notNull($this->media->getMediaPath());
```

### Bool-Validierung

```php
// Strikt: nur echte Booleans erlaubt
try {
    $flag = rex_type::bool($_POST['active']); // Wirft Exception bei "1", "true", etc.
} catch (InvalidArgumentException $e) {
    // Nicht boolean
}

// Mit null-Option
$nullable = rex_type::nullOrBool($value); // true, false oder null
```

### String-Validierung

```php
// Nur Strings erlaubt
$name = rex_type::string($_POST['name']);

// Mit null erlaubt
$description = rex_type::nullOrString($_POST['description'] ?? null);
```

### Int-Validierung

```php
// Nur Integer erlaubt (keine String-Zahlen!)
$count = rex_type::int($value);

// Mit null
$optional = rex_type::nullOrInt($value);
```

### Array-Validierung

```php
// Prüft ob Array
$items = rex_type::array($_POST['items']);

// Cast zu Array (besser: rex_type::cast($value, 'array'))
if (is_string($json)) {
    $data = json_decode($json, true);
    $data = rex_type::array($data); // Validiert dass Array zurückkam
}
```

### instanceOf-Validierung

```php
// Objekt-Typ prüfen
$addon = rex_type::instanceOf($package, rex_addon::class);

// Wirft Exception wenn nicht instanceof
$user = rex_type::instanceOf($object, rex_user::class);
```

### Console config:set Command

```php
// Wert aus Console-Input casten
$value = $input->getOption('value');
$type = $input->getOption('type') ?? 'string'; // int, bool, string, etc.

try {
    $value = rex_type::cast($value, $type);
    rex_config::set('myaddon', $key, $value);
} catch (InvalidArgumentException $e) {
    $output->writeln('<error>Invalid type: ' . $type . '</error>');
}
```

### YForm Upload Session-Vars

```php
// yform/lib/Field/value/upload.php
private static function getSessionVar($key, $varType = '', $default = '') {
    $sessionVars = $_SESSION['yform_upload'] ?? [];
    
    if (array_key_exists($key, $sessionVars)) {
        return rex_type::cast($sessionVars[$key], $varType);
    }
    
    return rex_type::cast($default, $varType);
}
```

### Thumb Addon Config

```php
public static function getConfig($key, $default = '', $vartype = 'string') {
    if (rex_config::has('thumb', $key)) {
        return \rex_type::cast(rex_config::get('thumb', $key), $vartype);
    }
    
    return \rex_type::cast($default, $vartype);
}

// Verwendung
$quality = thumb::getConfig('jpeg_quality', 85, 'int');
$watermark = thumb::getConfig('watermark_enabled', false, 'bool');
```

### Mediapool Service - strict notNull

```php
// Datei muss existieren
$path = $media->getPath();
$content = rex_type::notNull(rex_file::get($path));

// Wirft Exception wenn rex_file::get() null zurückgibt (Datei fehlt)
```

### Complex Shape-Validation

```php
// Mehrstufige Struktur
$config = rex_type::cast($_POST, [
    ['title', 'string', ''],
    ['settings', [
        ['enabled', 'bool', false],
        ['max_items', 'int', 10],
        ['tags', 'array[string]', []],
    ]],
]);

// Ergebnis:
// [
//   'title' => '...',
//   'settings' => [
//     'enabled' => true,
//     'max_items' => 20,
//     'tags' => ['tag1', 'tag2']
//   ]
// ]
```

### Array-Casting mit leeren Werten

```php
// Leerer String wird zu []
$items = rex_type::cast('', 'array'); // []

// Arrays bleiben Arrays (aber werden gecastet wenn $var kein Array ist)
$items = rex_type::cast([1, 2, 3], 'array'); // [1, 2, 3]

// Arrays aus $_POST mit int-Elementen
$selectedIds = rex_type::cast($_POST['ids'] ?? [], 'array[int]');
```

### Try-Catch für ungültige Casts

```php
try {
    $value = rex_type::cast($input, 'unknown_type');
} catch (InvalidArgumentException $e) {
    rex_logger::factory()->error('Invalid cast: {msg}', ['msg' => $e->getMessage()]);
    $value = $default;
}
```

### Kein Cast (leerer Vartype)

```php
// '' = kein Cast, Wert bleibt unverändert
$value = rex_type::cast($input, '');
// Entspricht: $value = $input;
```

### One-Of mit Default-Fallback

```php
// Erster Wert im Array ist Fallback
$priority = rex_type::cast($_POST['priority'], ['normal', 'high', 'urgent']);

// Wenn $_POST['priority'] = 'asdfgh' -> 'normal' (erster Wert)
// Wenn $_POST['priority'] = 'high' -> 'high' (passt)
```

### Backend Controller Page-Assertion

```php
// getCurrentPageObject() kann theoretisch null sein
$page = self::getCurrentPageObject();

// Mit notNull wird Exception geworfen wenn null
$page = rex_type::notNull(self::getCurrentPageObject());

// Profile-Page sicher holen
$page = rex_type::notNull(self::getPageObject('profile'));
```

### Type-Safe Config Wrapper

```php
class MyConfig {
    public static function getString(string $key, string $default = ''): string {
        return rex_type::cast(
            rex_config::get('myaddon', $key, $default), 
            'string'
        );
    }
    
    public static function getInt(string $key, int $default = 0): int {
        return rex_type::cast(
            rex_config::get('myaddon', $key, $default), 
            'int'
        );
    }
    
    public static function getBool(string $key, bool $default = false): bool {
        return rex_type::cast(
            rex_config::get('myaddon', $key, $default), 
            'bool'
        );
    }
}
```

### Psalm Integration

```php
// rex_type::notNull hat @psalm-assert !null
$value = getOptionalValue(); // ?string

$value = rex_type::notNull($value); 
// Psalm weiß jetzt: $value ist string (nicht null)

// rex_type::bool hat @psalm-assert bool
$flag = rex_type::bool($input);
// Psalm weiß: $flag ist definitiv boolean
```
