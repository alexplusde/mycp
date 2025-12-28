# Speed Up - Performance-Optimierung

**Keywords:** Speed, Performance, Prefetch, Preload, Cache, Tracking, Hover, Assets

## Übersicht

Speed Up optimiert die wahrgenommene Ladezeit durch Prefetching (nächste Seiten vorladen), Preloading (kritische Ressourcen) und Cache-Busting.

## Kern-Klassen

| Klasse | Beschreibung |
|--------|-------------|
| `speed_up` | Prefetch-URLs generieren, Output erzeugen |
| `speed_up_tracking` | Beliebtheit-basiertes Prefetching |
| `speed_up_asset` | Assets mit Timestamp (Cache-Buster) |
| `speed_up_theme` | Theme-Assets mit Timestamp |
| `speed_up_expires_checker` | Expires-Header-Prüfung |

## Klasse: speed_up

### Wichtige Methoden

| Methode | Rückgabe | Beschreibung |
|---------|----------|-------------|
| `::getConfig($key)` | `mixed` | Config-Wert abrufen |
| `getUrls()` | `self` | URLs generieren (Nachbarn, Kinder, Popular) |
| `getOutput()` | `string` | `<link rel="prefetch">` Tags |
| `showOutput()` | `void` | Output direkt ausgeben |

## Klasse: speed_up_tracking

### Wichtige Methoden

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|-------------|
| `::track($url_from, $url_to, $article_id_from, $clang_id_from, $article_id_to, $clang_id_to)` | `string, string, ?int, ?int, ?int, ?int` | `void` | Seitenübergang speichern |
| `::getTopUrls($url_from, $limit)` | `string, int` | `array` | Top-3 häufigste Ziel-URLs |
| `::deleteByArticle($article_id, $clang_id)` | `int, int` | `void` | Tracking für Artikel löschen |
| `::cleanupOldEntries($maxEntriesPerUrl)` | `int` | `void` | Alte Einträge begrenzen (max 255 pro URL) |

## Klasse: speed_up_asset

### Wichtige Methoden

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|-------------|
| `::getUrl($file, $show_timestamp)` | `string, bool` | `string` | URL mit Timestamp |
| `::getScript($file, $show_timestamp)` | `string, bool` | `string` | `<script>` Tag |
| `::getLink($file, $show_timestamp, $attributes)` | `string, bool, array` | `string` | `<link>` Tag |

## Klasse: speed_up_theme

### Wichtige Methoden

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|-------------|
| `::getUrl($file, $show_timestamp)` | `string, bool` | `string` | Theme-Asset-URL mit Timestamp |
| `::getScript($file, $show_timestamp)` | `string, bool` | `string` | `<script>` für Theme |
| `::getLink($file, $show_timestamp, $attributes)` | `string, bool, array` | `string` | `<link>` für Theme |

## Profile

| Profil | Beschreibung |
|--------|-------------|
| `disabled` | Keine Ausgabe |
| `custom` | Nur manuelle Codes + EP |
| `auto` (Standard) | Startseite, 2 Nachbarn, 2 Artikel, 1 Kind-Kategorie |
| `aggressive` | Alle Nachbarn, alle Artikel, alle Kinder |

## Praxisbeispiele

### 1. Automatische Einbindung

```php
// In Einstellungen aktivieren: "Automatisch einbinden"
// Dann in Template HEAD-Bereich nichts weiter nötig
```

### 2. Manuelle Einbindung

```php
<?php if (rex::isFrontend()): ?>
    REX_SPEED_UP[]
<?php endif; ?>
```

### 3. Profil setzen

```php
// Backend: System > Speed Up! > Einstellungen
rex_config::set('speed_up', 'profile', 'auto');
```

### 4. Zusätzliches Prefetching

```php
// Backend: Zusätzliches Prefetching-Feld
<link rel="prefetch" href="/wichtige-seite/">
<link rel="prefetch" href="/kontakt/">
```

### 5. Zusätzliches Preloading

```php
// Backend: Zusätzliches Preloading-Feld
<link rel="preload" href="/assets/fonts/font.woff2" as="font" type="font/woff2" crossorigin>
<link rel="preload" href="/media/hero.jpg" as="image">
```

### 6. Webfont preloaden

```php
<link rel="preload" href="<?= speed_up_asset::getUrl('fonts/font.woff2') ?>" as="font" type="font/woff2" crossorigin>
```

### 7. CSS/JS mit Cache-Busting

```php
<script src="<?= speed_up_asset::getUrl('project/js/script.js') ?>"></script>
<link href="<?= speed_up_asset::getUrl('project/css/style.css') ?>" rel="stylesheet">
```

### 8. Verkürzte Schreibweise

```php
<?= speed_up_asset::getScript('project/js/script.js') ?>
<?= speed_up_asset::getLink('project/css/style.css') ?>
```

### 9. Mit Attributen

```php
<?= speed_up_asset::getLink('project/css/print.css', true, ['media' => 'print']) ?>
<?= speed_up_asset::getLink('project/css/custom.css', true, ['rel' => 'preload', 'as' => 'style']) ?>
```

### 10. Theme-Assets

```php
<script src="<?= speed_up_theme::getUrl('frontend/js/app.js') ?>"></script>
<link href="<?= speed_up_theme::getUrl('frontend/css/styles.css') ?>" rel="stylesheet">
```

### 11. Theme verkürzt

```php
<?= speed_up_theme::getScript('frontend/js/app.js') ?>
<?= speed_up_theme::getLink('frontend/css/styles.css') ?>
```

### 12. Beliebtheit-basiertes Prefetching

```php
// Backend: "Beliebtheit-basiertes Prefetching aktivieren"
// Trackt automatisch, fügt Top-3 häufigste Ziele hinzu
```

### 13. Tracking manuell aufrufen

```php
use speed_up_tracking;

speed_up_tracking::track(
    '/seite-a/',
    '/seite-b/',
    10, // article_id_from
    1,  // clang_id_from
    20, // article_id_to
    1   // clang_id_to
);
```

### 14. Top-URLs abrufen

```php
$topUrls = speed_up_tracking::getTopUrls('/seite-a/', 3);
foreach ($topUrls as $url) {
    echo '<link rel="prefetch" href="' . $url . '">';
}
```

### 15. Tracking bereinigen

```php
// Behält nur 255 neueste Einträge pro URL
speed_up_tracking::cleanupOldEntries(255);
```

### 16. Hover-basiertes Prefetching

```php
// Backend: "Hover-basiertes Prefetching" aktivieren
// JavaScript lädt Seiten bei Hover/Touch/Focus
```

### 17. Extension Point PREFETCH_URLS

```php
rex_extension::register('PREFETCH_URLS', function(\rex_extension_point $ep) {
    $urls = $ep->getSubject();
    
    // Eigene URLs hinzufügen
    $urls[] = '/spezial-seite/';
    
    return $urls;
});
```

### 18. Artikel vom Prefetching ausschließen

```php
// Backend: System > Speed Up! > Artikel
// Checkbox pro Artikel: "Prefetching deaktivieren"
```

### 19. REX_VAR verwenden

```php
<script src="REX_VAR_SPEED_UP_ASSET[file='project/js/script.js']"></script>
```

### 20. Expires-Header prüfen

```php
// Backend: System > Speed Up! > Einstellungen
// Button: "Expires-Header prüfen"
// Zeigt Status für CSS/JS/Bilder/Fonts
```

### 21. YCom-Seiten ausschließen

```php
// Automatisch: Login, Logout, Registrierung, Passwort-Reset
// Werden nicht geprefetcht
```

### 22. Programmatisch URLs generieren

```php
$speedup = new speed_up();
$speedup->getUrls();
echo $speedup->getOutput();
```

### 23. Custom Profil

```php
rex_config::set('speed_up', 'profile', 'custom');

rex_extension::register('PREFETCH_URLS', function($ep) {
    return ['/seite1/', '/seite2/', '/seite3/'];
});
```

### 24. Medienpool-Bilder preloaden

```php
// Backend: "Medienpool-Dateien für Preloading"
// Wähle Hero-Image, Logo etc.
```

### 25. Cache-Busting ohne Timestamp

```php
$url = speed_up_asset::getUrl('project/js/script.js', false);
// Liefert /assets/project/js/script.js (ohne ?timestamp=...)
```

> **Integration:** Speed Up arbeitet mit **YRewrite** (Domains, Artikel-URLs), **Structure** (Nachbarn, Kategorien), **YCom** (Login-Seiten ausschließen), **URL-Addon** (Profile-URLs), **Media Manager** (Bild-Prefetching) und nutzt **rex_extension** (PREFETCH_URLS) für Anpassungen. JavaScript-Modul für Hover-Prefetch unterstützt Touch-Geräte und Barrierefreiheit.
