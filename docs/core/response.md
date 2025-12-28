# rex_response

**HTTP-Responses, Redirects, Downloads, Status-Codes, Caching**

**Keywords:** redirect, download, header, status, cache, content-type

---

## Methodenübersicht

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `sendRedirect()` | `string\|rex_article $url`, `array $params = []`, `int\|null $statusCode = null` | `never` | Redirect + exit() |
| `sendFile()` | `string $file`, `string\|null $contentType = null`, `string\|null $contentDisposition = null`, `array $headers = []` | `never` | Datei senden + exit() |
| `sendContent()` | `string $content`, `string\|null $filename = null`, `string\|null $contentType = null`, `array $headers = []` | `never` | Content senden + exit() |
| `sendPage()` | `string $content`, `string\|null $lastModified = null`, `array $headers = []` | `never` | HTML-Seite senden + exit() |
| `sendJson()` | `mixed $data`, `array $headers = []` | `never` | JSON senden + exit() |
| `sendCacheControl()` | `string $cacheControl = 'must-revalidate, proxy-revalidate, private'`, `int\|null $lastModified = null` | `void` | Cache-Header setzen |
| `sendNotModified()` | - | `never` | 304 Not Modified + exit() |
| `sendNotFound()` | `string $message = 'Not Found'` | `never` | 404 + exit() |
| `sendForbidden()` | `string $message = 'Forbidden'` | `never` | 403 + exit() |
| `sendUnauthorized()` | `string $message = 'Unauthorized'` | `never` | 401 + exit() |
| `setStatus()` | `int $statusCode` | `void` | HTTP-Statuscode setzen |
| `sendResource()` | `string $file`, `string\|null $contentType = null`, `bool $download = false`, `array $headers = []` | `never` | Datei mit Cache-Support |
| `getHttpMessage()` | `int $statusCode` | `string` | HTTP-Status-Message ("OK", "Not Found") |
| `cleanOutputBuffers()` | - | `void` | Output-Buffer leeren |
| `preload()` | `string\|array $uris`, `string $asType = 'script'`, `bool $crossorigin = false` | `void` | Link-Preload-Header setzen |
| `sendCSVContent()` | `array $rows`, `string $filename`, `string $delimiter = ','`, `string $enclosure = '"'` | `never` | CSV senden + exit() |

---

## HTTP-Status-Codes

| Code | Konstante | Bedeutung |
|------|-----------|-----------|
| 200 | `HTTP_OK` | Erfolgreich |
| 201 | `HTTP_CREATED` | Erstellt |
| 204 | `HTTP_NO_CONTENT` | Keine Inhalte |
| 301 | `HTTP_MOVED_PERMANENTLY` | Permanent verschoben |
| 302 | `HTTP_FOUND` | Temporäre Weiterleitung |
| 303 | `HTTP_SEE_OTHER` | Siehe andere URI |
| 304 | `HTTP_NOT_MODIFIED` | Nicht geändert |
| 307 | `HTTP_TEMPORARY_REDIRECT` | Temporär verschoben |
| 400 | `HTTP_BAD_REQUEST` | Fehlerhafte Anfrage |
| 401 | `HTTP_UNAUTHORIZED` | Nicht authentifiziert |
| 403 | `HTTP_FORBIDDEN` | Zugriff verboten |
| 404 | `HTTP_NOT_FOUND` | Nicht gefunden |
| 405 | `HTTP_METHOD_NOT_ALLOWED` | Methode nicht erlaubt |
| 500 | `HTTP_INTERNAL_ERROR` | Serverfehler |
| 503 | `HTTP_SERVICE_UNAVAILABLE` | Dienst nicht verfügbar |

---

## Praxisbeispiele

### Redirects

```php
// Einfacher Redirect (302)
rex_response::sendRedirect('https://example.com');

// Redirect mit Parametern
rex_response::sendRedirect('index.php', [
    'page' => 'content/edit',
    'article_id' => 5,
    'clang' => 1
]);

// Permanenter Redirect (301)
rex_response::sendRedirect('https://new-domain.com', [], 301);

// Backend-Page Redirect
rex_response::sendRedirect(rex_url::currentBackendPage([
    'func' => 'edit',
    'id' => $id,
    'msg' => 'Erfolgreich gespeichert'
]));

// Artikel-Redirect
$article = rex_article::get(5);
rex_response::sendRedirect($article);
```

### File-Downloads

```php
// Datei zum Download
$file = rex_path::addonData('myaddon', 'export.csv');
rex_response::sendFile($file, 'text/csv', 'attachment; filename="export.csv"');

// Inline-Anzeige (z.B. PDF im Browser)
$pdf = rex_path::media('document.pdf');
rex_response::sendFile($pdf, 'application/pdf', 'inline');

// Mit Custom-Headern
rex_response::sendFile($file, 'application/zip', 'attachment', [
    'X-Custom-Header' => 'value'
]);
```

### Content direkt senden

```php
// String-Content als Download
$csv = "Name,Email\nJohn,john@example.com\nJane,jane@example.com";
rex_response::sendContent($csv, 'export.csv', 'text/csv');

// JSON-Response
$data = ['status' => 'success', 'items' => [1, 2, 3]];
rex_response::sendJson($data);

// JSON mit Custom-Headern
rex_response::sendJson($data, [
    'X-Total-Count' => 100,
    'X-Page' => 1
]);
```

### CSV-Export (Helper-Methode)

```php
// Direkt aus Array
$rows = [
    ['Name', 'Email', 'Age'],
    ['John Doe', 'john@example.com', 25],
    ['Jane Smith', 'jane@example.com', 30]
];
rex_response::sendCSVContent($rows, 'users.csv');

// Mit Custom-Delimiter (Semikolon für Excel)
rex_response::sendCSVContent($rows, 'users.csv', ';');

// Aus Datenbank
$sql = rex_sql::factory();
$sql->setQuery('SELECT name, email, age FROM rex_users');

$rows = [['Name', 'Email', 'Alter']]; // Header
foreach ($sql as $row) {
    $rows[] = [
        $row->getValue('name'),
        $row->getValue('email'),
        $row->getValue('age')
    ];
}
rex_response::sendCSVContent($rows, 'export.csv');
```

### HTML-Seiten mit Caching

```php
// Seite mit Last-Modified
$content = '<html><body>Content</body></html>';
$lastModified = time(); // oder Datei-Timestamp
rex_response::sendPage($content, $lastModified);

// Custom-Header
rex_response::sendPage($content, null, [
    'X-Powered-By' => 'REDAXO',
    'X-Version' => rex::getVersion()
]);
```

### Cache-Control

```php
// Cache für 1 Stunde
rex_response::sendCacheControl('public, max-age=3600', time());

// Kein Cache (Standard bei Backend)
rex_response::sendCacheControl('no-cache, no-store, must-revalidate');

// 304 Not Modified (wenn Client-Cache gültig)
$fileModTime = filemtime($file);
$ifModifiedSince = $_SERVER['HTTP_IF_MODIFIED_SINCE'] ?? null;

if ($ifModifiedSince && strtotime($ifModifiedSince) >= $fileModTime) {
    rex_response::sendNotModified();
}

// Resource mit Auto-Cache (Bilder, CSS, JS)
$image = rex_path::media('logo.png');
rex_response::sendResource($image, 'image/png');
```

### Error-Pages

```php
// 404 Not Found
$articleId = rex_get('article_id', 'int');
$article = rex_article::get($articleId);

if (!$article) {
    rex_response::sendNotFound('Artikel nicht gefunden');
}

// 403 Forbidden (keine Berechtigung)
if (!rex::getUser()->hasPerm('admin')) {
    rex_response::sendForbidden('Zugriff verweigert');
}

// 401 Unauthorized (nicht eingeloggt)
if (!rex::getUser()) {
    rex_response::sendUnauthorized('Bitte anmelden');
}

// Custom-Statuscode
rex_response::setStatus(418); // I'm a teapot
echo "I'm a teapot!";
```

### Status-Codes manuell setzen

```php
// Erfolgreiche Erstellung (201)
if ($created) {
    rex_response::setStatus(rex_response::HTTP_CREATED);
    rex_response::sendJson(['id' => $newId]);
}

// Keine Inhalte (204)
if ($deleted) {
    rex_response::setStatus(rex_response::HTTP_NO_CONTENT);
    exit;
}

// Bad Request (400)
if ($errors) {
    rex_response::setStatus(rex_response::HTTP_BAD_REQUEST);
    rex_response::sendJson(['errors' => $errors]);
}
```

### Preload-Header (Performance)

```php
// Preload-Header für kritische Assets
rex_response::preload('/assets/core/style.css', 'style');
rex_response::preload('/assets/core/script.js', 'script');
rex_response::preload('/media/logo.png', 'image');

// Mit Crossorigin
rex_response::preload('https://cdn.example.com/font.woff2', 'font', true);

// Array
rex_response::preload([
    '/assets/core/style.css',
    '/assets/core/script.js'
], 'style');
```

### API-Responses

```php
// REST-API-Pattern
$method = rex_server('REQUEST_METHOD', 'string');

switch ($method) {
    case 'GET':
        // Liste abrufen
        $items = getItems();
        rex_response::sendJson($items);
        break;
    
    case 'POST':
        // Neu erstellen
        $data = json_decode(file_get_contents('php://input'), true);
        $id = createItem($data);
        rex_response::setStatus(rex_response::HTTP_CREATED);
        rex_response::sendJson(['id' => $id]);
        break;
    
    case 'PUT':
        // Aktualisieren
        $id = rex_get('id', 'int');
        $data = json_decode(file_get_contents('php://input'), true);
        updateItem($id, $data);
        rex_response::sendJson(['success' => true]);
        break;
    
    case 'DELETE':
        // Löschen
        $id = rex_get('id', 'int');
        deleteItem($id);
        rex_response::setStatus(rex_response::HTTP_NO_CONTENT);
        exit;
        break;
    
    default:
        rex_response::setStatus(rex_response::HTTP_METHOD_NOT_ALLOWED);
        rex_response::sendJson(['error' => 'Method not allowed']);
}
```

### AJAX-Responses

```php
// Success-Response
if (rex_request::isXmlHttpRequest()) {
    if ($success) {
        rex_response::sendJson([
            'success' => true,
            'message' => 'Gespeichert',
            'data' => $result
        ]);
    } else {
        rex_response::setStatus(400);
        rex_response::sendJson([
            'success' => false,
            'errors' => $errors
        ]);
    }
}
```

### Download mit Fortschrittsanzeige

```php
// Großer Download mit Buffer
$file = rex_path::addonData('backup', 'database.sql');

if (!is_file($file)) {
    rex_response::sendNotFound();
}

rex_response::cleanOutputBuffers();

header('Content-Type: application/octet-stream');
header('Content-Disposition: attachment; filename="' . basename($file) . '"');
header('Content-Length: ' . filesize($file));
header('Cache-Control: no-cache');

$handle = fopen($file, 'rb');
while (!feof($handle)) {
    echo fread($handle, 8192);
    flush();
}
fclose($handle);
exit;
```

### Mediapool-Integration

```php
// Media-Datei ausliefern mit Cache
$filename = rex_get('file', 'string');
$file = rex_path::media($filename);

if (!is_file($file)) {
    rex_response::sendNotFound();
}

// Mimetype ermitteln
$finfo = finfo_open(FILEINFO_MIME_TYPE);
$mimeType = finfo_file($finfo, $file);
finfo_close($finfo);

// Mit Cache-Support
rex_response::sendResource($file, $mimeType);
```

### Output-Buffer-Handling

```php
// Buffer vor Redirect leeren
ob_start();
echo "Some output";

// Problem: Output verhindert Redirect-Header
// Lösung:
rex_response::cleanOutputBuffers();
rex_response::sendRedirect('/success');
```

---

**Best Practices:**

- ✅ Nutze `sendRedirect()` statt `header('Location: ...')` + `exit`
- ✅ `sendFile()` / `sendContent()` führen automatisch `exit()` aus
- ✅ Setze Content-Type explizit: `application/json`, `text/csv`, etc.
- ✅ Verwende `sendResource()` für statische Assets (automatisches Caching)
- ✅ `cleanOutputBuffers()` vor Redirects/Downloads wenn nötig
- ⚠️ NIEMALS `echo` vor `sendRedirect()` (Header bereits gesendet)
- ⚠️ `sendJson()` escaped automatisch (XSS-sicher)
- ⚠️ Bei großen Downloads: Buffer-freundliche Methode verwenden
