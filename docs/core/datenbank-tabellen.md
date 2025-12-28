# datenbank-tabellen

Quelle: https://redaxo.org/doku/main/datenbank-tabellen

# Datenbank - Tabellen

- [rex_sql_table](#table)

- [Abruf der Struktur](#abruf-der-struktur)

- [get](#get)

- [exists](#exists)

- [getName](#getname)

- [hasColumn](#hascolumn)

- [getColumn](#getcolumn)

- [getColumns](#getcolumns)

- [getPrimaryKey](#getprimarykey)

- [hasIndex](#hasindex)

- [getIndex](#getindex)

- [getIndexes](#getindexes)

- [hasForeignKey](#hasforeignkey)

- [getForeignKey](#getforeignkey)

- [getForeignKeys](#getforeignkeys)

- [Änderungen ausführen](#aenderungen-ausfuehren)

- [create](#create)

- [alter](#alter)

- [ensure](#ensure)

- [drop](#drop)

- [Änderungen definieren](#aenderungen-definieren)

- [setName](#setname)

- [addColumn](#addcolumn)

- [ensureColumn](#ensurecolumn)

- [ensurePrimaryIdColumn](#ensureprimaryidcolumn)

- [ensureGlobalColumns](#ensureglobalcolumns)

- [renameColumn](#renamecolumn)

- [removeColumn](#removecolumn)

- [addIndex](#addindex)

- [ensureIndex](#ensureindex)

- [renameIndex](#renameindex)

- [removeIndex](#removeindex)

- [addForeignKey](#addforeignkey)

- [ensureForeignKey](#ensureforeignkey)

- [renameForeignKey](#renameforeignkey)

- [removeForeignKey](#removeforeignkey)

- [rex_sql_column](#column)

- [rex_sql_index](#index)

- [rex_sql_foreign_key](#foreign-key)

- [rex_sql_util](#util)

## rex_sql_table

Mit der Klasse `rex_sql_table` kann man die Struktur der Datenbanktabellen auslesen und verändern.

Die Klasse ist vor allem nützlich bei der Entwicklung von AddOns, um bei der Installation die nötigen Tabellen des AddOns anzulegen, bzw. sie bei der Deinstallation wieder zu löschen.

Beispiel für eine `install.php`:

`rex_sql_table::get(rex::getTable('foo'))
    ->ensurePrimaryIdColumn()
    ->ensureColumn(new rex_sql_column('title', 'varchar(255)'))
    ->ensureColumn(new rex_sql_column('description', 'text', true))
    ->ensureColumn(new rex_sql_column('status', 'tinyint(1)', false, 1))
    ->ensureIndex(new rex_sql_index('i_title', ['title']))
    ->ensure();`
``n

Durch diesen Code wird die Tabelle in der angegebenen Struktur sichergestellt. Sie wird also erstellt, falls noch nicht vorhanden, bzw. modifiziert, falls einzelne Spalten oder Indizes nicht der gewünschten Struktur entsprechen.

**

**Tipp:**
Über das Adminer-AddOn kann man sich den `rex_sql_table`-Code für eine Tabelle generieren lassen. Alternativ ist dies auch möglich über den Konsolenbefehl `redaxo/bin/console db:dump-schema <table>`.

Beispiel für eine `uninstall.php`:

`rex_sql_table::get(rex::getTable('foo'))->drop();`
``n

### Abruf der Struktur

#### get

`get($name,$db)`

Mit `rex_sql_table::get($name)` holt man sich das Objekt zu der Tabelle mit dem Namen `$name` und *optional* der Datebank $db (numerisch muss in der config.yml von REDAXO hinterlegt sein). Diese Methode wird verwendet unabhängig davon, ob man eine existieren Tabelle abrufen, bzw. editieren möchte, oder ob man eine neue Tabelle erstellen möchte.

#### exists

`exists()`

Prüft, ob die Tabelle existiert (`$table->exists()`).

#### getName

`getName()`

Gibt den Tabellennamen zurück.

#### hasColumn

`hasColumn($name)`

Prüft, ob die angegebene Spalte existiert.

#### getColumn

`getColumn($name)`

Liefert das `rex_sql_column`-Objekt zu der angegebenen Spalte, oder `null` falls die Spalte nicht existiert.

#### getColumns

`getColumns()`

Liefert ein Array mit allen Spalten der Tabelle als `rex_sql_column`-Objekte.

#### getPrimaryKey

`getPrimaryKey()`

Liefert den Primärschlüssel der Tabelle als Array mit den Spaltennamen, zum Beispiel `['id']`.

#### hasIndex

`hasIndex($name)`

Prüft, ob der angegebene Index existiert.

#### getIndex

`getIndex($name)`

Liefert das `rex_sql_index`-Objekt zu dem angegebenen Index, oder `null` falls der Index nicht existiert.

#### getIndexes

`getIndexes()`

Liefert ein Array mit allen Indizes der Tabelle als `rex_sql_index`-Objekte.

#### hasForeignKey

`hasForeignKey($name)`

Prüft, ob der angegebene Fremdschlüssel existiert.

#### getForeignKey

`getForeignKey($name)`

Liefert das `rex_sql_foreign_key`-Objekt zu dem angegebenen Fremdschlüssel, oder `null` falls der Fremdschlüssel nicht existiert.

#### getForeignKeys

`getForeignKeys()`

Liefert ein Array mit allen Fremdschlüsseln der Tabelle als `rex_sql_foreign_key`-Objekte.

### Änderungen ausführen

#### create

`create()`

Erstellt die Tabelle mit der zuvor angegebenen Definition. Falls die Tabelle bereits existiert, wird eine Exception geworfen.

#### alter

`alter()`

Ändert die Tabelle entsprechend der zuvor angegebenen Änderungen. Falls die Tabelle noch nicht existiert, wird eine Exception geworfen.

#### ensure

`ensure()`

Stellt die zuvor angegebene Definition sicher. Falls die Tabelle noch nicht existiert, wird sie angelegt. Ansonsten wird sie bei Bedarf entsprechend der Definition geändert. Dabei wird auch sichergestellt, dass die Spalten in der definierten Reihenfolge (Reihenfolge der `ensureColumn()`-Aufrufe, oder über explizite Positionsangaben) vorliegen. Daher sollte diese Methode nur verwendet werden, wenn die komplette Tabellen-Definition angegeben wurde, die sicherzustellen ist. Bei Angabe von nur einzelnen Änderungen sollte stattdessen `alter()` verwendet werden.

#### drop

`drop()`

Löscht die Tabelle. Falls sie gar nicht existiert, macht die Methode nichts, es wird also keine Exception geworfen.

### Änderungen definieren

Die folgenden Methoden führen die jeweiligen Änderungen nicht sofort aus, sondern dafür bedarf es immer den Aufruf einer der Methoden `create()`, `alter()` oder `ensure()`.

#### setName

`setName($name)`

Ändert den Tabellennamen.

#### addColumn

`addColumn(rex_sql_column $column, $afterColumn = null)`

Fügt eine neue Spalte hinzu. Falls eine Spalte mit dem Namen bereits existiert, wird eine Exception geworfen.
Optional kann die Position für die neue Spalte mit dem zweiten Parameter gesetzt werden, entweder durch Angabe eines anderen Spaltennamens, nach der die Spalte eingefügt werden soll, oder `rex_sql_table::FIRST`.

#### ensureColumn

`ensureColumn(rex_sql_column $column, $afterColumn = null)`

Stellt sicher, dass die Spalte mit der angegebenen Definition existiert. Die Spalte wird also ggf. angelegt oder geändert.
Optional kann die Position für die neue Spalte mit dem zweiten Parameter gesetzt werden, entweder durch Angabe eines anderen Spaltennamens, nach der die Spalte eingefügt werden soll, oder `rex_sql_table::FIRST`.

#### ensurePrimaryIdColumn

`ensurePrimaryIdColumn()`

Dies ist eine Shortcut-Methode für diesen Aufruf:

`$table
    ->ensureColumn(new rex_sql_column('id', 'int(10) unsigned', false, null, 'auto_increment'))
    ->setPrimaryKey('id');`
``n

#### ensureGlobalColumns

`ensureGlobalColumns()`

Dies ist eine Shortcut-Methode für diesen Aufruf:

`$table
    ->ensureColumn(new rex_sql_column('createdate', 'datetime'))
    ->ensureColumn(new rex_sql_column('createuser', 'varchar(255)'))
    ->ensureColumn(new rex_sql_column('updatedate', 'datetime'))
    ->ensureColumn(new rex_sql_column('updateuser', 'varchar(255)'));`
``n

#### renameColumn

`renameColumn($oldName, $newName)`

Benennt eine Spalte um.

#### removeColumn

`removeColumn($name)`

Entfernt eine Spalte.

#### setPrimaryKey

`setPrimaryKey($columns)`

Setzt den Primärschlüssel. Falls dieser nur für eine Spalte gesetzt werden soll, kann diese als String angegeben werden (`$table->setPrimaryKey('id')`), ansonsten als Array (`$table->setPrimaryKey(['namespace', 'key'])`).

#### addIndex

`addIndex(rex_sql_index $index)`

Fügt einen neuen Index hinzu. Falls ein Index mit dem Namen bereits existiert, wird eine Exception geworfen.

#### ensureIndex

`ensureIndex(rex_sql_index $index)`

Stellt sicher, dass der Index mit der angegebenen Definition existiert. Der Index wird also ggf. angelegt, oder geändert.

#### renameIndex

`renameIndex($oldName, $newName)`

Benennt einen Index um.

#### removeIndex

`removeIndex($name)`

Entfernt einen Index.

#### addForeignKey

`addForeignKey(rex_sql_foreign_key $foreignKey)`

Fügt einen neuen Fremdschlüssel hinzu. Falls ein Fremdschlüssel mit dem Namen bereits existiert, wird eine Exception geworfen.

#### ensureForeignKey

`ensureForeignKey(rex_sql_foreign_key $foreignKey)`

Stellt sicher, dass der Fremdschlüssel mit der angegebenen Definition existiert. Der Fremdschlüssel wird also ggf. angelegt oder geändert.

#### renameForeignKey

`renameForeignKey($oldName, $newName)`

Benennt einen Fremdschlüssel um.

#### removeForeignKey

`removeForeignKey($name)`

Entfernt einen Fremdschlüssel.

## rex_sql_column

`new rex_sql_column($name, $type, $nullable = false, $default = null, $extra = null)`

Parameter
Erklärung

`$name`
Name der Spalte

`$type`
Typ der Spalte als String, zum Beispiel `varchar(255)`, `int(10) unsigned`, `datetime`...

`$nullable`
Definiert, ob die Spalte auch den Wert `null` erlaubt (`true`/`false`)

`$default`
Default-Wert der Spalte

`$extra`
Zusätzeliche Spaltendefinitionen, wie zum Beispiel `'auto_increment'`.

Über die Methoden `getName()`, `getType()`, `isNullable()`, `getDefault()` und `getExtra()` können die Werte abgefragt werden.

## rex_sql_index

`new rex_sql_index($name, array $columns, $type = self::INDEX)`

Parameter
Erklärung

`$name`
Name des Indexes

`$columns`
Array mit den Spaltennamen, auf die sich der Index beziehen soll (z. B. `['id', 'clang_id']`)

`$type`
Index-Typ: ``rex_sql_index`::INDEX`(default),`rex_sql_index::UNIQUE`oder`rex_sql_index::FULLTEXT`

Über die Methoden `getName()`, `getColumns()` und `getType()` können die Werte abgefragt werden.

## rex_sql_foreign_key

`new rex_sql_foreign_key($name, $table, array $columns, $onUpdate = self::RESTRICT, $onDelete = self::RESTRICT)`

Parameter
Erklärung

`$name`
Name des Fremdschlüssels

`$table`
Name der Tabelle, die über den Fremdschlüssel referenziert wird

`$columns`
Assoziatives Array, welches die Spalten des Fremdschlüssels den Spalten in der referenzierten Tabelle zuordnet (z. B. `['foo_id' => 'id']`)

`$onUpdate`
`ON UPDATE`-Aktion: `rex_sql_foreign_key::RESTRICT` (default), `rex_sql_foreign_key::CASCADE` oder `rex_sql_foreign_key::SET_NULL`

`$onDelete`
`ON DELETE`-Aktion: `rex_sql_foreign_key::RESTRICT` (default), `rex_sql_foreign_key::CASCADE` oder `rex_sql_foreign_key::SET_NULL`

Über die Methoden `getName()`, `getTable()`, `getColumns()`, `getOnUpdate()` und `getOnDelete()` können die Werte abgefragt werden.

## rex_sql_util

### Kopieren von Tabellenstrukturen mit/oder ohne Daten

**

Beim Kopieren von REDAXO-Tabellen wird nicht automatisch der Prefix gesetzt. 

`// Nur Tabellenstruktur kopieren von rex_table1 zu neuer Tabelle rex_table2
rex_sql_util::copyTable('rex_table1', 'rex_table2');`
``n

`// Tabellenstruktur und Daten kopieren
rex_sql_util::copyTableWithData('rex_table1', 'rex_table2');`
``n

### Beispiel

` rex_sql_util::copyTableWithData(rex::getTablePrefix() . 'old_data',rex::getTablePrefix() . 'new_data');`
``n
                
                            [**Artikel bearbeiten](https://github.com/redaxo/docs/edit/main/datenbank-tabellen.md)
