# Mailer Profile - Mehrfach-E-Mail-Profile | Keywords: SMTP, E-Mail, Profile, PHPMailer, YForm-Action, IMAP, Testmail, Custom-Headers, Multi-Account

**Übersicht**: Verwaltet multiple SMTP/E-Mail-Profile für verschiedene Absender-Accounts. Erweitert das PHPMailer-Addon um YForm-basierte Profilverwaltung, Key-System, Runtime-Header, IMAP-Integration und Testmail-Funktionalität.

## Profil-Felder

| Feld | Typ | Beschreibung |
|------|-----|-------------|
| `name` | text | Profilname |
| `key` | text | Eindeutiger Key (für YDeploy) |
| `from_email` | email | Absender-E-Mail |
| `from_name` | text | Absender-Name |
| `reply_to` | email | Reply-To-Adresse |
| `smtp_host` | text | SMTP-Server |
| `smtp_port` | integer | SMTP-Port (25, 465, 587) |
| `smtp_username` | text | SMTP-Username |
| `smtp_password` | text | SMTP-Passwort |
| `smtp_secure` | choice | Verschlüsselung (tls, ssl) |
| `custom_headers` | textarea | JSON Custom-Headers |
| `imap_host` | text | IMAP-Server |
| `imap_username` | text | IMAP-Username |
| `imap_password` | text | IMAP-Passwort |
| `imap_folder` | text | Gesendete-Ordner |

## YForm-Action

| Syntax | Beschreibung |
|--------|-------------|
| `action\|mailer_profile\|{id}` | Profil nach ID |
| `action\|mailer_profile\|{key}` | Profil nach Key |
| `action\|mailer_profile\|{id}\|{headers_json}` | Mit Runtime-Headers |

## SMTP-Verschlüsselung

| Wert | Port | Beschreibung |
|------|------|-------------|
| `tls` | 587 | STARTTLS |
| `ssl` | 465 | SSL/TLS |
| `-` | 25 | Unverschlüsselt |

## Praxisbeispiele

### Beispiel 1: Profil im Backend anlegen

Backend unter `Addons` > `Mailer Profile`:

- **Name**: Marketing Newsletter
- **Key**: marketing
- **From Email**: <marketing@example.com>
- **From Name**: Marketing Team
- **SMTP Host**: smtp.example.com
- **SMTP Port**: 587
- **SMTP Username**: <marketing@example.com>
- **SMTP Password**: ••••••
- **SMTP Secure**: tls

### Beispiel 2: Profil nach ID nutzen

```php
use rex_mailer;
use Alexplusde\MailerProfile\MailerProfile;

// Profil laden
$profile = MailerProfile::get(1);

// Mailer mit Profil konfigurieren
$mail = rex_mailer::factory();
$profile->applyToMailer($mail);

// E-Mail versenden
$mail->addAddress('kunde@example.com');
$mail->Subject = 'Betreff';
$mail->Body = 'Nachricht';
$mail->send();
```

### Beispiel 3: Profil nach Key nutzen

```php
// Key-basierter Zugriff (für YDeploy)
$profile = MailerProfile::getByKey('marketing');

if ($profile) {
    $mail = rex_mailer::factory();
    $profile->applyToMailer($mail);
    // ...
}
```

### Beispiel 4: YForm-Action mit Profil-ID

```php
// Im YForm-Formular:
value|text|email|E-Mail-Adresse
value|textarea|message|Nachricht

action|mailer_profile|1
```

### Beispiel 5: YForm-Action mit Key

```php
// Robuster für Multi-Environment (dev/stage/prod)
value|text|email|E-Mail-Adresse
value|textarea|message|Nachricht

action|mailer_profile|marketing
```

### Beispiel 6: Custom Headers

Im Backend unter Profil > Custom Headers:

```json
{
  "X-Mailer": "REDAXO CMS",
  "X-Priority": "1",
  "X-MSMail-Priority": "High"
}
```

### Beispiel 7: Runtime Custom Headers

```php
// YForm-Action mit Runtime-Headers
action|mailer_profile|marketing|{"X-Campaign-ID":"2024-spring"}

// Werden mit Profil-Headers gemergt
```

### Beispiel 8: Programmatisch Runtime-Headers

```php
$profile = MailerProfile::get(1);
$mail = rex_mailer::factory();

// Profil anwenden
$profile->applyToMailer($mail);

// Zusätzliche Runtime-Headers
$runtime_headers = [
    'X-Campaign-ID' => '2024-spring',
    'X-User-ID' => rex::getUser()->getId(),
];

foreach ($runtime_headers as $key => $value) {
    $mail->addCustomHeader($key, $value);
}

$mail->send();
```

### Beispiel 9: IMAP Sent-Folder Integration

```php
// Profil mit IMAP konfigurieren:
// IMAP Host: imap.example.com
// IMAP Username: marketing@example.com
// IMAP Password: ••••••
// IMAP Folder: INBOX.Sent

$profile = MailerProfile::get(1);
$mail = rex_mailer::factory();
$profile->applyToMailer($mail);

$mail->addAddress('kunde@example.com');
$mail->Subject = 'Test';
$mail->Body = 'Nachricht';

// E-Mail versenden UND in IMAP-Ordner speichern
if ($mail->send()) {
    $profile->saveToImapSentFolder($mail);
}
```

### Beispiel 10: Testmail versenden

Im Backend:

- Profil öffnen
- "Testmail senden" Button
- Empfänger eingeben
- Testmail wird mit Profil-Einstellungen versendet

Programmatisch:

```php
$profile = MailerProfile::get(1);
$result = $profile->sendTestMail('test@example.com');

if ($result) {
    echo 'Testmail erfolgreich versendet!';
} else {
    echo 'Fehler: ' . $profile->getLastError();
}
```

### Beispiel 11: Mehrere Profile für verschiedene Zwecke

```php
// Profile anlegen:
// 1. "Support" (support@example.com) - Key: support
// 2. "Sales" (sales@example.com) - Key: sales
// 3. "Marketing" (marketing@example.com) - Key: marketing

// In Formularen unterscheiden:
if ($formular_typ == 'support') {
    $profile = MailerProfile::getByKey('support');
} elseif ($formular_typ == 'sales') {
    $profile = MailerProfile::getByKey('sales');
} else {
    $profile = MailerProfile::getByKey('marketing');
}
```

### Beispiel 12: Reply-To konfigurieren

```php
// Im Profil:
// Reply To: no-reply@example.com

// Wird automatisch gesetzt:
$profile = MailerProfile::get(1);
$mail = rex_mailer::factory();
$profile->applyToMailer($mail);

// Alternativ überschreiben:
$mail->addReplyTo('custom-reply@example.com', 'Custom Reply');
```

### Beispiel 13: Verschiedene SMTP-Server

```php
// Profil 1: Office 365
// SMTP Host: smtp.office365.com
// SMTP Port: 587
// SMTP Secure: tls

// Profil 2: Gmail
// SMTP Host: smtp.gmail.com
// SMTP Port: 587
// SMTP Secure: tls

// Profil 3: Custom Server
// SMTP Host: mail.example.com
// SMTP Port: 465
// SMTP Secure: ssl
```

### Beispiel 14: YForm-Action mit Fallback

```php
// YForm-Formular:
action|mailer_profile|marketing

// Falls Profil nicht existiert, greift Standard-PHPMailer
// Verhindert Formular-Fehler bei fehlendem Profil
```

### Beispiel 15: Profil-Auswahl per Dropdown

```php
// YForm-Formular mit Profil-Auswahl
value|choice|profile|E-Mail-Profil|1=Support,2=Sales,3=Marketing

// In Action auswerten:
$profile_id = $this->getValueField('profile');
$profile = MailerProfile::get($profile_id);
```

### Beispiel 16: Extension Point für Custom Logic

```php
rex_extension::register('MAILER_PROFILE_BEFORE_SEND', function($ep) {
    $profile = $ep->getParam('profile');
    $mail = $ep->getParam('mail');
    
    // Custom Logic vor dem Senden
    rex_logger::logInfo('mailer_profile', 'Sending email via profile: ' . $profile->getName());
    
    // Mail-Objekt manipulieren
    $mail->addCustomHeader('X-Send-Time', date('Y-m-d H:i:s'));
});
```

### Beispiel 17: Fehlerbehandlung

```php
$profile = MailerProfile::get(1);

if (!$profile) {
    rex_logger::logError('mailer_profile', 'Profile not found');
    return false;
}

try {
    $mail = rex_mailer::factory();
    $profile->applyToMailer($mail);
    
    $mail->addAddress('kunde@example.com');
    $mail->Subject = 'Test';
    $mail->Body = 'Nachricht';
    
    if (!$mail->send()) {
        rex_logger::logError('mailer_profile', 'Send failed: ' . $mail->ErrorInfo);
    }
} catch (Exception $e) {
    rex_logger::logException($e);
}
```

### Beispiel 18: YDeploy-Kompatibilität

```php
// In config.yml für verschiedene Umgebungen
# dev.config.yml
mailer_profiles:
  - key: marketing
    smtp_host: smtp.mailtrap.io
    smtp_port: 2525

# prod.config.yml
mailer_profiles:
  - key: marketing
    smtp_host: smtp.example.com
    smtp_port: 587

// Im Code immer Key verwenden:
$profile = MailerProfile::getByKey('marketing');
```

### Beispiel 19: Mehrere Empfänger

```php
$profile = MailerProfile::getByKey('newsletter');
$mail = rex_mailer::factory();
$profile->applyToMailer($mail);

// Mehrere Empfänger
$recipients = ['user1@example.com', 'user2@example.com', 'user3@example.com'];
foreach ($recipients as $recipient) {
    $mail->addAddress($recipient);
}

$mail->Subject = 'Newsletter';
$mail->Body = 'Content';
$mail->send();
```

### Beispiel 20: BCC für Archivierung

```php
// Im Profil Custom Headers:
{
  "BCC": "archive@example.com"
}

// Jede E-Mail wird automatisch auch an archive@example.com gesendet
```

### Beispiel 21: Profil-Liste ausgeben

```php
$profiles = MailerProfile::query()->find();

echo '<ul>';
foreach ($profiles as $profile) {
    echo '<li>';
    echo '<strong>' . $profile->getName() . '</strong> ';
    echo '(' . $profile->getKey() . ') - ';
    echo $profile->getFromEmail();
    echo '</li>';
}
echo '</ul>';
```

### Beispiel 22: Profil validieren

```php
$profile = MailerProfile::get(1);

// Testmail zur Validierung
$test_result = $profile->sendTestMail('admin@example.com');

if ($test_result) {
    echo '✓ Profil korrekt konfiguriert';
} else {
    echo '✗ Fehler in Profil-Konfiguration: ' . $profile->getLastError();
}
```

### Beispiel 23: Priority-Header

```php
// Custom Headers für hohe Priorität:
{
  "X-Priority": "1",
  "X-MSMail-Priority": "High",
  "Importance": "High"
}

// E-Mail wird im Client als wichtig markiert
```

### Beispiel 24: HTML + Plain Text

```php
$profile = MailerProfile::get(1);
$mail = rex_mailer::factory();
$profile->applyToMailer($mail);

$mail->addAddress('kunde@example.com');
$mail->Subject = 'Betreff';

// HTML-Body
$mail->Body = '<h1>Überschrift</h1><p>HTML-Nachricht</p>';

// Plain-Text Alternative
$mail->AltBody = "Überschrift\n\nPlain-Text-Nachricht";

$mail->send();
```

### Beispiel 25: Profil-Export/-Import für YDeploy

```php
// Export
$profile = MailerProfile::get(1);
$export = [
    'key' => $profile->getKey(),
    'name' => $profile->getName(),
    'from_email' => $profile->getFromEmail(),
    // ... weitere Felder ...
];
file_put_contents('profile_export.json', json_encode($export, JSON_PRETTY_PRINT));

// Import
$data = json_decode(file_get_contents('profile_export.json'), true);

$profile = MailerProfile::create();
$profile->setKey($data['key']);
$profile->setName($data['name']);
$profile->setFromEmail($data['from_email']);
// ... weitere Felder ...
$profile->save();
```

**Integration**: PHPMailer-Addon (Erweiterung), YForm (YOrm Dataset, action|mailer_profile), IMAP (Sent-Folder-Integration), rex_mailer (Factory-Pattern), Custom Headers (JSON-Merge), YDeploy (Key-basiertes System), Extension Points (MAILER_PROFILE_BEFORE_SEND, MAILER_PROFILE_AFTER_SEND), rex_logger (Fehlerprotokollierung), Testmail-Funktionalität
