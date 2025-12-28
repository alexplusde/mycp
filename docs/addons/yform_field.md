# YForm Field - Zusätzliche Feldtypen | Keywords: Forms, Validation, Custom Fields, Extensions, Input, Widgets, Actions

**Übersicht**: Erweitert YForm um 30+ zusätzliche Feldtypen, Validierungen und Actions. Bietet spezialisierte Eingabefelder für Geodaten, OpenAI-Integration, HTML5-Inputs, Custom-Links und mehr für professionelle Formulare.

## Zusätzliche Feldtypen (Auswahl)

| Feldtyp | Beschreibung |
|---------|-------------|
| `datetime_local` | HTML5-Eingabefeld für Datum + Uhrzeit |
| `datalist` | HTML5-Textfeld mit Auswahlvorschlägen ohne Validierung |
| `number_lat` | Breitengrad-Eingabe (-90°...90°) mit Präzision |
| `number_lng` | Längengrad-Eingabe (-180°...180°) mit Präzision |
| `domain` | Auswahlfeld mit System-Domain und YRewrite-Domains |
| `choice_html` | Erlaubt HTML in choice-Labels (Bilder, Icons) |
| `custom_link` | Link-Widget für mehrere Link-Typen (intern, extern, Media, YForm) |
| `privacy_policy` | Checkbox mit Link für AGB/Datenschutz |
| `tabs` | Gruppiert Formular-Felder in Tabs |
| `be_user_select` | REDAXO-Benutzer zuordnen |
| `form_url` | Erfasst URL, von der Formular abgeschickt wurde |
| `openai_prompt` | KI-Texterweiterung via OpenAI API |
| `openai_spellcheck` | Rechtschreib-/Grammatikprüfung via OpenAI |
| `thumbnail_hqapi` | Screenshots von Webseiten via HQAPI |
| `radio` / `radio_sql` | YForm 3 radio-Felder mit/ohne SQL |
| `select` / `select_sql` | YForm 3 select-Felder mit/ohne SQL |
| `seo_title` | SEO-Titel aus Feldern kombiniert |
| `datestamp_offset` | Datestamp mit Offset in die Zukunft |

## Zusätzliche Validierungen

| Validierung | Beschreibung |
|------------|-------------|
| `pwned` | Passwörter gegen "Have I Been Pwned"-API prüfen |

## Zusätzliche Actions

| Action | Beschreibung |
|--------|-------------|
| `attach` | Anhänge an E-Mails hängen |
| `attach_file` | Statische Dateien aus addon_data als Anhang |
| `attach_signature` | Signatur-Feld als Anhang |
| `conversion_push` | Google Ads Conversion-Tracking |
| `history_push` | URL/Titel in Browser-Verlauf einfügen |
| `to_session` | Formularwerte in Session speichern |

## number_lat / number_lng Parameter

| Parameter | Beschreibung |
|-----------|-------------|
| `precision` | Gesamtzahl der Stellen (Standard: 10/11) |
| `scale` | Dezimalstellen (Standard: 8) |
| `widget` | `input:text` oder `input:number` |
| `unit` | Einheit anzeigen (z.B. "°") |

## custom_link Optionen

| Option | Beschreibung |
|--------|-------------|
| `intern` | REDAXO-Artikel (Linkmap) |
| `external` | Externe URLs (http/https) |
| `media` | Medienpool-Dateien |
| `mailto` | E-Mail-Adressen |
| `phone` | Telefonnummern (tel:) |
| `yurl` | YForm-Datensätze (URL-Addon) |

## Praxisbeispiele

### Beispiel 1: datetime_local Feld

```php
// Pipe-Schreibweise
value|datetime_local|event_datetime|Veranstaltungsdatum|2024-01-01T00:00|2024-12-31T23:59|1|0||Notice

// TableSet
$field = [
    'type' => 'value',
    'type_id' => 'datetime_local',
    'name' => 'event_datetime',
    'label' => 'Veranstaltungsdatum',
    'min' => '2024-01-01T00:00',
    'max' => '2024-12-31T23:59',
    'current_date' => '1'
];
```

### Beispiel 2: Geodaten mit number_lat und number_lng

```php
// Breitengrad
value|number_lat|latitude|Breitengrad|10|8|input:number|°

// Längengrad
value|number_lng|longitude|Längengrad|11|8|input:number|°

// Ausgabe
$dataset = MyTable::get($id);
echo 'Koordinaten: ' . $dataset->getLatitude() . ', ' . $dataset->getLongitude();
```

### Beispiel 3: datalist mit Vorschlägen

```php
// Pipe-Schreibweise
value|datalist|city|Stadt|Berlin,München,Hamburg,Köln,Frankfurt

// Datalist akzeptiert auch freie Eingaben!
$dataset->setCity('Meine Stadt'); // Funktioniert auch ohne Vorschlag
```

### Beispiel 4: domain Auswahlfeld

```php
// Pipe-Schreibweise
value|domain|selected_domain|Domain auswählen|1||Notice

// Zeigt System-Domain + alle YRewrite-Domains an
// Multiple-Auswahl möglich

// Ausgabe
$domains = explode(',', $dataset->getSelectedDomain());
foreach ($domains as $domainId) {
    $domain = rex_yrewrite::getDomainById($domainId);
    echo $domain->getName() . '<br>';
}
```

### Beispiel 5: choice_html mit Bildern

```php
// Pipe-Schreibweise
value|choice_html|product|Produkt auswählen|
<img src="/media/product1.jpg"> Produkt 1=1,
<img src="/media/product2.jpg"> Produkt 2=2,
<img src="/media/product3.jpg"> Produkt 3=3
|0|0||Notice

// HTML im Label wird gerendert!
```

### Beispiel 6: custom_link Widget

```php
// Pipe-Schreibweise
value|custom_link|link|Link setzen|1|1|1|1|1||1

// Parameter: media|mailto|external|intern|phone|types|category|media_category|yurl

// Ausgabe im Template
$link = $dataset->getLink();
// Ausgabe: {"type":"internal","value":"5"} oder {"type":"media","value":"image.jpg"}

$linkData = json_decode($link, true);
if ($linkData['type'] == 'internal') {
    echo rex_getUrl($linkData['value']);
} elseif ($linkData['type'] == 'media') {
    echo rex_url::media($linkData['value']);
}
```

### Beispiel 7: privacy_policy Checkbox

```php
// Pipe-Schreibweise
value|privacy_policy|accept_privacy|Datenschutz|0|{"class":"form-check-input"}|Notice|1=Akzeptiert|Ich akzeptiere die|Datenschutzerklärung|5

// Parameter: name|label|no_db|attributes|notice|output_values|text|linktext|article_id

// Erzeugt: "Ich akzeptiere die <a href="/datenschutz">Datenschutzerklärung</a>"
```

### Beispiel 8: tabs für Formular-Gruppierung

```php
// Tab 1: Allgemein (erste Tab-Definition)
value|tabs|tab_general|Allgemein|1|general

value|text|title|Titel
value|textarea|description|Beschreibung

// Tab 2: SEO (mittlerer Tab)
value|tabs|tab_seo|SEO|2|general

value|text|seo_title|SEO-Titel
value|textarea|seo_description|SEO-Beschreibung

// Tab schließen (letzter Tab ohne Label)
value|tabs|tab_end||3|general

// Tabs mit group_by können mehrere Tab-Sets erstellen
```

### Beispiel 9: be_user_select

```php
// Pipe-Schreibweise
value|be_user_select|assigned_user|Verantwortlicher|0

// Zeigt alle Backend-Benutzer zur Auswahl
// Im Gegensatz zu be_user (setzt automatisch aktuellen User)

// Ausgabe
$userId = $dataset->getAssignedUser();
$user = rex_user::get($userId);
echo 'Verantwortlich: ' . $user->getName();
```

### Beispiel 10: form_url - Von wo wurde abgeschickt?

```php
// Pipe-Schreibweise
value|form_url|submitted_from|0

// Speichert automatisch die URL der Seite, von der das Formular abgeschickt wurde
// Nützlich für Statistiken bei seitenübergreifenden Formularen

// Ausgabe
echo 'Formular abgeschickt von: ' . $dataset->getSubmittedFrom();
```

### Beispiel 11: openai_prompt für KI-Erweiterung

```php
// Pipe-Schreibweise
value|openai_prompt|ai_description|KI-Beschreibung|YOUR_API_KEY|title,category|description|1|Erstelle eine SEO-optimierte Produktbeschreibung aus dem Titel und der Kategorie.|Du bist ein Marketing-Experte.|Titel: {title}, Kategorie: {category}

// Parameter: name|label|api_key|fields|target_field|overwrite|prompt_text|system_message|user_message_template

// Felder {title} und {category} werden in Prompt eingefügt
// Ergebnis wird in description gespeichert
```

### Beispiel 12: openai_spellcheck

```php
// Pipe-Schreibweise
value|openai_spellcheck|text_corrected|Korrektur|YOUR_API_KEY|text

// Parameter: name|label|api_key|field

// Korrigiert Rechtschreibung/Grammatik im Feld "text"
// Ergebnis wird in "text_corrected" gespeichert
```

### Beispiel 13: thumbnail_hqapi für Screenshots

```php
// Pipe-Schreibweise
value|thumbnail_hqapi|screenshot|Screenshot|url|screenshot_data|YOUR_API_KEY|dark|1|1920|1080|1000|png|0

// Parameter: source_url_field|target_field|api_key|theme|full_page|browser_width|browser_height|delay|format|mobile

// Erstellt Screenshot von URL im Feld "url"
// Speichert base64-Daten in "screenshot_data"
```

### Beispiel 14: radio mit YForm 3 Kompatibilität

```php
// Pipe-Schreibweise
value|radio|gender|Geschlecht|Frau=w,Herr=m,Divers=d|m|{"class":"form-check-input"}|Notice|0

// Wie YForm 3, auch in YForm 4 verfügbar
```

### Beispiel 15: select mit SQL-Abfrage

```php
// Pipe-Schreibweise
value|select_sql|category_id|Kategorie|SELECT id, name FROM rex_category ORDER BY name|||0

// SQL-Query holt Optionen dynamisch aus Datenbank
```

### Beispiel 16: seo_title für URL-Addon

```php
// Pipe-Schreibweise
value|seo_title|url_title|SEO-Titel|title,category_name| - ||1

// Parameter: name|label|fields|separator|salt|add_this_param

// Kombiniert Felder "title" und "category_name" mit " - "
// Perfekt für URL-Addon Slugs
```

### Beispiel 17: datestamp_offset

```php
// Pipe-Schreibweise
value|datestamp_offset|expires_at|Ablaufdatum|30|days|1

// Parameter: name|label|offset_value|offset_unit|show_value

// Setzt Datum automatisch 30 Tage in die Zukunft
// Units: minutes, hours, days, weeks, months, years
```

### Beispiel 18: attach_file Action

```php
// Pipe-Schreibweise
action|attach_file|agb.pdf,mein_addon/docs/agb.pdf|0

// Parameter: filename,path|replace

// Hängt statische Datei aus rex_path::addonData() an E-Mail an
// replace=1 ersetzt bisherige Anhänge
```

### Beispiel 19: conversion_push für Google Ads

```php
// Pipe-Schreibweise
action|conversion_push|google_ads|conversion|AW-XXXXXXXXX/XXXXXXXXXXXXXXXXXXXX|999|EUR

// Parameter: platform|event|send_to|value|currency

// Wichtig: Google Tag Manager muss initialisiert sein
// Erstellt Event 'gtagLoaded' wenn gtag.js geladen
```

### Beispiel 20: history_push Action

```php
// Pipe-Schreibweise
action|history_push|/danke|Vielen Dank!

// Parameter: url|title

// Fügt URL/Titel in Browser-Verlauf ein
// Nützlich für Single-Page-Formulare
```

### Beispiel 21: to_session Action

```php
// Pipe-Schreibweise
action|to_session|form_data

// Parameter: session_key

// Speichert alle Formularwerte in $_SESSION['form_data']
// Abruf: $_SESSION['form_data']['fieldname']
```

### Beispiel 22: pwned Passwort-Validierung

```php
// Pipe-Schreibweise
validate|pwned|password|Das Passwort wurde in Datenlecks gefunden!

// Prüft Passwort gegen "Have I Been Pwned"-API
// Warnt bei kompromittierten Passwörtern
```

### Beispiel 23: be_manager_relation_set mit SET

```php
// Pipe-Schreibweise (wie be_manager_relation)
value|be_manager_relation_set|categories|Kategorien|rex_category|name|1

// Unterschied: Datenbankfeldtyp SET statt TEXT
// Speichert Mehrfachauswahl als MySQL SET
```

### Beispiel 24: showvalue_extended

```php
// Pipe-Schreibweise
value|showvalue_extended|preview|Vorschau|<strong>Standard</strong>|Info-Text

// Parameter: name|label|defaultwert|notice

// Wie showvalue, aber mit mehr DB-Typen (text, varchar, mediumtext, longtext)
```

### Beispiel 25: UUID-Feld

```php
// Aus install/yform/uuid.php
value|uuid|unique_id|0|1

// Parameter: name|no_db|show_value

// Generiert automatisch UUIDv4
// Format: xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
```

### Beispiel 26: Custom Link mit YForm-Datensätzen

```php
// custom_link mit YForm-URL-Addon
value|custom_link|link|Link|0|0|0|0|0||0|0|1

// yurl=1 aktiviert YForm-Dataset-Linking

// Ausgabe mit URL-Addon
$linkData = json_decode($dataset->getLink(), true);
if ($linkData['type'] == 'yform') {
    // Format: rex-yf-{table}://{id}
    // Z.B.: rex-yf-rex_news://5
    $url = \Url\Url::get($linkData['value']);
    echo '<a href="' . $url . '">Link</a>';
}
```

### Beispiel 27: Tabs mit Fehlermarkierung

```php
// Tab-System zeigt Fehler visuell
value|tabs|tab1|Allgemein|1|mygroup
value|text|title|Titel
validate|empty|title|Titel ist Pflichtfeld!

value|tabs|tab2|Details|2|mygroup
value|text|description|Beschreibung

value|tabs|tab_end||3|mygroup

// Bei Validierungsfehler wird Tab "Allgemein" rot markiert und aktiviert
```

### Beispiel 28: number_lat mit Validierung

```php
// Breitengrad mit Präzision 10, Scale 8
value|number_lat|latitude|Breitengrad|10|8|input:number|°||{"step":"0.00000001"}

// Automatische Validierung: -90 bis +90
// DECIMAL(10,8) in Datenbank
```

### Beispiel 29: datalist vs select

```php
// datalist: Freie Eingabe MÖGLICH
value|datalist|city|Stadt|Berlin,München,Hamburg

// select: Freie Eingabe NICHT möglich
value|select|city|Stadt|Berlin=berlin,München=muenchen,Hamburg=hamburg

// datalist für flexible Eingaben
// select für strenge Vorgaben
```

### Beispiel 30: Kombiniertes Formular mit mehreren Custom-Feldtypen

```php
// Tab 1: Geodaten
value|tabs|tab_geo|Standort|1|form

value|text|address|Adresse
value|number_lat|lat|Breitengrad|10|8|input:number|°
value|number_lng|lng|Längengrad|11|8|input:number|°

// Tab 2: Kontakt
value|tabs|tab_contact|Kontakt|2|form

value|text|name|Name
validate|empty|name|Name erforderlich!

value|custom_link|website|Website|0|1|1|0|1
value|datalist|city|Stadt|Berlin,München,Hamburg,Köln

// Tab 3: Datenschutz
value|tabs|tab_privacy|Datenschutz|3|form

value|privacy_policy|accept_dsgvo|DSGVO|0||Notice||Ich akzeptiere die|Datenschutzerklärung|5
validate|empty|accept_dsgvo|Bitte akzeptieren!

// Tab Ende
value|tabs|tab_end||4|form

// Actions
value|form_url|source_url|0
action|to_session|form_data
action|attach_file|info.pdf,myaddon/docs/info.pdf
action|conversion_push|google_ads|conversion|AW-XXX/YYY|1|EUR
```

**Integration**: YForm Core, YForm Manager, Table Manager, Media Manager (custom_link), URL-Addon (custom_link, yurl, seo_title), OpenAI API (openai_prompt, openai_spellcheck), HQAPI (thumbnail_hqapi), "Have I Been Pwned" API (pwned), Google Tag Manager (conversion_push), YRewrite (domain), Session (to_session), Browser History API (history_push)
