# rex_csrf_token

**CSRF-Protection für Formulare (Cross-Site Request Forgery)**

**Keywords:** csrf, security, token, form, protection, xsrf

---

## Methodenübersicht

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `factory()` | `string $tokenId` | `rex_csrf_token` | Token-Instanz für ID erstellen |
| `getId()` | - | `string` | Token-ID abrufen |
| `getValue()` | - | `string` | Token-Wert (Hash) generieren/abrufen |
| `getHiddenField()` | - | `string` | HTML Hidden-Input `<input type="hidden" ...>` |
| `getUrlParams()` | - | `array` | Array für URL-Parameter: `['_csrf_token' => '...']` |
| `isValid()` | - | `bool` | Prüft ob gesendeter Token valid |
| `remove()` | - | `void` | Token aus Session entfernen |
| `removeAll()` | - | `void` | Alle Tokens aus Session entfernen (statisch) |

**Konstanten:**

- `rex_csrf_token::PARAM` = `'_csrf_token'` (Request-Parameter-Name)

---

## Praxisbeispiele

### Einfaches Formular mit CSRF-Protection

```php
// Token erstellen
$csrfToken = rex_csrf_token::factory('my_form');

// Formular-Verarbeitung
if (rex_request::isPOSTRequest()) {
    if (!$csrfToken->isValid()) {
        echo rex_view::error('Ungültiger CSRF-Token!');
        exit;
    }
    
    // Formular-Daten verarbeiten
    $name = rex_post('name', 'string');
    // ...
    
    echo rex_view::success('Erfolgreich gespeichert.');
}
?>

<form method="post">
    <?= $csrfToken->getHiddenField() ?>
    
    <input type="text" name="name" class="form-control">
    <button type="submit" class="btn btn-save">Speichern</button>
</form>
```

### CSRF-Token in GET-Links (DELETE-Actions)

```php
$csrfToken = rex_csrf_token::factory('delete_item');

// URL mit CSRF-Parameter
$deleteUrl = rex_url::currentBackendPage(array_merge([
    'func' => 'delete',
    'id' => $id
], $csrfToken->getUrlParams()));

echo '<a href="' . $deleteUrl . '" data-confirm="Wirklich löschen?">Löschen</a>';

// Verarbeitung
if (rex_get('func', 'string') === 'delete') {
    if (!$csrfToken->isValid()) {
        echo rex_view::error('Ungültiger CSRF-Token!');
        exit;
    }
    
    $id = rex_get('id', 'int');
    // Löschen...
}
```

### AJAX-Requests mit CSRF

```php
// Backend-Page
$csrfToken = rex_csrf_token::factory('ajax_action');
?>
<script>
// Token in JavaScript verfügbar machen
const csrfToken = '<?= $csrfToken->getValue() ?>';

// AJAX-Request
fetch('index.php?page=myaddon/ajax', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken
    },
    body: JSON.stringify({ action: 'save', data: {...} })
})
.then(response => response.json())
.then(data => console.log(data));
</script>

<?php
// ajax.php
$csrfToken = rex_csrf_token::factory('ajax_action');

// Token aus Header oder POST prüfen
$tokenFromHeader = $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
$tokenFromPost = rex_post('_csrf_token', 'string');

// Manuell validieren (da Token nicht im Standard-POST-Parameter)
$_POST['_csrf_token'] = $tokenFromHeader ?: $tokenFromPost;

if (!$csrfToken->isValid()) {
    rex_response::setStatus(403);
    rex_response::sendJson(['error' => 'Invalid CSRF token']);
}

// Verarbeitung...
rex_response::sendJson(['success' => true]);
```

### rex_form mit automatischem CSRF

```php
// rex_form integriert CSRF automatisch
$form = rex_form::factory('rex_article', 'Artikel', 'id=' . $id);
// CSRF-Token wird automatisch hinzugefügt und validiert

$form->addTextField('name');
$form->show();

// Intern: rex_csrf_token::factory('rex_form_' . $form->getName())
```

### Mehrere Formulare auf einer Seite

```php
// Unterschiedliche Token-IDs verwenden!
$csrfForm1 = rex_csrf_token::factory('form_add');
$csrfForm2 = rex_csrf_token::factory('form_edit');

// Form 1: Hinzufügen
if (rex_post('action', 'string') === 'add') {
    if (!$csrfForm1->isValid()) {
        die('Invalid token');
    }
    // Verarbeitung...
}

// Form 2: Bearbeiten
if (rex_post('action', 'string') === 'edit') {
    if (!$csrfForm2->isValid()) {
        die('Invalid token');
    }
    // Verarbeitung...
}
?>

<form method="post">
    <?= $csrfForm1->getHiddenField() ?>
    <input type="hidden" name="action" value="add">
    <!-- Felder -->
    <button type="submit">Hinzufügen</button>
</form>

<form method="post">
    <?= $csrfForm2->getHiddenField() ?>
    <input type="hidden" name="action" value="edit">
    <!-- Felder -->
    <button type="submit">Speichern</button>
</form>
```

### Token-Lebensdauer

```php
// Token ist Session-basiert
// Gültig bis:
// - Session läuft ab
// - Token wird manuell gelöscht (remove())
// - User loggt aus (removeAll())

// Token nach Verwendung entfernen (One-Time-Token)
$csrfToken = rex_csrf_token::factory('one_time_action');

if (rex_request::isPOSTRequest()) {
    if ($csrfToken->isValid()) {
        // Verarbeitung...
        $csrfToken->remove(); // Token ungültig machen
    }
}
```

### Session-Security (HTTP/HTTPS-Separation)

```php
// rex_csrf_token trennt automatisch HTTP/HTTPS-Tokens
// (verhindert Token-Diebstahl via Downgrade-Angriff)

// Session-Keys:
// - HTTP:  'csrf_tokens_' . rex::getEnvironment()
// - HTTPS: 'csrf_tokens_' . rex::getEnvironment() . '_https'

// Dies ist intern implementiert, keine manuelle Anpassung nötig
```

### Alle Tokens zurücksetzen

```php
// Bei Logout alle CSRF-Tokens entfernen
rex_csrf_token::removeAll();

// Bei Session-Hijacking-Verdacht
rex_login::startSession();
rex_csrf_token::removeAll();
session_regenerate_id(true);
```

### Custom-Token-Validierung (z.B. API)

```php
// Token-Wert abrufen für externe Verwendung
$csrfToken = rex_csrf_token::factory('api_request');
$tokenValue = $csrfToken->getValue();

// JSON-Response für Frontend
rex_response::sendJson([
    'csrf_token' => $tokenValue,
    'data' => [...]
]);

// Frontend sendet Token zurück
// Backend validiert
if (!$csrfToken->isValid()) {
    rex_response::setStatus(403);
    rex_response::sendJson(['error' => 'CSRF validation failed']);
}
```

### rex_list mit CSRF (Custom Delete-Links)

```php
$list = rex_list::factory('SELECT * FROM rex_article');

$csrfToken = rex_csrf_token::factory('delete_article');

// Delete-Link mit CSRF
$list->addColumn('delete', '<i class="rex-icon rex-icon-delete"></i> Löschen', -1);
$list->setColumnParams('delete', array_merge([
    'func' => 'delete',
    'id' => '###id###'
], $csrfToken->getUrlParams()));

// Verarbeitung
if (rex_get('func', 'string') === 'delete') {
    if (!$csrfToken->isValid()) {
        echo rex_view::error('Ungültiger CSRF-Token!');
    } else {
        $id = rex_get('id', 'int');
        // Löschen...
    }
}

$list->show();
```

### File-Upload mit CSRF

```php
$csrfToken = rex_csrf_token::factory('file_upload');

if (rex_request::isPOSTRequest()) {
    if (!$csrfToken->isValid()) {
        die('Invalid CSRF token');
    }
    
    if (isset($_FILES['upload'])) {
        $file = $_FILES['upload'];
        // Upload verarbeiten...
    }
}
?>

<form method="post" enctype="multipart/form-data">
    <?= $csrfToken->getHiddenField() ?>
    
    <input type="file" name="upload">
    <button type="submit">Hochladen</button>
</form>
```

### Extension Point Integration

```php
// In eigenem Extension Point CSRF prüfen
rex_extension::register('MY_CUSTOM_ACTION', function($ep) {
    $csrfToken = rex_csrf_token::factory('my_action');
    
    if (!$csrfToken->isValid()) {
        $ep->setSubject(false);
        return false;
    }
    
    // Verarbeitung...
    return true;
});
```

---

**Sicherheit:**

- ✅ **Immer** CSRF-Protection bei State-Changing Operations (POST, DELETE, PUT)
- ✅ Unterschiedliche Token-IDs für verschiedene Formulare/Aktionen
- ✅ Token nur in Session speichern (nie in Cookie/LocalStorage)
- ✅ HTTPS-Separation automatisch (separate Tokens für HTTP/HTTPS)
- ⚠️ GET-Requests sollten keine State-Changes verursachen (auch ohne CSRF sicher)
- ⚠️ Token nach One-Time-Use entfernen (`remove()`)
- ⚠️ Bei Logout: `removeAll()` aufrufen

**Pattern:**

```php
// 1. Token erstellen
$csrf = rex_csrf_token::factory('form_id');

// 2. In Formular einbinden
echo $csrf->getHiddenField();

// 3. Bei POST validieren
if (rex_request::isPOSTRequest()) {
    if (!$csrf->isValid()) {
        die('CSRF validation failed');
    }
    // Verarbeitung...
}
```

**Automatische Integration:**

- `rex_form` → CSRF automatisch integriert
- `rex_config_form` → CSRF automatisch integriert
- Custom Forms → Manuell `getHiddenField()` einfügen
