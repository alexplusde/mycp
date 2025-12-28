# Neues - News-Verwaltung

**Keywords:** News, Blog, Pressemitteilungen, Aktuelles, YForm, YRewrite, RSS-Feed, REST-API

## Übersicht

Neues ist eine vollständige News-Verwaltung für Aktuelles, Blog-Beiträge und Pressemitteilungen mit Kategorien, Autoren, Mehrsprachigkeit, RSS-Feed und REST-API.

## Kern-Klassen

| Klasse | Beschreibung |
|--------|-------------|
| `Entry` | News-Eintrag (`rex_yform_manager_dataset`) |
| `Category` | News-Kategorie |
| `Author` | News-Autor |
| `EntryLang` | Mehrsprachige Übersetzungen |
| `Neues` | Helper-Klasse (getList, getEntry) |

## Klasse: Entry

### Wichtige Methoden

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|-------------|
| `::get($id)` | `int $id` | `Entry\|null` | Lädt News-Eintrag |
| `::query()` | - | `Query` | Query-Builder |
| `::findOnline()` | `int $category_id` | `Collection` | Online-Einträge |
| `::findByCategory()` | `int $cat, int $status` | `Collection` | Nach Kategorie filtern |
| `getName()` | - | `string` | Überschrift |
| `getTeaser()` | - | `string` | Teaser-Text |
| `getDescription()` | - | `string` | Volltext (HTML) |
| `getDescriptionAsPlaintext()` | - | `string` | Volltext (Text) |
| `getPublishDate()` | - | `string` | Datum (Y-m-d H:i:s) |
| `getFormattedPublishDate()` | `int $format` | `string` | Formatiertes Datum |
| `getAuthor()` | - | `Author\|null` | Autor-Objekt |
| `getCategories()` | - | `Collection` | Kategorien |
| `getImage()` | - | `string` | Bild-Dateiname |
| `getImages()` | - | `array` | Mehrere Bilder |
| `getUrl()` | `string $profile` | `string` | URL (mit URL-Addon) |
| `getStatus()` | - | `int` | Status-Code |
| `isOnline()` | - | `bool` | Ist veröffentlicht? |

### Status-Konstanten

| Konstante | Wert | Beschreibung |
|-----------|------|-------------|
| `DRAFT` | `-1` | Entwurf |
| `PLANNED` | `0` | Geplant (Zeitsteuerung) |
| `ONLINE` | `1` | Veröffentlicht |

## Klasse: Category

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|-------------|
| `::get($id)` | `int $id` | `Category\|null` | Lädt Kategorie |
| `getName()` | - | `string` | Kategorie-Name |
| `getImage()` | - | `string` | Kategorie-Bild |
| `getEntries()` | - | `Collection` | Einträge der Kategorie |

## Klasse: Author

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|-------------|
| `::get($id)` | `int $id` | `Author\|null` | Lädt Autor |
| `getName()` | - | `string` | Vollständiger Name |
| `getNickname()` | - | `string` | Nickname/Pseudonym |
| `getText()` | - | `string` | Autor-Bio |
| `getBeUserId()` | - | `int` | Verknüpfter Backend-User |
| `getUser()` | - | `rex_user\|null` | Backend-User-Objekt |

## Helper-Klasse: Neues

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|-------------|
| `::getList()` | `int $rows, string $cursor` | `string` | Paginierte HTML-Liste |
| `::getEntry()` | `int $postId` | `string` | Einzeleintrag HTML |

## RSS-Feed-API

| Methode | URL | Beschreibung |
|---------|-----|-------------|
| `Rss::execute()` | `?rex-api-call=neues_rss` | RSS 2.0 Feed |
| Filter | `&category_id=3` | Nach Kategorie filtern |
| Filter | `&lang_id=1` | Nach Sprache filtern |
| Filter | `&domain_id=1` | Nach Domain filtern |

## Praxisbeispiele

### 1. News-Eintrag laden

```php
use FriendsOfRedaxo\Neues\Entry;

$entry = Entry::get(42);
echo $entry->getName();
echo $entry->getTeaser();
echo $entry->getDescription();
```

### 2. Alle Online-Einträge

```php
$entries = Entry::findOnline();
foreach ($entries as $entry) {
    echo '<h3>' . $entry->getName() . '</h3>';
    echo '<p>' . $entry->getTeaser() . '</p>';
}
```

### 3. Einträge einer Kategorie

```php
$entries = Entry::findByCategory(3, Entry::ONLINE);
foreach ($entries as $entry) {
    echo $entry->getName();
}
```

### 4. Query-Builder verwenden

```php
$entries = Entry::query()
    ->where('status', Entry::ONLINE, '>=')
    ->where('publishdate', date('Y-m-d H:i:s'), '<=')
    ->orderBy('publishdate', 'DESC')
    ->limit(10)
    ->find();
```

### 5. Mit Paginierung

```php
$pager = new rex_pager(10);
$entries = Entry::query()
    ->where('status', Entry::ONLINE)
    ->orderBy('publishdate', 'DESC')
    ->paginate($pager);

foreach ($entries as $entry) {
    echo $entry->getName();
}
echo $pager->getRowCount(); // Gesamtanzahl
```

### 6. Neuen Eintrag erstellen

```php
$entry = Entry::create();
$entry->setName('Neue Pressemitteilung');
$entry->setTeaser('Kurzer Teaser-Text');
$entry->setDescription('<p>Vollständiger Artikel...</p>');
$entry->setPublishDate(date('Y-m-d H:i:s'));
$entry->setStatus(Entry::ONLINE);
$entry->save();
```

### 7. Kategorien zuweisen

```php
$entry = Entry::get(42);
$entry->setValue('category_ids', '1,3,5'); // Kategorie-IDs als Komma-Liste
$entry->save();

// Oder: Kategorien auslesen
$categories = $entry->getCategories();
foreach ($categories as $cat) {
    echo $cat->getName();
}
```

### 8. Autor zuweisen

```php
use FriendsOfRedaxo\Neues\Author;

$author = Author::get(2);
$entry = Entry::get(42);
$entry->setValue('author_id', $author->getId());
$entry->save();

// Autor auslesen
$author = $entry->getAuthor();
echo $author->getName();
```

### 9. Formatiertes Datum

```php
$entry = Entry::get(42);
echo $entry->getFormattedPublishDate(IntlDateFormatter::FULL);
// "Montag, 28. Dezember 2025"

echo $entry->getFormattedPublishDate(IntlDateFormatter::SHORT);
// "28.12.25"
```

### 10. Datum + Uhrzeit formatiert

```php
$entry = Entry::get(42);
echo $entry->getFormattedPublishDateTime([
    IntlDateFormatter::FULL,
    IntlDateFormatter::SHORT
]);
// "Montag, 28. Dezember 2025, 14:30"
```

### 11. Bild ausgeben

```php
$entry = Entry::get(42);
$image = $entry->getImage(); // Dateiname
if ($image && $media = rex_media::get($image)) {
    echo '<img src="' . $media->getUrl() . '" alt="' . $entry->getName() . '">';
}
```

### 12. Mit Media Manager

```php
$entry = Entry::get(42);
$image = $entry->getImage();
if ($image) {
    $url = rex_media_manager::getUrl('rex_media_medium', $image);
    echo '<img src="' . $url . '" alt="' . $entry->getName() . '">';
}
```

### 13. Mehrere Bilder (Galerie)

```php
$entry = Entry::get(42);
$images = $entry->getImages(); // Array von Dateinamen
foreach ($images as $image) {
    if ($media = rex_media::get($image)) {
        echo '<img src="' . rex_media_manager::getUrl('thumb', $image) . '">';
    }
}
```

### 14. URL mit URL-Addon

```php
$entry = Entry::get(42);
$url = $entry->getUrl(); // nutzt URL-Profil "neues-entry-id"
echo '<a href="' . $url . '">' . $entry->getName() . '</a>';
```

### 15. Custom URL-Profil

```php
// z.B. für Multi-Domain
$url = $entry->getUrl('neues-entry-id-domain-2');
```

### 16. Plaintext-Beschreibung

```php
$entry = Entry::get(42);
$text = $entry->getDescriptionAsPlaintext(); // ohne HTML-Tags
echo substr($text, 0, 200) . '...'; // Erste 200 Zeichen
```

### 17. Status prüfen

```php
$entry = Entry::get(42);
if ($entry->isOnline()) {
    echo 'Dieser Artikel ist veröffentlicht';
}

switch ($entry->getStatus()) {
    case Entry::DRAFT:
        echo 'Entwurf';
        break;
    case Entry::PLANNED:
        echo 'Geplant für ' . $entry->getPublishDate();
        break;
    case Entry::ONLINE:
        echo 'Online';
        break;
}
```

### 18. Geplante Veröffentlichung (Cronjob)

```php
// Im Cronjob täglich
$entries = Entry::query()
    ->where('status', Entry::PLANNED)
    ->where('publishdate', date('Y-m-d H:i:s'), '<=')
    ->find();

foreach ($entries as $entry) {
    $entry->setStatus(Entry::ONLINE);
    $entry->save();
}
```

### 19. Neues::getList() für Frontend

```php
use FriendsOfRedaxo\Neues\Neues;

// Zeigt paginierte Liste mit Bootstrap 5 Fragmenten
echo Neues::getList(10, 'page'); // 10 pro Seite, GET-Parameter "page"
```

### 20. Neues::getEntry() für Detailseite

```php
$manager = Url\Url::resolveCurrent();
if ($manager) {
    $postId = $manager->getDatasetId();
    echo Neues::getEntry($postId);
} else {
    echo Neues::getList();
}
```

### 21. RSS-Feed einbinden

```php
// index.php?rex-api-call=neues_rss
// Standard-URL für RSS-Feed (alle Online-Einträge)
```

### 22. RSS-Feed nach Kategorie filtern

```php
// index.php?rex-api-call=neues_rss&category_id=3
```

### 23. RSS-Feed nach Sprache filtern

```php
// index.php?rex-api-call=neues_rss&lang_id=1
```

### 24. Schöne RSS-URLs (.htaccess)

```apache
RewriteRule ^feed/?$ index.php?rex-api-call=neues_rss [L]
RewriteRule ^feed/([^/]+)/?$ index.php?rex-api-call=neues_rss&category_id=$1 [L]
```

### 25. RSS-Feed programmatisch erstellen

```php
use FriendsOfRedaxo\Neues\Api\Rss;

$entries = Entry::findOnline(3); // Kategorie 3
$rss = Rss::createRssFeed($entries, 0, 1, 'News aus Kategorie 3');
```

### 26. Autor-Informationen

```php
$entry = Entry::get(42);
$author = $entry->getAuthor();
if ($author) {
    echo 'Von: ' . $author->getName();
    echo '<br>' . $author->getText(); // Bio
    
    // Verknüpfter Backend-User
    $user = $author->getUser();
    if ($user) {
        echo '<br>E-Mail: ' . $user->getValue('email');
    }
}
```

### 27. Alle Autoren auflisten

```php
use FriendsOfRedaxo\Neues\Author;

$authors = Author::query()->find();
foreach ($authors as $author) {
    echo '<h4>' . $author->getName() . '</h4>';
    echo '<p>' . $author->getText() . '</p>';
}
```

### 28. Kategorie-Übersicht

```php
use FriendsOfRedaxo\Neues\Category;

$categories = Category::query()->find();
foreach ($categories as $cat) {
    echo '<h3>' . $cat->getName() . '</h3>';
    $entries = $cat->getEntries();
    echo '<p>' . $entries->count() . ' Einträge</p>';
}
```

### 29. Domain-spezifische Einträge (YRewrite)

```php
$domainId = rex_yrewrite::getCurrentDomain()->getId();
$entries = Entry::query()
    ->whereListContains('domain_ids', $domainId)
    ->where('status', Entry::ONLINE)
    ->find();
```

### 30. Mehrsprachige Einträge

```php
$clangId = rex_clang::getCurrentId();
$entries = Entry::query()
    ->where('lang_id', $clangId)
    ->where('status', Entry::ONLINE)
    ->find();
```

### 31. Sprachvariante laden (EntryLang)

```php
use FriendsOfRedaxo\Neues\EntryLang;

$entryLang = EntryLang::query()
    ->where('entry_id', 42)
    ->where('clang_id', 1)
    ->findOne();

if ($entryLang) {
    echo $entryLang->getName();
    echo $entryLang->getDescription();
}
```

### 32. Canonical URL setzen

```php
$entry = Entry::get(42);
$entry->setCanonicalUrl('https://example.com/news/artikel');
$entry->save();

// Auslesen
echo $entry->getCanonicalUrl();
```

### 33. JSON+LD Schema.org

```php
$entry = Entry::get(42);
$fragment = new rex_fragment();
$fragment->setVar('entry', $entry);
echo $fragment->parse('neues/schema.json-ld.php');
```

### 34. Suche nach Stichworten

```php
$query = Entry::query()
    ->where('status', Entry::ONLINE)
    ->whereRaw('(name LIKE ? OR teaser LIKE ? OR description LIKE ?)', [
        '%Stichwort%',
        '%Stichwort%',
        '%Stichwort%'
    ])
    ->find();
```

### 35. Archiv nach Jahr/Monat

```php
$entries = Entry::query()
    ->where('status', Entry::ONLINE)
    ->whereRaw('YEAR(publishdate) = ?', [2025])
    ->whereRaw('MONTH(publishdate) = ?', [12])
    ->orderBy('publishdate', 'DESC')
    ->find();
```

> **Integration:** Neues arbeitet mit **URL-Addon** (sprechende URLs), **YRewrite** (Multi-Domain/Sprachen), **YForm** (Datenbank/Backend), **Media Manager** (Bilder), **REST-API** (externe Zugriffe) und **Cronjob-Addon** (geplante Veröffentlichung).
