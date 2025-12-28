# WSM (Wenn's Sein Muss) - Cookie Consent Manager

**Keywords:** Cookie, Consent, GDPR, DSGVO, Tracking, Iframe, Scripts, Services

## Übersicht

WSM ist ein moderner Cookie Consent Manager für REDAXO, der DSGVO-konform Einwilligungen für Tracking, Cookies und Drittanbieter-Dienste abfragt.

## Kern-Klassen

| Klasse | Beschreibung |
|--------|-------------|
| `Service` | Drittanbieter-Dienst mit Cookies/Tracking |
| `Group` | Kategorien (notwendig, Statistik, Marketing) |
| `Entry` | Cookie/LocalStorage/Tracking-Pixel-Eintrag |
| `Protocol` | Einwilligungs-Protokoll (Consent-Log) |
| `Iframe` | Iframe-Manager-Konfiguration |
| `Domain` | Domain-spezifische Einstellungen |
| `Fragment` | CSS/JS/Config-Ausgabe |
| `Lang` | Mehrsprachige Texte |
| `Wsm` | Helper-Klasse (Config, Services, JSON) |

## Klasse: Service

### Wichtige Methoden

| Methode | Rückgabe | Beschreibung |
|---------|----------|-------------|
| `getName()` | `string` | Dienstname |
| `getCompanyName()` | `string` | Firmenname |
| `getPrivacyPolicyUrl()` | `string` | Datenschutz-URL |
| `getJavascript()` | `string` | JavaScript nach Einwilligung |
| `getStatus()` | `int` | Status (Entwurf/Veröffentlicht) |
| `getGroupId()` | `int` | Zugewiesene Gruppe-ID |
| `getIframeManager()` | `string` | Iframe-Manager-Service-Name |

## Klasse: Protocol

### Wichtige Methoden

| Methode | Rückgabe | Beschreibung |
|---------|----------|-------------|
| `getConsentId()` | `string` | Eindeutige Consent-ID |
| `getAcceptType()` | `string` | Typ (all/necessary/custom) |
| `getAcceptedCategories()` | `string` | Akzeptierte Kategorien |
| `getAcceptedServices()` | `string` | Akzeptierte Dienste |
| `getRejectedServices()` | `string` | Abgelehnte Dienste |
| `getRevision()` | `?string` | Revisionsnummer |
| `getConsentdate()` | `string` | Einwilligungsdatum |

## Praxisbeispiele

### 1. Frontend-Integration

```php
<?php if (rex_addon::get('wenns_sein_muss')->isAvailable()): ?>
    <?= Alexplusde\Wsm\Fragment::getCss() ?>
    <?= Alexplusde\Wsm\Fragment::getScripts() ?>
    <?= Alexplusde\Wsm\Fragment::getJs() ?>
<?php endif ?>
```

### 2. Einstellungen-Button

```php
REX_WSM[type="manage"]
```

### 3. Consent-basiertes JavaScript

```html
<script type="text/plain" data-cookiecategory="analytics" src="analytics.js" defer></script>

<script type="text/plain" data-cookiecategory="ads">
    console.log('Ads category accepted');
</script>
```

### 4. Font nachladen nach Einwilligung

```javascript
link = document.createElement('link');
link.href = 'https://fonts.googleapis.com/css2?family=Rubik+Vinyl&display=swap';
link.rel = 'stylesheet';
document.getElementsByTagName('head')[0].appendChild(link);
```

### 5. Iframe-Manager YouTube

```html
<div class="video"
    data-service="youtube"
    data-id="dQw4w9WgXcQ"
    data-params="loop=1&autoplay=0&mute=1"
    data-autoscale data-ratio="16:9">
</div>
```

### 6. Iframe-Manager Google Maps

```html
<div class="maps"
    data-service="google_maps" 
    data-id="!1m14!1m12!1m3!1d..."
    data-autoscale>
</div>
```

### 7. Automatische YouTube-Ersetzung

```php
// In Einstellungen aktivieren: "Automatische YouTube-Ersetzung"
// Dann werden klassische YouTube-iframes automatisch umgewandelt
```

### 8. Dienst erstellen

```php
$service = Service::create();
$service->setName('Google Analytics');
$service->setCompanyName('Google LLC');
$service->setPrivacyPolicyUrl('https://policies.google.com/privacy');
$service->setStatus(1); // Veröffentlicht
$service->setGroupId(2); // Statistik-Gruppe
$service->save();
```

### 9. Cookie-Eintrag erstellen

```php
$entry = Entry::create();
$entry->setType('Cookie');
$entry->setName('_ga');
$entry->setDuration('2 Jahre');
$entry->setDescription('Google Analytics Cookie');
$entry->setServiceId($service->getId());
$entry->save();
```

### 10. Consent-Protokoll abrufen

```php
$protocols = Protocol::query()
    ->where('consentdate', date('Y-m-d'), '>=')
    ->find();

foreach ($protocols as $protocol) {
    echo $protocol->getConsentId() . ' - ' . $protocol->getAcceptType();
}
```

### 11. Open Cookie Database nutzen

```php
// Import eines Dienstes aus Open Cookie Database
Wsm::syncServiceFromOpenCookieDatabase('google_analytics');
```

### 12. Revisionsnummer setzen

```php
// In Einstellungen: "Revision" erhöhen
// Nutzer müssen erneut einwilligen
```

### 13. Domain-spezifische Einstellungen

```php
// Backend: Domains > Domain bearbeiten
// Impressum und Datenschutz pro Domain
$domain = Domain::query()->where('domain_id', 1)->findOne();
$domain->setImprintId(10);
$domain->setPrivacyPolicyId(11);
$domain->save();
```

### 14. Layout-Optionen

```php
// Backend: Einstellungen > Optik
// Layout: cloud, box, bar
// Position: bottom left, top center, etc.
```

### 15. Google Consent Mode v2

```php
// Automatisch aktiviert bei korrekter Konfiguration
// Sendet Consent-Status an Google Analytics/Ads
```

### 16. Sprog-Integration

```php
// Backend: Einstellungen > Setup > Sprog-Platzhalter
// Ersetzt alle Texte durch {{placeholder}}
rex_config::set('wenns_sein_muss', 'consent_modal_title', 
    Wildcard::getOpenTag() . 'consent_modal_title' . Wildcard::getCloseTag());
```

### 17. Demo-Daten importieren

```php
// Backend: Einstellungen > Demo
// Button: "Demo-Daten importieren"
```

### 18. API-Endpunkte

```php
// CSS: /?rex-api-call=wsm&wsm=css
// Lang: /?rex-api-call=wsm&wsm=lang
// JS: /?rex-api-call=wsm&wsm=js
```

### 19. JavaScript-Events

```javascript
// Consent gegeben
document.addEventListener('cc:onConsent', function() {
    console.log('Consent given');
});

// Consent geändert
document.addEventListener('cc:onChange', function() {
    console.log('Consent changed');
});
```

### 20. Modal programmatisch öffnen

```javascript
// Einstellungen öffnen
CookieConsent.show();

// Nur Consent-Modal
CookieConsent.show('consentModal');

// Nur Einstellungen
CookieConsent.show('preferencesModal');
```

### 21. Status prüfen

```javascript
const cookie = CookieConsent.getCookie();
const preferences = CookieConsent.getUserPreferences();

console.log(preferences.acceptType); // 'all', 'necessary', 'custom'
console.log(preferences.acceptedCategories); // ['necessary', 'analytics']
console.log(preferences.acceptedServices);
```

### 22. Service-Skript laden

```javascript
// Nach Einwilligung Dienst akzeptieren
CookieConsent.acceptService('analytics', 'analytics');
```

### 23. Custom Theme

```php
// Backend: Einstellungen > Optik > Theme
// CSS-Variablen in eigenem Stylesheet überschreiben
```

### 24. Tracking deaktivieren bei Prefetch

```php
// Automatisch: Sec-Purpose Header wird geprüft
// Prefetch/Prerender-Anfragen werden NICHT geloggt
```

### 25. Einwilligung widerrufen

```javascript
// Nutzer kann in Einstellungen Kategorien deaktivieren
// Neuer Protokoll-Eintrag wird erstellt
```

> **Integration:** WSM arbeitet mit **Sprog** (Mehrsprachigkeit), **YRewrite** (Domains), **Cookie Consent** (orestbida/cookieconsent), **Iframe Manager** (orestbida/iframemanager) und **Open Cookie Database** (OpenCookieDatabase.org). Erstellt automatisch Consent-Logs für DSGVO-Compliance und unterstützt Google Consent Mode v2 sowie YCom (Cookie-frei bis Login).
