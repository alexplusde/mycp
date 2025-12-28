# addon-package

Quelle: https://redaxo.org/doku/main/addon-package

# Package (package.yml)

- [Beispiel einer package.yml](#beispiel)

- [Schema](#schema)   

- [Die package.yml definiert das AddOn oder PlugIn](#ueber)

- [Pflichtangaben](#pflicht)

- [Empfohlene Angaben](#empfohlen)

- [Abhängigkeiten (requires:)](#requires)

- [Default Settings setzen (default_config:)](#defaults)

- [Konflikte (conflicts:)](#conflicts)

- [Dateien/Ordner ignorieren](#ignore)

- [Seiten (page: / subpages:)](#seiten)

- [Mehrere Seiten in der Hauptnavigation](#pages-main)

- [Seiten verstecken](#hidden)

- [Seiten ohne Layout ausgeben](#haslayout)

- [Eigener Bereich in der Redaxo Navigation (block:)](#block)

- [Rechte (perm:)](#rechte)

- [Übersetzung](#uebersetzung)

- [Eigene Properties](#eigene)

- [Properties der package.yml live überschreiben](#prop_overwrite)

- [PJAX deaktivieren](#pjax)

- [PlugIn](#plugin)

## Beispiel einer package.yml

`package: meinaddon
version: '1.0.0'
author: Rex Red
supportpage: https://meinesupportseite.tld
page:
    title: 'translate:Mein AddOn'
    perm: meinaddon[]
    pjax: false
    icon: rex-icon fa-television
    subpages:
        main:  
             title: 'translate:main'
             icon: rex-icon fa-television
        help:  
             title: 'translate:help'
             icon: rex-icon fa-help
             subPath: README.md
        module:
             title: 'translate:module'
             perm: admin
default_config:
    key: 'value'
    key2: false
requires:
    redaxo: '^5.1'
    php:
        version: '^7.1'
        extensions: [gd, intl]
    packages:
        media_manager: '^2.0.1'
        addonname/pluginname: '^2.4.6'
conflicts:
    packages:
        irgendein_addon: '>=1.0.0'`
``n

## Schema

Die ausführliche Schema-Definition auf [GitHub](https://github.com/redaxo/redaxo/blob/main/redaxo/src/core/schemas/package.json)

## Die package.yml definiert das AddOn oder PlugIn

In der package.yml werden alle nötigen Einstellungen und Informationen hinterlegt (das Package), damit das AddOn oder PlugIn korrekt von REDAXO gefunden und ausgeführt werden kann.
Die verwendete Sprache ist das auf Markup verzichtende YAML.

**

In YAML werden keine Tabs unterstützt. Die Einrückungen müssen mit Leerzeichen realisiert werden.

Die Definition erfolgt in Schlüssel-Wert-Paaren (key value pairs). Das Trennzeichen zwischen Schlüssel und Wert ist der Doppelpunkt. Die Zugehörigkeit zu Oberpunkten wird durch Einrückungen (per Leerzeichen) definiert.

Diese Definitionen heißen in REDAXO *Properties* und können mit `rex_addon::get('addonkey')->getProperty($key)` abgefragt werden.

## Pflichtangaben

Die nachfolgenden Felder sind die einzigen Pflichtfelder in der package.yml. Diese reichen aus, um ein (funktionsloses) AddOn zu erstellen.

`package: meinaddon
version: '1.0.0'`
``n

**package:** Hier wird der AddOnkey hinterlegt. Dieser sollte eindeutig und unverwechselbar sein, darf nur aus Buchstaben, _ (Unterstrich) und Zahlen bestehen. Damit es nicht zu Konflikten mit anderen AddOns gleicher Bezeichnung kommt, sollte man den AddOn-Key in [MyREDAXO](https://redaxo.org/myredaxo/login/) registrieren.

**version:** Hier wird die Version des AddOns hinterlegt. Damit der Installer die Versionen korrekt zuordnen kann, müssen die folgenden Vorgaben entsprechend [Composer](https://getcomposer.org/doc/articles/versions.md) eingehalten werden.

**

Um Probleme mit neuen PHP Major-Releases zu vermeiden, empfehlen wir die Angabe zur gewünschten PHP-Version zu hinterlegen. ^7.1 steht hierbei für `>= 7.1 < 8`

## Empfohlene Angaben

Damit die Nutzer erfahren, wer das AddOn geschrieben hat und wo man Support erhält, sollte man die Informationen zu Autor und Supportseite hinterlegen.

`author: Rex Red
supportpage: https://meinesupportseite.tld`
``n

## Abhängigkeiten (requires:)

Im AddOn sollte man festlegen, welche Umgebung es erwartet oder gar benötigt. Hierzu zählen:

- die erforderliche REDAXO-Version

- erforderliche AddOns und PlugIns, auf denen das AddOn ggf. aufbaut oder deren Funktionen es nutzt.

- die erwartete PHP-Version

- erforderliche PHP-Extensions

Werden diese Bedingungen nicht erfüllt, ist eine Installation nicht möglich.

**Beispiel:**

`requires:
    redaxo: '^5.1'
    packages:
        media_manager: '^2.0.1'
        addonname/pluginname: '^2.4.6'
    php:
        version: '>=5.6'
        extensions: [gd, xml]`
``n

Abhängigkeiten werden eingeleitet mit `requires:`.

Darunter eingerückt werden die Subkeys, hier: `redaxo`, `packages`, `php`; `packages` und `php` haben wiederum eigene Subkeys.

Hier wird *mindestens REDAXO 5.1* vorausgesetzt. `^` drückt aus, dass es sich auf das aktuelle Major-Release bezieht. Das heißt, eine Installation in einem REDAXO 6 wäre nicht möglich. Dies gilt ebenso für den Media Manager, der mindestens in Version 2.0.1 vorliegen muss. PHP dagegen muss nur höher oder gleich 5.6 sein. Hier gilt nicht die Begrenzung auf die Major-Release, sodass eine Installation unter PHP 7 möglich ist. "`addonname/pluginname: '^2.4'`" prüft, ob ein bestimmtes PlugIn vorhanden ist.

## Default settings (default_config)

In der package.yml können Default-Settings gesetzt werden, sodass diese direkt nach der Installation und Update zur Verfügung stehen. Diese Lösung ist eine Alternative zur PHP-Variante `$addon->setConfig('key', 'value')`, die bislang in der boot.php, install.php und update.php Verwendung fand.

`default_config:
    key: 'value'
    key2: false`
``n

## Konflikte (conflicts:)

Manchmal vertragen sich einige AddOns nicht miteinander, weil sie die gleichen Bibliotheken mitbringen – oder es liegt einfach eine Umgebung vor, die zu Problemen führen kann. Dann sollte vor der Installation geprüft werden, ob ein Konflikt vorliegt. Die Definition ist identisch mit `requires:` , wird jedoch durch `conflicts:` eingeleitet.

`conflicts:
    packages:
        irgendein_addon: '>=1.0.0'`
``n

Wird die Version größer/gleich 1.0.0 des genannten AddOns gefunden, bricht die Installation ab.

## Dateien/Ordner ignorieren

Bei der Erstellung des Installationspaketes können ausgewählte Dateien und Ordner ignoriert werden

`installer_ignore:

    - node_modules
    - .env
`
``n

**

Das ignore-Pattern greift nur auf der Root-Ebene des AddOns und arbeitet nicht rekursiv. Dementsprechend sind auch keine Patterns möglich wie assets/css/* oder source/js.

## Seiten (page: / subpages:)

Die Hauptseite wird über die Property `page` definiert. Diese wird aufgerufen, wenn man auf den Menüpunkt des AddOns klickt.

Jede Seite erhält einen Titel mit dem Key `title`.

`page:
    title: 'translate:title'`
``n

Der in der Hauptseite hinterlegte Titel ist zugleich die Bezeichnung für den Menüpunkt.

Für den Menüpunkt des AddOns kann ein Icon aus Font-Awsome festgelegt werden. Für die korrekte Darstellung sollte die CSS-Klasse des Icons immer in Kombination mit `rex-icon` angegeben werden:

`page:
    title: 'translate:title'
    icon: rex-icon fa-television`
``n

Will man die Hauptseite in **Unterseiten** unterteilen, werden diese mithilfe des Keys `subpages` eingeleitet. Danach folgen eingerückt frei wählbare Properties für die einzelnen Unterseiten.

`subpages:
    main:  
        title: 'translate:main'
        icon: rex-icon fa-television
    help:  
        title: 'translate:help'
        subPath: README.md
        icon: rex-icon fa-help
    module:
        title: 'translate:module'
        perm: admin`
``n

Die einzelnen Tabs der Seiten können auch mit Icons versehen werden.

**Die Seiten müssen im Ordner `/pages` als php-Dateien vorliegen.** (hier: `main.php` , `help.php` , `module.php` ).
Die Hauptseite ist die `index.php` im /pages-Ordner.

### Mehrere Seiten in der Navigationsleiste

Benötigt man mehrere Seiten direkt in der Navigationsleiste, lässt sich das auch über die `packages.yml` steuern.
Aus dem Key  `page` wird  `pages` und jede Seite muss um das Property  `main: 'true'` ergänzt werden. Außerdem bekommt jede Seite einen eigenen Key (z.B. myfirstpage).  Zu beachten ist auch, dass nun nicht mehr die index.php aufgerufen wird, sondern die Datei mit dem Namen des Keys (z.B. myfirstpage.php).

`pages:
  myfirstpage:
    title: 'translate:title-firstpage'
    main: true
    icon: rex-icon fa-user
  mysecondpage:
    title: 'translate:title-secondpage'
    main: true
    icon: rex-icon fa-group`
``n

### Seiten verstecken

Manchmal benötigt man Seiten, die nicht über die Navigation erreichbar sind. Hierzu steht der Parameter `hidden` zur Verfügung; mit `true` oder `false` wird die Sichtbarkeit gesteuert:

`seitenkey: { title: 'translate:seitenname', hidden: true}`
``n

Auch der eigentliche Menüpunkt des AddOns kann so versteckt werden.

### Seiten nicht im REDAXO-Layout ausgeben

Möchte man die Seite im eigenen Design ausgeben (z. B. in einem Popup) oder man benötigt eine Ausgabe nicht im HTML-Format (z. B. für JSON, TXT, YML) hilft folgender Code in der Seiten-Definiton.

`hasLayout: false` 

## Ein eigener Abschnitt in der Navigationsleiste (block:)

Soll die eigene AddOn-Seite nicht wie üblich unter `AddOns`, sondern in einem eigenen Abschnitt aufgeführt werden, löst man das über den Key `block`. Das funktioniert auch Addon-übergreifend und man kann mehrere Seiten aus mehreren AddOns in einem eigenen Abschintt organisieren.

`page:
    title: 'translate:title'
    icon: rex-icon fa-television
    block: 'translate:myOwnBlock'`
``n

## Rechte (perm:)

In der package.yml können auch Rechte für Benutzer festgelegt und abgefragt werden.

Möchte man z. B. nur Admins die Nutzung des AddOns gestatten, so fügt man der `page` -Definition `perm: admin` hinzu.
Möchte man das nur auf eine Unterseite beziehen, legt man den Key in der Definition der entsprechenden Unterseite ab.

Oftmals reicht die Festlegung auf den Admin nicht und man möchte eine ausgefeiltere Rechte-Vergabe definieren. (Beispiel: der Redakteur darf Daten einpflegen, aber nicht löschen.)

Daher legt man am besten ein eigenes Recht an.
Hierzu bietet sich der Hauptbereich der package.yml an.

Damit die Rechte später leicht identifiziert werden können, sollten diese den AddOnkey wiederspiegeln.

z. B.: `perm: meinaddon[]` 

Wird dieser Key angelegt, ist das Recht in der Benutzerverwaltung auswählbar. Weitere, davon abgeleitete Rechte können durch einen zusätzlichen key in den Klammern definiert werden.

z. B: `perm: meinaddon[delete]` 

Die Rechte können dann im AddOn per PHP abgefragt werden:

`rex::getUser()->hasPerm('meinaddon[delete]')`
``n

## Übersetzung

Mit `translate:` beginnende Werte werden anhand der Sprachdatei übersetzt. Der AddOn-Präfix (hier z. B. `meinaddon_` ) kann in den Lang-Files (den Sprachdateien) des AddOns weggelassen werden.

## Eigene Properties

Die package.yml ist sehr offen gestaltet. Daher kann man auch eigene Properties in ihr ablegen.
Der Abruf erfolgt wie oben gezeigt per `rex_addon::get('addonkey')->getProperty($eigenerkey)` .

## Properties der package.yml live überschreiben

Die in der package.yml eines AddOns hinterlegten Properties können zur Laufzeit überschrieben werden. 

**Beispiel: Änderung der Paginierung der Struktur**

Folgernder Code in z.B. der boot.php des project-AddOns bewirkt eine Änderung der Paginierung von default 50 auf 100: 

`rex_addon::get('structure')->setProperty('rows_per_page', 100);`
``n

## PJAX deaktivieren

Möchte man PJAX auf den Seiten des AddOns nutzen, kann man dies per `pjax: true` erreichen.

`page:
    title: 'translate:Mein AddOn'
    perm: meinaddon[]
    pjax: true
    icon: rex-icon fa-television`
``n

## PlugIn

PlugIns unterscheiden sich von AddOns nur durch ihre Definition im Value des Keys `package` in der Datei `package.yml` .

`package: meinaddon/meinplugin`
``n

Die Seiten eines PlugIns werden dem AddOn automatisch hinzugefügt.
                [**Artikel bearbeiten](https://github.com/redaxo/docs/edit/main/addon-package.md)
