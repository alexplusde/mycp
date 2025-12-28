# `rex_request`: GET, POST, SERVER, SESSION, COOKIE sicher auslesen

Verwende `rex_request` und zugehörige Funktionen statt direktem Zugriff auf Superglobals (`$_GET`, `$_POST`, `$_SERVER`, `$_SESSION`, `$_COOKIE`).

## Wichtigste Funktionen

| Funktion | Zugriff auf | Signatur | Beispiel |
|----------|-------------|----------|----------|
| `rex_get()` | `$_GET` | `rex_get($key, $type, $default)` | `rex_get('page', 'int', 1)` |
| `rex_post()` | `$_POST` | `rex_post($key, $type, $default)` | `rex_post('name', 'string', '')` |
| `rex_request()` | `$_REQUEST` | `rex_request($key, $type, $default)` | `rex_request('id', 'int')` |
| `rex_server()` | `$_SERVER` | `rex_server($key, $type, $default)` | `rex_server('HTTP_HOST', 'string')` |
| `rex_session()` | `$_SESSION` | `rex_session($key, $type, $default)` | `rex_session('user_id', 'int')` |
| `rex_set_session()` | `$_SESSION` | `rex_set_session($key, $value)` | `rex_set_session('cart', $items)` |
| `rex_unset_session()` | `$_SESSION` | `rex_unset_session($key)` | `rex_unset_session('temp_data')` |
| `rex_cookie()` | `$_COOKIE` | `rex_cookie($key, $type, $default)` | `rex_cookie('consent', 'bool')` |
| `rex_files()` | `$_FILES` | `rex_files($key, $type, $default)` | `rex_files('upload', 'array')` |
| `rex_env()` | `$_ENV` | `rex_env($key, $type, $default)` | `rex_env('PATH', 'string')` |

### Erlaubte Typen

`string`, `int`, `integer`, `bool`, `boolean`, `float`, `double`, `real`, `array`, `object`

### Whitelist-Validierung (REDAXO 5.17+)

```php
// Nur explizit erlaubte Werte
$sort = rex_get('sort', ['name', 'date', 'price'], 'name');
$status = rex_post('status', ['active', 'inactive'], 'active');
$limit = rex_get('limit', [10, 20, 50], 10);
```

## Zusätzliche Methoden

| Methode | Zweck |
|---------|-------|
| `rex_request_method()` | Liefert HTTP-Methode (GET, POST, PUT, DELETE) |
| `rex_request::isXmlHttpRequest()` | Prüft auf AJAX-Request |
| `rex_request::isPJAXRequest()` | Prüft auf PJAX-Request |
| `rex_request::isPJAXContainer($id)` | Prüft PJAX-Container-ID |

## Praxisbeispiele

### Paginierung mit Sortierung

```php
$page = rex_get('page', 'int', 1);
$sort = rex_get('sort', ['name', 'date', 'price_asc', 'price_desc'], 'name');
$limit = rex_get('limit', [10, 20, 50], 20);

$sql = rex_sql::factory();
$sql->setQuery("SELECT * FROM products ORDER BY {$sort} LIMIT {$limit} OFFSET " . ($page - 1) * $limit);
```

### Formulardaten sicher verarbeiten

```php
if (rex_request_method() === 'POST') {
    $name = rex_post('name', 'string');
    $email = rex_post('email', 'string');
    $status = rex_post('status', ['draft', 'published'], 'draft');

    // XSS-Schutz bei Ausgabe
    echo rex_escape($name);
}
```

### AJAX-Request erkennen

```php
if (rex_request::isXmlHttpRequest()) {
    // JSON-Response für AJAX
    header('Content-Type: application/json');
    echo json_encode(['success' => true]);
    exit;
}
```

### Session im Frontend starten

```php
// In boot.php des AddOns
if (rex::isFrontend()) {
    rex_login::startSession();
}

// Session-Werte setzen/auslesen
rex_set_session('cart_items', $items);
$cart = rex_session('cart_items', 'array', []);
```

### Domain aus Server-Variablen

```php
$host = rex_server('HTTP_HOST', 'string', 'localhost');
$protocol = rex_server('HTTPS', 'string') ? 'https' : 'http';
$fullUrl = $protocol . '://' . $host . rex_server('REQUEST_URI', 'string');
```

### File-Upload verarbeiten

```php
if (rex_request_method() === 'POST') {
    $file = rex_files('upload', 'array');

    if (!empty($file['tmp_name'])) {
        rex_mediapool::addMedia([
            'file' => $file['tmp_name'],
            'name' => $file['name'],
        ]);
    }
}
```

## Sicherheit

**Immer `rex_escape()` bei HTML-Ausgabe verwenden:**

```php
$search = rex_get('q', 'string');
echo '<h1>Suche: ' . rex_escape($search) . '</h1>';
```
