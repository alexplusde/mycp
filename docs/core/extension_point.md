# `rex_extension`: Event-System, Hooks registrieren und ausführen

Verwende `rex_extension`, um auf System-Events zu reagieren oder eigene Extension Points zu erstellen.

## Wichtigste Methoden

| Methode | Zweck |
|---------|-------|
| `rex_extension::register($name, $callback, $params, $priority)` | Event-Listener registrieren |
| `rex_extension::registerPoint($extensionPoint)` | Extension Point auslösen |
| `rex_extension::isRegistered($name)` | Prüfen ob Extension registriert |

## Extension registrieren

```php
// Einfacher Callback
rex_extension::register('EXTENSION_NAME', function(rex_extension_point $ep) {
    $subject = $ep->getSubject();
    $params = $ep->getParams();

    // Subject manipulieren und zurückgeben
    return $subject;
});

// Mit Priorität (niedrigere Zahl = früher)
rex_extension::register('EXTENSION_NAME', $callback, [], rex_extension::EARLY);  // Priorität 1
rex_extension::register('EXTENSION_NAME', $callback, [], rex_extension::NORMAL); // Priorität 5
rex_extension::register('EXTENSION_NAME', $callback, [], rex_extension::LATE);   // Priorität 9
```

## Extension Point auslösen

```php
// Subject wird von Extensions modifiziert
$content = '<h1>Title</h1>';
$content = rex_extension::registerPoint(new rex_extension_point(
    'MY_EXTENSION',
    $content,
    ['page_id' => 123]
));

// Readonly Extension (Subject kann nicht geändert werden)
rex_extension::registerPoint(new rex_extension_point(
    'MY_READONLY_EVENT',
    $data,
    ['user_id' => 5],
    true  // readonly
));
```

## Extension Point Objekt

| Methode | Zweck |
|---------|-------|
| `$ep->getName()` | Extension-Name |
| `$ep->getSubject()` | Subject abrufen |
| `$ep->setSubject($value)` | Subject setzen (wenn nicht readonly) |
| `$ep->getParam($key, $default)` | Parameter abrufen |
| `$ep->hasParam($key)` | Parameter existiert? |
| `$ep->getParams()` | Alle Parameter |
| `$ep->isReadonly()` | Ist readonly? |

## Wichtige Core Extension Points

### Frontend

| Name | Subject | Verwendung |
|------|---------|------------|
| `FE_OUTPUT` | string | HTML-Output vor Ausgabe manipulieren |
| `OUTPUT_FILTER` | string | Finaler Output-Filter (Backend + Frontend) |
| `URL_REWRITE` | rex_url | URL-Generierung beeinflussen |

### Backend

| Name | Subject | Verwendung |
|------|---------|------------|
| `PAGE_HEADER` | string | Header im Backend erweitern |
| `PAGE_TITLE` | string | Seiten-Titel ändern |
| `PAGE_SIDEBAR` | string | Sidebar-Content hinzufügen |

### Pakete

| Name | Subject | Verwendung |
|------|---------|------------|
| `PACKAGES_INCLUDED` | - | Alle Pakete geladen |
| `ADDON_INSTALL` | bool | Addon wird installiert |
| `ADDON_UNINSTALL` | bool | Addon wird deinstalliert |
| `ADDON_ACTIVATE` | bool | Addon wird aktiviert |
| `ADDON_DEACTIVATE` | bool | Addon wird deaktiviert |

### User & Auth

| Name | Subject | Verwendung |
|------|---------|------------|
| `USER_ADDED` | - | User erstellt |
| `USER_UPDATED` | - | User aktualisiert |
| `USER_DELETED` | - | User gelöscht |
| `PASSWORD_UPDATED` | - | Passwort geändert |

### Medienpool

| Name | Subject | Verwendung |
|------|---------|------------|
| `MEDIA_ADDED` | rex_media | Medium hochgeladen |
| `MEDIA_UPDATED` | rex_media | Medium aktualisiert |
| `MEDIA_DELETED` | string | Medium gelöscht (Dateiname) |

## Praxisbeispiele

### HTML-Output im Frontend manipulieren

```php
// In boot.php
rex_extension::register('FE_OUTPUT', function(rex_extension_point $ep) {
    $content = $ep->getSubject();

    // Lazy Loading für Bilder hinzufügen
    $content = str_replace('<img ', '<img loading="lazy" ', $content);

    // Analytics-Code einfügen
    $content = str_replace('</body>', '<script>/* Analytics */</script></body>', $content);

    return $content;
});
```

### Auf Addon-Installation reagieren

```php
rex_extension::register('ADDON_INSTALL', function(rex_extension_point $ep) {
    $addon = $ep->getParam('addon');

    if ($addon === 'my_addon') {
        // Custom Installation Logic
        rex_sql_table::get(rex::getTable('my_table'))
            ->ensureColumn(new rex_sql_column('id', 'int'))
            ->setPrimaryKey('id')
            ->ensure();
    }

    return $ep->getSubject();
});
```

### Backend-Navigation erweitern

```php
rex_extension::register('PACKAGES_INCLUDED', function() {
    if (rex::isBackend() && rex::getUser()) {
        rex_be_controller::getPageObject('system')->addSubpage(
            (new rex_be_page('my_page', 'My Page'))
                ->setHref('index.php?page=my_addon/main')
        );
    }
});
```

### Media Manager Effekt hinzufügen

```php
rex_extension::register('MEDIA_MANAGER_FILTERSET', function(rex_extension_point $ep) {
    $effects = $ep->getSubject();
    $effects[] = 'my_custom_effect';
    return $effects;
});
```

### User-Login überwachen

```php
rex_extension::register('USER_LOGIN_SUCCESS', function(rex_extension_point $ep) {
    $user = $ep->getParam('user');
    $login = $ep->getParam('login');

    rex_logger::factory()->log('info', sprintf(
        'User %s logged in from %s',
        $user->getLogin(),
        rex_server('REMOTE_ADDR', 'string')
    ));
});
```

### Eigenen Extension Point erstellen

```php
// In deinem AddOn-Code
$data = ['items' => [], 'count' => 0];

$data = rex_extension::registerPoint(new rex_extension_point(
    'MY_ADDON_DATA_LOAD',
    $data,
    ['context' => 'frontend']
));

// Andere AddOns können darauf reagieren
rex_extension::register('MY_ADDON_DATA_LOAD', function($ep) {
    $data = $ep->getSubject();
    $data['items'][] = 'New Item';
    $data['count']++;
    return $data;
});
```

### REX_LIST manipulieren

```php
rex_extension::register('REX_LIST_GET', function(rex_extension_point $ep) {
    $list = $ep->getSubject();

    // Custom Column hinzufügen
    $list->addColumn('actions', '<i class="icon">Edit</i>', -1, [
        '<th>Actions</th>',
        '<td>###actions###</td>'
    ]);

    $list->setColumnFormat('actions', 'custom', function($params) {
        $id = $params['list']->getValue('id');
        return '<a href="?id=' . $id . '">Edit</a>';
    });
}, [], true);  // readonly=true!
```

### Frontend-Tracking bei Seiten-Aufruf

```php
rex_extension::register('FE_OUTPUT', function(rex_extension_point $ep) {
    $article = rex_article::getCurrent();

    if ($article) {
        $sql = rex_sql::factory();
        $sql->setTable(rex::getTable('page_stats'));
        $sql->setValue('article_id', $article->getId());
        $sql->setValue('date', date('Y-m-d'));
        $sql->setRawValue('count', 'count + 1');
        $sql->insertOrUpdate();
    }

    return $ep->getSubject();
});
```

### Fehler-Email bei Media-Upload

```php
rex_extension::register('MEDIA_ADDED', function(rex_extension_point $ep) {
    $media = $ep->getSubject();
    $filename = $media->getFileName();

    // Prüfen auf verdächtige Dateitypen
    if (preg_match('/\.(exe|bat|sh)$/i', $filename)) {
        $mailer = new rex_mailer();
        $mailer->addAddress(rex::getProperty('error_email'));
        $mailer->Subject = 'Suspicious file upload';
        $mailer->Body = 'File uploaded: ' . $filename;
        $mailer->send();
    }
});
```

### Prioritäten verwenden

```php
// Wird als erstes ausgeführt
rex_extension::register('FE_OUTPUT', $callback1, [], rex_extension::EARLY);

// Wird als zweites ausgeführt  
rex_extension::register('FE_OUTPUT', $callback2, [], rex_extension::NORMAL);

// Wird als letztes ausgeführt
rex_extension::register('FE_OUTPUT', $callback3, [], rex_extension::LATE);

// Custom Priorität (0-10, niedrigere zuerst)
rex_extension::register('FE_OUTPUT', $callback4, [], 3);
```

## Best Practices

- `EARLY`: Für grundlegende Änderungen, auf denen andere aufbauen
- `NORMAL`: Standard-Priorität (Default)
- `LATE`: Für finale Anpassungen nach allen anderen
- Readonly-Extensions für Events ohne Subject-Rückgabe
- `return $ep->getSubject()` nicht vergessen wenn Subject geändert wird
