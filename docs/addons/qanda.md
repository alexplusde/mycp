# Q&A - Fragen & Antworten

**Keywords:** FAQ, Fragen, Antworten, Schema.org, JSON+LD, FAQPage, Kategorien, Mehrsprachigkeit

## Übersicht

Q&A ist ein YForm-basiertes FAQ-Addon mit Kategorien, Mehrsprachigkeit und automatischer Schema.org-Auszeichnung (FAQPage).

## Kern-Klassen

| Klasse | Beschreibung |
|--------|-------------|
| `Entry` | FAQ-Eintrag (Frage + Antwort) |
| `Category` | Kategorie für Gruppierung |
| `Lang` | Sprachvarianten |

## Klasse: Entry

### Wichtige Methoden

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|-------------|
| `::get($id)` | `int` | `Entry\|null` | Lädt Eintrag |
| `::query()` | - | `rex_yform_manager_query` | Query Builder |
| `::findByIds($ids, $status)` | `array, int` | `rex_yform_manager_collection` | Nach IDs filtern |
| `::findByCategoryIds($ids, $status)` | `array, int` | `rex_yform_manager_collection` | Nach Kategorie-IDs |
| `getQuestion($lang)` | `?int` | `string` | Frage (übersetzt) |
| `getAnswer($lang)` | `?int` | `string` | Antwort HTML |
| `getAnswerAsPlaintext($lang)` | `?int` | `string` | Antwort ohne HTML |
| `getCategory()` | - | `?Category` | Kategorie |
| `getCategories()` | - | `array` | Alle Kategorien |
| `getUrl($param)` | `?string` | `string` | Anker-URL (#question-header-{id}) |
| `getAuthor()` | - | `?rex_user` | Backend-Autor |
| `isOnline()` | - | `bool` | Status === ONLINE |

### Status-Konstanten

| Konstante | Wert | Beschreibung |
|-----------|------|-------------|
| `STATUS_OFFLINE` | `0` | Deaktiviert |
| `STATUS_ONLINE` | `1` | Veröffentlicht |

## Klasse: Category

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|-------------|
| `::get($id)` | `int` | `Category\|null` | Lädt Kategorie |
| `::findByIds($ids)` | `array` | `rex_yform_manager_collection` | Nach IDs |
| `getName()` | - | `string` | Name |
| `getAllQuestions($status)` | `?int` | `rex_yform_manager_collection` | Alle Fragen |

## Klasse: Lang

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|-------------|
| `getQuestion()` | - | `string` | Übersetzte Frage |
| `getAnswer()` | - | `string` | Übersetzte Antwort HTML |
| `getAnswerAsPlaintext()` | - | `string` | Antwort ohne Tags |
| `setQuestion($text)` | `string` | `self` | Frage setzen |
| `setAnswer($text)` | `string` | `self` | Antwort setzen |

## Praxisbeispiele

### 1. Frage/Antwort laden

```php
use Alexplusde\Qanda\Entry;

$question = Entry::get(42);
echo '<h3>' . $question->getQuestion() . '</h3>';
echo '<div>' . $question->getAnswer() . '</div>';
```

### 2. Alle Online-Fragen

```php
$questions = Entry::query()
    ->where('status', Entry::STATUS_ONLINE)
    ->orderBy('prio', 'ASC')
    ->find();
```

### 3. Nach IDs filtern

```php
$ids = [10, 20, 30];
$questions = Entry::findByIds($ids, Entry::STATUS_ONLINE);
```

### 4. Nach Kategorie filtern

```php
$categoryIds = [1, 2];
$questions = Entry::findByCategoryIds($categoryIds, Entry::STATUS_ONLINE);

foreach ($questions as $q) {
    echo '<h4>' . $q->getQuestion() . '</h4>';
    echo '<p>' . $q->getAnswerAsPlaintext() . '</p>';
}
```

### 5. Antwort ohne HTML

```php
$question = Entry::get(42);
$plain = $question->getAnswerAsPlaintext();
// Entfernt Tags, behält Zeilenumbrüche
```

### 6. JSON+LD für einzelne Frage

```php
$question = Entry::get(42);
$fragment = new rex_fragment();
$fragment->setVar('question', $question);
echo $fragment->parse('qanda/json-ld.php');
```

### 7. JSON+LD für FAQPage

```php
$questions = Entry::query()
    ->where('status', Entry::STATUS_ONLINE)
    ->find();

$fragment = new rex_fragment();
$fragment->setVar('questions', $questions);
echo $fragment->parse('qanda/FAQPage.json-ld.php');
```

### 8. Anker-URL generieren

```php
$question = Entry::get(42);
$url = $question->getUrl();
// Liefert '#question-header-42'
```

### 9. Mit Seiten-URL kombinieren

```php
$question = Entry::get(42);
$fullUrl = rex_getUrl(42) . $question->getUrl();
// Liefert '/faq/#question-header-42'
```

### 10. Kategorie-Übersicht

```php
use Alexplusde\Qanda\Category;

$categories = Category::query()->orderBy('name')->find();
foreach ($categories as $cat) {
    echo '<h2>' . $cat->getName() . '</h2>';
    $questions = $cat->getAllQuestions(Entry::STATUS_ONLINE);
    foreach ($questions as $q) {
        echo '<div>' . $q->getQuestion() . '</div>';
    }
}
```

### 11. Mehrsprachige Frage laden

```php
$question = Entry::get(42);
$clangId = rex_clang::getCurrentId();
echo $question->getQuestion($clangId);
echo $question->getAnswer($clangId);
```

### 12. Backend-Autor anzeigen

```php
$question = Entry::get(42);
$author = $question->getAuthor();
if ($author) {
    echo 'Autor: ' . $author->getName();
}
```

### 13. Neue Frage anlegen

```php
$entry = Entry::create();
$entry->setValue('question', 'Wie funktioniert X?');
$entry->setValue('answer', '<p>X funktioniert so...</p>');
$entry->setValue('category_ids', '1,3');
$entry->setValue('status', Entry::STATUS_ONLINE);
$entry->setValue('prio', 10);
$entry->save();
```

### 14. Kategorie mit Fragen

```php
$category = Category::get(3);
$questions = Entry::findByCategoryIds([3], Entry::STATUS_ONLINE);

echo '<section>';
echo '<h2>' . $category->getName() . '</h2>';
echo '<dl>';
foreach ($questions as $q) {
    echo '<dt id="question-header-' . $q->getId() . '">' . $q->getQuestion() . '</dt>';
    echo '<dd>' . $q->getAnswer() . '</dd>';
}
echo '</dl>';
echo '</section>';
```

### 15. FAQ-Seite mit Bootstrap 5 Accordion

```php
$questions = Entry::query()
    ->where('status', Entry::STATUS_ONLINE)
    ->orderBy('prio')
    ->find();

echo '<div class="accordion" id="faq">';
foreach ($questions as $i => $q) {
    echo '<div class="accordion-item">';
    echo '<h2 class="accordion-header" id="heading-' . $q->getId() . '">';
    echo '<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse-' . $q->getId() . '">';
    echo $q->getQuestion();
    echo '</button></h2>';
    echo '<div id="collapse-' . $q->getId() . '" class="accordion-collapse collapse" data-bs-parent="#faq">';
    echo '<div class="accordion-body">' . $q->getAnswer() . '</div>';
    echo '</div></div>';
}
echo '</div>';
```

### 16. Fragment-Integration

```php
$fragment = new rex_fragment();
$fragment->setVar('questions', Entry::findByCategoryIds([2], Entry::STATUS_ONLINE));
echo $fragment->parse('bs5/qanda/list.php');
```

### 17. Backend-Filter nach Status

```php
$drafts = Entry::query()
    ->where('status', Entry::STATUS_OFFLINE)
    ->find();
```

### 18. Übersetzung hinzufügen

```php
use Alexplusde\Qanda\Lang;

$lang = Lang::create();
$lang->setValue('entry_id', 42);
$lang->setValue('clang_id', 2); // Englisch
$lang->setQuestion('How does X work?');
$lang->setAnswer('<p>X works like this...</p>');
$lang->save();
```

### 19. Alle Kategorien einer Frage

```php
$question = Entry::get(42);
$categories = $question->getCategories();
foreach ($categories as $cat) {
    echo '<span class="badge">' . $cat->getName() . '</span>';
}
```

### 20. Suche in Fragen

```php
$searchTerm = 'Kündigung';
$questions = Entry::query()
    ->where('status', Entry::STATUS_ONLINE)
    ->whereRaw('(question LIKE ? OR answer LIKE ?)', ['%' . $searchTerm . '%', '%' . $searchTerm . '%'])
    ->find();
```

### 21. Schema.org JSON+LD (vollständig)

```php
$questions = Entry::findByCategoryIds([1], Entry::STATUS_ONLINE);
$data = [
    '@context' => 'https://schema.org',
    '@type' => 'FAQPage',
    'mainEntity' => []
];

foreach ($questions as $q) {
    $data['mainEntity'][] = [
        '@type' => 'Question',
        'name' => $q->getQuestion(),
        'acceptedAnswer' => [
            '@type' => 'Answer',
            'text' => $q->getAnswerAsPlaintext()
        ]
    ];
}

echo '<script type="application/ld+json">' . json_encode($data, JSON_UNESCAPED_UNICODE) . '</script>';
```

### 22. Priorität ändern

```php
$question = Entry::get(42);
$question->setValue('prio', 5);
$question->save();
```

### 23. Kategorie-Name anzeigen

```php
$question = Entry::get(42);
$category = $question->getCategory();
if ($category) {
    echo 'Kategorie: ' . $category->getName();
}
```

### 24. Fragen ohne Kategorie

```php
$questions = Entry::query()
    ->where('status', Entry::STATUS_ONLINE)
    ->whereRaw('category_ids = "" OR category_ids IS NULL')
    ->find();
```

### 25. REST-API Integration (wenn aktiviert)

```php
// GET /rest/qanda/entry/1.0.0/42
// Liefert JSON mit Frage/Antwort
```

> **Integration:** Q&A arbeitet mit **YForm** (Datenbank), **URL-Addon** (Anker-Links), **Schema.org** (FAQPage JSON+LD), **YRewrite** (Mehrsprachigkeit), **Plus BS5** (Bootstrap 5 Fragments) und nutzt `rex_clang` für Übersetzungen.
