# rex_string & rex_formatter

**String-Normalisierung, YAML-Handling, Datums-/Zahlenformatierung**

**Keywords:** normalize, slug, yaml, date, intl, number, bytes, truncate

---

## rex_string – Methodenübersicht

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `normalize()` | `string $string`, `string $replaceChar = '_'`, `string $allowedChars = ''` | `string` | Lowercase + Umlaut-Ersetzung (ä→ae), nur a-z0-9 + $allowedChars |
| `normalizeEncoding()` | `string $string` | `string` | UTF-8 NFD → NFC (OS X → Windows/Linux) |
| `split()` | `string $string` | `array` | Split by spaces, respektiert Quotes: `"a b 'c d'"` → `['a', 'b', 'c d']` |
| `buildQuery()` | `array $params`, `string $argSeparator = '&'` | `string` | URL-Querystring, verschachtelte Arrays möglich |
| `buildAttributes()` | `array $attributes` | `string` | HTML-Attribute: `['id' => 'test']` → `id="test"` |
| `yamlEncode()` | `array $value`, `int $inline = 3` | `string` | Array → YAML |
| `yamlDecode()` | `string $value` | `array` | YAML → Array (throws `rex_yaml_parse_exception`) |
| `size()` | `string $string` | `int` | Byte-Größe (8bit encoding) |
| `highlight()` | `string $string` | `string` | PHP-Code-Highlighting |
| `sanitizeHtml()` | `string $html` | `string` | XSS-Protection via AntiXSS |

---

## rex_formatter – Methodenübersicht

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `format()` | `string $value`, `string $formatType`, `mixed $format` | `string` | Dynamischer Aufruf: `format($val, 'date', 'd.m.Y')` |
| `date()` | `string\|int\|null $value`, `string $format = 'd.m.Y'` | `string` | `date()`-Formatierung |
| `intlDate()` | `string\|int\|DateTimeInterface\|null $value`, `int\|string\|null $format = IntlDateFormatter::MEDIUM` | `string` | Locale-aware Datum |
| `intlDateTime()` | `string\|int\|DateTimeInterface\|null $value`, `int\|array\|string\|null $format = [MEDIUM, SHORT]` | `string` | Locale-aware Datum+Zeit |
| `intlTime()` | `string\|int\|DateTimeInterface\|null $value`, `int\|string $format = IntlDateFormatter::SHORT` | `string` | Locale-aware Zeit |
| `number()` | `string\|float $value`, `array $format = [2, ',', ' ']` | `string` | Zahlenformatierung: `[decimals, dec_point, thousands_sep]` |
| `bytes()` | `string\|int $value`, `array $format = []` | `string` | Dateigröße: `1024` → `1 KiB` |
| `sprintf()` | `string $value`, `string $format = '%s'` | `string` | PHP `sprintf()` |
| `nl2br()` | `string $value` | `string` | `\n` → `<br>` |
| `truncate()` | `string $value`, `array $format = ['length' => 80, 'etc' => '…', 'break_words' => false]` | `string` | String kürzen |
| `widont()` | `string $value` | `string` | Hurenkind-Vermeidung (letztes Leerzeichen → `&#160;`) |
| `version()` | `string $value`, `string $format` | `string` | Version: `"5.17.1"` + `"%s.%s"` → `"5.17"` |
| `url()` | `string $value`, `array $format = ['attr' => '', 'params' => '']` | `string` | URL → `<a>`-Link |
| `email()` | `string $value`, `array $format = ['attr' => '', 'params' => '']` | `string` | E-Mail → `<a href="mailto:...">` |
| `custom()` | `string $value`, `callable\|array $format` | `string` | Custom Callable: `['MyClass::method', ['param' => 'val']]` |

---

## Praxisbeispiele

### rex_string – Slugs & Normalisierung

```php
// Dateiname-Normalisierung (Upload-Handling)
$filename = rex_string::normalize($_FILES['upload']['name']);
// "Über 50€ Sparen!.pdf" → "ueber_50_sparen_pdf"

// Slug mit Bindestrichen
$slug = rex_string::normalize($title, '-');
// "Hallo Welt!" → "hallo-welt"

// Erlaubte Zeichen definieren
$key = rex_string::normalize($input, '_', '.-');
// "my-file.2023" → "my-file.2023" (Punkte/Bindestriche erlaubt)

// Short-Key Generator (YForm, ID-Kombination)
$shortKey = rex_string::normalize($city . '_' . $id);
// "München_123" → "muenchen_123"
```

### rex_string – YAML-Handling

```php
// Config speichern
$config = ['api_key' => 'abc', 'timeout' => 30];
rex_file::put(
    rex_path::addonData('myaddon', 'config.yml'),
    rex_string::yamlEncode($config)
);

// Config laden
try {
    $yaml = rex_file::get(rex_path::addonData('myaddon', 'config.yml'));
    $config = rex_string::yamlDecode($yaml);
} catch (rex_yaml_parse_exception $e) {
    rex_logger::logException($e);
}
```

### rex_string – Query & Attribute Building

```php
// URL-Parameter (verschachtelt)
$params = [
    'func' => 'edit',
    'filter' => ['status' => 1, 'cat' => [2, 5]]
];
$query = rex_string::buildQuery($params);
// "func=edit&filter[status]=1&filter[cat][0]=2&filter[cat][1]=5"

// HTML-Attribute
$attrs = rex_string::buildAttributes([
    'id' => 'myform',
    'class' => ['form', 'form-horizontal'],
    'data-action' => 'submit'
]);
// ' id="myform" class="form form-horizontal" data-action="submit"'
```

### rex_string – Split mit Quotes

```php
// CLI-Parameter parsen
$input = "cmd --option='value with spaces' --flag";
$parts = rex_string::split($input);
// ['cmd', 'option' => 'value with spaces', 'flag']

// Form-Attribute parsen
$attrs = rex_string::split("class='btn btn-primary' disabled");
// ['class' => 'btn btn-primary', 'disabled']
```

### rex_formatter – Datumsformatierung (Locale-aware)

```php
// IntlDateFormatter (empfohlen, locale-aware)
echo rex_formatter::intlDate('2025-01-15');
// de: "15. Jan. 2025" | en: "Jan 15, 2025"

echo rex_formatter::intlDateTime('2025-01-15 14:30:00', IntlDateFormatter::SHORT);
// de: "15.01.25, 14:30" | en: "1/15/25, 2:30 PM"

// Mit Custom Pattern
echo rex_formatter::intlDateTime($timestamp, 'dd.MM.y HH:mm');
// "15.01.2025 14:30"

// Nur Zeit
echo rex_formatter::intlTime(time());
// de: "14:30" | en: "2:30 PM"

// Array-Format [DateFormat, TimeFormat]
echo rex_formatter::intlDateTime($date, [IntlDateFormatter::SHORT, IntlDateFormatter::MEDIUM]);
// de: "15.01.25, 14:30:00"
```

### rex_formatter – Backend-Listen

```php
// rex_list – Datumsspalten formatieren
$list->setColumnFormat('createdate', 'custom', function($params) {
    return rex_formatter::intlDateTime($params['value'], IntlDateFormatter::SHORT);
});

// rex_list – Dateigröße
$list->setColumnFormat('filesize', 'bytes', [2]);
// 1536000 → "1.46 MiB"

// rex_list – Zahlen
$list->setColumnFormat('price', 'number', [2, ',', '.']);
// 1234.5 → "1.234,50"
```

### rex_formatter – Truncate & Widont

```php
// Text kürzen (Snippet-Anzeige)
$short = rex_formatter::truncate($description, [
    'length' => 120,
    'etc' => '…',
    'break_words' => false // Wörter nicht trennen
]);

// Hurenkind vermeiden (typografisch)
$headline = rex_formatter::widont('Das ist eine lange Überschrift');
// "Das ist eine lange&#160;Überschrift" (letztes Space → nbsp)
```

### rex_formatter – Custom Formatter

```php
// Eigene Formatierung (YForm-Style)
rex_formatter::custom($value, function($val) {
    return '<span class="badge">' . strtoupper($val) . '</span>';
});

// Mit zusätzlichen Parametern
rex_formatter::custom($value, [
    'MyClass::formatStatus',
    ['classes' => 'badge badge-success']
]);

class MyClass {
    public static function formatStatus($params) {
        // $params['subject'] = $value
        // $params['classes'] = 'badge badge-success'
        return '<span class="' . $params['classes'] . '">' . $params['subject'] . '</span>';
    }
}
```

### rex_formatter – Version-Strings

```php
// Version kürzen
echo rex_formatter::version('5.17.1', '%s.%s');
// "5.17"

echo rex_formatter::version('2.1.3', 'v%s.%s.%s');
// "v2.1.3"
```

### rex_formatter – URL & E-Mail

```php
// URL-Link generieren
echo rex_formatter::url('example.com', [
    'attr' => ' target="_blank" rel="noopener"',
    'params' => 'ref=newsletter'
]);
// <a href="http://example.com?ref=newsletter" target="_blank" rel="noopener">http://example.com</a>

// E-Mail-Link
echo rex_formatter::email('info@example.com', [
    'params' => 'subject=Anfrage&body=Hallo...'
]);
// <a href="mailto:info@example.com?subject=Anfrage&body=Hallo...">info@example.com</a>
```

### Kombiniert – Dateiupload mit Normalisierung & Logging

```php
// Upload-Verarbeitung
$file = $_FILES['upload'];
$filename = rex_string::normalize($file['name'], '_', '.-');
$target = rex_path::addonData('uploads', $filename);

if (move_uploaded_file($file['tmp_name'], $target)) {
    $size = rex_formatter::bytes(filesize($target), [2]);
    $date = rex_formatter::intlDateTime(time());
    
    rex_logger::factory()->log(
        "Upload: {$filename} ({$size}) am {$date}",
        rex_logger::INFO
    );
}
```

---

**Sicherheit:**

- `rex_string::normalize()` → URL-sichere Slugs (keine Sonderzeichen)
- `rex_string::sanitizeHtml()` → XSS-Protection (AntiXSS-Library)
- `rex_string::buildAttributes()` → Auto-Escaping via `rex_escape()`
- `rex_formatter::url()` / `email()` → Auto-Escaping der Ausgabe

**Locale-Support:**

- `rex_formatter::intl*()` nutzen `Locale::getDefault()` (System-Locale)
- Timezone aus `date_default_timezone_get()` oder DateTimeInterface
- IntlDateFormatter-Konstanten: `NONE`, `SHORT`, `MEDIUM`, `LONG`, `FULL`
