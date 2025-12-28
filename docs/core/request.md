# rex_request

**Sicherer Zugriff auf Superglobals ($_GET, $_POST, $_SERVER, $_REQUEST, $_SESSION, $_COOKIE)**

**Keywords:** get, post, session, server, cookie, input, validation, whitelist

---

## Methodenübersicht

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `get()` | `string $key`, `string\|array $vartype = ''`, `mixed $default = null` | `mixed` | $_GET-Parameter auslesen |
| `post()` | `string $key`, `string\|array $vartype = ''`, `mixed $default = null` | `mixed` | $_POST-Parameter auslesen |
| `request()` | `string $key`, `string\|array $vartype = ''`, `mixed $default = null` | `mixed` | $_REQUEST-Parameter auslesen |
| `server()` | `string $key`, `string\|array $vartype = ''`, `mixed $default = null` | `mixed` | $_SERVER-Parameter auslesen |
| `session()` | `string $key`, `string\|array $vartype = ''`, `mixed $default = null` | `mixed` | $_SESSION-Parameter auslesen |
| `cookie()` | `string $key`, `string\|array $vartype = ''`, `mixed $default = null` | `mixed` | $_COOKIE-Parameter auslesen |
| `isPOSTRequest()` | - | `bool` | Prüft ob POST-Request |
| `isGETRequest()` | - | `bool` | Prüft ob GET-Request |
| `isXmlHttpRequest()` | - | `bool` | Prüft ob AJAX-Request (X-Requested-With) |
| `putMethod()` | - | `bool` | Prüft ob PUT-Request (aus $_POST['_method']) |
| `deleteMethod()` | - | `bool` | Prüft ob DELETE-Request (aus $_POST['_method']) |

---

## Funktions-Shortcuts

| Funktion | Entspricht | Beschreibung |
|----------|------------|--------------|
| `rex_get()` | `rex_request::get()` | Shortcut für GET |
| `rex_post()` | `rex_request::post()` | Shortcut für POST |
| `rex_request()` | `rex_request::request()` | Shortcut für REQUEST |
| `rex_server()` | `rex_request::server()` | Shortcut für SERVER |
| `rex_session()` | `rex_request::session()` | Shortcut für SESSION |
| `rex_cookie()` | `rex_request::cookie()` | Shortcut für COOKIE |

---

## Vartypes

| Vartype | Beschreibung | Beispiel-Rückgabe |
|---------|--------------|-------------------|
| `'string'` | String | `"hello"` |
| `'int'` | Integer | `42` |
| `'integer'` | Alias für `int` | `42` |
| `'float'` | Float | `3.14` |
| `'double'` | Alias für `float` | `3.14` |
| `'bool'` | Boolean | `true`, `false` |
| `'boolean'` | Alias für `bool` | `true`, `false` |
| `'array'` | Array (rekursiv gecastet) | `['key' => 'value']` |
| `['int', 'string']` | Array mit spezifischen Typen | `[1, "text", 3]` |
| `'rex-clang-id'` | Clang-ID (validiert gegen verfügbare Clangs) | `1` |
| `'rex-article-id'` | Artikel-ID (positiv) | `5` |
| `'rex-category-id'` | Kategorie-ID | `3` |
| `'rex-template-id'` | Template-ID | `2` |
| `'rex-module-id'` | Modul-ID | `7` |
| `'rex-media-category-id'` | Medienkategorie-ID | `4` |

---

## Praxisbeispiele

### Basis-Verwendung

```php
// GET-Parameter: ?id=123&name=Test
$id = rex_get('id', 'int'); // 123
$name = rex_get('name', 'string'); // "Test"
$page = rex_get('page', 'string', 'overview'); // Default: "overview"

// POST-Parameter
$email = rex_post('email', 'string');
$status = rex_post('status', 'bool');
$data = rex_post('data', 'array');

// SERVER-Variable
$method = rex_server('REQUEST_METHOD', 'string'); // "GET", "POST"
$userAgent = rex_server('HTTP_USER_AGENT', 'string');
$remoteAddr = rex_server('REMOTE_ADDR', 'string');
```

### Request-Type-Detection

```php
// POST vs. GET
if (rex_request::isPOSTRequest()) {
    // Formular verarbeiten
    $name = rex_post('name', 'string');
}

if (rex_request::isGETRequest()) {
    // Query-Parameter verarbeiten
}

// AJAX-Erkennung
if (rex_request::isXmlHttpRequest()) {
    // JSON-Response
    header('Content-Type: application/json');
    echo json_encode(['success' => true]);
    exit;
}

// PUT/DELETE via POST-Emulation
// <input type="hidden" name="_method" value="PUT">
if (rex_request::putMethod()) {
    // Update-Logik
}

if (rex_request::deleteMethod()) {
    // Delete-Logik
}
```

### Array-Parameter

```php
// ?filter[status]=1&filter[cat]=5
$filter = rex_get('filter', 'array');
// ['status' => '1', 'cat' => '5']

// Mit Typ-Casting
$filter = rex_get('filter', ['int']);
// ['status' => 1, 'cat' => 5]

// POST: name="ids[]" value="1,2,3"
$ids = rex_post('ids', ['int']);
// [1, 2, 3]
```

### REDAXO-spezifische Vartypes

```php
// Clang-ID (nur gültige Sprachen)
$clangId = rex_get('clang', 'rex-clang-id', rex_clang::getStartId());

// Artikel-ID (nur positive Werte)
$articleId = rex_get('article_id', 'rex-article-id');

// Kategorie-ID
$categoryId = rex_get('category_id', 'rex-category-id');

// Template/Modul-IDs
$templateId = rex_get('template_id', 'rex-template-id');
$moduleId = rex_get('module_id', 'rex-module-id');
```

### Whitelist-Validierung (ab REDAXO 5.17)

```php
// Nur erlaubte Werte
$func = rex_get('func', ['add', 'edit', 'delete'], 'list');
// Wenn 'func' nicht in ['add', 'edit', 'delete'], dann 'list'

// Status-Werte
$status = rex_post('status', ['active', 'inactive'], 'active');

// Sortierung
$sort = rex_get('sort', ['asc', 'desc'], 'asc');
```

### Session-Handling

```php
// Session-Daten lesen
$userId = rex_session('user_id', 'int');
$cart = rex_session('cart', 'array', []);

// Session-Daten schreiben
$_SESSION['user_id'] = 42;
$_SESSION['cart'] = ['item1', 'item2'];

// Session prüfen
if ($userId = rex_session('user_id', 'int')) {
    // User eingeloggt
}
```

### Cookie-Handling

```php
// Cookie lesen
$token = rex_cookie('remember_token', 'string');
$preferences = rex_cookie('prefs', 'array', []);

// Cookie setzen
setcookie('remember_token', $token, time() + 86400, '/');
```

### Backend-Typisches Pattern

```php
$func = rex_request('func', 'string');
$id = rex_request('id', 'int');
$page = rex_get('page', 'string');

switch ($func) {
    case 'add':
        // Formular anzeigen
        break;
    
    case 'edit':
        if ($id) {
            // Datensatz laden
        }
        break;
    
    case 'delete':
        if ($id && rex_request::isPOSTRequest()) {
            // Datensatz löschen
        }
        break;
    
    default:
        // Liste anzeigen
        break;
}
```

### XSS-Protection

```php
// NIEMALS direkt ausgeben!
// FALSCH:
echo $_GET['name']; // ⚠️ XSS-Gefahr

// RICHTIG:
echo rex_escape(rex_get('name', 'string')); // ✅ Escaped

// Oder in Templates:
$name = rex_get('name', 'string');
?>
<p><?= rex_escape($name) ?></p>
```

### Komplexes Formular-Handling

```php
if (rex_request::isPOSTRequest()) {
    $name = rex_post('name', 'string');
    $email = rex_post('email', 'string');
    $age = rex_post('age', 'int');
    $terms = rex_post('terms', 'bool');
    $interests = rex_post('interests', ['int'], []);
    
    // Validierung
    $errors = [];
    if (empty($name)) {
        $errors[] = 'Name erforderlich';
    }
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $errors[] = 'Ungültige E-Mail';
    }
    if ($age < 18) {
        $errors[] = 'Mindestalter: 18';
    }
    if (!$terms) {
        $errors[] = 'AGB-Zustimmung erforderlich';
    }
    
    if (empty($errors)) {
        // Speichern
        $sql = rex_sql::factory();
        $sql->setTable('rex_user_registrations');
        $sql->setValue('name', $name);
        $sql->setValue('email', $email);
        $sql->setValue('age', $age);
        $sql->setArrayValue('interests', $interests);
        $sql->insert();
        
        // Redirect
        rex_response::sendRedirect(rex_url::currentBackendPage(['msg' => 'Gespeichert']));
    }
}
```

### File-Upload mit rex_request

```php
if (rex_request::isPOSTRequest() && isset($_FILES['upload'])) {
    $file = $_FILES['upload'];
    
    if ($file['error'] === UPLOAD_ERR_OK) {
        $filename = rex_string::normalize($file['name']);
        $target = rex_path::addonData('myaddon', 'uploads/' . $filename);
        
        if (move_uploaded_file($file['tmp_name'], $target)) {
            // Speichern in DB
            $fileId = rex_post('file_id', 'int');
            $sql = rex_sql::factory();
            $sql->setTable('rex_myfiles');
            $sql->setValue('filename', $filename);
            $sql->setWhere('id = :id', ['id' => $fileId]);
            $sql->update();
        }
    }
}
```

### CSRF-Protected Forms

```php
// Formular mit CSRF-Token
$csrfToken = rex_csrf_token::factory('my_form');

if (rex_request::isPOSTRequest()) {
    if (!$csrfToken->isValid()) {
        die('CSRF-Token ungültig!');
    }
    
    // Formular verarbeiten
    $name = rex_post('name', 'string');
    // ...
}
?>
<form method="post">
    <?= $csrfToken->getHiddenField() ?>
    <input type="text" name="name">
    <button type="submit">Speichern</button>
</form>
```

---

**Sicherheit:**

- ✅ Verwende **immer** `rex_get()`, `rex_post()` etc. statt direktem Zugriff auf `$_GET`, `$_POST`
- ✅ Nutze Vartypes für Type-Casting: `'int'`, `'bool'`, `'array'`
- ✅ Setze Defaults für optionale Parameter
- ✅ Verwende Whitelist-Arrays (ab 5.17) für Enum-Werte
- ⚠️ Escape Ausgaben mit `rex_escape()` oder `htmlspecialchars()`
- ⚠️ Validiere E-Mails, URLs, Dateiuploads zusätzlich
- ⚠️ Nutze CSRF-Protection bei POST-Requests
