# Tracks - Module & Template Helper

**Keywords:** Tracks, Module, Templates, Sync, Installation, Backup, Config, Helper

## Übersicht

Tracks ist ein Helper-Addon zur Installation und Synchronisation von Modulen/Templates sowie für programmatisches Erstellen von Struktur/Content/Media.

## Kern-Klassen

| Klasse | Beschreibung |
|--------|-------------|
| `Tracks` | Modul/Template-Sync, Config-Export/Import, Backup |
| `Structure` | Kategorie/Artikel programmatisch erstellen |
| `Content` | Slices/Module-IDs verwalten |
| `Media` | Medien programmatisch hinzufügen |
| `Editor` | WYSIWYG-Editor-Profil ermitteln |

## Klasse: Tracks

### Wichtige Methoden

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|-------------|
| `::updateModule($addon)` | `string` | `void` | Importiert Module aus /install/module/ |
| `::writeModule($addon, $query)` | `string, string` | `void` | Exportiert Module in /install/module/ |
| `::updateTemplate($addon)` | `string` | `void` | Importiert Templates aus /install/template/ |
| `::writeTemplate($addon, $query)` | `string, string` | `void` | Exportiert Templates in /install/template/ |
| `::updateConfig($addon)` | `string` | `void` | Importiert rex_config aus JSON |
| `::writeConfig($addon)` | `string` | `void` | Exportiert rex_config in JSON |
| `::forceBackup($prefix, $type, $filename, $tables)` | `string, string, string, array` | `bool` | Erstellt Backup mit Timestamp |
| `::packageExists($packages)` | `array` | `bool` | Prüft Addon-Verfügbarkeit |

## Klasse: Structure

### Wichtige Methoden

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|-------------|
| `::addChildCategory($category_id, $name, $priority, $template_id, $clang_id, $additionalFields)` | `int, string, int, int, int, array` | `int` | Erstellt Unterkategorie |
| `::addChildArticle($category_id, $name, $priority, $template_id, $clang_id, $additionalFields)` | `int, string, int, int, int, array` | `int` | Erstellt Artikel |
| `::getSiteStartArticleId()` | - | `int` | Liefert Startartikel-ID |
| `::getSiteStartCategory()` | - | `?rex_category` | Liefert Startartikel-Kategorie |

## Klasse: Content

### Wichtige Methoden

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|-------------|
| `::getModuleIdByKey($key)` | `string` | `?int` | Modul-ID anhand Key |
| `::addSlice($article_id, $clang_ids, $module_id, $ctype_id, $values, $media, $medialist, $links, $linklist, $params)` | `int, array\|int, int, int, array, array, array, array, array, array` | `array` | Erstellt Slice in Artikel(n) |

## Klasse: Media

### Wichtige Methoden

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|-------------|
| `::addImage($filename, $path, $title, $category_id)` | `string, string, string, int` | `bool` | Fügt Bild zum Medienpool hinzu |

## Klasse: Editor

### Wichtige Methoden

| Methode | Rückgabe | Beschreibung |
|---------|----------|-------------|
| `::getFirstEditorProfile()` | `string` | Erster verfügbarer Editor (Redactor/TinyMCE/CKE5/Markitup) |
| `::getFirstRedactorProfile()` | `bool\|string` | Class-String für Redactor |
| `::getFirstTinyMceProfile()` | `bool\|string` | Class-String für TinyMCE |
| `::getFirstCke5Profile()` | `bool\|string` | Class-String für CKE5 |

## Praxisbeispiele

### 1. Module beim Install importieren

```php
// install.php
use Alexplusde\Tracks\Tracks;

if (rex_addon::exists('tracks')) {
    Tracks::forceBackup('meinaddon');
    Tracks::updateModule('meinaddon');
    Tracks::updateTemplate('meinaddon');
}
rex_delete_cache();
```

### 2. Module während Entwicklung exportieren

```php
// boot.php
use Alexplusde\Tracks\Tracks;

if (rex::isBackend() && rex::isDebugMode() && rex_config::get('meinaddon', 'dev')) {
    Tracks::writeModule('meinaddon', 'meinprefix.%');
    Tracks::writeTemplate('meinaddon', 'meinprefix.%');
}
```

### 3. Emoji-Alias verwenden

```php
use Alexplusde\Tracks\🦖;

if (rex_addon::exists('tracks')) {
    🦖::updateModule('meinaddon');
    🦖::updateTemplate('meinaddon');
}
```

### 4. Config synchronisieren

```php
// boot.php - Export während Entwicklung
if (rex::isBackend() && rex::isDebugMode()) {
    Tracks::writeConfig('meinaddon');
}

// install.php - Import bei Installation
Tracks::updateConfig('meinaddon');
```

### 5. Kategorie erstellen

```php
use Alexplusde\Tracks\Structure;

$catId = Structure::addChildCategory(
    0, // Parent-ID (0 = Root)
    'Hauptkategorie',
    10, // Priorität
    1, // Template-ID
    1 // Clang-ID
);
```

### 6. Kategorie mit zusätzlichen Feldern

```php
$catId = Structure::addChildCategory(
    5,
    'Unterkategorie',
    10,
    1,
    1,
    ['catname' => 'Custom Name', 'yrewrite_priority' => '0.8']
);
```

### 7. Artikel erstellen

```php
use Alexplusde\Tracks\Structure;

$articleId = Structure::addChildArticle(
    5, // Kategorie-ID
    'Neuer Artikel',
    10,
    1,
    1
);
```

### 8. Startartikel ermitteln

```php
$startId = Structure::getSiteStartArticleId();
$startCat = Structure::getSiteStartCategory();
```

### 9. Modul-ID anhand Key

```php
use Alexplusde\Tracks\Content;

$moduleId = Content::getModuleIdByKey('mein-modul-key');
```

### 10. Slice erstellen (einfach)

```php
use Alexplusde\Tracks\Content;

Content::addSlice(
    42, // Artikel-ID
    1, // Clang-ID
    5, // Modul-ID
    1, // CType
    [1 => 'Überschrift', 2 => 'Text...'], // REX_VALUE[1-20]
    [1 => 'bild.jpg'], // REX_MEDIA[1-10]
    [], // REX_MEDIALIST[1-10]
    [1 => 10], // REX_LINK[1-10]
    [] // REX_LINKLIST[1-10]
);
```

### 11. Slice in mehreren Sprachen

```php
$sliceIds = Content::addSlice(
    42,
    [1, 2, 3], // Alle Sprachen
    5,
    1,
    [1 => 'Headline', 2 => 'Content']
);
// Liefert ['1' => 123, '2' => 124, '3' => 125]
```

### 12. Bild zum Medienpool hinzufügen

```php
use Alexplusde\Tracks\Media;

Media::addImage(
    'fallback.png',
    __DIR__ . '/install/fallback.png',
    'Fallback-Bild',
    0 // Kategorie-ID
);
```

### 13. Backup vor Update

```php
Tracks::forceBackup(
    'meinaddon',
    'update',
    '', // Auto-Timestamp
    ['rex_module', 'rex_template']
);
```

### 14. Package-Abhängigkeit prüfen

```php
if (Tracks::packageExists(['yform', 'yrewrite'])) {
    // Installation fortsetzen
}
```

### 15. Editor-Profil ermitteln

```php
use Alexplusde\Tracks\Editor;

$editorClass = Editor::getFirstEditorProfile();
// Liefert 'class="form-control redactor-editor--default"'
```

### 16. Spezifischen Editor prüfen

```php
if ($profile = Editor::getFirstRedactorProfile()) {
    echo '<textarea ' . $profile . '>Text</textarea>';
}
```

### 17. Module mit Prefix exportieren

```php
// Exportiert alle Module mit Key "plus_bs5.%"
Tracks::writeModule('plus_bs5', 'plus_bs5.%');
```

### 18. Template-Struktur

```php
// Erstellt Dateien:
// /install/template/mein-template.json (Metadaten)
// /install/template/mein-template.php (Template-Code)
Tracks::writeTemplate('meinaddon', 'template-prefix.%');
```

### 19. Config-Export

```php
// Exportiert alle rex_config-Werte des Addons
Tracks::writeConfig('meinaddon');
// Erstellt /install/config/config.json
```

### 20. Geschützte Felder vermeiden

```php
// Diese Felder dürfen NICHT gesetzt werden:
// pid, id, parent_id, startarticle, path, revision

try {
    Structure::addChildCategory(0, 'Test', 10, 1, 1, ['id' => 999]);
} catch (InvalidArgumentException $e) {
    // Fehler: Protected field 'id'
}
```

### 21. Emoji-Klassen verwenden

```php
use Alexplusde\Tracks\🦖; // Tracks
use Alexplusde\Tracks\📂; // Structure
use Alexplusde\Tracks\🍰; // Content

🦖::updateModule('addon');
$catId = 📂::addChildCategory(0, 'Name', 10, 1, 1);
$moduleId = 🍰::getModuleIdByKey('key');
```

### 22. Install/Update-Path ermitteln

```php
$path = Tracks::getInstallOrUpdatePath('meinaddon', 'module');
// Bei Update: /addons/.new.meinaddon/install/module/
// Sonst: /addons/meinaddon/install/module/
```

### 23. Custom Slice-Parameter

```php
Content::addSlice(
    42,
    1,
    5,
    1,
    [1 => 'Text'],
    [],
    [],
    [],
    [],
    ['custom_field' => 'value'] // Zusätzliche DB-Felder
);
```

### 24. Alle Sprachen durchlaufen

```php
foreach (rex_clang::getAll() as $clang) {
    Structure::addChildArticle(
        5,
        'Artikel ' . $clang->getName(),
        10,
        1,
        $clang->getId()
    );
}
```

### 25. Komplette Installation

```php
// install.php
use Alexplusde\Tracks\Tracks;
use Alexplusde\Tracks\Structure;
use Alexplusde\Tracks\Media;

if (rex_addon::exists('tracks')) {
    // Backup erstellen
    Tracks::forceBackup('meinaddon');
    
    // Module/Templates importieren
    Tracks::updateModule('meinaddon');
    Tracks::updateTemplate('meinaddon');
    
    // Config importieren
    Tracks::updateConfig('meinaddon');
    
    // Struktur erstellen
    $catId = Structure::addChildCategory(0, 'Addon-Kategorie', 100, 1, 1);
    
    // Fallback-Bild
    Media::addImage('fallback.jpg', __DIR__ . '/install/fallback.jpg', 'Fallback', 0);
}

rex_delete_cache();
```

> **Integration:** Tracks wird verwendet von **plus_bs5**, **events**, **school**, **blaupause**, **ycom_fast_forward** und vielen Custom-Addons für automatisierte Installation/Synchronisation. Arbeitet mit **YForm** (Table Manager), **YRewrite** (Domains), **Media Manager** (Bilder) und allen WYSIWYG-Editoren (Redactor, TinyMCE, CKE5, Markitup).
