# YRewrite - SEO-URLs & Multi-Domain

**Keywords:** URL Rewriting SEO Domain Multi-Domain Sitemap Robots Canonical Redirect

## Übersicht

SEO-Addon für sprechende URLs (`/news/archiv/` statt `?article_id=13`), Multi-Domain-Betrieb mit separaten Sprachen/Domains und umfangreiche SEO-Features (Sitemap, Robots.txt, Canonical-URLs).

## Kern-Klassen

### rex_yrewrite

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `::getDomains()` | - | array | Alle registrierten Domains |
| `::getDomainByName($name)` | string | rex_yrewrite_domain\|null | Domain per Name |
| `::getDomainById($id)` | int | rex_yrewrite_domain\|null | Domain per ID |
| `::getDomainByArticleId($id, $clang)` | int, int | rex_yrewrite_domain\|null | Domain eines Artikels |
| `::getCurrentDomain()` | - | rex_yrewrite_domain\|null | Aktuelle Domain (Frontend) |
| `::getDefaultDomain()` | - | rex_yrewrite_domain | Default-Domain |
| `::isDomainStartArticle($id, $clang)` | int, int | bool | Ist Artikel Startseite einer Domain? |
| `::getFullUrlByArticleId($id, $clang, $params)` | int, int, array | string | Vollständige URL mit Protokoll+Domain |
| `::getUrlByArticleId($id, $clang, $params)` | int, int, array | string | Relative URL (/news/artikel/) |
| `::getArticleIdByUrl($domain, $url)` | string, string | array\|false | Artikel-ID+clang aus URL |
| `::setScheme($scheme)` | rex_yrewrite_scheme | void | Custom URL-Schema setzen |
| `::getScheme()` | - | rex_yrewrite_scheme | Aktuelles URL-Schema |
| `::deleteCache()` | - | void | YRewrite-Cache löschen |
| `::generatePathFile($params)` | array | void | Pathlist-Cache neu generieren |

### rex_yrewrite_domain

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `getId()` | - | int | Domain-ID |
| `getName()` | string | - | Domain-URL (z.B. <https://example.com/>) |
| `getMountId()` | - | int | Mountpoint Artikel-ID |
| `getStartId()` | - | int | Startseiten Artikel-ID |
| `getNotfoundId()` | - | int | 404-Seiten Artikel-ID |
| `getClangs()` | - | array | Aktive Sprachen dieser Domain |
| `getStartClang()` | - | int | Standard-Sprache |
| `getTitle()` | - | string | Domain-Titel |
| `getTitleScheme()` | - | string | Title-Schema (z.B. "%T - %SN") |
| `getRobots()` | - | string | robots.txt Inhalt |
| `getSitemap()` | - | string | sitemap.xml URL |
| `getUrl($params)` | array | string | URL mit Parametern |
| `getFullUrl($article_id, $clang, $params)` | int, int, array | string | Vollständige Artikel-URL |

### rex_yrewrite_seo

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `::getTitleTag($article, $domain)` | rex_article, rex_yrewrite_domain | string | `<title>` für Artikel |
| `::getDescriptionTag($article)` | rex_article | string | Meta-Description Tag |
| `::getCanonicalUrl($article, $domain)` | rex_article, rex_yrewrite_domain | string | Canonical-URL |
| `::getHreflangTags($article, $domain)` | rex_article, rex_yrewrite_domain | string | Hreflang-Tags (Sprachen) |
| `::getMetaRobots($article)` | rex_article | string | Robots Meta-Tag (index/noindex) |
| `::getSitemap($domain)` | rex_yrewrite_domain | string | Sitemap.xml Ausgabe |
| `::getRobots($domain)` | rex_yrewrite_domain | string | Robots.txt Ausgabe |

### rex_yrewrite_forward

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `::getAll()` | - | array | Alle Weiterleitungen |
| `::get($id)` | int | array\|null | Weiterleitung per ID |
| `::add($from, $to, $type, $domain)` | string, string, int, int | bool | Weiterleitung erstellen |
| `::delete($id)` | int | bool | Weiterleitung löschen |
| `::redirect($from, $to, $type)` | string, string, int | void | HTTP-Redirect ausführen |

## Praxisbeispiele

### Domain registrieren

```php
// In boot.php - Domain hinzufügen
$domain = new rex_yrewrite_domain(
    'https://www.example.com/', // URL mit Protokoll
    1, // Mount-ID (0 = root)
    '/', // Path
    0, // ID (0 = neu)
    5, // Startartikel-ID
    7, // 404-Artikel-ID
    [1, 2], // Sprachen (1=DE, 2=EN)
    1, // Standard-Sprache
    '%T - Example', // Title-Schema
    '', // robots.txt
    '', // sitemap.xml
    false // Auto-Sprache?
);

rex_yrewrite::addDomain($domain);
rex_yrewrite::generatePathFile(['domain' => 'https://www.example.com/']);
```

### Alle Domains abrufen

```php
// Liste aller Domains
foreach (rex_yrewrite::getDomains() as $domain) {
    echo $domain->getName() . '<br>';
    echo 'Start-Artikel: ' . $domain->getStartId() . '<br>';
    echo 'Sprachen: ' . implode(', ', $domain->getClangs()) . '<br>';
}
```

### Aktuelle Domain (Frontend)

```php
// Im Frontend-Template
$domain = rex_yrewrite::getCurrentDomain();

if ($domain) {
    echo 'Aktuelle Domain: ' . $domain->getName();
    echo 'Standard-Sprache: ' . $domain->getStartClang();
    echo 'Title-Schema: ' . $domain->getTitleScheme();
}
```

### Domain per Artikel ermitteln

```php
// Domain eines Artikels
$article_id = 42;
$clang = 1;

$domain = rex_yrewrite::getDomainByArticleId($article_id, $clang);

if ($domain) {
    echo 'Artikel gehört zu Domain: ' . $domain->getName();
}

// Ist Artikel die Startseite?
if (rex_yrewrite::isDomainStartArticle($article_id, $clang)) {
    echo 'Artikel ist Startseite';
}
```

### URL generieren

```php
// Einfache URL
$url = rex_yrewrite::getUrlByArticleId(42, 1);
echo $url; // "/news/artikel-titel/"

// Mit Parametern
$url = rex_yrewrite::getUrlByArticleId(42, 1, ['id' => 123, 'page' => 2]);
echo $url; // "/news/artikel/?id=123&page=2"

// Vollständige URL (mit Domain)
$full_url = rex_yrewrite::getFullUrlByArticleId(42, 1);
echo $full_url; // "https://example.com/news/artikel/"

// Mit Parametern und Separator
$full_url = rex_yrewrite::getFullUrlByArticleId(42, 1, ['cat' => 5], '&');
echo $full_url; // "https://example.com/news/?cat=5"
```

### Artikel-ID aus URL ermitteln

```php
// URL zu Artikel-ID auflösen
$domain = 'https://www.example.com/';
$url = '/news/mein-artikel/';

$result = rex_yrewrite::getArticleIdByUrl($domain, $url);

if ($result) {
    $article_id = key($result); // Artikel-ID
    $clang = current($result); // Sprach-ID
    
    echo "Artikel: $article_id, Sprache: $clang";
} else {
    echo '404 - Artikel nicht gefunden';
}
```

### Navigation mit YRewrite-URLs

```php
// Navigation generieren
$nav = rex_navigation::factory();

echo '<ul>';
foreach ($nav->get(0, 1, true, true) as $item) {
    $url = rex_yrewrite::getUrlByArticleId($item['id'], rex_clang::getCurrentId());
    echo '<li><a href="' . $url . '">' . $item['name'] . '</a></li>';
}
echo '</ul>';
```

### Breadcrumb mit YRewrite

```php
// Breadcrumb
$article = rex_article::getCurrent();
$path = $article->getPathAsArray();

echo '<ol class="breadcrumb">';

// Startseite
$domain = rex_yrewrite::getCurrentDomain();
if ($domain) {
    $start_url = rex_yrewrite::getUrlByArticleId($domain->getStartId(), rex_clang::getCurrentId());
    echo '<li><a href="' . $start_url . '">Home</a></li>';
}

// Pfad
foreach ($path as $article_id) {
    $nav_article = rex_article::get($article_id);
    if ($nav_article) {
        $url = rex_yrewrite::getUrlByArticleId($article_id, rex_clang::getCurrentId());
        echo '<li><a href="' . $url . '">' . $nav_article->getName() . '</a></li>';
    }
}

// Aktueller Artikel
echo '<li class="active">' . $article->getName() . '</li>';
echo '</ol>';
```

### SEO - Title Tag

```php
// Im Template <head>
$article = rex_article::getCurrent();
$domain = rex_yrewrite::getCurrentDomain();

echo rex_yrewrite_seo::getTitleTag($article, $domain);
// <title>Mein Artikel - Example</title> (nutzt Title-Schema aus Domain-Config)
```

### SEO - Meta Description

```php
// Meta-Description (aus yrewrite_description Metainfo-Feld)
$article = rex_article::getCurrent();

echo rex_yrewrite_seo::getDescriptionTag($article);
// <meta name="description" content="...">
```

### SEO - Canonical URL

```php
// Canonical-URL Tag
$article = rex_article::getCurrent();
$domain = rex_yrewrite::getCurrentDomain();

echo rex_yrewrite_seo::getCanonicalUrl($article, $domain);
// <link rel="canonical" href="https://example.com/news/artikel/">
```

### SEO - Hreflang Tags

```php
// Hreflang für mehrsprachige Seiten
$article = rex_article::getCurrent();
$domain = rex_yrewrite::getCurrentDomain();

echo rex_yrewrite_seo::getHreflangTags($article, $domain);
// <link rel="alternate" hreflang="de" href="https://example.com/de/artikel/">
// <link rel="alternate" hreflang="en" href="https://example.com/en/article/">
```

### SEO - Robots Meta

```php
// Robots Meta-Tag (aus yrewrite_index Metainfo-Feld)
$article = rex_article::getCurrent();

echo rex_yrewrite_seo::getMetaRobots($article);
// <meta name="robots" content="index,follow">
// oder: <meta name="robots" content="noindex,follow">
```

### SEO - Vollständiges Head-Template

```php
// Komplettes SEO-Head
$article = rex_article::getCurrent();
$domain = rex_yrewrite::getCurrentDomain();

echo rex_yrewrite_seo::getTitleTag($article, $domain);
echo rex_yrewrite_seo::getDescriptionTag($article);
echo rex_yrewrite_seo::getCanonicalUrl($article, $domain);
echo rex_yrewrite_seo::getHreflangTags($article, $domain);
echo rex_yrewrite_seo::getMetaRobots($article);

// Optional: Open Graph
if ($og_image = $article->getValue('og_image')) {
    $media = rex_media::get($og_image);
    if ($media) {
        echo '<meta property="og:image" content="' . $domain->getName() . 'media/' . $og_image . '">';
    }
}
```

### Sitemap abrufen

```php
// Sitemap.xml generieren
$domain = rex_yrewrite::getCurrentDomain();

header('Content-Type: application/xml; charset=utf-8');
echo rex_yrewrite_seo::getSitemap($domain);
exit;
```

### Robots.txt abrufen

```php
// Robots.txt ausgeben
$domain = rex_yrewrite::getCurrentDomain();

header('Content-Type: text/plain; charset=utf-8');
echo rex_yrewrite_seo::getRobots($domain);
exit;
```

### Weiterleitung erstellen

```php
// 301 Permanent Redirect
rex_yrewrite_forward::add(
    '/alte-url/', // Von
    '/neue-url/', // Nach
    301, // Type (301=permanent, 302=temporary)
    1 // Domain-ID (0 = alle)
);

// Zu externem Ziel
rex_yrewrite_forward::add(
    '/extern/',
    'https://google.com/',
    301,
    0
);

// Zu Artikel (Artikel-ID)
rex_yrewrite_forward::add(
    '/alter-artikel/',
    42, // Artikel-ID
    301,
    1
);
```

### Weiterleitungen verwalten

```php
// Alle Weiterleitungen
foreach (rex_yrewrite_forward::getAll() as $forward) {
    echo $forward['url'] . ' -> ' . $forward['redirect_to'] . ' (' . $forward['type'] . ')<br>';
}

// Einzelne Weiterleitung
$forward = rex_yrewrite_forward::get(5);
if ($forward) {
    echo $forward['url'];
}

// Löschen
rex_yrewrite_forward::delete(5);
```

### Custom URL-Schema

```php
// In lib/CustomRewriteScheme.php

class CustomRewriteScheme extends rex_yrewrite_scheme
{
    // URL-Suffix ändern (Standard: .html → /)
    public function getSuffix()
    {
        return '.html';
    }
    
    // Pfad-Normalisierung anpassen
    public function normalize($path, $clang = 1)
    {
        $path = str_replace('_', '-', $path);
        $path = strtolower($path);
        return parent::normalize($path, $clang);
    }
    
    // URL-Generierung anpassen
    public function getCustomUrl($article)
    {
        // Custom-Logik
        if ($article->getValue('custom_url')) {
            return $article->getValue('custom_url');
        }
        
        return parent::getCustomUrl($article);
    }
}

// In boot.php registrieren
rex_yrewrite::setScheme(new CustomRewriteScheme());
rex_yrewrite::generatePathFile([]);
```

### Sprach-Switch Navigation

```php
// Language Switcher
$current_article = rex_article::getCurrent();
$current_clang = rex_clang::getCurrentId();
$domain = rex_yrewrite::getCurrentDomain();

echo '<ul class="language-switcher">';

foreach ($domain->getClangs() as $clang_id) {
    $clang = rex_clang::get($clang_id);
    
    // Artikel in anderer Sprache
    $article = rex_article::get($current_article->getId(), $clang_id);
    
    if ($article) {
        $url = rex_yrewrite::getUrlByArticleId($article->getId(), $clang_id);
        $active = ($clang_id == $current_clang) ? ' class="active"' : '';
        
        echo '<li' . $active . '>';
        echo '<a href="' . $url . '">' . $clang->getCode() . '</a>';
        echo '</li>';
    }
}

echo '</ul>';
```

### Multi-Domain Navigation

```php
// Navigation über alle Domains
foreach (rex_yrewrite::getDomains() as $domain) {
    echo '<h3>' . $domain->getName() . '</h3>';
    
    $nav = rex_navigation::factory();
    
    echo '<ul>';
    foreach ($nav->get($domain->getMountId(), 1, true, true) as $item) {
        $url = $domain->getUrl() . rex_yrewrite::getUrlByArticleId($item['id'], $domain->getStartClang());
        echo '<li><a href="' . $url . '">' . $item['name'] . '</a></li>';
    }
    echo '</ul>';
}
```

### Alias-Domain einrichten

```php
// In boot.php - www zu non-www weiterleiten
rex_yrewrite::addAliasDomain(
    'https://www.example.com/', // Von (www)
    1, // Zu Domain-ID
    0 // clang_start
);

// Subdomain zu Hauptdomain
rex_yrewrite::addAliasDomain(
    'https://shop.example.com/',
    1,
    0
);
```

### Cache Management

```php
// YRewrite Cache löschen
rex_yrewrite::deleteCache();

// Z.B. nach Struktur-Änderungen
rex_extension::register('ART_UPDATED', function() {
    rex_yrewrite::deleteCache();
});

// Nach Domain-Änderungen
rex_extension::register('REX_FORM_SAVED', function(rex_extension_point $ep) {
    if ($ep->getParam('table') == 'rex_yrewrite_domain') {
        rex_yrewrite::deleteCache();
    }
});
```

### Custom 404-Handling

```php
// In 404-Template
$domain = rex_yrewrite::getCurrentDomain();
$requested_url = $_SERVER['REQUEST_URI'];

// 404-Header setzen
http_response_code(404);

// Logging
rex_logger::factory()->log('warning', 'YRewrite 404: ' . $requested_url);

// Vorschläge (ähnliche URLs)
$articles = rex_article::getRootArticles(false, rex_clang::getCurrentId());
foreach ($articles as $article) {
    $url = rex_yrewrite::getUrlByArticleId($article->getId(), rex_clang::getCurrentId());
    
    similar_text($requested_url, $url, $percent);
    if ($percent > 70) {
        echo 'Meinten Sie: <a href="' . $url . '">' . $article->getName() . '</a>?<br>';
    }
}
```

### URL-Validierung & Duplikate vermeiden

```php
// Im Backend - Prüfen ob URL bereits existiert
$article_id = rex_request::get('article_id', 'int');
$custom_url = rex_request::post('yrewrite_url', 'string');
$domain = rex_yrewrite::getDomainByArticleId($article_id, rex_clang::getCurrentId());

if ($custom_url) {
    $result = rex_yrewrite::getArticleIdByUrl($domain->getName(), $custom_url);
    
    if ($result && key($result) != $article_id) {
        echo 'Fehler: URL bereits vergeben für Artikel ' . key($result);
    }
}
```

### Media Manager mit YRewrite

```php
// Bilder mit Media Manager
$image = 'beispiel.jpg';
$type = 'header_large';

// Über aktuelle Domain
$domain = rex_yrewrite::getCurrentDomain();
$url = $domain->getName() . 'media/' . $type . '/' . $image;

echo '<img src="' . $url . '" alt="Beispiel">';

// Oder direkt
echo '<img src="/media/' . $type . '/' . $image . '" alt="Beispiel">';
```

### YRewrite + YForm Integration

```php
// YForm-Formular mit YRewrite-URLs
$yform = rex_yform::factory();

// Zurück zur aktuellen Seite nach Submit
$yform->setObjectparams('form_action', rex_yrewrite::getUrlByArticleId(
    rex_article::getCurrentId(),
    rex_clang::getCurrentId()
));

// Erfolgs-Weiterleitung
$yform->setActionField('redirect', [
    rex_yrewrite::getUrlByArticleId(42, 1) // Dankeschön-Seite
]);

echo $yform->getForm();
```

### Performance - Pathlist Cache

```php
// Pathlist neu generieren (nach großen Struktur-Änderungen)
rex_yrewrite::generatePathFile([
    'domain' => 'https://example.com/'
]);

// Kompletter Rebuild aller Domains
foreach (rex_yrewrite::getDomains() as $domain) {
    if ($domain->getName() != 'default') {
        rex_yrewrite::generatePathFile([
            'domain' => $domain->getName()
        ]);
    }
}
```

### Debugging YRewrite

```php
// Aktuelle URL-Auflösung debuggen
$domain = rex_yrewrite::getCurrentDomain();
$article = rex_article::getCurrent();

dump([
    'Domain' => $domain ? $domain->getName() : 'keine',
    'Artikel-ID' => $article->getId(),
    'Sprache' => rex_clang::getCurrentId(),
    'Generated URL' => rex_yrewrite::getUrlByArticleId($article->getId(), rex_clang::getCurrentId()),
    'Request URI' => $_SERVER['REQUEST_URI'],
    'Scheme' => get_class(rex_yrewrite::getScheme())
]);
```
