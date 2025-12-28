# Form System

**Keywords:** Form Builder Input Field Config Settings Widget Media Linkmap Validation Backend

## Übersicht

Form-Builder-System für Backend-Formulare mit Field-Wrappern, Config-Persistierung und Media/Linkmap-Widgets.

## Methoden

### rex_form_base (Abstract)

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `__construct($fieldset, $name, $method, $debug)` | string, string, string, bool | - | Initialisiert Form (default: POST) |
| `addField($tag, $name, $value, $attributes)` | string, string, mixed, array | rex_form_element | Generisches Feld hinzufügen |
| `addTextField($name, $value, $attributes)` | string, mixed, array | rex_form_element | Text-Input (type="text") |
| `addInputField($type, $name, $value, $attributes)` | string, string, mixed, array | rex_form_element | Input mit custom type |
| `addHiddenField($name, $value, $attributes)` | string, mixed, array | rex_form_element | Hidden-Field |
| `addReadOnlyTextField($name, $value, $attributes)` | string, mixed, array | rex_form_element | Readonly Text-Input |
| `addReadOnlyField($name, $value, $attributes)` | string, mixed, array | rex_form_element | Paragraph mit Wert |
| `addTextAreaField($name, $value, $attributes)` | string, mixed, array | rex_form_element | Textarea (6 rows default) |
| `addSelectField($name, $value, $attributes)` | string, mixed, array | rex_form_select_element | Select/Dropdown |
| `addCheckboxField($name, $value, $attributes)` | string, mixed, array | rex_form_checkbox_element | Checkbox(en) |
| `addRadioField($name, $value, $attributes)` | string, mixed, array | rex_form_radio_element | Radio-Buttons |
| `addMediaField($name, $value, $attributes)` | string, mixed, array | rex_form_widget_media_element | Medienpool-Picker (single) |
| `addMedialistField($name, $value, $attributes)` | string, mixed, array | rex_form_widget_medialist_element | Medienpool-Liste (multi) |
| `addLinkmapField($name, $value, $attributes)` | string, mixed, array | rex_form_widget_linkmap_element | Struktur-Picker (single) |
| `addLinklistField($name, $value, $attributes)` | string, mixed, array | rex_form_widget_linklist_element | Struktur-Liste (multi) |
| `addControlField($save, $apply, $delete, $reset, $abort)` | Element, Element, Element, Element, Element | rex_form_control_element | Save/Apply/Delete-Buttons |
| `addRawField($html)` | string | rex_form_raw_element | Custom HTML einfügen |
| `addFieldset($legend)` | string | void | Fieldset-Gruppe hinzufügen |
| `addParam($name, $value)` | string, string\|int\|bool | void | URL-Parameter für Redirects |
| `getParams()` | - | array | Alle Form-Params |
| `setUrl($url)` | string | void | Form action URL |
| `getUrl()` | - | string | URL mit Params |
| `addErrorMessage($code, $message)` | int, string | void | Custom Error registrieren |
| `get()` | - | string | Rendert komplettes Form-HTML |

### rex_config_form

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `::factory($namespace, $fieldset)` | string, string\|null | rex_config_form | Factory mit rex_config-Namespace |
| `getValue($name, $default)` | string, mixed | mixed | Liest aus rex_config::get($namespace, $name) |
| `save()` | - | bool | Schreibt alle Felder zu rex_config |
| `delete()` | - | bool | Löscht Config-Werte |

### Form Elements

| Klasse | Beschreibung | Verwendung |
|--------|--------------|------------|
| `rex_form_element` | Basis-Element für Input/Textarea | Via addField/addTextField |
| `rex_form_select_element` | Select-Dropdown mit Options | addSelectField()->setSelect() |
| `rex_form_checkbox_element` | Checkbox(en) mit Optionen | addCheckboxField()->addOption() |
| `rex_form_radio_element` | Radio-Buttons | addRadioField()->addOption() |
| `rex_form_prio_element` | Priority-Sortierung | Prio-Feld mit rex_sql_util |
| `rex_form_container_element` | Container für verschachtelte Felder | addContainerField() |
| `rex_form_control_element` | Save/Apply/Delete-Buttons | addControlField() |
| `rex_form_raw_element` | Raw HTML | addRawField('<hr>') |
| `rex_form_widget_media_element` | Medienpool-Single-Picker | addMediaField() |
| `rex_form_widget_medialist_element` | Medienpool-Multi-Liste | addMedialistField() |
| `rex_form_widget_linkmap_element` | Struktur-Single-Picker | addLinkmapField() |
| `rex_form_widget_linklist_element` | Struktur-Multi-Liste | addLinklistField() |

## Praxisbeispiele

### Config-Formular erstellen

```php
// Addon-Settings mit rex_config_form
$form = rex_config_form::factory('myAddon');

// Text-Input
$field = $form->addTextField('api_key');
$field->setLabel('API Key');
$field->setNotice('Hier den API-Schlüssel eintragen');

// Textarea
$field = $form->addTextAreaField('custom_css');
$field->setLabel('Custom CSS');

// Select
$field = $form->addSelectField('environment');
$field->setLabel('Umgebung');
$select = $field->getSelect();
$select->addOption('Development', 'dev');
$select->addOption('Production', 'prod');

// Save-Button wird automatisch hinzugefügt
echo $form->get(); // Rendert komplettes Formular
```

### Werte aus Config abrufen

```php
// rex_config_form getValue nutzt rex_config
$form = rex_config_form::factory('myAddon');

// Liest aus rex_config::get('myAddon', 'api_key')
$apiKey = $form->getValue('api_key', 'default-key');

// Oder direkt:
$apiKey = rex_config::get('myAddon', 'api_key');
```

### Form mit Fieldsets

```php
$form = rex_config_form::factory('myAddon');

// Erstes Fieldset
$form->addFieldset('Allgemeine Einstellungen');
$form->addTextField('site_title');
$form->addTextAreaField('site_description');

// Zweites Fieldset
$form->addFieldset('API-Konfiguration');
$form->addTextField('api_key');
$form->addTextField('api_secret');

// Drittes Fieldset
$form->addFieldset('Design');
$form->addTextAreaField('custom_css');
$form->addCheckboxField('enable_dark_mode');

echo $form->get();
```

### Select mit Optionen

```php
$form = rex_config_form::factory('myAddon');

$field = $form->addSelectField('status');
$field->setLabel('Status');

$select = $field->getSelect();
$select->addOption('Aktiv', 1);
$select->addOption('Inaktiv', 0);
$select->addOption('Wartung', 2);
$select->setSelected(1); // Default-Wert

// Oder aus SQL
$sql = rex_sql::factory();
$select->addDBSqlOptions('SELECT id, name FROM rex_categories ORDER BY name');

echo $form->get();
```

### Checkbox/Radio mit Optionen

```php
$form = rex_config_form::factory('myAddon');

// Checkbox (Mehrfachauswahl)
$field = $form->addCheckboxField('enabled_features');
$field->setLabel('Aktivierte Features');
$field->addOption('Feature A', 'feature_a');
$field->addOption('Feature B', 'feature_b');
$field->addOption('Feature C', 'feature_c');

// Radio (Einzelauswahl)
$field = $form->addRadioField('payment_method');
$field->setLabel('Zahlungsmethode');
$field->addOption('PayPal', 'paypal');
$field->addOption('Kreditkarte', 'creditcard');
$field->addOption('Rechnung', 'invoice');

echo $form->get();
```

### Media-Widget

```php
$form = rex_config_form::factory('myAddon');

// Single Media
$field = $form->addMediaField('logo');
$field->setLabel('Logo');
$field->setNotice('Wählen Sie ein Logo aus dem Medienpool');

// Media-Liste (mehrere Dateien)
$field = $form->addMedialistField('slider_images');
$field->setLabel('Slider-Bilder');
$field->setNotice('Wählen Sie mehrere Bilder für den Slider');

echo $form->get();
```

### Linkmap-Widget (Struktur-Picker)

```php
$form = rex_config_form::factory('myAddon');

// Single Link
$field = $form->addLinkmapField('contact_page');
$field->setLabel('Kontaktseite');

// Link-Liste
$field = $form->addLinklistField('footer_links');
$field->setLabel('Footer-Links');

echo $form->get();
```

### ReadOnly-Felder

```php
$form = rex_config_form::factory('myAddon');

// ReadOnly Text-Input (grau, disabled)
$field = $form->addReadOnlyTextField('installation_date', date('d.m.Y'));
$field->setLabel('Installiert am');

// ReadOnly als Paragraph (nur Anzeige)
$field = $form->addReadOnlyField('version', rex::getVersion());
$field->setLabel('REDAXO Version');

echo $form->get();
```

### Hidden-Fields

```php
$form = rex_config_form::factory('myAddon');

// Hidden für Token/ID
$form->addHiddenField('csrf_token', rex_csrf_token::factory('myAddon')->getToken());
$form->addHiddenField('form_id', 'settings_form');

$form->addTextField('api_key');
$form->addTextField('api_secret');

echo $form->get();
```

### Custom Attributes

```php
$form = rex_config_form::factory('myAddon');

// Input mit Placeholder + Custom Class
$field = $form->addTextField('email', null, [
    'class' => 'form-control custom-input',
    'placeholder' => 'mail@example.com',
    'data-validate' => 'email'
]);
$field->setLabel('E-Mail');

// Number-Input mit Min/Max
$field = $form->addInputField('number', 'max_items', null, [
    'class' => 'form-control',
    'min' => 1,
    'max' => 100,
    'step' => 5
]);
$field->setLabel('Maximale Anzahl');

echo $form->get();
```

### Raw HTML einfügen

```php
$form = rex_config_form::factory('myAddon');

$form->addTextField('api_key');

// Custom HTML zwischen Feldern
$form->addRawField('<hr><p class="alert alert-info">Wichtiger Hinweis...</p>');

$form->addTextField('api_secret');

// Oder komplexe Widgets
$form->addRawField('
    <div class="form-group">
        <label>Custom Widget</label>
        <div id="custom-widget"></div>
        <script>initCustomWidget();</script>
    </div>
');

echo $form->get();
```

### Form URL & Params

```php
$form = rex_config_form::factory('myAddon');

// URL für Form-Action
$form->setUrl('index.php');

// Parameter für Redirects nach Save
$form->addParam('page', 'myAddon/settings');
$form->addParam('subpage', 'advanced');

$form->addTextField('api_key');

echo $form->get();

// Nach Save wird zu index.php?page=myAddon/settings&subpage=advanced redirected
```

### Control-Buttons anpassen

```php
$form = rex_config_form::factory('myAddon');

$form->addTextField('api_key');
$form->addTextAreaField('custom_css');

// Custom Control-Buttons
$form->addControlField(
    $save = new rex_form_element('submit', 'save', 'Speichern'),
    $apply = new rex_form_element('submit', 'apply', 'Übernehmen'),
    $delete = null, // Kein Delete-Button
    $reset = new rex_form_element('reset', 'reset', 'Zurücksetzen'),
    $abort = null
);

echo $form->get();
```

### Validierung & Error-Messages

```php
$form = rex_config_form::factory('myAddon');

// Custom Error-Messages registrieren
$form->addErrorMessage(1, 'API Key darf nicht leer sein');
$form->addErrorMessage(2, 'Ungültiges API Key-Format');

$form->addTextField('api_key');

// Bei save() prüfen
if ($form->save()) {
    echo rex_view::success('Gespeichert');
} else {
    // Fehler anzeigen
    echo rex_view::error('Fehler beim Speichern');
}
```

### Nested/Container-Fields

```php
$form = rex_config_form::factory('myAddon');

// Container für verschachtelte Felder
$container = $form->addContainerField('social_links');
$container->setLabel('Social Media Links');

// Felder im Container
$container->addField('text', 'facebook', null, ['placeholder' => 'Facebook URL']);
$container->addField('text', 'twitter', null, ['placeholder' => 'Twitter URL']);
$container->addField('text', 'instagram', null, ['placeholder' => 'Instagram URL']);

echo $form->get();
```

### Modul-Input mit MForm (ähnliches Konzept)

```php
// In modules/input.php: MForm nutzt ähnliche API
$mform = new MForm();

$mform->addTextField('1.headline', ['label' => 'Überschrift']);
$mform->addTextAreaField('2.text', ['label' => 'Text']);
$mform->addMediaField('3.image', ['label' => 'Bild']);
$mform->addLinkField('4.link', ['label' => 'Link']);

echo $mform->show();
```

### Addon-Settings-Page

```php
// In pages/settings.php
$addon = rex_addon::get('myAddon');
$form = rex_config_form::factory($addon->getName());

// Basis-Einstellungen
$form->addFieldset('Grundeinstellungen');

$field = $form->addTextField('api_key');
$field->setLabel('API Schlüssel');
$field->setAttribute('placeholder', 'Ihr API-Key');

$field = $form->addSelectField('mode');
$field->setLabel('Modus');
$select = $field->getSelect();
$select->addOptions(['Test' => 'test', 'Live' => 'live']);

// Erweiterte Einstellungen
$form->addFieldset('Erweiterte Einstellungen');

$field = $form->addCheckboxField('enable_logging');
$field->addOption('Logging aktivieren', 1);

$field = $form->addTextAreaField('custom_js', null, ['rows' => 10]);
$field->setLabel('Custom JavaScript');

// Fragment-Wrapper für Bootstrap-Layout
$fragment = new rex_fragment();
$fragment->setVar('class', 'edit', false);
$fragment->setVar('title', 'Einstellungen');
$fragment->setVar('body', $form->get(), false);
echo $fragment->parse('core/page/section.php');
```

### Save-Handling überschreiben

```php
// Eigene Config-Form-Klasse
class myAddon_config_form extends rex_config_form
{
    protected function save()
    {
        // Vor dem Speichern validieren
        $apiKey = $this->getValue('api_key');
        if (empty($apiKey)) {
            $this->addErrorMessage(1, 'API Key erforderlich');
            return false;
        }
        
        // API-Key testen
        if (!$this->validateApiKey($apiKey)) {
            $this->addErrorMessage(2, 'API Key ungültig');
            return false;
        }
        
        // Parent save aufrufen
        if (!parent::save()) {
            return false;
        }
        
        // Nach dem Speichern: Cache löschen
        rex_delete_cache();
        
        return true;
    }
    
    private function validateApiKey($key)
    {
        // API-Validierung
        return strlen($key) === 32;
    }
}

// Verwendung
$form = myAddon_config_form::factory('myAddon');
```

### Form in Fragment

```php
$form = rex_config_form::factory('myAddon');
$form->addTextField('setting1');
$form->addTextField('setting2');

// In Bootstrap-Section-Fragment wrappen
$fragment = new rex_fragment();
$fragment->setVar('title', 'Einstellungen');
$fragment->setVar('body', $form->get(), false);
echo $fragment->parse('core/page/section.php');
```

### Conditional Fields (mit JS)

```php
$form = rex_config_form::factory('myAddon');

// Toggle-Field
$field = $form->addCheckboxField('enable_api');
$field->addOption('API aktivieren', 1);
$field->setAttribute('id', 'enable-api-toggle');
$field->setAttribute('onchange', 'toggleApiFields()');

// API-Felder (initial hidden)
$form->addRawField('<div id="api-fields" style="display:none;">');

$field = $form->addTextField('api_key');
$field->setLabel('API Key');

$field = $form->addTextField('api_secret');
$field->setLabel('API Secret');

$form->addRawField('</div>');

// JavaScript
$form->addRawField('<script>
function toggleApiFields() {
    const enabled = document.getElementById("enable-api-toggle").checked;
    document.getElementById("api-fields").style.display = enabled ? "block" : "none";
}
// Initial state
toggleApiFields();
</script>');

echo $form->get();
```

### File-Upload-Field (Custom)

```php
$form = rex_config_form::factory('myAddon');

// Standard Input File
$field = $form->addInputField('file', 'import_file', null, [
    'accept' => '.json,.csv',
    'class' => 'form-control'
]);
$field->setLabel('Datei hochladen');

// Oder mit Media-Widget (empfohlen)
$field = $form->addMediaField('import_file');
$field->setLabel('Datei hochladen');
$field->setNotice('Wählen Sie eine JSON/CSV-Datei aus dem Medienpool');

echo $form->get();
```

### Color-Picker-Field

```php
$form = rex_config_form::factory('myAddon');

$field = $form->addInputField('color', 'primary_color', '#007bff', [
    'class' => 'form-control'
]);
$field->setLabel('Primärfarbe');

$field = $form->addInputField('color', 'secondary_color', '#6c757d', [
    'class' => 'form-control'
]);
$field->setLabel('Sekundärfarbe');

echo $form->get();
```

### Date/Time-Fields

```php
$form = rex_config_form::factory('myAddon');

// Date
$field = $form->addInputField('date', 'event_date', null, [
    'class' => 'form-control'
]);
$field->setLabel('Datum');

// Time
$field = $form->addInputField('time', 'event_time', null, [
    'class' => 'form-control'
]);
$field->setLabel('Uhrzeit');

// Datetime
$field = $form->addInputField('datetime-local', 'event_datetime', null, [
    'class' => 'form-control'
]);
$field->setLabel('Datum & Uhrzeit');

echo $form->get();
```

### Multi-Language Forms

```php
$form = rex_config_form::factory('myAddon');

// Felder pro Sprache
foreach (rex_clang::getAll() as $clang) {
    $form->addFieldset($clang->getName());
    
    $field = $form->addTextField('title_' . $clang->getId());
    $field->setLabel('Titel');
    
    $field = $form->addTextAreaField('description_' . $clang->getId());
    $field->setLabel('Beschreibung');
}

echo $form->get();
```

### Form mit CSRF-Token (automatisch)

```php
$form = rex_config_form::factory('myAddon');

// CSRF-Token wird automatisch von rex_form_base hinzugefügt
// Wird in loadBackendConfig() integriert

$form->addTextField('api_key');

echo $form->get();

// Token-Check erfolgt automatisch bei save()
```

### Delete-Button hinzufügen

```php
$form = rex_config_form::factory('myAddon');

$form->addTextField('api_key');
$form->addTextAreaField('custom_css');

// Control-Field mit Delete
$deleteElement = new rex_form_element('submit', 'delete', 'Alle Einstellungen löschen');
$deleteElement->setAttribute('data-confirm', 'Wirklich alle Einstellungen löschen?');

$form->addControlField(
    null, // Save (null = default Button)
    null, // Apply (null = default Button)
    $deleteElement, // Custom Delete
    null, // Reset
    null  // Abort
);

echo $form->get();

// Im Controller
if (rex_post('delete', 'bool')) {
    rex_config::removeNamespace('myAddon');
    echo rex_view::success('Alle Einstellungen gelöscht');
}
```

### Form-Element manipulieren nach Hinzufügen

```php
$form = rex_config_form::factory('myAddon');

// Element hinzufügen
$field = $form->addTextField('api_key');
$field->setLabel('API Key');
$field->setNotice('32-stelliger Schlüssel');

// Attribute nachträglich setzen
$field->setAttribute('maxlength', 32);
$field->setAttribute('pattern', '[A-Za-z0-9]{32}');
$field->setAttribute('required', 'required');
$field->setAttribute('data-validate', 'api-key');

// CSS-Klassen
$field->setAttribute('class', 'form-control monospace');

echo $form->get();
```

### Prio-Element (Sortierung)

```php
// rex_form_prio_element nutzt rex_sql_util::organizePriorities

class myAddon_form extends rex_form
{
    public function init()
    {
        // Prio-Feld für Sortierung
        $field = $this->addPrioField('prio');
        $field->setLabel('Reihenfolge');
        $field->setLabelField('name'); // Anzeige-Name
        $field->setWhereCondition('category_id = ' . $this->sql->getValue('category_id'));
    }
}
```

### Werte vor Save manipulieren

```php
class myAddon_config_form extends rex_config_form
{
    protected function save()
    {
        // Werte vor Save manipulieren
        $apiKey = $this->getValue('api_key');
        
        // Trimmen
        $apiKey = trim($apiKey);
        
        // Zurückschreiben (über rex_config)
        rex_config::set($this->namespace, 'api_key', $apiKey);
        
        // Parent save überspringen, da wir manuell speichern
        // oder: parent::save() aufrufen
        
        return true;
    }
}
```

### Formular ohne Config-Persistierung

```php
// Eigene Form-Klasse ohne rex_config
class myAddon_import_form extends rex_form_base
{
    public function __construct()
    {
        parent::__construct('Import', 'import-form', 'POST');
        
        // Felder hinzufügen
        $this->addMediaField('import_file');
        $this->addSelectField('format');
        
        $this->addControlField();
    }
    
    protected function save()
    {
        // Custom Save-Logik (z.B. Datei-Import)
        $file = $this->getValue('import_file');
        $format = $this->getValue('format');
        
        // Import durchführen
        // ...
        
        return true;
    }
}

// Verwendung
$form = new myAddon_import_form();
if ($form->save()) {
    echo rex_view::success('Import erfolgreich');
}
echo $form->get();
```
