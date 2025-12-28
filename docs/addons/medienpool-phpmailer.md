# Medienpool & PHPMailer

**Keywords:** Media Upload File Management Email SMTP Mailer Attachment

## rex_media - Medienpool

### Hauptklasse

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `::get($filename)` | string | rex_media\|null | Datei per Dateiname |
| `::getList()` | - | array | Alle Medien |
| `getFileName()` | - | string | Dateiname |
| `getTitle()` | - | string | Titel |
| `getCategory()` | - | rex_media_category\|null | Kategorie |
| `getCategoryId()` | - | int | Kategorie-ID |
| `getWidth()` | - | int | Bildbreite (Pixel) |
| `getHeight()` | - | int | Bildhöhe (Pixel) |
| `getType()` | - | string | MIME-Type |
| `getSize()` | - | int | Dateigröße (Bytes) |
| `getFormattedSize()` | - | string | Größe formatiert (z.B. "1.5 MB") |
| `getExtension()` | - | string | Dateiendung |
| `isImage()` | - | bool | Ist Bild? |
| `getUrl()` | - | string | Media-URL |
| `getValue($key)` | string | mixed | Metainfo-Feld |
| `toImage($params)` | array | string | `<img>` Tag |
| `toLink($params)` | array | string | `<a>` Tag |
| `getUpdateDate()` | - | string | Änderungsdatum |
| `getCreateDate()` | - | string | Erstelldatum |
| `getUpdateUser()` | - | string | Bearbeiter |
| `getCreateUser()` | - | string | Ersteller |

### rex_media_category

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `::get($id)` | int | rex_media_category\|null | Kategorie per ID |
| `::getRootCategories()` | - | array | Root-Kategorien |
| `getId()` | - | int | ID |
| `getName()` | - | string | Name |
| `getParent()` | - | rex_media_category\|null | Eltern-Kategorie |
| `getChildren()` | - | array | Unterkategorien |
| `getPath()` | - | string | Pfad (IDs mit \|) |

### Praxisbeispiele

```php
// Media abrufen
$media = rex_media::get('logo.png');

if ($media) {
    echo $media->getFileName(); // "logo.png"
    echo $media->getTitle(); // Titel aus Backend
    echo $media->getUrl(); // "/media/logo.png"
    echo $media->getFormattedSize(); // "125 KB"
    echo $media->isImage() ? 'Bild' : 'Datei';
}

// IMG-Tag generieren
$media = rex_media::get('beispiel.jpg');
echo $media->toImage(['class' => 'img-fluid', 'alt' => 'Beispiel']);
// <img src="/media/beispiel.jpg" class="img-fluid" alt="Beispiel" width="1200" height="800">

// Link generieren
echo $media->toLink(['class' => 'download']);
// <a href="/media/beispiel.jpg" class="download">beispiel.jpg</a>

// Mit Media Manager
$url = rex_media_manager::getUrl('large', $media->getFileName());
echo '<img src="' . $url . '">';

// Datei-Infos
if ($media->isImage()) {
    echo 'Größe: ' . $media->getWidth() . ' x ' . $media->getHeight();
}
echo 'MIME-Type: ' . $media->getType(); // "image/jpeg"
echo 'Extension: ' . $media->getExtension(); // "jpg"

// Kategorie
$category = $media->getCategory();
if ($category) {
    echo 'Kategorie: ' . $category->getName();
}

// Metainfo-Felder
echo $media->getValue('med_copyright'); // Copyright
echo $media->getValue('med_description'); // Beschreibung

// Alle Medien einer Kategorie
$category = rex_media_category::get(5);
$sql = rex_sql::factory();
$sql->setQuery('SELECT * FROM rex_media WHERE category_id = ?', [$category->getId()]);

foreach ($sql as $row) {
    $media = rex_media::get($row->getValue('filename'));
    echo $media->getFileName() . '<br>';
}
```

## rex_mailer - PHPMailer

### Hauptklasse

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `::factory()` | - | rex_mailer | Factory-Pattern |
| `setFrom($email, $name)` | string, string | $this | Absender |
| `addTo($email, $name)` | string, string | $this | Empfänger |
| `addCC($email, $name)` | string, string | $this | CC (Carbon Copy) |
| `addBCC($email, $name)` | string, string | $this | BCC (Blind Copy) |
| `addReplyTo($email, $name)` | string, string | $this | Reply-To |
| `setSubject($subject)` | string | $this | Betreff |
| `setBody($body)` | string | $this | HTML-Body |
| `setAltBody($body)` | string | $this | Plain-Text Alternative |
| `addAttachment($path, $name)` | string, string | $this | Anhang |
| `addStringAttachment($content, $name, $type)` | string, string, string | $this | Anhang aus String |
| `send()` | - | bool | E-Mail senden |
| `getError()` | - | string | Fehlermeldung |
| `isSmtp()` | - | bool | Verwendet SMTP? |

### Praxisbeispiele

```php
// Einfache E-Mail
$mail = rex_mailer::factory();

$mail->setFrom('absender@example.com', 'Absender Name');
$mail->addTo('empfaenger@example.com', 'Empfänger Name');
$mail->setSubject('Test-E-Mail');
$mail->setBody('<h1>Hallo</h1><p>Dies ist eine Test-E-Mail.</p>');
$mail->setAltBody('Hallo, dies ist eine Test-E-Mail.'); // Plain-Text

if ($mail->send()) {
    echo 'E-Mail erfolgreich gesendet';
} else {
    echo 'Fehler: ' . $mail->getError();
}

// Mehrere Empfänger
$mail = rex_mailer::factory();
$mail->setFrom('noreply@example.com');
$mail->addTo('user1@example.com', 'User 1');
$mail->addTo('user2@example.com', 'User 2');
$mail->addCC('manager@example.com', 'Manager');
$mail->addBCC('admin@example.com'); // Ohne Name
$mail->setSubject('Newsletter');
$mail->setBody('Newsletter-Inhalt...');
$mail->send();

// Mit Anhang (Datei)
$mail = rex_mailer::factory();
$mail->setFrom('info@example.com');
$mail->addTo('kunde@example.com');
$mail->setSubject('Rechnung');
$mail->setBody('Anbei finden Sie Ihre Rechnung.');
$mail->addAttachment(rex_path::media('rechnung.pdf'), 'Rechnung.pdf');
$mail->send();

// Mit Anhang (String/Content)
$csv = "Name,Email\nMax,max@example.com\nAnna,anna@example.com";

$mail = rex_mailer::factory();
$mail->setFrom('export@example.com');
$mail->addTo('admin@example.com');
$mail->setSubject('CSV-Export');
$mail->setBody('Export als CSV im Anhang.');
$mail->addStringAttachment($csv, 'export.csv', 'text/csv');
$mail->send();

// Reply-To
$mail = rex_mailer::factory();
$mail->setFrom('noreply@example.com', 'System');
$mail->addReplyTo('support@example.com', 'Support');
$mail->addTo('kunde@example.com');
$mail->setSubject('Kontaktanfrage erhalten');
$mail->setBody('Ihre Anfrage wurde erfasst.');
$mail->send();

// HTML-E-Mail mit Bildern
$logo_url = rex_url::media('logo.png');

$html = '
<!DOCTYPE html>
<html>
<head><style>body { font-family: Arial; }</style></head>
<body>
    <img src="' . $logo_url . '" alt="Logo">
    <h1>Willkommen</h1>
    <p>Vielen Dank für Ihre Registrierung.</p>
</body>
</html>
';

$mail = rex_mailer::factory();
$mail->setFrom('welcome@example.com');
$mail->addTo('neuer-user@example.com');
$mail->setSubject('Willkommen');
$mail->setBody($html);
$mail->setAltBody('Willkommen! Vielen Dank für Ihre Registrierung.');
$mail->send();

// E-Mail aus Template
$template = rex_file::get(rex_path::addon('project', 'email_templates/welcome.php'));

$replacements = [
    '###NAME###' => 'Max Mustermann',
    '###EMAIL###' => 'max@example.com',
    '###URL###' => 'https://example.com/activate/abc123'
];

$body = str_replace(array_keys($replacements), array_values($replacements), $template);

$mail = rex_mailer::factory();
$mail->addTo('max@example.com');
$mail->setSubject('Aktivierung erforderlich');
$mail->setBody($body);
$mail->send();

// Fehlerbehandlung
$mail = rex_mailer::factory();
$mail->addTo('invalid-email'); // Ungültig
$mail->setSubject('Test');
$mail->setBody('Test');

if (!$mail->send()) {
    rex_logger::logError('email', 'E-Mail-Versand fehlgeschlagen: ' . $mail->getError());
    echo 'E-Mail konnte nicht gesendet werden';
}

// Mit YForm Action kombinieren
// In YForm Modul-Eingabe:
$yform = rex_yform::factory();
$yform->setActionField('email', [
    'empfaenger@example.com',
    'Kontaktformular',
    'Name: ###name###\nEmail: ###email###\nNachricht: ###message###',
    'absender@example.com',
    'Website'
]);

// Custom Mailer für Profil
$mail = rex_mailer::factory();

// Profil aus DB laden (rex_mailer_profile addon)
$profile_id = 2;
$sql = rex_sql::factory();
$sql->setQuery('SELECT * FROM rex_mailer_profile WHERE id = ?', [$profile_id]);

if ($sql->getRows()) {
    $mail->setFrom($sql->getValue('from'), $sql->getValue('fromname'));
}

$mail->addTo('kunde@example.com');
$mail->setSubject('Nachricht');
$mail->setBody('Ihre Nachricht...');
$mail->send();

// Batch-Versand (Newsletter)
$recipients = rex_sql::factory();
$recipients->setQuery('SELECT email, name FROM rex_newsletter_subscribers WHERE active = 1');

$mail = rex_mailer::factory();
$mail->setFrom('newsletter@example.com', 'Newsletter');
$mail->setSubject('Neuer Newsletter');

$html = rex_file::get(rex_path::addon('project', 'newsletter_template.html'));

foreach ($recipients as $row) {
    $body = str_replace('###NAME###', $row->getValue('name'), $html);
    
    $mail->clearAddresses();
    $mail->addTo($row->getValue('email'), $row->getValue('name'));
    $mail->setBody($body);
    
    if (!$mail->send()) {
        rex_logger::logError('newsletter', 'Failed to send to: ' . $row->getValue('email'));
    }
    
    sleep(1); // Rate limiting
}

// Transaktions-E-Mail (Bestellbestätigung)
function sendOrderConfirmation($order_id) {
    $order = rex_yform_manager_dataset::get($order_id, 'rex_orders');
    
    $mail = rex_mailer::factory();
    $mail->setFrom('shop@example.com', 'Example Shop');
    $mail->addTo($order->customer_email, $order->customer_name);
    $mail->setSubject('Bestellbestätigung #' . $order_id);
    
    $html = '<h1>Bestellbestätigung</h1>';
    $html .= '<p>Vielen Dank für Ihre Bestellung.</p>';
    $html .= '<p>Bestellnummer: ' . $order_id . '</p>';
    $html .= '<h2>Artikel:</h2><ul>';
    
    foreach ($order->getItems() as $item) {
        $html .= '<li>' . $item->product_name . ' - ' . $item->quantity . 'x ' . $item->price . ' €</li>';
    }
    
    $html .= '</ul><p><strong>Gesamt: ' . $order->total . ' €</strong></p>';
    
    $mail->setBody($html);
    
    // PDF-Rechnung anhängen
    $invoice_path = rex_path::addonData('shop', 'invoices/invoice_' . $order_id . '.pdf');
    if (file_exists($invoice_path)) {
        $mail->addAttachment($invoice_path, 'Rechnung.pdf');
    }
    
    return $mail->send();
}

// E-Mail mit eingebettetem Bild (CID)
$mail = rex_mailer::factory();
$mail->addTo('empfaenger@example.com');
$mail->setSubject('Embedded Image');

$logo_path = rex_path::media('logo.png');
$cid = $mail->addEmbeddedImage($logo_path, 'logo');

$html = '<img src="cid:' . $cid . '" alt="Logo"><h1>Hallo</h1>';
$mail->setBody($html);
$mail->send();

// Debug-Modus
$mail = rex_mailer::factory();
$mail->SMTPDebug = 2; // 0=off, 1=client, 2=client+server
$mail->Debugoutput = function($str, $level) {
    rex_logger::factory()->log($level, $str);
};

$mail->setFrom('test@example.com');
$mail->addTo('empfaenger@example.com');
$mail->setSubject('Debug-Test');
$mail->setBody('Test');
$mail->send();
```
