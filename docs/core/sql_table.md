# `rex_sql_table`: Schema-Migration, Tabellen erstellen/ändern

Verwende `rex_sql_table` für sichere Schema-Änderungen (CREATE/ALTER TABLE) ohne manuelles SQL.

## Grundlagen

```php
$table = rex_sql_table::get(rex::getTable('my_table'));

// Spalten definieren
$table->ensureColumn(new rex_sql_column('id', 'int(11)', false, null, 'auto_increment'));
$table->ensureColumn(new rex_sql_column('name', 'varchar(255)'));
$table->ensureColumn(new rex_sql_column('email', 'varchar(255)', true));  // nullable

// Primary Key
$table->setPrimaryKey('id');

// Tabelle anlegen/aktualisieren
$table->ensure();
```

## Spalten-Methoden

| Methode | Parameter | Verwendung |
|---------|-----------|------------|
| `ensureColumn($column)` | rex_sql_column | Spalte sicherstellen |
| `ensureGlobalColumns()` | - | Standard-Spalten (createdate, updatedate, createuser, updateuser) |
| `removeColumn($name)` | string | Spalte entfernen |
| `renameColumn($oldName, $newName)` | string, string | Spalte umbenennen |

## Index-Methoden

| Methode | Verwendung |
|---------|------------|
| `setPrimaryKey($columns)` | Primary Key setzen |
| `ensureIndex($index)` | Index sicherstellen |
| `removeIndex($name)` | Index entfernen |
| `renameIndex($oldName, $newName)` | Index umbenennen |

## Foreign Key-Methoden

| Methode | Verwendung |
|---------|------------|
| `ensureForeignKey($fk)` | Foreign Key sicherstellen |
| `removeForeignKey($name)` | Foreign Key entfernen |

## Tabellen-Methoden

| Methode | Verwendung |
|---------|------------|
| `ensure()` | Tabelle anlegen/aktualisieren |
| `drop()` | Tabelle löschen |
| `exists()` | Tabelle existiert? |
| `getName()` | Tabellenname |
| `rename($newName)` | Tabelle umbenennen |

## rex_sql_column erstellen

```php
new rex_sql_column(
    $name,              // Spaltenname
    $type,              // Datentyp
    $nullable = false,  // NULL erlaubt?
    $default = null,    // Default-Wert
    $extra = null,      // z.B. 'auto_increment'
    $comment = null     // Kommentar
);
```

## Praxisbeispiele

### Einfache Tabelle erstellen

```php
$table = rex_sql_table::get(rex::getTable('contacts'));
$table
    ->ensureColumn(new rex_sql_column('id', 'int(11)', false, null, 'auto_increment'))
    ->ensureColumn(new rex_sql_column('name', 'varchar(255)'))
    ->ensureColumn(new rex_sql_column('email', 'varchar(255)'))
    ->ensureColumn(new rex_sql_column('status', 'enum("active","inactive")', false, 'active'))
    ->setPrimaryKey('id')
    ->ensure();
```

### Tabelle mit Standard-Spalten

```php
$table = rex_sql_table::get(rex::getTable('products'));
$table
    ->ensureColumn(new rex_sql_column('id', 'int(11)', false, null, 'auto_increment'))
    ->ensureColumn(new rex_sql_column('title', 'varchar(255)'))
    ->ensureColumn(new rex_sql_column('price', 'decimal(10,2)'))
    ->setPrimaryKey('id')
    ->ensureGlobalColumns()  // createdate, updatedate, createuser, updateuser
    ->ensure();
```

### Text-Spalten verschiedener Größen

```php
$table = rex_sql_table::get(rex::getTable('articles'));
$table
    ->ensureColumn(new rex_sql_column('id', 'int(11)', false, null, 'auto_increment'))
    ->ensureColumn(new rex_sql_column('slug', 'varchar(255)'))
    ->ensureColumn(new rex_sql_column('teaser', 'text'))           // bis ~65KB
    ->ensureColumn(new rex_sql_column('content', 'mediumtext'))   // bis ~16MB
    ->ensureColumn(new rex_sql_column('metadata', 'longtext'))    // bis ~4GB
    ->setPrimaryKey('id')
    ->ensure();
```

### Numerische Datentypen

```php
$table = rex_sql_table::get(rex::getTable('stats'));
$table
    ->ensureColumn(new rex_sql_column('id', 'int(11)', false, null, 'auto_increment'))
    ->ensureColumn(new rex_sql_column('views', 'int(11)', false, 0))
    ->ensureColumn(new rex_sql_column('rating', 'tinyint(1)'))        // 0-255
    ->ensureColumn(new rex_sql_column('amount', 'decimal(10,2)'))     // Geldbeträge
    ->ensureColumn(new rex_sql_column('percentage', 'float'))
    ->setPrimaryKey('id')
    ->ensure();
```

### Datum/Zeit-Spalten

```php
$table = rex_sql_table::get(rex::getTable('events'));
$table
    ->ensureColumn(new rex_sql_column('id', 'int(11)', false, null, 'auto_increment'))
    ->ensureColumn(new rex_sql_column('event_date', 'date'))          // YYYY-MM-DD
    ->ensureColumn(new rex_sql_column('event_time', 'time'))          // HH:MM:SS
    ->ensureColumn(new rex_sql_column('created', 'datetime'))         // YYYY-MM-DD HH:MM:SS
    ->ensureColumn(new rex_sql_column('modified', 'timestamp'))       // Auto-Update
    ->setPrimaryKey('id')
    ->ensure();
```

### Indexe erstellen

```php
$table = rex_sql_table::get(rex::getTable('users'));
$table
    ->ensureColumn(new rex_sql_column('id', 'int(11)', false, null, 'auto_increment'))
    ->ensureColumn(new rex_sql_column('email', 'varchar(255)'))
    ->ensureColumn(new rex_sql_column('username', 'varchar(100)'))
    ->ensureColumn(new rex_sql_column('status', 'varchar(20)'))
    ->setPrimaryKey('id')
    ->ensureIndex(new rex_sql_index('email', ['email'], rex_sql_index::UNIQUE))
    ->ensureIndex(new rex_sql_index('status_idx', ['status'], rex_sql_index::INDEX))
    ->ensure();
```

### Fulltext-Index

```php
$table = rex_sql_table::get(rex::getTable('articles'));
$table
    ->ensureColumn(new rex_sql_column('id', 'int(11)', false, null, 'auto_increment'))
    ->ensureColumn(new rex_sql_column('title', 'varchar(255)'))
    ->ensureColumn(new rex_sql_column('content', 'text'))
    ->setPrimaryKey('id')
    ->ensureIndex(new rex_sql_index('fulltext_search', ['title', 'content'], rex_sql_index::FULLTEXT))
    ->ensure();
```

### Composite Primary Key

```php
$table = rex_sql_table::get(rex::getTable('page_visits'));
$table
    ->ensureColumn(new rex_sql_column('page_id', 'int(11)'))
    ->ensureColumn(new rex_sql_column('date', 'date'))
    ->ensureColumn(new rex_sql_column('count', 'int(11)', false, 0))
    ->setPrimaryKey(['page_id', 'date'])  // Kombinierter Primary Key
    ->ensure();
```

### Foreign Keys

```php
$table = rex_sql_table::get(rex::getTable('orders'));
$table
    ->ensureColumn(new rex_sql_column('id', 'int(11)', false, null, 'auto_increment'))
    ->ensureColumn(new rex_sql_column('user_id', 'int(11)'))
    ->ensureColumn(new rex_sql_column('total', 'decimal(10,2)'))
    ->setPrimaryKey('id')
    ->ensureForeignKey(new rex_sql_foreign_key(
        'fk_orders_users',                    // Name
        rex::getTable('users'),                // Referenz-Tabelle
        ['user_id' => 'id'],                   // Spalten-Mapping
        rex_sql_foreign_key::CASCADE,          // ON UPDATE
        rex_sql_foreign_key::SET_NULL          // ON DELETE
    ))
    ->ensure();
```

### Spalte nachträglich hinzufügen

```php
$table = rex_sql_table::get(rex::getTable('users'));
$table->ensureColumn(new rex_sql_column('phone', 'varchar(50)', true));
$table->ensure();
```

### Spalte umbenennen

```php
$table = rex_sql_table::get(rex::getTable('users'));
$table->renameColumn('old_name', 'new_name');
$table->ensure();
```

### Spalte entfernen

```php
$table = rex_sql_table::get(rex::getTable('users'));
$table->removeColumn('deprecated_field');
$table->ensure();
```

### Tabelle umbenennen

```php
$table = rex_sql_table::get(rex::getTable('old_table'));
$table->rename(rex::getTable('new_table'));
```

### Tabelle löschen

```php
$table = rex_sql_table::get(rex::getTable('temp_data'));
if ($table->exists()) {
    $table->drop();
}
```

### JSON-Spalte

```php
$table = rex_sql_table::get(rex::getTable('settings'));
$table
    ->ensureColumn(new rex_sql_column('id', 'int(11)', false, null, 'auto_increment'))
    ->ensureColumn(new rex_sql_column('key', 'varchar(100)'))
    ->ensureColumn(new rex_sql_column('data', 'json'))
    ->setPrimaryKey('id')
    ->ensure();
```

### ENUM-Spalte mit Default

```php
$table = rex_sql_table::get(rex::getTable('tasks'));
$table
    ->ensureColumn(new rex_sql_column('id', 'int(11)', false, null, 'auto_increment'))
    ->ensureColumn(new rex_sql_column('title', 'varchar(255)'))
    ->ensureColumn(new rex_sql_column(
        'priority',
        'enum("low","medium","high")',
        false,
        'medium'  // Default-Wert
    ))
    ->setPrimaryKey('id')
    ->ensure();
```

### Installation/Update Pattern

```php
// In install.php oder update.php
rex_sql_table::get(rex::getTable('addon_data'))
    ->ensureColumn(new rex_sql_column('id', 'int(11)', false, null, 'auto_increment'))
    ->ensureColumn(new rex_sql_column('name', 'varchar(255)'))
    ->ensureColumn(new rex_sql_column('value', 'text'))
    ->setPrimaryKey('id')
    ->ensure();

rex_sql_table::get(rex::getTable('addon_logs'))
    ->ensureColumn(new rex_sql_column('id', 'int(11)', false, null, 'auto_increment'))
    ->ensureColumn(new rex_sql_column('message', 'text'))
    ->ensureColumn(new rex_sql_column('level', 'varchar(20)'))
    ->ensureColumn(new rex_sql_column('created', 'datetime'))
    ->setPrimaryKey('id')
    ->ensureIndex(new rex_sql_index('level_idx', ['level']))
    ->ensure();
```

## Best Practices

1. **Immer `ensure()` statt `CREATE TABLE`** - Tabelle wird nur erstellt/geändert wenn nötig
2. **Primary Key definieren** - Verhindert Duplikate
3. **Indexe für WHERE/JOIN** - Beschleunigt Queries
4. **Foreign Keys für Integrität** - Verhindert inkonsistente Daten
5. **Global Columns für Tracking** - `ensureGlobalColumns()` für createdate etc.

## Foreign Key Constraints

```php
rex_sql_foreign_key::RESTRICT    // Änderung/Löschung verhindern
rex_sql_foreign_key::CASCADE     // Änderungen mitnehmen
rex_sql_foreign_key::SET_NULL    // Auf NULL setzen
rex_sql_foreign_key::NO_ACTION   // Keine Aktion
```

## Index-Typen

```php
rex_sql_index::INDEX      // Standard-Index
rex_sql_index::UNIQUE     // Unique-Index
rex_sql_index::FULLTEXT   // Fulltext-Index (für TEXT-Spalten)
```
