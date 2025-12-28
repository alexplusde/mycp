# Maintenance - Wartungsmodus | Keywords: Wartung, Downtime, Whitelist, IP-Filter, Domain-Sperrung, Ankündigung, Console, Zugriffskontrolle

**Übersicht**: Aktiviert Wartungsmodus für Frontend/Backend mit mehrstufigem Whitelist-System (IP, Domain, YRewrite-Domain), Authentifizierung (URL-Parameter, Passwort), Fragment-basierten Wartungsseiten, Ankündigungssystem und Console-Commands.

## Wartungsmodus-Typen

| Typ | Beschreibung |
|-----|-------------|
| `Frontend` | Nur Frontend blockieren |
| `Backend` | Nur Backend blockieren |
| `Both` | Frontend + Backend blockieren |

## Whitelist-Ebenen

| Ebene | Prüfung | Beispiel |
|-------|---------|----------|
| `IP-Whitelist` | IP-Adresse | `192.168.1.100, 10.0.0.5` |
| `Domain-Whitelist` | Host/Domain | `dev.example.com, staging.local` |
| `YRewrite-Whitelist` | YRewrite-Domain | `domain1\|domain2\|domain3` |

## Authentifizierung

| Methode | Beschreibung |
|---------|-------------|
| `URL-Parameter` | `?maintenance_secret=xyz` |
| `Passwort-Formular` | Login-Seite mit Passwort |
| `2FA` | Integration mit 2factor_auth |

## Console-Commands

| Command | Beschreibung |
|---------|-------------|
| `maintenance:mode on` | Wartungsmodus aktivieren |
| `maintenance:mode off` | Wartungsmodus deaktivieren |
| `maintenance:status` | Status abfragen |

## Praxisbeispiele

### Beispiel 1: Wartungsmodus aktivieren

Backend unter `System` > `Maintenance`:

- **Frontend-Wartung**: Aktiv
- **Backend-Wartung**: Inaktiv
- Speichern

Frontend ist nun gesperrt, Backend erreichbar.

### Beispiel 2: IP-Whitelist

```php
// Im Backend unter Maintenance > IP-Whitelist:
192.168.1.100, 192.168.1.101, 10.0.0.5

// Diese IPs können trotz Wartungsmodus zugreifen
```

### Beispiel 3: Domain-Whitelist

```php
// Im Backend unter Maintenance > Domain-Whitelist:
dev.example.com, staging.example.com, localhost

// Nur auf diesen Domains ist Zugriff erlaubt
```

### Beispiel 4: YRewrite-Domain-Whitelist

```php
// Im Backend unter Maintenance > YRewrite-Domains:
domain1.com|domain2.com|domain3.com

// Pipe-separated für mehrere YRewrite-Domains
```

### Beispiel 5: URL-Secret konfigurieren

```php
// Im Backend unter Maintenance > Secret:
maintenance_secret = mein-geheimer-code

// Zugriff via URL:
https://example.com/?maintenance_secret=mein-geheimer-code

// User erhält Session und kann navigieren
```

### Beispiel 6: Passwort-Authentifizierung

```php
// Im Backend unter Maintenance > Passwort:
wartung2024

// Frontend zeigt Passwort-Formular
// Nach korrekter Eingabe wird Session erstellt
```

### Beispiel 7: Custom Wartungsseite (Fragment)

```php
// Fragment: maintenance/frontend.php
<!DOCTYPE html>
<html>
<head>
    <title>Wartungsarbeiten</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 100px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        h1 { font-size: 48px; }
    </style>
</head>
<body>
    <h1>🔧 Wartungsarbeiten</h1>
    <p>Wir führen gerade Wartungsarbeiten durch.</p>
    <p>Bitte versuchen Sie es in 30 Minuten erneut.</p>
</body>
</html>
```

### Beispiel 8: Backend-Wartungsseite

```php
// Fragment: maintenance/backend.php
<!DOCTYPE html>
<html>
<head>
    <title>Backend-Wartung</title>
    <link rel="stylesheet" href="<?= rex_url::assets('core/bootstrap.min.css') ?>">
</head>
<body>
    <div class="container" style="margin-top: 100px;">
        <div class="alert alert-warning">
            <h2>Backend-Wartung</h2>
            <p>Das Backend ist vorübergehend nicht verfügbar.</p>
        </div>
    </div>
</body>
</html>
```

### Beispiel 9: Console-Aktivierung

```bash
# Wartungsmodus aktivieren
php redaxo/bin/console maintenance:mode on

# Wartungsmodus deaktivieren
php redaxo/bin/console maintenance:mode off

# Status abfragen
php redaxo/bin/console maintenance:status
```

### Beispiel 10: Programmatische Aktivierung

```php
use Alexplusde\Maintenance\Maintenance;

// Aktivieren
Maintenance::enable();

// Deaktivieren
Maintenance::disable();

// Status prüfen
if (Maintenance::isEnabled()) {
    echo 'Wartungsmodus aktiv';
}
```

### Beispiel 11: IP-Prüfung

```php
use Alexplusde\Maintenance\Maintenance;

$client_ip = $_SERVER['REMOTE_ADDR'];

if (Maintenance::isIpAllowed($client_ip)) {
    // IP auf Whitelist - Zugriff erlaubt
} else {
    // IP nicht erlaubt - Wartungsseite anzeigen
}
```

### Beispiel 12: Domain-Prüfung

```php
$host = $_SERVER['HTTP_HOST'];

if (Maintenance::isHostAllowed($host)) {
    // Domain erlaubt
} else {
    // Domain gesperrt
}
```

### Beispiel 13: YRewrite-Domain-Prüfung

```php
$domain = rex_yrewrite::getCurrentDomain();

if (Maintenance::isYrewriteDomainAllowed($domain)) {
    // YRewrite-Domain auf Whitelist
} else {
    // Domain gesperrt
}
```

### Beispiel 14: Secret-Prüfung

```php
// URL: ?maintenance_secret=xyz
$secret = rex_request::get('maintenance_secret', 'string');

if (Maintenance::isSecretAllowed($secret)) {
    // Secret korrekt - Session erstellen
    $_SESSION['maintenance_bypass'] = true;
}
```

### Beispiel 15: User-Prüfung (Backend)

```php
// Prüft ob User eingeloggt ist
if (Maintenance::isUserAllowed()) {
    // Backend-User - Zugriff erlaubt
} else {
    // Kein User - Wartungsseite
}
```

### Beispiel 16: Ankündigung erstellen

Im Backend unter `Maintenance` > `Ankündigung`:

- **Titel**: Geplante Wartung
- **Text**: Am 31.12.2024 von 22:00 - 02:00 Uhr
- **Startdatum**: 2024-12-30 00:00
- **Enddatum**: 2024-12-31 23:59
- **Aktiv**: Ja

Zeigt Ankündigung im Frontend vor Wartungsbeginn.

### Beispiel 17: Ankündigung im Template

```php
use Alexplusde\Maintenance\Announcement;

$announcement = Announcement::getCurrent();

if ($announcement && $announcement->isActive()) {
    echo '<div class="alert alert-info">';
    echo '<strong>' . $announcement->getTitle() . '</strong><br>';
    echo $announcement->getText();
    echo '</div>';
}
```

### Beispiel 18: Extension Point nutzen

```php
rex_extension::register('MAINTENANCE_CHECK', function($ep) {
    $is_maintenance = $ep->getSubject();
    
    // Custom Logic
    if (date('H') >= 22 && date('H') < 6) {
        // Nachts automatisch Wartungsmodus
        return true;
    }
    
    return $is_maintenance;
});
```

### Beispiel 19: Media-Dateien freigeben

```php
// Extension Point: MAINTENANCE_MEDIA_UNBLOCK_LIST
rex_extension::register('MAINTENANCE_MEDIA_UNBLOCK_LIST', function($ep) {
    $unblock = $ep->getSubject();
    
    // Bestimmte Medien trotz Wartung erlauben
    $unblock[] = 'logo.png';
    $unblock[] = 'favicon.ico';
    
    return $unblock;
});
```

### Beispiel 20: 2FA-Integration

```php
// Prüft ob 2factor_auth Addon installiert und User authentifiziert
if (rex_addon::get('2factor_auth')->isAvailable()) {
    if (Maintenance::isTwoFactorAuthenticated()) {
        // User mit 2FA - Zugriff erlaubt
    }
}
```

### Beispiel 21: Frontend + Backend gleichzeitig

```php
// Beide Modi aktivieren
Maintenance::enableFrontend();
Maintenance::enableBackend();

// Oder zusammen:
Maintenance::enable(true, true); // (frontend, backend)
```

### Beispiel 22: Nur für bestimmte Artikel

```php
rex_extension::register('MAINTENANCE_CHECK', function($ep) {
    $article = rex_article::getCurrent();
    
    // Nur bestimmte Artikel sperren
    if (in_array($article->getId(), [1, 5, 10])) {
        return true; // Wartungsmodus für diese Artikel
    }
    
    return false;
});
```

### Beispiel 23: Countdown-Timer

```php
// Fragment: maintenance/frontend.php
<?php
$end_time = strtotime('2024-12-31 02:00:00');
$now = time();
$remaining = $end_time - $now;
?>
<!DOCTYPE html>
<html>
<head>
    <title>Wartung</title>
    <script>
        // Countdown in JavaScript
        let remaining = <?= $remaining ?>;
        setInterval(() => {
            remaining--;
            const hours = Math.floor(remaining / 3600);
            const minutes = Math.floor((remaining % 3600) / 60);
            document.getElementById('countdown').innerText = 
                hours + 'h ' + minutes + 'm';
        }, 1000);
    </script>
</head>
<body>
    <h1>Wartungsarbeiten</h1>
    <p>Verfügbar in: <span id="countdown"></span></p>
</body>
</html>
```

### Beispiel 24: Logging

```php
rex_extension::register('MAINTENANCE_ENABLED', function($ep) {
    rex_logger::logNotice('maintenance', 'Wartungsmodus aktiviert von: ' . rex::getUser()->getLogin());
});

rex_extension::register('MAINTENANCE_DISABLED', function($ep) {
    rex_logger::logNotice('maintenance', 'Wartungsmodus deaktiviert von: ' . rex::getUser()->getLogin());
});
```

### Beispiel 25: Cronjob-Integration

```php
// Automatischer Wartungsmodus via Cronjob
class MaintenanceCronjob extends rex_cronjob
{
    public function execute()
    {
        $start = strtotime('2024-12-31 22:00:00');
        $end = strtotime('2024-12-31 02:00:00');
        $now = time();
        
        if ($now >= $start && $now < $end) {
            Maintenance::enable();
            $this->setMessage('Wartungsmodus aktiviert');
        } else {
            Maintenance::disable();
            $this->setMessage('Wartungsmodus deaktiviert');
        }
        
        return true;
    }
    
    public function getTypeName()
    {
        return 'Automatischer Wartungsmodus';
    }
}

// Registrieren
rex_cronjob_manager::registerType('MaintenanceCronjob');
```

**Integration**: YRewrite (Domain-basierte Whitelist), Fragments (maintenance/frontend.php, maintenance/backend.php), Console (maintenance:mode Commands), Extension Points (MAINTENANCE_CHECK, MAINTENANCE_ENABLED, MAINTENANCE_DISABLED, MAINTENANCE_MEDIA_UNBLOCK_LIST), Session-Management (Bypass-Session), 2factor_auth (2FA-Integration), rex_logger (Logging), Cronjob (Automatische Aktivierung/Deaktivierung), IP/Domain-Filtering
