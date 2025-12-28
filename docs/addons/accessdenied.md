# Access Denied - Keywords: Zugriff, Sperren, Gesperrt, Status, Preview-Link, Sharing, Kategoriesperrung, Artikelstatus

## Übersicht

**Access Denied** erweitert REDAXO um einen zusätzlichen Status "gesperrt" für Artikel und Kategorien. Gesperrte Artikel sind im Frontend nicht aufrufbar und leiten automatisch zur 404-Seite um – außer mit Preview-Link oder aus dem Backend heraus. Ideal für Staging-Inhalte oder zeitlich begrenzte Freigaben.

**Autor:** Friends Of REDAXO  
**GitHub:** <https://github.com/FriendsOfREDAXO/accessdenied>  
**Abhängigkeiten:** REDAXO >= 5.17  
**Optional:** YRewrite (für Preview-Link-Generierung), search_it (Index-Update empfohlen)

---

## Kern-Klasse

| Klasse | Beschreibung |
|--------|--------------|
| `FriendsOfRedaxo\Accessdenied\Accessdenied` | Hauptklasse mit allen Sperre-Funktionen |

---

## Status-Werte

| Status | Wert | Beschreibung | Farbe |
|--------|------|--------------|-------|
| Offline | `0` | Standard REDAXO - im Frontend nicht aufrufbar | Grau |
| Online | `1` | Standard REDAXO - im Frontend aufrufbar | Grün |
| **Gesperrt** | `2` | Neu: leitet zu 404-Seite um (außer mit Preview-Link) | Rot |

---

## Methoden

| Methode | Beschreibung |
|---------|--------------|
| `initializeSearchItPrevention()` | Verhindert Indexierung gesperrter Artikel in search_it |
| `preventSearchItIndexing($ep)` | Extension-Point-Handler für Search It |
| `addLockedStatus($ep)` | Fügt Status "gesperrt" zu Artikel-/Kategorie-Status hinzu |
| `handleFrontendRedirect()` | Prüft Status und leitet ggf. zur 404-Seite um |
| `redirectToNotFound()` | Leitet zur Fehlerseite um |
| `setDefaultArticleStatus($ep)` | Setzt Default-Status bei neuem Artikel |
| `setDefaultCategoryStatus($ep)` | Setzt Default-Status bei neuer Kategorie |
| `addContentSidebar($ep)` | Zeigt Preview-Link-Panel in gesperrten Artikeln |

---

## Konfiguration

| Config-Key | Typ | Beschreibung | Default |
|------------|-----|--------------|---------|
| `default_status` | int | Standard-Status für neue Artikel/Kategorien (0, 1, 2) | `1` (Online) |
| `inherit` | bool | Vererbung der Sperrung auf Unterseiten aktivieren | `false` |
| `linkparameter` | string | GET-Parameter für Preview-Link | `'preview'` |

---

## 20 Praxisbeispiele

### 1. Artikel auf "gesperrt" setzen

```php
$article = rex_article::get(42);
rex_article_service::articleStatus(42, $article->getClang(), 2);
echo "Artikel gesperrt.";
```

### 2. Kategorie auf "gesperrt" setzen

```php
rex_category_service::categoryStatus(5, 1, 2);
echo "Kategorie gesperrt.";
```

### 3. Status eines Artikels prüfen

```php
$article = rex_article::getCurrent();
if ($article->getValue('status') == 2) {
    echo "Dieser Artikel ist gesperrt.";
}
```

### 4. Preview-Link generieren

```php
// Wird automatisch im Backend-Panel angezeigt
$previewLink = rex_yrewrite::getFullUrlByArticleId($articleId) . '?preview=id-' . $articleId;
echo '<a href="' . $previewLink . '">Vorschau</a>';
```

### 5. Artikel mit Preview-Link aufrufen

```
https://example.org/gesperrter-artikel?preview=id-42
```

### 6. Prüfen, ob Preview-Link verwendet wird

```php
$linkparameter = rex_config::get('accessdenied', 'linkparameter', 'preview');
$articleId = rex_article::getCurrent()->getId();

if (rex_request($linkparameter, 'string', '') == 'id-' . $articleId) {
    echo "Preview-Modus aktiv!";
}
```

### 7. Default-Status auf "gesperrt" setzen

```php
// Neue Artikel/Kategorien werden standardmäßig gesperrt
rex_config::set('accessdenied', 'default_status', 2);
```

### 8. Default-Status auf "online" setzen

```php
rex_config::set('accessdenied', 'default_status', 1);
```

### 9. Vererbung aktivieren

```php
// Gesperrte Kategorien sperren auch Unterseiten
rex_config::set('accessdenied', 'inherit', true);
```

### 10. Vererbung deaktivieren

```php
rex_config::set('accessdenied', 'inherit', false);
```

### 11. Custom Preview-Parameter

```php
// Statt ?preview=id-42 → ?staging=id-42
rex_config::set('accessdenied', 'linkparameter', 'staging');
```

### 12. Prüfen, ob Artikel in gesperrter Kategorie

```php
$cat = rex_category::getCurrent();
$package = rex_addon::get('accessdenied');

if ($package->getConfig('inherit') == true && 
    $cat && 
    $cat->getClosest(fn (rex_category $cat) => 2 == $cat->getValue('status'))) {
    echo "Diese Kategorie oder eine Elternkategorie ist gesperrt.";
}
```

### 13. Extension Point: Redirect verhindern

```php
// boot.php
rex_extension::register('PACKAGES_INCLUDED', function($ep) {
    // Custom Logic vor Access Denied Redirect
    if (rex_article::getCurrent()->getValue('status') == 2) {
        // Eigene Logik statt 404-Redirect
    }
}, rex_extension::EARLY); // Vor LATE von Access Denied
```

### 14. Search It Index bei Sperrung aktualisieren

```php
// Nach Änderung des Status
rex_article_service::articleStatus($articleId, $clangId, 2);

if (rex_addon::get('search_it')->isAvailable()) {
    search_it_indexer::factory()->indexArticle($articleId);
}
```

### 15. Alle gesperrten Artikel finden

```php
$sql = rex_sql::factory();
$articles = $sql->getArray('SELECT * FROM rex_article WHERE status = 2');

foreach ($articles as $article) {
    echo rex_article::get($article['id'])->getName() . '<br>';
}
```

### 16. Alle gesperrten Kategorien finden

```php
$sql = rex_sql::factory();
$categories = $sql->getArray('SELECT * FROM rex_article WHERE pid = 0 AND status = 2');

foreach ($categories as $cat) {
    echo rex_category::get($cat['id'])->getName() . '<br>';
}
```

### 17. Backend-Check: Aus Backend aufgerufen?

```php
if (rex_backend_login::hasSession()) {
    echo "Zugriff aus Backend - gesperrte Artikel werden angezeigt.";
}
```

### 18. Quick Navigation Styling

```css
/* Automatisch geladen - gesperrte Artikel in rot */
a.quicknavi_left.qn_status_2 {
    opacity: 0.6;
    border-left: 8px solid #FF4040;
}
```

### 19. Multi-Domain: Preview nur für eigene Domain

```php
// Bei Multi-Domain-Setup muss User unter passender Domain eingeloggt sein
$currentDomain = rex_yrewrite::getCurrentDomain();
if ($currentDomain && !rex_backend_login::hasSession()) {
    // Redirect zu 404
    rex_redirect(rex_article::getNotfoundArticleId(), rex_clang::getCurrentId());
}
```

### 20. Deinstallation: Alle gesperrten Artikel auf offline setzen

```php
// Wird automatisch bei Deinstallation ausgeführt
$sql = rex_sql::factory();
$sql->setQuery('UPDATE ' . rex::getTablePrefix() . 'article SET status=0 WHERE status = 2');
rex_addon::get('structure')->clearCache();
```

---

## Backend-Integration

### Status-Auswahl

- In Artikel-/Kategorie-Einstellungen erscheint neuer Status "gesperrt"
- Rot markiert mit Warndreieck-Symbol (fa fa-exclamation-triangle)

### Preview-Link-Panel

- Bei gesperrten Artikeln wird automatisch ein Panel angezeigt
- Enthält Share-Link mit Preview-Parameter
- Copy-to-Clipboard-Button für einfaches Teilen
- Erscheint in Content-Sidebar

### Quick Navigation

- Gesperrte Artikel werden mit rotem Rand dargestellt
- Opacity 0.6 zur visuellen Unterscheidung
- Funktioniert mit Quick Navigation >= 8.1

---

## Settings (System → Access denied)

1. **Default-Status:** Wähle, ob neue Artikel/Kategorien standardmäßig offline, online oder gesperrt angelegt werden
2. **Vererbung:** Aktiviere/deaktiviere die Vererbung von Kategorie-Sperrungen auf Unterkategorien und Artikel
3. **Link-Parameter:** Passe den GET-Parameter für Preview-Links an (Standard: `preview`)

---

## Frontend-Verhalten

### Normale Anfrage (ohne Preview-Link)

```
https://example.org/gesperrter-artikel
→ Redirect zu 404-Seite (rex_article::getNotfoundArticleId())
```

### Mit Preview-Link

```
https://example.org/gesperrter-artikel?preview=id-42
→ Artikel wird normal angezeigt
```

### Aus Backend

```
User eingeloggt im Backend
→ Artikel wird normal angezeigt
```

---

## Vererbungs-Logik

### Kategorie gesperrt + Vererbung aktiv

```
Kategorie "News" (Status: gesperrt)
  ├─ Artikel "News 1" (Status: online) → trotzdem gesperrt durch Vererbung
  ├─ Unterkategorie "Archiv" (Status: online) → trotzdem gesperrt
  │   └─ Artikel "Alt" (Status: online) → trotzdem gesperrt
```

### Kategorie gesperrt + Vererbung inaktiv

```
Kategorie "News" (Status: gesperrt)
  ├─ Artikel "News 1" (Status: online) → aufrufbar
  ├─ Unterkategorie "Archiv" (Status: online) → aufrufbar
```

---

## Search It Integration

```php
// Automatisch registriert in boot.php
Accessdenied::initializeSearchItPrevention();

// Extension Point Handler
rex_extension::register('SEARCH_IT_INDEX_ARTICLE', 
    [Accessdenied::class, 'preventSearchItIndexing']);

// Logik
if ($article->getValue('status') == 2) {
    return false; // Artikel nicht indexieren
}
if ($inherit && $cat->getClosest(fn($cat) => 2 == $cat->getValue('status'))) {
    return false; // Artikel in gesperrter Kategorie nicht indexieren
}
```

---

## Hinweise

⚠️ **Search It:** Index nach Sperrung neu generieren für konsistente Suchergebnisse

⚠️ **Multi-Domain:** REDAXO-Benutzer muss unter jeweiliger Domain eingeloggt sein ([Issue #22](https://github.com/FriendsOfREDAXO/accessdenied/issues/22))

⚠️ **Deinstallation:** Alle gesperrten Artikel werden automatisch auf "offline" gesetzt

⚠️ **Preview-Link-Sicherheit:** Link-Parameter ist vorhersehbar - nutze starke Artikel-IDs oder Custom-Parameter

---

## Verwandte Addons

- [YRewrite](yrewrite.md) - URL-Management (für FullUrl in Preview-Links)
- [Search It](search_it.md) - Verhindert Indexierung gesperrter Artikel
- [Quick Navigation](https://github.com/FriendsOfREDAXO/quick_navigation) - Visuelle Markierung im Backend

---

**GitHub:** <https://github.com/FriendsOfREDAXO/accessdenied>
