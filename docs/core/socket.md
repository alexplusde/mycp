# `rex_socket`: HTTP(S)-Verbindungen, externe APIs, GET/POST/PUT/DELETE

Verwende `rex_socket`, um externe URLs und APIs aufzurufen, Daten abzurufen oder nach außen zu kommunizieren.

## Initialisierung

| Methode | Verwendung | Rückgabe |
|---------|------------|----------|
| `rex_socket::factory($host, $port, $ssl)` | Socket mit separaten Parametern erstellen | `rex_socket` |
| `rex_socket::factoryUrl($url)` | Socket direkt aus vollständiger URL erstellen | `rex_socket` |

```php
// Mit separaten Parametern (Port 443 für SSL)
$socket = rex_socket::factory('api.example.com', 443, true);
$socket->setPath('/v1/endpoint?param=value');

// Direkt mit vollständiger URL
$socket = rex_socket::factoryUrl('https://api.example.com/v1/endpoint');
```

## Wichtige Methoden

### Request-Konfiguration

| Methode | Zweck |
|---------|-------|
| `setPath($path)` | Pfad setzen (bei `factory()`) |
| `setTimeout($timeout)` | Timeout in Sekunden |
| `setOptions($options)` | PHP Stream-Context-Optionen |
| `addHeader($key, $value)` | Custom Header hinzufügen |
| `addBasicAuthorization($user, $password)` | Basic Auth Header |
| `followRedirects($count)` | Redirects folgen (nur GET) |
| `acceptCompression()` | Gzip/Deflate aktivieren |

### Request ausführen

| Methode | HTTP-Verb | Parameter |
|---------|-----------|-----------|
| `doGet()` | GET | - |
| `doPost($data, $files)` | POST | String/Array/Callback, Files-Array |
| `doDelete()` | DELETE | - |
| `doRequest($method, $data)` | Beliebig | HTTP-Methode, Body |

### Response-Methoden (`rex_socket_response`)

| Methode | Rückgabe | Prüfung |
|---------|----------|---------|
| `getBody()` | string | Kompletter Body |
| `getBufferedBody($chunkSize)` | string\|false | Body in Chunks |
| `getHeader($key)` | string | Header-Wert |
| `getStatusCode()` | int | HTTP Status-Code |
| `isOk()` | bool | Status = 200 |
| `isSuccessful()` | bool | Status 200-299 |
| `isRedirection()` | bool | Status 300-399 |
| `isClientError()` | bool | Status 400-499 |
| `isServerError()` | bool | Status 500-599 |
| `writeBodyTo($filename)` | void | Body in Datei schreiben |

## Praxisbeispiele

### API-Daten abrufen und als Datei speichern

```php
try {
    $socket = rex_socket::factoryUrl('https://download.db-ip.com/free/dbip-country-lite-2025-01.mmdb.gz');
    $response = $socket->doGet();
    
    if ($response->isOk()) {
        $body = $response->getBody();
        $body = gzdecode($body);
        rex_file::put(rex_path::addonData('statistics', 'ip2geo.mmdb'), $body);
    }
} catch (rex_socket_exception $e) {
    rex_logger::logException($e);
}
```

### POST-Request mit Basic Auth an API senden

```php
$socket = rex_socket::factory('hcti.io', 443, true);
$socket->setPath('/v1/image');
$socket->addBasicAuthorization($username, $api_key);

$data = [
    'html' => $html,
    'selector' => 'main',
    'viewport_width' => 1200,
    'viewport_height' => 630,
];

$response = $socket->doPost($data);

if ($response->isOk()) {
    $result = json_decode($response->getBody(), true);
    $imageUrl = $result['url'] ?? null;
}
```

### JSON-API mit Custom Headers

```php
$socket = rex_socket::factoryUrl('https://api.openai.com/v1/completions');
$socket->addHeader('Authorization', 'Bearer ' . $apiKey);
$socket->addHeader('Content-Type', 'application/json');

$response = $socket->doPost(json_encode(['prompt' => 'Hello', 'max_tokens' => 50]));

if ($response->isSuccessful()) {
    $data = json_decode($response->getBody(), true);
}
```

### SSL-Optionen für selbstsignierte Zertifikate

```php
$socket = rex_socket::factory('internal-api.local', 443, true);
$socket->setOptions([
    'ssl' => [
        'verify_peer' => false,
        'verify_peer_name' => false,
    ],
]);
$response = $socket->doGet();
```

### Große Dateien chunk-weise verarbeiten

```php
$response = $socket->doGet();
$file = fopen(rex_path::addonData('addon', 'download.zip'), 'w');

while (false !== ($chunk = $response->getBufferedBody(8192))) {
    fwrite($file, $chunk);
}
fclose($file);
```

### Redirects automatisch folgen

```php
$socket = rex_socket::factoryUrl('https://short.url/abc');
$socket->followRedirects(5); // Max 5 Redirects
$response = $socket->doGet();
```

## Proxy-Unterstützung

### Globaler Proxy (config.yml)

```yaml
socket_proxy: 'http://proxy.company.com:8080'
```

### Proxy für einzelne Verbindung

```php
$socket = rex_socket_proxy::factoryUrl('http://proxy:8080')
    ->setDestinationUrl('https://api.example.com/data');
$response = $socket->doGet();
```

## Fehlerbehandlung

Alle Socket-Methoden können `rex_socket_exception` werfen:

```php
try {
    $response = rex_socket::factoryUrl($url)->doGet();
} catch (rex_socket_exception $e) {
    rex_logger::logException($e);
    // Fallback oder Fehlermeldung
}
```
