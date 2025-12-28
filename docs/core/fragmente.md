# `rex_fragment`: Wiederverwendbare View-Templates

Verwende `rex_fragment` für wiederverwendbare UI-Komponenten und Templates (Frontend & Backend).

## Grundlagen

```php
$fragment = new rex_fragment();
$fragment->setVar('title', 'Mein Titel');
$fragment->setVar('items', $arrayData);
echo $fragment->parse('mein-fragment.php');
```

**Speicherorte:** `fragments/` in AddOns oder `redaxo/src/core/fragments/` im Core.

## Variablen übergeben

| Methode | Zweck |
|---------|-------|
| `setVar($key, $value, $escape)` | Variable setzen (escape=false für HTML) |
| `getVar($key, $default)` | Variable auslesen |

**Im Fragment zugreifen:**

```php
// fragments/card.php
<div class="card">
    <h3><?= $this->title ?></h3>
    <p><?= $this->getVar('description', 'Keine Beschreibung') ?></p>
</div>
```

**Reservierte Variablennamen:** `filename`, `vars`, `decorator`, `fragmentDirs`

## Praxisbeispiele

### Alert-Box Fragment erstellen

```php
// fragments/alert.php
<div class="alert alert-<?= $this->type ?>" role="alert">
    <?= $this->message ?>
</div>
```

```php
// Verwendung
$fragment = new rex_fragment();
$fragment->setVar('type', 'success');
$fragment->setVar('message', 'Erfolgreich gespeichert!');
echo $fragment->parse('alert.php');
```

### Liste mit Daten ausgeben

```php
// fragments/product-list.php
<ul class="products">
    <?php foreach ($this->products as $product): ?>
        <li>
            <h4><?= rex_escape($product['name']) ?></h4>
            <p><?= $product['price'] ?> €</p>
        </li>
    <?php endforeach ?>
</ul>
```

```php
$products = rex_sql::factory()
    ->getArray('SELECT * FROM products');

$fragment = new rex_fragment();
$fragment->setVar('products', $products);
echo $fragment->parse('product-list.php');
```

### REDAXO Core-Fragment nutzen (Pagination)

```php
use rex_pager;

$pager = new rex_pager(50); // 50 Items pro Seite
$pager->setRowCount(500);   // 500 Gesamt-Items

$fragment = new rex_fragment();
$fragment->setVar('urlprovider', 'rex_article');
$fragment->setVar('pager', $pager);
echo $fragment->parse('core/navigations/pagination.php');
```

### Subfragmente einbinden

```php
// fragments/page.php
<div class="page">
    <header><?= $this->subfragment('header.php') ?></header>
    <main><?= $this->content ?></main>
    <footer><?= $this->subfragment('footer.php') ?></footer>
</div>
```

### Backend-Fragment überschreiben (Login anpassen)

Erstelle in deinem AddOn: `fragments/core/login/content.php`

```php
// Eigenes Login-Design
<div class="custom-login">
    <img src="<?= rex_url::assets('addon/logo.svg') ?>" alt="Logo">
    <?= $this->subfragment('../../default-content.php') ?>
</div>
```

### Formular-Fragment mit Fehlerbehandlung

```php
// fragments/contact-form.php
<form method="post">
    <?php if (!empty($this->errors)): ?>
        <div class="alert alert-danger">
            <ul>
                <?php foreach ($this->errors as $error): ?>
                    <li><?= rex_escape($error) ?></li>
                <?php endforeach ?>
            </ul>
        </div>
    <?php endif ?>

    <input type="text" name="email" value="<?= rex_escape($this->email) ?>">
    <button type="submit">Senden</button>
</form>
```

### Button-Group Fragment

```php
// fragments/button-group.php
<div class="btn-group" role="group">
    <?php foreach ($this->buttons as $button): ?>
        <a href="<?= $button['url'] ?>"
           class="btn btn-<?= $button['style'] ?? 'default' ?>">
            <?= $button['label'] ?>
        </a>
    <?php endforeach ?>
</div>
```

```php
$fragment = new rex_fragment();
$fragment->setVar('buttons', [
    ['label' => 'Speichern', 'url' => '#', 'style' => 'primary'],
    ['label' => 'Abbrechen', 'url' => '#', 'style' => 'secondary'],
]);
echo $fragment->parse('button-group.php');
```

## HTML-Escaping

```php
// Auto-Escape aktivieren (Standard: true)
$fragment->setVar('userInput', $data, true);

// HTML erlauben (z.B. für Editor-Inhalte)
$fragment->setVar('htmlContent', $wysiwyg, false);
```

## Core-Fragmente

Wichtige REDAXO-Fragmente zum Überschreiben oder Nutzen:

- `core/navigations/pagination.php`
- `core/buttons/button.php`
- `core/form/form.php`
- `core/login/content.php`
