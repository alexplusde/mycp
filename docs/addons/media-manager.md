# Media Manager - Bildbearbeitung

**Keywords:** Image Processing Effects Resize Crop Media Types Cache Responsive

## Übersicht

Core-Addon zur dynamischen Bildbearbeitung mit Effekten (resize, crop, filter, watermark). Erzeugt optimierte Bildvarianten on-the-fly mit Caching.

## Hauptklassen

### rex_media_manager

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `::create($type, $file)` | string, string | rex_managed_media | Bild mit Typ verarbeiten |
| `::getUrl($type, $file)` | string, string | string | URL zu verarbeitetem Bild |
| `::deleteCache($file)` | string | bool | Cache für Datei löschen |
| `::deleteCacheByType($type)` | string | bool | Cache für Typ löschen |

### rex_managed_media

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `send($exit)` | bool | void | Bild an Browser senden |
| `getMediaPath()` | - | string | Pfad zur Originaldatei |
| `getFormat()` | - | string | Bildformat (jpg, png, webp) |
| `getHeader()` | - | array | HTTP-Header |
| `isCached()` | - | bool | Ist gecacht? |

### rex_effect_abstract

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `execute()` | - | void | Effekt ausführen |
| `getName()` | - | string | Effekt-Name |
| `getParams()` | - | array | Effekt-Parameter |

## Standard-Effekte

| Effekt | Parameter | Beschreibung |
|---------|-----------|--------------|
| `resize` | width, height, style | Größe ändern (max/min/exact/crop) |
| `crop` | width, height, offset_width, offset_height, position | Ausschnitt |
| `filter_blur` | amount, radius | Weichzeichnen |
| `filter_sharpen` | amount, radius | Schärfen |
| `filter_brightness` | brightness | Helligkeit |
| `filter_contrast` | contrast | Kontrast |
| `filter_greyscale` | - | Graustufen |
| `filter_sepia` | - | Sepia-Filter |
| `rounded_corners` | topleft, topright, bottomleft, bottomright | Abgerundete Ecken |
| `mirror` | horizontal, vertical | Spiegeln |
| `rotate` | rotate | Drehen (-360 bis 360°) |
| `flip` | flip | Horizontal/Vertikal spiegeln |
| `workspace` | width, height, pos, bgcolor | Canvas/Hintergrund |
| `brand` | brand_image, hpos, vpos, brand_transparency | Wasserzeichen |
| `convert2img` | convert_to | Format konvertieren (jpg/png/webp) |
| `header` | download, cache | HTTP-Header setzen |
| `mediapath` | mediapath | Pfad zu anderem Bild |

## Praxisbeispiele

### Bild-URL generieren

```php
// URL mit Media Manager Type
$url = rex_media_manager::getUrl('header_large', 'beispiel.jpg');
echo '<img src="' . $url . '" alt="Beispiel">';

// Output: /media/header_large/beispiel.jpg
```

### Verschiedene Bildgrößen

```php
$image = 'produkt.jpg';

// Thumbnail
$thumb = rex_media_manager::getUrl('thumbnail', $image);
echo '<img src="' . $thumb . '">';

// Mittel
$medium = rex_media_manager::getUrl('medium', $image);
echo '<img src="' . $medium . '">';

// Large
$large = rex_media_manager::getUrl('large', $image);
echo '<a href="' . $large . '"><img src="' . $thumb . '"></a>';
```

### Responsive Images

```php
$image = 'hero.jpg';

echo '<picture>';
echo '<source media="(min-width: 1200px)" srcset="' . rex_media_manager::getUrl('hero_xl', $image) . '">';
echo '<source media="(min-width: 992px)" srcset="' . rex_media_manager::getUrl('hero_lg', $image) . '">';
echo '<source media="(min-width: 768px)" srcset="' . rex_media_manager::getUrl('hero_md', $image) . '">';
echo '<img src="' . rex_media_manager::getUrl('hero_sm', $image) . '" alt="Hero">';
echo '</picture>';
```

### Bild verarbeiten & ausgeben

```php
// Bild verarbeiten
$media = rex_media_manager::create('thumbnail', 'beispiel.jpg');

if ($media->isCached()) {
    echo 'Aus Cache';
} else {
    echo 'Neu generiert';
}

// An Browser senden (mit Exit)
$media->send(true);
```

### Cache löschen

```php
// Cache für eine Datei löschen (alle Types)
rex_media_manager::deleteCache('beispiel.jpg');

// Cache für einen Type löschen (alle Dateien)
rex_media_manager::deleteCacheByType('thumbnail');

// Kompletten Cache löschen
rex_media_manager::deleteCache();
```

### Custom Media Type erstellen

```php
// In boot.php oder setup
$sql = rex_sql::factory();
$sql->setTable('rex_media_manager_type');
$sql->setValue('name', 'blog_teaser');
$sql->setValue('description', 'Blog Teaser 600x400');
$sql->setValue('status', 1);

if (!$sql->setWhere(['name' => 'blog_teaser'])->select()->getRows()) {
    $type_id = $sql->insert()->getLastId();
    
    // Effekt hinzufügen: Resize
    $sql->setTable('rex_media_manager_type_effect');
    $sql->setValue('type_id', $type_id);
    $sql->setValue('effect', 'resize');
    $sql->setValue('parameters', json_encode([
        'width' => 600,
        'height' => 400,
        'style' => 'crop'
    ]));
    $sql->setValue('priority', 1);
    $sql->insert();
}
```

### Resize-Styles

```php
// max - Bild passt in Box (behält Proportionen)
$url = rex_media_manager::getUrl('max_800x600', $image);

// min - Bild füllt Box mindestens (behält Proportionen)
$url = rex_media_manager::getUrl('min_800x600', $image);

// exact - Exakte Größe (verzerrt ggf.)
$url = rex_media_manager::getUrl('exact_800x600', $image);

// crop - Ausschnitt in exakter Größe (beschneidet)
$url = rex_media_manager::getUrl('crop_800x600', $image);
```

### Crop mit Position

```php
// Crop mit bestimmter Position
// Positions: topleft, top, topright, left, center, right, bottomleft, bottom, bottomright

// Beispiel Type mit crop effect:
// width: 400
// height: 400
// position: center
$url = rex_media_manager::getUrl('square_center', $image);
```

### Filter anwenden

```php
// Graustufen
$grey = rex_media_manager::getUrl('greyscale', $image);

// Sepia
$sepia = rex_media_manager::getUrl('sepia', $image);

// Blur
$blur = rex_media_manager::getUrl('blur', $image);

// Sharpen
$sharp = rex_media_manager::getUrl('sharpen', $image);
```

### Wasserzeichen

```php
// Type mit brand-Effekt erstellen
// brand_image: logo.png
// hpos: right (left/center/right oder Pixel)
// vpos: bottom (top/center/bottom oder Pixel)
// brand_transparency: 80 (0-100)

$url = rex_media_manager::getUrl('with_watermark', $image);
echo '<img src="' . $url . '">';
```

### Bild drehen

```php
// 90° im Uhrzeigersinn
$rotated = rex_media_manager::getUrl('rotate_90', $image);

// 180°
$rotated = rex_media_manager::getUrl('rotate_180', $image);

// -90° (gegen Uhrzeigersinn)
$rotated = rex_media_manager::getUrl('rotate_270', $image);
```

### Abgerundete Ecken

```php
// Type mit rounded_corners-Effekt
// topleft, topright, bottomleft, bottomright: Radius in Pixel

$rounded = rex_media_manager::getUrl('rounded', $image);
```

### Format konvertieren

```php
// PNG zu JPG
$jpg = rex_media_manager::getUrl('convert_jpg', 'bild.png');

// Zu WebP
$webp = rex_media_manager::getUrl('convert_webp', $image);

// Kombination: Resize + WebP
echo '<picture>';
echo '<source type="image/webp" srcset="' . rex_media_manager::getUrl('large_webp', $image) . '">';
echo '<img src="' . rex_media_manager::getUrl('large', $image) . '">';
echo '</picture>';
```

### Custom Background (Workspace)

```php
// Type mit workspace-Effekt
// width: 1000
// height: 1000
// pos: center (Position des Bildes auf Canvas)
// bgcolor: #ffffff (Hintergrundfarbe)

$canvas = rex_media_manager::getUrl('on_canvas', $image);
```

### Download forcieren

```php
// Type mit header-Effekt
// download: dateiname.jpg (oder leer für Original-Name)
// cache: no_cache

$download = rex_media_manager::getUrl('force_download', $image);
echo '<a href="' . $download . '" download>Download</a>';
```

### SVG als IMG konvertieren

```php
// Type mit convert2img-Effekt für SVG
// convert_to: jpg/png

$svg_as_jpg = rex_media_manager::getUrl('svg_to_jpg', 'icon.svg');
```

### Mehrere Effekte kombinieren

```php
// Type mit mehreren Effekten (werden in Reihenfolge ausgeführt):
// 1. resize: 800x600, crop
// 2. filter_sharpen: amount=80
// 3. brand: logo.png, right, bottom
// 4. convert2img: webp

$optimized = rex_media_manager::getUrl('optimized', $image);
```

### Lazy Loading mit Placeholder

```php
$image = 'header.jpg';

// Tiny Placeholder
$placeholder = rex_media_manager::getUrl('tiny_blur', $image); // z.B. 50px + blur
$full = rex_media_manager::getUrl('header_large', $image);

echo '<img 
    src="' . $placeholder . '" 
    data-src="' . $full . '" 
    class="lazyload" 
    alt="Header"
>';
```

### Retina-Display (2x)

```php
$image = 'logo.png';

$normal = rex_media_manager::getUrl('logo_200', $image); // 200x200
$retina = rex_media_manager::getUrl('logo_400', $image); // 400x400

echo '<img 
    src="' . $normal . '" 
    srcset="' . $normal . ' 1x, ' . $retina . ' 2x" 
    alt="Logo"
>';
```

### Srcset für verschiedene Auflösungen

```php
$image = 'banner.jpg';

$srcset = [
    rex_media_manager::getUrl('banner_400', $image) . ' 400w',
    rex_media_manager::getUrl('banner_800', $image) . ' 800w',
    rex_media_manager::getUrl('banner_1200', $image) . ' 1200w',
    rex_media_manager::getUrl('banner_1600', $image) . ' 1600w',
];

echo '<img 
    src="' . rex_media_manager::getUrl('banner_800', $image) . '" 
    srcset="' . implode(', ', $srcset) . '" 
    sizes="100vw" 
    alt="Banner"
>';
```

### Galerie mit Thumbnails

```php
// REX_MEDIALIST[1]
$images = explode(',', 'REX_MEDIALIST[1]');

echo '<div class="gallery">';
foreach ($images as $image) {
    $thumb = rex_media_manager::getUrl('gallery_thumb', $image);
    $large = rex_media_manager::getUrl('gallery_large', $image);
    
    echo '<a href="' . $large . '" data-lightbox="gallery">';
    echo '<img src="' . $thumb . '" alt="">';
    echo '</a>';
}
echo '</div>';
```

### CSS Background Image

```php
$image = 'hero.jpg';
$url = rex_media_manager::getUrl('hero_1920', $image);

echo '<div class="hero" style="background-image: url(' . $url . ')">';
echo '<h1>Willkommen</h1>';
echo '</div>';
```

### Bild mit Fallback

```php
$image = 'REX_MEDIA[1]';

if ($image && rex_media::get($image)) {
    $url = rex_media_manager::getUrl('teaser', $image);
} else {
    $url = rex_media_manager::getUrl('teaser', 'placeholder.jpg');
}

echo '<img src="' . $url . '" alt="Teaser">';
```

### Image Preload (Performance)

```php
// Im <head>
$hero = rex_media_manager::getUrl('hero_1920', 'header.jpg');
echo '<link rel="preload" as="image" href="' . $url . '">';
```

### Cache-Warming (nach Upload)

```php
// Nach Media-Upload alle wichtigen Types generieren
rex_extension::register('MEDIA_ADDED', function(rex_extension_point $ep) {
    $filename = $ep->getParam('filename');
    $types = ['thumbnail', 'medium', 'large', 'hero'];
    
    foreach ($types as $type) {
        rex_media_manager::create($type, $filename);
    }
});
```

### Media Manager Type prüfen

```php
$type = 'thumbnail';

$sql = rex_sql::factory();
$sql->setQuery('SELECT * FROM rex_media_manager_type WHERE name = ?', [$type]);

if ($sql->getRows() > 0) {
    echo 'Type "' . $type . '" existiert';
    echo 'Status: ' . $sql->getValue('status');
} else {
    echo 'Type nicht gefunden';
}
```

### Effekte eines Types abrufen

```php
$type = 'thumbnail';

$sql = rex_sql::factory();
$sql->setQuery('
    SELECT * FROM rex_media_manager_type_effect 
    WHERE type_id = (SELECT id FROM rex_media_manager_type WHERE name = ?)
    ORDER BY priority
', [$type]);

foreach ($sql as $row) {
    echo $row->getValue('effect') . ': ';
    $params = json_decode($row->getValue('parameters'), true);
    print_r($params);
}
```

### Progressive JPG erzeugen

```php
// Type mit convert2img-Effekt
// convert_to: jpg
// interlace: true (für progressive)

$progressive = rex_media_manager::getUrl('progressive_jpg', $image);
```

### Dynamischer Type-Name

```php
// Type basierend auf Device/Viewport wählen
$viewport_width = rex_request::get('vw', 'int', 1200);

if ($viewport_width <= 768) {
    $type = 'mobile';
} elseif ($viewport_width <= 1200) {
    $type = 'tablet';
} else {
    $type = 'desktop';
}

$url = rex_media_manager::getUrl($type, $image);
```

### Bild-Info aus Cache

```php
$media = rex_media_manager::create('large', 'beispiel.jpg');

echo 'Format: ' . $media->getFormat();
echo 'Gecacht: ' . ($media->isCached() ? 'Ja' : 'Nein');
echo 'Pfad: ' . $media->getMediaPath();

$header = $media->getHeader();
echo 'Content-Type: ' . $header['Content-Type'];
```

### Custom Effect erstellen

```php
// In lib/MediaManagerEffects/CustomEffect.php

class rex_effect_custom extends rex_effect_abstract
{
    public function execute()
    {
        // Parameter aus Backend
        $amount = (int) $this->params['amount'];
        
        // Auf $this->media->getImage() arbeiten (GDlib Resource)
        $img = $this->media->getImage();
        
        // Custom Bildbearbeitung
        imagefilter($img, IMG_FILTER_BRIGHTNESS, $amount);
        
        $this->media->setImage($img);
    }
    
    public function getName()
    {
        return 'Custom Brightness';
    }
}

// In boot.php registrieren
rex_media_manager::addEffect('rex_effect_custom');
```

### URL mit Cache-Buster

```php
// Cache-Buster via Timestamp
$image = 'logo.png';
$media = rex_media::get($image);
$timestamp = $media ? $media->getUpdateDate() : time();

$url = rex_media_manager::getUrl('logo', $image);
$url .= '?v=' . $timestamp;

echo '<img src="' . $url . '" alt="Logo">';
```

### Art Direction (verschiedene Crops)

```php
$image = 'header.jpg';

echo '<picture>';
// Mobile: Square Crop
echo '<source media="(max-width: 767px)" srcset="' . rex_media_manager::getUrl('square_crop', $image) . '">';
// Tablet: 16:9
echo '<source media="(max-width: 1199px)" srcset="' . rex_media_manager::getUrl('crop_16_9', $image) . '">';
// Desktop: 21:9
echo '<img src="' . rex_media_manager::getUrl('crop_21_9', $image) . '" alt="Header">';
echo '</picture>';
```
