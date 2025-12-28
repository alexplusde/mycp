# file

Quelle: https://redaxo.org/doku/main/file

# File-Handling

- [Einleitung](#einleitung)

- [rex_file](#rexfile)

- [get](#rexfile_get)

- [getConfig](#rexfile_getConfig)

- [getCache](#rexfile_getCache)

- [put](#rexfile_put)

- [append](#rexfile_append)

- [putConfig](#rexfile_putConfig)

- [putCache](#rexfile_putCache)

- [copy](#rexfile_copy)

- [move](#rexfile_move)

- [delete](#rexfile_delete)

- [extension](#rexfile_extension)

- [mimeType](#rexfile_mimeType)

- [formattedSize](#rexfile_formattedSize)

- [getOutput](#rexfile_getOutput)

- [rex_dir](#dir)

- [create](#create)

- [isWritable](#isWritable)

- [copy](#copy)

- [delete](#delete)

- [deleteFiles](#deleteFiles)

## Einleitung

Für die Erstellung und Pflege von Dateien und Verzeichnissen stehen die PHP-Classes `rex_file` und `rex_dir` zur Verfügung. Nachfolgend werden die Aufgaben der darin enthaltenen Methoden gelistet.

In den Methoden müssen korrekte Pfade angegeben werden. Im Kapitel [Pfade (rex_path, rex_url)](/doku/main/pfade) finden sich dazu alle erforderlichen Informationen.

## rex_file

Die Class `rex_file` kümmert sich um das Handling einzelner Dateien. Hier stehen Methoden zum Einlesen, Schreiben und zur Ausgabe von Dateien aus und im Dateisystem zur Verfügung.

[Quellcode auf GitHub](https://github.com/redaxo/redaxo/blob/main/redaxo/src/core/lib/util/file.php)

### rex_file::get

Mit der Methode `get` wird eine Datei aus dem Dateisystem eingelesen. Ein weiterer Parameter erlaubt die Ausgabe eines Default-Wertes bzw. Fehlermeldung, wenn die Datei nicht gelesen werden kann (default: NULL).

`rex_file::get($file, $default = null);`
``n

Beispiel:

`$data = rex_file::get(rex_path::frontend('/assets/styles.css'),'not available');`
``n

### rex_file::getConfig

Mit der Methode `getConfig` kann eine Config-Datei eingelesen werden. Kann die Datei nicht gelesen werden, kann ein Default-Wert zurückgegeben werden (default: NULL).  

**

Diese Methode wird hauptsächlich vom Core verwendet. AddOns sollten auf die Möglichkeiten der package.yml, Properties und rex_config zurückgreifen.

`rex_file::getConfig($file, $default = []);`
``n

Beispiel: Einlesen der REDAXO Config

`$config = rex_file::getConfig('config.yml');`
``n

### rex_file::getCache

Mit der Methode `getCache` wird eine Datei aus dem Cache eingelesen. Ein weiterer Parameter erlaubt die Ausgabe eines Default-Wertes bzw. Fehlermedlung (wenn nicht festgelegt NULL), wenn die Datei nicht gelesen werden kann.  

`rex_file::getCache($file, $default = []);`
``n

Beispiel:

`echo (rex_file::getCache(rex_path::addonCache('meinaddon').'blindtext.txt'));`
``n

### rex_file::put

Die Methode `put` schreibt Content in eine Datei. Existiert die Datei noch nicht, wird sie erstellt. Die Rückgabe bei Erfolg ist TRUE, sonst FALSE. Vorhandene Inhalte der Datei werden überschrieben.  

`rex_file::put($file, $content);`
``n

Beispiel:

`$css = 'body { background: #eee;}
p { line-height: 1.2em;}
';
$success = rex_file::put(rex_path::frontend('/assets/new_styles.css'),$css);`
``n

### rex_file::append

Die Methode `append` schreibt Content an das Ende einer Datei. Existiert die Datei noch nicht, wird sie erstellt. Die Rückgabe bei Erfolg ist TRUE, sonst FALSE. Es kann ein individueller Trenner definiert werden, der Standard ist leer.  

`rex_file::append($file, $content, $delimiter = '');`
``n

Beispiel: 

`$file = "meine_datei.txt";
$content = "Neuer Inhalt";
$delimiter = "\n"; // Optional: Trennzeichen, z.B. Zeilenumbruch

if (rex_file::append($file, $content, $delimiter)) {
    echo "Inhalt erfolgreich hinzugefügt.";
} else {
    echo "Fehler beim Hinzufügen des Inhalts.";
}`
``n

### rex_file::putConfig

Die Methode `putConfig` schreibt Konfigurationsdaten in eine Config-Datei. Die Rückgabe bei Erfolg ist TRUE, sonst FALSE.

**

Diese Methode wird hauptsächlich vom Core verwendet. AddOns sollten auf die Möglichkeiten der package.yml, Properties und rex_config zurückgreifen.

`rex_file::putConfig($file, $content);`
``n

### rex_file::putCache

Die Methode `putCache` schreibt Daten in den Cache. Bei Erfolg TRUE, sonst FALSE.

`rex_file::putCache($file, $content);`
``n

Beispiel:

`$content = '
Dies ist ein Typoblindtext. An ihm kann man sehen, ob alle Buchstaben da sind und wie sie aussehen.
';
rex_file::putCache(rex_path::addonCache('meinaddon').'blindtext.txt',$content);`
``n

Der gecachte Inhalt kann dann mit `getCache` abgerufen werden:

`echo (rex_file::getCache(rex_path::addonCache('meinaddon').'blindtext.txt'));`
``n

### rex_file::copy

Die Methode `copy` ermöglicht das Kopieren einer einer Datei zu einem Verzeichnis oder Datei. Es müssen eine Quell- und ein Zielpfad eingegeben werden. Die Rückgabe bei Erfolg ist TRUE, sonst FALSE.

`rex_file::copy($srcfile, $dstfile);`
``n

### rex_file::move

Die Methode `move` ermöglicht das Verschieben oder Umbenennen einer Datei. Es müssen ein Quell- und ein Zielpfad angegeben werden. Die Rückgabe bei Erfolg ist TRUE, sonst FALSE.

`rex_file::move($srcfile, $dstfile);`
``n

### rex_file::delete

Die Methode `delete` ermöglicht das Löschen einer einer Datei. Die Rückgabe bei Erfolg ist TRUE, sonst FALSE.

`rex_file::delete($file);`
``n

### rex_file::extension

Die Methode `extension` liefert als Rückgabe die Dateiendung einer Datei.

`rex_file::extension($file);`
``n

### rex_file::mimeType

Die Methode `mimeType` liefert den MimeType einer Datei.

`$extension = rex_file::mimeType($file);`
``n

z.B.:

- application/javascript

- image/svg+xml

- video/mpeg

### rex_file::formattedSize

Die Methode `formattedSize` liefert eine benutzerfreundliche Ausgabe der Dateigröße einer Datei

`$filesize = rex_file::formattedSize($file);`
``n

### rex_file::getOutput

`getOutput` führt die angegebene Datei aus und gibt das Ergebnis aus.

`rex_file::getOutput($file);`
``n

## rex_dir

Die Class `rex_dir` kümmert sich um das Handling von Verzeichnissen. Hier stehen Methoden zum Erstellen, Kopieren und Löschen von Verzeichnissen zur Verfügung.

[Quellcode auf GitHub](https://github.com/redaxo/redaxo/blob/main/redaxo/src/core/lib/util/dir.php)  

### rex_dir::create

`create` erstellt ein bzw. mehrere Verzeichnisse. Ist der Parameter $recursive auf true gestellt (Standard), wird der komplette Pfad inkl. angegebener Unterverzeichnisse erstellt. Bei false, müssen die angegebenen Unterverzeichnisse bereits bestehen. Rückgabe bei Erfolg ist TRUE, sonst FALSE.  

`rex_dir::create($dir, $recursive = true);`
``n

### rex_dir::isWritable

`isWritable` prüft ob Schreibrechte für das Verzeichnis bestehen. Rückgabe bei Erfolg ist TRUE, sonst FALSE.  

`rex_dir::isWritable($dir);`
``n

### rex_dir::copy

`copy` kopiert ein Verzeichnis zum angegebenen Ziel. Rückgabe bei Erfolg ist TRUE, sonst FALSE.

`rex_dir::copy($srcdir, $dstdir);`
``n

### rex_dir::delete

`delete` löscht ein Verzeichnis rekursiv. Wird `$deleteSelf` auf `false` gesetzt werden nur die Unterverzeichnisse gelöscht.   Rückgabe bei Erfolg ist TRUE, sonst FALSE.

`rex_dir::delete($dir, $deleteSelf = true);`
``n

### rex_dir::deleteFiles

`deleteFiles` löscht alle Deteien im angegeben Verzeichnis und der Unterverzeichnisse. Wird `$recursive` auf `false` gesetzt werden die Dateien der Unterverzeichnisse nicht gelöscht. Rückgabe bei Erfolg ist TRUE, sonst FALSE.

`rex_dir::deleteFiles($dir, $recursive = true);`
``n
                
                            [**Artikel bearbeiten](https://github.com/redaxo/docs/edit/main/file.md)
