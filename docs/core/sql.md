# `rex_sql`: Datenbank-Queries, SELECT, INSERT, UPDATE, DELETE

Verwende `rex_sql` für alle Datenbank-Operationen mit Prepared Statements und sichere Parameter-Bindung.

## Initialisierung

```php
$sql = rex_sql::factory();      // Standard-DB (meist DB 1)
$sql = rex_sql::factory(2);     // Andere DB-Verbindung
```

## Query-Methoden

| Methode | Verwendung |
|---------|------------|
| `setQuery($query, $params)` | Query ausführen (mit Prepared Statement) |
| `prepareQuery($query)` | Query vorbereiten |
| `execute($params)` | Vorbereiteten Query ausführen |
| `getArray($query, $params)` | Alle Ergebnisse als Array |
| `getRows()` | Anzahl betroffener Zeilen |
| `getLastId()` | Letzte Insert-ID |

## INSERT/UPDATE Helfer

| Methode | Verwendung |
|---------|------------|
| `setTable($table)` | Tabelle für INSERT/UPDATE setzen |
| `setValue($column, $value)` | Spaltenwert setzen |
| `setRawValue($column, $rawValue)` | Raw SQL-Wert (z.B. `NOW()`) |
| `setDateTimeValue($column, $value)` | DateTime setzen |
| `insert()` | INSERT ausführen |
| `update()` | UPDATE ausführen (benötigt WHERE) |
| `insertOrUpdate()` | INSERT oder UPDATE bei Duplikat |
| `setWhere($where, $params)` | WHERE-Bedingung für UPDATE/DELETE |
| `delete()` | DELETE ausführen (benötigt WHERE) |

## Ergebnis-Zugriff

| Methode | Rückgabe |
|---------|----------|
| `getValue($column)` | Spaltenwert der aktuellen Zeile |
| `hasValue($column)` | Spalte existiert? |
| `getRows()` | Anzahl Zeilen |
| `getRow()` | Aktuelle Zeilennummer (0-based) |
| `next()` | Zur nächsten Zeile |
| `hasNext()` | Gibt es weitere Zeilen? |
| `reset()` | Cursor zurücksetzen |

## Praxisbeispiele

### SELECT mit Prepared Statement

```php
$sql = rex_sql::factory();
$sql->setQuery('SELECT * FROM ' . rex::getTable('articles') . ' WHERE id = :id', [
    'id' => 5
]);

if ($sql->getRows() > 0) {
    $title = $sql->getValue('title');
    $content = $sql->getValue('content');
}
```

### Mehrere Ergebnisse durchlaufen

```php
$sql = rex_sql::factory();
$sql->setQuery('SELECT * FROM ' . rex::getTable('users') . ' WHERE active = 1');

foreach ($sql as $row) {
    echo $row->getValue('name') . '<br>';
}

// Alternative mit hasNext()
while ($sql->hasNext()) {
    echo $sql->getValue('email') . '<br>';
    $sql->next();
}
```

### Alle Ergebnisse als Array

```php
$products = rex_sql::factory()->getArray(
    'SELECT * FROM ' . rex::getTable('products') . ' WHERE category = :cat',
    ['cat' => 'books']
);

foreach ($products as $product) {
    echo $product['title'];
}
```

### INSERT mit setValue

```php
$sql = rex_sql::factory();
$sql->setTable(rex::getTable('contacts'));
$sql->setValue('name', 'Max Mustermann');
$sql->setValue('email', 'max@example.com');
$sql->setDateTimeValue('created', time());
$sql->insert();

$newId = $sql->getLastId();
```

### UPDATE mit WHERE

```php
$sql = rex_sql::factory();
$sql->setTable(rex::getTable('users'));
$sql->setValue('status', 'active');
$sql->setValue('last_login', date('Y-m-d H:i:s'));
$sql->setWhere('id = :id', ['id' => 123]);
$sql->update();

echo $sql->getRows() . ' Zeilen aktualisiert';
```

### INSERT OR UPDATE (bei Duplikat)

```php
$sql = rex_sql::factory();
$sql->setTable(rex::getTable('stats'));
$sql->setValue('date', date('Y-m-d'));
$sql->setValue('page_id', $pageId);
$sql->setRawValue('count', 'count + 1');  // Bei UPDATE: count erhöhen
$sql->insertOrUpdate();
```

### DELETE mit WHERE

```php
$sql = rex_sql::factory();
$sql->setTable(rex::getTable('logs'));
$sql->setWhere('created < :date', ['date' => date('Y-m-d', strtotime('-30 days'))]);
$sql->delete();
```

### Raw SQL-Werte verwenden

```php
$sql = rex_sql::factory();
$sql->setTable(rex::getTable('orders'));
$sql->setValue('customer_id', 5);
$sql->setRawValue('order_date', 'NOW()');
$sql->setRawValue('total', 'price * quantity');
$sql->insert();
```

### Komplexe WHERE-Bedingung

```php
$sql = rex_sql::factory();
$sql->setQuery(
    'SELECT * FROM ' . rex::getTable('products') . '
     WHERE category = :cat 
     AND price BETWEEN :min AND :max
     AND status = :status
     ORDER BY price ASC',
    [
        'cat' => 'electronics',
        'min' => 100,
        'max' => 500,
        'status' => 'active'
    ]
);
```

### COUNT-Query

```php
$sql = rex_sql::factory();
$sql->setQuery('SELECT COUNT(*) as total FROM ' . rex::getTable('articles'));
$total = $sql->getValue('total');
```

### JOIN-Query

```php
$sql = rex_sql::factory();
$sql->setQuery('
    SELECT u.name, o.order_number, o.total
    FROM ' . rex::getTable('users') . ' u
    INNER JOIN ' . rex::getTable('orders') . ' o ON u.id = o.user_id
    WHERE u.status = :status
', ['status' => 'active']);

foreach ($sql as $row) {
    echo $row->getValue('name') . ': ' . $row->getValue('order_number');
}
```

### Transaktionen

```php
$sql = rex_sql::factory();
try {
    $sql->setQuery('START TRANSACTION');
    
    $sql->setTable(rex::getTable('accounts'));
    $sql->setValue('balance', 100);
    $sql->setWhere('id = 1');
    $sql->update();
    
    $sql->setTable(rex::getTable('accounts'));
    $sql->setValue('balance', -100);
    $sql->setWhere('id = 2');
    $sql->update();
    
    $sql->setQuery('COMMIT');
} catch (rex_sql_exception $e) {
    $sql->setQuery('ROLLBACK');
    throw $e;
}
```

### Prepared Statement mehrfach ausführen

```php
$sql = rex_sql::factory();
$sql->prepareQuery('INSERT INTO ' . rex::getTable('logs') . ' (message, level) VALUES (?, ?)');

$logs = [
    ['User logged in', 'info'],
    ['File uploaded', 'debug'],
    ['Error occurred', 'error'],
];

foreach ($logs as [$message, $level]) {
    $sql->execute([$message, $level]);
}
```

### NULL-Werte behandeln

```php
$sql = rex_sql::factory();
$sql->setTable(rex::getTable('users'));
$sql->setValue('email', $email);
$sql->setValue('phone', $phone ?: null);  // NULL wenn leer
$sql->insert();

// Beim Auslesen
$phone = $sql->getValue('phone');  // Kann null sein
```

### Debug-Modus aktivieren

```php
$sql = rex_sql::factory();
$sql->setDebug(true);  // Zeigt Queries im Debug-Modus
$sql->setQuery('SELECT * FROM ' . rex::getTable('users'));
```

### Array WHERE mit IN

```php
$ids = [1, 2, 3, 4, 5];
$placeholders = implode(',', array_fill(0, count($ids), '?'));

$sql = rex_sql::factory();
$sql->setQuery(
    'SELECT * FROM ' . rex::getTable('articles') . ' WHERE id IN (' . $placeholders . ')',
    $ids
);
```

### Paginierung

```php
$page = rex_get('page', 'int', 1);
$perPage = 20;
$offset = ($page - 1) * $perPage;

$sql = rex_sql::factory();
$sql->setQuery('
    SELECT * FROM ' . rex::getTable('products') . '
    ORDER BY created DESC
    LIMIT :limit OFFSET :offset
', ['limit' => $perPage, 'offset' => $offset]);
```

## Sicherheit

**Immer Prepared Statements verwenden:**

```php
// ✅ RICHTIG
$sql->setQuery('SELECT * FROM table WHERE id = :id', ['id' => $userId]);

// ❌ FALSCH (SQL-Injection-Gefahr!)
$sql->setQuery("SELECT * FROM table WHERE id = $userId");
```

## Fehlerbehandlung

```php
try {
    $sql = rex_sql::factory();
    $sql->setQuery('SELECT * FROM nonexistent_table');
} catch (rex_sql_exception $e) {
    rex_logger::logException($e);
    echo 'Datenbankfehler: ' . $e->getMessage();
}
```

## Multiple Datenbanken

```php
// DB 1 (Standard)
$sql1 = rex_sql::factory(1);
$sql1->setQuery('SELECT * FROM ' . rex::getTable('users'));

// DB 2 (andere Verbindung)
$sql2 = rex_sql::factory(2);
$sql2->setQuery('SELECT * FROM external_table');
```
