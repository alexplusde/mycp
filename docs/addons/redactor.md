# Redactor - WYSIWYG-Editor

**Keywords:** Redactor, WYSIWYG, Editor, Profile, Plugins, jQuery, Vanilla JS, Frontend, Backend

## Übersicht

Redactor integriert den WYSIWYG-Editor "Redactor 3" in REDAXO für Frontend und Backend mit Profil-Verwaltung, Plugins und Custom-Settings.

## Kern-Klassen

| Klasse | Beschreibung |
|--------|-------------|
| `Redactor` | Profile/Plugin-Verwaltung, Cache-Generierung |

## Profile-System

### Profil-Eigenschaften

| Eigenschaft | Typ | Beschreibung |
|-------------|-----|-------------|
| `name` | string | Profilname (wird zu CSS-Klasse) |
| `description` | string | Beschreibung |
| `min_height` | int | Minimale Editor-Höhe (px) |
| `max_height` | int | Maximale Editor-Höhe (px) |
| `plugin_counter` | bool | Zeichenzähler aktivieren |
| `plugin_limiter` | int | Zeichenlimit (0 = unbegrenzt) |
| `plugins` | string | Komma-separierte Plugin-Liste |
| `settings` | text | Custom Redactor-Optionen |

### Standard-Plugins

| Plugin | Beschreibung |
|--------|-------------|
| `html` | HTML-Quellcode-Ansicht |
| `format` | Text-Formate (h1-h6, p, blockquote) |
| `bold, italic` | Fett/Kursiv |
| `ul, ol` | Listen |
| `indent, outdent` | Einrückung |
| `alignment` | Text-Ausrichtung |
| `linkInternal` | Interne Links (REDAXO Linkmap) |
| `linkExternal` | Externe Links |
| `image` | Bilder (REDAXO Medienpool) |
| `table` | Tabellen |
| `hr` | Horizontale Linie |
| `quote` | Zitat-Dialog |
| `clip` | Textbausteine |
| `style` | Inline-Formate (mark, code, var, kbd, sup, sub) |
| `undo, redo` | Rückgängig/Wiederholen |

## Praxisbeispiele

### 1. Editor im Backend-Modul

```html
<textarea class="form-control redactor-editor--full" name="REX_INPUT_VALUE[1]">
REX_VALUE[1]
</textarea>
```

### 2. Ausgabe im Template

```php
REX_VALUE[id="1" output="html"]
```

### 3. Profil erstellen (Backend)

```text
Backend: Addons > Redactor > Profile
- Name: full
- Min Height: 200
- Max Height: 600
- Plugins: html,|,format,bold,italic,|,image,linkInternal
```

### 4. CSS-Selektor

```css
/* Profil "full" wird zu: */
.redactor-editor--full
```

### 5. Custom Settings (Profil-Einstellungen)

```text
pastePlainText: true
tabKey: false
buttons: ['bold', 'italic', 'link']
```

### 6. Clip-Plugin (Textbausteine)

```text
Plugins-Feld:
clip[Disclaimer=<p>Rechtliche Hinweise...</p>|Signatur=Mit freundlichen Grüßen]
```

### 7. Format-Plugin konfigurieren

```text
Plugins-Feld:
format[h2|h3|p|blockquote]
```

### 8. Style-Plugin anpassen

```text
Plugins-Feld:
style[mark|code|kbd]
```

### 9. Listen-Plugin

```text
Plugins-Feld:
lists[ul|ol|indent|outdent]
```

### 10. Profil-Selektor in YForm

```json
{"class":"form-control redactor-editor--minimal"}
```

### 11. Programmatisch Profil erstellen

```php
Redactor::insertProfile(
    'minimal',
    'Minimaler Editor',
    200,
    400,
    false, // Kein Counter
    0, // Kein Limiter
    'bold,italic,linkInternal',
    'pastePlainText: true'
);
```

### 12. Profil-Existenz prüfen

```php
if (Redactor::profileExists('full')) {
    // Profil vorhanden
}
```

### 13. Cache neu generieren

```php
Redactor::createProfileFiles();
Redactor::createPluginFile();
```

### 14. Frontend-Integration (Vanilla JS)

```html
<!-- CSS -->
<link rel="stylesheet" href="/assets/addons/redactor/vendor/redactor/redactor.css">
<link rel="stylesheet" href="/assets/addons/redactor/redactor.css">

<!-- JavaScript -->
<script src="/assets/addons/redactor/vendor/redactor/redactor.js"></script>
<script src="/assets/addons/redactor/vendor/redactor/langs/de.js"></script>
<script src="/assets/addons/redactor/cache/plugins.vanilla.de_de.js"></script>
<script src="/assets/addons/redactor/cache/profiles.js"></script>
<script src="/assets/addons/redactor/redactor.vanilla.js"></script>
```

### 15. Textarea im Frontend

```html
<textarea class="redactor-editor--default">
Initialer Text...
</textarea>
```

### 16. linkYForm-Plugin (Custom)

```text
Plugins-Feld:
linkYForm[rex_neues_entry=name|rex_event_date=name|rex_staff=name]
```

### 17. OUTPUT_FILTER für linkYForm

```php
rex_extension::register('OUTPUT_FILTER', function($ep) {
    return preg_replace_callback(
        '@rex-yf-(news|person)://(\d+)@i',
        function ($matches) {
            $object = News::get($matches[2]);
            return $object ? $object->getUrl() : '';
        },
        $ep->getSubject()
    );
});
```

### 18. Table-Plugin aktivieren

```text
Plugins-Feld:
table
```

### 19. Widget-Plugin

```text
Plugins-Feld:
widget
```

### 20. Zeichenzähler

```text
Backend Profil-Einstellung:
✓ Plugin Counter aktivieren
```

### 21. Zeichenlimit

```text
Backend Profil-Einstellung:
Plugin Limiter: 500
```

### 22. Plugin-Separatoren

```text
Plugins-Feld:
bold,italic,|,linkInternal,linkExternal,|,image
```

### 23. Custom Toolbar-Reihenfolge

```text
Settings-Feld:
buttons: ['format', 'bold', 'italic', 'link', 'image']
```

### 24. Paste Plain Text

```text
Settings-Feld:
pastePlainText: true
```

### 25. Extension Point REDACTOR_PLUGIN_DIRS

```php
rex_extension::register('REDACTOR_PLUGIN_DIRS', function($ep) {
    $dirs = $ep->getSubject();
    $dirs['custom'] = rex_path::addon('project', 'assets/redactor/plugins/');
    return $dirs;
});
```

> **Integration:** Redactor arbeitet mit **jQuery** (Backend), **Vanilla JS** (Frontend), **Media Manager** (Bildauswahl), **Structure** (Linkmap), **YForm** (Formular-Editor), **Sprog** (Wildcard-Ersetzung in Clips), **URL-Addon** (YForm-Link-URLs) und **rex:ready** Events (Backend-Initialisierung). Profile werden gecacht in `/cache/profiles.js` und Plugins in `/cache/plugins.{locale}.js`.
