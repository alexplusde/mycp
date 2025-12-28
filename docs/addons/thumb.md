# Thumb - OpenGraph-Bildgenerator | Keywords: OpenGraph, Social Media, SEO, Preview, Screenshot, HTML2Image, Meta-Tags, Bildgenerator

**Übersicht**: Generiert automatisch OpenGraph/Social-Media-Preview-Bilder aus HTML/SVG-Templates via API (htmlcsstoimage.com oder html2image.net). Integriert sich mit Media Manager, YRewrite und dem URL-Addon für optimierte Social-Media-Vorschauen.

## API-Provider

| Provider | Basis-URL |
|----------|-----------|
| `HCTI` | htmlcsstoimage.com |
| `H2IN` | html2image.net |

## SEO-Image-Modi

| Modus | Beschreibung |
|-------|-------------|
| `ignore` | Keinen og:image Tag ausgeben |
| `replace` | og:image mit generiertem Bild ersetzen |
| `background` | Generiertes Bild nur wenn kein og:image vorhanden |

## Media-Manager-Effekte

| Effekt | Zweck |
|--------|-------|
| `thumb_generator` | Generiert OpenGraph-Bild |
| `thumb_cache` | Cached generiertes Bild |

## Template-Typen

| Typ | Format | Verwendung |
|-----|--------|------------|
| `HTML` | HTML/CSS | Dynamisches Layout |
| `SVG` | SVG | Vektorgrafik |

## Praxisbeispiele

### Beispiel 1: API-Zugangsdaten konfigurieren

Im Backend unter `System` > `Thumb`:

- **Provider**: HCTI (htmlcsstoimage.com)
- **User ID**: Ihre User ID
- **API Key**: Ihr API Key
- Test-Button klicken zur Validierung

### Beispiel 2: HTML-Fragment als Template

```php
// Fragment: thumb/my_template.php
<!DOCTYPE html>
<html>
<head>
<style>
body {
    width: 1200px;
    height: 630px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    display: flex;
    align-items: center;
    justify-content: center;
    font-family: Arial, sans-serif;
}
.title {
    color: white;
    font-size: 64px;
    text-align: center;
    padding: 40px;
}
</style>
</head>
<body>
    <div class="title"><?= $this->article->getName() ?></div>
</body>
</html>
```

### Beispiel 3: SVG-Template

```php
// Fragment: thumb/logo_template.php
<svg width="1200" height="630" xmlns="http://www.w3.org/2000/svg">
    <rect width="1200" height="630" fill="#1a1a1a"/>
    <text x="50%" y="50%" text-anchor="middle" 
          font-family="Arial" font-size="72" fill="white">
        <?= htmlspecialchars($this->article->getName()) ?>
    </text>
</svg>
```

### Beispiel 4: Media-Manager-Profil erstellen

Backend unter `Medienpool` > `Media Manager`:

- **Profilname**: og_image
- **Effekt hinzufügen**: thumb_generator
- **Template**: my_template
- **Breite**: 1200px
- **Höhe**: 630px

### Beispiel 5: YRewrite Integration

```php
// Im Template: <head>-Bereich
<?php
$article = rex_article::getCurrent();
$og_image = rex_media_manager::getUrl('og_image', $article->getId() . '.jpg');
?>
<meta property="og:image" content="<?= rex_url::base() . $og_image ?>">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
```

### Beispiel 6: URL-Addon Integration

```php
// Extension Point: YREWRITE_SEO_TAGS
rex_extension::register('YREWRITE_SEO_TAGS', function($ep) {
    $article = $ep->getParam('article');
    
    $og_image = rex_media_manager::getUrl('og_image', $article->getId() . '.jpg');
    
    $ep->setSubject([
        'og:image' => rex_url::base() . $og_image,
        'og:image:width' => 1200,
        'og:image:height' => 630,
        'twitter:card' => 'summary_large_image',
        'twitter:image' => rex_url::base() . $og_image,
    ]);
});
```

### Beispiel 7: Dynamische Daten im Template

```php
// Fragment: thumb/article_preview.php
<?php
$article = $this->article;
$author = $article->getValue('author');
$date = date('d.m.Y', strtotime($article->getValue('createdate')));
?>
<!DOCTYPE html>
<html>
<head>
<style>
body {
    width: 1200px;
    height: 630px;
    background: #ffffff;
    font-family: 'Segoe UI', Tahoma, sans-serif;
    padding: 60px;
    box-sizing: border-box;
}
h1 { font-size: 48px; color: #333; margin-bottom: 20px; }
.meta { font-size: 24px; color: #666; }
</style>
</head>
<body>
    <h1><?= htmlspecialchars($article->getName()) ?></h1>
    <div class="meta">Von <?= $author ?> | <?= $date ?></div>
</body>
</html>
```

### Beispiel 8: API testen

```php
// System > Thumb > Test API
// Sendet Test-Request an gewählten Provider

use Alexplusde\Thumb\Thumb;

$thumb = new Thumb();
$result = $thumb->testApi();

if ($result['success']) {
    echo 'API funktioniert!';
    echo '<img src="' . $result['url'] . '">';
}
```

### Beispiel 9: SEO-Image-Modus konfigurieren

Im Backend unter `System` > `Thumb` > `Einstellungen`:

- **SEO Image Mode**: replace
- Ersetzt vorhandene og:image Tags mit generiertem Bild

### Beispiel 10: Background-Modus

```php
// SEO Image Mode: background
// Generiert nur Bild, wenn kein og:image vorhanden

// Nützlich für Artikel ohne Beitragsbild
```

### Beispiel 11: Cache-Verwaltung

```php
// Media Manager cached generierte Bilder automatisch
// Manuelles Cache-Löschen:

$article_id = 42;
$cache_file = rex_path::addonCache('thumb', 'og_image_' . $article_id . '.jpg');

if (file_exists($cache_file)) {
    unlink($cache_file);
}
```

### Beispiel 12: Template mit Logo

```php
// Fragment: thumb/with_logo.php
<?php
$logo = rex_media::get('logo.svg');
?>
<!DOCTYPE html>
<html>
<head>
<style>
body { width: 1200px; height: 630px; background: #f0f0f0; padding: 80px; }
.logo { width: 150px; margin-bottom: 40px; }
h1 { font-size: 56px; color: #333; }
</style>
</head>
<body>
    <img src="<?= rex_url::media($logo->getFileName()) ?>" class="logo">
    <h1><?= $this->article->getName() ?></h1>
</body>
</html>
```

### Beispiel 13: Mehrere Templates

```php
// Template für News-Artikel
rex_media_manager::getUrl('og_news', $article_id . '.jpg');

// Template für Produkte
rex_media_manager::getUrl('og_product', $article_id . '.jpg');

// Template für Events
rex_media_manager::getUrl('og_event', $article_id . '.jpg');

// Jeweils eigenes Media-Manager-Profil mit eigenem Fragment
```

### Beispiel 14: CSS Grid Layout

```php
// Fragment: thumb/grid_layout.php
<!DOCTYPE html>
<html>
<head>
<style>
body {
    width: 1200px;
    height: 630px;
    display: grid;
    grid-template-columns: 2fr 1fr;
    gap: 40px;
    padding: 60px;
    background: #667eea;
}
.content { color: white; }
.image { 
    background: url('<?= rex_url::media('preview.jpg') ?>');
    background-size: cover;
    border-radius: 12px;
}
</style>
</head>
<body>
    <div class="content">
        <h1><?= $this->article->getName() ?></h1>
    </div>
    <div class="image"></div>
</body>
</html>
```

### Beispiel 15: YForm-Tabellen-Integration

```php
// OpenGraph für YForm-Detailseite
$entry = rex_yform_manager_dataset::get($id, 'rex_events');

$og_image = rex_media_manager::getUrl('og_event', 'event_' . $entry->getId() . '.jpg');

echo '<meta property="og:image" content="' . rex_url::base() . $og_image . '">';
```

### Beispiel 16: Fragment-Variablen

```php
// Fragment: thumb/custom.php
<?php
// Verfügbare Variablen:
// $this->article - rex_article Objekt
// $this->clang_id - Sprach-ID
// $this->domain - YRewrite Domain

$title = $this->article->getName();
$category = $this->article->getCategory()->getName();
?>
<!DOCTYPE html>
<html>
<head>
<style>
body { width: 1200px; height: 630px; padding: 80px; background: #1a1a1a; color: white; }
h1 { font-size: 64px; }
.category { font-size: 32px; color: #999; }
</style>
</head>
<body>
    <div class="category"><?= $category ?></div>
    <h1><?= $title ?></h1>
</body>
</html>
```

### Beispiel 17: Error Handling

```php
use Alexplusde\Thumb\Thumb;

try {
    $thumb = new Thumb();
    $result = $thumb->generate([
        'html' => '<div>Test</div>',
        'css' => 'div { width: 1200px; height: 630px; }'
    ]);
    
    if ($result['success']) {
        $image_url = $result['url'];
    } else {
        rex_logger::logError('thumb', $result['message']);
    }
} catch (Exception $e) {
    rex_logger::logException($e);
}
```

### Beispiel 18: Google Fonts einbinden

```php
// Fragment: thumb/with_fonts.php
<!DOCTYPE html>
<html>
<head>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@700&display=swap" rel="stylesheet">
<style>
body {
    width: 1200px;
    height: 630px;
    font-family: 'Poppins', sans-serif;
    background: #000;
    color: #fff;
    display: flex;
    align-items: center;
    justify-content: center;
}
h1 { font-size: 72px; text-align: center; }
</style>
</head>
<body>
    <h1><?= $this->article->getName() ?></h1>
</body>
</html>
```

### Beispiel 19: Webhook-Integration

```php
// Bei Artikel-Änderung automatisch Bild neu generieren
rex_extension::register('ART_UPDATED', function($ep) {
    $article = $ep->getSubject();
    
    // Cache löschen
    $cache_file = rex_path::addonCache('thumb', 'og_image_' . $article->getId() . '.jpg');
    if (file_exists($cache_file)) {
        unlink($cache_file);
    }
    
    // Neues Bild generieren
    $og_image = rex_media_manager::getUrl('og_image', $article->getId() . '.jpg');
});
```

### Beispiel 20: Conditional Content

```php
// Fragment: thumb/conditional.php
<?php
$article = $this->article;
$has_image = $article->getValue('image') != '';
?>
<!DOCTYPE html>
<html>
<head>
<style>
body { width: 1200px; height: 630px; padding: 80px; }
.with-image { background: url('<?= rex_url::media($article->getValue('image')) ?>'); }
.no-image { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
</style>
</head>
<body class="<?= $has_image ? 'with-image' : 'no-image' ?>">
    <h1><?= $article->getName() ?></h1>
</body>
</html>
```

### Beispiel 21: Multi-Language Support

```php
// Extension Point für alle Sprachen
rex_extension::register('YREWRITE_SEO_TAGS', function($ep) {
    $article = $ep->getParam('article');
    $clang_id = rex_clang::getCurrentId();
    
    $og_image = rex_media_manager::getUrl(
        'og_image',
        $article->getId() . '_' . $clang_id . '.jpg'
    );
    
    $ep->setSubject([
        'og:image' => rex_url::base() . $og_image,
        'og:locale' => rex_clang::getCurrent()->getCode(),
    ]);
});
```

### Beispiel 22: Batch-Generierung

```php
// Alle Artikel-Bilder vorgenieren
$articles = rex_article::getRootArticles();

foreach ($articles as $article) {
    $og_image = rex_media_manager::getUrl('og_image', $article->getId() . '.jpg');
    
    // URL aufrufen = Bild generieren & cachen
    file_get_contents(rex_url::base() . $og_image);
    
    echo 'Generiert: ' . $article->getName() . '<br>';
}
```

### Beispiel 23: Custom Parameters

```php
// Zusätzliche Parameter an Template übergeben
$thumb = new Thumb();
$result = $thumb->generate([
    'html' => rex_fragment::factory('thumb/custom.php', [
        'article' => $article,
        'custom_param' => 'Mein Wert',
        'author_name' => 'Max Mustermann'
    ]),
]);
```

### Beispiel 24: Responsive Preview

```php
// Verschiedene Größen generieren
$sizes = [
    'og_large' => ['width' => 1200, 'height' => 630],  // Facebook
    'og_square' => ['width' => 1080, 'height' => 1080], // Instagram
    'og_twitter' => ['width' => 1200, 'height' => 600], // Twitter
];

foreach ($sizes as $profile => $size) {
    $url = rex_media_manager::getUrl($profile, $article->getId() . '.jpg');
    echo '<link rel="image_src" href="' . $url . '">';
}
```

### Beispiel 25: Debug-Modus

```php
// Template-Output überprüfen
$fragment = new rex_fragment();
$fragment->setVar('article', $article);
$html = $fragment->parse('thumb/my_template.php');

// HTML ausgeben zum Testen
echo '<pre>' . htmlspecialchars($html) . '</pre>';

// Oder direkt im Browser anzeigen
echo $html;
```

**Integration**: Media Manager (Effekt thumb_generator), YRewrite (Extension Point YREWRITE_SEO_TAGS), URL-Addon (SEO-Integration), Fragments (Template-System), htmlcsstoimage.com/html2image.net API, OpenGraph/Twitter Card Standards, rex_logger (Error Logging), Extension Points (ART_UPDATED für Cache-Refresh)
