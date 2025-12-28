# rex_view

**Backend-UI-Komponenten (Messages, Content-Sections, Titel, Navigation)**

**Keywords:** backend, ui, message, alert, content, title, clang-switch

---

## Methodenübersicht

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `info()` | `string $message`, `string $cssClass = ''` | `string` | Info-Meldung (blau) |
| `success()` | `string $message`, `string $cssClass = ''` | `string` | Erfolgs-Meldung (grün) |
| `warning()` | `string $message`, `string $cssClass = ''` | `string` | Warnung (gelb) |
| `error()` | `string $message`, `string $cssClass = ''` | `string` | Fehler (rot) |
| `content()` | `string $content`, `string $title = ''` | `string` | Content-Section mit optionalem Titel |
| `title()` | `string $head`, `string\|array\|null $subtitle = null` | `string` | Seiten-Titel mit Subnavigation |
| `addCssFile()` | `string $file`, `string $media = 'all'` | `void` | CSS-Datei hinzufügen |
| `addJsFile()` | `string $file`, `array $options = []` | `void` | JS-Datei hinzufügen |
| `setJsProperty()` | `string $key`, `mixed $value` | `void` | JS-Property (global verfügbar) |
| `setFavicon()` | `string $file` | `void` | Favicon setzen |
| `clangSwitch()` | `rex_context $context`, `bool $asDropDown = true` | `string` | Sprach-Umschalter |
| `toolbar()` | `string $content`, `string\|null $brand = null`, `string\|null $cssClass = null`, `bool $inverse = false` | `string` | Toolbar erstellen |

**JS-Options:**

- `rex_view::JS_DEFERED` = `'defer'`
- `rex_view::JS_ASYNC` = `'async'`
- `rex_view::JS_IMMUTABLE` = `'immutable'`

---

## Praxisbeispiele

### Messages (Alerts)

```php
// Info-Nachricht
echo rex_view::info('Dies ist eine Info-Nachricht.');

// Erfolg
echo rex_view::success('Erfolgreich gespeichert!');

// Warnung
echo rex_view::warning('Achtung: Diese Aktion kann nicht rückgängig gemacht werden.');

// Fehler
echo rex_view::error('Fehler beim Speichern der Daten.');

// Mit Custom-CSS-Klasse
echo rex_view::success('Gespeichert!', 'my-custom-class');
```

### Messages mit HTML-Content

```php
// Mehrzeilig
$message = '
<strong>Erfolgreich!</strong><br>
Die Daten wurden gespeichert.<br>
<a href="...">Zurück zur Übersicht</a>
';
echo rex_view::success($message);

// Liste von Fehlern
$errors = ['Feld 1 ist erforderlich', 'Feld 2 ist ungültig'];
echo rex_view::error('<ul><li>' . implode('</li><li>', $errors) . '</li></ul>');
```

### Content-Sections

```php
// Einfache Content-Section
$content = '<p>Lorem ipsum dolor sit amet...</p>';
echo rex_view::content($content, 'Überschrift');

// Formular in Section
$form = '<form>...</form>';
echo rex_view::content($form, 'Einstellungen');

// Section ohne Titel
$content = '<div>...</div>';
echo rex_view::content($content);
```

### Seiten-Titel mit Subnavigation

```php
// Einfacher Titel
echo rex_view::title('Mein Addon');

// Titel mit eigener Subnavigation (automatisch aus Backend-Pages)
echo rex_view::title('Mein Addon', null);

// Titel mit Custom-Subtitle (String)
echo rex_view::title('Mein Addon', '<small>Version 1.0.0</small>');

// Mit rex_be_page Array für Subnavigation
$pages = [
    rex_be_controller::getPageObject('myaddon/overview'),
    rex_be_controller::getPageObject('myaddon/settings')
];
echo rex_view::title('Mein Addon', $pages);
```

### CSS/JS-Files hinzufügen

```php
// CSS hinzufügen
rex_view::addCssFile($this->getAssetsUrl('styles.css'));
rex_view::addCssFile($this->getAssetsUrl('print.css'), 'print');

// JS hinzufügen
rex_view::addJsFile($this->getAssetsUrl('script.js'));

// Mit defer/async
rex_view::addJsFile($this->getAssetsUrl('script.js'), [
    rex_view::JS_DEFERED => true
]);

rex_view::addJsFile($this->getAssetsUrl('script.js'), [
    rex_view::JS_ASYNC => true,
    rex_view::JS_IMMUTABLE => true
]);
```

### JS-Properties (für Frontend-Zugriff)

```php
// JS-Daten verfügbar machen
rex_view::setJsProperty('apiUrl', '/api/endpoint');
rex_view::setJsProperty('userId', rex::getUser()->getId());
rex_view::setJsProperty('config', [
    'debug' => rex::isDebugMode(),
    'lang' => rex_i18n::getLocale()
]);

// Im JavaScript zugreifen:
// rex.apiUrl
// rex.userId
// rex.config.debug
```

### Clang-Switch (Sprach-Umschalter)

```php
// Als Tabs (Standard)
$context = new rex_context([
    'page' => 'content/edit',
    'article_id' => $articleId,
    'clang' => rex_clang::getCurrentId()
]);
echo rex_view::clangSwitch($context);

// Als Dropdown (bei 4+ Sprachen automatisch)
echo rex_view::clangSwitch($context, true);

// Als Buttons
echo rex_view::clangSwitchAsButtons($context, false);
```

### Komplette Backend-Page

```php
// pages/index.php
$addon = rex_addon::get('myaddon');

// Titel
echo rex_view::title($addon->i18n('title'));

// Erfolgs-Nachricht
if (rex_get('msg', 'string') === 'saved') {
    echo rex_view::success($addon->i18n('saved'));
}

// Fehler-Nachricht
if ($error = rex_get('error', 'string')) {
    echo rex_view::error($error);
}

// Content
$content = '
<div class="panel panel-default">
    <div class="panel-body">
        <p>Content hier...</p>
    </div>
</div>
';

echo rex_view::content($content, 'Überschrift');
```

### Toolbar

```php
// Toolbar mit Brand
$buttons = '
<a href="..." class="btn btn-primary">Button 1</a>
<a href="..." class="btn btn-default">Button 2</a>
';
echo rex_view::toolbar($buttons, 'Meine Toolbar');

// Inverse Toolbar (dunkler Hintergrund)
echo rex_view::toolbar($buttons, null, 'my-toolbar', true);
```

### Messages nach Form-Submit

```php
$func = rex_request('func', 'string');

if ($func === 'save' && rex_request::isPOSTRequest()) {
    // Speichern...
    if ($success) {
        // Redirect mit Message-Parameter
        rex_response::sendRedirect(rex_url::currentBackendPage([
            'msg' => 'saved'
        ]));
    } else {
        echo rex_view::error('Fehler beim Speichern.');
    }
}

// Message aus URL-Parameter anzeigen
if (rex_get('msg', 'string') === 'saved') {
    echo rex_view::success('Erfolgreich gespeichert!');
}
```

### Fragment-Integration

```php
// rex_view::content() nutzt intern rex_fragment
// Äquivalent:
$fragment = new rex_fragment();
$fragment->setVar('title', 'Überschrift');
$fragment->setVar('body', '<p>Content</p>', false);
echo $fragment->parse('core/page/section.php');

// Oder einfacher:
echo rex_view::content('<p>Content</p>', 'Überschrift');
```

### Custom-CSS für Messages

```php
// Sticky Message (bleibt oben)
echo rex_view::info('Wichtiger Hinweis', 'sticky-message');

// Custom Alert-Style
echo rex_view::warning('Warnung', 'alert-dismissible');

// CSS in eigenem Addon definieren:
// .sticky-message { position: sticky; top: 0; z-index: 1000; }
```

### Conditional Messages

```php
// Nur für Admins
if (rex::getUser()->isAdmin()) {
    echo rex_view::warning('Admin-Modus aktiv!');
}

// Debug-Modus
if (rex::isDebugMode()) {
    echo rex_view::info('Debug-Modus ist aktiviert.');
}

// Permission-Check
if (!rex::getUser()->hasPerm('myaddon[]')) {
    echo rex_view::error('Keine Berechtigung für diese Aktion.');
}
```

### rex_list/rex_form Integration

```php
// rex_list mit Messages
$list = rex_list::factory('SELECT * FROM rex_user');

// Erfolgs-Nachricht aus rex_list
if ($msg = $list->getMessage()) {
    echo rex_view::success($msg);
}

// Warnung aus rex_list
if ($warning = $list->getWarning()) {
    echo rex_view::warning($warning);
}

$list->show();
```

### Favicon anpassen

```php
// In boot.php eines Addons
if (rex::isBackend()) {
    rex_view::setFavicon($this->getAssetsUrl('favicon.ico'));
}
```

### Mehrsprachige Messages

```php
// Mit i18n
echo rex_view::success(rex_i18n::msg('myaddon_save_success'));
echo rex_view::error(rex_i18n::msg('myaddon_save_error'));

// Mit Platzhaltern
echo rex_view::info(rex_i18n::msg('myaddon_items_found', $count));
```

### Extension Point für Messages

```php
// Message via Extension Point ändern
rex_extension::register('PAGE_TITLE_SHOWN', function($ep) {
    if (rex::isDebugMode()) {
        return rex_view::warning('Debug-Modus aktiv!');
    }
});
```

---

**Best Practices:**

- ✅ `rex_view::content()` für strukturierte Sections
- ✅ `rex_view::title()` für konsistente Page-Header
- ✅ Messages nach Redirects via URL-Parameter (`?msg=saved`)
- ✅ `addCssFile()` / `addJsFile()` in `boot.php` (Backend-Check!)
- ✅ `setJsProperty()` für Config-Übergabe an Frontend
- ⚠️ Messages sind **nicht escaped** → `rex_escape()` bei User-Input!
- ⚠️ CSS/JS nur bei `rex::isBackend()` hinzufügen
- ⚠️ Clang-Switch nur bei `rex_clang::count() > 1` anzeigen

**HTML-Struktur:**

```php
// rex_view::info() generiert:
<div class="alert alert-info">Message</div>

// rex_view::success() generiert:
<div class="alert alert-success">Message</div>

// rex_view::warning() generiert:
<div class="alert alert-warning">Message</div>

// rex_view::error() generiert:
<div class="alert alert-danger">Message</div>
```
