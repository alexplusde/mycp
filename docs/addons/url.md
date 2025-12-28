# URL - YForm URL-Generator

**Keywords:** URL, YForm, Profile, SEO, Sitemap, YRewrite, Slug, Speaking URLs

## Übersicht

URL-Addon erzeugt sprechende URLs aus YForm-Datensätzen (z.B. `/news/artikel-titel/`) statt GET-Parameter (`/news/?id=1`).

## Kern-Klassen

| Klasse | Beschreibung |
|--------|-------------|
| `Url` | URL-Objekt mit Parse/Modify-Methoden |
| `Profile` | URL-Profile-Konfiguration |
| `UrlManager` | Aktuelle URL auflösen, Dataset-ID ermitteln |
| `Seo` | SEO-Tags, OpenGraph, Schema.org |

## Klasse: Url

### Wichtige Methoden

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|-------------|
| `::resolveCurrent()` | - | `?UrlManager` | Aktuellen URL-Manager |
| `::get($url)` | `string` | `Url` | URL-Objekt erstellen |
| `::getCurrent()` | - | `string` | Aktuelle URL als String |
| `::getRewriter()` | - | `?Rewriter` | YRewrite-Rewriter |
| `getSchemeAndHttpHost()` | - | `string` | Schema + Host |
| `getPath()` | - | `string` | Pfad ohne Query |
| `withSolvedScheme()` | - | `self` | Schema setzen (http/https) |
| `toString()` | - | `string` | Komplette URL |

## Klasse: Profile

### Wichtige Methoden

| Methode | Rückgabe | Beschreibung |
|---------|----------|-------------|
| `::get($id)` | `?Profile` | Profil laden (ID/Namespace) |
| `::getAll()` | `array` | Alle Profile |
| `::getByTableName($table)` | `array` | Profile für YForm-Tabelle |
| `::getByArticleId($article_id, $clang_id)` | `array` | Profile für Artikel |
| `getId()` | `int` | Profil-ID |
| `getNamespace()` | `string` | Namespace (URL-Param-Key) |
| `getArticleId()` | `int` | Verknüpfter Artikel |
| `getTableName()` | `string` | YForm-Tabellename |
| `buildUrls()` | `void` | Alle URLs generieren |
| `buildUrlsByDatasetId($id)` | `void` | URLs für Dataset |
| `deleteUrls()` | `self` | Alle URLs löschen |
| `inSitemap()` | `bool` | In Sitemap aufnehmen |

## Klasse: UrlManager

### Wichtige Methoden

| Methode | Rückgabe | Beschreibung |
|---------|----------|-------------|
| `getDatasetId()` | `int\|string\|null` | Dataset-ID |
| `getDataset()` | `?rex_yform_manager_dataset` | Dataset-Objekt |
| `getArticleId()` | `int\|string\|null` | Artikel-ID |
| `getClangId()` | `int\|string\|null` | Sprach-ID |
| `getProfile()` | `?Profile` | Profil-Objekt |
| `getSeoTitle()` | `mixed` | SEO-Titel |
| `getSeoDescription()` | `mixed` | SEO-Beschreibung |
| `getSeoImage()` | `mixed` | SEO-Bild |
| `getUrl()` | `string` | URL als String |

## Klasse: Seo

### Wichtige Methoden

| Methode | Rückgabe | Beschreibung |
|---------|----------|-------------|
| `::getSitemap()` | `array` | Alle Sitemap-URLs |
| `getTitleTag()` | `string` | `<title>` Tag |
| `getDescriptionTag()` | `string` | Meta-Description |
| `getOpenGraphTags()` | `string` | OpenGraph-Tags |
| `getCanonicalUrl()` | `string` | Canonical-URL |
| `getHreflangTags()` | `string` | Hreflang-Links |
| `getAllTags()` | `string` | Alle SEO-Tags kombiniert |

## Praxisbeispiele

### 1. URL generieren

```php
$url_key = 'news-id';
$url = rex_getUrl('', '', [$url_key => $newsId]);
// Liefert /news/artikel-titel/
```

### 2. In YOrm-Modell

```php
class News extends rex_yform_manager_dataset
{
    public function getUrl(): string
    {
        return rex_getUrl('', '', ['news-id' => $this->getId()]);
    }
}
```

### 3. Aktuellen Manager auflösen

```php
use Url\Url;

$manager = Url::resolveCurrent();
if ($manager !== null) {
    $newsId = $manager->getDatasetId();
    $news = News::get($newsId);
}
```

### 4. Modul für Detail/Liste

```php
$manager = Url::resolveCurrent();
if ($manager !== null) {
    // Detailseite
    $news = News::get($manager->getDatasetId());
    echo '<h1>' . $news->getValue('title') . '</h1>';
} else {
    // Übersicht
    $newsList = News::query()->find();
    foreach ($newsList as $news) {
        echo '<a href="' . $news->getUrl() . '">' . $news->getValue('title') . '</a>';
    }
}
```

### 5. Mehrere Tabellen auf einen Artikel

```php
$manager = Url::resolveCurrent();
if ($manager) {
    $profile = $manager->getProfile();
    
    if ($profile->getTableName() === 'rex_news') {
        $news = News::get($manager->getDatasetId());
    } elseif ($profile->getTableName() === 'rex_news_category') {
        $category = NewsCategory::get($manager->getDatasetId());
    }
}
```

### 6. Manager-Methoden

```php
$manager = Url::resolveCurrent();
if ($manager) {
    $articleId = $manager->getArticleId();
    $clangId = $manager->getClangId();
    $datasetId = $manager->getDatasetId();
    $profile = $manager->getProfile();
    $namespace = $manager->getProfile()->getNamespace();
    $seoTitle = $manager->getSeoTitle();
}
```

### 7. Dataset mit Relationen laden

```php
$manager = Url::resolveCurrent();
if ($manager) {
    $dataset = $manager->getDataset();
    // Lädt automatisch alle in Profile konfigurierten Relationen
}
```

### 8. URLs neu generieren

```php
$profiles = \Url\Profile::getAll();
foreach ($profiles as $profile) {
    $profile->deleteUrls();
    $profile->buildUrls();
}
```

### 9. Profile nach Tabelle

```php
$profiles = \Url\Profile::getByTableName('rex_news');
foreach ($profiles as $profile) {
    echo $profile->getNamespace();
}
```

### 10. Profil-Namespace verwenden

```php
$manager = Url::resolveCurrent();
if ($manager && $profile = $manager->getProfile()) {
    echo 'Profil: ' . $profile->getNamespace();
}
```

### 11. SEO-Tags ausgeben

```php
use Url\Seo;

$manager = Url::resolveCurrent();
if ($manager) {
    $seo = new Seo($manager);
    echo $seo->getTitleTag();
    echo $seo->getDescriptionTag();
    echo $seo->getOpenGraphTags();
}
```

### 12. Extension Point URL_SEO_TAGS

```php
rex_extension::register('URL_SEO_TAGS', function(\rex_extension_point $ep) use ($manager) {
    $tags = $ep->getSubject();
    
    // Title anpassen
    $tags['title'] = 'Custom: ' . $manager->getSeoTitle();
    
    return $tags;
});
```

### 13. YForm-Formular auf URL-Seite

```php
$manager = Url::resolveCurrent();
if ($manager) {
    $yform->setObjectparams('form_action', rex_getUrl('', '', [
        $manager->getProfile()->getNamespace() => $manager->getDatasetId()
    ]));
}
```

### 14. Extension Point PREFETCH_URLS

```php
rex_extension::register('PREFETCH_URLS', function(\rex_extension_point $ep) {
    $urls = $ep->getSubject();
    
    // Eigene URLs hinzufügen
    $urls[] = '/wichtige-seite/';
    
    return $urls;
});
```

### 15. URL kürzen (EP URL_PRE_SAVE)

```php
rex_extension::register('URL_PRE_SAVE', function(\rex_extension_point $ep) {
    $url = $ep->getParam('object');
    $article_id = $ep->getParam('article_id');
    
    // Artikel/Kategorienamen entfernen
    if ($article_id != rex_yrewrite::getDomainByArticleId($article_id)->getStartId()) {
        $url->segments = ['data'];
    }
    
    return $url;
});
```

### 16. Sitemap generieren

```php
use Url\Seo;

$sitemap = Seo::getSitemap();
foreach ($sitemap as $entry) {
    echo '<url>';
    echo '<loc>' . $entry['loc'] . '</loc>';
    echo '<lastmod>' . $entry['lastmod'] . '</lastmod>';
    echo '</url>';
}
```

### 17. Profil programmatisch erstellen

```php
use Url\Profile;

$profile = Profile::create()
    ->setNamespace('events')
    ->setArticleId(42)
    ->setTableName('rex_events')
    ->setColumnId('id')
    ->setColumnClangId('clang_id')
    ->setSegmentPart1Column('name')
    ->setSitemapAdd(true);
```

### 18. URLs für Dataset aktualisieren

```php
$profiles = Profile::getByTableName('rex_news');
foreach ($profiles as $profile) {
    $profile->buildUrlsByDatasetId($newsId);
}
```

### 19. Canonical URL

```php
$manager = Url::resolveCurrent();
if ($manager) {
    $seo = new Seo($manager);
    echo $seo->getCanonicalUrl();
}
```

### 20. Hreflang für Mehrsprachigkeit

```php
$manager = Url::resolveCurrent();
if ($manager) {
    $seo = new Seo($manager);
    echo $seo->getHreflangTags();
}
```

### 21. YForm List Column

```php
// Zeigt URLs in YForm Table Manager
// Automatisch verfügbar für Tabellen mit Profilen
```

### 22. URL-Objekt manipulieren

```php
use Url\Url;

$url = Url::get('https://example.org/news/titel/');
$url->withSolvedScheme();
echo $url->getSchemeAndHttpHost(); // https://example.org
echo $url->getPath(); // /news/titel/
```

### 23. Cache löschen

```php
use Url\Cache;

Cache::deleteProfiles();
```

### 24. Sitemap-Index mit Profilen

```php
// boot.php
if (preg_match('~(^|/)sitemap\.xml$~', $_SERVER['REQUEST_URI'])) {
    $profiles = \Url\Profile::all();
    echo '<?xml version="1.0" encoding="UTF-8"?>';
    echo '<sitemapindex>';
    foreach ($profiles as $profile) {
        echo '<sitemap>';
        echo '<loc>' . rex_yrewrite::getCurrentDomain()->getUrl() . 'sitemap-profile-' . $profile->getNamespace() . '.xml</loc>';
        echo '</sitemap>';
    }
    echo '</sitemapindex>';
    exit;
}
```

### 25. Fluent Interface

```php
$profile = Profile::create()
    ->setNamespace('blog')
    ->setArticleId(10)
    ->setTableName('rex_blog')
    ->setRelation1TableName('rex_blog_category')
    ->setRelation1TableParameters(['column' => 'category_id'])
    ->setColumnSeoTitle('title')
    ->setColumnSeoDescription('teaser')
    ->setColumnSeoImage('image')
    ->setSitemapAdd(true);
```

> **Integration:** URL-Addon arbeitet mit **YRewrite** (SEO, Domains, Normalisierung), **YForm** (Datensätze, Table Manager), **Structure** (Artikel-Verknüpfung), **Media Manager** (SEO-Images) und wird von **neues**, **qanda**, **events**, **staff** und vielen Custom-Addons genutzt für sprechende URLs.
