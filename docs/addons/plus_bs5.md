# Plus BS5 - Keywords: Bootstrap 5, Module, Template, Fragment, MForm, MBlock, YForm, Responsive, Components

## Übersicht

**Plus BS5** ist ein umfangreiches Framework für Bootstrap 5 in REDAXO. Es bietet fertige Module, Template-Strukturen, Fragmente für die Ausgabe und erweiterte MForm/MBlock-Integrationen. Das Addon beschleunigt die Entwicklung von Bootstrap 5-Websites erheblich durch wiederverwendbare Komponenten.

**Autor:** Alexander Walther  
**GitHub:** <https://github.com/alexplusde/plus_bs5>  
**Abhängigkeiten:** REDAXO >= 5.17, YForm >= 4.0, MForm >= 7.0, MBlock >= 5.0  
**Optional:** Redactor, YRewrite

---

## Kern-Klassen

| Klasse | Beschreibung |
|--------|--------------|
| `BS5\Fragment` | Fragment-Verwaltung und Parsing |
| `BS5\Helper` | Hilfs-Methoden für Bootstrap-Komponenten |
| `BS5\MForm` | MForm-Erweiterungen für BS5 |
| `BS5\Config` | Konfigurationsverwaltung |

---

## BS5\Fragment

| Methode | Beschreibung |
|---------|--------------|
| `get($name)` | Lädt Fragment-Datei und gibt Inhalt zurück |
| `parse($name, $vars = [])` | Parsed Fragment mit Variablen |
| `exists($name)` | Prüft, ob Fragment existiert |
| `getPath($name)` | Gibt vollständigen Pfad zu Fragment zurück |
| `getList()` | Gibt Array aller verfügbaren Fragmente zurück |

---

## BS5\Helper

| Methode | Beschreibung |
|---------|--------------|
| `getIcon($name, $class = '')` | Gibt Bootstrap-Icon HTML zurück |
| `getButton($text, $url, $class = 'btn-primary')` | Erstellt Bootstrap-Button |
| `getCard($title, $content, $footer = '')` | Erstellt Bootstrap-Card |
| `getAlert($message, $type = 'info')` | Erstellt Bootstrap-Alert |
| `getBadge($text, $type = 'primary')` | Erstellt Bootstrap-Badge |
| `getAccordion($items)` | Erstellt Bootstrap-Accordion |
| `getCarousel($items, $id = 'carousel')` | Erstellt Bootstrap-Carousel |
| `getModal($id, $title, $content)` | Erstellt Bootstrap-Modal |
| `getOffcanvas($id, $title, $content)` | Erstellt Bootstrap-Offcanvas |

---

## BS5\MForm

| Methode | Beschreibung |
|---------|--------------|
| `addBS5InputField($label, $name, $value = '')` | Fügt BS5-styled Input hinzu |
| `addBS5SelectField($label, $name, $options = [])` | Fügt BS5-styled Select hinzu |
| `addBS5TextareaField($label, $name, $value = '')` | Fügt BS5-styled Textarea hinzu |
| `addBS5CheckboxField($label, $name, $value = 1)` | Fügt BS5-styled Checkbox hinzu |
| `addBS5RadioField($label, $name, $options = [])` | Fügt BS5-styled Radio-Group hinzu |
| `addBS5SwitchField($label, $name, $value = 1)` | Fügt BS5-styled Switch hinzu |
| `addBS5RangeField($label, $name, $min, $max)` | Fügt BS5-styled Range-Slider hinzu |

---

## Fragment-Struktur

### Layout-Fragmente

| Fragment | Beschreibung |
|----------|--------------|
| `bs5/layout/container.php` | Container/Container-Fluid |
| `bs5/layout/row.php` | Bootstrap Row |
| `bs5/layout/col.php` | Bootstrap Column |
| `bs5/layout/grid.php` | Vollständiges Grid-System |
| `bs5/layout/section.php` | Section mit Padding/Margin |

### Komponenten-Fragmente

| Fragment | Beschreibung |
|----------|--------------|
| `bs5/components/accordion.php` | Accordion-Komponente |
| `bs5/components/alert.php` | Alert-Box |
| `bs5/components/badge.php` | Badge |
| `bs5/components/breadcrumb.php` | Breadcrumb-Navigation |
| `bs5/components/button.php` | Button |
| `bs5/components/card.php` | Card-Komponente |
| `bs5/components/carousel.php` | Carousel/Slider |
| `bs5/components/collapse.php` | Collapse-Element |
| `bs5/components/dropdown.php` | Dropdown-Menü |
| `bs5/components/list-group.php` | List-Group |
| `bs5/components/modal.php` | Modal-Dialog |
| `bs5/components/nav.php` | Navigation |
| `bs5/components/navbar.php` | Navbar |
| `bs5/components/offcanvas.php` | Offcanvas-Menü |
| `bs5/components/pagination.php` | Pagination |
| `bs5/components/progress.php` | Progress-Bar |
| `bs5/components/spinner.php` | Loading-Spinner |
| `bs5/components/table.php` | Responsive Table |
| `bs5/components/tabs.php` | Tabs |
| `bs5/components/toast.php` | Toast-Notification |

### Content-Fragmente

| Fragment | Beschreibung |
|----------|--------------|
| `bs5/content/hero.php` | Hero-Section |
| `bs5/content/feature.php` | Feature-Box |
| `bs5/content/testimonial.php` | Testimonial/Zitat |
| `bs5/content/team.php` | Team-Member-Card |
| `bs5/content/pricing.php` | Pricing-Table |
| `bs5/content/cta.php` | Call-to-Action |
| `bs5/content/gallery.php` | Bildergalerie |
| `bs5/content/video.php` | Video-Embed |

---

## Module

### Content-Module

| Modul | Beschreibung |
|-------|--------------|
| **Text** | WYSIWYG-Editor mit Redactor |
| **Text + Bild** | Text neben Bild (links/rechts) |
| **Überschrift** | H1-H6 mit Styling-Optionen |
| **Button** | Call-to-Action-Button |
| **Zitat** | Blockquote mit Autor |
| **Video** | YouTube/Vimeo-Embed |
| **Galerie** | Bildergalerie mit Lightbox |

### Layout-Module

| Modul | Beschreibung |
|-------|--------------|
| **Container** | Container/Container-Fluid |
| **Grid** | Flexibles Spalten-Layout |
| **Spacer** | Vertikaler Abstand |
| **Separator** | Trennlinie (HR) |

### Komponenten-Module

| Modul | Beschreibung |
|-------|--------------|
| **Accordion** | Ausklappbare Bereiche |
| **Tabs** | Tab-Navigation mit Content |
| **Cards** | Card-Grid mit MBlock |
| **Slider** | Bootstrap-Carousel |
| **Features** | Feature-Boxen mit Icons |
| **Team** | Team-Member-Cards |
| **Testimonials** | Kundenbewertungen |
| **Pricing** | Preistabellen |
| **FAQ** | Häufige Fragen als Accordion |
| **Contact** | Kontakt-Formular mit YForm |

---

## 30 Praxisbeispiele

### 1. Fragment laden und ausgeben

```php
$fragment = new BS5\Fragment();
echo $fragment->parse('bs5/components/alert', [
    'type' => 'success',
    'message' => 'Erfolgreich gespeichert!'
]);
```

### 2. Button-Helper verwenden

```php
$helper = new BS5\Helper();
echo $helper->getButton('Mehr erfahren', '/about', 'btn-primary btn-lg');
```

### 3. Card erstellen

```php
$card = BS5\Helper::getCard(
    'Titel der Card',
    '<p>Dies ist der Card-Inhalt mit HTML.</p>',
    '<a href="#" class="btn btn-primary">Weiterlesen</a>'
);
echo $card;
```

### 4. Alert-Box ausgeben

```php
echo BS5\Helper::getAlert('Achtung: Diese Aktion kann nicht rückgängig gemacht werden.', 'warning');
```

### 5. Badge erstellen

```php
echo 'Status: ' . BS5\Helper::getBadge('Aktiv', 'success');
```

### 6. Accordion mit mehreren Items

```php
$items = [
    ['title' => 'Frage 1', 'content' => 'Antwort 1'],
    ['title' => 'Frage 2', 'content' => 'Antwort 2'],
    ['title' => 'Frage 3', 'content' => 'Antwort 3'],
];
echo BS5\Helper::getAccordion($items);
```

### 7. Carousel mit Bildern

```php
$slides = [
    ['image' => '/media/slide1.jpg', 'caption' => 'Slide 1'],
    ['image' => '/media/slide2.jpg', 'caption' => 'Slide 2'],
    ['image' => '/media/slide3.jpg', 'caption' => 'Slide 3'],
];
echo BS5\Helper::getCarousel($slides, 'heroCarousel');
```

### 8. Modal-Dialog

```php
$modal = BS5\Helper::getModal(
    'confirmModal',
    'Bestätigung erforderlich',
    '<p>Möchten Sie diese Aktion wirklich durchführen?</p>
     <button class="btn btn-danger" data-bs-dismiss="modal">Abbrechen</button>
     <button class="btn btn-success">Bestätigen</button>'
);
echo $modal;

// Trigger-Button
echo '<button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#confirmModal">Öffnen</button>';
```

### 9. Offcanvas-Menü

```php
$offcanvas = BS5\Helper::getOffcanvas(
    'mobileMenu',
    'Navigation',
    '<nav>
        <a href="/" class="d-block py-2">Home</a>
        <a href="/about" class="d-block py-2">Über uns</a>
        <a href="/contact" class="d-block py-2">Kontakt</a>
    </nav>'
);
echo $offcanvas;

// Trigger-Button
echo '<button class="btn btn-primary" data-bs-toggle="offcanvas" data-bs-target="#mobileMenu">Menü</button>';
```

### 10. Container-Fragment

```php
$fragment = new BS5\Fragment();
echo $fragment->parse('bs5/layout/container', [
    'fluid' => false,
    'content' => '<h1>Willkommen</h1>'
]);
```

### 11. Grid-Layout mit Fragmenten

```php
$fragment = new BS5\Fragment();
echo $fragment->parse('bs5/layout/grid', [
    'columns' => [
        ['content' => '<h3>Spalte 1</h3>', 'class' => 'col-md-4'],
        ['content' => '<h3>Spalte 2</h3>', 'class' => 'col-md-4'],
        ['content' => '<h3>Spalte 3</h3>', 'class' => 'col-md-4'],
    ]
]);
```

### 12. Hero-Section

```php
$fragment = new BS5\Fragment();
echo $fragment->parse('bs5/content/hero', [
    'title' => 'Willkommen auf unserer Website',
    'subtitle' => 'Wir bieten erstklassige Dienstleistungen',
    'button_text' => 'Jetzt starten',
    'button_url' => '/start',
    'background_image' => '/media/hero-bg.jpg'
]);
```

### 13. Feature-Boxen

```php
$fragment = new BS5\Fragment();
$features = [
    [
        'icon' => 'bi-lightning',
        'title' => 'Schnell',
        'text' => 'Optimierte Performance'
    ],
    [
        'icon' => 'bi-shield-check',
        'title' => 'Sicher',
        'text' => 'Höchste Sicherheitsstandards'
    ],
    [
        'icon' => 'bi-heart',
        'title' => 'Zuverlässig',
        'text' => 'Immer für Sie da'
    ]
];

foreach ($features as $feature) {
    echo $fragment->parse('bs5/content/feature', $feature);
}
```

### 14. Team-Member-Card

```php
$fragment = new BS5\Fragment();
echo $fragment->parse('bs5/content/team', [
    'name' => 'Max Mustermann',
    'position' => 'Geschäftsführer',
    'image' => '/media/team/max.jpg',
    'email' => 'max@example.com',
    'phone' => '+49 123 456789'
]);
```

### 15. Pricing-Table

```php
$fragment = new BS5\Fragment();
echo $fragment->parse('bs5/content/pricing', [
    'title' => 'Premium',
    'price' => '29,90',
    'period' => 'monatlich',
    'features' => [
        'Feature 1',
        'Feature 2',
        'Feature 3'
    ],
    'button_text' => 'Jetzt buchen',
    'button_url' => '/checkout',
    'highlighted' => true
]);
```

### 16. Breadcrumb-Navigation

```php
$fragment = new BS5\Fragment();
echo $fragment->parse('bs5/components/breadcrumb', [
    'items' => [
        ['label' => 'Home', 'url' => '/'],
        ['label' => 'Produkte', 'url' => '/produkte'],
        ['label' => 'Details', 'active' => true]
    ]
]);
```

### 17. Pagination

```php
$fragment = new BS5\Fragment();
echo $fragment->parse('bs5/components/pagination', [
    'current' => 3,
    'total' => 10,
    'url_pattern' => '/news?page={page}'
]);
```

### 18. Progress-Bar

```php
$fragment = new BS5\Fragment();
echo $fragment->parse('bs5/components/progress', [
    'value' => 75,
    'label' => '75% abgeschlossen',
    'color' => 'success',
    'striped' => true,
    'animated' => true
]);
```

### 19. Toast-Notification

```php
$fragment = new BS5\Fragment();
echo $fragment->parse('bs5/components/toast', [
    'title' => 'Benachrichtigung',
    'message' => 'Ihre Änderungen wurden gespeichert.',
    'time' => 'vor 1 Minute',
    'autohide' => true
]);
```

### 20. Responsive Table

```php
$fragment = new BS5\Fragment();
echo $fragment->parse('bs5/components/table', [
    'headers' => ['Name', 'Email', 'Status'],
    'rows' => [
        ['Max Mustermann', 'max@example.com', 'Aktiv'],
        ['Erika Musterfrau', 'erika@example.com', 'Inaktiv']
    ],
    'striped' => true,
    'hover' => true
]);
```

### 21. MForm mit BS5-Styling

```php
$mform = new MForm();
$mform->addBS5InputField('Name', 'REX_INPUT_VALUE[1]');
$mform->addBS5InputField('Email', 'REX_INPUT_VALUE[2]');
$mform->addBS5TextareaField('Nachricht', 'REX_INPUT_VALUE[3]');
echo $mform->show();
```

### 22. MForm Select mit BS5

```php
$mform = new MForm();
$mform->addBS5SelectField('Kategorie', 'REX_INPUT_VALUE[1]', [
    '1' => 'News',
    '2' => 'Events',
    '3' => 'Blog'
]);
echo $mform->show();
```

### 23. MForm Switch-Field

```php
$mform = new MForm();
$mform->addBS5SwitchField('Newsletter abonnieren', 'REX_INPUT_VALUE[1]', 1);
echo $mform->show();
```

### 24. MBlock mit Card-Layout

```php
$id = 1;
$mblock = new MBlock();
$mblock->setFormBlockId($id);

$mform = new MForm();
$mform->addBS5InputField('Titel', 'REX_INPUT_VALUE[' . $id . '][0][title]');
$mform->addBS5TextareaField('Text', 'REX_INPUT_VALUE[' . $id . '][0][text]');
$mform->addMediaField(1, 'REX_INPUT_VALUE[' . $id . '][0][image]');

echo $mblock->show();

// OUTPUT
foreach (rex_var::toArray('REX_VALUE[' . $id . ']') as $item) {
    echo BS5\Helper::getCard($item['title'], $item['text']);
}
```

### 25. Icon-Helper

```php
echo BS5\Helper::getIcon('bi-heart-fill', 'text-danger fs-3');
```

### 26. List-Group mit Links

```php
$fragment = new BS5\Fragment();
echo $fragment->parse('bs5/components/list-group', [
    'items' => [
        ['text' => 'Dashboard', 'url' => '/dashboard', 'active' => true],
        ['text' => 'Profil', 'url' => '/profile'],
        ['text' => 'Einstellungen', 'url' => '/settings']
    ]
]);
```

### 27. Navbar mit Dropdown

```php
$fragment = new BS5\Fragment();
echo $fragment->parse('bs5/components/navbar', [
    'brand' => 'MeineLogo',
    'brand_url' => '/',
    'items' => [
        ['label' => 'Home', 'url' => '/'],
        ['label' => 'Über uns', 'url' => '/about'],
        [
            'label' => 'Produkte',
            'dropdown' => [
                ['label' => 'Produkt 1', 'url' => '/produkt-1'],
                ['label' => 'Produkt 2', 'url' => '/produkt-2']
            ]
        ]
    ]
]);
```

### 28. Spinner (Loading)

```php
echo BS5\Helper::getSpinner('border', 'primary', 'Lädt...');
```

### 29. Custom Fragment erstellen

```php
// fragments/custom/my-component.php
<div class="my-component <?= $this->class ?>">
    <h3><?= $this->title ?></h3>
    <p><?= $this->content ?></p>
</div>

// Verwendung
$fragment = new BS5\Fragment();
echo $fragment->parse('custom/my-component', [
    'title' => 'Meine Komponente',
    'content' => 'Inhalt hier',
    'class' => 'bg-light p-4'
]);
```

### 30. YForm-Template mit BS5

```php
// YForm-Formular mit BS5-Styling
$yform = new rex_yform();
$yform->setObjectparams('form_skin', 'bs5');
$yform->setValueField('text', ['name', 'Name']);
$yform->setValueField('email', ['email', 'E-Mail']);
$yform->setValueField('textarea', ['message', 'Nachricht']);
$yform->setActionField('db', ['rex_contact']);
echo $yform->getForm();
```

---

## Assets-Integration

### SCSS-Struktur

```
assets/styles/
├── bootstrap/
│   ├── bootstrap.scss       # Bootstrap-Import
│   ├── _custom-variables.scss  # Variable-Overrides
│   └── _custom-styles.scss     # Custom Styles
├── components/
│   ├── _buttons.scss
│   ├── _cards.scss
│   ├── _forms.scss
│   └── _navigation.scss
└── style.scss              # Haupt-SCSS
```

### JavaScript-Module

```
assets/scripts/
├── components/
│   ├── carousel.js
│   ├── modal.js
│   ├── offcanvas.js
│   └── tooltip.js
└── app.js                  # Haupt-JS mit Bootstrap-Import
```

---

## Template-Setup

### Basis-Template

```php
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?= rex_escape($this->getValue('seo_title')) ?></title>
    
    <!-- Bootstrap CSS -->
    <link href="<?= rex_url::base('assets/addons/plus_bs5/dist/style.css') ?>" rel="stylesheet">
</head>
<body>
    <!-- Navbar -->
    <?php 
    $fragment = new BS5\Fragment();
    echo $fragment->parse('bs5/components/navbar', [
        'brand' => 'Logo',
        'items' => [] // Navigation aus rex_navigation
    ]); 
    ?>
    
    <!-- Content -->
    <main>
        <?= $this->getArticle() ?>
    </main>
    
    <!-- Footer -->
    <footer class="bg-dark text-white py-4">
        <div class="container">
            <p>&copy; <?= date('Y') ?> Meine Website</p>
        </div>
    </footer>
    
    <!-- Bootstrap JS -->
    <script src="<?= rex_url::base('assets/addons/plus_bs5/dist/app.js') ?>"></script>
</body>
</html>
```

---

## Konfiguration

### Custom Variables überschreiben

```scss
// assets/styles/bootstrap/_custom-variables.scss
$primary: #0066cc;
$secondary: #6c757d;
$success: #28a745;

$font-family-base: 'Open Sans', sans-serif;
$font-size-base: 1rem;
$line-height-base: 1.6;

$border-radius: 0.375rem;
$box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
```

### Custom Styles hinzufügen

```scss
// assets/styles/bootstrap/_custom-styles.scss
.btn-custom {
    background: linear-gradient(45deg, $primary, $secondary);
    border: none;
    color: white;
}

.card-hover {
    transition: transform 0.3s ease;
    &:hover {
        transform: translateY(-5px);
    }
}
```

---

## Module-Installation

Module werden automatisch beim Addon-Setup installiert:

1. **Backend → Plus BS5 → Module installieren**
2. Wähle gewünschte Module aus
3. Module werden in REDAXO-Modulverwaltung erstellt
4. Module in Vorlagen zuweisen

---

## Best Practices

### Fragment-Verwendung

```php
// Gut: Variablen übergeben
$fragment->parse('bs5/components/alert', [
    'type' => 'success',
    'message' => $message
]);

// Schlecht: HTML direkt
echo '<div class="alert alert-success">' . $message . '</div>';
```

### Responsive Images

```php
// Mit Media Manager
$media = rex_media::get('bild.jpg');
$img = '<img src="' . rex_url::media('bild.jpg') . '" 
            srcset="' . rex_media_manager::getUrl('medium', 'bild.jpg') . ' 768w,
                    ' . rex_media_manager::getUrl('large', 'bild.jpg') . ' 1200w"
            class="img-fluid" alt="Beschreibung">';
```

### Grid-System nutzen

```php
<div class="container">
    <div class="row">
        <div class="col-12 col-md-6 col-lg-4">
            <!-- Content -->
        </div>
    </div>
</div>
```

---

## Hinweise

⚠️ **Bootstrap 5 erforderlich** - Nicht kompatibel mit Bootstrap 4 oder älter

⚠️ **Asset-Kompilierung** - SCSS/JS müssen kompiliert werden (Webpack/Gulp)

⚠️ **Browser-Kompatibilität** - Bootstrap 5 unterstützt nur moderne Browser

⚠️ **jQuery nicht erforderlich** - Bootstrap 5 nutzt Vanilla JavaScript

---

## Verwandte Addons

- [MForm](mform.md) - Formular-Builder für Module
- [MBlock](mblock.md) - Wiederholbare Inhaltsblöcke
- [YForm](yform.md) - Formular-Framework
- [Redactor](redactor.md) - WYSIWYG-Editor

---

**GitHub:** <https://github.com/alexplusde/plus_bs5>
