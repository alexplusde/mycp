# rex_be_controller, rex_be_page, rex_be_navigation

Keywords: Backend, Controller, Navigation, Pages, Backend-Struktur, Main-Page, Subpage, Permissions

## Übersicht

**rex_be_controller**: Zentrale Verwaltung für Backend-Pages. Ermittelt aktuelle Page (`getCurrentPage()`), Page-Objekte (`getPageObject()`), Page-Teile (`getCurrentPagePart()`). Erstellt System-Pages (System, Packages, Profile, Credits, Log).

**rex_be_page**: Repräsentiert eine Backend-Seite mit Title, Href, Path, Subpages, Permissions, Icon, Attributes. Unterstützt Popups, Pjax, Hidden-Pages. Klasse `rex_be_page_main` für Hauptmenü-Einträge mit Block+Prio.

**rex_be_navigation**: Factory für Navigation-Rendering. Sammelt Pages nach Blocks (default, system, addons), sortiert nach Prio, generiert verschachtelte Arrays für Fragment-Rendering.

## rex_be_controller Methoden

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `setCurrentPage($page)` | `string` | `void` | Setzt aktuelle Page (z.B. `myaddon/main`) |
| `getCurrentPage()` | - | `string` | Gibt aktuelle Page zurück |
| `getCurrentPagePart($part, $default)` | `int\|null`, `string\|null` | `string\|array` | Gibt Page-Teil zurück (Teil 1, 2, ...) oder alle Teile |
| `getCurrentPageObject()` | - | `rex_be_page\|null` | Gibt Page-Objekt zur aktuellen Page |
| `requireCurrentPageObject()` | - | `rex_be_page` | Wie `getCurrentPageObject()`, wirft Exception bei null |
| `getPageObject($page)` | `string\|array` | `rex_be_page\|null` | Gibt Page-Objekt für Page-Key |
| `getPages()` | - | `array` | Gibt alle registrierten Pages zurück |
| `setPages($pages)` | `array` | `void` | Setzt alle Pages (z.B. nach Modifikation) |
| `getPageTitle()` | - | `string` | Gibt Browser-Titel zurück (`Page · Server · REDAXO`) |
| `getSetupPage()` | - | `rex_be_page` | Gibt Setup-Page zurück |
| `getLoginPage()` | - | `rex_be_page` | Gibt Login-Page zurück |
| `appendLoggedInPages()` | - | `void` | Fügt System-Pages hinzu (System, Packages, Profile, Credits, Log) |
| `appendPackagePages()` | - | `void` | Fügt Addon/Plugin-Pages aus `page`/`pages` Property hinzu |

## rex_be_page Methoden

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `__construct($key, $title)` | `string`, `string` | - | Erstellt Page (z.B. `myaddon/main`, `Mein Addon`) |
| `getKey()` | - | `string` | Gibt Key zurück (z.B. `main`) |
| `getFullKey()` | - | `string` | Gibt vollen Pfad zurück (z.B. `myaddon/main`) |
| `setTitle($title)` | `string` | `$this` | Setzt Titel |
| `getTitle()` | - | `string` | Gibt Titel zurück |
| `setHref($href)` | `string\|array` | `$this` | Setzt Link-URL (String oder Parameter-Array) |
| `getHref()` | - | `string` | Gibt URL zurück |
| `setPath($path)` | `string` | `$this` | Setzt Dateipfad (z.B. `pages/main.php`) |
| `setSubPath($path)` | `string` | `$this` | Setzt Dateipfad für Subpage |
| `setPopup($popup)` | `bool\|string` | `$this` | Markiert als Popup (optional onclick-Attr) |
| `isPopup()` | - | `bool` | Prüft ob Popup |
| `setHidden($hidden)` | `bool` | `$this` | Versteckt Page in Navigation |
| `isHidden()` | - | `bool` | Prüft ob versteckt |
| `setHasLayout($hasLayout)` | `bool` | `$this` | Aktiviert/deaktiviert Layout-Rendering |
| `hasLayout()` | - | `bool` | Prüft ob Layout aktiv |
| `setHasNavigation($nav)` | `bool` | `$this` | Zeigt/versteckt Backend-Navigation |
| `hasNavigation()` | - | `bool` | Prüft ob Navigation sichtbar |
| `setPjax($pjax)` | `bool` | `$this` | Aktiviert Pjax (Ajax-Page-Load) |
| `hasPjax()` | - | `bool` | Prüft ob Pjax aktiv |
| `setIcon($icon)` | `string` | `$this` | Setzt Icon-CSS-Klasse |
| `getIcon()` | - | `string` | Gibt Icon zurück |
| `setRequiredPermissions($perms)` | `string\|array` | `$this` | Setzt erforderliche Permissions |
| `checkPermission($user)` | `rex_user` | `bool` | Prüft User-Permissions |
| `addSubpage($page)` | `rex_be_page` | `$this` | Fügt Subpage hinzu |
| `getSubpage($key)` | `string` | `rex_be_page\|null` | Gibt Subpage zurück |
| `getSubpages()` | - | `array` | Gibt alle Subpages zurück |
| `setIsActive($active)` | `bool` | `$this` | Markiert als aktiv |
| `isActive()` | - | `bool` | Prüft ob aktiv |
| `addItemClass($class)` | `string` | `$this` | Fügt CSS-Klasse zu `<li>` hinzu |
| `addLinkClass($class)` | `string` | `$this` | Fügt CSS-Klasse zu `<a>` hinzu |
| `setItemAttr($name, $value)` | `string`, `string` | `$this` | Setzt `<li>`-Attribut |
| `setLinkAttr($name, $value)` | `string`, `string` | `$this` | Setzt `<a>`-Attribut |

## rex_be_page_main Methoden (zusätzlich)

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `__construct($block, $key, $title)` | `string`, `string`, `string` | - | Main-Page mit Block (z.B. `system`, `addons`) |
| `setBlock($block)` | `string` | `$this` | Setzt Block-Name |
| `getBlock()` | - | `string` | Gibt Block zurück |
| `setPrio($prio)` | `int` | `$this` | Setzt Sortier-Priorität |
| `getPrio()` | - | `int` | Gibt Prio zurück |

## rex_be_navigation Methoden

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `factory()` | - | `rex_be_navigation` | Erstellt Navigation-Instanz |
| `addPage($page)` | `rex_be_page` | `void` | Fügt Page zur Navigation hinzu |
| `getNavigation()` | - | `array` | Gibt Navigation-Array zurück (für Fragment) |
| `setHeadline($block, $headline)` | `string`, `string` | `void` | Setzt Block-Überschrift |
| `getHeadline($block)` | `string` | `string` | Gibt Block-Überschrift zurück |
| `setPrio($block, $prio)` | `string`, `int` | `void` | Setzt Block-Priorität |
| `getPrio($block)` | `string` | `int\|null` | Gibt Block-Prio zurück |

## Praxisbeispiele

### Aktuelle Page ermitteln

```php
// In Backend-Pages
$currentPage = rex_be_controller::getCurrentPage(); // "myaddon/main"

// Body-ID generieren
$bodyId = rex_string::normalize($currentPage, '-', ' '); // "myaddon-main"
```

### Page-Teile auslesen

```php
// Erste Ebene
$part1 = rex_be_controller::getCurrentPagePart(1); // "myaddon"

// Zweite Ebene
$part2 = rex_be_controller::getCurrentPagePart(2); // "main"

// Mit Default-Wert
$part3 = rex_be_controller::getCurrentPagePart(3, 'default'); // "default" wenn leer

// Alle Teile als Array
$parts = rex_be_controller::getCurrentPagePart(null); // ["myaddon", "main"]
```

### Page-Objekt holen

```php
// Aktuelles Page-Objekt
$pageObj = rex_be_controller::getCurrentPageObject();

if ($pageObj) {
    echo $pageObj->getTitle();
}

// Oder mit Exception
$pageObj = rex_be_controller::requireCurrentPageObject();
```

### Spezifisches Page-Objekt

```php
// Page via String
$page = rex_be_controller::getPageObject('yform/yform_field_docs');

// Page via Array
$page = rex_be_controller::getPageObject(['yform', 'yform_field_docs']);

if ($page) {
    echo $page->getTitle();
}
```

### Browser-Titel

```php
// Generiert: "Addon Title · example.com · REDAXO CMS"
$title = rex_be_controller::getPageTitle();
echo '<title>' . $title . '</title>';
```

### Backend-Page erstellen (Addon boot.php)

```php
// Basis-Page
$page = new rex_be_page('myaddon/main', rex_i18n::msg('myaddon_title'));
$page->setSubPath(rex_path::addon('myaddon', 'pages/main.php'));
rex_be_controller::getPages()['myaddon'] = $page;

// Oder als Main-Page mit Icon
$page = new rex_be_page_main('addons', 'myaddon', rex_i18n::msg('myaddon_title'));
$page->setPath(rex_path::addon('myaddon', 'pages/index.php'));
$page->setIcon('rex-icon fa-cogs');
$page->setPrio(50);
```

### Subpage hinzufügen

```php
$mainPage = rex_be_controller::getPageObject('myaddon');

// Settings-Subpage
$subpage = new rex_be_page('settings', rex_i18n::msg('myaddon_settings'));
$subpage->setSubPath(rex_path::addon('myaddon', 'pages/settings.php'));
$mainPage->addSubpage($subpage);

// Weitere Subpage
$subpage = new rex_be_page('docs', rex_i18n::msg('myaddon_docs'));
$subpage->setSubPath(rex_path::addon('myaddon', 'pages/docs.php'));
$mainPage->addSubpage($subpage);
```

### Permissions setzen

```php
$page = new rex_be_page('myaddon/admin', 'Administration');
$page->setRequiredPermissions('admin[]'); // Nur Admins

// Mehrere Permissions
$page->setRequiredPermissions(['myaddon[admin]', 'myaddon[edit]']);

// Prüfen
if ($page->checkPermission(rex::requireUser())) {
    echo 'User hat Zugriff';
}
```

### Popup-Page

```php
$page = new rex_be_page('myaddon/popup', 'Popup');
$page->setPopup(true); // Öffnet in Popup
$page->setHasNavigation(false); // Keine Navigation
$page->setHasLayout(false); // Minimales Layout
```

### Hidden Page (nicht in Navigation)

```php
$page = new rex_be_page('myaddon/ajax', 'Ajax Endpoint');
$page->setHidden(true);
$page->setHasLayout(false);
$page->setSubPath(rex_path::addon('myaddon', 'pages/ajax.php'));
```

### Pjax aktivieren

```php
// Seite lädt via Ajax (schneller)
$page = new rex_be_page('myaddon/main', 'Main');
$page->setPjax(true);
```

### Custom Href

```php
// Externe URL
$page = new rex_be_page('docs', 'Dokumentation');
$page->setHref('https://example.com/docs');

// Interne URL mit Parametern
$page->setHref(['page' => 'myaddon/main', 'func' => 'edit', 'id' => 1]);
// Oder:
$page->setHref(rex_url::backendPage('myaddon/main', ['func' => 'edit']));
```

### Icon setzen

```php
$page = new rex_be_page_main('addons', 'myaddon', 'My Addon');
$page->setIcon('rex-icon fa-star'); // FontAwesome
$page->setIcon('rex-icon rex-icon-package'); // REDAXO Icon
```

### CSS-Klassen hinzufügen

```php
$page = new rex_be_page('special', 'Special');
$page->addItemClass('my-custom-class'); // <li class="my-custom-class">
$page->addLinkClass('btn btn-primary'); // <a class="btn btn-primary">
```

### Navigation erstellen (Fragment)

```php
$nav = rex_be_navigation::factory();

// Pages hinzufügen
$nav->addPage($page1);
$nav->addPage($page2);

// Navigation rendern
$navigation = $nav->getNavigation();

$fragment = new rex_fragment();
$fragment->setVar('navigation', $navigation, false);
echo $fragment->parse('core/navigations/main.php');
```

### Block-Headline setzen

```php
$nav = rex_be_navigation::factory();
$nav->setHeadline('custom_block', 'Meine Tools');

// Block-Prio setzen
$nav->setPrio('custom_block', 15);
```

### package.yml Pages-Property

```php
# package.yml
page: myaddon
pages:
    main: { title: 'translate:myaddon_main' }
    settings: { title: 'translate:myaddon_settings', perm: 'admin[]' }
    docs: { title: 'translate:myaddon_docs', hidden: true }
```

### Pages-Array im PHP

```php
// In boot.php
rex_addon::get('myaddon')->setProperty('pages', [
    'main' => [
        'title' => rex_i18n::msg('myaddon_main'),
        'icon' => 'rex-icon fa-home',
    ],
    'settings' => [
        'title' => rex_i18n::msg('myaddon_settings'),
        'perm' => 'admin[]',
        'pjax' => true,
    ],
]);
```

### Dynamische Subpages

```php
$mainPage = rex_be_controller::getPageObject('myaddon');

// Subpages durchlaufen
foreach ($mainPage->getSubpages() as $key => $subpage) {
    echo $subpage->getTitle() . '<br>';
}

// Spezifische Subpage
$settingsPage = $mainPage->getSubpage('settings');
```

### Aktive Page markieren

```php
$page = rex_be_controller::getCurrentPageObject();

if ($page && $page->isActive()) {
    echo '<li class="active">...</li>';
}

// Manuell setzen
$page->setIsActive(true);
$page->addItemClass('active');
```

### System-Pages-Struktur

```php
// appendLoggedInPages() erstellt:
// - profile (pages/profile.php)
// - credits (pages/credits.php)
// - system
//   - settings (pages/system.settings.php)
//   - lang (pages/system.clangs.php)
//   - log
//     - redaxo (pages/system.log.redaxo.php)
//     - php (pages/system.log.external.php)
//     - slow-queries (pages/system.log.slow-queries.php)
//   - report
//     - html (pages/system.report.html.php)
//     - markdown (pages/system.report.markdown.php)
//   - phpinfo (pages/system.phpinfo.php)
// - packages (pages/packages.php)
```

### Page-Prüfung für Addon-Logik

```php
// In boot.php: CSS nur auf eigener Page laden
if (rex::isBackend() && rex_be_controller::getCurrentPage() === 'myaddon/main') {
    rex_view::addCssFile(rex_url::addonAssets('myaddon', 'backend.css'));
}

// Oder Teile prüfen
if (rex_be_controller::getCurrentPagePart(1) === 'myaddon') {
    // Auf allen Addon-Pages
}
```

### Login/Setup Pages

```php
// Setup-Page (kein Layout)
$setupPage = rex_be_controller::getSetupPage();
// Page: "setup", Path: "pages/setup.php"

// Login-Page
$loginPage = rex_be_controller::getLoginPage();
// Page: "login", Path: "pages/login.php", hasNavigation: false
```

### Packages-Page deaktivieren (Safe Mode)

```php
// appendLoggedInPages() fügt packages nur hinzu wenn !rex::isLiveMode()
if (rex::isLiveMode()) {
    // Keine Packages-Page
}
```

### rex_list mit page-Parameter

```php
$list = rex_list::factory('SELECT * FROM table');

// Automatisch aktuelle Page hinzufügen
$list->addParam('page', rex_be_controller::getCurrentPage());

// List-URLs enthalten jetzt ?page=myaddon/main
```

### rex_form mit page-Parameter

```php
$form = rex_form::factory('rex_table', '', 'id=' . $id);

// Automatisch in __construct:
$this->addParam('page', rex_be_controller::getCurrentPage());
```

### Custom Attributes

```php
$page = new rex_be_page('special', 'Special');

// <li>-Attribute
$page->setItemAttr('data-id', '123');
$page->setItemAttr('data-type', 'custom');

// <a>-Attribute
$page->setLinkAttr('target', '_blank');
$page->setLinkAttr('rel', 'noopener');
```

### Conditional Page-Loading

```php
// Nur laden wenn User spezielle Perm hat
if (rex::requireUser()->hasPerm('myaddon[advanced]')) {
    $page = new rex_be_page('advanced', 'Advanced');
    $mainPage->addSubpage($page);
}
```

### First Subpage Leaf

```php
// Wenn Page keine direkte Path hat, findet getHref() erste verfügbare Subpage
$page = new rex_be_page('myaddon', 'Main');
$page->addSubpage(new rex_be_page('sub1', 'Sub 1'));

$href = $page->getHref(); 
// Leitet zu erster Subpage: myaddon/sub1
```

### Backend-Kontext-Prüfung

```php
// In Fragmenten/Templates
$isLogin = ('login' === rex_be_controller::getCurrentPage());
$isSetup = ('setup' === rex_be_controller::getCurrentPage());

if ($isLogin || $isSetup) {
    // Minimale Navigation
}
```
