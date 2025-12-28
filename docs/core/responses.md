# `rex_response`: HTTP-Status, Redirects, Downloads, Caching

Verwende `rex_response` für HTTP-Statuscodes, Weiterleitungen, Datei-Downloads und Cache-Control.

## Wichtigste Methoden

| Methode | Zweck | Beispiel |
|---------|-------|----------|
| `setStatus($code)` | HTTP-Statuscode setzen | `rex_response::setStatus(404)` |
| `getStatus()` | Aktuellen Statuscode abrufen | `rex_response::getStatus()` |
| `sendRedirect($url)` | Redirect ausführen (beendet Script) | `rex_response::sendRedirect($url)` |
| `sendFile($file, $type, $disposition)` | Datei ausgeben | `rex_response::sendFile($path, 'application/pdf')` |
| `sendResource($resource, $filename, $type)` | Stream-Ressource ausgeben | `rex_response::sendResource($fp, 'data.csv')` |
| `sendContent($content, $filename, $type, $disposition)` | String als Datei ausgeben | `rex_response::sendContent($csv, 'export.csv')` |
| `sendCacheControl($value)` | Cache-Control-Header | `rex_response::sendCacheControl('no-cache')` |
| `sendLastModified($timestamp)` | Last-Modified-Header | `rex_response::sendLastModified($time)` |
| `cleanOutputBuffers()` | Alle Output-Buffer leeren | `rex_response::cleanOutputBuffers()` |

## HTTP-Statuscodes (Konstanten)

```php
rex_response::HTTP_OK                    // 200
rex_response::HTTP_MOVED_PERMANENTLY     // 301
rex_response::HTTP_FOUND                 // 302
rex_response::HTTP_NOT_MODIFIED          // 304
rex_response::HTTP_BAD_REQUEST           // 400
rex_response::HTTP_UNAUTHORIZED          // 401
rex_response::HTTP_FORBIDDEN             // 403
rex_response::HTTP_NOT_FOUND             // 404
rex_response::HTTP_INTERNAL_ERROR        // 500
```

## Praxisbeispiele

### 301-Redirect (SEO-Weiterleitung)

```php
rex_response::setStatus(rex_response::HTTP_MOVED_PERMANENTLY);
rex_response::sendRedirect(rex_getUrl(123));
```

### 404-Fehlerseite ausgeben

```php
if (!$article) {
    rex_response::setStatus(rex_response::HTTP_NOT_FOUND);
    rex_response::sendPage(rex_article::getNotfoundArticleId());
    exit;
}
```

### PDF-Datei zum Download anbieten

```php
$file = rex_path::addonData('addon', 'report.pdf');
rex_response::sendFile($file, 'application/pdf', 'attachment');
```

### CSV-Export direkt ausgeben

```php
$csv = "Name;Email\n";
$csv .= "Max;max@example.com\n";

rex_response::sendContent(
    $csv,
    'export.csv',
    'text/csv',
    'attachment'
);
```

### Redirect mit Parametern und Anker

```php
rex_response::setStatus(302);
$url = rex_getUrl(5, null, ['id' => 123, 'tab' => 'details']) . '#section-2';
rex_response::sendRedirect($url);
```

### API-Response mit Cache-Control

```php
rex_response::sendCacheControl('public, max-age=3600');
rex_response::sendContentType('application/json');
echo json_encode(['status' => 'ok', 'data' => $result]);
exit;
```

### Bild aus Mediapool mit Last-Modified

```php
$media = rex_media::get('logo.png');

if ($media) {
    rex_response::sendLastModified($media->getUpdateDate());
    rex_response::sendFile(
        rex_path::media($media->getFileName()),
        'image/png'
    );
}
```

### Output-Buffer leeren vor eigenem Output

```php
rex_response::cleanOutputBuffers();
header('Content-Type: text/plain');
echo "Raw output";
exit;
```

## Content-Disposition

- `'inline'`: Datei im Browser anzeigen (Standard)
- `'attachment'`: Download erzwingen
