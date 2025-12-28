# Staff - Mitarbeiterverwaltung

**Keywords:** Staff, Team, Mitarbeiter, VCard, QR-Code, Kontaktdaten, YForm

## Übersicht

Staff ist eine YForm-basierte Mitarbeiterverwaltung für Team-Seiten mit VCard/QR-Code-Export, Kategorien und Adressverwaltung.

## Kern-Klassen

| Klasse | Beschreibung |
|--------|-------------|
| `Person` | Mitarbeiter-Dataset (`rex_yform_manager_dataset`) |
| `Category` | Mitarbeiter-Kategorie |
| `Address` | Adress-Dataset (optional verknüpfbar) |

## Klasse: Person

### Wichtige Methoden (Getter)

| Methode | Rückgabe | Beschreibung |
|---------|----------|-------------|
| `::get($id)` | `Person\|null` | Lädt Mitarbeiter |
| `getName()` | `string` | Vollständiger Name (oder Fullname-Feld) |
| `getFullName()` | `string` | Vor- + Nachname kombiniert |
| `getFirstName()` | `string` | Vorname |
| `getLastName()` | `string` | Nachname |
| `getTitle()` | `string` | Titel (Dr., Prof.) |
| `getDescription()` | `string` | Kurzbeschreibung/Position |
| `getContent()` | `string` | Vita/Lebenslauf (HTML) |
| `getCompany()` | `string` | Unternehmen |
| `getMailWork()` | `string` | Geschäftliche E-Mail |
| `getMailHome()` | `string` | Private E-Mail |
| `getPhoneCell()` | `string` | Mobilnummer (normalisiert) |
| `getPhoneWork()` | `string` | Arbeitsnummer |
| `getPhoneHome()` | `string` | Privatnummer |
| `getUrl()` | `string` | Website-URL |
| `getImage()` | `string` | Profilbild-Dateiname |
| `getMedia()` | `?rex_media` | Media-Objekt |

### Adress-Methoden (mit Fallback)

| Methode | Rückgabe | Beschreibung |
|---------|----------|-------------|
| `getAddress()` | `?Address` | Verknüpfte Adresse |
| `getStreet()` | `string` | Straße (verknüpft/Fallback) |
| `getCity()` | `string` | Stadt |
| `getZip()` | `string` | PLZ |
| `getCountry()` | `string` | Land |

### VCard/QR-Code

| Methode | Rückgabe | Beschreibung |
|---------|----------|-------------|
| `getVCard()` | `string` | VCard 3.0 als String |
| `getVCardObject()` | `VCard` | VCard-Objekt (anpassbar) |
| `getQRCode()` | `string` | QR-Code als SVG/PNG |
| `getQrCodeModal()` | `string` | Bootstrap 5 Modal HTML |
| `getQrUrl()` | `string` | Backend-API-URL für QR |
| `getVCardUrl()` | `string` | Backend-API-URL für VCard |

### Status-Konstanten

| Konstante | Wert | Beschreibung |
|-----------|------|-------------|
| `STATUS_ONLINE` | `1` | Veröffentlicht |
| `STATUS_DRAFT` | `0` | Entwurf |
| `STATUS_HIDDEN` | `-1` | Versteckt |
| `STATUS_LOCKED` | `-2` | Gesperrt |

## Praxisbeispiele

### 1. Mitarbeiter laden

```php
use Alexplusde\Staff\Person;

$person = Person::get(42);
echo $person->getFullName();
echo $person->getDescription();
```

### 2. Alle Online-Mitarbeiter

```php
$staff = Person::query()
    ->where('status', Person::STATUS_ONLINE)
    ->orderBy('prio', 'ASC')
    ->find();
```

### 3. VCard erstellen

```php
$person = Person::get(42);
$vcard = $person->getVCard();
header('Content-Type: text/vcard; charset=utf-8');
header('Content-Disposition: attachment; filename="kontakt.vcf"');
echo $vcard;
```

### 4. QR-Code als SVG

```php
$person = Person::get(42);
$qrCode = $person->getQRCode(['outputType' => QRCode::OUTPUT_MARKUP_SVG]);
echo '<div>' . $qrCode . '</div>';
```

### 5. QR-Code Modal (Bootstrap 5)

```php
$person = Person::get(42);
echo $person->getQrCodeModal();
// Rendert Button + Modal mit QR-Code und Download
```

### 6. Telefonnummern normalisiert

```php
$person = Person::get(42);
echo $person->getPhoneWork();  // +49 123 456789 (E.164)
echo $person->getPhoneCell();  // +49 170 1234567
```

### 7. Statische Normalisierung

```php
$normalized = Person::normalizePhone('0123 / 456-789');
// Gibt '+49123456789' zurück
```

### 8. Adresse mit Fallback

```php
$person = Person::get(42);
echo $person->getStreet();   // Aus verknüpfter Adresse oder Fallback
echo $person->getZip();
echo $person->getCity();
echo $person->getCountry();
```

### 9. Verknüpfte Adresse laden

```php
use Alexplusde\Staff\Address;

$person = Person::get(42);
$address = $person->getAddress();
if ($address) {
    echo $address->getName();  // z.B. "Hauptsitz München"
    echo $address->getStreet();
}
```

### 10. Neue Adresse zuordnen

```php
$address = Address::create();
$address->setName('Filiale Berlin');
$address->setStreet('Unter den Linden 1');
$address->setZip('10117');
$address->setCity('Berlin');
$address->save();

$person = Person::get(42);
$person->setValue('address_id', $address->getId());
$person->save();
```

### 11. Mitarbeiter nach Kategorie

```php
use Alexplusde\Staff\Category;

$category = Category::get(2); // z.B. "Vorstand"
$members = $category->getAllMembers();
foreach ($members as $member) {
    echo $member->getName();
}
```

### 12. Kategorien eines Mitarbeiters

```php
$person = Person::get(42);
$categoryIds = explode(',', $person->getValue('category_ids'));
foreach ($categoryIds as $catId) {
    $cat = Category::get($catId);
    echo $cat->getName();
}
```

### 13. Profilbild ausgeben

```php
$person = Person::get(42);
$media = $person->getMedia();
if ($media) {
    echo '<img src="' . $media->getUrl() . '" alt="' . $person->getName() . '">';
}
```

### 14. Mit Media Manager

```php
$person = Person::get(42);
$image = $person->getImage();
if ($image) {
    $url = rex_media_manager::getUrl('rex_media_small', $image);
    echo '<img src="' . $url . '">';
}
```

### 15. JSON+LD für Person (schema.org)

```php
$person = Person::get(42);
$fragment = new rex_fragment();
$fragment->setVar('person', $person);
echo $fragment->parse('staff/json-ld.php');
```

### 16. Status prüfen

```php
$person = Person::get(42);
if ($person->getValue('status') === Person::STATUS_ONLINE) {
    echo 'Mitarbeiter ist sichtbar';
}
```

### 17. Neuen Mitarbeiter anlegen

```php
$person = Person::create();
$person->setFullname('Max Mustermann');
$person->setFirstname('Max');
$person->setLastname('Mustermann');
$person->setEmailWork('max@example.com');
$person->setPhoneWork('+49 123 456789');
$person->setPrio(10);
$person->setValue('status', Person::STATUS_ONLINE);
$person->save();
```

### 18. Sortierung nach Priorität

```php
$staff = Person::query()
    ->where('status', Person::STATUS_ONLINE)
    ->orderBy('prio', 'ASC')
    ->orderBy('lastname', 'ASC')
    ->find();
```

### 19. Backend-User verknüpfen (Author)

```php
$person = Person::get(42);
$person->setValue('be_user_id', 5); // rex_user ID
$person->save();
```

### 20. VCard-Objekt anpassen

```php
$person = Person::get(42);
$vcard = $person->getVCardObject();
$vcard->addNote('Wichtiger Ansprechpartner');
$vcard->addCategories(['Vertrieb', 'Außendienst']);
echo $vcard->getOutput();
```

### 21. QR-Code mit Optionen

```php
$person = Person::get(42);
$qr = $person->getQRCode([
    'outputType' => QRCode::OUTPUT_IMAGE_PNG,
    'eccLevel' => 'H',
    'scale' => 10
]);
```

### 22. Custom Getter für Firma (Fallback)

```php
// Person::getCompany() liefert Default aus Einstellungen
$company = $person->getCompany();
// Wenn leer: rex_config::get('staff', 'default_company_name')
```

### 23. URL mit Fallback

```php
// Person::getUrl() liefert Default aus Einstellungen
$url = $person->getUrl();
// Wenn leer: rex_config::get('staff', 'default_company_url')
```

### 24. Team-Seite ausgeben

```php
$categories = Category::query()->orderBy('prio')->find();
foreach ($categories as $cat) {
    echo '<h2>' . $cat->getName() . '</h2>';
    $members = $cat->getAllMembers();
    foreach ($members as $person) {
        echo '<div class="team-member">';
        echo '<img src="' . rex_media_manager::getUrl('thumb', $person->getImage()) . '">';
        echo '<h3>' . $person->getName() . '</h3>';
        echo '<p>' . $person->getDescription() . '</p>';
        echo '<a href="mailto:' . $person->getMailWork() . '">E-Mail</a>';
        echo '</div>';
    }
}
```

### 25. Download-Links Backend

```php
$person = Person::get(42);
echo '<a href="' . $person->getVCardUrl(true) . '">VCard herunterladen</a>';
echo '<a href="' . $person->getQrUrl('svg', true) . '">QR-Code herunterladen</a>';
```

> **Integration:** Staff arbeitet mit **YForm** (Datenbank/Backend), **chillerlan/php-qrcode** (QR-Codes), **jeroendesloovere/vcard** (VCards), **Media Manager Responsive** (optional für Bilder) und nutzt **rex_config** für Standard-Firmendaten (Name, URL, Adresse).
