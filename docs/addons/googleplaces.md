# Google Places - Keywords: Google Places API, Reviews, Rezensionen, Bewertungen, Google Maps, Place ID, YForm, Cronjob, Backend, API-Integration

## Übersicht

**Google Places** ist ein Add-on für REDAXO 5, das die Integration der Google Places API ermöglicht. Es speichert Details zu Google Places-Einträgen sowie Rezensionen (Reviews) in der Datenbank und ermöglicht die automatische Synchronisation via Cronjob. Das Add-on basiert auf YOrm-Datasets und bietet eine komfortable Backend-Verwaltung sowie Fragment-basierte Frontend-Ausgabe.

**Autor:** FriendsOfREDAXO  
**GitHub:** <https://github.com/alexplusde/googleplaces>  
**Version:** 3.x  
**Namespace:** `FriendsOfRedaxo\GooglePlaces`

---

## Hauptklassen

| Klasse | Beschreibung |
|--------|--------------|
| `FriendsOfRedaxo\GooglePlaces\GooglePlaces` | Statische Utility-Klasse für API-Zugriffe auf die Google Places API |
| `FriendsOfRedaxo\GooglePlaces\Place` | YOrm-Dataset-Klasse für Google Places-Einträge (rex_googleplaces_place_detail) |
| `FriendsOfRedaxo\GooglePlaces\Review` | YOrm-Dataset-Klasse für Rezensionen (rex_googleplaces_review) |
| `FriendsOfRedaxo\GooglePlaces\Cronjob` | Cronjob-Klasse für automatische Synchronisation aller Places |
| `rex_api_find_place_id` | API-Endpunkt für die Suche nach Places über Text Search API |

---

## Google Places API-Anbindung

### API-Endpunkte

```php
// Google Places Details API
https://maps.googleapis.com/maps/api/place/details/json?place_id={place_id}&key={api_key}

// Google Places Text Search API (v1)
https://places.googleapis.com/v1/places:searchText
```

### API-Key-Konfiguration

| Einstellung | Beschreibung |
|-------------|--------------|
| `api_key` | Google Maps API-Schlüssel mit Places API Berechtigung |

---

## 25 Praxisbeispiele

### 1. Google Place zur Datenbank hinzufügen

```php
use FriendsOfRedaxo\GooglePlaces\Place;

$place = Place::create();
$place->setPlaceId('ChIJN1t_tDeuEmsRUsoyG83frY4'); // Google Place ID
$place->save();
```

### 2. Place-Details synchronisieren

```php
$place = Place::get(1);
if ($place->sync()) {
    echo "Synchronisation erfolgreich";
} else {
    echo "Fehler bei der Synchronisation";
}
```

### 3. Alle Places abrufen

```php
$places = Place::query()->find();
foreach ($places as $place) {
    echo $place->getName() . ' - ' . $place->getAddress();
}
```

### 4. Rezensionen zu einem Place abrufen

```php
$place = Place::get(1);
$reviews = $place->getReviews(5, 0, 4); // Limit 5, Offset 0, Min Rating 4
foreach ($reviews as $review) {
    echo $review->getAuthorName() . ': ' . $review->getRating() . '/5';
}
```

### 5. API-Response als Array abrufen

```php
$place = Place::get(1);
$apiData = $place->getApiResponseAsArray();
echo $apiData['name']; // Name aus API-Response
echo $apiData['formatted_address']; // Adresse
```

### 6. Durchschnittliche Bewertung aus API

```php
$place = Place::get(1);
$avgRating = $place->getAvgRatingApi(); // z.B. 4.5
echo "Durchschnittsbewertung: " . $avgRating . " / 5";
```

### 7. Durchschnittliche Bewertung aus Datenbank

```php
$place = Place::get(1);
$avgRating = $place->getAvgRating(); // Berechnet aus gespeicherten Reviews
```

### 8. Anzahl der Rezensionen zählen

```php
$place = Place::get(1);
$count = $place->countReviews();
echo "Anzahl Rezensionen: " . $count;
```

### 9. Place-Name aus API-Response

```php
$place = Place::get(1);
$name = $place->getName(); // Aus JSON extrahiert
```

### 10. Place-Adresse aus API-Response

```php
$place = Place::get(1);
$address = $place->getAddress(); // Aus JSON extrahiert
```

### 11. Places als Select-Optionen

```php
$options = Place::getPlacesOptions(); // Array: ID => "Name Adresse"
```

### 12. Backend-Suche nach Places

```php
// GET-Parameter: name, street, zip, city
$name = 'Restaurant';
$street = 'Hauptstraße 1';
$zip = '12345';
$city = 'Berlin';

$result = rex_api_find_place_id::queryPlaces($name, $street, $zip, $city, $apiKey);
// Gibt Array mit Places zurück
```

### 13. Place über API-Endpunkt hinzufügen

```php
// Backend-URL:
$url = 'index.php?rex-api-call=find_place_id';
$url .= '&name=' . urlencode('Restaurant');
$url .= '&street=' . urlencode('Hauptstraße 1');
$url .= '&zip=12345';
$url .= '&city=' . urlencode('Berlin');

// Gibt JSON zurück:
// {"ChIJxxx": {"text": "Restaurant Name", "formattedAddress": "..."}}
```

### 14. Review-Status setzen

```php
use FriendsOfRedaxo\GooglePlaces\Review;

$review = Review::get(1);
$review->setStatus(Review::STATUS_VISIBLE); // STATUS_VISIBLE oder STATUS_HIDDEN
$review->save();
```

### 15. Rezensionen nach Datum filtern

```php
$place = Place::get(1);
$reviews = $place->getReviews(
    10,                    // Limit
    0,                     // Offset
    5,                     // Min Rating
    'publishdate',         // Order by field
    'DESC'                 // Order direction
);
```

### 16. Cronjob für automatische Synchronisation

```php
// Wird bei Installation automatisch angelegt
use FriendsOfRedaxo\GooglePlaces\GooglePlaces;

GooglePlaces::syncAll(); // Synchronisiert alle Places
```

### 17. Manuelle Synchronisation aus Backend

```php
// pages/sync.php
$places = Place::query()->find();
foreach ($places as $place) {
    $place->sync();
}
```

### 18. Fragment für Review-Ausgabe

```php
use FriendsOfRedaxo\GooglePlaces\Place;

$fragment = new rex_fragment();
$fragment->setVar('place', Place::get(1), false);
echo $fragment->parse('googleplaces/reviews.bs5.php');
```

### 19. Review-Autor-URL abrufen

```php
$review = Review::get(1);
$authorUrl = $review->getAuthorUrl(); // Google-Profil-URL
```

### 20. Review-Text abrufen

```php
$review = Review::get(1);
$text = $review->getText(); // Review-Text
```

### 21. Review-Rating abrufen

```php
$review = Review::get(1);
$rating = $review->getRating(); // 1-5
```

### 22. Review-Veröffentlichungsdatum

```php
$review = Review::get(1);
$date = $review->getPublishdate(); // datetime
```

### 23. Place-Update-Datum

```php
$place = Place::get(1);
$lastUpdate = $place->getUpdatedate(); // Letztes Sync-Datum
```

### 24. YForm-Backend-Liste mit Custom-Columns

```php
// Extension Point YFORM_DATA_LIST
Place::epYformDataList($ep);
// Zeigt Name, Adresse, Telefon aus API-Response
```

### 25. Fehlerbehandlung bei API-Requests

```php
$placeData = GooglePlaces::googleApiResult('ChIJN1t_tDeuEmsRUsoyG83frY4');

if (isset($placeData['error'])) {
    // API-Fehler aufgetreten
    rex_logger::factory()->log('warning', 'Google Places API Error: ' . $placeData['error']);
}
```

---

## GooglePlaces-Klasse (API-Utility)

| Methode | Beschreibung |
|---------|--------------|
| `googleApiResult(string $place_id = null): array` | Ruft Place-Details direkt von Google Places API ab |
| `getFromGoogle(string $place_id = null, string $key = null): array\|string` | Wie googleApiResult, optional mit Key-Filter |
| `getPlaceDetails(string $place_id = null): array\|false` | Prüft DB, sonst API-Abruf |
| `getAllReviewsLive(string $place_id = null): array` | Ruft Reviews direkt von API ab (limitiert auf 5) |
| `syncAll(): bool` | Synchronisiert alle Places in der Datenbank |

---

## Place-Klasse (YOrm-Dataset)

| Methode | Beschreibung |
|---------|--------------|
| `getReviews(int $limit, int $offset, int $minRating, string $orderByField, string $orderBy, int $status): Collection` | Reviews mit Filterung |
| `getApiResponseAsArray(): ?array` | API-Response als Array |
| `sync(): bool` | Synchronisiert diesen Place mit API |
| `countReviews(): int` | Anzahl Reviews aus DB |
| `getAvgRatingApi(): float` | Durchschnittsbewertung aus API |
| `getAvgRating(): float` | Durchschnittsbewertung aus DB-Reviews |
| `getName(): string` | Place-Name aus API-Response |
| `getAddress(): string` | Adresse aus API-Response |
| `getPlacesOptions(): array` | Alle Places als Select-Optionen |
| `getPlaceId(): ?string` | Google Place ID |
| `setPlaceId(mixed $value): self` | Setzt Place ID |
| `getApiResponseJson(): ?string` | API-Response als JSON-String |
| `setApiResponseJson(mixed $value): self` | Setzt API-Response |
| `getUpdatedate(): ?string` | Letztes Update-Datum |
| `setUpdatedate(string $datetime): self` | Setzt Update-Datum |

---

## Review-Klasse (YOrm-Dataset)

| Methode | Beschreibung |
|---------|--------------|
| `getPlace(): ?Place` | Zugehöriger Place |
| `getPlaceId(): ?int` | Place-ID (Relation) |
| `setPlaceId(int $value): self` | Setzt Place-ID |
| `getGooglePlaceId(): ?string` | Google Place ID |
| `setGooglePlaceId(mixed $value): self` | Setzt Google Place ID |
| `getAuthorName(): ?string` | Review-Autor-Name |
| `getAuthorUrl(): ?string` | Google-Profil-URL des Autors |
| `getProfilePhotoUrl(): ?string` | Profilbild-URL |
| `getRating(): ?int` | Bewertung 1-5 |
| `getText(): ?string` | Review-Text |
| `getPublishdate(): ?string` | Veröffentlichungsdatum |
| `getStatus(): ?int` | STATUS_VISIBLE oder STATUS_HIDDEN |
| `setStatus(int $value): self` | Setzt Status |

---

## Datenbank-Struktur

### Tabelle: rex_googleplaces_place_detail

| Feld | Typ | Beschreibung |
|------|-----|--------------|
| `id` | int | Primärschlüssel |
| `place_id` | varchar(191) | Google Place ID (unique) |
| `api_response_json` | text | Vollständige API-Antwort als JSON |
| `createdate` | datetime | Erstellungsdatum |
| `updatedate` | datetime | Letztes Update |
| `review_ids` | varchar(191) | YForm-Relation zu Reviews |

### Tabelle: rex_googleplaces_review

| Feld | Typ | Beschreibung |
|------|-----|--------------|
| `id` | int | Primärschlüssel |
| `uuid` | varchar(36) | Eindeutige UUID |
| `place_detail_id` | int | Relation zu Place |
| `google_place_id` | varchar(191) | Google Place ID |
| `author_name` | varchar(191) | Autor-Name |
| `author_url` | text | Google-Profil-URL |
| `profile_photo_url` | text | Profilbild-URL |
| `rating` | int | Bewertung 1-5 |
| `text` | text | Review-Text |
| `publishdate` | datetime | Veröffentlichungsdatum |
| `status` | tinyint(1) | STATUS_VISIBLE (1) oder STATUS_HIDDEN (0) |
| `createdate` | datetime | Erstellungsdatum |
| `updatedate` | datetime | Letztes Update |

**Indizes:**

- `rex_googleplaces_review`: UNIQUE auf `uuid`, UNIQUE auf Kombination `google_place_id + author_url`

---

## Cronjob-Konfiguration

| Cronjob | Beschreibung |
|---------|--------------|
| `Google Places: Reviews per API-Call aktualisieren` | Synchronisiert automatisch alle Places, wird bei Installation angelegt |

**Empfohlene Intervalle:**

- **Täglich**: Für 1-5 Places
- **Wöchentlich**: Für 5-20 Places
- **Monatlich**: Bei begrenztem API-Kontingent

**API-Limits beachten:** Reviews bei Google werden nicht stündlich aktualisiert. Tägliche oder wöchentliche Intervalle sind meist ausreichend.

---

## Backend-Seiten

| Seite | Beschreibung |
|-------|--------------|
| `Google Places → Abfrage` | Suche nach Places über Text Search API, Hinzufügen zur Datenbank |
| `Google Places → Places` | YForm-Liste aller gespeicherten Places mit Details |
| `Google Places → Reviews` | YForm-Liste aller Rezensionen mit Filterung |
| `Google Places → Sync` | Manuelle Synchronisation aller Places |
| `Google Places → Einstellungen` | API-Key-Konfiguration, Auto-Publish-Einstellung |

---

## Einstellungen

| Einstellung | Beschreibung | Werte |
|-------------|--------------|-------|
| `api_key` | Google Maps API-Schlüssel | Text |
| `sync_reviews` | Reviews automatisch synchronisieren | 0/1 |
| `auto_publish_reviews` | Neue Reviews automatisch veröffentlichen | STATUS_HIDDEN / STATUS_VISIBLE |

---

## Fragment-Ausgabe

### Bootstrap 5 Fragment

```php
// fragments/googleplaces/reviews.bs5.php
use FriendsOfRedaxo\GooglePlaces\Place;

$place = Place::get(1);
$limit = 3;
$reviews = $place->getReviews($limit, 0, 5, 'publishdate', 'DESC');
```

**Template-Struktur:**

- Zeigt Place-Name und Durchschnittsbewertung
- Listet Reviews mit Autor, Rating, Text, Datum
- Link zu "Eigene Bewertung verfassen"

---

## API-Limitierung

**Wichtiger Hinweis:** Die Google Places API beschränkt den Zugriff auf die **letzten 5 Rezensionen** pro Place. Für vollständigen Review-Zugriff sind weitere API-Calls oder eine andere Lösung erforderlich.

---

## Integration mit YRewrite

Das Add-on kann mit [YRewrite](yrewrite.md) kombiniert werden, um Places domainspezifisch zu verwalten. Über die Backend-Suche können Places gefunden und hinzugefügt werden.

---

## Integration mit MForm

Modul-Eingabe mit MForm für Place-Auswahl:

```php
use FriendsOfRedaxo\MForm;
use FriendsOfRedaxo\GooglePlaces\Place;

$mform = MForm::factory();
$places = Place::query()->find();
$options = [];
foreach($places as $place) {
    $options[$place->getId()] = $place->getName();   
}
$mform->addSelectField("1.0", $options, ['label' => 'Standort auswählen']);
echo $mform->show();
```

---

## Verwandte Addons

- [YForm](yform.md) - Datenbank-Management
- [YRewrite](yrewrite.md) - Domain-Management
- [Cronjob](cronjob.md) - Automatische Synchronisation
- [MForm](mform.md) - Modul-Eingabe

---

**GitHub:** <https://github.com/alexplusde/googleplaces>
