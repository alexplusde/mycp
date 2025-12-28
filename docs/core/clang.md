# rex_clang & rex_clang_service

Keywords: Mehrsprachigkeit, Languages, Clang, Sprachen, Multi-Language, Language Management

## Übersicht

**rex_clang** repräsentiert eine Sprache (Content Language) mit ID, Code (`de`, `en`), Name, Priority, Status (online/offline). Zentrale Klasse für Mehrsprachigkeit im Frontend+Backend.

**rex_clang_service** verwaltet CRUD-Operationen für Sprachen: addCLang, editCLang, deleteCLang. Generiert Cache-Datei `var/cache/clang.cache`. Wirft Extension Points (CLANG_ADDED, CLANG_UPDATED, CLANG_DELETED).

## rex_clang Methoden

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `exists($id)` | `int` | `bool` | Prüft ob Clang-ID existiert |
| `get($id)` | `int` | `rex_clang\|null` | Gibt Clang-Objekt für ID zurück |
| `getStartId()` | - | `int` | Gibt erste Clang-ID zurück (Standard-Sprache) |
| `getCurrent()` | - | `rex_clang` | Gibt aktuelle Clang zurück |
| `getCurrentId()` | - | `int` | Gibt aktuelle Clang-ID zurück |
| `setCurrentId($id)` | `int` | `void` | Setzt aktuelle Clang-ID (Backend-Kontext) |
| `getAll($ignoreOfflines)` | `bool` | `array` | Gibt alle Clangs zurück, optional ohne Offline-Sprachen |
| `getAllIds($ignoreOfflines)` | `bool` | `array` | Gibt alle Clang-IDs zurück |
| `count($ignoreOfflines)` | `bool` | `int` | Zählt Clangs |
| `getId()` | - | `int` | Clang-ID |
| `getCode()` | - | `string` | Sprachcode (z.B. `de`, `en`, `fr`) |
| `getName()` | - | `string` | Sprachname (z.B. "Deutsch", "English") |
| `getPriority()` | - | `int` | Sortierreihenfolge |
| `isOnline()` | - | `bool` | Status (online = true, offline = false) |
| `hasValue($key)` | `string` | `bool` | Prüft ob Custom-Feld existiert |
| `getValue($key)` | `string` | `mixed` | Gibt Custom-Feld-Wert zurück (z.B. `clang_locale`) |

## rex_clang_service Methoden

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `addCLang($code, $name, $priority, $status)` | `string`, `string`, `int`, `bool` | `void` | Erstellt neue Sprache |
| `editCLang($id, $code, $name, $priority, $status)` | `int`, `string`, `string`, `int`, `bool\|null` | `bool` | Bearbeitet Sprache |
| `deleteCLang($id)` | `int` | `void` | Löscht Sprache (nicht Start-Sprache!) |
| `generateCache()` | - | `void` | Generiert Cache-Datei `clang.cache` |

## Praxisbeispiele

### Aktuelle Sprache ermitteln

```php
// In Templates/Modulen
$clang = rex_clang::getCurrent();
$clangId = rex_clang::getCurrentId(); // 1, 2, 3...
$code = $clang->getCode(); // "de", "en", "fr"
```

### HTML lang-Attribut

```php
// In Templates
<html lang="<?php echo rex_clang::getCurrent()->getCode(); ?>">
```

### Startsprache ermitteln

```php
// Erste Clang-ID (meist 1)
$startId = rex_clang::getStartId();

// Startseitenlink
$homeUrl = rex_article::getSiteStartArticle(rex_clang::getCurrentId())->getUrl();
```

### Alle Sprachen auflisten

```php
// Alle Clangs (inkl. Offline)
foreach (rex_clang::getAll() as $id => $clang) {
    echo $clang->getName() . ' (' . $clang->getCode() . ')<br>';
}

// Nur Online-Sprachen
foreach (rex_clang::getAll(true) as $id => $clang) {
    echo '<a href="' . rex_article::getCurrent($id)->getUrl() . '">';
    echo $clang->getName();
    echo '</a>';
}
```

### Clang-IDs holen

```php
// Alle IDs
$clangIds = rex_clang::getAllIds(); // [1, 2, 3]

// Nur Online-IDs
$onlineIds = rex_clang::getAllIds(true);

// In SQL-Queries
$placeholders = implode(',', array_fill(0, count($clangIds), '?'));
$sql->setQuery("SELECT * FROM table WHERE clang_id IN ($placeholders)", $clangIds);
```

### Anzahl Sprachen

```php
// Alle Sprachen
$count = rex_clang::count(); // 3

// Nur Online
$onlineCount = rex_clang::count(true);

if (rex_clang::count() > 1) {
    echo 'Mehrsprachige Installation';
}
```

### Sprache existiert?

```php
$clangId = rex_request::get('clang', 'int');

if (rex_clang::exists($clangId)) {
    rex_clang::setCurrentId($clangId);
} else {
    rex_clang::setCurrentId(rex_clang::getStartId());
}
```

### Backend: Aktuelle Clang setzen

```php
// In Backend-Pages
$clangId = rex_request('clang', 'int', rex_clang::getStartId());

if (rex_clang::exists($clangId)) {
    rex_clang::setCurrentId($clangId);
}
```

### Custom Clang-Felder

```php
// Custom-Feld "clang_locale" (z.B. via MetaInfo)
$clang = rex_clang::getCurrent();

if ($clang->hasValue('clang_locale')) {
    $locale = $clang->getValue('clang_locale'); // "de_DE", "en_US"
    Locale::setDefault($locale);
}

// Fallback
$locale = $clang->getValue('clang_locale') ?? 'de-DE';
```

### Sprachweiche im Template

```php
$clang = rex_clang::getCurrent();

if ($clang->getCode() === 'de') {
    echo 'Deutscher Content';
} elseif ($clang->getCode() === 'en') {
    echo 'English Content';
}
```

### CSS-Klasse für Sprache

```php
// Body-Class mit Sprachcode
$cssClass = 'lang-' . rex_clang::getCurrent()->getCode();
echo '<body class="' . $cssClass . '">';
// <body class="lang-de">
```

### YForm Usability - Language Caching

```php
// Cache-Key mit Clang-ID
$langId = $langId ?? rex_clang::getCurrentId();
$cacheKey = 'model_' . $this->getTable() . '_' . $langId;
```

### Sprog Addon - Wildcard-Sync über Sprachen

```php
foreach (rex_clang::getAll() as $id => $clang) {
    // Wildcard für jede Sprache synchronisieren
    $this->syncWildcard($wildcard, $id);
}
```

### rex_clang_service: Sprache hinzufügen

```php
// Neue Sprache anlegen (nur Backend/Setup!)
rex_clang_service::addCLang(
    'fr',           // Code
    'Français',     // Name
    3,              // Priority
    true            // Status (online)
);

// Trigger: Extension Point CLANG_ADDED
```

### Sprache bearbeiten

```php
// Sprache updaten
rex_clang_service::editCLang(
    2,              // ID
    'en',           // Code
    'English',      // Name
    2,              // Priority
    true            // Status (online)
);

// Trigger: Extension Point CLANG_UPDATED
```

### Sprache löschen

```php
try {
    rex_clang_service::deleteCLang(3);
    // Trigger: Extension Point CLANG_DELETED
} catch (rex_functional_exception $e) {
    echo rex_view::error($e->getMessage());
    // Fehler: Startsprache kann nicht gelöscht werden
}
```

### Cache neu generieren

```php
// Nach manuellen DB-Änderungen
rex_clang_service::generateCache();

// Oder: Cache gesamt löschen
rex_delete_cache();
```

### Extension Point: CLANG_ADDED

```php
rex_extension::register('CLANG_ADDED', function(rex_extension_point $ep) {
    $clang = $ep->getParam('clang');
    $id = $ep->getParam('id');
    
    // Artikel für neue Sprache anlegen
    rex_article_service::copyContent(1, 1, $id);
});
```

### Extension Point: CLANG_UPDATED

```php
rex_extension::register('CLANG_UPDATED', function(rex_extension_point $ep) {
    $clang = $ep->getParam('clang');
    
    // Eigene Logik nach Clang-Update
    rex_logger::factory()->info('Clang updated: ' . $clang->getName());
});
```

### Extension Point: CLANG_DELETED

```php
rex_extension::register('CLANG_DELETED', function(rex_extension_point $ep) {
    $clangId = $ep->getParam('id');
    
    // Eigene Daten in Addon-Tabellen löschen
    rex_sql::factory()->setQuery('DELETE FROM addon_table WHERE clang_id = ?', [$clangId]);
});
```

### Frontend: Sprachnavigation

```php
// Sprachnavigation im Template
$article = rex_article::getCurrent();

echo '<ul class="language-switcher">';
foreach (rex_clang::getAll(true) as $id => $clang) {
    $articleInLang = rex_article::get($article->getId(), $id);
    
    if ($articleInLang && $articleInLang->isOnline()) {
        $active = ($id === rex_clang::getCurrentId()) ? ' class="active"' : '';
        echo '<li' . $active . '>';
        echo '<a href="' . $articleInLang->getUrl() . '">' . $clang->getCode() . '</a>';
        echo '</li>';
    }
}
echo '</ul>';
```

### Artikel in anderer Sprache

```php
$currentArticle = rex_article::getCurrent();
$articleId = $currentArticle->getId();

// Artikel in Sprache 2
$articleEN = rex_article::get($articleId, 2);

if ($articleEN && $articleEN->isOnline()) {
    echo '<a href="' . $articleEN->getUrl() . '">English Version</a>';
}
```

### Backend rex_list mit Clang-Filter

```php
$list = rex_list::factory('SELECT * FROM table WHERE clang_id = ' . rex_clang::getCurrentId());

// Clang-Spalte mit Namen anzeigen
$list->setColumnFormat('clang_id', 'custom', function($params) {
    $clang = rex_clang::get($params['value']);
    return $clang ? $clang->getName() : '-';
});
```

### rex_form mit Clang-Select

```php
$form = rex_form::factory('rex_table', '', 'id=' . $id);

// Clang-Auswahl
$field = $form->addSelectField('clang_id');
$field->setLabel('Sprache');

$select = $field->getSelect();
foreach (rex_clang::getAll() as $clang) {
    $select->addOption($clang->getName(), $clang->getId());
}
```

### Priorität/Reihenfolge

```php
// Clangs sind automatisch nach Priority sortiert
foreach (rex_clang::getAll() as $clang) {
    echo $clang->getPriority() . ': ' . $clang->getName() . '<br>';
}
// 1: Deutsch
// 2: English
// 3: Français
```

### Status prüfen (Online/Offline)

```php
$clang = rex_clang::get(2);

if ($clang && $clang->isOnline()) {
    echo 'Sprache ist online';
} else {
    echo 'Sprache ist offline oder existiert nicht';
}
```

### Locale-Mapping für rex_i18n

```php
// Custom-Feld "clang_locale" -> rex_i18n Locale
$clang = rex_clang::getCurrent();
$locale = $clang->getValue('clang_locale') ?? 'de_de';

rex_i18n::setLocale($locale);
```

### YRewrite mit Clangs

```php
// YRewrite Domain-Config mit Clang
$domain->setStartId($articleId);
$domain->setClangId($clangId);

// Artikel-URL in bestimmter Sprache
$url = rex_yrewrite::getFullUrlByArticleId($articleId, $clangId);
```

### SQL-Query über alle Sprachen

```php
$sql = rex_sql::factory();

foreach (rex_clang::getAllIds() as $clangId) {
    $sql->setQuery('
        UPDATE rex_article 
        SET online_from = ? 
        WHERE clang_id = ?
    ', [time(), $clangId]);
}
```

### Clang-Switch im Backend (rex_view)

```php
// Backend-Page mit Clang-Switch
$content = '... page content ...';

$fragment = new rex_fragment();
$fragment->setVar('content', $content, false);
$fragment->setVar('clang_switch', true); // Aktiviert Clang-Dropdown
echo $fragment->parse('core/page/section.php');
```

### Fallback-Sprache

```php
// Wenn gewünschte Sprache offline
$preferredId = 2;

if (!rex_clang::exists($preferredId) || !rex_clang::get($preferredId)->isOnline()) {
    $clangId = rex_clang::getStartId(); // Fallback zur Startsprache
} else {
    $clangId = $preferredId;
}

rex_clang::setCurrentId($clangId);
```

### Export: Nur Online-Sprachen

```php
// YForm Export mit Online-Clangs
$languages = rex_clang::getAll(true);

foreach ($languages as $clang) {
    $this->exportLanguage($clang->getId());
}
```
