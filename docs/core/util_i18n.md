# rex_i18n

Keywords: Übersetzung, Translation, Mehrsprachigkeit, Locales, Internationalisierung, i18n, Language Files

## Übersicht

`rex_i18n` verwaltet Übersetzungen im System. Lang-Files (`.lang`) aus Core und Addons werden geladen, gecacht und über Keys abgerufen. Unterstützt Fallback-Locales und Platzhalter `{0}`, `{1}` für dynamische Werte.

## Methoden

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `setLocale($locale)` | `string` | `void` | Setzt aktuelle Locale (z.B. `de_de`, `en_gb`) |
| `getLocale()` | - | `string` | Gibt aktuelle Locale zurück |
| `getLocales()` | - | `array` | Listet verfügbare Locales auf |
| `msg($key, ...)` | `string`, varargs | `string` | Übersetzt Key, HTML-escaped, mit Platzhaldern `{0}`, `{1}` |
| `rawMsg($key, ...)` | `string`, varargs | `string` | Übersetzt Key, NICHT escaped |
| `hasMsg($key)` | `string` | `bool` | Prüft ob Key in aktueller Locale existiert |
| `hasMsgOrFallback($key)` | `string` | `bool` | Prüft Key inkl. Fallback-Locales |
| `addMsg($key, $message)` | `string`, `string` | `void` | Fügt Übersetzung zur Laufzeit hinzu |
| `translate($text, $escape)` | `string`, `bool` | `string` | Übersetzt wenn Prefix `translate:` vorhanden |
| `translateArray($array, $escape)` | `array`, `bool` | `array` | Rekursive Übersetzung aller Array-Werte |
| `addDirectory($dir)` | `string` | `void` | Fügt Verzeichnis zu Lang-File-Pfaden hinzu |

## Praxisbeispiele

### Basis-Übersetzungen

```php
// Einfache Übersetzung
echo rex_i18n::msg('save'); // "Speichern"
echo rex_i18n::msg('delete'); // "Löschen"
echo rex_i18n::msg('cancel'); // "Abbrechen"
```

### Platzhalter mit dynamischen Werten

```php
// {0}, {1} werden durch folgende Parameter ersetzt
echo rex_i18n::msg('myaddon_items_found', $count);
// Lang-File: myaddon_items_found = {0} Einträge gefunden

echo rex_i18n::msg('yform_data_added', $tableName, $id);
// Lang-File: yform_data_added = Datensatz #{1} in Tabelle "{0}" angelegt
```

### Escaped vs. Raw

```php
// msg() escapt HTML automatisch
echo rex_i18n::msg('welcome_text'); // <strong>Tags</strong> werden escaped

// rawMsg() gibt ungefilterte Ausgabe
echo rex_i18n::rawMsg('html_content'); // <strong>Tags</strong> bleiben erhalten
echo rex_i18n::rawMsg('bs5_missing_addon', implode(', ', $addons));
```

### Backend-Meldungen mit rex_view

```php
// Kombiniert mit Backend-Messages
echo rex_view::success(rex_i18n::msg('myaddon_save_success'));
echo rex_view::error(rex_i18n::msg('myaddon_save_error'));
echo rex_view::warning(rex_i18n::msg('myaddon_outdated'));
```

### Locale setzen und abfragen

```php
// Aktuelle Locale ermitteln
$locale = rex_i18n::getLocale(); // "de_de"

// Locale temporär ändern (z.B. für E-Mails)
$oldLocale = rex_i18n::getLocale();
rex_i18n::setLocale('en_gb');
$subject = rex_i18n::msg('email_subject');
rex_i18n::setLocale($oldLocale);
```

### Verfügbare Locales prüfen

```php
// Alle installierten Sprachen listen
$locales = rex_i18n::getLocales(); // ['de_de', 'en_gb', 'fr_fr']

foreach ($locales as $locale) {
    rex_i18n::setLocale($locale);
    echo rex_i18n::msg('language_name'); // Lokalisierter Sprachname
}
```

### Keys prüfen (hasMsg)

```php
// Vor Ausgabe prüfen ob Übersetzung existiert
if (rex_i18n::hasMsg('myaddon_special_key')) {
    echo rex_i18n::msg('myaddon_special_key');
} else {
    echo 'Key not found';
}

// Mit Fallback-Prüfung
if (rex_i18n::hasMsgOrFallback('shared_key')) {
    echo rex_i18n::msg('shared_key'); // Auch aus Fallback-Locale
}
```

### Übersetzung zur Laufzeit hinzufügen

```php
// Dynamische Übersetzungen (nicht persistent)
rex_i18n::addMsg('temp_key', 'Temporärer Wert');
echo rex_i18n::msg('temp_key'); // "Temporärer Wert"

// In Loops für generierte Keys
foreach ($items as $id => $name) {
    rex_i18n::addMsg("item_{$id}", $name);
}
```

### translate() für bedingte Übersetzung

```php
// Übersetzt nur wenn "translate:" Prefix vorhanden
$value = 'translate:save_button';
echo rex_i18n::translate($value); // "Speichern" (escaped)

$value = 'Keine Übersetzung';
echo rex_i18n::translate($value); // "Keine Übersetzung" (escaped)

// Ohne Escaping
echo rex_i18n::translate('translate:html_text', false); // Raw HTML
```

### translateArray() für verschachtelte Arrays

```php
$config = [
    'title' => 'translate:page_title',
    'buttons' => [
        'save' => 'translate:save',
        'cancel' => 'translate:cancel',
    ],
    'count' => 42, // Bleibt unverändert
];

$translated = rex_i18n::translateArray($config);
// ['title' => 'Seitentitel', 'buttons' => ['save' => 'Speichern', ...], 'count' => 42]
```

### YForm-Labels übersetzen

```php
// MForm Beispiel mit i18n
$mform = new MForm();
$mform->addTextField(1, [
    'label' => rex_i18n::msg('bs5.module.mform.headline')
]);
$mform->addMediaField(2, [
    'label' => rex_i18n::msg('bs5.module.mform.image')
]);
```

### Backend-Listen mit Übersetzungen

```php
$list = rex_list::factory('SELECT id, name FROM table');
$list->setColumnLabel('id', rex_i18n::msg('id'));
$list->setColumnLabel('name', rex_i18n::msg('name'));

// Funktions-Spalten
$list->addColumn('edit', '<i class="rex-icon rex-icon-edit"></i>', 0, [
    '<a href="' . $list->getUrl(['func' => 'edit', 'id' => '###id###']) . '">'
        . rex_i18n::msg('edit')
        . '</a>'
]);
```

### Custom i18n-Function für translate()

```php
// Eigene Übersetzungsfunktion übergeben
$customI18n = function($key) {
    return "Custom: " . rex_i18n::msg($key);
};

$text = rex_i18n::translate('translate:welcome', true, $customI18n);
// "Custom: Willkommen"
```

### Addon Lang-Directory hinzufügen

```php
// In boot.php eines Addons
if (rex::isBackend()) {
    rex_i18n::addDirectory(rex_addon::get('myaddon')->getPath('lang'));
}

// Lang-Files: myaddon/lang/de_de.lang, myaddon/lang/en_gb.lang
// Format: key = Übersetzung
```

### Lang-File Format

```
# Kommentare mit #
save = Speichern
delete = Löschen
cancel = Abbrechen

# Mit Platzhaldern
myaddon_items_found = {0} Einträge gefunden
myaddon_user_greeting = Hallo {0}, du hast {1} Nachrichten

# Mehrzeilige Werte (nur eine Zeile!)
long_text = Dies ist ein langer Text ohne Zeilenumbrüche
```

### Formular-Validierung mit i18n

```php
if (empty($_POST['name'])) {
    $error = rex_i18n::msg('myaddon_name_required');
}

if (strlen($_POST['email']) < 5) {
    $error = rex_i18n::msg('myaddon_email_invalid');
}

if ($error) {
    echo rex_view::error($error);
}
```

### E-Mail-Vorlagen mehrsprachig

```php
function sendEmail($userId, $locale = 'de_de') {
    $oldLocale = rex_i18n::getLocale();
    rex_i18n::setLocale($locale);
    
    $subject = rex_i18n::msg('email_reset_subject');
    $body = rex_i18n::msg('email_reset_body', $userName, $resetLink);
    
    rex_mailer::factory()->setSubject($subject)->setBody($body)->send();
    
    rex_i18n::setLocale($oldLocale);
}
```

### Navigation mit Übersetzungen

```php
$nav = rex_be_navigation::factory();
$page = new rex_be_page('myaddon/main', rex_i18n::msg('myaddon_title'));
$page->setSubPath(rex_path::addon('myaddon', 'pages/main.php'));
$nav->addPage($page);

// Subpage
$subpage = new rex_be_page('myaddon/settings', rex_i18n::msg('myaddon_settings'));
$page->addSubpage($subpage);
```

### Fehlerbehandlung mit Fallback

```php
// getMsgFallback wird automatisch genutzt
// Fallback über rex::getProperty('lang_fallback')
rex::setProperty('lang_fallback', ['de_de', 'en_gb']);

// Wenn Key in de_de fehlt, wird en_gb durchsucht
echo rex_i18n::msg('rare_key');

// Eigener Fallback-Wert
$value = rex_i18n::hasMsg('optional_key') 
    ? rex_i18n::msg('optional_key') 
    : 'Default Value';
```

### rex_form Labels übersetzen

```php
$form = rex_form::factory('rex_table', '', 'id=' . $id);
$form->addTextField('name')->setLabel(rex_i18n::msg('name'));
$form->addTextAreaField('description')->setLabel(rex_i18n::msg('description'));

// Submit-Button
$form->setApplyUrl(rex_url::currentBackendPage());
$form->setSubmitButtonLabel(rex_i18n::msg('save'));
```

### Konsolen-Commands übersetzen

```php
class MyCommand extends rex_console_command {
    protected function configure() {
        $this->setDescription(rex_i18n::msg('myaddon_command_desc'));
        $this->setHelp(rex_i18n::msg('myaddon_command_help'));
    }
    
    protected function execute(InputInterface $input, OutputInterface $output) {
        $output->writeln(rex_i18n::msg('myaddon_command_success'));
    }
}
```

### Clang-spezifische Übersetzungen

```php
// rex_i18n ist systemweit, für Artikel-Content:
$clang = rex_clang::getCurrent();
$clangCode = $clang->getCode(); // "de", "en"

// Eigene Locale-Mapping
$localeMap = ['de' => 'de_de', 'en' => 'en_gb'];
rex_i18n::setLocale($localeMap[$clangCode] ?? 'de_de');
```

### Setup-Prozess mit i18n

```php
// Install.php - Sprache erkennen
$setupLocale = rex_request::request('lang', 'string', 'de_de');
rex_i18n::setLocale($setupLocale);

echo '<h1>' . rex_i18n::msg('setup_step_1') . '</h1>';
echo '<p>' . rex_i18n::msg('setup_db_config') . '</p>';
```
