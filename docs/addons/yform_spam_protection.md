# YForm Spam Protection - Keywords: Spam, Bot-Schutz, Honeypot, Timer, IP-Sperre, reCAPTCHA, Formular-Schutz, DSGVO

## Übersicht

**YForm Spam Protection** kombiniert verschiedene Maßnahmen gegen Spam und Bots für YForm-Formulare. Die Lösung ist barrierefrei, DSGVO-konform, benötigt keine Benutzereingaben und ist in unter 5 Minuten eingerichtet.

**Autor:** Friends Of REDAXO / Alexander Walther  
**GitHub:** <https://github.com/alexplusde/yform_spam_protection>  
**Abhängigkeiten:** YForm >= 4.0  
**Optional:** StopForumSpam-API, reCAPTCHA-Plugin

---

## YForm-Field

| Feldname | Beschreibung |
|----------|--------------|
| `spam_protection` | Validierungs-Feld mit Honeypot, Timer und IP-Checks |

---

## Schutz-Mechanismen

| Mechanismus | Beschreibung |
|-------------|--------------|
| **Timer (Session)** | Prüft Zeit zwischen Seiten-Aufruf und Submit |
| **Timer (Formular)** | Prüft Zeit zwischen Formular-Laden und Submit |
| **IP-Sperre** | Blockiert IP nach zu vielen Anfragen |
| **Honeypot** | Verstecktes Feld, das Bots ausfüllen |
| **JavaScript-Check** | Prüft, ob JavaScript aktiviert ist |
| **StopForumSpam** | Externe Spam-IP-Datenbank (optional) |

---

## Konfiguration

| Config-Key | Typ | Beschreibung | Default |
|------------|-----|--------------|---------|
| `timer_session` | int | Mindestzeit (Sek.) zwischen Seiten-Aufruf und Submit | `5` |
| `timer_form` | int | Mindestzeit (Sek.) zwischen Formular-Laden und Submit | `3` |
| `ip_block_limit` | int | Max. Anfragen pro IP im Zeitfenster | `5` |
| `ip_block_timer` | int | Zeitfenster (Sek.) für IP-Limit | `300` (5 Min) |
| `use_stopforumspam` | bool | StopForumSpam-API aktivieren | `false` |
| `ip_whitelist` | string | Komma-getrennte IPs (Whitelist) | `''` |
| `ignore_user` | bool | Eingeloggte Backend-User ignorieren | `true` |

---

## Datenbank-Tabelle

### rex_tmp_yform_spam_protection_frequency

| Spalte | Typ | Beschreibung |
|--------|-----|--------------|
| `ipv4` | int(10) unsigned | IPv4-Adresse (INET_ATON) |
| `ipv6` | varbinary(16) | IPv6-Adresse |
| `createdate` | datetime | Zeitstempel der Anfrage |
| `was_blocked` | bit(1) | Wurde Anfrage blockiert? |

**Auto-Cleanup:** Einträge älter als `ip_block_timer` werden automatisch gelöscht.

---

## 25 Praxisbeispiele

### 1. YForm-Field einbinden (PHP)

```php
$yform = new rex_yform();
$yform->setValueField('spam_protection', [
    'honeypot', 
    'Bitte nicht ausfüllen.', 
    'Ihre Anfrage wurde als Spam erkannt.', 
    0 // Debug-Modus (0 = aus, 1 = an)
]);
```

### 2. YForm-Field einbinden (Pipe)

```
spam_protection|honeypot|Bitte nicht ausfüllen|Ihre Anfrage wurde als Spam erkannt.|0
```

### 3. Debug-Modus aktivieren

```
spam_protection|honeypot|Label|Fehlermeldung|1
```

### 4. Mehrere Formulare auf einer Seite

```php
// Formular 1
$yform1 = new rex_yform();
$yform1->setObjectparams('form_name', 'kontakt_formular');
$yform1->setValueField('spam_protection', ['honeypot', 'Label', 'Fehler', 0]);

// Formular 2
$yform2 = new rex_yform();
$yform2->setObjectparams('form_name', 'newsletter_formular');
$yform2->setValueField('spam_protection', ['honeypot', 'Label', 'Fehler', 0]);
```

### 5. Eindeutiger Formular-Name (Pipe)

```
objparams|form_name|zweites_formular
spam_protection|honeypot|Bitte nicht ausfüllen|Fehlermeldung|0
```

### 6. Session-Timer anpassen

```php
rex_config::set('yform_spam_protection', 'timer_session', 10);
// Mindestens 10 Sekunden zwischen Aufruf und Submit
```

### 7. Formular-Timer anpassen

```php
rex_config::set('yform_spam_protection', 'timer_form', 5);
// Mindestens 5 Sekunden zwischen Formular-Laden und Submit
```

### 8. IP-Limit erhöhen

```php
rex_config::set('yform_spam_protection', 'ip_block_limit', 10);
// Erlaubt 10 Anfragen statt 5
```

### 9. IP-Zeitfenster verlängern

```php
rex_config::set('yform_spam_protection', 'ip_block_timer', 600);
// 10 Minuten statt 5 Minuten
```

### 10. IP-Whitelist setzen

```php
rex_config::set('yform_spam_protection', 'ip_whitelist', '192.168.1.100,10.0.0.1');
```

### 11. Backend-User vom Spam-Schutz ausnehmen

```php
rex_config::set('yform_spam_protection', 'ignore_user', true);
// Eingeloggte Backend-User werden nicht geprüft
```

### 12. StopForumSpam aktivieren

```php
rex_config::set('yform_spam_protection', 'use_stopforumspam', true);
// Prüft IP gegen externe Spam-Datenbank
```

### 13. Honeypot-Label anpassen

```php
$yform->setValueField('spam_protection', [
    'honeypot', 
    'Falls Sie ein Mensch sind, lassen Sie dieses Feld leer.', 
    'Spam erkannt!', 
    0
]);
```

### 14. Custom Fehlermeldung

```php
$yform->setValueField('spam_protection', [
    'honeypot', 
    'Bitte nicht ausfüllen.', 
    'Ihre Anfrage wurde als Spam erkannt. Bitte versuchen Sie es in einigen Minuten erneut.', 
    0
]);
```

### 15. Mehrsprachige Fehlermeldung (Sprog)

```php
// Mit Sprog-Platzhaltern
$yform->setValueField('spam_protection', [
    'honeypot', 
    '{{ spam_protection_label }}', 
    '{{ spam_protection_error }}', 
    0
]);
```

### 16. Debug-Log im Frontend (mit dump)

```
spam_protection|honeypot|Label|Fehler|1
```

**Output (bei aktivem Debug):**

```
[
    "session-microtime eingehalten: 1234567890.123 + 5 > 1234567895.456",
    "formular-microtime eingehalten: 1234567890.123 + 3 > 1234567893.456",
    "honeypot wurde nicht ausgefüllt"
]
```

### 17. IP-Blockierung in Datenbank prüfen

```php
$sql = rex_sql::factory();
$count = $sql->getArray(
    'SELECT COUNT(*) as count FROM rex_tmp_yform_spam_protection_frequency 
     WHERE ipv4 = INET_ATON(:ip)', 
    [':ip' => $_SERVER['REMOTE_ADDR']]
)[0]['count'];

echo "Diese IP hat $count Anfragen im Zeitfenster.";
```

### 18. Alle blockierten IPs anzeigen

```php
$sql = rex_sql::factory();
$blocked = $sql->getArray(
    'SELECT INET_NTOA(ipv4) as ip, COUNT(*) as count 
     FROM rex_tmp_yform_spam_protection_frequency 
     WHERE was_blocked = 1 
     GROUP BY ipv4'
);

foreach ($blocked as $entry) {
    echo "IP {$entry['ip']}: {$entry['count']} blockierte Anfragen<br>";
}
```

### 19. Alte Einträge manuell löschen

```php
$timer = rex_config::get('yform_spam_protection', 'ip_block_timer', 300);
$sql = rex_sql::factory();
$sql->setQuery(
    'DELETE FROM rex_tmp_yform_spam_protection_frequency 
     WHERE createdate < (NOW() - INTERVAL ' . $timer . ' SECOND)'
);
```

### 20. StopForumSpam-Prüfung testen

```php
// Manuelle API-Anfrage
$ip = $_SERVER['REMOTE_ADDR'];
$result = file_get_contents('http://api.stopforumspam.org/api?ip=' . $ip);

$doc = new DOMDocument();
$doc->loadXML($result);
$appears = $doc->getElementsByTagName('appears')[0]->nodeValue;

if ($appears == 'yes') {
    echo "IP ist in StopForumSpam-Datenbank gesperrt!";
}
```

### 21. Backend-Test: Timer-Werte erhöhen

```php
// Im Backend unter YForm → Spamschutz → Erweiterte Einstellungen
rex_config::set('yform_spam_protection', 'timer_session', 30);
rex_config::set('yform_spam_protection', 'timer_form', 30);
// Jetzt 30 Sekunden warten, um Formular zu testen
```

### 22. Custom Template für Honeypot

```php
// ytemplates/custom/value.spam_protection.tpl.php
<div id="<?= $this->getHTMLId() ?>" style="display:none;">
    <label for="<?= $this->getFieldId() ?>"><?= $this->getLabel() ?></label>
    <input id="<?= $this->getFieldId() ?>" 
           name="<?= $this->getFieldId() ?>" 
           type="email" 
           autocomplete="off" 
           tabindex="-1">
    <input id="<?= $this->getFieldId() ?>_microtime" 
           name="<?= $this->getFieldId() ?>_microtime" 
           type="hidden" 
           value="<?= microtime(true) ?>">
    <input id="<?= $this->getFieldId() ?>_js_enabled" 
           name="<?= $this->getFieldId() ?>_js_enabled" 
           type="hidden" 
           value="0">
</div>
<script nonce="<?= rex_response::getNonce() ?>">
    document.getElementById("<?= $this->getFieldId() ?>_js_enabled").value = 
        new Date().getFullYear();
</script>
```

### 23. Extension Point: Custom Spam-Check

```php
// boot.php
rex_extension::register('YFORM_DATA_ADDED', function($ep) {
    $params = $ep->getParams();
    $form = $params['form'];
    
    // Custom Spam-Check
    if (strpos($form->getValue('nachricht'), 'spam-keyword') !== false) {
        rex_logger::factory()->log('warning', 'Spam detected in form', [], __FILE__, __LINE__);
    }
});
```

### 24. Monitoring: Spam-Statistik

```php
$sql = rex_sql::factory();
$stats = $sql->getArray(
    'SELECT 
        DATE(createdate) as date,
        COUNT(*) as total,
        SUM(was_blocked) as blocked
     FROM rex_tmp_yform_spam_protection_frequency 
     GROUP BY DATE(createdate) 
     ORDER BY date DESC 
     LIMIT 7'
);

foreach ($stats as $day) {
    echo "{$day['date']}: {$day['total']} Anfragen, {$day['blocked']} blockiert<br>";
}
```

### 25. Deinstallation (Cleanup)

```php
// Wird automatisch ausgeführt
rex_sql_table::get(rex::getTable('tmp_yform_spam_protection_frequency'))->drop();
rex_config::removeNamespace('yform_spam_protection');
```

---

## Funktionsweise

### Timer (Session)

Beim ersten Seiten-Aufruf wird ein Session-Timestamp gespeichert. Wird das Formular vor Ablauf der `timer_session`-Zeit abgeschickt, schlägt die Validierung fehl.

**Beispiel:** `timer_session = 5` → Mindestens 5 Sekunden zwischen Seiten-Aufruf und Submit

### Timer (Formular)

Beim Laden des Formulars wird per JavaScript ein Microtime-Wert in ein Hidden Field geschrieben. Wird das Formular vor Ablauf der `timer_form`-Zeit abgeschickt, schlägt die Validierung fehl.

**Beispiel:** `timer_form = 3` → Mindestens 3 Sekunden zwischen Formular-Laden und Submit

### IP-Sperre

Jede Anfrage wird mit IP-Adresse (IPv4/IPv6) in der Datenbank gespeichert. Überschreitet eine IP das `ip_block_limit` im `ip_block_timer`-Zeitfenster, werden weitere Anfragen blockiert.

**Beispiel:** `ip_block_limit = 5`, `ip_block_timer = 300` → Max. 5 Anfragen in 5 Minuten

**Auto-Cleanup:** Einträge älter als `ip_block_timer` werden automatisch gelöscht.

### Honeypot

Ein für Menschen per CSS verstecktes Eingabefeld wird dem Formular hinzugefügt. Spambots füllen häufig alle Felder aus. Wird das Honeypot-Feld ausgefüllt, schlägt die Validierung fehl.

**Barrierefreiheit:**

- `autocomplete="off"` verhindert versehentliches Ausfüllen
- `tabindex="-1"` entfernt Feld aus Tab-Reihenfolge
- `aria-hidden="true"` versteckt Feld für Screenreader

### JavaScript-Check

Per JavaScript wird das aktuelle Jahr in ein Hidden Field geschrieben. Fehlt dieser Wert (JavaScript deaktiviert), kann optional eine Warnung ausgegeben werden.

**Hinweis:** Aktuell nur für Monitoring, keine automatische Ablehnung.

### StopForumSpam

Externe API-Anfrage an `http://api.stopforumspam.org/api?ip=...` prüft, ob die IP in der Spam-Datenbank gelistet ist. Bei Treffer schlägt die Validierung fehl.

**Wichtig:** Externe Anfrage → DSGVO-Prüfung erforderlich!

---

## Backend-Einstellungen

**YForm → Spamschutz → Einstellungen**

1. **Basis-Einstellungen**
   - Fehlermeldung (derzeit disabled)

2. **Checks**
   - Honeypot (aktiviert)
   - IP-Blockierung (aktiviert)

3. **Erweiterte Einstellungen**
   - Session-Timer (Sekunden)
   - Formular-Timer (Sekunden)
   - IP-Block-Limit (Anzahl)
   - IP-Block-Zeitfenster (Sekunden)
   - StopForumSpam (aktivieren/deaktivieren)
   - IP-Whitelist (komma-getrennt)
   - Backend-User ignorieren (ja/nein)

---

## DSGVO-Hinweise

### Standard-Konfiguration (DSGVO-konform)

- IP-Adressen werden temporär gespeichert
- Automatische Löschung nach `ip_block_timer`
- Keine externen Dienste

### Mit StopForumSpam (DSGVO-Prüfung erforderlich!)

- Externe API-Anfrage an stopforumspam.org
- IP-Adresse wird übermittelt
- Datenschutzerklärung anpassen
- ggf. Einwilligung einholen

---

## Fehlersuche

### "session-microtime nicht eingehalten" trotz Wartezeit

**Ursache:** Formular wird mehrmals im Template ausgegeben (z.B. `REX_ARTICLE[]` mehrfach)

**Lösung:**

```php
// Nur einmal pro Seite
echo $this->getArticle(1, 1); 

// NICHT:
echo REX_ARTICLE[1];
echo REX_ARTICLE[1]; // 2x = Problem!
```

### Honeypot wird von echten Nutzern ausgefüllt

**Ursache:** CSS-Styling funktioniert nicht, Feld ist sichtbar

**Lösung:** Prüfe CSS-Einbindung oder nutze Custom Template

### IP-Sperre greift trotz Whitelist

**Ursache:** IP-Format falsch oder Leerzeichen

**Lösung:**

```php
// Richtig:
rex_config::set('yform_spam_protection', 'ip_whitelist', '192.168.1.1,10.0.0.1');

// Falsch:
rex_config::set('yform_spam_protection', 'ip_whitelist', '192.168.1.1, 10.0.0.1'); // Leerzeichen!
```

---

## Templates

**Bootstrap:** `ytemplates/bootstrap/value.spam_protection.tpl.php`  
**Classic:** `ytemplates/classic/value.spam_protection.tpl.php`

Beide Templates enthalten:

- Honeypot-Feld (per CSS versteckt)
- Microtime-Hidden-Field
- JavaScript-Check
- Nonce-Support für CSP

---

## Hinweise

⚠️ **Mehrere Formulare:** Unbedingt eindeutige `form_name` vergeben!

⚠️ **Debug-Modus:** Nur für Entwicklung aktivieren, nicht im Live-Betrieb

⚠️ **Timer-Werte:** Zu niedrige Werte (< 3 Sek) können echte User blockieren

⚠️ **StopForumSpam:** DSGVO-Prüfung erforderlich bei Nutzung externer API

⚠️ **IP-Speicherung:** In Datenschutzerklärung erwähnen

---

## Verwandte Addons

- [YForm](yform.md) - Formular-Framework (Basis)
- [Sprog](sprog.md) - Mehrsprachige Fehlermeldungen (optional)

---

**GitHub:** <https://github.com/alexplusde/yform_spam_protection>
