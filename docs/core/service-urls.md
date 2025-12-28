# service-urls

Quelle: https://redaxo.org/doku/main/service-urls

# URLs

- [Standard-URL-Schema](#standard-url-schema)

- [URL-Rewrite-AddOns](#rewrite)

- [URLs formatieren mit rex_getUrl()](#rex-get-url)

- [Artikel-ID](#artikel-id)

- [Sprach-ID](#sprach-id)

- [Parameter](#parameter)

- [Trennzeichen](#trennzeichen)

- [Link aus Artikel- oder Kategorieobjekt erstellen mit toLink](#toLink)

- [Artikelumleitung](#umleitung)

## Standard-URL-Schema

Das standardmäßige URL-Schema des REDAXO-Frontends arbeitet mit der Artikel-ID, bzw. zusätzlich mit der Sprach-ID, sofern mehrere Sprachen im CMS angelegt wurden:

`// Dieser Link führt zum Artikel mit der ID 3
./index.php?article_id=3`
``n

Sofern mehr als eine Sprache in REDAXO existiert, also eine oder mehrere Sprachen angelegt wurden, taucht zusätzlich die Sprach-ID mit in der URL auf:

`// Dieser Link führt zum Artikel mit der ID 3 in der Sprache mit der ID 2
./index.php?article_id=3&clang=2`
``n

**

Hinweis: Auch Links zu Artikeln der aktuellen Sprache enthalten diesen Sprachparameter, obwohl er nicht nötig wäre.

## URL-Rewrite-AddOns

Beim Einsatz von URL-Rewrite-AddOns wie beispielsweise yRewrite werden "schönere" URLs generiert, die für den Besucher angenehmer zu erfassen und auch für Suchmaschinen leichter auszuwerten sind. Diese URLs orientieren sich am klassischen Ordner--Schema von statischen Websites und lauten z. B. so:

`/ueber-uns/kontakt/`
``n

## URLs formulieren mit [rex_getUrl](https://friendsofredaxo.github.io/phpdoc/namespaces/default.html#method_rex_getUrl)

Wenn man Frontend-URLs zu internen REDAXO-Artikeln setzt, möchte man dies natürlich in einer Weise tun, die unabhängig von jeglichen Rewrite-Mechanismen immer funktioniert. Hierbei hilft die Funktion `rex_getUrl` .

Parameter
Erklärung

`$id`
Die ID des gewünschten Artikels

`$clang`
Die ID der gewünschten Sprache

`$params`
Array von Parametern

`$separator`
Das Trennzeichen zwischen den Parametern (Default: '& ')

### Artikel-ID

Beim Aufruf übergibt man rex_getURL im Normalfall eine gültige Artikel-ID. Die Artikel-ID kann als feste Zahl oder auch dynamisch mittels einer Variable übergeben werden:

`// Die URL des aktuellen Artikels wird ausgegeben
$aktuelle_id = $this->getValue('article_id');
<?php echo rex_getUrl($aktuelle_id); ?>`
``n

### Sprach-ID

Beim mehrsprachigen Websites wird als zweiter Parameter die Sprach-ID übergeben. Dieser Aufruf wechselt zum aktuellen Artikel in der Sprache mit der ID 2:

`// Die URL des aktuellen Artikels in der Sprache mit der ID 2 ausgegeben
$aktuelle_id = $this->getValue('article_id');
<?php echo rex_getUrl($aktuelle_id, 2); ?>`
``n

Mehr Information über Links in mehrsprachigen Websites findet sich im Kapitel [Mehrsprachigkeit](/doku/main/mehrsprachigkeit)

### Parameter

`// Die URL des aktuellen Artikels in der Sprache mit der aktuellen Sprach-ID und weiteren Parametern ausgegeben
$aktuelle_id = $this->getValue('article_id');
<?php echo rex_getUrl($aktuelle_id, rex_clang::getCurrentId(), array ('chapters' => 2, 'page' => 3) ); ?>`
``n

### Trennzeichen

Das Trennzeichen ist standardmäßig auf `&amp;` eingestellt, um URLs zu erzeugen, die bspw. in ein `href=""` -Attribut eingesetzt werden können:

`// Die Schreibweise des Trennzeichens(Separators) wird immer auf &amp; festgelegt
$aktuelle_id = $this->getValue('article_id');
<?php echo rex_getUrl($aktuelle_id, rex_clang::getCurrentId(), array $params = [], '&amp;'); ?>`
``n

Um Anker ohne HTML-Entities auszugeben, wie sie bspw. bei Weiterleitungen oder E-Mail-Templates im Plaintext benötigt werden, muss der 4. Parameter ersetzt werden:

`// Die Schreibweise des Trennzeichens(Separators) wird nun auf & festgelegt
$aktuelle_id = $this->getValue('article_id');
<?php echo rex_getUrl($aktuelle_id, rex_clang::getCurrentId(), array $params = [], '&'); ?>`
``n

## Link aus Artikel- oder Kategorieobjekt erstellen mit toLink()

Es ist möglich, direkt aus einem Artikel-Objekt heraus einen Link zu diesem mit toLink() zu erstellen. Hierbei können Parameter-, Attribute und auch der Surrounding-Tag mit Parameter übergeben werden.

***Beispiel:***

`
// Einfacher Aufruf erzeugt einen Link ohne Attribute und Parameter
echo  $article->toLink();`
``n

`// Mit Parameter, Attribute, Surround-Tags und dazugehörige Attribute
echo  $article->toLink(
  [ 'pdf' => '1'
  ],
  [
  'class' =>  $class,
  'rel' => '_blank',
  'alt' => $article->getName()
  ],
  'li',
  [
  'class' =>  $class,
  'title' => $article->getName()
  ]
);
`
``n

## Artikelumleitung

Mit rex_redirect() kann eine Umleitung zu einem anderen Artikel erzeugt werden. Es handelt sich hierbei nicht um eine Url. Die Funktion wird innerhalb eines Templates, Moduls oder AddOn aufgerufen um eine Umleitung direkt anzustoßen.

`rex_redirect($article_id, $clang = null, array $params = [])`
``n

Die rex_redirect ist eine Kurzform von:

`rex_response::sendRedirect(rex_getUrl($article_id, $clang, $params, '&'));
`
``n

mit `rex_response::sendRedirect` kann man auch Umleitungen zu externen Seiten erstellen.

Weitere Infos zu rex_response in der [REDAXO API Dokumentation](https://friendsofredaxo.github.io/phpdoc/classes/rex-response.html)
                [**Artikel bearbeiten](https://github.com/redaxo/docs/edit/main/service-urls.md)
