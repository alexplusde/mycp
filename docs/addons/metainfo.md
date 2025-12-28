# Metainfo - Custom Fields

**Keywords:** Metainfo, Custom Fields, Article, Category, Media, Felder, Metadata, Backend, Properties

## Übersicht

Metainfo ermöglicht das Hinzufügen von benutzerdefinierten Feldern zu Artikeln, Kategorien, Medien und Klassen für erweiterte Metadaten.

## Kern-Funktionen

| Funktion | Rückgabe | Beschreibung |
|----------|----------|-------------|
| `rex_metainfo_add_field($name, $title, $priority, $attributes, $type, $default, $params, $validate, $restrictions)` | int | Erstellt neues Metainfo-Feld |
| `rex_metainfo_delete_field($name)` | bool | Löscht Metainfo-Feld |

## Feld-Typen

| Typ-ID | Name | Beschreibung |
|--------|------|-------------|
| 1 | text | Einzeiliges Textfeld |
| 2 | textarea | Mehrzeiliges Textfeld |
| 3 | select | Select-Dropdown |
| 4 | radio | Radio-Buttons |
| 5 | checkbox | Checkbox |
| 6 | REX_MEDIA_WIDGET | Media-Manager-Widget (Dateiauswahl) |
| 7 | REX_MEDIALIST_WIDGET | Media-Manager-Widget (Dateiliste) |
| 8 | REX_LINK_WIDGET | Link-Widget (Artikel-Auswahl) |
| 9 | REX_LINKLIST_WIDGET | Link-Widget (Artikel-Liste) |
| 10 | date | Datums-Picker |
| 11 | datetime | Datum/Zeit-Picker |
| 12 | legend | Überschrift/Legende |
| 13 | time | Zeit-Picker |

## Prefix

| Prefix | Bereich |
|--------|---------|
| `art_` | Artikel (rex_article) |
| `cat_` | Kategorie (rex_category) |
| `med_` | Medien (rex_media) |
| `clang_` | Sprachen (rex_clang) |

## Praxisbeispiele

### 1. Text-Feld hinzufügen

```php
rex_metainfo_add_field(
    'art_seo_title',        // Name mit Prefix
    'SEO Title',            // Titel im Backend
    1,                      // Priorität (Reihenfolge)
    '',                     // Attributes (HTML)
    1,                      // Typ: text
    '',                     // Default-Wert
    '',                     // Params (z.B. für Select)
    '',                     // Validate (z.B. 'notEmpty')
    ''                      // Restrictions (z.B. '1,2,3')
);
```

### 2. Textarea hinzufügen

```php
rex_metainfo_add_field(
    'art_intro_text',
    'Intro-Text',
    2,
    'rows="5" cols="50"',
    2,                      // Typ: textarea
    '',
    '',
    '',
    ''
);
```

### 3. Select-Feld mit Optionen

```php
rex_metainfo_add_field(
    'art_layout',
    'Layout',
    3,
    '',
    3,                      // Typ: select
    'standard',             // Default-Wert
    'standard=Standard|fullwidth=Full Width|sidebar=Mit Sidebar',
    '',
    ''
);
```

### 4. Radio-Buttons

```php
rex_metainfo_add_field(
    'art_show_sidebar',
    'Sidebar anzeigen',
    4,
    '',
    4,                      // Typ: radio
    '1',
    '1=Ja|0=Nein',
    '',
    ''
);
```

### 5. Checkbox

```php
rex_metainfo_add_field(
    'art_featured',
    'Featured Article',
    5,
    '',
    5,                      // Typ: checkbox
    '0',
    '1=Auf Startseite anzeigen',
    '',
    ''
);
```

### 6. Media-Widget (einzelne Datei)

```php
rex_metainfo_add_field(
    'art_header_image',
    'Header-Bild',
    6,
    '',
    6,                      // Typ: REX_MEDIA_WIDGET
    '',
    '',
    '',
    ''
);
```

### 7. Medialist-Widget (mehrere Dateien)

```php
rex_metainfo_add_field(
    'art_gallery',
    'Galerie-Bilder',
    7,
    '',
    7,                      // Typ: REX_MEDIALIST_WIDGET
    '',
    '',
    '',
    ''
);
```

### 8. Link-Widget (Artikel-Auswahl)

```php
rex_metainfo_add_field(
    'art_related_article',
    'Verwandter Artikel',
    8,
    '',
    8,                      // Typ: REX_LINK_WIDGET
    '',
    '',
    '',
    ''
);
```

### 9. Linklist-Widget (mehrere Artikel)

```php
rex_metainfo_add_field(
    'art_related_articles',
    'Verwandte Artikel',
    9,
    '',
    9,                      // Typ: REX_LINKLIST_WIDGET
    '',
    '',
    '',
    ''
);
```

### 10. Date-Picker

```php
rex_metainfo_add_field(
    'art_publish_date',
    'Veröffentlichungsdatum',
    10,
    '',
    10,                     // Typ: date
    '',
    '',
    '',
    ''
);
```

### 11. Datetime-Picker

```php
rex_metainfo_add_field(
    'art_event_datetime',
    'Event Datum/Zeit',
    11,
    '',
    11,                     // Typ: datetime
    '',
    '',
    '',
    ''
);
```

### 12. Time-Picker

```php
rex_metainfo_add_field(
    'art_opening_time',
    'Öffnungszeit',
    12,
    '',
    13,                     // Typ: time
    '',
    '',
    '',
    ''
);
```

### 13. Legend/Überschrift

```php
rex_metainfo_add_field(
    'art_seo_legend',
    'SEO-Einstellungen',
    13,
    '',
    12,                     // Typ: legend
    '',
    '',
    '',
    ''
);
```

### 14. Feld mit Validation

```php
rex_metainfo_add_field(
    'art_email',
    'E-Mail',
    14,
    '',
    1,                      // text
    '',
    '',
    'notEmpty,email',       // Validierung
    ''
);
```

### 15. Feld nur für bestimmte Kategorien

```php
rex_metainfo_add_field(
    'art_special_field',
    'Spezielles Feld',
    15,
    '',
    1,
    '',
    '',
    '',
    '5,6,7'                 // Nur für Kategorien 5,6,7
);
```

### 16. Kategorie-Feld

```php
rex_metainfo_add_field(
    'cat_teaser_image',
    'Kategorie Teaser',
    1,
    '',
    6,                      // REX_MEDIA_WIDGET
    '',
    '',
    '',
    ''
);
```

### 17. Media-Feld

```php
rex_metainfo_add_field(
    'med_copyright',
    'Copyright',
    1,
    '',
    1,                      // text
    '',
    '',
    '',
    ''
);
```

### 18. Wert im Frontend auslesen (Artikel)

```php
$article = rex_article::getCurrent();
$seoTitle = $article->getValue('art_seo_title');
$headerImage = $article->getValue('art_header_image');
$featured = $article->getValue('art_featured');
```

### 19. REX_VAR Ausgabe

```text
REX_ARTICLE[field="art_seo_title"]
REX_ARTICLE[id="5" field="art_intro_text"]
REX_CATEGORY[field="cat_teaser_image"]
REX_MEDIA[file="beispiel.jpg" field="med_copyright"]
```

### 20. Kategorie-Wert auslesen

```php
$category = rex_category::getCurrent();
$teaserImage = $category->getValue('cat_teaser_image');
```

### 21. Media-Wert auslesen

```php
$media = rex_media::get('beispiel.jpg');
$copyright = $media->getValue('med_copyright');
```

### 22. Feld programmatisch löschen

```php
if (rex_metainfo_delete_field('art_old_field')) {
    echo 'Feld erfolgreich gelöscht';
}
```

### 23. Select-Feld mit DB-Query

```php
// Optionen aus Datenbank holen
$sql = rex_sql::factory();
$sql->setQuery('SELECT id, name FROM rex_my_table ORDER BY name');
$options = [];

foreach ($sql as $row) {
    $options[] = $row->getValue('id') . '=' . $row->getValue('name');
}

rex_metainfo_add_field(
    'art_reference',
    'Referenz',
    20,
    '',
    3,                      // select
    '',
    implode('|', $options),
    '',
    ''
);
```

### 24. Conditional Field Display (per Extension Point)

```php
rex_extension::register('METAINFO_FORM_ADD', function(rex_extension_point $ep) {
    $field = $ep->getParam('field');
    
    // Feld nur bei bestimmten Templates anzeigen
    if ($field->getName() == 'art_special_field') {
        $article = rex_article::getCurrent();
        if ($article->getTemplateId() != 5) {
            return false; // Feld ausblenden
        }
    }
});
```

### 25. Multiple Media-Widgets verarbeiten

```php
$galleryImages = $article->getValue('art_gallery');
$images = explode(',', $galleryImages);

foreach ($images as $filename) {
    if ($media = rex_media::get($filename)) {
        echo '<img src="' . rex_url::media($filename) . '" alt="' . $media->getTitle() . '">';
    }
}
```

### 26. Linklist verarbeiten

```php
$relatedIds = $article->getValue('art_related_articles');
$articleIds = explode(',', $relatedIds);

foreach ($articleIds as $id) {
    if ($related = rex_article::get($id)) {
        echo '<a href="' . $related->getUrl() . '">' . $related->getName() . '</a>';
    }
}
```

### 27. Installation in boot.php

```php
// addon/plugins/.../boot.php
if (!rex_metainfo_add_field('art_custom_field', 'Custom', 1, '', 1, '', '', '', '')) {
    // Feld existiert bereits oder Fehler
}
```

### 28. Uninstall in uninstall.php

```php
// addon/plugins/.../uninstall.php
rex_metainfo_delete_field('art_custom_field');
rex_metainfo_delete_field('cat_custom_field');
rex_metainfo_delete_field('med_custom_field');
```

### 29. Standardwert mit PHP

```php
rex_metainfo_add_field(
    'art_created_date',
    'Erstellt am',
    25,
    '',
    10,                     // date
    date('Y-m-d'),          // Heutiges Datum als Standard
    '',
    '',
    ''
);
```

### 30. Custom HTML-Attribute

```php
rex_metainfo_add_field(
    'art_video_url',
    'Video-URL',
    30,
    'placeholder="https://youtube.com/..." pattern="https://.*"',
    1,                      // text
    '',
    '',
    '',
    ''
);
```

> **Integration:** Metainfo arbeitet mit **Structure-Plugin** (Artikel/Kategorien), **Medienpool** (Media-Metadaten), **Backend** (Formular-Generierung), **YForm** (Feld-Typen-Kompatibilität), **REX_VAR** (Template-Ausgabe), **Extension Points** (METAINFO_FORM_ADD, METAINFO_TYPE_*) und **rex_sql** (Datenbank-Spalten). Felder werden automatisch als Spalten in `rex_article`, `rex_category` und `rex_media` angelegt.
