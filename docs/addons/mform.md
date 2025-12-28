# MForm - Module Input Builder

**Keywords:** Module Input Form Builder UI Widgets Repeater Media Link Custom Fields Backend

## Übersicht

Addon zum Erstellen von REDAXO Modul-Eingaben per PHP-API mit visuellen Widgets (Media, Links, Repeater), Layouts (Fieldsets, Tabs, Columns) und flexiblen Templates. Ersetzt MBlock durch integrierten Repeater mit Nesting-Fähigkeit.

## Hauptklasse

### MForm

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `::factory($debug)` | bool | MForm | Factory-Pattern, neue Instanz |
| `show()` | - | string | Rendert Formular-HTML |
| `setTheme($theme)` | string | $this | Template-Theme setzen |
| `setDebug($debug)` | bool | $this | Debug-Modus |
| `setShowWrapper($bool)` | bool | $this | Wrapper anzeigen? |

## Basis-Felder

| Methode | Parameter | Beschreibung |
|---------|-----------|--------------|
| `addTextField($id, $attr, $default)` | int/string, array, string | Text-Eingabe (REX_VALUE[]) |
| `addTextAreaField($id, $attr, $default)` | int/string, array, string | Textarea (REX_VALUE[]) |
| `addHiddenField($id, $value, $attr)` | int/string, string, array | Hidden-Feld |
| `addSelectField($id, $options, $attr, $size, $default)` | int/string, array, array, int, string | Select-Dropdown |
| `addMultiSelectField($id, $options, $attr, $size, $default)` | int/string, array, array, int, string | Multiple-Select |
| `addCheckboxField($id, $options, $attr, $default)` | int/string, array, array, string | Checkboxen |
| `addRadioField($id, $options, $attr, $default)` | int/string, array, array, string | Radio-Buttons |
| `addInputField($type, $id, $attr, $default)` | string, int/string, array, string | HTML5 Input (email, number, date, etc.) |

## Spezial-Widgets

| Methode | Parameter | Beschreibung |
|---------|-----------|--------------|
| `addMediaField($id, $attr)` | int, array | Media-Pool Datei-Auswahl (REX_MEDIA[]) |
| `addMedialistField($id, $attr)` | int, array | Media-Pool Mehrfach-Auswahl (REX_MEDIALIST[]) |
| `addLinkField($id, $attr)` | int, array | Artikel-Link (REX_LINK[]) |
| `addLinklistField($id, $attr)` | int, array | Mehrfach Artikel-Links (REX_LINKLIST[]) |
| `addCustomLinkField($id, $attr)` | int/string, array | Flexibler Link (intern/extern/media/mailto/tel) |
| `addImageListField($id, $attr)` | int/string, array | Bild-Liste mit Titel/Copyright |
| `addLinkListField($id, $attr)` | int/string, array | Link-Liste mit Titel/Beschreibung |
| `addYFormLinkField($id, $table, $attr)` | int/string, string, array | YForm-Dataset Verknüpfung |

## Layout-Elemente

| Methode | Parameter | Beschreibung |
|---------|-----------|--------------|
| `addFieldsetArea($legend, $form, $attr)` | string, MForm/callable, array | Fieldset-Gruppierung |
| `addColumnElement($col, $form, $attr)` | int, MForm/callable, array | Spalten-Layout (Bootstrap col-sm-X) |
| `addInlineElement($label, $form, $attr)` | string, MForm/callable, array | Inline-Darstellung (Felder nebeneinander) |
| `addTabElement($label, $form, $open, $pullRight, $attr)` | string, MForm/callable, bool, bool, array | Tab-Panel |
| `addCollapseElement($label, $form, $open, $hideLinks, $attr, $accordion)` | string, MForm/callable, bool, bool, array, bool | Ausklapp-Panel |
| `addAccordionElement($label, $form, $open, $hideLinks, $attr)` | string, MForm/callable, bool, bool, array | Accordion (auto-close other) |

## Repeater

| Methode | Parameter | Beschreibung |
|---------|-----------|--------------|
| `addRepeaterElement($id, $form, $open, $confirmDelete, $attr)` | int/string, MForm, bool, bool, array | Wiederhol-Element (ersetzt MBlock) mit Nesting |

## Feld-Optionen

| Methode | Parameter | Beschreibung |
|---------|-----------|--------------|
| `setLabel($label)` | string | Feld-Beschriftung |
| `setAttributes($attr)` | array | HTML-Attribute (class, id, data-*) |
| `setOptions($options)` | array | Select/Radio/Checkbox Optionen |
| `setSize($size)` | int | Select size / Textarea rows |
| `setMultiple()` | - | Multiple-Auswahl aktivieren |
| `setPlaceholder($text)` | string | Placeholder-Text |
| `setDefaultValue($value)` | string | Standard-Wert |

## Hilfs-Elemente

| Methode | Parameter | Beschreibung |
|---------|-----------|--------------|
| `addHtml($html)` | string | Raw HTML |
| `addHeadline($text, $attr)` | string, array | Überschrift |
| `addDescription($text)` | string | Beschreibungstext |
| `addAlertInfo($text)` | string | Info-Hinweis (blau) |
| `addAlertWarning($text)` | string | Warnung (gelb) |
| `addAlertDanger($text)` | string | Fehler (rot) |
| `addAlertSuccess($text)` | string | Erfolg (grün) |

## Praxisbeispiele

### Einfaches Text-Modul

```php
<?php
// In Modul-Eingabe
use FriendsOfRedaxo\MForm;

echo MForm::factory()
    ->addTextField(1, ['label' => 'Überschrift'])
    ->addTextAreaField(2, ['label' => 'Text'])
    ->show();
```

### Mit Fieldset-Gruppierung

```php
use FriendsOfRedaxo\MForm;

$mform = MForm::factory();

$mform->addFieldsetArea('Inhalt', MForm::factory()
    ->addTextField(1, ['label' => 'Überschrift'])
    ->addTextAreaField(2, ['label' => 'Text', 'rows' => 5])
);

$mform->addFieldsetArea('Bild', MForm::factory()
    ->addMediaField(1, ['label' => 'Bild'])
    ->addTextField(3, ['label' => 'Bildunterschrift'])
);

echo $mform->show();
```

### Select mit Optionen

```php
echo MForm::factory()
    ->addSelectField(5, [
        'left' => 'Links',
        'center' => 'Mittig',
        'right' => 'Rechts'
    ], ['label' => 'Ausrichtung'])
    ->show();
```

### Multi-Select

```php
echo MForm::factory()
    ->addMultiSelectField(6, [
        'option1' => 'Option 1',
        'option2' => 'Option 2',
        'option3' => 'Option 3'
    ], ['label' => 'Mehrfachauswahl'], 5) // 5 Zeilen
    ->show();
```

### Checkboxen & Radio Buttons

```php
$mform = MForm::factory();

// Checkboxen
$mform->addCheckboxField(7, [
    'bold' => 'Fett',
    'italic' => 'Kursiv',
    'underline' => 'Unterstrichen'
], ['label' => 'Textformatierung']);

// Radio Buttons
$mform->addRadioField(8, [
    'h1' => 'Überschrift 1',
    'h2' => 'Überschrift 2',
    'h3' => 'Überschrift 3'
], ['label' => 'Überschriften-Typ']);

echo $mform->show();
```

### HTML5 Input-Typen

```php
$mform = MForm::factory();

$mform->addInputField('email', 1, ['label' => 'E-Mail', 'placeholder' => 'name@example.com']);
$mform->addInputField('number', 2, ['label' => 'Alter', 'min' => 0, 'max' => 120]);
$mform->addInputField('date', 3, ['label' => 'Datum']);
$mform->addInputField('color', 4, ['label' => 'Farbe']);
$mform->addInputField('range', 5, ['label' => 'Lautstärke', 'min' => 0, 'max' => 100]);

echo $mform->show();
```

### Media-Feld (Bild/Datei)

```php
echo MForm::factory()
    ->addMediaField(1, [
        'label' => 'Bild auswählen',
        'types' => 'jpg,png,gif',
        'category' => 5 // Nur aus dieser Kategorie
    ])
    ->show();
```

### Medialist (mehrere Dateien)

```php
echo MForm::factory()
    ->addMedialistField(1, [
        'label' => 'Galerie-Bilder',
        'types' => 'jpg,png'
    ])
    ->show();

// Ausgabe
$images = explode(',', 'REX_MEDIALIST[1]');
foreach ($images as $image) {
    echo '<img src="/media/' . $image . '">';
}
```

### Link-Feld (Artikel-Verknüpfung)

```php
echo MForm::factory()
    ->addLinkField(1, ['label' => 'Ziel-Artikel'])
    ->show();

// Ausgabe
$article_id = 'REX_LINK[1]';
if ($article_id) {
    $article = rex_article::get($article_id);
    echo '<a href="' . $article->getUrl() . '">' . $article->getName() . '</a>';
}
```

### Custom Link (vielseitig)

```php
echo MForm::factory()
    ->addCustomLinkField('link', [
        'label' => 'Link (intern/extern/Media/Mailto/Tel)'
    ])
    ->show();

// Ausgabe (REX_VALUE[20] als JSON)
$link = json_decode('REX_VALUE[20]', true);

if ($link) {
    switch ($link['type']) {
        case 'internal':
            $url = rex_getUrl($link['article']);
            break;
        case 'external':
            $url = $link['url'];
            break;
        case 'media':
            $url = '/media/' . $link['media'];
            break;
        case 'mailto':
            $url = 'mailto:' . $link['email'];
            break;
        case 'tel':
            $url = 'tel:' . $link['phone'];
            break;
    }
    
    echo '<a href="' . $url . '">' . ($link['title'] ?? 'Link') . '</a>';
}
```

### YForm-Verknüpfung

```php
echo MForm::factory()
    ->addYFormLinkField('product_id', 'rex_products', [
        'label' => 'Produkt auswählen'
    ])
    ->show();

// Ausgabe
$product_id = 'REX_VALUE[20]';
if ($product_id) {
    $product = rex_yform_manager_dataset::get($product_id, 'rex_products');
    echo $product->name;
}
```

### Image-List Widget

```php
echo MForm::factory()
    ->addImageListField('images', [
        'label' => 'Bild-Galerie mit Titel/Copyright'
    ])
    ->show();

// Ausgabe (REX_VALUE[20] als JSON)
$images = json_decode('REX_VALUE[20]', true);

foreach ($images as $img) {
    echo '<figure>';
    echo '<img src="/media/' . $img['image'] . '">';
    echo '<figcaption>' . $img['title'] . '</figcaption>';
    echo '<small>&copy; ' . $img['copyright'] . '</small>';
    echo '</figure>';
}
```

### Link-List Widget

```php
echo MForm::factory()
    ->addLinkListField('links', [
        'label' => 'Link-Liste mit Beschreibung'
    ])
    ->show();

// Ausgabe (REX_VALUE[20] als JSON)
$links = json_decode('REX_VALUE[20]', true);

echo '<ul>';
foreach ($links as $link) {
    echo '<li>';
    echo '<a href="' . $link['url'] . '">' . $link['title'] . '</a>';
    echo '<p>' . $link['description'] . '</p>';
    echo '</li>';
}
echo '</ul>';
```

### Spalten-Layout (2-spaltig)

```php
$mform = MForm::factory();

$mform->addColumnElement(6, MForm::factory()
    ->addTextField(1, ['label' => 'Linke Spalte'])
    ->addTextAreaField(2, ['label' => 'Text links'])
);

$mform->addColumnElement(6, MForm::factory()
    ->addTextField(3, ['label' => 'Rechte Spalte'])
    ->addTextAreaField(4, ['label' => 'Text rechts'])
);

echo $mform->show();
```

### Inline-Felder (nebeneinander)

```php
echo MForm::factory()
    ->addInlineElement('Adresse', MForm::factory()
        ->addTextField('street', ['label' => 'Straße', 'class' => 'col-8'])
        ->addTextField('number', ['label' => 'Nr.', 'class' => 'col-4'])
    )
    ->show();
```

### Tabs

```php
$mform = MForm::factory();

$mform->addTabElement('Inhalt', MForm::factory()
    ->addTextField(1, ['label' => 'Überschrift'])
    ->addTextAreaField(2, ['label' => 'Text'])
, true); // true = Tab initial geöffnet

$mform->addTabElement('Bild', MForm::factory()
    ->addMediaField(1, ['label' => 'Bild'])
    ->addTextField(3, ['label' => 'Alt-Text'])
);

$mform->addTabElement('Einstellungen', MForm::factory()
    ->addSelectField(5, ['left' => 'Links', 'right' => 'Rechts'], ['label' => 'Position'])
);

echo $mform->show();
```

### Collapse / Accordion

```php
$mform = MForm::factory();

// Collapse (alle können offen sein)
$mform->addCollapseElement('SEO', MForm::factory()
    ->addTextField(10, ['label' => 'Meta Title'])
    ->addTextAreaField(11, ['label' => 'Meta Description'])
, true); // true = initial geöffnet

// Accordion (nur eines offen)
$mform->addAccordionElement('Erweitert', MForm::factory()
    ->addTextField(12, ['label' => 'Custom CSS Class'])
    ->addTextAreaField(13, ['label' => 'Custom JS'])
);

echo $mform->show();
```

### Repeater (einfach)

```php
echo MForm::factory()
    ->addRepeaterElement(1, MForm::factory()
        ->addTextField('title', ['label' => 'Titel'])
        ->addTextAreaField('text', ['label' => 'Text'])
        ->addMediaField('REX_MEDIA_1', ['label' => 'Bild'])
    )
    ->show();

// Ausgabe (REX_VALUE[1] als JSON-Array)
$items = json_decode('REX_VALUE[1]', true);

foreach ($items as $item) {
    echo '<h3>' . $item['title'] . '</h3>';
    echo '<p>' . $item['text'] . '</p>';
    echo '<img src="/media/' . $item['REX_MEDIA_1'] . '">';
}
```

### Repeater mit Nesting

```php
echo MForm::factory()
    ->addRepeaterElement(1, MForm::factory()
        ->addTextField('section_title', ['label' => 'Abschnitts-Titel'])
        
        // Nested Repeater für Slides
        ->addRepeaterElement('slides', MForm::factory()
            ->addTextField('slide_title', ['label' => 'Slide-Titel'])
            ->addMediaField('REX_MEDIA_1', ['label' => 'Slide-Bild'])
            ->addTextField('caption', ['label' => 'Beschriftung'])
        , true, true, ['btn_text' => 'Slide hinzufügen'])
    , true, true, ['btn_text' => 'Abschnitt hinzufügen'])
    ->show();

// Ausgabe (verschachtelt)
$sections = json_decode('REX_VALUE[1]', true);

foreach ($sections as $section) {
    echo '<section>';
    echo '<h2>' . $section['section_title'] . '</h2>';
    
    foreach ($section['slides'] as $slide) {
        echo '<div class="slide">';
        echo '<h3>' . $slide['slide_title'] . '</h3>';
        echo '<img src="/media/' . $slide['REX_MEDIA_1'] . '">';
        echo '<p>' . $slide['caption'] . '</p>';
        echo '</div>';
    }
    
    echo '</section>';
}
```

### Repeater mit Custom Buttons

```php
echo MForm::factory()
    ->addRepeaterElement(1, MForm::factory()
        ->addTextField('name', ['label' => 'Name'])
        ->addTextField('email', ['label' => 'E-Mail'])
    , true, true, [
        'btn_text' => 'Kontakt hinzufügen', // Button-Text
        'btn_class' => 'btn-success', // Button-Klasse
        'confirm_delete_msg' => 'Wirklich löschen?' // Confirm-Message
    ])
    ->show();
```

### Bedingtes Anzeigen (Toggle Checkbox)

```php
$mform = MForm::factory();

$mform->addToggleCheckboxField(10, [
    'show_video' => 'Video anzeigen'
], ['label' => 'Optionen']);

$mform->addCollapseElement('Video-Einstellungen', MForm::factory()
    ->addTextField(1, ['label' => 'YouTube-ID'])
    ->addCheckboxField(11, [
        'autoplay' => 'Autoplay',
        'loop' => 'Loop'
    ])
, false, false, [
    'data-mform-collapse-trigger' => 'show_video' // Wird angezeigt wenn show_video aktiv
]);

echo $mform->show();
```

### Alerts & Hinweise

```php
$mform = MForm::factory();

$mform->addAlertInfo('Dies ist eine Info-Nachricht');
$mform->addAlertWarning('Achtung: Bitte beachten!');
$mform->addAlertDanger('Fehler: Etwas ist schiefgelaufen');
$mform->addAlertSuccess('Erfolgreich gespeichert!');

$mform->addTextField(1, ['label' => 'Name']);

echo $mform->show();
```

### Custom HTML einfügen

```php
$mform = MForm::factory();

$mform->addTextField(1, ['label' => 'Titel']);

$mform->addHtml('<hr><p>Weitere Optionen:</p>');

$mform->addCheckboxField(5, [
    'featured' => 'Als Featured markieren'
]);

echo $mform->show();
```

### Placeholder & Default-Werte

```php
echo MForm::factory()
    ->addTextField(1, [
        'label' => 'Name',
        'placeholder' => 'Max Mustermann'
    ])
    ->addTextField(2, [
        'label' => 'E-Mail',
        'placeholder' => 'max@example.com'
    ], 'info@example.com') // Default-Wert
    ->show();
```

### CSS-Klassen & Attribute

```php
echo MForm::factory()
    ->addTextField(1, [
        'label' => 'Code',
        'class' => 'form-control-lg font-monospace',
        'data-custom' => 'value',
        'maxlength' => 50
    ])
    ->show();
```

### Dynamische Optionen (SQL)

```php
// Kategorien aus Datenbank
$sql = rex_sql::factory();
$sql->setQuery('SELECT id, name FROM rex_categories ORDER BY name');

$options = [];
foreach ($sql as $row) {
    $options[$row->getValue('id')] = $row->getValue('name');
}

echo MForm::factory()
    ->addSelectField(5, $options, ['label' => 'Kategorie wählen'])
    ->show();
```

### MForm mit Closure

```php
$mform = MForm::factory();

$mform->addFieldsetArea('Inhalt', function() {
    return MForm::factory()
        ->addTextField(1, ['label' => 'Titel'])
        ->addTextAreaField(2, ['label' => 'Text']);
});

echo $mform->show();
```

### Theme anpassen

```php
// Custom Theme verwenden
echo MForm::factory()
    ->setTheme('bootstrap5') // Theme-Name
    ->addTextField(1, ['label' => 'Name'])
    ->show();
```

### Debug-Modus

```php
// Zeigt generiertes Array
echo MForm::factory(true) // true = Debug
    ->addTextField(1, ['label' => 'Test'])
    ->show();
```

### Komplettes Beispiel (Team-Modul)

```php
use FriendsOfRedaxo\MForm;

$mform = MForm::factory();

$mform->addFieldsetArea('Team-Mitglied', MForm::factory()
    ->addTextField(1, ['label' => 'Name*'])
    ->addTextField(2, ['label' => 'Position'])
    ->addTextField(3, ['label' => 'E-Mail'])
    ->addMediaField(1, ['label' => 'Foto'])
    ->addTextAreaField(4, ['label' => 'Biografie', 'rows' => 5])
);

$mform->addTabElement('Social Media', MForm::factory()
    ->addTextField(5, ['label' => 'LinkedIn', 'placeholder' => 'https://linkedin.com/in/...'])
    ->addTextField(6, ['label' => 'Twitter', 'placeholder' => '@username'])
    ->addTextField(7, ['label' => 'Website', 'placeholder' => 'https://...'])
);

$mform->addTabElement('Einstellungen', MForm::factory()
    ->addCheckboxField(10, [
        'featured' => 'Als Featured anzeigen',
        'public_email' => 'E-Mail öffentlich anzeigen'
    ], ['label' => 'Optionen'])
    ->addSelectField(11, [
        'left' => 'Links',
        'center' => 'Mittig',
        'right' => 'Rechts'
    ], ['label' => 'Bild-Position'])
);

echo $mform->show();
```

### Migration von MBlock zu Repeater

```php
// ALT (MBlock)
$mform = new MForm();
$mform->addTextField("1.0.name", ['label' => 'Name']);
$mform->addMediaField(1, ['label' => 'Bild']);
echo MBlock::show(1, $mform->show());

// NEU (MForm Repeater)
echo MForm::factory()
    ->addRepeaterElement(1, MForm::factory()
        ->addTextField('name', ['label' => 'Name'])
        ->addMediaField('REX_MEDIA_1', ['label' => 'Bild'])
    )
    ->show();
```
