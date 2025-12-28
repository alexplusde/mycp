# rex_sql_util

Keywords: SQL-Utilities, Import, Dump, Priorities, copyTable, organizePriorities, slowQueryLog

## Übersicht

`rex_sql_util` bietet Hilfsfunktionen für SQL-Operationen: Import von `.sql`-Dumps, Tabellen-Kopieren (mit/ohne Daten), automatische Prioritäts-Nummerierung (z.B. für Sortierung). Unterstützt Platzhalter (`%TABLE_PREFIX%`, `%USER%`, `%TIME%`).

## Methoden

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `importDump($file, $debug)` | `string`, `bool` | `bool` | Importiert `.sql`-Datei in DB (install.sql, uninstall.sql) |
| `organizePriorities($table, $prioCol, $where, $orderBy, $startBy)` | `string`, `string`, `string`, `string`, `int` | `void` | Nummeriert Spalte fortlaufend durch (Sortierreihenfolge) |
| `copyTable($source, $dest)` | `string`, `string` | `void` | Kopiert Tabellenstruktur (ohne Daten) |
| `copyTableWithData($source, $dest)` | `string`, `string` | `void` | Kopiert Tabelle inkl. Daten |
| `slowQueryLogPath()` | - | `string\|null` | Gibt Pfad zur Slow-Query-Log-Datei zurück |
| `splitSqlFile(&$queries, $sql, $release)` | `array`, `string`, `int` | `bool` | Interner Parser: Splittet SQL-Dump in Statements |

## Praxisbeispiele

### SQL-Dump importieren (install.sql)

```php
// In install.php: SQL-Datei ausführen
$installSql = rex_path::addon('myaddon', 'install.sql');

if (file_exists($installSql)) {
    rex_sql_util::importDump($installSql);
}

// Mit Debug-Modus
rex_sql_util::importDump($installSql, true);
```

### Install.sql mit Platzhaltern

```sql
-- install.sql
CREATE TABLE %TABLE_PREFIX%myaddon_items (
    id INT(11) AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    created_by VARCHAR(255) DEFAULT '%USER%',
    created_at INT(11) DEFAULT %TIME%
);

INSERT INTO %TABLE_PREFIX%myaddon_items (name) VALUES ('Demo Item');
```

### Uninstall.sql importieren

```php
// In uninstall.php
$uninstallSql = rex_path::addon('myaddon', 'uninstall.sql');

if (file_exists($uninstallSql)) {
    rex_sql_util::importDump($uninstallSql);
}
```

### Uninstall.sql Beispiel

```sql
-- uninstall.sql
DROP TABLE IF EXISTS %TABLE_PREFIX%myaddon_items;
DROP TABLE IF EXISTS %TABLE_PREFIX%myaddon_categories;
```

### Prioritäten organisieren (Auto-Nummerierung)

```php
// Nach INSERT/UPDATE: Prioritäten neu durchnummerieren
rex_sql_util::organizePriorities(
    rex::getTable('myaddon_items'),  // Tabellenname
    'priority',                       // Spaltenname für Priorität
    '',                              // WHERE-Bedingung (leer = alle)
    'priority',                      // ORDER BY
    1                                // Start bei 1
);

// Resultat: priority = 1, 2, 3, 4, ...
```

### Prioritäten mit WHERE-Filter

```php
// Nur Items einer Kategorie neu nummerieren
rex_sql_util::organizePriorities(
    rex::getTable('myaddon_items'),
    'priority',
    'category_id = 5',  // Nur Kategorie 5
    'priority, name',   // Sortierung
    1
);
```

### Structure: Artikel-Prioritäten

```php
// rex_article_service nutzt organizePriorities
rex_sql_util::organizePriorities(
    rex::getTable('article'),
    'priority',
    'clang_id=' . $clangId . ' AND parent_id=' . $parentId,
    'priority',
    1
);
```

### Slices/Module: Content-Prioritäten

```php
// Nach Slice-Verschiebung
rex_sql_util::organizePriorities(
    rex::getTable('article_slice'),
    'priority',
    'article_id=' . $articleId . ' AND clang_id=' . $clangId . ' AND ctype_id=' . $ctypeId,
    'priority',
    1
);
```

### Clang-Prioritäten neu sortieren

```php
// rex_clang_service nutzt nach addCLang/editCLang/deleteCLang:
rex_sql_util::organizePriorities(
    rex::getTable('clang'),
    'priority',
    '',
    'priority'
);
```

### Metainfo-Feld-Prioritäten

```php
// Metainfo-Felder nach Prefix sortieren
rex_sql_util::organizePriorities(
    rex::getTablePrefix() . 'metainfo_field',
    'priority',
    'name LIKE "art_%"',  // Nur Article-Felder
    'priority, updatedate'
);
```

### Media Manager Effects sortieren

```php
// Effects nach Bearbeitung neu sortieren
rex_sql_util::organizePriorities(
    rex::getTable('media_manager_type_effect'),
    'priority',
    'type_id=' . $typeId,
    'priority'
);
```

### Tabelle kopieren (nur Struktur)

```php
// Backup-Tabelle erstellen (ohne Daten)
try {
    rex_sql_util::copyTable(
        rex::getTable('myaddon_items'),
        rex::getTable('myaddon_items_backup')
    );
} catch (rex_exception $e) {
    echo 'Fehler: ' . $e->getMessage();
}
```

### Tabelle mit Daten kopieren

```php
// Vollständiges Backup
rex_sql_util::copyTableWithData(
    rex::getTable('myaddon_items'),
    rex::getTable('myaddon_items_' . date('Ymd'))
);
```

### Demo-Daten importieren

```php
// In Backend-Page: Demo-Daten Button
if (rex_post('import_demo', 'boolean')) {
    $file = rex_path::addon('myaddon', 'install/demo.sql');
    
    if (file_exists($file)) {
        try {
            rex_sql_util::importDump($file);
            echo rex_view::success('Demo-Daten importiert');
        } catch (rex_sql_exception $e) {
            echo rex_view::error($e->getMessage());
        }
    }
}
```

### Demo.sql mit mehreren Inserts

```sql
-- demo.sql
INSERT INTO %TABLE_PREFIX%myaddon_categories (name, priority) VALUES
('Kategorie 1', 1),
('Kategorie 2', 2),
('Kategorie 3', 3);

INSERT INTO %TABLE_PREFIX%myaddon_items (name, category_id, created_at) VALUES
('Item A', 1, %TIME%),
('Item B', 1, %TIME%),
('Item C', 2, %TIME%);
```

### Update.sql für Migration

```php
// update.php: Spalte hinzufügen via SQL-Datei
$version = $addon->getProperty('version');

if (version_compare($version, '2.0.0', '>=')) {
    $updateSql = rex_path::addon('myaddon', 'update/2.0.0.sql');
    
    if (file_exists($updateSql)) {
        rex_sql_util::importDump($updateSql);
    }
}
```

### Slow Query Log auslesen

```php
// Backend-Page: Slow Queries anzeigen
$slowQueryPath = rex_sql_util::slowQueryLogPath();

if ($slowQueryPath && is_readable($slowQueryPath)) {
    $lines = file($slowQueryPath, FILE_IGNORE_NEW_LINES);
    $recent = array_slice($lines, -100);
    
    echo '<pre>' . implode("\n", $recent) . '</pre>';
} else {
    echo 'Slow Query Log nicht verfügbar';
}
```

### System-Log: Slow Queries Page

```php
// rex_be_controller fügt Page hinzu wenn Log existiert
if ('system' === rex_be_controller::getCurrentPagePart(1) && 'log' === rex_be_controller::getCurrentPagePart(2)) {
    $slowQueryLogPath = rex_sql_util::slowQueryLogPath();
    
    if (null !== $slowQueryLogPath && @is_readable($slowQueryLogPath)) {
        $logsPage->addSubpage((new rex_be_page('slow-queries', rex_i18n::msg('syslog_slowqueries')))
            ->setSubPath(rex_path::core('pages/system.log.slow-queries.php')));
    }
}
```

### Platzhalter in SQL-Dumps

```php
// Automatisch ersetzt beim Import:
// %TABLE_PREFIX% -> rex_ (oder Custom)
// %TEMP_PREFIX% -> tmp_rex_
// %USER% -> aktueller User-Login
// %TIME% -> time() Timestamp
```

### Eigene Platzhalter

```php
// prepareQuery ist private, aber eigene Wrapper möglich:
$sql = file_get_contents($sqlFile);
$sql = str_replace('%CUSTOM_VAL%', $myValue, $sql);
file_put_contents($tempFile, $sql);
rex_sql_util::importDump($tempFile);
unlink($tempFile);
```

### rex_form_element_prio nutzt organizePriorities

```php
// form/elements/prio.php verwendet intern:
if ($this->fieldSaved) {
    rex_sql_util::organizePriorities(
        $this->getTable(),
        $this->getName(),
        $whereCondition,
        $this->params['order_by']
    );
}
```

### Tracks Addon: Content-Prioritäten

```php
// tracks/lib/Content.php
public function reorganizePriorities() {
    rex_sql_util::organizePriorities(
        rex::getTable('tracks_content'),
        'priority',
        'track_id=' . $this->getId(),
        'priority'
    );
}
```

### Sprog: Struktur-Copy mit Prioritäten

```php
// Nach Artikel-Kopie: Slices neu nummerieren
\rex_sql_util::organizePriorities(
    \rex::getTable('article_slice'),
    'priority',
    'article_id=' . $newArticleId . ' AND clang_id=' . $clangId,
    'priority'
);
```

### Error-Handling bei importDump

```php
try {
    rex_sql_util::importDump($sqlFile);
} catch (rex_sql_exception $e) {
    rex_logger::logException($e);
    echo rex_view::error('SQL-Import fehlgeschlagen: ' . $e->getMessage());
    return false;
}

return true;
```

### Import mit Validierung

```php
$sqlFile = rex_path::addon('myaddon', 'install.sql');

if (!file_exists($sqlFile)) {
    throw new rex_exception('install.sql nicht gefunden');
}

if (!str_ends_with($sqlFile, '.sql')) {
    throw new rex_exception('Nur .sql Dateien erlaubt');
}

rex_sql_util::importDump($sqlFile);
```

### Batch-Import mehrerer SQL-Files

```php
$sqlFiles = [
    'install/tables.sql',
    'install/data.sql',
    'install/demo.sql',
];

foreach ($sqlFiles as $file) {
    $path = rex_path::addon('myaddon', $file);
    
    if (file_exists($path)) {
        rex_sql_util::importDump($path);
    }
}
```

### Prioritäten manuell setzen vor organizePriorities

```php
// Elemente mit priority = 999 ans Ende sortieren
$sql = rex_sql::factory();
$sql->setQuery('UPDATE ' . rex::getTable('items') . ' SET priority = 999 WHERE special = 1');

// Dann durchnummerieren (special items kommen ans Ende)
rex_sql_util::organizePriorities(
    rex::getTable('items'),
    'priority',
    '',
    'priority'  // 999 wird zu höchster Nummer
);
```

### Prioritäten mit Kategorien

```php
// Jede Kategorie einzeln neu nummerieren
$categories = rex_sql::factory()->getArray('SELECT DISTINCT category_id FROM ' . rex::getTable('items'));

foreach ($categories as $cat) {
    rex_sql_util::organizePriorities(
        rex::getTable('items'),
        'priority',
        'category_id=' . $cat['category_id'],
        'priority, name',
        1
    );
}
```

### Table-Copy für Tests

```php
// Test-Setup: Tabelle als Backup
if (rex::isDebugMode()) {
    rex_sql_util::copyTableWithData(
        rex::getTable('myaddon_items'),
        rex::getTable('myaddon_items_test')
    );
}

// Tests durchführen...

// Cleanup
rex_sql_table::get(rex::getTable('myaddon_items_test'))->drop();
```

### SQL-Dump mit Kommentaren

```sql
-- install.sql: Kommentare werden ignoriert

-- Tabelle für Items
CREATE TABLE %TABLE_PREFIX%myaddon_items (
    id INT(11) AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    /* Multi-Line
       Kommentar */
    created_at INT(11)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

# Hash-Kommentare auch möglich
INSERT INTO %TABLE_PREFIX%myaddon_items (name) VALUES ('Test');
```

### Conditional Import

```php
// Nur importieren wenn Tabelle nicht existiert
if (!rex_sql_table::get(rex::getTable('myaddon_items'))->exists()) {
    rex_sql_util::importDump(rex_path::addon('myaddon', 'install.sql'));
}
```
