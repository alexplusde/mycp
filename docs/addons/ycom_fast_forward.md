# YCom Fast Forward - Keywords: YCom, Login, Logout, Registrierung, Profile, 2FA, OTP, Fragmente, Auto-Logout, Multi-Login, YForm-Action, Passwort-Reset

## Übersicht

**YCom Fast Forward** ist ein Add-on für REDAXO 5, das fertige Fragmente und Module für alle YCom-Funktionen bereitstellt. Es erstellt automatisch die benötigte Seitenstruktur, konfiguriert YCom und bietet erweiterte Funktionen wie Auto-Logout, Login-Token-Management und Multi-Domain-Login.

**Autor:** Alexander Walther  
**GitHub:** <https://github.com/alexplusde/ycom_fast_forward>  
**Namespace:** `Alexplusde\YComFastForward`  
**Abhängigkeiten:** YCom, YForm, MForm

⚠️ **Achtung:** Nicht bei bestehenden Projekten installieren, da Konfigurationen überschrieben und neue Artikel angelegt werden!

---

## Kern-Klassen

| Klasse | Beschreibung |
|--------|--------------|
| `Alexplusde\YComFastForward\YComFastForward` | Zentrale Utility-Klasse für Fragment-Parsing, Config-Verwaltung |
| `Alexplusde\YComFastForward\LoginToken` | YOrm-Dataset für Login-Token-Management (rex_ycom_fast_forward_activation_key) |
| `Alexplusde\YComFastForward\Profile` | YOrm-Dataset für YCom-Profile pro YRewrite-Domain (rex_ycom_fast_forward_profile) |
| `Alexplusde\YComFastForward\Api\LoginAs` | API-Endpunkt für "Login als User" im Backend |
| `Alexplusde\YComFastForward\Api\MultiLogin` | API-Endpunkt für domainübergreifenden Login |

---

## Fragmente

| Fragment | Beschreibung |
|----------|--------------|
| `login.php` | Login-Formular mit Email/Passwort |
| `logout.php` | Logout-Handler (Session-Clear + Redirect) |
| `password-2fa-check.php` | Passwort vergessen + 2FA-Überprüfung |
| `password-2fa-setup.php` | 2FA einrichten (OTP-Setup) |
| `password-change.php` | Passwort ändern für eingeloggten User |
| `password-reset.php` | Passwort zurücksetzen mit Token |
| `profile.php` | Profil bearbeiten (Firstname, Lastname, Email, Newsletter) |
| `register.php` | Registrierungsformular |
| `terms_of_use.php` | Nutzungsbedingungen akzeptieren |
| `redirect.php` | Gruppenbasierte Weiterleitung nach Login |

---

## 25 Praxisbeispiele

### 1. Fragment in Modul ausgeben

```php
use Alexplusde\YComFastForward\YComFastForward;

echo YComFastForward::parse('login.php', 'Login', 'Bitte melden Sie sich an.');
```

### 2. Login-Formular mit YForm

```php
// Fragment: login.php
$form = rex_yform::factory();
$form->setValidateField('ycom_auth', ['login', 'password', null, '{{ycom_login_warning_enterloginpsw}}', 'Login fehlgeschlagen']);
$form->setValueField('text', ['login', '{{ycom_login_login}}', '', '', '{"required":"required","autocomplete":"email"}']);
$form->setValueField('password', ['password', '{{ycom_login_password}}', '', '', '{"required":"required","autocomplete":"current-password"}']);
$form->setValueField('submit', ['submit', '{{ycom_login_submit}}']);
echo $form->getForm();
```

### 3. Profil bearbeiten

```php
// Fragment: profile.php
$yform = new rex_yform();
$yform->setObjectparams('form_name', 'ycom_profile');
$yform->setValueField('ycom_auth_load_user', ['userinfo', 'email,firstname,lastname']);
$yform->setValueField('text', ['firstname', '{{ycom_user_firstname}}']);
$yform->setValueField('text', ['lastname', '{{ycom_user_lastname}}']);
$yform->setActionField('ycom_auth_db', []);
echo $yform->getForm();
```

### 4. Logout durchführen

```php
// Fragment: logout.php
rex_ycom_auth::clearUserSession();
rex_response::sendRedirect(rex_getUrl(rex_config::get('ycom/auth', 'article_id_logout_redirect')));
```

### 5. Passwort zurücksetzen

```php
// Fragment: password-reset.php
$yform->setValidateField('ycom_auth_password', [
    'password',           // Feld für neues Passwort
    'password_confirm',   // Bestätigung
    3,                    // Min-Länge
    8,                    // Max-Länge
    ''                    // Fehlermeldung
]);
```

### 6. 2FA einrichten

```php
// Fragment: password-2fa-setup.php
$yform->setValueField('ycom_auth_otp', ['setup']); // OTP-Setup-Feld
echo $yform->getForm();
```

### 7. 2FA überprüfen

```php
// Fragment: password-2fa-check.php
$yform->setValueField('ycom_auth_otp', ['verify']); // OTP-Verifikation
echo $yform->getForm();
```

### 8. Login-Token erstellen

```php
use Alexplusde\YComFastForward\LoginToken;

$userId = 5;
$token = LoginToken::create($userId); // Generiert Token
echo "Aktivierungslink: " . rex_getUrl('aktivierung') . '?key=' . $token->getActivationKey();
```

### 9. Login via Token durchführen

```php
$key = rex_request('key', 'string');
$loginToken = LoginToken::findByKey($key);

if ($loginToken && $loginToken->isActive()) {
    $loginToken->login(true); // Login + Redirect
}
```

### 10. Token-Status prüfen

```php
$token = LoginToken::get(1);
if ($token->isActive()) {
    echo "Token ist aktiv";
} elseif ($token->isExpired()) {
    echo "Token ist abgelaufen";
} elseif ($token->isUsed()) {
    echo "Token wurde bereits verwendet";
}
```

### 11. Config-Wert abrufen

```php
use Alexplusde\YComFastForward\YComFastForward;

$timeout = YComFastForward::getConfig('auto_logout_client_timeout', 0);
```

### 12. Label aus Config abrufen

```php
$label = YComFastForward::getLabel('login_failed_disabled');
// Gibt gespeicherten Label-Text zurück oder "{{ login_failed_disabled }}"
```

### 13. YCom-Config setzen

```php
YComFastForward::setYComAuthConfig('article_id_login', $articleId);
```

### 14. Auto-Logout serverseitig prüfen

```php
use Alexplusde\YComFastForward\YComFastForward;

if (rex_ycom_auth::getUser()) {
    YComFastForward::checkAutoLogoutServerTimeout();
}
```

### 15. Auto-Logout JavaScript einbinden

```php
<script 
    nonce="<?= rex_response::getNonce() ?>"
    data-ycom-autologout-timeout="<?= rex_config::get('ycom_fast_forward', 'auto_logout_client_timeout', 0) ?>"
    data-ycom-autologout-warning="<?= rex_config::get('ycom_fast_forward', 'auto_logout_client_warning', 0) ?>"
    data-ycom-autologout-url="<?= rex_getUrl(rex_config::get('ycom/auth', 'article_id_logout')) ?>"
    data-ycom-autologout-title="<?= htmlspecialchars(YComFastForward::getLabel('auto_logout_modal_title'), ENT_QUOTES, 'UTF-8') ?>"
    data-ycom-autologout-message="<?= htmlspecialchars(YComFastForward::getLabel('auto_logout_modal_message'), ENT_QUOTES, 'UTF-8') ?>"
    data-ycom-autologout-close="<?= htmlspecialchars(YComFastForward::getLabel('auto_logout_modal_close'), ENT_QUOTES, 'UTF-8') ?>"
    data-ycom-autologout-stay="<?= htmlspecialchars(YComFastForward::getLabel('auto_logout_modal_stay'), ENT_QUOTES, 'UTF-8') ?>"
    src="<?= rex_url::addonAssets('ycom_fast_forward', 'js/ycom_fast_forward_autologout.js') ?>">
</script>
```

### 16. Gruppenbasierte Weiterleitung

```php
// Fragment: redirect.php
$ycom_user = rex_ycom_auth::getUser();
if ($ycom_user) {
    $ycom_groups = $ycom_user->getRelatedCollection('ycom_groups');
    if ($ycom_groups && count($ycom_groups) > 0) {
        $first_group = reset($ycom_groups);
        $target_article_id = $first_group->getValue("target_article_id");
        
        if ($target_article_id) {
            rex_response::sendRedirect(rex_getUrl($target_article_id));
            exit;
        }
    }
}
```

### 17. Login-as-User im Backend

```php
// Backend-Spalte "Login als User" wird automatisch hinzugefügt
// URL-Format: ?rex-api-call=ycom_fast_forward_login_as&ycom_user_id={id}&login_as_token={token}
```

### 18. Multi-Domain-Login initialisieren

```php
// API-Call: ?rex-api-call=ycom_fast_forward_multi_login&init=1
// Gibt JSON mit Domains und Tokens zurück
```

### 19. Nutzungsbedingungen-Reset

```php
YComFastForward::resetYComUserTermsOfUseAccepted();
// Setzt termsofuse_accepted auf 0 für alle User
```

### 20. YCom-Auth-Type für Artikel setzen

```php
YComFastForward::setYcomAuthForArticle($articleId, 1); // 1 = Login erforderlich
```

### 21. Registrierung mit Aktivierungs-Token

```php
// Nach Registrierung Token generieren
$userId = $newUser->getId();
$token = LoginToken::create($userId);

// Email mit Aktivierungslink senden
$activationUrl = rex_getUrl('aktivierung') . '?key=' . $token->getActivationKey();
```

### 22. E-Mail-Templates für Passwort-Reset

```php
// Fragment: yform_email/password-reset.html.php
$clang_id = rex_clang::getCurrentId();
// HTML-Template für Passwort-Reset-Email
```

### 23. Cookie-Einstellungen für Subdomains

```php
// Backend: YCom Fast Forward → Cookie-Einstellungen
// Konfiguriert session_cookie_domain und session_cookie_path
```

### 24. Profile für YRewrite-Domains

```php
use Alexplusde\YComFastForward\Profile;

$profile = Profile::create();
$profile->setValue('yrewrite_domain_id', $domainId);
$profile->setValue('article_id_login', $loginArticleId);
$profile->setValue('article_id_logout', $logoutArticleId);
$profile->save();
```

### 25. Logout nach Aktivierung

```php
// Config-Option: logout_after_activation
if (YComFastForward::getConfig('logout_after_activation') == 1) {
    // User wird nach erfolgreicher Aktivierung ausgeloggt
}
```

---

## YComFastForward-Methoden

| Methode | Beschreibung |
|---------|--------------|
| `parse(string $file, string $title = '', string $description = ''): string` | Parsed Fragment-Datei |
| `getConfig(string $key, mixed $default = null): mixed` | Ruft Config-Wert ab |
| `getLabel(string $key): string` | Ruft Label-Text ab |
| `setConfig(string $key, mixed $value): bool` | Setzt Config-Wert |
| `getYComAuthConfig(string $key): mixed` | Ruft YCom-Auth-Config ab |
| `setYComAuthConfig(string $key, mixed $value): bool` | Setzt YCom-Auth-Config |
| `setYcomAuthForArticle(int $article_id, int $auth_type): void` | Setzt Auth-Type für Artikel |
| `resetYComUserTermsOfUseAccepted(): void` | Reset termsofuse_accepted für alle User |
| `checkAutoLogoutServerTimeout(): void` | Prüft und führt serverseitigen Auto-Logout durch |

---

## LoginToken-Klasse

| Methode | Beschreibung |
|---------|--------------|
| `create(int $userId): self` | Erstellt neuen Aktivierungs-Token |
| `findByKey(string $key): self` | Findet Token anhand Key |
| `findByUserId(int $userId): Collection` | Findet alle Tokens eines Users |
| `isActive(): bool` | Prüft ob Token aktiv ist |
| `isExpired(): bool` | Prüft ob Token abgelaufen ist |
| `isUsed(): bool` | Prüft ob Token bereits verwendet wurde |
| `login(bool $redirect = false): bool` | Loggt User via Token ein |
| `setStatusUsed(): self` | Setzt Status auf "verwendet" |
| `setStatusExpired(): self` | Setzt Status auf "abgelaufen" |

### Token-Status-Konstanten

| Konstante | Wert | Beschreibung |
|-----------|------|--------------|
| `STATUS_EXPIRED` | -1 | Token abgelaufen |
| `STATUS_USED` | 0 | Token wurde verwendet |
| `STATUS_ACTIVE` | 1 | Token ist aktiv |

---

## Auto-Logout-Konfiguration

| Einstellung | Beschreibung | Einheit |
|-------------|--------------|---------|
| `auto_logout_server_timeout` | Serverseitiger Timeout | Minuten |
| `auto_logout_client_timeout` | Clientseitiger Timeout | Minuten |
| `auto_logout_client_warning` | Warnung vor Logout | Minuten |

### Serverseitiger Auto-Logout

```php
// In allen Templates im geschützten Bereich:
use Alexplusde\YComFastForward\YComFastForward;

if (rex_ycom_auth::getUser()) {
    YComFastForward::checkAutoLogoutServerTimeout();
}
```

**Funktionsweise:**

- Session-Timestamp wird bei Login gesetzt
- Bei jedem Seitenaufruf wird Zeitdifferenz geprüft
- Bei Überschreitung: Redirect zur Logout-Seite
- Bei Aktivität: Timestamp wird aktualisiert

### Clientseitiger Auto-Logout

**Funktionsweise:**

- Überwacht Benutzeraktivität (Maus, Tastatur, Touch, Scroll)
- Zeigt Warnung vor Logout an
- Button "Eingeloggt bleiben" verhindert Logout
- Automatischer Logout nach Ablauf

**Voraussetzung:** Element mit `id="app"` muss im DOM vorhanden sein (nur im geschützten Bereich aktiv).

---

## API-Endpunkte

| API-Call | Beschreibung |
|----------|--------------|
| `?rex-api-call=ycom_fast_forward_login_as&ycom_user_id={id}&login_as_token={token}` | Login als User (Backend) |
| `?rex-api-call=ycom_fast_forward_multi_login&init=1` | Gibt Domains + Tokens für Multi-Login zurück |
| `?rex-api-call=ycom_fast_forward_multi_login&token={token}` | Loggt User auf Domain ein |

---

## Datenbank-Struktur

### Tabelle: rex_ycom_fast_forward_activation_key

| Feld | Typ | Beschreibung |
|------|-----|--------------|
| `id` | int | Primärschlüssel |
| `ycom_user_id` | int | User-ID |
| `status` | tinyint(1) | -1 = abgelaufen, 0 = verwendet, 1 = aktiv |
| `activation_key` | varchar(191) | Eindeutiger Aktivierungs-Key (unique) |
| `createdate` | datetime | Erstellungsdatum |
| `expiredate` | datetime | Ablaufdatum |
| `deletedate` | datetime | Löschdatum (für Auto-Delete) |
| `updatedate` | datetime | Letztes Update |
| `comment` | varchar(191) | Optionaler Kommentar |

### Tabelle: rex_ycom_fast_forward_profile

| Feld | Typ | Beschreibung |
|------|-----|--------------|
| `id` | int | Primärschlüssel |
| `yrewrite_domain_id` | int | YRewrite-Domain-ID |
| `article_id_login` | int | Login-Artikel |
| `article_id_logout` | int | Logout-Artikel |
| `article_id_jump_ok` | int | Zielseite nach erfolgreicher Anmeldung |
| `article_id_jump_logout` | int | Zielseite nach Logout |
| `article_id_jump_denied` | int | Zielseite bei Zugriff verweigert |
| `article_id_password` | int | Passwort-vergessen-Artikel |
| `mailer_profile_id` | text | Mailer-Profile-IDs |
| `email_template_otp` | varchar(191) | E-Mail-Template für OTP |
| `email_template_password` | varchar(191) | E-Mail-Template für Passwort-Reset |

---

## Installation & Setup

### Automatische Einrichtung

Bei der Installation werden automatisch folgende Strukturen angelegt:

**Kategorien & Artikel:**

```
Login
  └─ Login
  └─ Passwort vergessen
Mein Profil
  └─ Profil
  └─ Passwort ändern
  └─ 2FA
  └─ Nutzungsbedingungen
Logout
  └─ Logout
Registrierung
  └─ Registrierung
```

**YCom-Konfiguration wird automatisch angepasst.**

**Modul "YCom Fast Forward" wird angelegt.**

**E-Mail-Templates werden installiert.**

**Feld `lastname` wird zur Tabelle `rex_ycom_user` hinzugefügt.**

---

## E-Mail-Templates

| Template | Beschreibung |
|----------|--------------|
| `yform_email/password-reset.html.php` | HTML-E-Mail für Passwort-Reset |
| `yform_email/password-reset.plaintext.php` | Plaintext-E-Mail für Passwort-Reset |

---

## Cookie-Einstellungen

Für Login über Domains und Subdomains können folgende Session-Einstellungen konfiguriert werden:

| Einstellung | Beschreibung |
|-------------|--------------|
| `session_cookie_domain` | Domain für Session-Cookie (z.B. `.example.com` für alle Subdomains) |
| `session_cookie_path` | Pfad für Session-Cookie |

**Backend:** YCom Fast Forward → Cookie-Einstellungen  
**Automatische Backup-Erstellung** der alten Konfiguration.

---

## Health-Seite

Zeigt Status-Übersicht der YCom-User-Datenbank:

- Anzahl Benutzer insgesamt
- Anzahl Benutzer je Status (aktiv, inaktiv, gesperrt)
- Anzahl Benutzer je YCom-Gruppe
- Anzahl Benutzer mit akzeptierten Nutzungsbedingungen

---

## Verwandte Addons

- [YCom](ycom.md) - User-Management
- [YForm](yform.md) - Formular-Framework
- [MForm](mform.md) - Modul-Eingabe
- [YRewrite](yrewrite.md) - Domain-Management
- [Mailer Profile](mailer_profile.md) - Multi-Profile-Emails

---

**GitHub:** <https://github.com/alexplusde/ycom_fast_forward>
