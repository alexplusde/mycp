# Inbox - YForm-basiertes Kontaktformular

**Keywords:** Inbox, Kontaktformular, YForm, Rapidmail, Spam-Schutz, Auto-Delete, Mailer-Profile

## Übersicht

Inbox ist ein YForm-basiertes Kontaktformular-Addon für Anfragen über die REDAXO-Website mit Backend-Verwaltung, Spam-Schutz und optionalem Rapidmail-Tracking.

## Hauptklasse

| Klasse | Beschreibung |
|--------|-------------|
| `Inbox` | YOrm Dataset-Klasse (`rex_yform_manager_dataset`), greift auf `rex_inbox` zu |

### Wichtige Methoden

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|-------------|
| `::get($id)` | `int $id` | `Inbox\|null` | Lädt Inbox-Eintrag |
| `::create()` | - | `Inbox` | Erstellt neuen Eintrag |
| `::query()` | - | `rex_yform_manager_query` | Query-Builder |
| `::getYForm()` | verschiedene | `rex_yform` | Erstellt YForm-Formular |
| `getName()` | - | `?string` | Name des Absenders |
| `getEmail()` | - | `?string` | E-Mail-Adresse |
| `getPhone()` | - | `?string` | Telefonnummer |
| `getMessage()` | `bool $asPlaintext` | `?string` | Nachricht (HTML/Text) |
| `getPrefferedChannel()` | - | `?string` | Bevorzugter Kontaktweg |
| `getDatestamp()` | - | `?string` | Zeitstempel Eingang |
| `getDeletedate()` | - | `?\DateTime` | Geplantes Löschdatum |

### Rapidmail-Tracking (optional)

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|-------------|
| `getRapidmailMessageId()` | - | `?string` | Rapidmail Message-ID |
| `getRapidmailStatus()` | - | `?string` | Status als JSON |
| `getRapidmailStatusArray()` | - | `?array` | Status als Array |
| `setRapidmailMessageId()` | `mixed $value` | `self` | Setzt Message-ID |
| `setRapidmailStatus()` | `mixed $value` | `self` | Setzt Status (Array→JSON) |
| `updateRapidmailStatus()` | - | `bool` | Aktualisiert Status von API |
| `::isRapidmailAvailable()` | - | `bool` | Prüft yform_rapidmail |
| `::isRapidmailTrackingEnabled()` | - | `bool` | Prüft Settings |

## Praxisbeispiele

### 1. Inbox-Eintrag laden

```php
use Alexplusde\Inbox\Inbox;

$inbox = Inbox::get(42);
echo $inbox->getName();
echo $inbox->getEmail();
echo $inbox->getMessage();
```

### 2. Alle Einträge abfragen

```php
$entries = Inbox::query()->find();
foreach ($entries as $entry) {
    echo $entry->getName() . ': ' . $entry->getEmail();
}
```

### 3. Neue Inbox-Nachricht erstellen

```php
$inbox = Inbox::create();
$inbox->setName('Max Mustermann');
$inbox->setEmail('max@example.com');
$inbox->setPhone('+49 123 456789');
$inbox->setMessage('Meine Anfrage...');
$inbox->setDatestamp(date('Y-m-d H:i:s'));
$inbox->save();
```

### 4. Kontaktformular im Frontend einbinden

```php
$yform = Inbox::getYForm();
echo $yform->getForm();
```

### 5. Kontaktformular mit Fragment

```php
// Fragment: inbox/form.php
$fragment = new rex_fragment();
echo $fragment->parse('inbox/form.php');
```

### 6. Formular mit Custom-Feldern

```php
$yform = Inbox::getYForm(
    null, 
    [Inbox::NAME, Inbox::EMAIL, Inbox::MESSAGE, Inbox::PRIVACY_POLICY], // Feldauswahl
    true, // objparams
    true, // honeypot
    true, // database
    0     // mailer_profile
);
echo $yform->getForm();
```

### 7. Nachricht als Plaintext

```php
$inbox = Inbox::get(42);
$text = $inbox->getMessage(true); // true = ohne HTML-Tags
```

### 8. Bevorzugter Kontaktweg

```php
$inbox = Inbox::get(42);
$channel = $inbox->getPrefferedChannel(); // email, phone, whatsapp, telegram
```

### 9. Löschdatum prüfen (Auto-Delete)

```php
$inbox = Inbox::get(42);
$deleteDate = $inbox->getDeletedate();
if ($deleteDate && $deleteDate < new DateTime()) {
    echo 'Wird bald gelöscht am ' . $deleteDate->format('d.m.Y');
}
```

### 10. Einträge mit Löschdatum filtern

```php
$entries = Inbox::query()
    ->whereRaw('deletedate IS NOT NULL')
    ->orderBy('deletedate', 'ASC')
    ->find();
```

### 11. YForm mit Mailer-Profile

```php
if (rex_addon::get('mailer_profile')->isAvailable()) {
    $yform = Inbox::getYForm(null, null, true, true, true, 2); // Profil-ID 2
    echo $yform->getForm();
}
```

### 12. Subject für E-Mail abrufen

```php
$subject = Inbox::getSubject('Max Mustermann'); // Prefix + Name
echo $subject; // "Anfrage Max Mustermann"
```

### 13. Subject für Bestätigung an Kunden

```php
$subjectClient = Inbox::getSubjectClient('Max Mustermann');
echo $subjectClient; // "Ihre Anfrage Max Mustermann"
```

### 14. IP-Adresse speichern

```php
$inbox = Inbox::create();
$inbox->setIp($_SERVER['REMOTE_ADDR']);
$inbox->save();
```

### 15. Rapidmail: Message-ID speichern (nach E-Mail-Versand)

```php
if (Inbox::isRapidmailAvailable() && Inbox::isRapidmailTrackingEnabled()) {
    $inbox = Inbox::get(42);
    $inbox->setRapidmailMessageId('msg_abc123def456');
    $inbox->setRapidmailStatus([
        'status' => 'sent',
        'timestamp' => date('Y-m-d H:i:s')
    ]);
    $inbox->save();
}
```

### 16. Rapidmail: Status abrufen

```php
$inbox = Inbox::get(42);
$messageId = $inbox->getRapidmailMessageId();
$statusJson = $inbox->getRapidmailStatus(); // JSON-String
$statusArray = $inbox->getRapidmailStatusArray(); // Array
if ($statusArray) {
    echo 'Status: ' . $statusArray['status'];
    echo 'Zeitstempel: ' . $statusArray['timestamp'];
}
```

### 17. Rapidmail: Status von API aktualisieren

```php
$inbox = Inbox::get(42);
if ($inbox->updateRapidmailStatus()) {
    echo 'Status erfolgreich aktualisiert';
    $status = $inbox->getRapidmailStatusArray();
    echo 'Neuer Status: ' . $status['status'];
} else {
    echo 'Fehler beim Status-Abruf';
}
```

### 18. Rapidmail: Cronjob für Status-Updates

```php
// Im Cronjob alle Stunde
$entries = Inbox::query()
    ->whereRaw('rapidmail_message_id IS NOT NULL')
    ->whereRaw('rapidmail_last_check < DATE_SUB(NOW(), INTERVAL 1 HOUR)')
    ->find();

foreach ($entries as $entry) {
    try {
        $entry->updateRapidmailStatus();
        usleep(100000); // 0.1s Pause (Rate Limiting)
    } catch (Exception $e) {
        rex_logger::logException($e);
    }
}
```

### 19. Rapidmail: Fehlgeschlagene Zustellungen überwachen

```php
$failed = Inbox::query()
    ->whereRaw('JSON_EXTRACT(rapidmail_status, "$.status") = "failed"')
    ->where('datestamp', '>', date('Y-m-d', strtotime('-24 hours')))
    ->find();

if ($failed->count() > 10) {
    // Alert senden
    rex_mailer::factory()
        ->setFrom('system@example.com')
        ->addTo('admin@example.com')
        ->setSubject('WARNUNG: Viele fehlgeschlagene E-Mails')
        ->setBody("Es sind {$failed->count()} E-Mails in den letzten 24h fehlgeschlagen")
        ->send();
}
```

### 20. Rapidmail: Status-Details

```php
$inbox = Inbox::get(42);
$status = $inbox->getRapidmailStatusArray();
if ($status) {
    switch ($status['status']) {
        case 'sent':
            echo 'E-Mail wurde versendet';
            break;
        case 'delivered':
            echo 'E-Mail wurde zugestellt';
            break;
        case 'failed':
            echo 'Zustellung fehlgeschlagen: ' . ($status['error'] ?? 'Unbekannter Fehler');
            break;
    }
}
```

### 21. YForm Action für Rapidmail-Tracking

```php
// In boot.php oder YForm-Action
class yform_action_inbox_rapidmail_tracking extends rex_yform_action_abstract
{
    public function executeAction(): void
    {
        if (!Inbox::isRapidmailAvailable() || !Inbox::isRapidmailTrackingEnabled()) {
            return;
        }
        
        $inboxId = $this->params['value_pool']['sql']['id'] ?? null;
        if (!$inboxId) return;
        
        $inbox = Inbox::get($inboxId);
        if (!$inbox) return;
        
        // E-Mail via Rapidmail versenden
        // $response = $rapidmailApi->send(...);
        // $inbox->setRapidmailMessageId($response['message_id']);
        // $inbox->setRapidmailStatus(['status' => 'sent', 'timestamp' => date('Y-m-d H:i:s')]);
        $inbox->save();
    }
}
```

### 22. Einträge der letzten 7 Tage

```php
$entries = Inbox::query()
    ->where('datestamp', '>=', date('Y-m-d H:i:s', strtotime('-7 days')))
    ->orderBy('datestamp', 'DESC')
    ->find();
```

### 23. Einträge mit bestimmtem Kanal

```php
$whatsappRequests = Inbox::query()
    ->where('preffered_channel', 'whatsapp')
    ->find();
```

### 24. Privacy-Policy-Akzeptanz prüfen

```php
$inbox = Inbox::get(42);
$acceptedAt = $inbox->getPrivacyPolicy(); // DateTime
if ($acceptedAt) {
    echo 'Datenschutz akzeptiert am: ' . $acceptedAt->format('d.m.Y H:i');
}
```

### 25. Datensatz aktualisieren

```php
$inbox = Inbox::get(42);
$inbox->setMessage('Aktualisierte Nachricht');
$inbox->save();
```

### 26. Spam-Schutz mit Honeypot aktivieren

```php
$yform = Inbox::getYForm(
    null,
    null,
    true,  // objparams
    true,  // honeypot aktiviert
    true,  // database
    0
);
```

### 27. Integration mit YForm Spam Protection

```php
// Voraussetzung: yform_spam_protection installiert
$yform = Inbox::getYForm();
// Honeypot wird automatisch eingefügt
echo $yform->getForm();
```

### 28. Custom Template für YForm

```php
$yform = Inbox::getYForm();
$yform->setObjectparams('form_ytemplate', 'bootstrap5,bootstrap');
echo $yform->getForm();
```

### 29. Formular ohne Datenbank-Speicherung (nur E-Mail)

```php
$yform = Inbox::getYForm(
    null,
    null,
    true,
    true,
    false,  // keine DB-Speicherung
    0
);
$yform->setActionField('tpl2email', ['inbox' => 'admin@example.com']);
echo $yform->getForm();
```

### 30. Multilinguale Formulare mit YRewrite

```php
// Fragment erstellen je Sprache
$yform = Inbox::getYForm();
$yform->setObjectparams('form_ytemplate', 'bootstrap5');

// Labels übersetzen via i18n
// rex_i18n::addDirectory(rex_path::addon('inbox', 'lang'));

echo $yform->getForm();
```

> **Integration:** Inbox arbeitet mit **YForm**, **Auto Delete** (DSGVO-Löschfristen), **Mailer Profile** (verschiedene SMTP-Profile), **YForm Spam Protection** (Honeypot/reCAPTCHA), **YForm Rapidmail** (Versandstatus-Tracking) und **YRewrite** (Multilingualität).
