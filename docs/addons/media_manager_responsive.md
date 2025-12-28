# Media Manager Responsive - Responsive Bilder

**Keywords:** Responsive, Images, Picture, Srcset, WebP, AVIF, Thumbnails, Performance, Lazy Loading

## Übersicht

Media Manager Responsive erweitert `rex_media` um Methoden für responsive Bilder (`<picture>`, `srcset`), moderne Formate (WebP/AVIF), Thumbhash-Platzhalter und Cache-Busting.

## Kern-Klassen

| Klasse | Beschreibung |
|--------|-------------|
| `Media` | Erweitert `rex_media` um responsive Methoden |
| `Profile` | Profil-Gruppen mit Breakpoints |
| `Type` | Einzelner Media-Manager-Typ in Gruppe |
| `ManagerHelper` | Programmatische Media-Manager-Typen-Erstellung |

## Klasse: Media

### Wichtige Methoden

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|-------------|
| `::get($filename)` | `string` | `?Media` | Lädt Medium (erweitert) |
| `getImg($type)` | `string` | `string` | `<img>` mit srcset/width/height |
| `getPicture($group)` | `string` | `string` | `<picture>` mit `<source>` Tags |
| `getImgSrcset($group)` | `string` | `string` | Srcset-String für manuelle Verwendung |
| `getBackgroundStyles($group, $selector)` | `string, string` | `string` | Responsive CSS für Background-Images |
| `getFrontendUrl($media, $type, $timestamp)` | `Media, string, bool` | `string` | URL mit Cache-Buster |
| `getSvg()` | - | `string` | Inline-SVG ohne `<img>` |
| `getBase64($inline)` | `bool` | `string` | Base64-kodiertes Bild |
| `getThumbhash()` | - | `string` | Thumbhash-String (Platzhalter) |
| `getImgThumbhash()` | - | `string` | `<img>` mit Thumbhash als Data-URL |
| `getStructuredData()` | - | `string` | Schema.org JSON+LD für ImageObject |

### Setter-Methoden

| Methode | Parameter | Beschreibung |
|---------|-----------|-------------|
| `setClass($class)` | `string` | CSS-Klasse setzen |
| `setTitle($title)` | `string` | Title/Alt-Text setzen |
| `setLoading($loading)` | `string` | loading="lazy\|eager\|auto" |
| `setAttributes($attributes)` | `array` | Zusätzliche Attribute |

## Klasse: Profile

### Wichtige Methoden

| Methode | Rückgabe | Beschreibung |
|---------|----------|-------------|
| `::getTypes($group)` | `?array<Type>` | Alle Typen einer Gruppe |
| `::getBackgroundStyles($file, $group, $selector)` | `string` | CSS-Styles für Background |
| `getPicture($media, $group)` | `string` | Picture-Element generieren |
| `getSrcset($media, $group)` | `string` | Srcset-String generieren |

## REX_VAR

```php
REX_MEDIA_PLUS[file="file.jpg" output="img" profile="small"]
REX_MEDIA_PLUS[file="file.svg" output="svg"]
REX_MEDIA_PLUS[file="file.jpg" output="thumbhash"]
REX_MEDIA_PLUS[file="file.jpg" output="picture" group="header"]
REX_MEDIA_PLUS[file="file.jpg" output="background" group="header"]
```

## Praxisbeispiele

### 1. Einfaches responsive Bild

```php
use Alexplusde\MediaManagerResponsive\Media;

echo Media::get('beispiel.jpg')->getImg('default');
// Liefert <img> mit srcset, width, height, loading
```

### 2. Mit CSS-Klasse und Attributen

```php
echo Media::get('beispiel.jpg')
    ->setClass('img-fluid')
    ->setTitle('Bildbeschreibung')
    ->setLoading('lazy')
    ->setAttributes(['data-category' => 'gallery'])
    ->getImg('default');
```

### 3. Picture-Element mit Breakpoints

```php
echo Media::get('hero.jpg')->getPicture('header');
// Verwendet Profil-Gruppe "header" mit allen definierten Breakpoints
```

### 4. Responsive Background-Image

```php
echo Media::get('background.jpg')
    ->getBackgroundStyles('header', '#hero-section');
// Liefert <style> mit Media-Queries
```

### 5. SVG inline ausgeben

```php
echo Media::get('logo.svg')->getSvg();
// Liefert kompletten SVG-Code (kein <img>-Tag)
```

### 6. Thumbhash-Platzhalter

```php
// Thumbhash-String
$thumbhash = Media::get('bild.jpg')->getThumbhash();

// <img> mit Thumbhash als Platzhalter
echo Media::get('bild.jpg')->getImgThumbhash();
```

### 7. Base64-Encoding

```php
// Base64-String
$base64 = Media::get('icon.png')->getBase64();

// Als Data-URL inline
echo '<img src="' . Media::get('icon.png')->getBase64(true) . '">';
```

### 8. Strukturierte Daten

```php
echo Media::get('produkt.jpg')->getStructuredData();
// Liefert Schema.org JSON+LD für ImageObject
```

### 9. Attribute-Array für manuelle Verwendung

```php
$media = Media::get('bild.jpg');
$attrs = $media->getImgAsAttributesArray('default');

// Attribute erweitern/überschreiben
$attrs['class'] = trim(($attrs['class'] ?? '') . ' custom-class');
$attrs['data-lightbox'] = 'gallery';

echo '<img ' . rex_string::buildAttributes($attrs) . '>';
```

### 10. Frontend-URL mit Cache-Buster

```php
$url = Media::getFrontendUrl(Media::get('bild.jpg'), 'small', true);
// Liefert /media/small/bild.jpg?timestamp=1234567890
```

### 11. Profil-Gruppe "default" nutzen

```php
// Verwendet Bootstrap 5.3 Breakpoints (xs, sm, md, lg, xl, xxl @ 1x/2x)
echo Media::get('gallery.jpg')->getPicture('default');
```

### 12. Media-Negotiation (WebP/AVIF)

```php
// Mit accept_media_type Effect im Media Manager
// Browser wählt automatisch WebP/AVIF wenn unterstützt
echo Media::get('photo.jpg')->getImg('responsive');
```

### 13. REX_VAR in Modulen

```php
// Einfaches Bild
REX_MEDIA_PLUS[file="REX_VALUE[1]" output="img" profile="medium"]

// Picture-Element
REX_MEDIA_PLUS[file="REX_VALUE[1]" output="picture" group="slider"]

// SVG
REX_MEDIA_PLUS[file="REX_VALUE[1]" output="svg"]
```

### 14. Profil-Gruppen erstellen (Backend)

```php
// Backend: Media Manager > Media Manager Responsive
// Neue Gruppe anlegen mit Breakpoints:
// - xs_1x: 1-575px @ 1x
// - sm_1x: 576-767px @ 1x
// - md_1x: 768-991px @ 1x
// etc.
```

### 15. Programmatische Typ-Erstellung

```php
use Alexplusde\MediaManagerResponsive\ManagerHelper;

$typeId = ManagerHelper::createTypeWithEffects(
    'responsive_medium',
    'Medium responsive Bild',
    [
        [
            'effect' => 'resize',
            'parameters' => [
                'rex_effect_resize' => [
                    'rex_effect_resize_width' => '768',
                    'rex_effect_resize_height' => '',
                    'rex_effect_resize_style' => 'maximum'
                ]
            ]
        ]
    ]
);
```

### 16. Accept-Media-Type Effect

```php
// Im Media Manager Type hinzufügen:
// Effect: accept_media_type
// Liefert automatisch WebP/AVIF basierend auf Browser-Support
```

### 17. Lazy Loading

```php
echo Media::get('bild.jpg')
    ->setLoading('lazy')
    ->getImg('default');
// <img loading="lazy" ...>
```

### 18. Art Direction mit Picture

```php
// Verschiedene Bildausschnitte für Mobile/Desktop
$media = Media::get('hero.jpg');
echo $media->getPicture('art-direction');
// Gruppe "art-direction" nutzt verschiedene Crops/Formate
```

### 19. Fallback für alte Browser

```php
$media = Media::get('bild.jpg');
$picture = $media->getPicture('responsive');
// <picture> enthält automatisch <img> als Fallback
```

### 20. Cache-Warmup-Integration

```php
// Addon cache_warmup läuft über alle Medien
// Generiert alle Profile/Typen-Kombinationen vorab
```

### 21. Fragment-Integration

```php
$fragment = new rex_fragment();
$fragment->setVar('media', Media::get('bild.jpg'));
$fragment->setVar('type', 'default');
echo $fragment->parse('media_manager_responsive/img.php');
```

### 22. Figure mit Caption

```php
$fragment = new rex_fragment();
$fragment->setVar('media', Media::get('bild.jpg'));
$fragment->setVar('caption', 'Bildbeschreibung');
echo $fragment->parse('media_manager_responsive/figure.php');
```

### 23. Background-Styles mit Custom-Selector

```php
echo Profile::getBackgroundStyles(
    'background.jpg',
    'hero',
    '.hero-section'
);
// Generiert Media-Queries für .hero-section
```

### 24. WYSIWYG-Integration

```php
// Backend-Einstellung: Standard-Media-Manager-Typ wählen
// Bilder aus Redactor/TinyMCE werden automatisch optimiert
```

### 25. Srcset manuell verwenden

```php
$media = Media::get('gallery.jpg');
$srcset = $media->getImgSrcset('gallery');

echo '<img src="' . $media->getUrl('default') . '" 
           srcset="' . $srcset . '" 
           sizes="(max-width: 768px) 100vw, 50vw">';
```

> **Integration:** Media Manager Responsive arbeitet mit **Media Manager** (Effekte, Typen, Cache), **YForm** (Medienpool-Felder), **YRewrite** (Domain-URLs), **cache_warmup** (Vorab-Generierung), **Media Negotiator** (Format-Auswahl), **Redactor/TinyMCE** (WYSIWYG-Bilder) und unterstützt **Imagick/GD** für WebP/AVIF-Konvertierung sowie **Thumbhash** für Platzhalter-Generierung.
