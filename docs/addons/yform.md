# YForm - Formular-Builder & ORM

**Keywords:** Form Builder ORM Database Table Manager Dataset Query Frontend Backend Validation CRUD YOrm

## Übersicht

Universelles Formular- und Datenbank-Management-System mit ORM (YOrm), Table Manager für Backend-CRUD, Frontend-Formularen und E-Mail-Versand.

## Kern-Klassen

### rex_yform_manager_table

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `::get($tableName)` | string | rex_yform_manager_table\|null | Lädt Table-Definition |
| `::getAll()` | - | array | Alle registrierten Tabellen |
| `query()` | - | rex_yform_manager_query | Query-Builder für Tabelle |
| `getCSRFKey()` | - | rex_csrf_token | CSRF-Token für Tabelle |
| `getRawValues()` | - | array | Alle Felder der Tabelle |
| `getFields()` | - | array | Feld-Objekte |
| `getName()` | - | string | Tabellenname (z.B. 'rex_my_table') |
| `::deleteCache()` | - | void | Table-Cache löschen |

### rex_yform_manager_dataset

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `::get($id, $table)` | int, string | rex_yform_manager_dataset\|null | Lädt Datensatz per ID |
| `::create($table)` | string | rex_yform_manager_dataset | Neuer leerer Datensatz |
| `::query()` | - | rex_yform_manager_query | Query-Builder (statisch) |
| `getValue($key, $default)` | string, mixed | mixed | Feld-Wert abrufen |
| `setValue($key, $value)` | string, mixed | $this | Feld-Wert setzen |
| `save()` | - | bool | Speichert Datensatz (Insert/Update) |
| `delete()` | - | bool | Löscht Datensatz |
| `getMessages()` | - | array | Validierungs-Fehler |
| `getId()` | - | int | Primary Key |
| `getRelatedDataset($key)` | string | rex_yform_manager_dataset\|null | Relation folgen |
| `getRelatedCollection($key)` | string | rex_yform_manager_collection | 1:n Relation |
| `getForm()` | - | rex_yform | YForm-Formular für Datensatz |
| `executeForm($yform)` | rex_yform | string | Formular ausführen & ausgeben |
| `::setModelClass($table, $class)` | string, string | void | Custom Model registrieren |

### rex_yform_manager_query

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `find()` | - | rex_yform_manager_collection | Alle Ergebnisse |
| `findOne()` | - | rex_yform_manager_dataset\|null | Erstes Ergebnis |
| `findId($id)` | int | rex_yform_manager_dataset\|null | Per ID suchen |
| `where($column, $value, $operator)` | string, mixed, string | $this | WHERE-Bedingung |
| `whereRaw($sql, $params)` | string, array | $this | Raw SQL WHERE |
| `orderBy($column, $direction)` | string, string | $this | ORDER BY |
| `limit($limit, $offset)` | int, int | $this | LIMIT |
| `alias($alias)` | string | $this | Tabellen-Alias |
| `joinRelation($field, $alias)` | string, string | $this | JOIN über Relation |
| `select($field, $alias)` | string, string | $this | Spalte auswählen |
| `selectRaw($sql)` | string | $this | Raw SQL SELECT |
| `count()` | - | int | Anzahl Ergebnisse |
| `exists()` | - | bool | Mindestens 1 Ergebnis? |
| `chunk($size, $callback)` | int, callable | void | Batch-Processing |
| `paginate($page, $perPage)` | int, int | array | Pagination-Daten |

### rex_yform

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `::factory()` | - | rex_yform | Neues Formular |
| `setObjectparams($key, $value)` | string, mixed | void | Parameter setzen (form_action, form_method) |
| `setValueField($type, $params)` | string, array | void | Value-Feld hinzufügen (text, textarea, select) |
| `setValidateField($type, $params)` | string, array | void | Validation hinzufügen |
| `setActionField($type, $params)` | string, array | void | Action (db, email, showtext) |
| `getForm()` | - | string | Rendert Formular-HTML |
| `::addTemplatePath($path)` | string | void | Template-Verzeichnis registrieren |

## Praxisbeispiele

### Table Manager - Tabelle abrufen

```php
// Tabelle laden
$table = rex_yform_manager_table::get('rex_my_products');

echo $table->getName(); // 'rex_my_products'

// Alle Felder
foreach ($table->getFields() as $field) {
    echo $field->getName() . ' - ' . $field->getTypeName();
}

// CSRF-Token für Frontend-Formulare
$token = $table->getCSRFKey();
```

### Alle Tabellen auflisten

```php
// Alle YForm-Tabellen
foreach (rex_yform_manager_table::getAll() as $table) {
    echo $table->getName() . '<br>';
}

// Mit Feldanzahl
foreach (rex_yform_manager_table::getAll() as $table) {
    echo $table->getName() . ': ' . count($table->getFields()) . ' Felder<br>';
}
```

### Dataset abrufen

```php
// Datensatz per ID
$product = rex_yform_manager_dataset::get(42, 'rex_products');

if ($product) {
    echo $product->name;
    echo $product->price;
    echo $product->description;
}

// Mit Fallback
$product = rex_yform_manager_dataset::get($id, 'rex_products');
if (!$product) {
    echo 'Produkt nicht gefunden';
    exit;
}
```

### Dataset erstellen & speichern

```php
// Neuen Datensatz erstellen
$product = rex_yform_manager_dataset::create('rex_products');
$product->name = 'Neues Produkt';
$product->price = 99.90;
$product->description = 'Beschreibung...';
$product->status = 1;

if ($product->save()) {
    echo 'Gespeichert mit ID: ' . $product->getId();
} else {
    echo 'Fehler: ' . implode('<br>', $product->getMessages());
}
```

### Dataset aktualisieren

```php
// Bestehenden Datensatz laden und ändern
$product = rex_yform_manager_dataset::get(42, 'rex_products');

if ($product) {
    $product->name = 'Geänderter Name';
    $product->price = 149.90;
    
    if ($product->save()) {
        echo 'Aktualisiert';
    } else {
        echo 'Fehler: ' . implode('<br>', $product->getMessages());
    }
}
```

### Dataset löschen

```php
// Datensatz löschen
$product = rex_yform_manager_dataset::get(42, 'rex_products');

if ($product && $product->delete()) {
    echo 'Gelöscht';
} else {
    echo 'Fehler beim Löschen';
}

// Oder direkt via Query
rex_yform_manager_dataset::query('rex_products')
    ->findId(42)
    ?->delete();
```

### Custom Model Class

```php
// In lib/Models/Product.php
class Product extends rex_yform_manager_dataset
{
    // Eigene Methoden
    public function getFormattedPrice()
    {
        return number_format($this->price, 2, ',', '.') . ' €';
    }
    
    public function isAvailable()
    {
        return $this->status == 1 && $this->stock > 0;
    }
    
    // Accessor (wird automatisch bei $product->full_name aufgerufen)
    public function getFullName()
    {
        return $this->name . ' (' . $this->sku . ')';
    }
}

// In boot.php registrieren
rex_yform_manager_dataset::setModelClass('rex_products', Product::class);

// Verwendung
$product = Product::query()->findId(42);
echo $product->getFormattedPrice(); // "99,90 €"
echo $product->full_name; // "Mein Produkt (SKU-123)" (via getFullName)
```

### Query - Einfache Abfragen

```php
// Alle Datensätze
$products = rex_yform_manager_dataset::query('rex_products')
    ->find();

foreach ($products as $product) {
    echo $product->name;
}

// Mit WHERE
$products = rex_yform_manager_dataset::query('rex_products')
    ->where('status', 1)
    ->where('price', 100, '>')
    ->find();

// Mit ORDER BY und LIMIT
$products = rex_yform_manager_dataset::query('rex_products')
    ->where('status', 1)
    ->orderBy('name', 'ASC')
    ->limit(10)
    ->find();
```

### Query - Komplexe Abfragen

```php
// Mit Alias und JOIN
$products = rex_yform_manager_dataset::query('rex_products')
    ->alias('p')
    ->joinRelation('category_id', 'c') // Folgt Relation-Feld
    ->select('c.name', 'category_name')
    ->where('p.status', 1)
    ->orderBy('p.name')
    ->find();

foreach ($products as $product) {
    echo $product->name . ' - ' . $product->category_name;
}

// Raw SQL
$products = rex_yform_manager_dataset::query('rex_products')
    ->whereRaw('LOWER(name) LIKE ?', ['%redaxo%'])
    ->selectRaw('COUNT(*) as total')
    ->find();
```

### Query - Count & Exists

```php
// Anzahl
$count = rex_yform_manager_dataset::query('rex_products')
    ->where('status', 1)
    ->count();

echo 'Aktive Produkte: ' . $count;

// Existiert?
$exists = rex_yform_manager_dataset::query('rex_products')
    ->where('sku', 'PROD-123')
    ->exists();

if ($exists) {
    echo 'SKU bereits vergeben';
}
```

### Query - Pagination

```php
// Seite 1, 20 Einträge pro Seite
$page = rex_request::get('page', 'int', 1);

$result = rex_yform_manager_dataset::query('rex_products')
    ->where('status', 1)
    ->orderBy('name')
    ->paginate($page, 20);

// $result = ['items' => Collection, 'total' => int, 'page' => int, 'perPage' => int, 'pages' => int]

foreach ($result['items'] as $product) {
    echo $product->name . '<br>';
}

// Pagination ausgeben
echo 'Seite ' . $result['page'] . ' von ' . $result['pages'];
echo ' (' . $result['total'] . ' gesamt)';
```

### Query - Chunk Processing

```php
// Große Datenmengen in Batches verarbeiten
rex_yform_manager_dataset::query('rex_products')
    ->chunk(100, function($products) {
        foreach ($products as $product) {
            // Verarbeitung
            $product->processHeavyOperation();
        }
    });
```

### Relationen - belongsTo (n:1)

```php
// Produkt hat eine Kategorie (category_id Relation-Feld)
$product = rex_yform_manager_dataset::get(42, 'rex_products');

// Kategorie laden
$category = $product->getRelatedDataset('category_id');
if ($category) {
    echo $category->name;
}

// Oder direkt via JOIN
$product = rex_yform_manager_dataset::query('rex_products')
    ->joinRelation('category_id', 'c')
    ->select('c.name', 'category_name')
    ->findId(42);

echo $product->category_name;
```

### Relationen - hasMany (1:n)

```php
// Kategorie hat viele Produkte
$category = rex_yform_manager_dataset::get(5, 'rex_categories');

// Alle Produkte der Kategorie
$products = $category->getRelatedCollection('category_id', 'rex_products');

foreach ($products as $product) {
    echo $product->name;
}

// Mit Filter
$products = rex_yform_manager_dataset::query('rex_products')
    ->where('category_id', $category->id)
    ->where('status', 1)
    ->orderBy('name')
    ->find();
```

### Frontend-Formular (Pipe-Notation)

```php
// In Modul-Ausgabe
$yform = rex_yform::factory();

// Formular-Parameter
$yform->setObjectparams('form_action', rex_getUrl());
$yform->setObjectparams('form_method', 'post');
$yform->setObjectparams('form_showformafterupdate', 0);

// Felder (Pipe-Notation)
$yform->setValueField('text', ['name', 'Name*']);
$yform->setValueField('text', ['email', 'E-Mail*']);
$yform->setValueField('textarea', ['message', 'Nachricht*']);

// Validierung
$yform->setValidateField('empty', ['name', 'Bitte Namen angeben']);
$yform->setValidateField('empty', ['email', 'Bitte E-Mail angeben']);
$yform->setValidateField('email', ['email', 'Ungültige E-Mail']);

// Aktion: E-Mail senden
$yform->setActionField('email', [
    'empfänger@example.com',
    'Kontaktformular',
    'Name: ###name###\nE-Mail: ###email###\nNachricht:\n###message###'
]);

// Erfolgs-Meldung
$yform->setActionField('showtext', ['', 'Vielen Dank für Ihre Nachricht!']);

// Ausgabe
echo $yform->getForm();
```

### Frontend-Formular (PHP-API)

```php
$yform = rex_yform::factory();

$yform->setObjectparams('form_action', rex_getUrl());

// Text-Feld
$yform->setValueField('text', [
    'name' => 'name',
    'label' => 'Name',
    'notice' => 'Ihr vollständiger Name'
]);

// Select mit Optionen
$yform->setValueField('select', [
    'name' => 'category',
    'label' => 'Kategorie',
    'options' => 'Allgemein,Support,Vertrieb'
]);

// Checkbox
$yform->setValueField('checkbox', [
    'name' => 'newsletter',
    'label' => 'Newsletter abonnieren'
]);

echo $yform->getForm();
```

### Frontend-Formular in DB speichern

```php
$yform = rex_yform::factory();

$yform->setObjectparams('form_action', rex_getUrl());

// Felder
$yform->setValueField('text', ['name', 'Name*']);
$yform->setValueField('text', ['email', 'E-Mail*']);
$yform->setValueField('textarea', ['message', 'Nachricht*']);

// Validierung
$yform->setValidateField('empty', ['name', 'Pflichtfeld']);
$yform->setValidateField('email', ['email', 'Ungültige E-Mail']);

// In DB speichern (rex_contact_messages)
$yform->setActionField('db', [
    'rex_contact_messages', // Tabellenname
    'name,email,message,createdate', // Felder
    '', // Main-ID (leer = INSERT)
    '', // DB-Feld für Main-ID
    '', // Hidden-Felder
    '', // Auto-Felder (z.B. createdate=NOW())
]);

// Erfolgs-Meldung
$yform->setActionField('showtext', ['', 'Nachricht gespeichert!']);

echo $yform->getForm();
```

### Dataset-Formular im Frontend

```php
// Bestehenden Datensatz bearbeiten
$product = rex_yform_manager_dataset::get($id, 'rex_products');

if ($product) {
    // Formular aus Dataset generieren
    $yform = $product->getForm();
    
    // Parameter anpassen
    $yform->setObjectparams('form_action', rex_getUrl(REX_ARTICLE_ID, '', ['id' => $id]));
    $yform->setObjectparams('form_method', 'post');
    $yform->setObjectparams('getdata', true); // Daten laden
    
    // Erfolgs-Meldung
    $yform->setActionField('showtext', ['', 'Produkt aktualisiert']);
    
    // Ausgabe
    echo $product->executeForm($yform);
}
```

### Neuen Datensatz via Frontend-Formular

```php
// Neuen Datensatz erstellen
$product = rex_yform_manager_dataset::create('rex_products');

// Formular generieren
$yform = $product->getForm();

$yform->setObjectparams('form_action', rex_getUrl());
$yform->setActionField('showtext', ['', 'Produkt erstellt!']);

// Ausgabe
echo $product->executeForm($yform);
```

### Custom Templates

```php
// Custom Template-Pfad registrieren (boot.php)
rex_yform::addTemplatePath(rex_path::addon('project', 'ytemplates'));

// Template-Struktur:
// project/ytemplates/
//   bootstrap/
//     value.text.tpl.php
//     value.textarea.tpl.php
//   foundation/
//     ...

// Im Formular Template setzen
$yform->setObjectparams('form_ytemplate', 'bootstrap');
```

### E-Mail-Versand mit Anhang

```php
$yform = rex_yform::factory();

$yform->setObjectparams('form_action', rex_getUrl());

// Felder
$yform->setValueField('text', ['name', 'Name']);
$yform->setValueField('text', ['email', 'E-Mail']);
$yform->setValueField('upload', ['attachment', 'Anhang', '', '', 1]); // 1 = erforderlich

// E-Mail mit Anhang
$yform->setActionField('email', [
    'empfänger@example.com', // An
    'Kontakt mit Anhang', // Betreff
    'Name: ###name###\nE-Mail: ###email###', // Body
    '', // Von (leer = aus Config)
    '', // Von-Name
    '', // Reply-To
    '', // BCC
    '', // CC
    '', // Anhänge-Feld: attachment
    'attachment'
]);

echo $yform->getForm();
```

### Validierung - Komplexe Regeln

```php
$yform = rex_yform::factory();

// Pflichtfeld
$yform->setValidateField('empty', ['name', 'Name ist Pflicht']);

// E-Mail
$yform->setValidateField('email', ['email', 'Ungültige E-Mail']);

// Länge (min, max)
$yform->setValidateField('type', ['password', 'string', 'Passwort muss Text sein']);
$yform->setValidateField('compare_value', ['password', '>=', 8, 'Mindestens 8 Zeichen']);

// RegEx
$yform->setValidateField('preg_match', ['phone', '/^[0-9\s\-\+]+$/', 'Nur Zahlen, Leerzeichen, +, -']);

// Custom Validation
$yform->setValidateField('customfunction', [
    'email',
    'myCustomValidator',
    '',
    'E-Mail bereits registriert'
]);

// In lib/functions.php
function myCustomValidator($email, $params) {
    $exists = rex_yform_manager_dataset::query('rex_users')
        ->where('email', $email)
        ->exists();
    
    return !$exists; // true = valid, false = invalid
}
```

### Datensatz-Events

```php
// In Custom Model Class

class Product extends rex_yform_manager_dataset
{
    // Before Save
    public function preSave()
    {
        // Slug generieren
        if (empty($this->slug)) {
            $this->slug = rex_string::normalize($this->name);
        }
        
        // Timestamps
        if (!$this->getId()) {
            $this->created_at = date('Y-m-d H:i:s');
        }
        $this->updated_at = date('Y-m-d H:i:s');
    }
    
    // After Save
    public function postSave()
    {
        // Cache löschen
        rex_delete_cache();
        
        // Benachrichtigung
        if ($this->wasModified('status') && $this->status == 1) {
            $this->sendPublishNotification();
        }
    }
    
    // Before Delete
    public function preDelete()
    {
        // Beziehungen löschen
        rex_sql::factory()
            ->setTable('rex_product_images')
            ->setWhere(['product_id' => $this->id])
            ->delete();
    }
}
```

### Mass Operations

```php
// Mehrere Datensätze auf einmal aktualisieren
$products = rex_yform_manager_dataset::query('rex_products')
    ->where('category_id', 5)
    ->find();

foreach ($products as $product) {
    $product->status = 0;
    $product->save();
}

// Oder via SQL (schneller für große Mengen)
rex_sql::factory()
    ->setTable('rex_products')
    ->setWhere(['category_id' => 5])
    ->setValue('status', 0)
    ->update();
```

### Soft Deletes

```php
// In Custom Model mit deleted_at Feld

class Product extends rex_yform_manager_dataset
{
    // Überschreibe delete()
    public function delete()
    {
        $this->deleted_at = date('Y-m-d H:i:s');
        return $this->save();
    }
    
    // Query-Scope für nur aktive
    public static function active()
    {
        return static::query()
            ->whereRaw('deleted_at IS NULL');
    }
    
    // Wiederherstellen
    public function restore()
    {
        $this->deleted_at = null;
        return $this->save();
    }
}

// Verwendung
$products = Product::active()->find(); // Nur nicht-gelöschte
```

### Export nach CSV

```php
// Datensätze exportieren
$products = rex_yform_manager_dataset::query('rex_products')
    ->where('status', 1)
    ->orderBy('name')
    ->find();

header('Content-Type: text/csv; charset=UTF-8');
header('Content-Disposition: attachment; filename="products.csv"');

$fp = fopen('php://output', 'w');

// Header
fputcsv($fp, ['ID', 'Name', 'Price', 'SKU'], ';');

// Daten
foreach ($products as $product) {
    fputcsv($fp, [
        $product->id,
        $product->name,
        $product->price,
        $product->sku
    ], ';');
}

fclose($fp);
exit;
```

### Import aus CSV

```php
// CSV importieren
$file = $_FILES['import']['tmp_name'];

if (($handle = fopen($file, 'r')) !== false) {
    // Header überspringen
    fgetcsv($handle, 1000, ';');
    
    while (($data = fgetcsv($handle, 1000, ';')) !== false) {
        $product = rex_yform_manager_dataset::create('rex_products');
        $product->name = $data[0];
        $product->price = $data[1];
        $product->sku = $data[2];
        $product->status = 1;
        
        if (!$product->save()) {
            echo 'Fehler: ' . implode(', ', $product->getMessages());
        }
    }
    
    fclose($handle);
    echo 'Import abgeschlossen';
}
```

### Table Cache löschen

```php
// Nach Schema-Änderungen Cache löschen
rex_yform_manager_table::deleteCache();

// Z.B. in update.php nach Tabellen-Änderungen
$addon = rex_addon::get('myAddon');

// Tabelle modifizieren
$sql = rex_sql::factory();
$sql->setQuery('ALTER TABLE rex_my_table ADD COLUMN new_field VARCHAR(255)');

// Cache löschen
rex_yform_manager_table::deleteCache();
```

### JSON-Export

```php
// Datensätze als JSON
$products = rex_yform_manager_dataset::query('rex_products')
    ->where('status', 1)
    ->find();

$data = [];
foreach ($products as $product) {
    $data[] = [
        'id' => $product->id,
        'name' => $product->name,
        'price' => $product->price,
        'category' => $product->getRelatedDataset('category_id')->name ?? null
    ];
}

header('Content-Type: application/json');
echo json_encode($data, JSON_PRETTY_PRINT);
exit;
```

### REST API mit YForm

```php
// API-Endpoint in lib/Api.php

class Product_Api extends rex_yform_rest
{
    public function get()
    {
        $id = rex_request::get('id', 'int');
        
        if ($id) {
            // Einzelner Datensatz
            $product = rex_yform_manager_dataset::get($id, 'rex_products');
            return $this->sendJson($product ? $product->getData() : null);
        }
        
        // Liste
        $products = rex_yform_manager_dataset::query('rex_products')
            ->where('status', 1)
            ->find();
        
        $data = [];
        foreach ($products as $product) {
            $data[] = $product->getData();
        }
        
        return $this->sendJson($data);
    }
    
    public function post()
    {
        $data = json_decode(file_get_contents('php://input'), true);
        
        $product = rex_yform_manager_dataset::create('rex_products');
        $product->setData($data);
        
        if ($product->save()) {
            return $this->sendJson($product->getData(), 201);
        }
        
        return $this->sendJson(['errors' => $product->getMessages()], 400);
    }
}
```
