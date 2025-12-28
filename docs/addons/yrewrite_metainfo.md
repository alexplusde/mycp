# YRewrite Metainfo - Domain Meta-Infos & PWA | Keywords: SEO, OpenGraph, Favicon, Manifest, Meta-Tags, PWA, Icons, YRewrite

**Übersicht**: Erweitert YRewrite-Domains um umfassende Metainformationen. Bietet vorkonfigurierte Felder für SEO, OpenGraph, Favicons, PWA-Manifeste und Icons. YOrm-basiert mit praktischen Dataset-Methoden für Domain-spezifische Einstellungen.

## Kern-Klassen

| Klasse | Beschreibung |
|--------|-------------|
| `Domain` | YOrm-Dataset für Domain-Metainformationen (extends rex_yform_manager_dataset) |
| `Icon` | YOrm-Dataset für Favicon/PWA-Icons (extends rex_yform_manager_dataset) |
| `Article` | Erweitert rex_article um YRewrite-Metadaten |
| `Category` | Erweitert rex_category um YRewrite-Metadaten |
| `YrewriteMetadataTrait` | Trait für YRewrite-Felder (Title, Description, Image, etc.) |

## Domain-Methoden

| Methode | Rückgabe | Beschreibung |
|---------|---------|-------------|
| `getCurrent()` | ?Domain | Aktuelle Domain als Dataset |
| `getCurrentValue($key)` | mixed | Wert der aktuellen Domain |
| `getHead()` | string | Komplettes `<head>`-Fragment |
| `getYRewrite()` | ?rex_yrewrite_domain | Original YRewrite-Domain-Objekt |
| `getName()` | ?string | Website-Titel (og:title) |
| `getLogo($asMedia)` | mixed | Logo-Datei |
| `getType()` | ?string | OpenGraph-Typ (website/article) |
| `getThumbnail($asMedia)` | mixed | og:image Thumbnail |
| `getIcon()` | ?Icon | Zugeordnetes Icon-Profil |

## Icon-Methoden (PWA/Favicon)

| Methode | Rückgabe | Beschreibung |
|---------|---------|-------------|
| `getName()` | ?string | Profilname |
| `getShortName()` | ?string | PWA Kurzname (App-Verknüpfung) |
| `getDisplay()` | ?string | PWA Browser-UI (standalone/fullscreen) |
| `getThemeColor()` | ?string | PWA Theme-Farbe (hex) |
| `getBackgroundColor()` | ?string | PWA Hintergrund-Farbe |
| `getShortcutIcon($asMedia)` | mixed | favicon.ico |
| `getAppleTouchIcon($asMedia)` | mixed | Apple Touch Icon (180x180) |
| `getManifest($asMedia)` | mixed | site.webmanifest Datei |
| `getFaviconPng96($asMedia)` | mixed | PNG Favicon 96x96 |
| `getFaviconSvg($asMedia)` | mixed | SVG Favicon |
| `getServiceWorker()` | ?string | Service Worker JS-Datei |

## Article/Category-Methoden (Trait)

| Methode | Rückgabe | Beschreibung |
|---------|---------|-------------|
| `getYrewriteTitle()` | ?string | SEO-Titel |
| `getYrewriteDescription()` | ?string | SEO-Beschreibung |
| `getYrewriteImage($asMedia)` | mixed | SEO-Bild |
| `getYrewriteUrlType()` | ?string | URL-Typ (auto/custom/redirection) |
| `getYrewriteUrl()` | ?string | Custom URL |
| `getYrewriteRedirection()` | ?string | Weiterleitungs-URL |
| `getYrewriteChangefreq()` | ?string | Sitemap Changefreq |
| `getYrewritePriority()` | ?string | Sitemap Priority (0.0-1.0) |
| `getYrewriteIndex()` | ?int | Noindex-Flag (0/1) |
| `getYrewriteCanonicalUrl()` | ?string | Canonical URL |

## Standard-Felder (Domain)

| Feld | Typ | Beschreibung |
|------|-----|-------------|
| `yrewrite_domain_id` | int | Verknüpfung zu YRewrite-Domain |
| `name` | varchar | Website-Titel |
| `logo` | text | Logo-Datei (Medienpool) |
| `type` | varchar | OpenGraph-Typ (website) |
| `thumbnail` | text | og:image Bild |
| `icon` | int | Verknüpfung zu Icon-Profil |

## Standard-Felder (Icon)

| Feld | Typ | Beschreibung |
|------|-----|-------------|
| `name` | varchar | Profilname |
| `short_name` | varchar | PWA Kurzname |
| `display` | varchar | PWA Display-Modus |
| `theme_color` | varchar | PWA Theme-Farbe (#hex) |
| `background_color` | varchar | PWA Hintergrund-Farbe |
| `shortcut_icon` | text | favicon.ico |
| `apple_touch_icon` | text | apple-touch-icon.png |
| `manifest` | text | site.webmanifest |
| `favicon_png_96` | text | favicon-96x96.png |
| `favicon_svg` | text | favicon.svg |
| `serviceworker` | varchar | Service Worker JS |

## Praxisbeispiele

### Beispiel 1: Head-Fragment im Template einbinden

```php
// Im Template-Header
use Alexplusde\YrewriteMetainfo\Domain;

echo Domain::getHead();
```

### Beispiel 2: Aktuelle Domain abrufen

```php
use Alexplusde\YrewriteMetainfo\Domain;

$domain = Domain::getCurrent();

if ($domain) {
    echo 'Website: ' . $domain->getName();
    echo '<br>Logo: ' . $domain->getLogo();
}
```

### Beispiel 3: Domain-Wert direkt abrufen

```php
use Alexplusde\YrewriteMetainfo\Domain;

// Ohne Domain-Objekt
$siteName = Domain::getCurrentValue('name');
echo 'Website: ' . $siteName;
```

### Beispiel 4: Original YRewrite-Domain abrufen

```php
$domain = Domain::getCurrent();
$yrewriteDomain = $domain->getYRewrite();

echo 'Domain: ' . $yrewriteDomain->getName();
echo '<br>URL: ' . $yrewriteDomain->getUrl();
```

### Beispiel 5: Logo im Template ausgeben

```php
$domain = Domain::getCurrent();
$logo = $domain->getLogo(true); // Als rex_media

if ($logo) {
    echo '<img src="' . rex_url::media($logo->getFileName()) . '" alt="' . $domain->getName() . '">';
}
```

### Beispiel 6: OpenGraph Thumbnail

```php
$domain = Domain::getCurrent();
$thumbnail = $domain->getThumbnail(true);

if ($thumbnail) {
    echo '<meta property="og:image" content="' . rex_url::media($thumbnail->getFileName()) . '">';
}
```

### Beispiel 7: Icon-Profil abrufen

```php
use Alexplusde\YrewriteMetainfo\Icon;

$domain = Domain::getCurrent();
$icon = $domain->getIcon();

if ($icon) {
    echo 'Icon-Profil: ' . $icon->getName();
    echo '<br>Theme-Farbe: ' . $icon->getThemeColor();
}
```

### Beispiel 8: PWA-Manifest ausgeben

```php
$icon = $domain->getIcon();

if ($icon && $icon->getManifest()) {
    echo '<link rel="manifest" href="' . rex_url::media($icon->getManifest()) . '">';
}
```

### Beispiel 9: Favicon-Set ausgeben

```php
$icon = $domain->getIcon();

if ($icon) {
    // ICO Favicon
    if ($icon->getShortcutIcon()) {
        echo '<link rel="shortcut icon" href="' . rex_url::media($icon->getShortcutIcon()) . '">';
    }
    
    // PNG Favicon
    if ($icon->getFaviconPng96()) {
        echo '<link rel="icon" type="image/png" sizes="96x96" href="' . rex_url::media($icon->getFaviconPng96()) . '">';
    }
    
    // SVG Favicon
    if ($icon->getFaviconSvg()) {
        echo '<link rel="icon" type="image/svg+xml" href="' . rex_url::media($icon->getFaviconSvg()) . '">';
    }
}
```

### Beispiel 10: Apple Touch Icon

```php
$icon = $domain->getIcon();

if ($icon && $icon->getAppleTouchIcon()) {
    echo '<link rel="apple-touch-icon" sizes="180x180" href="' . rex_url::media($icon->getAppleTouchIcon()) . '">';
}
```

### Beispiel 11: PWA Theme-Color

```php
$icon = $domain->getIcon();

if ($icon && $icon->getThemeColor()) {
    echo '<meta name="theme-color" content="' . $icon->getThemeColor() . '">';
}
```

### Beispiel 12: Service Worker registrieren

```php
$icon = $domain->getIcon();

if ($icon && $icon->getServiceWorker() && $icon->getServiceWorkerUrl()) {
    ?>
    <script>
    if ('serviceWorker' in navigator) {
        navigator.serviceWorker.register('<?= $icon->getServiceWorkerUrl() ?>');
    }
    </script>
    <?php
}
```

### Beispiel 13: Article mit YRewrite-Metadaten

```php
use Alexplusde\YrewriteMetainfo\Article;

$article = Article::get($articleId);

echo '<title>' . $article->getYrewriteTitle() . '</title>';
echo '<meta name="description" content="' . $article->getYrewriteDescription() . '">';

$image = $article->getYrewriteImage(true);
if ($image) {
    echo '<meta property="og:image" content="' . rex_url::media($image->getFileName()) . '">';
}
```

### Beispiel 14: Category-Metadaten

```php
use Alexplusde\YrewriteMetainfo\Category;

$category = Category::get($categoryId);

echo 'SEO-Titel: ' . $category->getYrewriteTitle();
echo '<br>Beschreibung: ' . $category->getYrewriteDescription();
```

### Beispiel 15: Sitemap-Einstellungen

```php
$article = Article::get($articleId);

echo 'Changefreq: ' . $article->getYrewriteChangefreq(); // daily, weekly, monthly
echo '<br>Priority: ' . $article->getYrewritePriority(); // 0.0 - 1.0
echo '<br>Index: ' . ($article->getYrewriteIndex() ? 'index' : 'noindex');
```

### Beispiel 16: Canonical URL

```php
$article = Article::get($articleId);
$canonical = $article->getYrewriteCanonicalUrl();

if ($canonical) {
    echo '<link rel="canonical" href="' . $canonical . '">';
} else {
    // Fallback: Aktuelle URL
    echo '<link rel="canonical" href="' . rex_yrewrite::getFullPath() . '">';
}
```

### Beispiel 17: Custom URL / Redirection

```php
$article = Article::get($articleId);

$urlType = $article->getYrewriteUrlType();

if ($urlType == 'custom') {
    $customUrl = $article->getYrewriteUrl();
    echo 'Custom URL: ' . $customUrl;
} elseif ($urlType == 'redirection') {
    $redirectUrl = $article->getYrewriteRedirection();
    echo 'Weiterleitung zu: ' . $redirectUrl;
}
```

### Beispiel 18: Domain-Daten in YForm-Formular

```php
// In einem YForm-Modul
$domain = Domain::getCurrent();

// Hidden-Field mit Domain-Name vorbelegen
value|be_hidden|site_name|<?= $domain->getName() ?>
```

### Beispiel 19: Multi-Domain-Unterscheidung

```php
$domain = Domain::getCurrent();
$yrewriteDomain = $domain->getYRewrite();

if ($yrewriteDomain->getHost() == 'www.example.com') {
    // Domain-spezifische Logik
    echo 'Hauptdomain';
} elseif ($yrewriteDomain->getHost() == 'shop.example.com') {
    echo 'Shop-Domain';
}
```

### Beispiel 20: Icon-Profil mehreren Domains zuordnen

```php
// Im Backend unter YRewrite > Icons und PWA-Profile
// Ein Icon-Profil kann mehreren Domains zugeordnet werden

// Code-Beispiel: Domain mit Icon verknüpfen
$domain = Domain::get($domainId);
$domain->setIcon($iconId);
$domain->save();
```

### Beispiel 21: RealFavicon-Generator ZIP hochladen

Im Backend unter `YRewrite` > `Icons und PWA-Profile`:

1. ZIP von [RealFaviconGenerator](https://realfavicongenerator.net/) erstellen
2. Im Backend hochladen
3. Medienpool-Kategorie wählen (oder neue erstellen)
4. Icons werden automatisch importiert und zugeordnet

```php
// Automatische Zuordnung:
// - favicon.ico → shortcut_icon
// - apple-touch-icon.png → apple_touch_icon
// - site.webmanifest → manifest
// - favicon-96x96.png → favicon_png_96
// - favicon.svg → favicon_svg
```

### Beispiel 22: PWA Display-Modi

```php
$icon = $domain->getIcon();
$display = $icon->getDisplay();

// Mögliche Werte:
// - fullscreen: Vollbild ohne Browser-UI
// - standalone: Wie native App (Standard)
// - minimal-ui: Minimale Browser-UI
// - browser: Normaler Browser

echo '<meta name="mobile-web-app-capable" content="yes">';
```

### Beispiel 23: Debug-Favicon bei aktiviertem Debug-Modus

```php
// In config.yml
yrewrite_metainfo:
    show_debug_favicon: true

// Zeigt Warn-Favicon wenn:
// - rex::isDebugMode() aktiv
// - PHPMailer debug aktiviert

// Automatisch im head.php Fragment integriert
```

### Beispiel 24: Custom Head-Fragment

```php
// fragments/yrewrite_metainfo/head.php im project-Addon erstellen

use Alexplusde\YrewriteMetainfo\Domain;
use Alexplusde\YrewriteMetainfo\Icon;

$domain = Domain::getCurrent();
$seo = new rex_yrewrite_seo();

if ($domain) {
    // Eigene Meta-Tags
    echo '<meta name="author" content="' . $domain->getValue('author') . '">';
    
    // Standard-Tags
    echo $seo->getTags();
    
    // Icons
    $icon = $domain->getIcon();
    if ($icon) {
        echo '<link rel="manifest" href="' . $icon->getManifestUrl() . '">';
    }
}
```

### Beispiel 25: YOrm Query für alle Domains

```php
use Alexplusde\YrewriteMetainfo\Domain;

// Alle Domains
$domains = Domain::query()->find();

foreach ($domains as $domain) {
    echo $domain->getName() . ' (' . $domain->getYRewrite()->getHost() . ')<br>';
}

// Domain nach YRewrite-ID
$domain = Domain::query()
    ->where('yrewrite_domain_id', 2)
    ->findOne();
```

### Beispiel 26: Icon-Profil erstellen

```php
use Alexplusde\YrewriteMetainfo\Icon;

$icon = Icon::create();
$icon->setName('Hauptprofil');
$icon->setShortName('MeineSite');
$icon->setDisplay('standalone');
$icon->setThemeColor('#0066cc');
$icon->setBackgroundColor('#ffffff');
$icon->setShortcutIcon('favicon.ico');
$icon->setAppleTouchIcon('apple-touch-icon.png');
$icon->setManifest('site.webmanifest');
$icon->save();

echo 'Icon-Profil erstellt mit ID: ' . $icon->getId();
```

### Beispiel 27: Domain-Metadaten setzen

```php
$domain = Domain::get($domainId);

$domain->setName('Meine Website');
$domain->setType('website');
$domain->setLogo('logo.svg');
$domain->setThumbnail('og-image.jpg');
$domain->setIcon(1); // Icon-Profil ID
$domain->save();
```

### Beispiel 28: Article-Metadaten programmatisch setzen

```php
use Alexplusde\YrewriteMetainfo\Article;

$article = Article::get($articleId);

$article->setYrewriteTitle('SEO-optimierter Titel');
$article->setYrewriteDescription('Detaillierte Meta-Beschreibung für Suchmaschinen');
$article->setYrewriteImage('article-image.jpg');
$article->setYrewriteChangefreq('weekly');
$article->setYrewritePriority('0.8');
$article->save();
```

### Beispiel 29: Integration mit speed_up Addon

```php
// Automatisch im head.php Fragment integriert
if (class_exists('speed_up')) {
    $speed_up = new speed_up();
    $speed_up->show();
}

// Preload/Prefetch/DNS-Prefetch für bessere Performance
```

### Beispiel 30: Integration mit wenns_sein_muss (Cookie-Consent)

```php
// Automatisch im head.php Fragment
use Alexplusde\Wsm\Fragment;

if (rex_addon::get('wenns_sein_muss')->isAvailable()) {
    echo Fragment::getCss();
    echo Fragment::getScripts();
    echo Fragment::getJs();
}

// Cookie-Consent-Banner wird automatisch eingebunden
```

**Integration**: YRewrite (Domain-Verwaltung), YForm (Datenverwaltung), YOrm (Dataset-Methoden), Medienpool (Favicon/Logo), RealFaviconGenerator (Icon-Import), Speed_up (Performance), Wenns_sein_muss (Cookie-Consent), URL-Addon (Custom URLs), Service Worker (PWA), OpenGraph (Social Media), Schema.org (Structured Data)
