# eRecht24 - Keywords: Rechtstexte, Datenschutz, Impressum, AGB, Privacy Policy, Legal, DSGVO, Cookie-Hinweis

## Übersicht

**eRecht24** integriert den eRecht24-Rechtstexte-Service in REDAXO. Das Add-on ermöglicht die automatische Synchronisation und Verwaltung von Rechtstexten (Datenschutzerklärung, Impressum, AGB) über die eRecht24-API. Änderungen werden per Push-Benachrichtigung automatisch aktualisiert.

**Autor:** Alexander Walther  
**GitHub:** <https://github.com/alexplusde/erecht24>  
**Abhängigkeiten:** YForm >= 4.0, YRewrite (optional)  
**API:** eRecht24 Projekt-API (kostenpflichtig)

---

## Kern-Klassen

| Klasse | Beschreibung |
|--------|--------------|
| `eRecht24` | Haupt-Utility-Klasse mit statischen Helper-Methoden |
| `eRecht24Client` | Domain-Registrierung und API-Verwaltung |
| `rex_api_erecht24_push` | Push-API für automatische Updates von eRecht24 |

---

## eRecht24 (Hauptklasse)

| Methode | Beschreibung |
|---------|--------------|
| `setConfig($key, $value)` | Setzt Config-Wert |
| `getConfig($key, $default = null)` | Liest Config-Wert |
| `getDomains()` | Gibt alle registrierten Domains zurück (Array) |
| `getTextById($domain, $textType, $lang = 'de')` | Liest gespeicherten Rechtstext (HTML) |
| `getTextHtml($domain, $textType, $lang = 'de')` | Wie `getTextById()` mit HTML-Output |
| `getTextPlain($domain, $textType, $lang = 'de')` | Rechtstext als Plain Text |
| `getLastModified($domain, $textType, $lang = 'de')` | Zeitpunkt der letzten Änderung |
| `getImprint($domain, $lang = 'de')` | Impressum abrufen |
| `getPrivacyPolicy($domain, $lang = 'de')` | Datenschutzerklärung abrufen |
| `getPrivacyPolicySocialMedia($domain, $lang = 'de')` | Datenschutz für Social Media |
| `getGoogleAnalytics($domain, $lang = 'de')` | Google Analytics Tracking Code |
| `setLanguageSupport($supported)` | Setzt unterstützte Sprachen (array) |
| `getLanguageSupport()` | Liest unterstützte Sprachen |

---

## eRecht24Client (Domain-Management)

| Methode | Beschreibung |
|---------|--------------|
| `registerDomain($domain, $apiKey)` | Registriert Domain mit API-Key bei eRecht24 |
| `unregisterDomain($domain)` | Entfernt Domain-Registrierung |
| `getDomainSecret($domain)` | Liest Secret für Domain (Push-API) |
| `validateApiKey($apiKey)` | Prüft Gültigkeit eines API-Keys |
| `fetchTexts($domain, $lang = 'de')` | Lädt alle Rechtstexte von API |
| `updateTexts($domain, $data)` | Aktualisiert Rechtstexte in Datenbank |

---

## rex_api_erecht24_push (Push-API)

| Methode | Beschreibung |
|---------|--------------|
| `execute()` | Verarbeitet Push-Benachrichtigung von eRecht24 |

**URL:** `/?rex-api-call=erecht24_push`

**Methode:** POST

**Payload:** JSON mit aktualisierten Rechtstexten

---

## Datenbank-Tabellen

### rex_erecht24_domain

| Spalte | Typ | Beschreibung |
|--------|-----|--------------|
| `id` | int | Primärschlüssel |
| `domain` | varchar(255) | Registrierte Domain |
| `api_key` | varchar(255) | eRecht24 API-Key |
| `secret` | varchar(255) | Secret für Push-API |
| `createdate` | datetime | Registrierungsdatum |
| `updatedate` | datetime | Letzte Änderung |

### rex_erecht24_text

| Spalte | Typ | Beschreibung |
|--------|-----|--------------|
| `id` | int | Primärschlüssel |
| `domain_id` | int | Foreign Key zu rex_erecht24_domain |
| `type` | varchar(50) | Typ (imprint, privacy_policy, etc.) |
| `lang` | varchar(5) | Sprache (de, en) |
| `html` | longtext | Rechtstext als HTML |
| `plain` | longtext | Rechtstext als Plain Text |
| `modified` | datetime | Zeitstempel der letzten API-Änderung |
| `createdate` | datetime | Erstellt am |
| `updatedate` | datetime | Aktualisiert am |

---

## Text-Typen

| Typ | Beschreibung |
|-----|--------------|
| `imprint` | Impressum |
| `privacy_policy` | Datenschutzerklärung |
| `privacy_policy_social_media` | Datenschutz für Social Media |
| `google_analytics` | Google Analytics Tracking Code |

---

## 25 Praxisbeispiele

### 1. Domain registrieren

```php
$client = new eRecht24Client();
$apiKey = 'dein-erecht24-api-key';
$domain = 'example.org';

if ($client->registerDomain($domain, $apiKey)) {
    echo "Domain erfolgreich registriert!";
} else {
    echo "Registrierung fehlgeschlagen.";
}
```

### 2. Impressum ausgeben

```php
$domain = 'example.org';
$imprint = eRecht24::getImprint($domain);

echo $imprint; // HTML-Output
```

### 3. Datenschutzerklärung ausgeben

```php
$privacyPolicy = eRecht24::getPrivacyPolicy('example.org');
echo $privacyPolicy;
```

### 4. Mehrsprachige Rechtstexte

```php
// Deutsches Impressum
$imprintDE = eRecht24::getImprint('example.org', 'de');

// Englisches Impressum
$imprintEN = eRecht24::getImprint('example.org', 'en');
```

### 5. Rechtstexte als Plain Text

```php
$plainText = eRecht24::getTextPlain('example.org', 'privacy_policy');
echo nl2br($plainText);
```

### 6. Zeitstempel der letzten Änderung

```php
$lastModified = eRecht24::getLastModified('example.org', 'imprint');
echo "Zuletzt geändert: " . date('d.m.Y H:i', strtotime($lastModified));
```

### 7. Social Media Datenschutz

```php
$socialMediaPrivacy = eRecht24::getPrivacyPolicySocialMedia('example.org');
echo $socialMediaPrivacy;
```

### 8. Google Analytics Tracking Code

```php
$gaCode = eRecht24::getGoogleAnalytics('example.org');
echo $gaCode; // Enthält Tracking-Code mit Cookie-Hinweisen
```

### 9. Alle registrierten Domains

```php
$domains = eRecht24::getDomains();
foreach ($domains as $domain) {
    echo $domain['domain'] . '<br>';
}
```

### 10. API-Key validieren

```php
$client = new eRecht24Client();
$apiKey = 'test-api-key';

if ($client->validateApiKey($apiKey)) {
    echo "API-Key ist gültig";
} else {
    echo "API-Key ist ungültig";
}
```

### 11. Domain-Secret abrufen

```php
$client = new eRecht24Client();
$secret = $client->getDomainSecret('example.org');
echo "Push-API-Secret: " . $secret;
```

### 12. Rechtstexte manuell aktualisieren

```php
$client = new eRecht24Client();
$texte = $client->fetchTexts('example.org', 'de');

if ($texte) {
    $client->updateTexts('example.org', $texte);
    echo "Rechtstexte aktualisiert!";
}
```

### 13. Unterstützte Sprachen setzen

```php
eRecht24::setLanguageSupport(['de', 'en']);
```

### 14. Unterstützte Sprachen abrufen

```php
$languages = eRecht24::getLanguageSupport();
// ['de', 'en']
```

### 15. Config-Wert setzen

```php
eRecht24::setConfig('custom_setting', 'my_value');
```

### 16. Config-Wert lesen

```php
$value = eRecht24::getConfig('custom_setting', 'default_value');
```

### 17. Domain deregistrieren

```php
$client = new eRecht24Client();
$client->unregisterDomain('example.org');
echo "Domain entfernt.";
```

### 18. Modul für Impressum

```php
// INPUT
<fieldset>
    <legend>Impressum</legend>
    <p>Wird automatisch von eRecht24 geladen.</p>
</fieldset>

// OUTPUT
<?php
$domain = rex::getServer();
echo eRecht24::getImprint($domain);
?>
```

### 19. Modul für Datenschutzerklärung

```php
// INPUT
<fieldset>
    <legend>Datenschutzerklärung</legend>
    <p>Wird automatisch von eRecht24 geladen.</p>
</fieldset>

// OUTPUT
<?php
$domain = rex::getServer();
echo eRecht24::getPrivacyPolicy($domain);
?>
```

### 20. YRewrite-Integration

```php
// Template: Sprache aus YRewrite
$lang = rex_yrewrite::getCurrentDomain()->getStartClang();
$langCode = rex_clang::get($lang)->getCode(); // 'de' oder 'en'

$imprint = eRecht24::getImprint(rex::getServer(), $langCode);
echo $imprint;
```

### 21. Push-API Webhook einrichten

```
1. eRecht24-Backend öffnen
2. Projekt → API-Einstellungen
3. Webhook-URL eintragen: https://example.org/?rex-api-call=erecht24_push
4. Secret aus REDAXO kopieren (rex_erecht24_domain.secret)
5. Speichern
```

### 22. Push-API testen

```bash
curl -X POST "https://example.org/?rex-api-call=erecht24_push" \
  -H "Content-Type: application/json" \
  -d '{
    "domain": "example.org",
    "secret": "your-secret-here",
    "type": "imprint",
    "html": "<h1>Impressum</h1>...",
    "plain": "Impressum...",
    "modified": "2024-01-15T10:30:00Z"
  }'
```

### 23. Impressum in Footer

```php
// Template footer.php
<footer>
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <a href="<?= rex_getUrl(rex_article::getSiteStartArticleId()) ?>">Startseite</a> |
                <a href="<?= rex_getUrl($impressumArticleId) ?>">Impressum</a> |
                <a href="<?= rex_getUrl($datenschutzArticleId) ?>">Datenschutz</a>
            </div>
        </div>
    </div>
</footer>
```

### 24. Backend-Seite: Alle Rechtstexte

```php
// pages/index.php Fragment
$domains = eRecht24::getDomains();

foreach ($domains as $domain) {
    echo '<h2>' . $domain['domain'] . '</h2>';
    
    $types = ['imprint', 'privacy_policy', 'privacy_policy_social_media'];
    foreach ($types as $type) {
        $modified = eRecht24::getLastModified($domain['domain'], $type);
        echo '<p>' . $type . ': ' . $modified . '</p>';
    }
}
```

### 25. Extension Point für Custom Processing

```php
// boot.php
rex_extension::register('ERECHT24_TEXTS_UPDATED', function(rex_extension_point $ep) {
    $domain = $ep->getParam('domain');
    $type = $ep->getParam('type');
    $lang = $ep->getParam('lang');
    
    // Custom Action, z.B. Notification
    rex_logger::logNotice('eRecht24', "Rechtstext aktualisiert: $domain / $type / $lang");
});
```

---

## Backend-Seiten

1. **eRecht24 → Domains:** Domain-Registrierung und API-Key-Verwaltung
2. **eRecht24 → Rechtstexte:** Übersicht aller gespeicherten Texte
3. **eRecht24 → Einstellungen:** Sprach-Konfiguration

---

## Push-API Setup

1. **Domain in REDAXO registrieren** (Backend → eRecht24 → Domains)
2. **Secret kopieren** (wird automatisch generiert)
3. **eRecht24-Backend öffnen** (<https://www.e-recht24.de/mitglieder/>)
4. **Projekt → API-Einstellungen**
5. **Webhook-URL:** `https://example.org/?rex-api-call=erecht24_push`
6. **Secret eintragen** (aus REDAXO kopiert)
7. **Speichern** → Automatische Updates aktiviert

---

## Mehrsprachigkeit

```php
// Sprachen aktivieren
eRecht24::setLanguageSupport(['de', 'en']);

// Deutsches Impressum
$imprintDE = eRecht24::getImprint('example.org', 'de');

// Englisches Impressum
$imprintEN = eRecht24::getImprint('example.org', 'en');

// YRewrite-Integration
$currentLang = rex_yrewrite::getCurrentDomain()->getStartClang();
$langCode = rex_clang::get($currentLang)->getCode();
$imprint = eRecht24::getImprint(rex::getServer(), $langCode);
```

---

## Hinweise

⚠️ **eRecht24-Projekt erforderlich** - Kostenpflichtiger Service (ab ca. 15 €/Monat)

⚠️ **API-Key nicht weitergeben** - Sicher aufbewahren (nicht in Git commiten)

⚠️ **Push-API für Echtzeit-Updates** - Ohne Push-API müssen Texte manuell aktualisiert werden

⚠️ **Datenschutz beachten** - eRecht24-Texte regelmäßig überprüfen und anpassen

---

## Installation

1. **eRecht24-Account erstellen:** <https://www.e-recht24.de/premium/>
2. **Projekt anlegen** im eRecht24-Backend
3. **API-Key generieren** (Projekt → API)
4. **Addon installieren** in REDAXO
5. **Domain registrieren** (Backend → eRecht24 → Domains)
6. **Push-API einrichten** (siehe oben)

---

## Verwandte Addons

- [YRewrite](yrewrite.md) - Mehrsprachigkeit und Domain-Verwaltung
- [YForm](yform.md) - Formular-Framework

---

**GitHub:** <https://github.com/alexplusde/erecht24>
