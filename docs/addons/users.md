# Users - Benutzerverwaltung | Keywords: Backend, Rechte, Rollen, Authentifizierung, Berechtigungen, Sitzungen, Sessions, Admin

**Übersicht**: Verwaltet Backend-Benutzer mit rollenbasiertem Rechtesystem. Ermöglicht Authentifizierung, Sitzungsverwaltung und komplexe Berechtigungen für sichere Zugriffskontrolle im REDAXO-Backend.

## Kern-Klassen

| Klasse | Beschreibung |
|--------|-------------|
| `rex_user` | Zentrale Benutzer-Klasse mit Methoden für Authentifizierung und Rechteverwaltung |
| `rex_backend_login` | Backend-Login-System mit Session-Management |
| `rex_user_session` | Session-Verwaltung für Benutzer |
| `rex_user_role` | Rollenbasierte Rechteverwaltung |
| `rex_clang_perm` | Sprachchenrechte für Benutzer |

## rex_user-Methoden

| Methode | Rückgabe | Beschreibung |
|---------|---------|-------------|
| `getId()` | int | ID des Benutzers |
| `getLogin()` | string | Login-Name |
| `getName()` | string | Vollständiger Name |
| `getEmail()` | string | E-Mail-Adresse |
| `isAdmin()` | bool | Admin-Status prüfen |
| `hasRole()` | bool | Rolle zugewiesen? |
| `hasPerm($perm)` | bool | Berechtigung prüfen |
| `getComplexPerm($key)` | rex_complex_perm | Komplexe Berechtigung abrufen |
| `getValue($key)` | mixed | Benutzerwert abrufen |
| `setValue($key, $value)` | self | Benutzerwert setzen |
| `save()` | bool | Speichert Änderungen |

## rex_backend_login-Methoden

| Methode | Rückgabe | Beschreibung |
|---------|---------|-------------|
| `hasSession()` | bool | Aktive Session vorhanden? |
| `createUser()` | ?rex_user | User-Objekt aus Session erstellen |
| `checkLogin()` | bool | Login-Daten prüfen |
| `setUser(rex_user $user)` | void | Benutzer für Session setzen |

## Standard-Berechtigungen

| Permission | Beschreibung |
|-----------|-------------|
| `admin` / `admin[]` | Administrator-Rechte |
| `users[]` | Benutzerverwaltung |
| `general|settings[]` | Systemeinstellungen |
| `general|update[]` | System-Updates |
| `media[]` | Medienverwaltung |
| `structure[]` | Strukturverwaltung |
| `modules[]` | Modulverwaltung |
| `templates[]` | Templateverwaltung |
| `clang[...]` | Sprachrechte |

## Praxisbeispiele

### Beispiel 1: Aktuellen Benutzer abrufen

```php
$user = rex::getUser();

if ($user) {
    echo 'Eingeloggt als: ' . $user->getLogin();
    echo '<br>Name: ' . $user->getName();
    echo '<br>E-Mail: ' . $user->getEmail();
}
```

### Beispiel 2: Admin-Status prüfen

```php
$user = rex::getUser();

if ($user && $user->isAdmin()) {
    echo 'Administrator-Rechte vorhanden';
    // Zeige erweiterte Optionen
}
```

### Beispiel 3: Berechtigung prüfen

```php
$user = rex::getUser();

if ($user && $user->hasPerm('structure[]')) {
    echo 'Darf Struktur bearbeiten';
} else {
    echo 'Keine Struktur-Rechte';
}
```

### Beispiel 4: Mehrere Berechtigungen prüfen

```php
$user = rex::getUser();

if ($user) {
    if ($user->hasPerm('media[]') && $user->hasPerm('structure[]')) {
        echo 'Hat Medien- und Struktur-Rechte';
    }
}
```

### Beispiel 5: Komplexe Sprachrechte prüfen

```php
$user = rex::getUser();
$clangId = rex_clang::getCurrentId();

if ($user && $user->getComplexPerm('clang')->hasPerm($clangId)) {
    echo 'Darf diese Sprache bearbeiten';
}
```

### Beispiel 6: Backend-Login prüfen

```php
// In Templates: Offline-Artikel für Admins anzeigen
if (rex_backend_login::hasSession()) {
    echo 'Backend-User ist eingeloggt';
    // Zeige Offline-Artikel
}
```

### Beispiel 7: Alle Benutzer abrufen

```php
$sql = rex_sql::factory();
$users = $sql->getArray('SELECT * FROM ' . rex::getTable('user') . ' WHERE status = 1 ORDER BY login');

foreach ($users as $userData) {
    $user = rex_user::fromSql($userData);
    echo $user->getLogin() . ' - ' . $user->getName() . '<br>';
}
```

### Beispiel 8: Benutzer erstellen

```php
$user = rex_user::create();
$user->setLogin('johndoe');
$user->setName('John Doe');
$user->setEmail('john@example.com');
$user->setValue('status', 1);

// Passwort setzen (wird automatisch gehasht)
$user->setValue('password', rex_login::passwordHash('geheim123'));

if ($user->save()) {
    echo 'Benutzer erstellt';
}
```

### Beispiel 9: Rolle zuweisen

```php
$user = rex_user::get($userId);
if ($user) {
    $user->setValue('role', 'editor'); // Name der Rolle
    $user->save();
}
```

### Beispiel 10: Benutzer-Metadaten setzen

```php
$user = rex::getUser();
if ($user) {
    $user->setValue('description', 'Hauptredakteur');
    $user->setValue('lastlogin', date('Y-m-d H:i:s'));
    $user->save();
}
```

### Beispiel 11: Session-Validierung

```php
use rex_backend_login;

// Prüfen ob Backend-User eingeloggt
if (!rex_backend_login::hasSession()) {
    // Redirect zum Login
    header('Location: ' . rex_url::backendPage('login'));
    exit;
}
```

### Beispiel 12: Addon-spezifische Rechte

```php
$user = rex::getUser();

// Addon-Berechtigung prüfen
if ($user && $user->hasPerm('yform[manager]')) {
    echo 'Darf YForm Manager nutzen';
}

// Komplexe YForm-Tabellen-Rechte
if ($user && $user->getComplexPerm('yform_manager_table_view')->hasPerm('rex_my_table')) {
    echo 'Darf diese YForm-Tabelle sehen';
}
```

### Beispiel 13: User-Objekt im Frontend erstellen

```php
// Für spezielle Fälle (z.B. Fehlermeldungen für Admins)
$user = rex_backend_login::createUser();

if ($user && $user->isAdmin()) {
    // Detaillierte Fehlermeldung für Admin
    echo rex_error_handler::getFullErrorMessage($exception);
}
```

### Beispiel 14: Benutzer nach ID laden

```php
$userId = 5;
$user = rex_user::get($userId);

if ($user) {
    echo $user->getLogin();
} else {
    echo 'Benutzer nicht gefunden';
}
```

### Beispiel 15: Benutzer löschen

```php
$user = rex_user::get($userId);

if ($user && !$user->isAdmin()) {
    if ($user->delete()) {
        echo 'Benutzer gelöscht';
    }
}
```

### Beispiel 16: Passwort ändern

```php
$user = rex_user::get($userId);

if ($user) {
    $newPassword = 'neuespasswort123';
    $user->setValue('password', rex_login::passwordHash($newPassword));
    $user->save();
}
```

### Beispiel 17: Eigenes Profil bearbeiten

```php
$user = rex::getUser();

if ($user) {
    $user->setName(rex_post('name', 'string'));
    $user->setEmail(rex_post('email', 'string'));
    
    if ($user->save()) {
        echo rex_view::success('Profil aktualisiert');
    }
}
```

### Beispiel 18: Benutzer-Status prüfen

```php
$user = rex_user::get($userId);

if ($user && 1 == $user->getValue('status')) {
    echo 'Benutzer ist aktiv';
} else {
    echo 'Benutzer ist inaktiv';
}
```

### Beispiel 19: Alle Admins abrufen

```php
$sql = rex_sql::factory();
$sql->setQuery('SELECT * FROM ' . rex::getTable('user') . ' WHERE admin = 1');

while ($sql->hasNext()) {
    $user = rex_user::fromSql($sql);
    echo $user->getLogin() . ' (Admin)<br>';
    $sql->next();
}
```

### Beispiel 20: Benutzer nach Login finden

```php
$login = 'johndoe';
$sql = rex_sql::factory();
$sql->setQuery('SELECT * FROM ' . rex::getTable('user') . ' WHERE login = ?', [$login]);

if ($sql->getRows() > 0) {
    $user = rex_user::fromSql($sql->getArray()[0]);
    echo $user->getName();
}
```

### Beispiel 21: Sprach-Berechtigungen setzen

```php
$user = rex_user::get($userId);

if ($user) {
    // Zugriff auf Sprachen 1 und 2
    $user->setValue('clang', '1|2');
    $user->save();
}
```

### Beispiel 22: Startseite für Rolle festlegen

```php
$user = rex_user::get($userId);

if ($user) {
    $user->setValue('startpage', 'yform/manager');
    $user->save();
}
```

### Beispiel 23: Benutzer-Suchfunktion

```php
$searchTerm = rex_request('search', 'string');
$sql = rex_sql::factory();

$query = 'SELECT * FROM ' . rex::getTable('user') . ' 
          WHERE login LIKE ? OR name LIKE ? OR email LIKE ?';
$params = array_fill(0, 3, '%' . $searchTerm . '%');

$users = $sql->getArray($query, $params);

foreach ($users as $userData) {
    $user = rex_user::fromSql($userData);
    echo $user->getLogin() . ' - ' . $user->getName() . '<br>';
}
```

### Beispiel 24: Backend-Seite mit Rechtsprüfung

```php
// In pages/index.php
$user = rex::requireUser();

if (!$user->hasPerm('media[]') && !$user->isAdmin()) {
    echo rex_view::error('Keine Berechtigung');
    return;
}

// Inhalt der Seite
echo 'Geschützter Bereich';
```

### Beispiel 25: Multi-Faktor-Authentifizierung prüfen

```php
$user = rex::getUser();

if ($user) {
    $twoFactorEnabled = (bool) $user->getValue('two_factor_auth');
    
    if (!$twoFactorEnabled) {
        echo rex_view::warning('2FA nicht aktiviert');
    }
}
```

### Beispiel 26: Benutzer nach Rolle filtern

```php
$roleName = 'editor';
$sql = rex_sql::factory();
$users = $sql->getArray('SELECT * FROM ' . rex::getTable('user') . ' WHERE role = ?', [$roleName]);

echo count($users) . ' Benutzer mit Rolle "' . $roleName . '"';
```

### Beispiel 27: Letzten Login speichern

```php
// In boot.php oder Login-Extension
rex_extension::register('LOGIN_SUCCESS', function(rex_extension_point $ep) {
    $user = $ep->getSubject();
    
    if ($user instanceof rex_user) {
        $user->setValue('lastlogin', date('Y-m-d H:i:s'));
        $user->save();
    }
});
```

### Beispiel 28: Benutzer deaktivieren

```php
$user = rex_user::get($userId);

if ($user && !$user->isAdmin()) {
    $user->setValue('status', 0);
    
    if ($user->save()) {
        echo 'Benutzer deaktiviert';
    }
}
```

### Beispiel 29: Custom Permission Check

```php
$user = rex::getUser();

// Eigene Berechtigung registrieren
if ($user && $user->hasPerm('myaddon[edit]')) {
    echo 'Darf Addon bearbeiten';
}
```

### Beispiel 30: Benutzer-Statistik

```php
$sql = rex_sql::factory();

// Anzahl aktiver Benutzer
$activeUsers = $sql->getArray('SELECT COUNT(*) as count FROM ' . rex::getTable('user') . ' WHERE status = 1')[0]['count'];

// Anzahl Admins
$admins = $sql->getArray('SELECT COUNT(*) as count FROM ' . rex::getTable('user') . ' WHERE admin = 1')[0]['count'];

echo 'Aktive Benutzer: ' . $activeUsers . '<br>';
echo 'Administratoren: ' . $admins;
```

**Integration**: Kern-System, Session-Management, Extension Points (LOGIN_SUCCESS, USER_IMPERSONATE), Backend-Controller, Addon-spezifische Rechteverwaltung (z.B. YForm), YCom (Frontend-Benutzer)
