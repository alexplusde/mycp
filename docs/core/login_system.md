# Login & User System

**Keywords:** Authentication Session User Permission Role Admin Impersonate Backend Login Access Control RBAC

## Übersicht

Login-System mit Session-Management, User-Authentifizierung, Rollen-basierter Zugriffskontrolle und Admin-Impersonation.

## Methoden

### rex_login

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `setLogin($login, $password)` | string, string | void | Setzt Login-Credentials |
| `setLogout($logout)` | bool | void | Setzt Logout-Flag |
| `setSessionDuration($duration)` | int | void | Session-Timeout in Sekunden (default 28 Tage) |
| `checkLogin()` | - | bool | Prüft Anmeldung gegen DB, regeneriert Session |
| `impersonate($userId)` | int | void | Admin nimmt User-Identität an |
| `depersonate()` | - | void | Beendet Impersonation |
| `getUser()` | - | rex_user\|null | Aktueller User (impersonated) |
| `getImpersonator()` | - | rex_user\|null | Original Admin bei Impersonation |
| `getValue($key, $default)` | string, mixed | mixed | User-Eigenschaft aus DB |
| `setSessionVar($var, $value)` | string, scalar | void | Session-Variable setzen |
| `getSessionVar($var, $default)` | string, mixed | mixed | Session-Variable lesen |
| `passwordHash($password)` | string | string | Verschlüsselt Passwort (sha1+bcrypt) |
| `passwordVerify($pw, $hash)` | string, string | bool | Prüft Passwort gegen Hash |
| `passwordNeedsRehash($hash)` | string | bool | Hash aktualisieren nötig? |
| `startSession()` | - | void | Startet PHP-Session |
| `regenerateSessionId()` | - | void | Session-ID neu generieren (Fixation) |

### rex_user

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `rex_user::get($id)` | int | rex_user\|null | User-Instanz aus Cache |
| `rex_user::forLogin($login)` | string | rex_user\|null | User per Login-Name laden |
| `rex_user::require($id)` | int | rex_user | User laden oder Exception |
| `getId()` | - | int | User-ID |
| `getLogin()` | - | string | Login-Name |
| `getName()` | - | string | Anzeige-Name |
| `getEmail()` | - | string | E-Mail-Adresse |
| `isAdmin()` | - | bool | Admin-Berechtigung? |
| `hasPerm($perm)` | string | bool | Permission-Check inkl. Admin |
| `hasRole()` | - | bool | Hat zugewiesene Rolle? |
| `getComplexPerm($key)` | string | rex_complex_perm\|null | Komplexes Recht-Objekt (media/clang/structure) |
| `getLanguage()` | - | string | Backend-Sprache (z.B. 'de_de') |
| `getStartPage()` | - | string | Start-Subpage nach Login |
| `getValue($key, $default)` | string, mixed | mixed | DB-Feld-Wert |

### rex_user_role_interface

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `hasPerm($perm)` | string | bool | Rolle hat Berechtigung? |
| `getComplexPerm($user, $key)` | rex_user, string | rex_complex_perm\|null | Komplexes Recht für User |
| `::get($id)` | string | rex_user_role_interface\|null | Rolle per ID(s) laden |

### rex_perm

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `::register($perm, $name, $group)` | string, string, self::* | void | Registriert neues Recht (GENERAL/OPTIONS/EXTRAS) |
| `::has($perm)` | string | bool | Recht existiert? |
| `::getAll($group)` | self::* | array | Alle Rechte einer Gruppe |

### rex_user_session

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `storeCurrentSession($login, $cookieKey, $passkey)` | rex_backend_login, string, string | void | Speichert Session in DB |
| `clearCurrentSession()` | - | void | Löscht aktuelle Session aus DB |
| `updateLastActivity($login)` | rex_backend_login | void | Aktualisiert Aktivität (max 1x/Min) |
| `removeSession($sessionId, $userId)` | string, int | bool | Entfernt Session per ID |
| `removeSessionsExceptCurrent($userId)` | int | void | Löscht alle Sessions außer aktueller |
| `::updateSessionId($old, $new)` | string, string | void | Bei Session-Regeneration |
| `::clearExpiredSessions()` | - | void | Cleanup abgelaufener Sessions |

## Praxisbeispiele

### User abrufen

```php
// Aktueller Backend-User (null wenn nicht eingeloggt)
$user = rex::getUser();
if ($user) {
    echo $user->getName();
}

// User zwingend notwendig - sonst Exception
$user = rex::requireUser();
echo $user->getEmail();

// User per ID laden
$user = rex_user::get(5);
if ($user) {
    echo $user->getLogin();
}

// User per Login-Namen laden
$user = rex_user::forLogin('admin');
if ($user) {
    echo $user->getId();
}
```

### Berechtigungen prüfen

```php
$user = rex::requireUser();

// Admin?
if ($user->isAdmin()) {
    echo 'Super-Admin mit allen Rechten';
}

// Einzelnes Recht prüfen
if ($user->hasPerm('media[]')) {
    echo 'Darf Media verwalten';
}

// Custom Addon-Recht
if ($user->hasPerm('myAddon[settings]')) {
    // Addon-Einstellungen erlaubt
}

// Admin-Check ist in hasPerm() integriert (Admin hat immer true)
if ($user->hasPerm('structure')) {
    echo 'Zugriff auf Struktur';
}
```

### Complex Permissions

```php
$user = rex::requireUser();

// Sprach-Zugriff prüfen
$clangPerm = $user->getComplexPerm('clang');
if ($clangPerm && $clangPerm->hasPerm(2)) {
    echo 'Zugriff auf Sprache 2';
}

// Media-Kategorie prüfen
$mediaPerm = $user->getComplexPerm('media');
if ($mediaPerm && $mediaPerm->hasPerm(5)) {
    echo 'Zugriff auf Media-Kategorie 5';
}

// Struktur-Kategorie prüfen
$structurePerm = $user->getComplexPerm('structure');
if ($structurePerm && $structurePerm->hasPerm(10)) {
    echo 'Zugriff auf Struktur-Kategorie 10';
}

// Modul-Zugriff
$modulePerm = $user->getComplexPerm('modules');
if ($modulePerm && $modulePerm->hasPerm(3)) {
    echo 'Darf Modul 3 verwenden';
}
```

### User-Properties

```php
$user = rex::requireUser();

// Standard-Properties
echo $user->getId();        // 1
echo $user->getLogin();     // 'admin'
echo $user->getName();      // 'Administrator'
echo $user->getEmail();     // 'admin@example.com'
echo $user->getLanguage();  // 'de_de'
echo $user->getStartPage(); // 'structure'

// Custom DB-Felder
echo $user->getValue('phone', '-');
echo $user->getValue('department');
echo $user->getValue('createdate');
```

### Login-Handling

```php
$login = new rex_backend_login();

// Login-Versuch
$login->setLogin($_POST['user_login'], $_POST['user_psw']);

if ($login->checkLogin()) {
    // Erfolgreich eingeloggt
    $user = $login->getUser();
    echo 'Willkommen ' . $user->getName();
} else {
    // Fehler
    echo $login->getMessage(); // 'Fehler bei der Anmeldung.'
}

// Session-Dauer setzen (default 28 Tage = 2419200 Sekunden)
$login->setSessionDuration(3600); // 1 Stunde

// Logout
$login->setLogout(true);
$login->checkLogin(); // Setzt Message + löscht Session
```

### Session-Management

```php
// Session starten (automatisch vor checkLogin)
rex_login::startSession();

// Session-Variable setzen/lesen
$login->setSessionVar('last_page', '/structure');
$lastPage = $login->getSessionVar('last_page', '/profile');

// Session-ID neu generieren (gegen Fixation)
rex_login::regenerateSessionId();

// Session-Cookies konfigurieren
$params = rex_login::getCookieParams();
// ['lifetime' => 0, 'path' => '/', 'domain' => '', 'secure' => true, 'httponly' => true, 'samesite' => 'Lax']

// Session in DB speichern (rex_user_session)
$sessionMgr = rex_user_session::getInstance();
$sessionMgr->storeCurrentSession($login);

// Letzte Aktivität aktualisieren
$sessionMgr->updateLastActivity($login);

// Aktuelle Session beenden
$sessionMgr->clearCurrentSession();
```

### Impersonation (Admin als User)

```php
$login = rex::getProperty('login');
$admin = $login->getUser();

if ($admin && $admin->isAdmin()) {
    // Als User 42 einloggen
    $login->impersonate(42);
    
    // Jetzt ist $login->getUser() = User 42
    echo rex::getUser()->getName(); // 'John Doe'
    
    // Original Admin ist noch abrufbar
    echo rex::getImpersonator()->getName(); // 'Administrator'
    
    // Zurück zum Admin
    $login->depersonate();
}

// Check ob impersoniert
if (rex::getImpersonator()) {
    echo 'Admins sehen aktuell als User: ' . rex::getUser()->getName();
}
```

### Passwort-Hashing

```php
// Passwort hashen (sha1 + bcrypt)
$hash = rex_login::passwordHash('meinPasswort');
// $2y$10$...

// Passwort prüfen
if (rex_login::passwordVerify('eingabe', $hash)) {
    echo 'Passwort korrekt';
}

// Rehash nötig? (z.B. bei Bcrypt-Cost-Änderung)
if (rex_login::passwordNeedsRehash($hash)) {
    $newHash = rex_login::passwordHash('meinPasswort');
    // In DB speichern
}

// Bei checkLogin() automatisch:
// - sha1($password) wird intern gebildet
// - Mit DB-Hash verglichen
// - Bei Erfolg: Session-Regeneration
```

### Session-DB-Verwaltung

```php
$sessionMgr = rex_user_session::getInstance();

// Session mit Cookie-Key speichern (Stay Logged In)
$sessionMgr->storeCurrentSession($login, 'abc123xyz', 'passkey_id');

// Spezifische Session löschen
$sessionMgr->removeSession('sess_xyz789', 42);

// Alle Sessions eines Users löschen (außer aktuelle)
$sessionMgr->removeSessionsExceptCurrent(42);

// Abgelaufene Sessions bereinigen (Cronjob)
rex_user_session::clearExpiredSessions();
// Löscht:
// - Sessions ohne Cookie älter als session_duration
// - Sessions mit Cookie älter als 3 Monate

// Bei Session-Regeneration
rex_user_session::updateSessionId('old_sess_id', 'new_sess_id');
```

### Permission-System

```php
// In boot.php: Custom Permission registrieren
rex_perm::register('myAddon[config]', 'Einstellungen ändern', rex_perm::OPTIONS);
rex_perm::register('myAddon[export]', 'Daten exportieren', rex_perm::GENERAL);
rex_perm::register('myAddon[import]', null, rex_perm::EXTRAS); // Nutzt i18n-Key

// Prüfen ob Permission existiert
if (rex_perm::has('myAddon[config]')) {
    // Registriert
}

// Alle Permissions einer Gruppe
$generalPerms = rex_perm::getAll(rex_perm::GENERAL);
// ['structure' => 'structure :: Struktur verwalten', 'media[]' => 'media[] :: ...' ]

$optionsPerms = rex_perm::getAll(rex_perm::OPTIONS);
// ['myAddon[config]' => 'myAddon[config] :: Einstellungen ändern']

// User-Check
if (rex::requireUser()->hasPerm('myAddon[config]')) {
    // Erlaubt
}
```

### Backend-Login-Klasse

```php
// Verwendung über rex Property
$login = rex::getProperty('login'); // rex_backend_login Instanz

$login->setLogin($_POST['user_login'], $_POST['user_psw']);

if ($login->checkLogin()) {
    // User authentifiziert
    $user = $login->getUser(); // rex_user Instanz
    
    // Session-Variablen
    $userId = $login->getSessionVar(rex_login::SESSION_USER_ID);
    $startTime = $login->getSessionVar(rex_login::SESSION_START_TIME);
    $lastActivity = $login->getSessionVar(rex_login::SESSION_LAST_ACTIVITY);
    
    // Impersonator wenn vorhanden
    $impersonatorId = $login->getSessionVar(rex_login::SESSION_IMPERSONATOR);
} else {
    echo $login->getMessage();
}
```

### User-Verwaltung in Extension Point

```php
// Bei User-Login
rex_extension::register('REX_FORM_SAVED', function(rex_extension_point $ep) {
    if ($ep->getParam('form') instanceof rex_user_form) {
        $user = rex::requireUser();
        rex_logger::factory()->info('User ' . $user->getLogin() . ' hat Profil bearbeitet');
    }
});

// Bei Session-Regeneration
rex_extension::register('SESSION_REGENERATED', function(rex_extension_point $ep) {
    $previous = $ep->getParam('previous_id');
    $new = $ep->getParam('new_id');
    
    // DB-Session-ID aktualisieren
    rex_user_session::updateSessionId($previous, $new);
});
```

### Stay Logged In (Cookie-basiert)

```php
// Login mit "Angemeldet bleiben"
$login = rex::getProperty('login');
$login->setLogin($_POST['user_login'], $_POST['user_psw']);

if ($login->checkLogin()) {
    if (!empty($_POST['stay_logged_in'])) {
        // Cookie-Key generieren
        $cookieKey = bin2hex(random_bytes(32));
        
        // Session mit Cookie speichern
        rex_user_session::getInstance()->storeCurrentSession(
            $login, 
            $cookieKey,
            $_POST['passkey'] ?? null
        );
        
        // Cookie setzen (3 Monate)
        setcookie('rex_stay', $cookieKey, time() + 7776000, '/');
    }
}
```

### Multi-Query-Setup

```php
// Custom Login-Query (z.B. LDAP-Integration)
$login->setLoginQuery("
    SELECT * FROM rex_user 
    WHERE login = :login 
    AND status = 1
    AND ldap_sync = 1
");

// Custom User-Query (mehr Felder)
$login->setUserQuery("
    SELECT u.*, d.name as department_name
    FROM rex_user u
    LEFT JOIN rex_department d ON u.department_id = d.id
    WHERE u.id = :id
");

// Impersonate-Query (z.B. nur aktive User)
$login->setImpersonateQuery("
    SELECT * FROM rex_user 
    WHERE id = :id 
    AND status = 1
");
```

### User-Properties im Backend

```php
// In Backend-Template: User-Info anzeigen
$user = rex::getUser();
if ($user) {
    ?>
    <div class="user-info">
        <strong><?= $user->getName() ?></strong>
        <?= $user->getEmail() ?>
        
        <?php if ($user->isAdmin()): ?>
            <span class="badge">Admin</span>
        <?php endif ?>
        
        <?php if ($impersonator = rex::getImpersonator()): ?>
            <div class="alert">
                Sie sind eingeloggt als <strong><?= $user->getName() ?></strong>
                (Original: <?= $impersonator->getName() ?>)
                <a href="?depersonate=1">Zurück zu <?= $impersonator->getName() ?></a>
            </div>
        <?php endif ?>
    </div>
    <?php
}
```

### Session-Check in API

```php
// API-Endpoint mit Login-Check
function api_myEndpoint(rex_api_function $api) {
    $user = rex::getUser();
    
    if (!$user) {
        return rex_api_function::sendJson(['error' => 'Not authenticated'], 401);
    }
    
    if (!$user->hasPerm('myAddon[api]')) {
        return rex_api_function::sendJson(['error' => 'Permission denied'], 403);
    }
    
    // API-Logik
    return rex_api_function::sendJson(['status' => 'ok']);
}
```

### Role-Implementation (Addon: users)

```php
// rex_user_role implementiert rex_user_role_interface

// Rolle laden
$role = rex_user_role::get('1,2,3'); // Mehrere Rollen
if ($role) {
    // Permissions prüfen
    if ($role->hasPerm('structure')) {
        echo 'Rolle hat Struktur-Recht';
    }
    
    // Complex Perm
    $clangPerm = $role->getComplexPerm($user, 'clang');
}

// Bei User
$user = rex::requireUser();
if ($user->hasRole()) {
    echo 'User hat Rolle zugewiesen';
}
```

### Session-Timeout-Handling

```php
$login = rex::getProperty('login');

// Session-Dauer: 28 Tage = 2419200 Sekunden (default)
// Letzter Zugriff muss innerhalb dieser Zeit sein

// Max Overall Duration: 4 Wochen (SESSION_START_TIME)
// Absolute Session-Dauer unabhängig von Aktivität

// Bei checkLogin():
// - SESSION_LAST_ACTIVITY geprüft gegen sessionDuration
// - SESSION_START_TIME geprüft gegen sessionMaxOverallDuration

// Expired?
if (!$login->checkLogin()) {
    if ($login->getMessage() === rex_i18n::msg('login_session_expired')) {
        // Session abgelaufen
        header('Location: /redaxo/index.php?rex-api-call=auth');
    }
}
```

### Passwort-Änderung

```php
$user = rex::requireUser();

// Neues Passwort hashen
$newPassword = $_POST['new_password'];
$newHash = rex_login::passwordHash($newPassword);

// In DB speichern
$sql = rex_sql::factory();
$sql->setTable(rex::getTable('user'));
$sql->setWhere(['id' => $user->getId()]);
$sql->setValue('password', $newHash);
$sql->update();

// Session aktualisieren (sonst logout)
rex::getProperty('login')->changedPassword($newHash);

// User-Instanz neu laden
rex_user::clearInstance($user->getId());
```

### Backend-Page-Schutz

```php
// In page.php: Permission-Check
$user = rex::requireUser();

if (!$user->hasPerm('myAddon[settings]')) {
    echo rex_view::error('Keine Berechtigung');
    exit;
}

// Oder über rex_be_page
rex_be_controller::getCurrentPage()->checkPermission('myAddon[settings]');

// Page-Definition in package.yml
pages:
    myAddon:
        title: 'My Addon'
        perm: myAddon[]
        subpages:
            settings:
                title: 'Einstellungen'
                perm: myAddon[settings]
```

### Passwort-Reset-Flow

```php
// 1. Reset-Token generieren
$user = rex_user::forLogin($_POST['email']);
if ($user) {
    $token = bin2hex(random_bytes(32));
    $sql = rex_sql::factory();
    $sql->setTable(rex::getTable('user'));
    $sql->setWhere(['id' => $user->getId()]);
    $sql->setValue('reset_token', $token);
    $sql->setValue('reset_token_time', time());
    $sql->update();
    
    // E-Mail mit Link senden
    mail($user->getEmail(), 'Passwort zurücksetzen', 
         'Link: https://example.com/reset?token=' . $token);
}

// 2. Token validieren
$token = $_GET['token'];
$sql = rex_sql::factory();
$sql->setQuery('SELECT * FROM rex_user WHERE reset_token = ? AND reset_token_time > ?', 
               [$token, time() - 3600]); // 1 Stunde gültig

if ($sql->getRows()) {
    // 3. Neues Passwort setzen
    $newHash = rex_login::passwordHash($_POST['new_password']);
    $sql->setTable(rex::getTable('user'));
    $sql->setWhere(['id' => $sql->getValue('id')]);
    $sql->setValue('password', $newHash);
    $sql->setValue('reset_token', null);
    $sql->update();
}
```

### User-Sessions auflisten

```php
// Alle aktiven Sessions eines Users
$userId = 42;
$sessions = rex_sql::factory()
    ->setQuery('
        SELECT session_id, starttime, last_activity, ip, useragent
        FROM rex_user_session
        WHERE user_id = ?
        ORDER BY last_activity DESC
    ', [$userId])
    ->getArray();

foreach ($sessions as $session) {
    echo $session['session_id'] . ' - ' . $session['last_activity'];
    echo ' (' . $session['ip'] . ')';
    
    // Session beenden
    if ($_POST['terminate'] === $session['session_id']) {
        rex_user_session::getInstance()->removeSession($session['session_id'], $userId);
    }
}
```

### Login-Statistik

```php
// Letzte Logins tracken
rex_extension::register('REX_FORM_SAVED', function(rex_extension_point $ep) {
    if ($ep->getParam('form') instanceof rex_backend_login_form) {
        $login = rex::getProperty('login');
        if ($login->checkLogin()) {
            $user = $login->getUser();
            
            rex_sql::factory()
                ->setTable(rex::getTable('user'))
                ->setWhere(['id' => $user->getId()])
                ->setValue('last_login', rex_sql::datetime())
                ->setValue('login_count', 'login_count + 1', false)
                ->update();
        }
    }
});
```
