# rex_list & rex_form

**Backend-Tabellen und Formulare**

**Keywords:** backend, list, form, crud, admin, table, fieldset

---

## rex_list – Methodenübersicht

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `factory()` | `string $query`, `int\|null $rowsPerPage = 30`, `string\|null $listName = null`, `bool $debug = false`, `int $db = 1`, `array $defaultSort = []` | `rex_list` | Erstellt Liste aus SQL-Query |
| `show()` | - | `void` | Ausgabe (echo) der kompletten Liste |
| `get()` | - | `string` | Gibt HTML-String zurück (kein echo) |
| `setCaption()` | `string $caption` | `void` | Tabellen-Überschrift |
| `setNoRowsMessage()` | `string $message` | `void` | Nachricht wenn keine Zeilen vorhanden |
| `addColumn()` | `string $columnHead`, `string $columnBody`, `int $columnIndex = -1`, `array\|null $columnLayout = null` | `void` | Custom-Spalte hinzufügen, `###field###` als Platzhalter |
| `removeColumn()` | `string $columnName` | `void` | Spalte ausblenden |
| `setColumnLabel()` | `string $columnName`, `string $label` | `void` | Spalten-Überschrift ändern |
| `setColumnFormat()` | `string $columnName`, `string $formatType`, `mixed $format = ''`, `array $params = []` | `void` | Formatierung: `'date'`, `'number'`, `'bytes'`, `'custom'` |
| `setColumnSortable()` | `string $columnName`, `string $direction = 'asc'` | `void` | Spalte sortierbar machen |
| `setColumnParams()` | `string $columnName`, `array $params = []` | `void` | Link-Parameter: `['id' => '###id###', 'func' => 'edit']` |
| `addLinkAttribute()` | `string $columnName`, `string $attrName`, `string\|int $attrValue` | `void` | HTML-Attribute für Links: `class`, `data-*` |
| `setColumnLayout()` | `string $columnHead`, `array $columnLayout` | `void` | Custom HTML: `['<th>###VALUE###</th>', '<td>###VALUE###</td>']` |
| `setRowAttributes()` | `array\|callable $attr` | `void` | `<tr>`-Attribute: Array oder Callback `function($list)` |
| `addParam()` | `string $name`, `string\|int $value` | `void` | URL-Parameter für alle Links |
| `addTableAttribute()` | `string $name`, `string\|int $value` | `void` | `<table>`-HTML-Attribute |
| `addTableColumnGroup()` | `array $columns`, `int\|null $columnGroupSpan = null` | `void` | `<colgroup>` für Spaltenbreiten: `[40, '*', 240]` |
| `getMessage()` | - | `string` | Status-Nachricht aus URL-Parameter `{listName}_msg` |
| `getWarning()` | - | `string` | Warnung aus URL-Parameter `{listName}_warning` |
| `getUrl()` | `array $params = []`, `bool $escape = true` | `string` | URL mit Standard-Parametern (sort, pagination) |

---

## rex_form – Methodenübersicht

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `factory()` | `string $tableName`, `string $fieldset`, `string $whereCondition`, `string $method = 'post'`, `bool $debug = false`, `int $db = 1` | `rex_form` | Erstellt Formular für DB-Tabelle |
| `show()` | - | `void` | Ausgabe (echo) des kompletten Formulars |
| `get()` | - | `string` | Gibt HTML-String zurück (kein echo) |
| `addFieldset()` | `string $fieldset`, `array $attributes = []` | `void` | Neues Fieldset (Abschnitt) |
| `addTextField()` | `string $name`, `mixed $value = null`, `array $attributes = []` | `rex_form_element` | Text-Eingabefeld |
| `addTextAreaField()` | `string $name`, `mixed $value = null`, `array $attributes = []` | `rex_form_element` | Mehrzeiliges Textfeld |
| `addReadOnlyField()` | `string $name`, `mixed $value = null`, `array $attributes = []` | `rex_form_element` | Nicht-editierbar (`<p>`) |
| `addReadOnlyTextField()` | `string $name`, `mixed $value = null`, `array $attributes = []` | `rex_form_element` | Read-only `<input>` (readonly-Attribut) |
| `addCheckboxField()` | `string $name`, `mixed $value = null`, `array $attributes = []` | `rex_form_checkbox_element` | Checkbox |
| `addRadioField()` | `string $name`, `mixed $value = null`, `array $attributes = []` | `rex_form_radio_element` | Radio-Buttons |
| `addSelectField()` | `string $name`, `mixed $value = null`, `array $attributes = []` | `rex_form_select_element` | Dropdown/Select |
| `addMediaField()` | `string $name`, `mixed $value = null`, `array $attributes = []` | `rex_form_widget_media_element` | Mediapool-Widget |
| `addMedialistField()` | `string $name`, `mixed $value = null`, `array $attributes = []` | `rex_form_widget_medialist_element` | Mediapool-Liste |
| `addLinkmapField()` | `string $name`, `mixed $value = null`, `array $attributes = []` | `rex_form_widget_linkmap_element` | Linkmap-Widget |
| `addLinklist Field()` | `string $name`, `mixed $value = null`, `array $attributes = []` | `rex_form_widget_linklist_element` | Linkmap-Liste |
| `addPrioField()` | `string $name`, `mixed $value = null`, `array $attributes = []` | `rex_form_prio_element` | Priorität-Verwaltung |
| `addContainerField()` | `string $name`, `mixed $value = null`, `array $attributes = []` | `rex_form_container_element` | Container für verschachtelte Felder |
| `addParam()` | `string $name`, `string\|int $value` | `void` | URL-Parameter (hidden fields) |
| `setLanguageSupport()` | `string $idField`, `string $clangField` | `void` | Mehrsprachigkeit aktivieren |
| `setApplyUrl()` | `string $url` | `void` | Redirect nach "Übernehmen"-Button |
| `setMessage()` | `string $msg` | `void` | Erfolgsmeldung anzeigen |
| `setWarning()` | `string $warning` | `void` | Warnung anzeigen |
| `isEditMode()` | - | `bool` | Prüft ob Edit-Modus (vs. Add-Modus) |
| `getSql()` | - | `rex_sql` | Zugriff auf rex_sql-Instanz |
| `getTableName()` | - | `string` | Tabellenname |

---

## Praxisbeispiele

### rex_list – Einfache Tabelle

```php
// Basis-Liste mit Pagination
$list = rex_list::factory('SELECT id, name, email, createdate FROM rex_user');

// Spalten-Labels
$list->setColumnLabel('id', 'ID');
$list->setColumnLabel('name', 'Benutzername');
$list->setColumnLabel('email', 'E-Mail');
$list->setColumnLabel('createdate', 'Erstellt am');

// Spalten sortierbar
$list->setColumnSortable('name');
$list->setColumnSortable('createdate', 'desc');

// Datumsformatierung
$list->setColumnFormat('createdate', 'custom', function($params) {
    return rex_formatter::intlDateTime($params['value'], IntlDateFormatter::SHORT);
});

// Ausgabe
$list->show();
```

### rex_list – Custom Spalten & Links

```php
$list = rex_list::factory('SELECT * FROM rex_article', 30);

// Icon-Spalte (ganz vorne)
$list->addColumn(
    '<i class="rex-icon rex-icon-article"></i>',
    '<i class="rex-icon rex-icon-article"></i>',
    0,
    ['<th class="rex-table-icon">###VALUE###</th>', '<td class="rex-table-icon">###VALUE###</td>']
);

// Aktions-Spalte mit Edit-Link
$list->addColumn('actions', '<i class="rex-icon rex-icon-edit"></i> Bearbeiten', -1);
$list->setColumnParams('actions', [
    'func' => 'edit',
    'id' => '###id###'
]);

// Delete-Spalte
$list->addColumn('delete', '<i class="rex-icon rex-icon-delete"></i> Löschen', -1);
$list->setColumnParams('delete', [
    'func' => 'delete',
    'id' => '###id###'
]);
$list->addLinkAttribute('delete', 'data-confirm', 'Wirklich löschen?');

$list->show();
```

### rex_list – Custom Formatierung & Platzhalter

```php
$list = rex_list::factory('SELECT id, status, downloads FROM rex_media');

// Platzhalter in Custom-Spalte
$list->addColumn('info', 'Datei #<strong>###id###</strong> (###downloads### Downloads)', 3);

// Status-Badge mit Custom Callback
$list->setColumnFormat('status', 'custom', function($params) {
    $badges = [
        0 => '<span class="rex-offline">Offline</span>',
        1 => '<span class="rex-online">Online</span>',
    ];
    return $badges[$params['value']] ?? '';
});

// Dateigröße formatieren
$list->setColumnFormat('filesize', 'bytes', [2]);

// Spalte ausblenden
$list->removeColumn('updatedate');

$list->show();
```

### rex_list – Zeilen-Attribute (Conditional Styling)

```php
$list = rex_list::factory('SELECT * FROM rex_article');

// Callback für <tr>-Attribute
$list->setRowAttributes(function($list) {
    $status = $list->getValue('status');
    $class = ($status == 1) ? 'rex-online' : 'rex-offline';
    return ['class' => $class];
});

// Oder als Array (statisch)
$list->setRowAttributes(['class' => 'rex-table-row']);

$list->show();
```

### rex_list – Spaltenbreiten mit colgroup

```php
$list = rex_list::factory('SELECT * FROM rex_user');

// Spaltenbreiten festlegen
$list->addTableColumnGroup([
    40,      // Icon-Spalte: 40px
    '*',     // Name: flexibel
    240,     // E-Mail: 240px
    140,     // Aktionen: 140px
]);

$list->show();
```

### rex_list – Ohne Pagination

```php
// Alle Zeilen auf einer Seite
$list = rex_list::factory(
    'SELECT * FROM rex_addon ORDER BY name',
    rex_list::DISABLE_PAGINATION
);

$list->show();
```

### rex_list – Nachrichten & Warnings

```php
$list = rex_list::factory('SELECT * FROM rex_media');

// Erfolgs-Nachricht nach Update
if (rex_get('updated', 'bool')) {
    $list->setMessage('Eintrag erfolgreich aktualisiert.');
}

// Warning
if (rex_get('error', 'bool')) {
    $list->setWarning('Fehler beim Speichern.');
}

// Nachrichten via URL-Parameter
// ?{listName}_msg=Erfolgreich&{listName}_warning=Achtung

echo $list->getMessage(); // Auto-Auslesen aus URL
echo $list->getWarning();

$list->show();
```

---

### rex_form – Einfaches Edit-Formular

```php
$func = rex_request('func', 'string');
$id = rex_request('id', 'int');

// WHERE-Condition für Edit/Add-Modus
if ('edit' == $func && $id) {
    $form = rex_form::factory('rex_user', 'Benutzer bearbeiten', 'id=' . $id);
} else {
    $form = rex_form::factory('rex_user', 'Benutzer anlegen', 'id=0');
}

// Felder
$form->addTextField('name')
    ->setLabel('Benutzername')
    ->setAttribute('class', 'form-control');

$form->addTextField('email')
    ->setLabel('E-Mail')
    ->setAttribute('placeholder', 'user@example.com');

$form->addSelectField('status')
    ->setLabel('Status')
    ->setSelect([0 => 'Offline', 1 => 'Online']);

$form->addTextAreaField('description')
    ->setLabel('Beschreibung')
    ->setAttribute('rows', 5);

$form->show();
```

### rex_form – Mehrsprachiges Formular

```php
$form = rex_form::factory('rex_article', 'Artikel', 'id=' . $id);

// Sprach-Support aktivieren
$form->setLanguageSupport('id', 'clang_id');

// Bei insert: Datensatz wird für alle Sprachen angelegt
// Bei update: Nur aktuelle Sprache wird aktualisiert

$form->addTextField('name')->setLabel('Name');
$form->addTextAreaField('content')->setLabel('Inhalt');

$form->show();
```

### rex_form – Widgets (Media, Linkmap)

```php
$form = rex_form::factory('rex_article', 'Artikel', 'id=' . $id);

// Mediapool-Widget (einzelne Datei)
$form->addMediaField('image')
    ->setLabel('Bild')
    ->setAttribute('preview', '1');

// Mediapool-Liste (mehrere Dateien)
$form->addMedialistField('gallery')
    ->setLabel('Bildergalerie');

// Linkmap-Widget (einzelner Artikel)
$form->addLinkmapField('redirect_article_id')
    ->setLabel('Weiterleitung');

// Linkmap-Liste (mehrere Artikel)
$form->addLinklistField('related_articles')
    ->setLabel('Verwandte Artikel');

$form->show();
```

### rex_form – Read-Only Felder & Prio

```php
$form = rex_form::factory('rex_article', 'Artikel', 'id=' . $id);

// Read-Only (als <p>)
$form->addReadOnlyField('id')
    ->setLabel('ID')
    ->setSuffix('<small>Auto-generiert</small>');

// Read-Only Input (als <input readonly>)
$form->addReadOnlyTextField('createdate')
    ->setLabel('Erstellt am');

// Priorität-Verwaltung
$form->addPrioField('prio')
    ->setLabel('Sortierung');

$form->show();
```

### rex_form – Checkbox & Radio

```php
$form = rex_form::factory('rex_config', 'Einstellungen', 'id=1');

// Checkbox
$field = $form->addCheckboxField('newsletter');
$field->addOption('Newsletter abonniert', 1);
$field->setLabel('Newsletter');

// Radio-Buttons
$field = $form->addRadioField('gender');
$field->addOptions([
    'm' => 'Männlich',
    'f' => 'Weiblich',
    'd' => 'Divers'
]);
$field->setLabel('Geschlecht');

$form->show();
```

### rex_form – Select mit Custom Options

```php
$form = rex_form::factory('rex_article', 'Artikel', 'id=' . $id);

// Einfache Select
$field = $form->addSelectField('status');
$field->setLabel('Status');
$field->setSelect([
    0 => 'Offline',
    1 => 'Online'
]);

// Select mit Datenbank-Daten
$sql = rex_sql::factory();
$sql->setQuery('SELECT id, name FROM rex_category ORDER BY name');

$categories = [];
foreach ($sql as $row) {
    $categories[$row->getValue('id')] = $row->getValue('name');
}

$field = $form->addSelectField('category_id');
$field->setLabel('Kategorie');
$field->setSelect($categories);

$form->show();
```

### rex_form – Mehrere Fieldsets

```php
$form = rex_form::factory('rex_article', 'Artikel', 'id=' . $id);

// Fieldset 1: Basis
$form->addFieldset('Basis-Informationen');
$form->addTextField('name')->setLabel('Name');
$form->addTextAreaField('description')->setLabel('Beschreibung');

// Fieldset 2: SEO
$form->addFieldset('SEO');
$form->addTextField('seo_title')->setLabel('Meta-Title');
$form->addTextAreaField('seo_description')->setLabel('Meta-Description');

// Fieldset 3: Einstellungen
$form->addFieldset('Einstellungen');
$form->addSelectField('status')->setSelect([0 => 'Offline', 1 => 'Online']);

$form->show();
```

### rex_form – Redirect nach Speichern

```php
$form = rex_form::factory('rex_article', 'Artikel', 'id=' . $id);

// URL für "Übernehmen"-Button
$form->setApplyUrl(rex_url::currentBackendPage(['func' => 'edit', 'id' => $id]));

// Nach "Speichern"-Button wird automatisch zur Übersicht weitergeleitet

$form->addTextField('name');
$form->show();
```

### rex_form – Validation & Custom Save

```php
class MyForm extends rex_form {
    protected function preSave($fieldsetName, $fieldName, $fieldValue, rex_sql $saveSql) {
        // Wert vor Speicherung manipulieren
        if ($fieldName == 'slug') {
            $fieldValue = rex_string::normalize($fieldValue, '-');
        }
        
        // updateuser/updatedate werden automatisch gesetzt
        return parent::preSave($fieldsetName, $fieldName, $fieldValue, $saveSql);
    }
}

$form = MyForm::factory('rex_article', 'Artikel', 'id=' . $id);
$form->addTextField('slug');
$form->show();
```

### rex_form – Extension Points

```php
// Nach Speichern
rex_extension::register('REX_FORM_SAVED', function(rex_extension_point $ep) {
    $form = $ep->getParam('form');
    $sql = $ep->getParam('sql');
    
    if ($form->getTableName() == 'rex_article') {
        // Cache leeren, Log schreiben, etc.
        rex_delete_cache();
    }
});

// Nach Löschen
rex_extension::register('REX_FORM_DELETED', function(rex_extension_point $ep) {
    $form = $ep->getParam('form');
    // Cleanup, Logging, etc.
});
```

---

## Kombination rex_list + rex_form

```php
$func = rex_request('func', 'string');
$id = rex_request('id', 'int');

if ($func == 'edit' || $func == 'add') {
    // Formular anzeigen
    $form = rex_form::factory('rex_article', 'Artikel', 'id=' . $id);
    $form->addTextField('name')->setLabel('Name');
    $form->show();
} else {
    // Liste anzeigen
    $list = rex_list::factory('SELECT * FROM rex_article');
    $list->setColumnLabel('name', 'Artikelname');
    
    // Edit-Button
    $list->addColumn('edit', '<i class="rex-icon rex-icon-edit"></i> Bearbeiten', -1);
    $list->setColumnParams('edit', ['func' => 'edit', 'id' => '###id###']);
    
    // Add-Button über der Liste
    $content = '<a href="' . rex_url::currentBackendPage(['func' => 'add']) . '" class="btn btn-primary">
        <i class="rex-icon rex-icon-add"></i> Artikel hinzufügen
    </a>';
    $content .= $list->get();
    
    $fragment = new rex_fragment();
    $fragment->setVar('title', 'Artikel-Übersicht');
    $fragment->setVar('body', $content, false);
    echo $fragment->parse('core/page/section.php');
}
```

---

**Best Practices:**

- `rex_list::factory()` → SQL möglichst einfach halten (JOINs via `setColumnFormat()` + Callback nachladen)
- `rex_form::factory()` → WHERE-Condition MUSS eindeutig sein (1 Datensatz)
- Custom Formatierung → `setColumnFormat('field', 'custom', function($params) { ... })`
- Spalten-Platzhalter → `###fieldname###` in `addColumn()` Body
- CSRF-Protection → Automatisch in rex_form integriert
- Mehrsprachigkeit → `setLanguageSupport()` vor `show()`

**Automatische Felder:**
`rex_form` setzt automatisch bei Speichern (wenn Spalten vorhanden):

- `updateuser` → `rex::requireUser()->getValue('login')`
- `updatedate` → aktueller Timestamp
- `createuser` → nur bei INSERT
- `createdate` → nur bei INSERT
