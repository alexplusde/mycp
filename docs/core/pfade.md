# pfade

Quelle: https://redaxo.org/doku/main/pfade

# Pfade

- [Zugriff auf Dateisystem](#zugriff)

- [Dateisystem - rex_path](#rex_path)

- [base](#base)

- [frontend](#frontend)

- [frontendController](#frontendController)

- [backend](#backend)

- [backendController](#backendController)

- [media](#media)

- [assets](#assets)

- [coreAssets](#coreAssets)

- [addonAssets](#addonAssets)

- [pluginAssets](#pluginAssets)

- [data](#data)

- [coreData](#coreData)

- [addonData](#addonData)

- [pluginData](#pluginData)

- [cache](#cache)

- [coreCache](#coreCache)

- [addonCache](#addonCache)

- [pluginCache](#pluginCache)

- [log](#log)

- [src](#src)

- [core](#core)

- [addon](#addon)

- [plugin](#plugin)

- [absolute](#absolute)

- [URLs - rex_url](#rex_url)

- [base](#urlbase)

- [frontend](#urlfrontend)

- [frontendController](#urlfrontendController)

- [backend](#urlbackend)

- [backendController](#urlbackendController)

- [backendPage](#urlbackendPage)

- [currentBackendPage](#urlcurrentBackendPage)

- [media](#urlmedia)

- [assets](#urlassets)

- [coreAssets](#urlcoreAssets)

- [addonAssets](#urladdonAssets)

- [pluginAssets](#urlpluginAssets)

## Zugriff auf das Dateisystem

Die Klassen `rex_path` und `rex_url` ermöglichen den Zugriff auf die entsprechenden Ressourcen im Dateisystem ( `rex_path` ) bzw. per URL ( `rex_url` ).

## Dateisystem - rex_path

**

**Hinweis:** Es wird nicht geprüft, ob die zurückgegebenen Pfade gültig sind oder existieren.

### base

Gibt den Base Pfad mit der übergebenen Datei oder dem Ordner zurück

Beispiele:

`rex_path::base()
// ergibt: "/htdocs/meinverzeichnis/"`
``n

`rex_path::base('index.php')
// ergibt: "/htdocs/meinverzeichnis/index.php"`
``n

### frontend

Gibt den Frontend-Pfad mit der übergebenen Datei oder dem Ordner zurück

Beispiele:

`rex_path::frontend()
// ergibt: "/htdocs/meinverzeichnis/"`
``n

`rex_path::frontend('index.php')
// ergibt: "/htdocs/meinverzeichnis/index.php"`
``n

### frontendController

Pfad zum Frontend-Controller

Beispiel:

`rex_path::frontendController()
// ergibt: "/htdocs/meinverzeichnis/index.php"`
``n

### backend

Pfad zum Backend

Beispiel:

`rex_path::backend()
// ergibt: "/htdocs/meinverzeichnis/redaxo/"`
``n

`rex_path::backend('meinedatei.php')
// ergibt: "/htdocs/meinverzeichnis/redaxo/meinedatei.php"`
``n

### backendController

Pfad zum Backend-Controller

Beispiel:

`rex_path::backendController()
// ergibt: "/htdocs/meinverzeichnis/redaxo/index.php"`
``n

### media

Pfad zum Media-Verzeichnis

Beispiel:

`rex_path::media()
// ergibt: "/htdocs/meinverzeichnis/media/"`
``n

### assets

Pfad zum Assets-Verzeichnis

Beispiel:

`rex_path::assets()
// ergibt: "/htdocs/meinverzeichnis/assets/"`
``n

### coreAssets

Pfad zum Assets-Verzeichnis des Core

Beispiel:

`rex_path::coreAssets()
// ergibt: "/htdocs/meinverzeichnis/assets/core/"`
``n

`rex_path::coreAssets('file.txt')
// ergibt: "/htdocs/meinverzeichnis/assets/core/file.txt"`
``n

### addonAssets

Pfad zum Assets-Verzeichnis eines AddOns

Beispiel:

`rex_path::addonAssets('meinaddon')
// ergibt: "/htdocs/meinverzeichnis/assets/addons/meinaddon/"`
``n

`rex_path::addonAssets('meinaddon','file.txt')
// ergibt: "/htdocs/meinverzeichnis/assets/addons/meinaddon/file.txt"`
``n

### pluginAssets

Pfad zum Assets-Verzeichnis eines Plugins

Beispiel:

`rex_path::pluginAssets('meinaddon','meinplugin')
// ergibt: "/htdocs/meinverzeichnis/assets/addons/meinaddon/plugins/meinplugin/"`
``n

`rex_path::pluginAssets('meinaddon','meinplugin','file.txt')
// ergibt: "/htdocs/meinverzeichnis/assets/addons/meinaddon/plugins/meinplugin/file.txt"`
``n

### data

Pfad zum Data-Verzeichnis

Beispiel:

`rex_path::data()
// ergibt: "/htdocs/meinverzeichnis/data/"`
``n

### coreData

Pfad zum Data-Verzeichnis des Core

Beispiel:

`rex_path::coreData()
// ergibt: "/htdocs/meinverzeichnis/data/core/"`
``n

`rex_path::coreData('file.txt')
// ergibt: "/htdocs/meinverzeichnis/data/core/file.txt"`
``n

### addonData

Pfad zum Data-Verzeichnis eines AddOns

Beispiel:

`rex_path::addonData('meinaddon')
// ergibt: "/htdocs/meinverzeichnis/data/addons/meinaddon/"`
``n

`rex_path::addonData('meinaddon','file.txt')
// ergibt: "/htdocs/meinverzeichnis/data/addons/meinaddon/file.txt"`
``n

### pluginData

Pfad zum Data-Verzeichnis eines Plugins

Beispiel:

`rex_path::pluginData('meinaddon','meinplugin')
// ergibt: "/htdocs/meinverzeichnis/data/addons/meinaddon/plugins/meinplugin/"`
``n

`rex_path::pluginData('meinaddon','meinplugin','file.txt')
// ergibt: "/htdocs/meinverzeichnis/data/addons/meinaddon/plugins/meinplugin/file.txt"`
``n

### cache

Pfad zum Cache-Verzeichnis

Beispiel:

`rex_path::cache()
// ergibt: "/htdocs/meinverzeichnis/redaxo/cache/"`
``n

`rex_path::cache('file.txt')
// ergibt: "/htdocs/meinverzeichnis/redaxo/cache/file.txt"`
``n

### coreCache

Pfad zum Data-Verzeichnis

Beispiel:

`rex_path::coreCache()
// ergibt: "/htdocs/meinverzeichnis/redaxo/cache/core/"`
``n

`rex_path::coreCache('file.txt')
// ergibt: "/htdocs/meinverzeichnis/redaxo/cache/core/file.txt"`
``n

### addonCache

Pfad zum Cache-Verzeichnis eines AddOns

Beispiel:

`rex_path::addonCache('meinaddon')
// ergibt: "/htdocs/meinverzeichnis/redaxo/cache/addons/meinaddon/"`
``n

`rex_path::addonCache('meinaddon','file.txt')
// ergibt: "/htdocs/meinverzeichnis/redaxo/cache/addons/meinaddon/file.txt"`
``n

### pluginCache

Pfad zum Cache-Verzeichnis eines Plugins

Beispiel:

`rex_path::pluginCache('meinaddon','meinplugin')
// ergibt: "/htdocs/meinverzeichnis/redaxo/cache/addons/meinaddon/plugins/meinplugin/"`
``n

`rex_path::pluginCache('meinaddon','meinplugin','file.txt')
// ergibt: "/htdocs/meinverzeichnis/redaxo/cache/addons/meinaddon/plugins/meinplugin/file.txt"`
``n

### Log

Pfad zur angegebenen Log-Datei.

Beispiel:
`rex_path::log('mail.log')` => `/httpdocs/redaxo/data/log/mail.log` 

### src

Pfad zum Src-Verzeichnis

Beispiel:

`rex_path::src()
// ergibt: "/htdocs/meinverzeichnis/redaxo/src/"`
``n

`rex_path::src('file.txt')
// ergibt: "/htdocs/meinverzeichnis/redaxo/src/file.txt"`
``n

### core

Pfad zum Core-Verzeichnis

Beispiel:

`rex_path::core()
// ergibt: "/htdocs/meinverzeichnis/redaxo/src/core/"`
``n

`rex_path::core('file.txt')
// ergibt: "/htdocs/meinverzeichnis/redaxo/src/core/file.txt"`
``n

### addon

Pfad zum AddOn-Verzeichnis

Beispiel:

`rex_path::addon('meinaddon')
// ergibt: "/htdocs/meinverzeichnis/redaxo/src/addons/meinaddon/"`
``n

`rex_path::addon('meinaddon','file.txt')
// ergibt: "/htdocs/meinverzeichnis/redaxo/src/addons/meinaddon/file.txt"`
``n

### plugin

Pfad zum PlugIn-Verzeichnis

Beispiel:

`rex_path::plugin('meinaddon','meinplugin')
// ergibt: "/htdocs/meinverzeichnis/redaxo/src/addons/meinaddon/plugins/meinplugin/"`
``n

`rex_path::plugin('meinaddon','meinplugin','file.txt')
// ergibt: "/htdocs/meinverzeichnis/redaxo/src/addons/meinaddon/plugins/meinplugin/file.txt"`
``n

### absolute

Wandelt einen relativen Pfad zu einem absoluten Pfad

Beispiel:

`rex_path::absolute('../../src/addons')
// ergibt: "src/addons"`
``n

## URLs - rex_url

**

**Hinweis:** Bei allen URL-Funktionen der Klasse `rex_url` wird eine Installation von REDAXO in einem Unterverzeichnis berücksichtigt.

Funktionen, die Parameter zu URLs umschreiben, können die URL auch "escaped" zurückgeben.

### base

Liefert den Basispfad der Website

Beispiel:

`rex_url::base()
// ergibt: "/"`
``n

`rex_url::base('file.txt')
// ergibt: "/file.txt"`
``n

### frontend

Liefert den Frontendpfad der Website

Beispiel:

`rex_url::frontend()
// ergibt: "/"`
``n

Bei Installation in einem Unterverzeichnis:

`rex_url::frontend()
// ergibt: "/verzeichnis/"`
``n

`rex_url::frontend('file.txt')
// ergibt: "/verzeichnis/file.txt"`
``n

### frontendController

Generiert eine URL aus übergebenen Parametern

Beispiel:

`rex_url::frontendController(['key'=>'value'])
// ergibt: "/index.php?key=value"`
``n

`rex_url::frontendController(['k1'=>'v1','k2'=>'v2'], true)
// ergibt: "/index.php?k1=v1&amp; k2=v2"`
``n

### backend

Liefert den Backendpfad der Website

Beispiel:

`rex_url::backend()
// ergibt: "/redaxo/"`
``n

`rex_url::backend('file.txt')
// ergibt: "/redaxo/file.txt"`
``n

### backendController

Generiert eine Backend-URL aus übergebenen Parametern

Beispiel:

`rex_url::backendController(['key'=>'value'])
// ergibt: "/redaxo/index.php?key=value"`
``n

`rex_url::backendController(['k1'=>'v1','k2'=>'v2'], true)
// ergibt: "/redaxo/index.php?k1=v1&amp; k2=v2"`
``n

### backendPage

Generiert eine URL zu einer Backend Seite

Beispiel:

`rex_url::backendPage('mypage',['key'=>'value'])
// ergibt: "/redaxo/index.php?page=mypage&key=value"`
``n

`rex_url::backendPage('mypage',['k1'=>'v1','k2'=>'v2'], true)
// ergibt: "/redaxo/index.php?page=mypage&amp; k1=v1&amp; k2=v2"`
``n

### currentBackendPage

Generiert eine URL zur aktuellen Backend-Seite. Sollte sinnvollerweise nur von einer Backend-Page aufgerufen werden, ansonsten ist der Parameter `page` leer.

Beispiel:

`rex_url::currentBackendPage(['key'=>'value'])
// ergibt: "/redaxo/index.php?page=currpage&key=value"`
``n

`rex_url::currentBackendPage(['k1'=>'v1','k2'=>'v2'], true)
// ergibt: "/redaxo/index.php?page=currpage&amp; k1=v1&amp; k2=v2"`
``n

### media

Liefert den Frontendpfad zum Media-Verzeichnis

Beispiel:

`rex_url::media()
// ergibt: "/media/"`
``n

`rex_url::media('file.txt')
// ergibt: "/media/file.txt"`
``n

### assets

Liefert den Frontendpfad zum Assets-Verzeichnis

Beispiel:

`rex_url::assets()
// ergibt: "/assets/"`
``n

`rex_url::assets('file.txt')
// ergibt: "/assets/file.txt"`
``n

### coreAssets

Liefert den Frontendpfad zum Assets-Verzeichnis des Core

Beispiel:

`rex_url::coreAssets()
// ergibt: "/assets/core/"`
``n

`rex_url::coreAssets('file.txt')
// ergibt: "/assets/core/file.txt"`
``n

### addonAssets

Liefert den Frontendpfad zum Assets-Verzeichnis eines AddOns

Beispiel:

`rex_url::addonAssets('meinaddon')
// ergibt: "/assets/addons/meinaddon/"`
``n

`rex_url::addonAssets('meinaddon','file.txt')
// ergibt: "/assets/addons/meinaddon/file.txt"`
``n

### pluginAssets

Liefert den Frontendpfad zum Assets-Verzeichnis eines Plugins

Beispiel:

`rex_url::pluginAssets('meinaddon','meinplugin')
// ergibt: "/assets/addons/meinaddon/plugins/meinplugin/"`
``n

`rex_url::pluginAssets('meinaddon','meinplugin','file.txt')
// ergibt: "/assets/addons/meinaddon/plugins/meinplugin/file.txt"`
``n
                
                            [**Artikel bearbeiten](https://github.com/redaxo/docs/edit/main/pfade.md)
