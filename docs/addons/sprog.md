# Sprog - Keywords: Platzhalter, Wildcard, Übersetzung, Translation, Mehrsprachigkeit, i18n, Sprachbasis, Filter

## Übersicht

**Sprog** ist das Sprach-Addon für REDAXO und ermöglicht die Verwaltung von Platzhaltern (Wildcards) für Übersetzungen. Das Addon unterstützt Sprachbasen, Filter, automatische Synchronisierung von Struktur-Metadaten sowie das Kopieren von Inhalten zwischen Sprachen.

**Autor:** Thomas Blum  
**GitHub:** <https://github.com/tbaddade/redaxo_sprog>  
**Abhängigkeiten:** REDAXO >= 5.17  
**Empfohlen:** YForm, Structure/Content-Plugin

---

## Kern-Klassen

| Klasse | Beschreibung |
|--------|--------------|
| `Sprog\Wildcard` | Haupt-Klasse für Platzhalter-Verwaltung und -Ersetzung |
| `Sprog\Abbreviation` | Abkürzungen mit `<abbr>`-Tag |
| `Sprog\Extension` | Extension Points für Synchronisierung |
| `Sprog\Sync` | Synchronisierung von Artikel- und Kategorie-Metadaten |

---

## Sprog\Wildcard

| Methode | Beschreibung |
|---------|--------------|
| `get($wildcard, $clang_id = null)` | Gibt übersetzten Platzhalter zurück |
| `parse($content, $clang_id = null)` | Ersetzt alle Platzhalter im Content |
| `getOpenTag()` | Gibt öffnendes Tag zurück (default: `{{`) |
| `getCloseTag()` | Gibt schließendes Tag zurück (default: `}}`) |
| `getRegexp($value = '.*?')` | Gibt RegEx-Pattern für Platzhalter zurück |
| `isClangSwitchMode()` | Prüft, ob Sprach-Umschaltmodus aktiv |
| `getMissingWildcards()` | Findet fehlende Platzhalter in Slices |
| `getMissingWildcardsAsTable()` | Gibt fehlende Platzhalter als HTML-Tabelle zurück |

---

## Sprog\Abbreviation

| Methode | Beschreibung |
|---------|--------------|
| `parse($content, $clang_id = null)` | Ersetzt Abkürzungen mit `<abbr>`-Tag |

---

## Sprog\Sync

| Methode | Beschreibung |
|--------|--------------|
| `articleNameToCategoryName($params)` | Synchronisiert Artikelname → Kategoriename |
| `categoryNameToArticleName($params)` | Synchronisiert Kategoriename → Artikelname |
| `articleStatus($params)` | Synchronisiert Artikel-Status zwischen Sprachen |
| `categoryStatus($params)` | Synchronisiert Kategorie-Status zwischen Sprachen |
| `articleTemplate($params)` | Synchronisiert Template zwischen Sprachen |
| `categoryTemplate($params)` | Synchronisiert Kategorie-Template zwischen Sprachen |

---

## Datenbank-Tabellen

### rex_sprog_wildcard

| Spalte | Typ | Beschreibung |
|--------|-----|--------------|
| `pid` | int | Primärschlüssel (Auto-Increment) |
| `id` | int | Platzhalter-ID (gleich für alle Sprachen) |
| `clang_id` | int | Sprach-ID |
| `wildcard` | varchar(255) | Platzhalter-Name (ohne Tags) |
| `replace` | text | Übersetzung |
| `createdate` | datetime | Erstellt am |
| `updatedate` | datetime | Aktualisiert am |
| `createuser` | varchar(255) | Erstellt von |
| `updateuser` | varchar(255) | Aktualisiert von |
| `revision` | int | Versions-Nummer |

### rex_sprog_abbreviation

| Spalte | Typ | Beschreibung |
|--------|-----|--------------|
| `id` | int | Primärschlüssel |
| `clang_id` | int | Sprach-ID |
| `abbreviation` | varchar(255) | Abkürzung |
| `text` | text | Ausgeschriebener Text |
| `status` | tinyint(1) | Status (aktiv/inaktiv) |
| `createdate` | datetime | Erstellt am |
| `updatedate` | datetime | Aktualisiert am |

---

## Wildcard-Modus

Sprog bietet zwei Modi für die Platzhalter-Verwaltung:

### Clang-Switch-Modus (Standard)

- Separate Backend-Ansicht pro Sprache
- Alle Sprachen haben dieselbe `id`, nur unterschiedliche `clang_id`
- Platzhalter-Name kann nur in Admin-Ansicht geändert werden
- Empfohlen für die meisten Projekte

### Clang-All-Modus

- Eine Tabelle zeigt alle Sprachen auf einmal
- Alle Felder direkt editierbar
- Übersichtlicher bei wenigen Sprachen
- Aktivieren unter: System → Sprog → Einstellungen

---

## 30 Praxisbeispiele

### 1. Einfacher Platzhalter ausgeben

```php
echo Wildcard::get('hello');
// Ausgabe: Hallo (in DE)
// Ausgabe: Hello (in EN)
```

### 2. Platzhalter mit Helper-Funktion

```php
echo sprogcard('company_name');
// Kurzform für: Wildcard::get('company_name')
```

### 3. Text mit mehreren Platzhaltern

```php
$text = '{{ greeting }}, {{ username }}! {{ welcome_message }}';
echo Wildcard::parse($text);
```

### 4. Platzhalter für spezifische Sprache

```php
// Deutsches Impressum
$imprintDE = Wildcard::get('imprint', 1);

// Englisches Impressum
$imprintEN = Wildcard::get('imprint', 2);
```

### 5. Template mit Platzhaltern

```php
<!DOCTYPE html>
<html lang="<?= rex_clang::getCurrent()->getCode() ?>">
<head>
    <title><?= Wildcard::get('page_title') ?></title>
    <meta name="description" content="<?= Wildcard::get('meta_description') ?>">
</head>
<body>
    <h1><?= Wildcard::get('headline') ?></h1>
    <?= $this->getArticle() ?>
    <footer>
        <p><?= Wildcard::get('copyright') ?></p>
    </footer>
</body>
</html>
```

### 6. Platzhalter mit HTML

```php
// Backend: Platzhalter "footer_text"
// Eingabe: <p>© 2025 <strong>Meine Firma</strong></p>

// Frontend
echo Wildcard::get('footer_text');
// Ausgabe: <p>© 2025 <strong>Meine Firma</strong></p>
```

### 7. Platzhalter mit Filter (lowercase)

```php
// {{ company_name | lowercase }}
$text = '{{ company_name | lowercase }}';
echo Wildcard::parse($text);
// Ausgabe: musterfirma gmbh (statt Musterfirma GmbH)
```

### 8. Platzhalter mit Filter (uppercase)

```php
// {{ heading | uppercase }}
echo sprogdown('{{ heading | uppercase }}');
// Ausgabe: WILLKOMMEN
```

### 9. Platzhalter mit Filter (markdown)

```php
// {{ about_text | markdown }}
// Wandelt Markdown in HTML um
$text = sprogdown('{{ about_text | markdown }}');
```

### 10. Custom Filter registrieren

```php
// boot.php
rex_extension::register('SPROG_FILTER', function(rex_extension_point $ep) {
    $filters = $ep->getSubject();
    
    $filters['uppercase'] = function($value) {
        return mb_strtoupper($value);
    };
    
    $filters['excerpt'] = function($value, $length = 100) {
        return mb_substr(strip_tags($value), 0, $length) . '...';
    };
    
    return $filters;
});
```

### 11. Filter mit Parametern

```php
// {{ long_text | excerpt(50) }}
// Kürzt Text auf 50 Zeichen
echo sprogdown('{{ long_text | excerpt(50) }}');
```

### 12. Sprachfeld-Helper (sprogfield)

```php
// Statt:
$name_de = $item->getValue('name_1');
$name_en = $item->getValue('name_2');

// Besser:
$name = $item->getValue(sprogfield('name'));
// Automatisch: name_1 bei clang_id=1, name_2 bei clang_id=2
```

### 13. Sprogfield in YOrm-Dataset

```php
class MyDataset extends \rex_yform_manager_dataset
{
    public function getName()
    {
        return trim($this->{sprogfield('name')});
    }
    
    public function getDescription()
    {
        return $this->{sprogfield('description')};
    }
}
```

### 14. Sprogvalue-Helper

```php
$data = [
    'title_1' => 'Deutscher Titel',
    'title_2' => 'English Title',
    'text_1' => 'Deutscher Text',
    'text_2' => 'English Text'
];

// Gibt Wert für aktuelle Sprache zurück
$title = sprogvalue($data, 'title');
$text = sprogvalue($data, 'text');
```

### 15. Sprogarray-Helper

```php
$data = [
    'title_1' => 'DE Titel',
    'title_2' => 'EN Title',
    'text_1' => 'DE Text',
    'text_2' => 'EN Text',
    'author' => 'Max Mustermann' // Kein Sprachfeld
];

// Fügt Felder ohne Suffix hinzu
$data = sprogarray($data, ['title', 'text']);

// Jetzt verfügbar:
// $data['title'] => aktueller Titel (abhängig von clang_id)
// $data['text'] => aktueller Text
```

### 16. Synchronisation: Artikelname → Kategoriename

```php
// boot.php oder Project-Addon
rex_config::set('sprog', 'sync_structure_article_name_to_category_name', true);

// Bei Artikel-Speicherung wird Kategoriename automatisch aktualisiert
```

### 17. Synchronisation: Status zwischen Sprachen

```php
rex_config::set('sprog', 'sync_structure_status', true);

// Artikel in DE auf "online" setzen → auch in EN "online"
```

### 18. Synchronisation: Template zwischen Sprachen

```php
rex_config::set('sprog', 'sync_structure_template', true);

// Template-Änderung in DE → automatisch in allen Sprachen
```

### 19. Sprachbasis definieren

```php
// Backend: System → Sprog → Einstellungen
// Sprachbasis für EN: DE (1)

// Platzhalter "hello" nur in DE gepflegt
// EN nutzt automatisch DE-Version, wenn kein EN-Wert vorhanden
$clangBase = rex_config::get('sprog', 'clang_base');
// ['1' => 1, '2' => 1] -> EN (2) nutzt DE (1) als Basis
```

### 20. Fehlende Platzhalter finden

```php
// Backend: Sprog → Platzhalter
// Am Ende der Seite: "Fehlende Platzhalter"
// Zeigt alle {{ wildcards }} aus Slices, die noch nicht angelegt sind
$missing = Wildcard::getMissingWildcards();
dump($missing);
```

### 21. Platzhalter-Tags anpassen

```php
// package.yml oder boot.php
rex_config::set('sprog', 'wildcard_open_tag', '[[');
rex_config::set('sprog', 'wildcard_close_tag', ']]');

// Jetzt: [[ hello ]] statt {{ hello }}
```

### 22. Inhalte von Sprache A nach B kopieren

```php
// Backend: Sprog → Inhalte kopieren → Struktur & Inhalte
// Quelle: Deutsch (1)
// Ziel: Englisch (2)
// → Kopiert alle Slices von DE nach EN
```

### 23. Metadaten synchronisieren

```php
// Backend: Sprog → Inhalte kopieren → Struktur-Metadaten
// Synchronisiert: Name, Kategorie-Name, Prio, Status, Template
// Nützlich nach großen Struktur-Änderungen in einer Sprache
```

### 24. Platzhalter exportieren (CSV)

```php
// Backend: Sprog → Import/Export → Export
// Erzeugt CSV mit Spalten: wildcard, de, en, fr, ...
// Für Übersetzungsbüros
```

### 25. Platzhalter importieren (CSV)

```php
// Backend: Sprog → Import/Export → Import
// CSV hochladen
// Automatische Sprach-Erkennung via Language-Code (de, en, fr)
// Optional: Fehlende Sprachen automatisch anlegen
```

### 26. Extension Point: Wildcard-Ersetzung anpassen

```php
rex_extension::register('OUTPUT_FILTER', function($ep) {
    $content = $ep->getSubject();
    
    // Eigene Logik vor Sprog
    $content = str_replace('[[CUSTOM]]', 'Custom Value', $content);
    
    // Sprog-Wildcards ersetzen
    $content = Wildcard::parse($content);
    
    return $content;
});
```

### 27. Abbreviations (Abkürzungen)

```php
// Backend: Sprog → Abbreviations
// Abkürzung: REDAXO
// Text: REDAXO Content Management System
// Status: Aktiv

// Frontend (automatisch via Extension Point):
// REDAXO -> <abbr title="REDAXO Content Management System">REDAXO</abbr>
```

### 28. Wildcard in REX_VALUE

```php
// Modul OUTPUT
$text = 'REX_VALUE[1]';
$text = Wildcard::parse($text);
echo $text;

// Ermöglicht Redakteuren Platzhalter zu nutzen:
// Eingabe: Willkommen bei {{ company_name }}
// Ausgabe: Willkommen bei Musterfirma GmbH
```

### 29. Platzhalter in YForm-Formularen

```php
// YForm Pipe-Schreibweise
text|name|{{ form_label_name }}

// PHP-Schreibweise
$yform->setValueField('text', [
    'name',
    Wildcard::get('form_label_name')
]);
```

### 30. Clang-Switch deaktivieren (Alle Sprachen in einer Tabelle)

```php
// Backend: System → Sprog → Einstellungen
// "Sprachen pro Unterseite anzeigen" deaktivieren

// Alternative via boot.php:
rex_config::set('sprog', 'wildcard_clang_switch', false);

// Jetzt: Backend → Sprog → Platzhalter
// Zeigt Tabelle mit allen Sprachen auf einmal
```

---

## Konfiguration

| Config-Key | Typ | Beschreibung | Default |
|------------|-----|--------------|---------|
| `wildcard_open_tag` | string | Öffnendes Platzhalter-Tag | `'{{ '` |
| `wildcard_close_tag` | string | Schließendes Platzhalter-Tag | `' }}'` |
| `wildcard_clang_switch` | bool | Sprach-Umschaltmodus aktiv | `true` |
| `clang_base` | array | Sprachbasen-Zuordnung (clang_id => basis_clang_id) | `[]` |
| `sync_structure_article_name_to_category_name` | bool | Artikelname → Kategoriename sync | `false` |
| `sync_structure_category_name_to_article_name` | bool | Kategoriename → Artikelname sync | `false` |
| `sync_structure_status` | bool | Status zwischen Sprachen sync | `false` |
| `sync_structure_template` | bool | Template zwischen Sprachen sync | `false` |

---

## Backend-Seiten

1. **Sprog → Platzhalter:** Verwaltung aller Wildcards (Clang-Switch oder All-Modus)
2. **Sprog → Abbreviations:** Verwaltung von Abkürzungen
3. **Sprog → Inhalte kopieren:**
   - **Struktur & Inhalte:** Slices von Sprache A nach B kopieren
   - **Struktur-Metadaten:** Metadaten synchronisieren
4. **Sprog → Import/Export:**
   - **Export:** CSV-Export aller Wildcards
   - **Import:** CSV-Import mit automatischer Sprach-Erkennung
5. **System → Sprog:** Einstellungen (Tags, Clang-Switch, Sync-Optionen)

---

## Filter

### Standard-Filter

| Filter | Beschreibung | Beispiel |
|--------|--------------|----------|
| `lowercase` | Kleinbuchstaben | `{{ text \| lowercase }}` |
| `uppercase` | Großbuchstaben | `{{ text \| uppercase }}` |
| `markdown` | Markdown → HTML | `{{ content \| markdown }}` |

### Custom Filter erstellen

```php
// boot.php
rex_extension::register('SPROG_FILTER', function($ep) {
    $filters = $ep->getSubject();
    
    // Neuer Filter
    $filters['truncate'] = function($value, $length = 100, $suffix = '...') {
        if (mb_strlen($value) > $length) {
            return mb_substr($value, 0, $length) . $suffix;
        }
        return $value;
    };
    
    return $filters;
});

// Verwendung
echo sprogdown('{{ long_text | truncate(50, "…") }}');
```

---

## Sprachbasis-System

### Konzept

- Eine Sprache (z.B. EN) kann eine andere (z.B. DE) als "Basis" definieren
- Fehlt in EN ein Platzhalter-Wert, wird automatisch DE verwendet
- Spart Pflegeaufwand bei redundanten Übersetzungen

### Einrichtung

```php
// Backend: System → Sprog → Einstellungen → Sprachbasis
// Für Sprache "EN (2)": Wähle "DE (1)"

// Programmatisch:
rex_config::set('sprog', 'clang_base', [
    2 => 1,  // EN nutzt DE als Basis
    3 => 1   // FR nutzt DE als Basis
]);
```

### Beispiel

```php
// Platzhalter "contact_phone" nur in DE gepflegt
// DE: +49 123 456789
// EN: (leer)

// Frontend in EN:
echo Wildcard::get('contact_phone', 2);
// Ausgabe: +49 123 456789 (Fallback auf DE)
```

---

## CSV-Import/Export

### Export-Format

```csv
wildcard,de,en,fr
company_name,Musterfirma GmbH,Sample Company Ltd,Société Exemple
contact_email,info@beispiel.de,info@example.com,info@exemple.fr
```

### Import-Optionen

- **Fehlende Sprachen hinzufügen:** Erstellt automatisch neue Sprachen aus CSV-Spalten
- **Fehlende Sprachen ignorieren:** Überspringt unbekannte Sprachcodes

---

## Extension Points

| Extension Point | Beschreibung |
|-----------------|--------------|
| `SPROG_FILTER` | Custom Filter registrieren |
| `ART_UPDATED` | Artikel-Synchronisierung (via `Sprog\Extension`) |
| `CAT_UPDATED` | Kategorie-Synchronisierung (via `Sprog\Extension`) |
| `CLANG_ADDED` | Neue Sprache: Wildcards aus Startsprache kopieren |
| `CLANG_DELETED` | Wildcards der gelöschten Sprache entfernen |
| `OUTPUT_FILTER` | Wildcard-Ersetzung im Frontend |

---

## Helper-Funktionen

| Funktion | Beschreibung |
|----------|--------------|
| `sprogcard($wildcard, $clang_id = null)` | Kurzform für `Wildcard::get()` |
| `sprogdown($text, $clang_id = null)` | Kurzform für `Wildcard::parse()` |
| `sprogfield($field, $separator = '_')` | Feldname mit Sprach-Suffix (z.B. `name_1`) |
| `sprogvalue($array, $field, $fallback_clang_id = 0)` | Wert aus Array mit Sprach-Suffix |
| `sprogarray($array, $fields, $fallback_clang_id = 0)` | Mehrere Felder mit Suffix hinzufügen |

---

## Hinweise

⚠️ **Platzhalter-Namen:** Keine Leer- oder Sonderzeichen, nur `a-z`, `0-9`, `_`, `-`

⚠️ **Clang-Switch-Modus:** Admin-Berechtigung erforderlich zum Ändern von Wildcard-Namen

⚠️ **Sync-Funktionen:** Vorsicht bei Aktivierung - automatische Änderungen über alle Sprachen!

⚠️ **Sprachbasis:** Gut bei wenigen Unterschieden, kann aber redundante Daten verschleiern

⚠️ **Performance:** Bei vielen Platzhaltern (> 500) kann Parsing langsam werden → Caching empfohlen

---

## Verwandte Addons

- [YForm](yform.md) - Mehrsprachige Felder mit Sprog-Helpers
- [YRewrite](yrewrite.md) - URL-Management für Mehrsprachigkeit
- [Structure/Content](structure.md) - Struktur-Synchronisierung

---

**GitHub:** <https://github.com/tbaddade/redaxo_sprog>
