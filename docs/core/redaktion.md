# redaktion

Quelle: https://redaxo.org/doku/main/redaktion

# Redaktion

- [Einleitung](#einleitung)

- [Blöcke](#bloecke)

- [Block bearbeiten](#block-bearbeiten)

- [Block löschen](#block-loeschen-)

- [Block verschieben](#block-verschieben)

- [Block online/offline](#block-status)

- [Bedienelemente in REDAXO](#bedienelemente)

- [Formularfelder](#formularfelder)

- [Link](#linkmap)

- [Linkliste](#linklist)

- [Medien-Link](#media)

- [Medienliste](#medialist)

- [Texteditoren und weitere Eingabemöglichkeiten](#andere)

- [Artikel-Funktionen](#funktionen)

- [Artikel in Startartikel umwandeln](#convert)

- [Artikel in Kategorie umwandeln](#convertcat)

- [Inhalte kopieren](#copycontent)

- [Artikel / Kategorien Kopieren und Verschieben](#move)

- [Sprachen](#sprachen)

- [Inhalte zwischen Sprachen kopieren](#copylang)

- [Metadaten](#metadaten)

- [Bereiche](#bereiche)

- [Arbeitsversion / Liveversion](#version)

- [History](#history)

## Einleitung

Die Artikel der Webpräsenz findet und erstellt man in den Kategorien der Strukturverwaltung. Dort wählt man auch das Template aus, welches die Anzeige des Artikels und die Anzahl der zu pflegenden Spalten definiert. Es gibt zwei Artikeltypen: ***Normale Artikel*** und ***Startartikel***.

Ein Startartikel repräsentiert immer die Kategorie und wird automatisch bei Erstellung einer Kategorie angelegt. Ein Startartikel ist erkennbar an seinem farblich hervorgehobenen Icon.
Normale Artikel können zusätzlich in einer Kategorie abgelegt werden.

Die Inhalte der Artikel werden über Blöcke eingepflegt. Zusätzliche Informationen und Einstellungen können in den Metadaten hinterlegt werden.

## Blöcke

Die Inhalte (der Content) eines Artikels werden mithilfe von Blöcken zusammengebaut. Sie werden durch die installierten Module in REDAXO zur Verfügung gestellt. Die Funktionen der Blöcke reichen von einfachen Texteingaben/-ausgaben bis zu kleinen Applikationen zur Generierung der Inhalte auf der jeweiligen Seite. Mögliche Einsatzzwecke sind vielfältig, beispielhaft seien genannt: Headlines, Fließtext, Galerien und die Steuerung von Ausgaben installierter AddOns.

                *

Editiermodus und Blockauswahl

Die Blöcke werden im Editiermodus (1) des Artikels eingepflegt.

                *

Blockauswahlmenü

Um einen Block hinzuzufügen, 

- klickt man auf das Aufklappmenü `Block hinzufügen` (2)

- und wählt den gewünschten Block (3)

- füllt das Formular aus (sofern erforderlich)

- speichert mit `Block speichern` 

Möchte man den aktuellen Stand der Bearbeitung zwischenspeichern und den Block geöffnet halten, um weiter zu arbeiten, klickt man auf `Block übernehmen` . Möchte man den aktuellen Stand nicht speichern, kann man die Bearbeitung `abbrechen` .

**

Da in jeder REDAXO-Installation unterschiedliche, häufig individuell erstellte Module zur Verfügung stehen, wird deren Funktion hier nicht erläutert.

### Block bearbeiten

Um einen vorhanden Block zu bearbeiten, klickt man auf das grüne Editier-Symbol.

### Block löschen

Einen Block löscht man durch Klick auf das rote Symbol mit dem Mülleimer.

### Block verschieben

Blöcke können mit den Pfeilen rechts um jeweils eine Position nach oben oder unten verschoben werden.

### Block onnline/offline

Mit der Schaltfläche `online` bzw. `offline` kann die Block-Darstellung beeinflusst werden. Ist ein Block `offline` wird dieser im Frontend nicht ausgegeben.

## Bedienelemente in REDAXO

Es gibt einige wiederkehrende Eingabemöglichkeiten in REDAXO. Hierzu zählen Formulareingaben, Linkauswahl und Auswahlfelder für Medien.

### Formularfelder

Die meisten Blöcke fragen in Formularen die Eingaben des Redakteurs ab. Hier können über Textfelder, Checkboxen und Auswahllisten verschiedene Einstellungen definiert und Texte eingepflegt werden.

### Link

                *

Link-widget

Über das Link-Widget kann ein einzelner Artikel der REDAXO-Webpräsenz verlinkt werden. Zur Auswahl eines Links klickt man auf das Sitemap-Symbol. Es öffnet sich dann ein Fenster (die Linkmap), in dem man innerhalb der Seitenstruktur den gewünschten Artikel auswählen kann. Um eine Kategorie zu verlinken, wählt man den dazugehörigen Startartikel. Mit dem anderen Symbol kann man die Linkauswahl wieder aufheben.

### Linklist

                *

Linklist-Widget

Mit dem Linklist-Widget können mehrere Artikel verlinkt werden. Die Reihenfolge der Links kann über die Pfeile verändert werden. Sonst verhält sich diese Eingabe wie beim Link-Widget.

### Medien-Link

                *

Media-Widget

Mit dem Media-Link-Widget werden einzelne Medien aus dem Medienpool ausgewählt. Das können beispielsweise Bilder oder Dokumente sein. Den Medienpool zur Auswahl des Mediums ruft man über das Listenmodul auf.

Um den Upload-Dialog des Medienpools aufzurufen, klickt man auf das (+)-Symbol. Möchte man die Informationen zum aktuell ausgewählten Medium im Medienpool aufrufen, klickt man auf das Auge.

### Medienliste

                *

Medialist-Widget

Zur Auswahl mehrerer Medien gibt es das Medialist-Widget. Hier können aus dem Medienpool mehrere Medien ausgewählt und deren Reihenfolge organisiert werden. Medialist-Widgets werden beispielsweise für die Erstellung von Downloadlisten oder Galerien benötigt. Sonst verhält sich diese Eingabe wie der Medien-Link.

### Texteditoren und weitere Eingabemöglichkeiten

Weitere Eingabemöglichkeiten werden über AddOns in REDAXO bereitgestellt. Hierzu zählen beispielhaft auch Markdown- und WYSIWYG-Editoren (MS-Word ähnlich).

## Artikel-Funktionen

Im Reiter `Funktionen` stehen je nach Artikeltyp folgende Funktionen zur Verfügung.

### Artikel in Startartikel umwandeln

[Siehe: Strukturverwaltung](/doku/main/strukturverwaltung#convertcat)

### Artikel in Kategorie umwandeln

[Siehe: Strukturverwaltung](/doku/main/strukturverwaltung#convertcat)

### Inhalte kopieren

[Siehe: Sprachen](#sprachen)

### Artikel / Kategorien kopieren und verschieben

[Siehe: Strukturverwaltung](/doku/main/strukturverwaltung#convert)

## Sprachen

REDAXO ist mehrsprachenfähig. Sofern mehrere Sprachen aktiviert sind und der Redakteur die entsprechenden Berechtigungen besitzt, erscheint im Backend oben rechts neben der Pfadleiste eine Sprachauswahl. Damit kann innerhalb eines Artikels zwischen den zur Verfügung stehenden Sprachversionen gewechselt werden.

Ein Artikel ist immer in allen Sprachen vorhanden und unterscheidet sich durch den Titel, die Inhalte und die Metadaten. Möchte man einen Artikel oder eine Kategorie in einer Sprache nicht in der Navigation oder in Artikellisten einer Sprache anzeigen, können diese mit dem Offline-Staus (sofern in der Programmierung der Website vorgesehen) ausgeblendet werden.
Die Sprachen werden vom Admin verwaltet und bereitgestellt.

**

Wenn ein Artikel in einer Sprache gelöscht wird, werden auch alle übrigen Sprachversionen gelöscht.

### Inhalte zwischen Sprachen kopieren

Im Reiter `Funktionen` steht die Kopierfunktion `Inhalte kopieren` zur Verfügung. Hiermit kann ein ganzer Artikel mit all seinen Blöcken identisch in eine andere Sprache zur Übersetzung übertragen werden. Befinden sich in der gewünschten Zielsprache bereits Inhalte, werden die Blöcke der Quelle ans Ende des Zielartikels gesetzt.

## Metadaten

Im Reiter `Metadaten` können zusätzliche Einstellungen für den Artikel durchgeführt werden. Dies können u.a. Timer-Einstellungen, Informationen für Suchmaschinen und soziale Netzwerke sein. Die Metadaten werden individuell für die jeweilige Webpräsenz festgelegt und werden durch das Metainfo-AddOn bereitgestellt und können sich je nach Kategorie unterscheiden.

Neben Artikeln können auch für Kategorien und Medien Metadaten verwendet werden. Diese werden an folgenden Stellen gepflegt:

[Strukturverwaltung](/doku/main/strukturverwaltung#meta)

[Medienpool](/doku/main/medienpool#detail)

## Bereiche

Ein Artikel kann in mehrere Bereiche unterteilt sein, die voneinander unabhängig gepflegt werden können. Je nach ausgewähltem Template können unterschiedlich viele Bereiche zur Verfügung gestellt werden. Häufig wird diese Funktion verwendet, um z. B. eine Seitenleiste oder eine Fußnote zu pflegen oder komplexere Layouts zu realisieren.

Um in einen Bereich zu gelangen, klickt man im Editiermodus auf die Bezeichnung des gewünschten Bereichs. Diese findet man im Reiter `Editiermodus` als Untermenüpunkte. Die Pflege der Bereiche erfolgt, indem man mit Modulen Inhaltsblöcke anlegt.

## Arbeitsversion / Liveversion

                *

Arbeitsversion / Liveversion

Sollte das Versions-PlugIn der Struktur installiert sein, ist es möglich, Arbeits- und Liveversionen der Artikel zu pflegen. Die Liveversion ist die aktuell auf der Website veröffentlichte Version. Die Umschaltung zwischen Liveversion und Arbeitsversion erfolgt über das Drop-Down-Menü `Version` .

In der Arbeitsversion erstellt man eine neue Ausgabe des Artikels.
Jeder Artikel hat eine leere Arbeitsversion zugeordnet, die sich nach Belieben füllen lässt. Es ist möglich, die Inhalte der Liveversion in die Arbeitsversion zu übertragen, sodass man an der aktuellen Version weiterarbeiten kann. Um eine Vorschau der Arbeitsversion zu erhalten, klickt man auf „Voransicht“. Nach Abschluss der Überarbeitung kann die Arbeitsversion als Liveversion freigegeben werden und somit online geschaltet werden.

**

**Achtung!** Wird die Arbeitsversion als Liveversion freigegeben, wird die aktuelle Liveversion überschrieben bzw. gelöscht. Nutzt man jedoch auch das History-PlugIn, so ist es möglich, vorherige Versionen wiederherzustellen.

## History

In REDAXO ist eine Versionierung (History) integriert. Ist diese aktiviert, erfasst REDAXO jede Änderung in den Artikel-Blöcken.

                *

History-Gegenüberstellung

Nach Klick auf das History-Symbol (runder Pfeil, mit Uhr, neben dem Reiter zum Editiermodus) öffnet sich eine Gegenüberstellung der Versionen. Über den Schieberegler oder das Drop-Down-Menü können die einzelnen Versionen ausgewählt und im rechten Fenster betrachtet werden.

Möchte man eine ältere Version wiederherstellen, klickt man auf `Diese Version übernehmen` . Hierbei wird die aktuelle Version als neue Version gespeichert, sodass es jederzeit möglich ist, den Vorgang rückgängig zu machen.
                [**Artikel bearbeiten](https://github.com/redaxo/docs/edit/main/redaktion.md)
