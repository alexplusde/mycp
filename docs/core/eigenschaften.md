# eigenschaften

Quelle: https://redaxo.org/doku/main/eigenschaften

# Eigenschaften

- [rex-Klasse](#rex-klasse)

- [Config-Methoden](#config-methoden)

- [Property-Methoden](#property-methoden)

- [Verwendung eigener Properties in Projekten](#eigene_properties)

- [Beschreibung der Methoden](#beschreibung)

- [getAccesskey](#get-accesskey)

- [getConfig](#get-config)

- [getDirPerm](#get-dir-perm)

- [getErrorEmail](#get-error-email)

- [getFilePerm](#get-file-perm)

- [getProperty](#get-property)

- [getServer](#get-server)

- [getServerName](#get-server-name)

- [getTable](#get-table)

- [getTablePrefix](#get-table-prefix)

- [getTempPrefix](#get-temp-prefix)

- [getUser](#get-user)

- [getVersion](#get-version)

- [hasConfig](#has-config)

- [hasProperty](#has-property)

- [isBackend](#is-backend)

- [isFrontend](#is-frontend)

- [isDebugMode](#is-debug-mode)

- [isSafeMode](#is-safe-mode)

- [isSetup](#is-setup)

- [removeConfig](#remove-config)

- [removeProperty](#remove-property)

- [setConfig](#set-config)

- [setProperty](#set-property)

- [Beispiele](#beispiele)

## "rex"-Klasse

Die Methoden der Klasse `rex` sind global in Templates, Modulen und AddOns verfügbar und ermöglichen Zugriff auf Grundeinstellungen und Zustände des Systems.
Methoden wie `setProperty` und `getProperty` können auch verwendet werden, um systemweit eigene Eigenschaften bereitzustellen.

## Config-Methoden

Die Werte werden in der Tabelle `rex_config` gespeichert.

**

**Hinweis:** AddOns können ihre Konfiguration über das Package-Objekt in die Konfiguration schreiben: `rex_addon::get($addon)->setConfig($key, $value);` und lesen `$value = rex_addon::get($addon)->getConfig($key);` 

## Property-Methoden

Property-Methoden des Cores werden über "rex"-Klasse und über den Namespace des jeweiligen AddOns (z. B. vom Project-AddOn)  bereitgestellt. Die in den Properties gespeicherten Werte werden dynamisch während der Laufzeit verwaltet und werden zur Laufzeit gesetzt und abgerufen. Hierzu zählen auch die Properties, die in den package.yml der AddOns und in der config.yml des Cores hinterlegt sind.

Zur Verwendung der Properties in eigenen Prokjekten, sollten diese im Namespace eines AddOns verwaltet werden. Kollisionen mit den Core-Definitionen und weiteren AddOns werden so vermieden.

## Verwendung eigener Properties in Projekten

Properties sollten in einem eigenen Namespace unabhängig vom Core (rex:) verwendet werden. Es bietet sich an hierzu z. B. das project-AddOn oder ein anderes AddOn zu verwenden. So werden Kollisionen mit anderen AddOns und dem Core vermieden.

Setzen einer AddOn spezifischen Property

`$project = rex_addon::get('project');
$project->setProperty($key, $value);`
``n

Auslesen einer AddOn spezifischen Property

`$project = rex_addon::get('project');
$project->getProperty($key);`
``n

Auslesen über REDAXO-Variablen in Templates und Blöcken

`REX_PROPERTY[namespace=project key=foo]`
``n

**

Möchte man eine Property in einem Template auslesen, die in Blöcken gesetzt wurde, sollte man vorab den Artikel holen. z. B. per `$article='REX_ARTICLE[]';` und dann die Property auslesen.

## Beschreibung der Methoden

### getAccesskey

Beispiel:

`<button type="submit" <?= rex::getAccesskey("speichern","s") ?>>Speichern</button>`
``n

schreibt

`<button type="submit" accesskey="s" title="speichern[s]">Speichern</button>`
``n

in die Ausgabe.

Für den Access-Key können auch Werte aus `config` verwendet werden:
save: s
apply: x
delete: d
add: a

Beispiel:

`<button type="submit" <?= rex::getAccesskey("speichern","save") ?>>Speichern</button>`
``n

schreibt

`<button type="submit" accesskey="s" title="speichern[s]">Speichern</button>`
``n

in die Ausgabe.

### getConfig

Beispiel:

`rex::getConfig('version')` => "5.3"

Siehe auch: [setConfig](#set-config)

### getDirPerm

Liest die Eigenschaft von `dirperm` aus.

Beispiel:
`rex::getDirPerm()` => 755

### getErrorEmail

Gibt die im System eingestellte Error-E-Mail-Adresse aus.

Beispiel:
`rex::getErrorEmail()` => 'info@example.com'

### getFilePerm

Liest die Eigenschaft von `fileperm` aus.

Beispiel:
`rex::getFilePerm()` => 664

### getProperty

Liest die Eigenschaft des Wertes, der zuvor über `setProperty` gespeichert wurde.

Beispiel:
`rex::getProperty('myvar')` => Inhalt des zuvor über `rex::setProperty('myvar',$var)` gespeicherten Wertes.

Die Werte können von einem beliebigen Typ sein. ,z.B.: 

Wenn man weiß, dass ein Array in einem `rex_addon`- oder `rex_config`-Wert existiert, kann man dieses direkt abfragen:

`rex_addon::get('addonname')->getProperty('arrayroot')['key']['subkey']

rex_config::get('key')->getProperty('arrayroot')['key']['subkey']`
``n

Siehe auch: [setProperty](#set-property), [hasProperty](#has-property) und [removeProperty](#remove-property)

### getServer

Liest den Wert aus, der in den Systemeinstellungen im Feld `URL der Website` eingetragen wurde.

Beispiel:
`rex::getServer()` => [http://example.com/](http://example.com/)

Die Methode kann verwendet werden, um absolute URLs zu erstellen.

### getServerName

Liest den Wert aus, der in den Systemeinstellungen im Feld `Name der Website` eingetragen wurde.

Beispiel:
`rex::getServerName()` => "Meine supertolle Website"

Die Methode kann verwendet werden, um den Title-Tag zu füllen.

### getTable

Fügt an einen übergebenen Tabellennamen das in der `config` stehende Prefix für die Datenbanktabellen hinzu.
Standard: `rex_` 

Parameter: Tabellenname

Beispiel:
`rex::getTable('adressen')` => rex_adressen

Die Funktion ist bevorzugt einzusetzen anstelle von `rex::getTablePrefix.'adressen'` 

### getTablePrefix

Liefert den Wert für den in der `config` eingestellten Table Prefix für Datenbanktabellen.
Standard: `rex_` 

Beispiel: `rex::getTablePrefix()` => rex_

Die Methode `rex::getTable()` ist bevorzugt einzusetzen.

### getTempPrefix

Liefert den Wert für den in der `config` eingestellten `temp_prefix` .
Standard: `tmp_` 

Beispiel:
`rex::getTempPrefix()` => tmp_

### getUser

Wenn ein REDAXO Benutzer im Backend angemeldet ist, liefert diese Methode den Benutzer als User-Objekt.

Beispiel:
`rex::getUser()->getName()` => Administrator

**

**Hinweis:** Selbst wenn ein Nutzer angemeldet ist, wird `rex::getUser()` im Frontend nicht automatisch befüllt, sondern erst, wenn es zum ersten Mal explizit angefordert wurde. Im Frontend sollte die Abfrage daher so durchgeführt werden:

`if (rex_backend_login::createUser()) {
    $user = rex::getUser()->getName();
}`
``n

### getVersion

Liefert die installierte Version von REDAXO.

Beispiel:
`rex::getVersion()` => "5.3.0"

`if(rex_string::versionCompare(rex::getVersion(), '5.3.0', '>=')) ...` prüft, ob die REDAXO-Version mindestens 5.3.0 ist.

### hasConfig

Prüft, ob ein Config-Wert gesetzt ist.

Beispiel:
`rex::hasConfig('version')` => true

### hasProperty

Prüft, ob eine Eigenschaft gesetzt ist.

Beispiel:
`rex::hasProperty('myvar')` => true

Siehe auch: [setProperty](#set-property), [getProperty](#get-property) und [removeProperty](#remove-property)

### isBackend

Prüft, ob gerade das Backend aufgerufen wird. Wird oft in Modulen und AddOns verwendet, um die Backend-Ausgabe anders zu gestalten als die Frontend-Ausgabe.

Beispiel:
`rex::isBackend()` => true im Backend, false im Frontend

### isFrontend

Prüft, ob gerade das Frontend aufgerufen wird. Wird oft in Modulen und AddOns verwendet, um die Frontend-Ausgabe anders zu gestalten als die Backend-Ausgabe.

Beispiel:
`rex::isFrontend()` => true im Frontend, false im Backend

### isDebugMode

Prüft, ob der DebugMode in den Systemeinstellungen aktiviert ist.

Beispiel:
`rex::isDebugMode()` => true oder false

### isSafeMode

Prüft, ob der SafeMode des Systems aktiviert ist. Im SafeMode sind AddOns deaktiviert.

Beispiel:
`rex::isSafeMode()` => true oder false

### isSetup

Prüft, ob sich das System im Setup-Modus befindet. Der Wert kann in den Systemeinstellungen auf `true` gesetzt werden, was nur sehr, sehr ausnahmsweise notwendig sein sollte ...

Beispiel:
`rex::isSetup()` => normalerweise false

### removeConfig

Eine Config-Einstellung löschen.

Beispiel:
`rex::removeConfig('ein_konf_wert')` 

Siehe auch: [getConfig](#get-config), [setConfig](#set-config) und [hasConfig](#has-config)

### removeProperty

Eine Eigenschaft löschen.

Beispiel:
`rex::removeProperty('myvar')` 

Siehe auch: [getProperty](#get-property), [hasProperty](#has-property) und [setProperty](#set-property)

### setConfig

Eine Config-Einstellung setzen.

Beispiel: `rex::setConfig('ein_konf_name','der_konf_value')` 

Siehe auch: [getConfig](#get-config), [removeConfig](#remove-config) und [hasConfig](#has-config)

### setProperty

Eine Eigenschaft setzen.

Beispiel:
`rex::setProperty('myvar','myval')` 

Siehe auch: [getProperty](#get-property), [hasProperty](#has-property) und [removeProperty](#remove-property)

Siehe auch [Konfiguration](/doku/main/konfiguration)

## Beispiele

### Informationen aus Artikel im Template auslesen

Über Properties die im Namespace eines AddOns hinterlegt sind, lassen sich kann man Properties die in  Modulen gesetzt wurden in Templates auslesen. Hierzu ist es erforderlich vor Abfrage der Variable den Artikel einzulesen, z. B. mittles `$this->getArticle();` oder `REX_ARTICLE[]` .

Im gewünschten Modul wird mit

`$project = rex_addon::get('project');
$project->setProperty('key',"wert")``
``n

die gewünschte Information im project-AddOn hinterlegt.

Danach kann der Inhalt der Variable im Template ausgelesen werden

***Ausgabe im Template***

`$article = $this->getArticle();
$project = rex_addon::get('project');

// ist eine Property gesetzt?
if ($project->getProperty('key') != "") {
echo '<title>'.rex_escape($project->getProperty('key')).'</title>';
}
// sonst:
else {
echo '<title>'. rex_escape($this->getValue('name')).'</title>';
}`
``n
                
                            [**Artikel bearbeiten](https://github.com/redaxo/docs/edit/main/eigenschaften.md)
