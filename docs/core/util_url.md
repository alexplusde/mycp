# rex_url

Keywords: URL-Generierung, Backend-Links, Frontend-Links, Assets, Media, Backendcontroller, Frontendcontroller

## Übersicht

`rex_url` generiert relative URLs für Frontend, Backend, Controller, Media, Assets. Nutzt rex_path_default_provider für flexible Pfade. Unterstützt Query-Parameter mit Escaping für HTML-Kontext (`&amp;`).

## Methoden

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `base($file)` | `string` | `string` | Basis-URL (Root) + optionale Datei |
| `frontend($file)` | `string` | `string` | URL zum Frontend-Ordner |
| `frontendController($params, $escape)` | `array`, `bool` | `string` | URL zu `index.php` (Frontend) mit Parametern |
| `backend($file)` | `string` | `string` | URL zum Backend-Ordner (`redaxo/`) |
| `backendController($params, $escape)` | `array`, `bool` | `string` | URL zu `redaxo/index.php` mit Parametern |
| `backendPage($page, $params, $escape)` | `string`, `array`, `bool` | `string` | URL zu Backend-Page mit `?page=...` |
| `currentBackendPage($params, $escape)` | `array`, `bool` | `string` | URL zur aktuellen Backend-Page |
| `media($file)` | `string` | `string` | URL zu `media/` + Dateiname |
| `assets($file)` | `string` | `string` | URL zu `assets/` + Datei |
| `coreAssets($file)` | `string` | `string` | URL zu Core-Assets (`assets/core/`) |
| `addonAssets($addon, $file)` | `string`, `string` | `string` | URL zu Addon-Assets (`assets/addons/{addon}/`) |
| `pluginAssets($addon, $plugin, $file)` | `string`, `string`, `string` | `string` | URL zu Plugin-Assets (`assets/addons/{addon}/plugins/{plugin}/`) |

## Praxisbeispiele

### Backend-URLs generieren

```php
// URL zu Backend-Startseite
$url = rex_url::backend(); // "/redaxo/"

// URL zu Backend-Controller
$url = rex_url::backendController(); // "/redaxo/index.php"

// Mit Parametern
$url = rex_url::backendController(['page' => 'system/settings'], false);
// "/redaxo/index.php?page=system/settings"
```

### Backend-Pages verlinken

```php
// URL zu spezifischer Backend-Page
$url = rex_url::backendPage('content/edit', ['article_id' => 1, 'clang' => 1]);
// "/redaxo/index.php?page=content/edit&article_id=1&clang=1"

// Escaped für HTML-Attribute (Standard)
$url = rex_url::backendPage('yform/manager/data_edit', ['table_name' => 'users'], true);
// "/redaxo/index.php?page=yform/manager/data_edit&amp;table_name=users"
```

### Aktuelle Backend-Page mit zusätzlichen Parametern

```php
// URL zur aktuellen Seite + neue Parameter
$url = rex_url::currentBackendPage(['func' => 'edit', 'id' => 42]);
// Wenn auf "myaddon/main": "/redaxo/index.php?page=myaddon/main&func=edit&id=42"

// In rex_list für Edit-Links
$list = rex_list::factory('SELECT * FROM table');
$list->addColumn('edit', 'Edit', 0, [
    '<a href="' . rex_url::currentBackendPage(['func' => 'edit', 'id' => '###id###']) . '">Bearbeiten</a>'
]);
```

### Frontend-URLs

```php
// Frontend Root
$url = rex_url::frontend(); // "/"

// Frontend Controller
$url = rex_url::frontendController(['article_id' => 1, 'clang' => 1]);
// "/index.php?article_id=1&clang=1"

// Ohne Escaping für Redirects
$redirect = rex_url::frontendController(['article_id' => 5], false);
rex_response::sendRedirect($redirect);
```

### Media-Dateien verlinken

```php
// Bild aus media/
$imageUrl = rex_url::media('logo.png'); // "/media/logo.png"

// In Templates
echo '<img src="' . rex_url::media($filename) . '" alt="Image">';

// Dynamische Media-Ausgabe
if (rex_media::get($filename)) {
    echo '<a href="' . rex_url::media($filename) . '">Download</a>';
}
```

### Assets verlinken

```php
// Core-Assets (jQuery, Bootstrap etc.)
$jqueryUrl = rex_url::coreAssets('jquery.min.js');
// "/assets/core/jquery.min.js"

// Addon-Assets
$cssUrl = rex_url::addonAssets('myaddon', 'styles.css');
// "/assets/addons/myaddon/styles.css"

$jsUrl = rex_url::addonAssets('myaddon', 'script.js');
// "/assets/addons/myaddon/script.js"
```

### Plugin-Assets

```php
// Plugin von Addon
$pluginCss = rex_url::pluginAssets('yform', 'manager', 'styles.css');
// "/assets/addons/yform/plugins/manager/styles.css"

// In Backend-Pages
rex_view::addCssFile(rex_url::pluginAssets('myaddon', 'backend', 'backend.css'));
rex_view::addJsFile(rex_url::pluginAssets('myaddon', 'backend', 'backend.js'));
```

### YForm Formular-Action

```php
// YForm Custom-Form mit Backend-Action
$yform = new rex_yform();
$yform->setObjectparams('form_action', 
    rex_url::backendController([
        'page' => 'content/edit',
        'article_id' => $article_id,
        'clang' => $clang,
    ], false)
);
```

### yrewrite_metainfo Links

```php
// Link zu Backend-Page mit Parametern
$params = ['domain_id' => $domainId, 'func' => 'edit'];
$editUrl = rex_url::backendPage('yrewrite/metainfo/domain', $params);

return '<a href="' . $editUrl . '">' . rex_i18n::msg('yrewrite_metainfo_edit') . '</a>';
```

### ycom Auth Backend-Session-Link

```php
// Backend-Link mit User-ID Parameter
$sessionUrl = rex_url::backendController([
    'page' => 'ycom/auth/sessions',
    'user_id' => $userId,
    'func' => 'create_session',
]);
```

### Redirect nach Speichern

```php
// In Backend-Page nach Form-Submit
if ($form->isSubmitted() && $form->validate()) {
    $form->save();
    
    $params = ['func' => '', 'msg' => 'saved'];
    rex_response::sendRedirect(rex_url::currentBackendPage($params, false));
}
```

### Google Places Review Redirect

```php
$params = ['func' => '', 'synced' => 1];
rex_response::sendRedirect(
    rex_url::backendPage('googleplaces/review', $params, false)
);
```

### YForm Manager Table-Field Redirect

```php
rex_response::sendRedirect(
    rex_url::backendController([
        'page' => 'yform/manager/table_field',
        'table_name' => 'rex_yrewrite_metainfo',
    ], false)
);
```

### rex_list Pagination

```php
$list = rex_list::factory('SELECT * FROM table');

// Interne Verwendung für Pagination
// rex_url::backendController() oder frontendController() je nach Kontext
$paginationUrl = rex::isBackend() 
    ? rex_url::backendController($params, $escape) 
    : rex_url::frontendController($params, $escape);
```

### Backend-Hilfe-Link

```php
$helpUrl = rex_url::backendPage('packages', [
    'subpage' => 'help',
    'package' => 'yform_usability',
]);

echo '<a href="' . $helpUrl . '" title="' . rex_i18n::msg('help') . '">
    <i class="rex-icon rex-icon-help"></i>
</a>';
```

### Assets in Backend-Views laden

```php
// In Backend-Page (pages/main.php)
rex_view::addCssFile(rex_url::addonAssets('myaddon', 'backend.css'));
rex_view::addJsFile(rex_url::addonAssets('myaddon', 'backend.js'));

// Core-Assets
rex_view::addJsFile(rex_url::coreAssets('vendor/jquery/jquery.min.js'));
```

### Basis-URL für absolute Pfade

```php
// Root-URL
$baseUrl = rex_url::base(); // "https://example.com/"

// Datei im Root
$robotsUrl = rex_url::base('robots.txt'); // "/robots.txt"

// Für OpenGraph/Canonical in Templates
echo '<link rel="canonical" href="' . rex_url::base() . $article->getUrl() . '">';
```

### Frontend-Asset-Links in Templates

```php
// CSS-Dateien
echo '<link rel="stylesheet" href="' . rex_url::addonAssets('myaddon', 'frontend.css') . '">';

// JavaScript
echo '<script src="' . rex_url::addonAssets('myaddon', 'frontend.js').'"></script>';

// Bilder
echo '<img src="' . rex_url::addonAssets('myaddon', 'logo.svg') . '">';
```

### Conditional Backend/Frontend URLs

```php
// Je nach Kontext unterschiedliche URLs
if (rex::isBackend()) {
    $url = rex_url::backendController(['page' => 'myaddon/settings']);
} else {
    $url = rex_url::frontendController(['article_id' => 1]);
}
```

### Download-Link zu Media-Datei

```php
// Direkter Media-Download
$filename = 'document.pdf';
$downloadUrl = rex_url::media($filename);

echo '<a href="' . $downloadUrl . '" download>' . $filename . '</a>';

// Media Manager Resize
$resizedUrl = rex_url::media('mymedia.jpg') . '?rex_media_type=thumbnail';
```

### Backend-Navigation mit URLs

```php
$nav = rex_be_navigation::factory();

$page = new rex_be_page('myaddon/main', 'My Addon');
$page->setSubPath(rex_path::addon('myaddon', 'pages/main.php'));
$page->setHref(rex_url::backendPage('myaddon/main'));
$nav->addPage($page);

// Externe URL
$externalPage = new rex_be_page('external', 'Dokumentation');
$externalPage->setHref('https://example.com/docs');
$externalPage->setIsCorePage(false);
$nav->addPage($externalPage);
```

### Ajax-Request URLs im Backend

```php
// JavaScript: Ajax zu Backend-Controller
<script>
$.ajax({
    url: '<?= rex_url::backendController(['page' => 'myaddon/ajax', 'action' => 'getData'], false) ?>',
    success: function(data) {
        console.log(data);
    }
});
</script>
```

### Escaping für verschiedene Kontexte

```php
// HTML-Attribut (escaped mit &amp;)
$htmlUrl = rex_url::backendPage('page', ['id' => 1], true);
echo '<a href="' . $htmlUrl . '">Link</a>';

// Redirect/JavaScript (unescaped mit &)
$rawUrl = rex_url::backendPage('page', ['id' => 1], false);
rex_response::sendRedirect($rawUrl);
```

### Favicon/Manifest URLs

```php
// yrewrite_metainfo Icon-URLs
$faviconUrl = rex_url::media() . $icon->getValue('shortcut_icon');
$appleTouchUrl = rex_url::media() . $icon->getValue('apple_touch_icon');
$manifestUrl = rex_url::media() . $icon->getValue('manifest');

echo '<link rel="icon" href="' . $faviconUrl . '">';
echo '<link rel="apple-touch-icon" href="' . $appleTouchUrl . '">';
```
