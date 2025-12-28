# Search It with GPT - Keywords: Search It, OpenAI, GPT, ChatGPT, Custom GPT, OpenAPI, Search API, KI-Suche

## Übersicht

**Search It with GPT** ermöglicht die Integration von REDAXO Search It als Datenquelle für eigene GPTs von OpenAI. Das Add-on stellt eine OpenAPI-Schnittstelle bereit, über die ChatGPT-Plus-Nutzer ihre Website-Inhalte durchsuchen und in GPT-Antworten einbinden können.

**Autor:** Alexander Walther  
**GitHub:** <https://github.com/alexplusde/search_it_with_gpt>  
**Abhängigkeiten:** Search It >= 6.10.0, YRewrite >= 2.10.0, ChatGPT Plus-Abo

---

## Kern-Klasse

| Klasse | Beschreibung |
|--------|--------------|
| `rex_api_search_it_with_gpt` | API-Endpunkt für Suchanfragen von OpenAI GPT |

---

## API-Endpunkt

**URL:** `/?rex-api-call=search_it_with_gpt&search={query}`

**Authentifizierung:** Custom Header `X-SearchItWithGpt-Token`

**Methode:** GET

**Parameter:**

- `rex-api-call`: Muss `search_it_with_gpt` sein
- `search`: Suchbegriff (1-2 Wörter empfohlen)

---

## 20 Praxisbeispiele

### 1. API-Key bei Installation

```php
// Wird automatisch generiert
rex_config::set('search_it_with_gpt', 'token', bin2hex(random_bytes(32)));
```

### 2. API-Key abrufen

```php
$apiKey = rex_config::get('search_it_with_gpt', 'token');
echo "API-Key: " . $apiKey;
```

### 3. Suchanfrage per API

```bash
curl -X GET "https://example.org/?rex-api-call=search_it_with_gpt&search=kontakt" \
  -H "X-SearchItWithGpt-Token: YOUR_API_KEY"
```

### 4. API-Response-Format

```json
{
  "status": true,
  "count": 5,
  "results": [
    {
      "title": "Kontakt",
      "url": "https://example.org/kontakt",
      "teaser": "Kontaktieren Sie uns...",
      "content": "Vollständiger Seiteninhalt..."
    }
  ]
}
```

### 5. Fehlerbehandlung - Kein API-Key

```json
{
  "error": "Authentifizierung erforderlich"
}
```

### 6. Fehlerbehandlung - Ungültiger API-Key

```json
{
  "error": "Ungültiger API-Key"
}
```

### 7. Fehlerbehandlung - Fehlender Suchbegriff

```json
{
  "status": false,
  "message": "Suchbegriff fehlt."
}
```

### 8. Fehlerbehandlung - Keine Ergebnisse

```json
{
  "status": true,
  "count": 0,
  "message": "Keine Ergebnisse gefunden."
}
```

### 9. Search It-Integration (Artikel)

```php
// Automatisch: Durchsucht Artikel-Inhalte
$article = rex_article::get($hit['fid']);
$yrewrite = new rex_yrewrite_seo($article->getId());
```

### 10. Search It-Integration (URL-Addon)

```php
// Automatisch: Durchsucht URL-Addon-Einträge
$url_sql = rex_sql::factory();
$url_sql->setTable(search_it_getUrlAddOnTableName());
$url_sql->setWhere(['url_hash' => $hit['fid']]);
```

### 11. Ergebnis-Formatierung (Artikel)

```php
$formattedResults[] = [
    'title' => $yrewrite->getTitle(),
    'url' => rex_yrewrite::getFullPath(ltrim(rex_getUrl($hit['fid'], $hit['clang']), '/')),
    'teaser' => $hit['highlightedtext'],
    'content' => $hit['plaintext'],
];
```

### 12. Ergebnis-Formatierung (URL-Addon)

```php
$url_seo = json_decode($url_hit['seo'], true);
$formattedResults[] = [
    'title' => $url_seo['title'],
    'url' => $url_hit['url'],
    'teaser' => strip_tags($url_seo['description']),
    'content' => preg_replace('/\s+/', ' ', strip_tags($hit['unchangedtext'])),
];
```

### 13. OpenAPI-Schema (Header)

```yaml
openapi: 3.0.0
info:
  title: SearchItExtensionAPI
  description: Stellt zusätzliche Informationen anhand der Website-Suchfunktion bereit.
  version: 1.0.0
servers:
  - url: https://example.org/
    description: Website-Suchergebnisse
```

### 14. OpenAPI-Schema (Security)

```yaml
components:
  securitySchemes:
    ApiKeyAuth:
      type: apiKey
      in: header
      name: X-SearchItWithGpt-Token
security:
  - ApiKeyAuth: []
```

### 15. OpenAPI-Schema (Endpoint)

```yaml
paths:
  /:
    get:
      operationId: searchQuery
      summary: Führt eine Suchanfrage durch
      parameters:
        - in: query
          name: rex-api-call
          required: true
          schema:
            type: string
            default: search_it_with_gpt
        - in: query
          name: search
          required: true
          description: Suchbegriff (1-2 Wörter)
          schema:
            type: string
```

### 16. OpenAPI-Schema (Response)

```yaml
responses:
  "200":
    description: Liste von Suchergebnissen
    content:
      application/json:
        schema:
          type: object
          properties:
            status:
              type: boolean
            count:
              type: integer
            results:
              type: array
              items:
                $ref: '#/components/schemas/SearchResult'
```

### 17. GPT-Action einrichten

```
1. Gehe zu https://chat.openai.com/gpts/editor
2. Wähle "Configure" → "Actions" → "Create new action"
3. Füge OpenAPI-Schema ein
4. Authentifizierung: API Key, Custom Header
5. Header-Name: X-SearchItWithGpt-Token
6. API-Key: Dein generierter Token
```

### 18. GPT-Instruction-Beispiel

```
Du bist ein hilfreicher Assistent für die Website example.org.
Nutze die searchQuery-Action, um relevante Inhalte zu finden.
Antworte nur basierend auf den Suchergebnissen.
```

### 19. Test der API

```php
// GET-Request mit cURL
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, 'https://example.org/?rex-api-call=search_it_with_gpt&search=kontakt');
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'X-SearchItWithGpt-Token: ' . $apiKey
]);
$response = curl_exec($ch);
curl_close($ch);

$data = json_decode($response, true);
```

### 20. Deinstallation

```php
// Entfernt Namespace-Config
rex_config::removeNamespace('search_it_with_gpt');
```

---

## OpenAPI-Schema (komplett)

```yaml
openapi: 3.0.0
info:
  title: SearchItExtensionAPI
  description: Stellt zusätzliche Informationen anhand der Website-Suchfunktion bereit.
  version: 1.0.0
servers:
  - url: https://example.org/
    description: Website-Suchergebnisse
paths:
  /:
    get:
      operationId: searchQuery
      summary: Führt eine Suchanfrage durch und gibt Ergebnisse zurück
      parameters:
        - in: query
          name: rex-api-call
          required: true
          schema:
            type: string
            default: search_it_with_gpt
        - in: query
          name: search
          required: true
          description: Suchbegriff (1-2 Wörter)
          schema:
            type: string
      responses:
        "200":
          description: Liste von Suchergebnissen
          content:
            application/json:
              schema:
                type: object
                properties:
                  status:
                    type: boolean
                  count:
                    type: integer
                  results:
                    type: array
                    items:
                      $ref: '#/components/schemas/SearchResult'
components:
  securitySchemes:
    ApiKeyAuth:
      type: apiKey
      in: header
      name: X-SearchItWithGpt-Token
  schemas:
    SearchResult:
      type: object
      properties:
        title:
          type: string
        url:
          type: string
        teaser:
          type: string
        content:
          type: string
security:
  - ApiKeyAuth: []
```

---

## GPT-Einrichtung

1. **GPT erstellen:** <https://chat.openai.com/gpts/editor>
2. **Configure → Actions → Create new action**
3. **OpenAPI-Schema einfügen** (siehe oben)
4. **Authentifizierung:**
   - Type: API Key
   - Auth Type: Custom
   - Custom Header Name: `X-SearchItWithGpt-Token`
   - API Key: Aus REDAXO-Backend (Search It → OpenAPI für GPT)
5. **Privacy Policy:** URL zur Datenschutzseite angeben
6. **Test Action:** Testanfrage durchführen

---

## Hinweise

⚠️ **URL-Suchtreffer werden derzeit nicht unterstützt** - nur Article-Treffer.

⚠️ **Nur aktuelle Sprache** - Suche erfolgt nur in der aktuellen Website-Sprache.

⚠️ **Rechtliche Prüfung erforderlich** - DSGVO-Konformität und OpenAI-Nutzung anwaltlich klären.

---

## Verwandte Addons

- [Search It](search_it.md) - Volltext-Suchfunktion
- [YRewrite](yrewrite.md) - URL-Management

---

**GitHub:** <https://github.com/alexplusde/search_it_with_gpt>
