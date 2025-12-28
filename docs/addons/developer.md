# Developer - Dateisystem-Synchronisation

**Keywords:** Developer, Sync, Synchronisation, Template, Modul, Action, Dateisystem, Git, Versionskontrolle, Console

## Übersicht

Developer synchronisiert Templates, Module und Actions zwischen Datenbank und Dateisystem für die Arbeit mit externen Editoren und Git-Versionskontrolle.

## Kern-Klassen

| Klasse | Beschreibung |
|--------|-------------|
| `rex_developer_manager` | Manager für alle Synchronizer (Start/Register) |
| `rex_developer_synchronizer` | Abstract-Klasse für Sync-Implementierungen |
| `rex_developer_synchronizer_default` | Standard-Synchronizer für DB-Tabellen |
| `rex_developer_synchronizer_item` | Repräsentiert ein Sync-Item |
| `rex_developer_command` | Console-Command für CLI-Sync |

## Manager-Methoden

| Methode | Rückgabe | Beschreibung |
|---------|----------|-------------|
| `rex_developer_manager::start($force)` | void | Startet Synchronisation |
| `rex_developer_manager::synchronize($type, $force)` | void | Führt Synchronisation aus |
| `rex_developer_manager::register($sync, $start)` | void | Registriert Synchronizer |
| `rex_developer_manager::setBasePath($path)` | void | Setzt Basis-Pfad |
| `rex_developer_manager::getBasePath()` | string | Gibt Basis-Pfad zurück |

## Synchronizer-Item-Methoden

| Methode | Rückgabe | Beschreibung |
|---------|----------|-------------|
| `getId()` | int | Item-ID |
| `getName()` | string | Item-Name |
| `getUpdated()` | int | Timestamp der letzten Änderung |
| `getFiles()` | array | Alle Dateien mit Content |
| `getFile($file)` | string | Content einer Datei |
| `setFile($file, $content)` | void | Setzt Datei-Content |

## Synchronizer-Force-Modi

| Konstante | Beschreibung |
|-----------|-------------|
| `rex_developer_synchronizer::FORCE_DB` | Datenbank überschreibt Dateien |
| `rex_developer_synchronizer::FORCE_FILES` | Dateien überschreiben Datenbank |

## Praxisbeispiele

### 1. Standard-Ordnerstruktur

```text
redaxo/data/addons/developer/
├── templates/
│   ├── Startseite [1]/
│   │   ├── 1.rex_id
│   │   ├── metadata.yml
│   │   └── template.php
│   └── Navigation [2]/
│       ├── 2.rex_id
│       ├── metadata.yml
│       └── template.php
├── modules/
│   ├── Hero Slider [10]/
│   │   ├── 10.rex_id
│   │   ├── metadata.yml
│   │   ├── input.php
│   │   └── output.php
│   └── Kontaktformular [11]/
│       ├── 11.rex_id
│       ├── metadata.yml
│       ├── input.php
│       └── output.php
└── actions/
    └── SEO Meta Tags [5]/
        ├── 5.rex_id
        ├── metadata.yml
        ├── preview.php
        ├── presave.php
        └── postsave.php
```

### 2. Template metadata.yml

```yaml
name: Startseite
key: homepage
active: true
attributes:
  ctype: []
  ctypes:
    - "1"
    - "2"
  categories:
    - "1"
```

### 3. Modul metadata.yml

```yaml
name: Hero Slider
key: hero_slider
```

### 4. Action metadata.yml

```yaml
name: SEO Meta Tags
previewmode: 1
presavemode: 0
postsavemode: 1
```

### 5. Console-Command

```bash
php redaxo/bin/console developer:sync
# Synchronizes developer files.
```

### 6. Force DB (Dateien überschreiben)

```bash
php redaxo/bin/console developer:sync --force-db
```

### 7. Force Files (Datenbank überschreiben)

```bash
php redaxo/bin/console developer:sync --force-files
```

### 8. Eigenen Synchronizer registrieren

```php
$synchronizer = new rex_developer_synchronizer_default(
    'custom_table',
    rex::getTable('my_custom'),
    ['content' => 'content.php'],
    ['status' => 'int', 'priority' => 'int']
);

rex_developer_manager::register($synchronizer);
```

### 9. Synchronizer mit Callback

```php
$synchronizer = new rex_developer_synchronizer_default(
    'modules',
    rex::getTable('module'),
    ['input' => 'input.php', 'output' => 'output.php']
);

$synchronizer->setEditedCallback(function (rex_developer_synchronizer_item $item) {
    // Alle Artikel mit diesem Modul aus Cache löschen
    rex_article_cache::deleteAll();
});

$synchronizer->setDeletedCallback(function (rex_developer_synchronizer_item $item) {
    // Log-Eintrag erstellen
    rex_logger::factory()->log('developer', 'Module deleted: ' . $item->getName());
});

rex_developer_manager::register($synchronizer);
```

### 10. Custom Base Path

```php
rex_developer_manager::setBasePath(rex_path::data('my_custom_path'));
```

### 11. Metadata-Spalten definieren

```php
$synchronizer = new rex_developer_synchronizer_default(
    'templates',
    rex::getTable('template'),
    ['content' => 'template.php'],
    [
        'key' => 'string',
        'active' => 'boolean',
        'attributes' => 'json'
    ]
);
```

### 12. ID-Spalte anpassen

```php
$synchronizer = new rex_developer_synchronizer_default(
    'custom_table',
    rex::getTable('my_table'),
    ['content' => 'content.php']
);

$synchronizer->setIdColumn('uid');
$synchronizer->setNameColumn('title');
$synchronizer->setUpdatedColumn('modified_at');
```

### 13. Extension Point DEVELOPER_MANAGER_START

```php
rex_extension::register('DEVELOPER_MANAGER_START', function($ep) {
    // Custom Synchronizer registrieren
    $sync = new rex_developer_synchronizer_default(...);
    rex_developer_manager::register($sync);
});
```

### 14. Template programmatisch erstellen

```text
redaxo/data/addons/developer/templates/Custom Template [99]/
├── 99.rex_id
├── metadata.yml
└── template.php
```

metadata.yml:

```yaml
name: Custom Template
key: custom
active: true
```

template.php:

```php
<?php
echo '<h1>Custom Template</h1>';
```

### 15. Modul programmatisch erstellen

```text
redaxo/data/addons/developer/modules/Dynamic Module [100]/
├── 100.rex_id
├── metadata.yml
├── input.php
└── output.php
```

### 16. Dateinamen mit Präfix

Backend-Einstellung: "Präfix aktivieren"

```text
templates/
└── Startseite [1]/
    ├── 1.rex_id
    ├── metadata.yml
    └── 1.Startseite.template.php
```

### 17. Custom Dateinamen

```text
modules/Hero Slider [10]/
├── 10.rex_id
├── metadata.yml
├── hero-slider-backend.input.php
└── hero-slider-frontend.output.php
```

Developer erkennt `*.input.php` und `*.output.php` automatisch.

### 18. Ordner-Suffix mit ID

Backend-Einstellung: "ID-Suffix aktivieren"

```text
templates/
├── Startseite [1]/
└── Navigation [2]/
```

### 19. Automatische Umbenennung deaktivieren

Backend-Einstellung: "Automatische Umbenennung" deaktivieren

Dann können Ordner beliebig umbenannt werden (Zuordnung über .rex_id):

```text
modules/
└── my-custom-folder-name/
    ├── 10.rex_id
    ├── metadata.yml
    ├── input.php
    └── output.php
```

### 20. Item aus Dateisystem löschen

Bei aktivierter Option "Ordner automatisch löschen":

1. Im Backend Module löschen
2. Developer löscht Ordner automatisch

Bei deaktivierter Option:

1. Im Backend Module löschen
2. `.rex_id` wird zu `.rex_ignore`
3. Ordner bleibt erhalten

### 21. Sync im Frontend deaktivieren

```php
// config.yml oder boot.php
rex_addon::get('developer')->setConfig('sync_frontend', false);
```

### 22. Sync im Backend deaktivieren

```php
rex_addon::get('developer')->setConfig('sync_backend', false);
```

### 23. YForm E-Mail Templates synchronisieren

Backend-Einstellung: "YForm E-Mail Templates synchronisieren" aktivieren

```text
redaxo/data/addons/developer/yform_email/
└── Kontaktformular [1]/
    ├── 1.rex_id
    ├── metadata.yml
    ├── body.php
    └── body_html.php
```

metadata.yml:

```yaml
name: Kontaktformular
mail_from: noreply@example.com
mail_from_name: Website
subject: Neue Kontaktanfrage
```

### 24. Umlaute in Dateinamen

Backend-Einstellung: "Umlaute ersetzen" aktivieren

```text
Ä → Ae
Ö → Oe
Ü → Ue
ß → ss
```

Deaktiviert: Umlaute bleiben erhalten.

### 25. Nach DB-Import synchronisieren

```php
rex_extension::register('BACKUP_AFTER_DB_IMPORT', function() {
    rex_developer_manager::synchronize(null, rex_developer_synchronizer::FORCE_DB);
});
```

### 26. Editor-URL für Templates/Module

```php
rex_extension::register('EDITOR_URL', function(rex_extension_point $ep) {
    // rex:///template/1/template
    // rex:///module/10/input
    
    $file = $ep->getParam('file');
    $line = $ep->getParam('line');
    
    // Developer generiert automatisch URL zum Editor
    return rex_editor::factory()->getUrl($file, $line);
});
```

### 27. Eigene Synchronizer-Klasse

```php
class my_custom_synchronizer extends rex_developer_synchronizer
{
    protected function getItems()
    {
        $items = [];
        $sql = rex_sql::factory();
        $sql->setQuery('SELECT * FROM ' . rex::getTable('my_table'));
        
        foreach ($sql as $row) {
            $item = new rex_developer_synchronizer_item(
                $row->getValue('id'),
                $row->getValue('name'),
                strtotime($row->getValue('updatedate'))
            );
            $item->setFile('content.php', $row->getValue('content'));
            $items[] = $item;
        }
        
        return $items;
    }
    
    protected function addItem(rex_developer_synchronizer_item $item)
    {
        $sql = rex_sql::factory();
        $sql->setTable(rex::getTable('my_table'));
        $sql->setValue('name', $item->getName());
        $sql->setValue('content', $item->getFile('content.php'));
        $sql->setDateTimeValue('updatedate', $item->getUpdated());
        $sql->insert();
        
        return (int) $sql->getLastId();
    }
    
    protected function editItem(rex_developer_synchronizer_item $item)
    {
        $sql = rex_sql::factory();
        $sql->setTable(rex::getTable('my_table'));
        $sql->setWhere(['id' => $item->getId()]);
        $sql->setValue('name', $item->getName());
        $sql->setValue('content', $item->getFile('content.php'));
        $sql->setDateTimeValue('updatedate', $item->getUpdated());
        $sql->update();
    }
    
    protected function deleteItem(rex_developer_synchronizer_item $item)
    {
        $sql = rex_sql::factory();
        $sql->setTable(rex::getTable('my_table'));
        $sql->setWhere(['id' => $item->getId()]);
        $sql->delete();
    }
}

// Registrieren
$sync = new my_custom_synchronizer('my_custom', ['content.php']);
rex_developer_manager::register($sync);
```

### 28. Datei-Content lazy laden

```php
$item = new rex_developer_synchronizer_item(1, 'Example', time());

// Callable statt String für große Dateien
$item->setFile('template.php', function() {
    return rex_file::get(rex_path::frontend('large-template.php'));
});
```

### 29. Serialize/JSON Metadata

```php
$synchronizer = new rex_developer_synchronizer_default(
    'custom',
    rex::getTable('my_table'),
    ['content' => 'content.php'],
    [
        'config' => 'json',          // JSON-Objekt
        'settings' => 'serialize',   // PHP-Serialized
        'active' => 'boolean',
        'priority' => 'int'
    ]
);
```

metadata.yml:

```yaml
name: Example
config:
  option1: value1
  option2: value2
settings: 'a:2:{s:3:"foo";s:3:"bar";s:3:"baz";i:42;}'
active: true
priority: 10
```

### 30. Debug-Modus Synchronisation

```php
// Frontend-Sync nur mit aktivem Debug-Modus
if (rex::isDebugMode() || rex_backend_login::createUser()->isAdmin()) {
    rex_developer_manager::start();
}
```

> **Integration:** Developer arbeitet mit **Structure/Content-Plugin** (Templates/Module/Actions), **YForm** (E-Mail-Templates), **Console** (CLI-Commands), **Backup-Addon** (FORCE_DB nach Import), **Editor-Integration** (URL-Generator), **Extension Points** (DEVELOPER_MANAGER_START, BACKUP_AFTER_DB_IMPORT, EDITOR_URL) und **Git-Workflows** (Versionskontrolle). Synchronisation erfolgt bei aktiviertem Backend/Frontend-Login und berücksichtigt Timestamps für Konflikt-Erkennung.
