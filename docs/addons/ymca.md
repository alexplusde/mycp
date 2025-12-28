# YMCA - YForm Model Class Accelerator | Keywords: Code-Generator, YOrm, Dataset-Klassen, RESTful API, Getter/Setter, Type-Hints, Dokumentation, OpenAPI

**Übersicht**: Generiert typsichere YOrm-Dataset-Klassen mit Getter/Setter-Methoden, Field-Konstanten und optionalen Zusatzgeneratoren (RESTful API, PDF-Fragments, Dokumentation, OpenAPI-Specs). Nutzt nette/php-generator für Single Point of Truth und verbesserte IDE-Unterstützung.

## Generator-Typen

| Typ | Beschreibung |
|-----|-------------|
| `YOrm Class` | Dataset-Klasse mit Getter/Setter |
| `RESTful API` | API-Routes für CRUD-Operationen |
| `PDF Fragment` | Fragment für PDF-Generierung |
| `Documentation` | Markdown-Dokumentation |
| `Dotlang` | Übersetzungsdateien (.lang) |
| `OpenAPI` | OpenAPI 3.0 Specification |

## Field-Konstanten (FIELD_*)

| Typ | Konstante | Beispiel |
|-----|-----------|----------|
| `text` | `FIELD_NAME` | `'name'` |
| `integer` | `FIELD_ID` | `'id'` |
| `be_media` | `FIELD_IMAGE` | `'image'` |
| `be_link` | `FIELD_ARTICLE_ID` | `'article_id'` |
| `datetime` | `FIELD_CREATED_AT` | `'created_at'` |
| `datestamp` | `FIELD_TIMESTAMP` | `'timestamp'` |

## Unterstützte Feldtypen

| YForm-Typ | PHP-Typ | Return-Type |
|-----------|---------|-------------|
| `text` | string | `?string` |
| `textarea` | string | `?string` |
| `integer` | int | `?int` |
| `be_media` | rex_media | `?rex_media` |
| `be_link` | rex_article | `?rex_article` |
| `be_manager_relation` | rex_yform_manager_collection | `rex_yform_manager_collection` |
| `datetime` | DateTime | `?DateTime` |
| `datestamp` | int | `?int` |
| `choice` | mixed | `?string` |
| `checkbox` | bool | `bool` |
| `float` | float | `?float` |
| `email` | string | `?string` |
| `url` | string | `?string` |
| `domain` | string | `?string` |
| `ip` | string | `?string` |

## Praxisbeispiele

### Beispiel 1: Einfache Klasse generieren

Im Backend unter `YForm` > `Tabellenverwaltung` > `rex_events`:

- Button "YMCA" klicken
- Generator: YOrm Class
- Namespace: `App\Models`
- Klasse generieren

### Beispiel 2: Generierte Klasse verwenden

```php
// Generierte Klasse: src/models/Event.php
namespace App\Models;

use rex_yform_manager_dataset;

class Event extends rex_yform_manager_dataset
{
    // Field-Konstanten (Single Point of Truth)
    public const FIELD_ID = 'id';
    public const FIELD_NAME = 'name';
    public const FIELD_DATE = 'date';
    public const FIELD_IMAGE = 'image';
    
    // Getter mit Type-Hints
    public function getName(): ?string
    {
        return $this->getValue(self::FIELD_NAME);
    }
    
    public function getDate(): ?DateTime
    {
        $value = $this->getValue(self::FIELD_DATE);
        return $value ? new DateTime($value) : null;
    }
    
    public function getImage(): ?rex_media
    {
        $value = $this->getValue(self::FIELD_IMAGE);
        return $value ? rex_media::get($value) : null;
    }
    
    // Setter mit Type-Hints
    public function setName(?string $value): self
    {
        $this->setValue(self::FIELD_NAME, $value);
        return $this;
    }
    
    public function setDate(?DateTime $value): self
    {
        $this->setValue(self::FIELD_DATE, $value?->format('Y-m-d H:i:s'));
        return $this;
    }
    
    public function setImage(?rex_media $value): self
    {
        $this->setValue(self::FIELD_IMAGE, $value?->getFileName());
        return $this;
    }
}
```

### Beispiel 3: Field-Konstanten nutzen

```php
use App\Models\Event;

// Statt String-Namen:
$event->getValue('name');

// Field-Konstanten verwenden:
$event->getValue(Event::FIELD_NAME);

// IDE-Unterstützung + Single Point of Truth
// Bei Feldänderung nur Konstante anpassen
```

### Beispiel 4: Typisierte Getter

```php
$event = Event::get(1);

// String
$name = $event->getName(); // ?string

// DateTime
$date = $event->getDate(); // ?DateTime
echo $date->format('d.m.Y'); // Type-safe!

// Media
$image = $event->getImage(); // ?rex_media
echo $image?->getUrl();
```

### Beispiel 5: Fluent Setter

```php
$event = Event::create()
    ->setName('Konzert')
    ->setDate(new DateTime('2024-12-31'))
    ->setImage(rex_media::get('concert.jpg'))
    ->save();

// Method-Chaining durch return $this
```

### Beispiel 6: be_link Relation

```php
// YForm-Feld: be_link|article_id|Artikel
// Generierter Getter:

public function getArticle(): ?rex_article
{
    $value = $this->getValue(self::FIELD_ARTICLE_ID);
    return $value ? rex_article::get($value) : null;
}

// Verwendung:
$event = Event::get(1);
$article = $event->getArticle();
echo $article?->getName();
```

### Beispiel 7: be_manager_relation

```php
// YForm-Feld: be_manager_relation|speakers|Speaker|1-n
// Generierter Getter:

public function getSpeakers(): rex_yform_manager_collection
{
    return $this->getRelatedCollection(self::FIELD_SPEAKERS);
}

// Verwendung:
$event = Event::get(1);
foreach ($event->getSpeakers() as $speaker) {
    echo $speaker->getName();
}
```

### Beispiel 8: RESTful API generieren

Generator: RESTful API
Ausgabe:

```php
// routes/api.php

// GET /api/events
rex_api_function::setRoute('GET', 'api/events', function() {
    $events = Event::query()->find();
    return rex_api_response::json($events);
});

// GET /api/events/:id
rex_api_function::setRoute('GET', 'api/events/:id', function($id) {
    $event = Event::get($id);
    return rex_api_response::json($event);
});

// POST /api/events
rex_api_function::setRoute('POST', 'api/events', function() {
    $data = rex_request::post();
    $event = Event::create();
    $event->setData($data);
    $event->save();
    return rex_api_response::json($event, 201);
});

// PUT /api/events/:id
rex_api_function::setRoute('PUT', 'api/events/:id', function($id) {
    $event = Event::get($id);
    $data = rex_request::post();
    $event->setData($data);
    $event->save();
    return rex_api_response::json($event);
});

// DELETE /api/events/:id
rex_api_function::setRoute('DELETE', 'api/events/:id', function($id) {
    $event = Event::get($id);
    $event->delete();
    return rex_api_response::json(null, 204);
});
```

### Beispiel 9: PDF-Fragment generieren

Generator: PDF Fragment
Ausgabe:

```php
// fragments/pdf/event.php
<?php
/** @var Event $event */
?>
<h1><?= $event->getName() ?></h1>
<p><strong>Datum:</strong> <?= $event->getDate()?->format('d.m.Y') ?></p>

<?php if ($image = $event->getImage()): ?>
    <img src="<?= $image->getUrl() ?>" alt="">
<?php endif; ?>

<p><?= $event->getDescription() ?></p>
```

### Beispiel 10: Markdown-Dokumentation

Generator: Documentation
Ausgabe:

```markdown
# Event Model

## Fields

- **id** (integer): Primary Key
- **name** (text): Event name
- **date** (datetime): Event date
- **image** (be_media): Event image

## Methods

### getName(): ?string
Returns the event name.

### getDate(): ?DateTime
Returns the event date as DateTime object.

### getImage(): ?rex_media
Returns the event image as rex_media object.

## Usage

```php
$event = Event::get(1);
echo $event->getName();
echo $event->getDate()->format('d.m.Y');
```

```

### Beispiel 11: Dotlang-Dateien

Generator: Dotlang
Ausgabe:
```

# de_de.lang

event_field_id = ID
event_field_name = Name
event_field_date = Datum
event_field_image = Bild

# en_gb.lang

event_field_id = ID
event_field_name = Name
event_field_date = Date
event_field_image = Image

```

### Beispiel 12: OpenAPI Specification

Generator: OpenAPI
Ausgabe:
```yaml
openapi: 3.0.0
info:
  title: Event API
  version: 1.0.0
paths:
  /api/events:
    get:
      summary: List all events
      responses:
        '200':
          description: Success
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Event'
    post:
      summary: Create event
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/Event'
      responses:
        '201':
          description: Created
components:
  schemas:
    Event:
      type: object
      properties:
        id:
          type: integer
        name:
          type: string
        date:
          type: string
          format: date-time
        image:
          type: string
```

### Beispiel 13: Checkbox/Bool-Felder

```php
// YForm-Feld: checkbox|is_published|Veröffentlicht
// Generierter Code:

public const FIELD_IS_PUBLISHED = 'is_published';

public function isPublished(): bool
{
    return (bool) $this->getValue(self::FIELD_IS_PUBLISHED);
}

public function setIsPublished(bool $value): self
{
    $this->setValue(self::FIELD_IS_PUBLISHED, $value ? 1 : 0);
    return $this;
}

// Verwendung:
if ($event->isPublished()) {
    echo 'Veröffentlicht';
}
```

### Beispiel 14: Choice-Felder

```php
// YForm-Feld: choice|status|Status|draft=Entwurf,published=Veröffentlicht
// Generierter Code:

public const FIELD_STATUS = 'status';
public const STATUS_DRAFT = 'draft';
public const STATUS_PUBLISHED = 'published';

public function getStatus(): ?string
{
    return $this->getValue(self::FIELD_STATUS);
}

public function isDraft(): bool
{
    return $this->getStatus() === self::STATUS_DRAFT;
}

public function isPublished(): bool
{
    return $this->getStatus() === self::STATUS_PUBLISHED;
}
```

### Beispiel 15: Float-Felder

```php
// YForm-Feld: number|price|Preis
// Generierter Code:

public const FIELD_PRICE = 'price';

public function getPrice(): ?float
{
    return $this->getValue(self::FIELD_PRICE) !== null 
        ? (float) $this->getValue(self::FIELD_PRICE) 
        : null;
}

public function setPrice(?float $value): self
{
    $this->setValue(self::FIELD_PRICE, $value);
    return $this;
}

// Verwendung:
echo number_format($event->getPrice(), 2) . ' €';
```

### Beispiel 16: Multiple Relationen

```php
// be_manager_relation|categories|Category|n-m

public function getCategories(): rex_yform_manager_collection
{
    return $this->getRelatedCollection(self::FIELD_CATEGORIES);
}

public function addCategory(Category $category): self
{
    $this->addRelation(self::FIELD_CATEGORIES, $category);
    return $this;
}

public function removeCategory(Category $category): self
{
    $this->removeRelation(self::FIELD_CATEGORIES, $category);
    return $this;
}
```

### Beispiel 17: Custom Methods hinzufügen

```php
// Generierte Klasse erweitern
namespace App\Models;

class Event extends rex_yform_manager_dataset
{
    // ... generierte Methoden ...
    
    // Custom Methods
    public function isUpcoming(): bool
    {
        $date = $this->getDate();
        return $date && $date > new DateTime();
    }
    
    public function isPast(): bool
    {
        return !$this->isUpcoming();
    }
    
    public function getFormattedDate(): string
    {
        return $this->getDate()?->format('d.m.Y H:i') ?? '';
    }
}
```

### Beispiel 18: Batch-Generierung

```php
// Alle YForm-Tabellen durchlaufen
$tables = rex_yform_manager_table::getAll();

foreach ($tables as $table) {
    $generator = new \Alexplusde\Ymca\YormGenerator($table);
    $generator->generate();
    
    echo 'Generiert: ' . $table->getTableName() . '<br>';
}
```

### Beispiel 19: Namespace konfigurieren

Im Backend: YForm > YMCA > Einstellungen

- **Namespace**: `App\Models`
- **Output Directory**: `src/models/`
- **Generate API**: Ja
- **Generate Docs**: Ja

### Beispiel 20: Email/URL-Validierung

```php
// YForm-Feld: email|contact_email|E-Mail
// Generierter Code:

public function getContactEmail(): ?string
{
    return $this->getValue(self::FIELD_CONTACT_EMAIL);
}

public function setContactEmail(?string $value): self
{
    if ($value && !filter_var($value, FILTER_VALIDATE_EMAIL)) {
        throw new InvalidArgumentException('Invalid email address');
    }
    $this->setValue(self::FIELD_CONTACT_EMAIL, $value);
    return $this;
}
```

### Beispiel 21: Datestamp zu DateTime

```php
// YForm-Feld: datestamp|created_at|Erstellt am
// Generierter Code:

public function getCreatedAt(): ?DateTime
{
    $timestamp = $this->getValue(self::FIELD_CREATED_AT);
    return $timestamp ? DateTime::createFromFormat('U', $timestamp) : null;
}

public function setCreatedAt(?DateTime $value): self
{
    $this->setValue(self::FIELD_CREATED_AT, $value?->getTimestamp());
    return $this;
}
```

### Beispiel 22: Domain-Feld

```php
// YForm-Feld: domain|website|Website
// Generierter Code:

public function getWebsite(): ?string
{
    return $this->getValue(self::FIELD_WEBSITE);
}

public function getWebsiteUrl(): ?string
{
    $domain = $this->getWebsite();
    return $domain ? 'https://' . $domain : null;
}
```

### Beispiel 23: Alle Konstanten auslesen

```php
// FIELD_CONFIG Konstante enthält alle Felder
class Event extends rex_yform_manager_dataset
{
    public const FIELD_CONFIG = [
        'id' => ['type' => 'integer', 'label' => 'ID'],
        'name' => ['type' => 'text', 'label' => 'Name'],
        'date' => ['type' => 'datetime', 'label' => 'Datum'],
    ];
}

// Verwendung:
foreach (Event::FIELD_CONFIG as $field => $config) {
    echo $config['label'] . ': ' . $event->getValue($field) . '<br>';
}
```

### Beispiel 24: PHPDoc für IDE

```php
// Generierte Klasse mit vollständigem PHPDoc
/**
 * Event Model
 * 
 * @property int $id
 * @property string $name
 * @property string $date
 * @property string $image
 * 
 * @method ?string getName()
 * @method ?DateTime getDate()
 * @method ?rex_media getImage()
 * @method self setName(?string $value)
 * @method self setDate(?DateTime $value)
 * @method self setImage(?rex_media $value)
 */
class Event extends rex_yform_manager_dataset
{
    // ...
}
```

### Beispiel 25: Re-Generierung nach Schema-Änderung

```php
// Nach YForm-Feldänderung neu generieren
// Backend: YForm > Tabelle > YMCA-Button

// Oder via Extension Point:
rex_extension::register('YFORM_DATA_UPDATED', function($ep) {
    $table = $ep->getParam('table');
    
    if ($table->getTableName() == 'rex_events') {
        $generator = new \Alexplusde\Ymca\YormGenerator($table);
        $generator->generate();
    }
});
```

**Integration**: YForm (YOrm Datasets, Tabellenverwaltung), nette/php-generator (Code-Generierung), rex_api_function (RESTful API), rex_fragment (PDF-Templates), OpenAPI Standards, IDE Integration (PHPDoc, Type-Hints), Extension Points (YFORM_DATA_UPDATED), Single Point of Truth Pattern (Field-Konstanten)
