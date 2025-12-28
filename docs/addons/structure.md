# Structure - Artikel & Kategorien

**Keywords:** Article Category Structure Navigation Sitemap Content Tree Hierarchy

## Übersicht

Core-Addon zur Verwaltung der Seitenstruktur mit Kategorien (Ordner) und Artikeln (Seiten). Bietet Hierarchie, Prioritäten, Status, Metadaten und Navigation.

## Hauptklassen

### rex_article

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `::get($id, $clang)` | int, int | rex_article\|null | Artikel per ID laden |
| `::getCurrent()` | - | rex_article | Aktueller Artikel (Frontend) |
| `::getSiteStartArticle($clang)` | int | rex_article | Startseite |
| `::getNotfoundArticle($clang)` | int | rex_article | 404-Seite |
| `::getNotfoundArticleId()` | - | int | 404-Artikel-ID |
| `::getRootArticles($ignoreOfflines, $clang)` | bool, int | array | Root-Artikel (Level 0) |
| `::getCurrentId()` | - | int | ID des aktuellen Artikels |
| `getId()` | - | int | Artikel-ID |
| `getName()` | - | string | Artikel-Name |
| `getUrl($params, $sep)` | array, string | string | Artikel-URL |
| `getValue($key)` | string | mixed | Wert aus rex_article-Tabelle |
| `getArticle($curctype)` | int | string | Artikel-Content rendern |
| `getParent()` | - | rex_category\|null | Eltern-Kategorie |
| `getPathAsArray()` | - | array | Pfad als ID-Array |
| `isOnline()` | - | bool | Ist Artikel online? |
| `isStartArticle()` | - | bool | Ist Startartikel einer Kategorie? |
| `hasTemplate()` | - | bool | Hat Template zugewiesen? |
| `getTemplateId()` | - | int | Template-ID |
| `hasValue($key)` | string | bool | Artikel hat Wert? |
| `clangSwitch($clang)` | int | rex_article\|null | Artikel in anderer Sprache |

### rex_category

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `::get($id, $clang)` | int, int | rex_category\|null | Kategorie per ID |
| `::getCurrent()` | - | rex_category | Aktuelle Kategorie (Frontend) |
| `::getRootCategories($ignoreOfflines, $clang)` | bool, int | array | Root-Kategorien (Level 0) |
| `getChildren($ignoreOfflines)` | bool | array | Unterkategorien |
| `getArticles($ignoreOfflines)` | bool | array | Artikel dieser Kategorie |
| `getParent()` | - | rex_category\|null | Eltern-Kategorie |
| `getPathAsArray()` | - | array | Pfad als ID-Array |
| `isOnline()` | - | bool | Ist online? |
| `getPath()` | - | string | Pfad als String (IDs mit \|) |
| `getPriority()` | - | int | Priorität (Sortierung) |

### rex_navigation

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `::factory()` | - | rex_navigation | Factory-Pattern |
| `get($parentId, $depth, $ignoreOfflines, $ignoreHidden)` | int, int, bool, bool | array | Navigation-Array |
| `render($parentId, $depth, $open, $custom)` | int, int, bool, callable | string | Navigation als HTML |

## Praxisbeispiele

### Aktuellen Artikel abrufen

```php
// Im Frontend-Template
$article = rex_article::getCurrent();

echo $article->getName(); // Artikel-Name
echo $article->getId(); // Artikel-ID
echo $article->getUrl(); // URL
echo $article->getValue('art_description'); // Custom Metainfo-Feld
```

### Artikel per ID laden

```php
// Artikel laden
$article = rex_article::get(42, 1); // ID 42, Sprache 1

if ($article) {
    echo $article->getName();
    echo $article->getUrl();
    echo $article->isOnline() ? 'Online' : 'Offline';
}
```

### Artikel in anderer Sprache

```php
// Aktueller Artikel in anderer Sprache
$current = rex_article::getCurrent();

$article_de = $current->clangSwitch(1); // Deutsch
$article_en = $current->clangSwitch(2); // Englisch

if ($article_en) {
    echo '<a href="' . $article_en->getUrl() . '">English</a>';
}
```

### Startseite & 404

```php
// Startseite
$home = rex_article::getSiteStartArticle(rex_clang::getCurrentId());
echo '<a href="' . $home->getUrl() . '">Home</a>';

// 404-Seite
$notfound = rex_article::getNotfoundArticle(rex_clang::getCurrentId());
echo $notfound->getArticle(); // Content der 404-Seite

// Redirect zur 404
$article_id = rex_article::getNotfoundArticleId();
rex_redirect($article_id, rex_clang::getCurrentId(), [], 404);
```

### Pfad ermitteln (Breadcrumb)

```php
// Breadcrumb aus Pfad
$article = rex_article::getCurrent();
$path = $article->getPathAsArray();

echo '<ol class="breadcrumb">';
foreach ($path as $cat_id) {
    $category = rex_category::get($cat_id);
    if ($category) {
        echo '<li><a href="' . $category->getUrl() . '">' . $category->getName() . '</a></li>';
    }
}
echo '<li class="active">' . $article->getName() . '</li>';
echo '</ol>';
```

### Artikel-Content rendern

```php
// Kompletten Artikel-Content ausgeben
$article = rex_article::get(42);
echo $article->getArticle(); // Alle Slices (ctypes)

// Nur bestimmten ctype
echo $article->getArticle(1); // Nur ctype 1 (z.B. Sidebar)
```

### Aktuelle Kategorie

```php
// Im Frontend
$category = rex_category::getCurrent();

if ($category) {
    echo $category->getName();
    echo $category->getId();
    echo $category->getPriority();
    echo $category->getPath(); // z.B. "|1|5|12|"
}
```

### Kategorie per ID

```php
$category = rex_category::get(5, 1); // ID 5, Sprache 1

if ($category) {
    echo $category->getName();
    echo $category->isOnline() ? 'Online' : 'Offline';
}
```

### Unterkategorien abrufen

```php
// Alle Unterkategorien
$parent = rex_category::get(5);
$children = $parent->getChildren(true); // true = nur online

foreach ($children as $child) {
    echo '<a href="' . $child->getUrl() . '">' . $child->getName() . '</a><br>';
}
```

### Artikel einer Kategorie

```php
// Alle Artikel der Kategorie
$category = rex_category::get(5);
$articles = $category->getArticles(true); // true = nur online

foreach ($articles as $article) {
    if (!$article->isStartArticle()) { // Startartikel überspringen
        echo '<a href="' . $article->getUrl() . '">' . $article->getName() . '</a><br>';
    }
}
```

### Root-Kategorien

```php
// Hauptkategorien (Level 0)
$categories = rex_category::getRootCategories(true); // true = nur online

foreach ($categories as $cat) {
    echo '<a href="' . $cat->getUrl() . '">' . $cat->getName() . '</a><br>';
}
```

### Root-Artikel

```php
// Artikel auf Level 0 (außerhalb von Kategorien)
$articles = rex_article::getRootArticles(true, rex_clang::getCurrentId());

foreach ($articles as $article) {
    echo '<a href="' . $article->getUrl() . '">' . $article->getName() . '</a><br>';
}
```

### Navigation (Factory)

```php
// Haupt-Navigation
$nav = rex_navigation::factory();

// Level 0 und 1
$items = $nav->get(0, 2, true, true); // 0=root, 2=depth, true=ignoreOfflines, true=ignoreHidden

foreach ($items as $item) {
    echo '<li>';
    echo '<a href="' . $item['href'] . '">' . $item['name'] . '</a>';
    
    // Unterpunkte
    if (!empty($item['children'])) {
        echo '<ul>';
        foreach ($item['children'] as $child) {
            echo '<li><a href="' . $child['href'] . '">' . $child['name'] . '</a></li>';
        }
        echo '</ul>';
    }
    
    echo '</li>';
}
```

### Navigation rendern (Bootstrap)

```php
// Navigation als HTML mit Custom Renderer
$nav = rex_navigation::factory();

echo $nav->render(0, 2, true, function($items, $depth) {
    $output = '<ul class="nav navbar-nav">';
    
    foreach ($items as $item) {
        $active = ($item['active']) ? ' class="active"' : '';
        
        $output .= '<li' . $active . '>';
        $output .= '<a href="' . $item['href'] . '">' . $item['name'] . '</a>';
        
        if (!empty($item['children'])) {
            $output .= '<ul class="dropdown-menu">';
            foreach ($item['children'] as $child) {
                $output .= '<li><a href="' . $child['href'] . '">' . $child['name'] . '</a></li>';
            }
            $output .= '</ul>';
        }
        
        $output .= '</li>';
    }
    
    $output .= '</ul>';
    return $output;
});
```

### Sitemap (Navigation Level 0-3)

```php
// Sitemap generieren
function renderSitemap($parent_id = 0, $depth = 3, $current_depth = 0) {
    if ($current_depth >= $depth) return '';
    
    $nav = rex_navigation::factory();
    $items = $nav->get($parent_id, 1, true, true);
    
    if (empty($items)) return '';
    
    $output = '<ul class="sitemap-level-' . $current_depth . '">';
    
    foreach ($items as $item) {
        $output .= '<li>';
        $output .= '<a href="' . $item['href'] . '">' . $item['name'] . '</a>';
        
        if (!empty($item['children'])) {
            $output .= renderSitemap($item['id'], $depth, $current_depth + 1);
        }
        
        $output .= '</li>';
    }
    
    $output .= '</ul>';
    return $output;
}

echo renderSitemap(0, 3); // 3 Ebenen tief
```

### Eltern-Kategorie

```php
// Eltern-Kategorie eines Artikels
$article = rex_article::getCurrent();
$parent = $article->getParent();

if ($parent) {
    echo 'Kategorie: <a href="' . $parent->getUrl() . '">' . $parent->getName() . '</a>';
}
```

### Kategoriebaum rekursiv

```php
function renderCategoryTree($parent_id = 0, $depth = 0) {
    $categories = ($parent_id == 0) 
        ? rex_category::getRootCategories(true) 
        : rex_category::get($parent_id)->getChildren(true);
    
    if (empty($categories)) return '';
    
    $output = '<ul class="category-tree level-' . $depth . '">';
    
    foreach ($categories as $cat) {
        $output .= '<li>';
        $output .= '<a href="' . $cat->getUrl() . '">' . $cat->getName() . '</a>';
        
        // Rekursiv
        if ($cat->getChildren(true)) {
            $output .= renderCategoryTree($cat->getId(), $depth + 1);
        }
        
        $output .= '</li>';
    }
    
    $output .= '</ul>';
    return $output;
}

echo renderCategoryTree();
```

### Artikel-Liste mit Pagination

```php
$category_id = 5;
$per_page = 10;
$page = rex_request::get('page', 'int', 1);

$category = rex_category::get($category_id);
$all_articles = $category->getArticles(true);

// Paginieren
$total = count($all_articles);
$offset = ($page - 1) * $per_page;
$articles = array_slice($all_articles, $offset, $per_page);

// Ausgabe
foreach ($articles as $article) {
    echo '<h3><a href="' . $article->getUrl() . '">' . $article->getName() . '</a></h3>';
    echo '<p>' . $article->getValue('art_description') . '</p>';
}

// Pagination
$total_pages = ceil($total / $per_page);
for ($i = 1; $i <= $total_pages; $i++) {
    $url = rex_getUrl($category_id, '', ['page' => $i]);
    echo '<a href="' . $url . '">' . $i . '</a> ';
}
```

### Template prüfen

```php
$article = rex_article::getCurrent();

if ($article->hasTemplate()) {
    echo 'Template-ID: ' . $article->getTemplateId();
    
    // Template-Name
    $template = rex_template::get($article->getTemplateId());
    echo 'Template: ' . $template->getName();
}
```

### Artikel erstellen (Backend)

```php
// Neuen Artikel erstellen
rex_article_service::addArticle([
    'category_id' => 5, // Parent-Kategorie
    'name' => 'Neuer Artikel',
    'template_id' => 1,
    'clang_id' => 1,
    'priority' => 1,
    'status' => 1 // 1 = online
]);
```

### Artikel aktualisieren

```php
// Artikel aktualisieren
rex_article_service::editArticle([
    'id' => 42,
    'clang_id' => 1,
    'name' => 'Geänderter Name',
    'status' => 1
]);
```

### Kategorie erstellen

```php
// Neue Kategorie
rex_category_service::addCategory([
    'parent_id' => 0, // 0 = root
    'name' => 'Neue Kategorie',
    'template_id' => 1,
    'clang_id' => 1,
    'priority' => 99,
    'status' => 1
]);
```

### URL mit Parametern

```php
// URL mit Query-Parametern
$article = rex_article::get(42);

$url = $article->getUrl(['id' => 123, 'page' => 2], '&');
// /artikel/?id=123&page=2

// Mit rex_getUrl (Alternative)
$url = rex_getUrl(42, '', ['id' => 123, 'page' => 2]);
```

### Metainfo-Felder abfragen

```php
$article = rex_article::getCurrent();

// Standard-Felder
echo $article->getName();
echo $article->getValue('createdate'); // Erstelldatum
echo $article->getValue('updatedate'); // Änderungsdatum
echo $article->getValue('createuser'); // Ersteller
echo $article->getValue('updateuser'); // Bearbeiter

// Custom Metainfo-Felder (wenn vorhanden)
echo $article->getValue('art_description'); // Meta-Description
echo $article->getValue('art_keywords'); // Keywords
echo $article->getValue('art_image'); // Beitragsbild
echo $article->getValue('art_author'); // Autor

// Prüfen ob Feld vorhanden
if ($article->hasValue('art_teaser')) {
    echo $article->getValue('art_teaser');
}
```

### Sprach-Switch

```php
// Language Switcher
$current = rex_article::getCurrent();
$clangs = rex_clang::getAll();

echo '<ul class="lang-switcher">';
foreach ($clangs as $clang) {
    $article = $current->clangSwitch($clang->getId());
    
    if ($article) {
        $active = ($clang->getId() == rex_clang::getCurrentId()) ? ' class="active"' : '';
        echo '<li' . $active . '>';
        echo '<a href="' . $article->getUrl() . '">' . $clang->getCode() . '</a>';
        echo '</li>';
    }
}
echo '</ul>';
```

### Online/Offline Status

```php
$article = rex_article::get(42);

if ($article->isOnline()) {
    echo 'Artikel ist online';
    echo $article->getValue('status'); // 1
} else {
    echo 'Artikel ist offline';
    echo $article->getValue('status'); // 0
}
```

### Startartikel prüfen

```php
$article = rex_article::getCurrent();

if ($article->isStartArticle()) {
    echo 'Dies ist ein Startartikel einer Kategorie';
}
```

### Navigation mit aktiven States

```php
$nav = rex_navigation::factory();
$items = $nav->get(0, 2, true, true);
$current_id = rex_article::getCurrentId();
$path = rex_article::getCurrent()->getPathAsArray();

foreach ($items as $item) {
    $active = ($item['id'] == $current_id || in_array($item['id'], $path)) ? 'active' : '';
    
    echo '<li class="' . $active . '">';
    echo '<a href="' . $item['href'] . '">' . $item['name'] . '</a>';
    
    if (!empty($item['children'])) {
        echo '<ul>';
        foreach ($item['children'] as $child) {
            $child_active = ($child['id'] == $current_id) ? 'active' : '';
            echo '<li class="' . $child_active . '"><a href="' . $child['href'] . '">' . $child['name'] . '</a></li>';
        }
        echo '</ul>';
    }
    
    echo '</li>';
}
```

### Geschwister-Artikel

```php
// Artikel der gleichen Kategorie
$current = rex_article::getCurrent();
$parent = $current->getParent();

if ($parent) {
    $siblings = $parent->getArticles(true);
    
    echo '<ul class="siblings">';
    foreach ($siblings as $sibling) {
        if ($sibling->getId() != $current->getId() && !$sibling->isStartArticle()) {
            echo '<li><a href="' . $sibling->getUrl() . '">' . $sibling->getName() . '</a></li>';
        }
    }
    echo '</ul>';
}
```

### Vorheriger/Nächster Artikel

```php
$current = rex_article::getCurrent();
$parent = $current->getParent();

if ($parent) {
    $articles = $parent->getArticles(true);
    $current_index = array_search($current->getId(), array_map(fn($a) => $a->getId(), $articles));
    
    // Vorheriger
    if ($current_index > 0 && isset($articles[$current_index - 1])) {
        $prev = $articles[$current_index - 1];
        echo '<a href="' . $prev->getUrl() . '">« ' . $prev->getName() . '</a>';
    }
    
    // Nächster
    if (isset($articles[$current_index + 1])) {
        $next = $articles[$current_index + 1];
        echo '<a href="' . $next->getUrl() . '">' . $next->getName() . ' »</a>';
    }
}
```
