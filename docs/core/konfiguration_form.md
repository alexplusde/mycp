# konfiguration_form

Quelle: https://redaxo.org/doku/main/konfiguration_form

# Konfigurations-Formulare für AddOns

Möchte man individuelle Einstellungen durch den Redakteur festlegen lassen, benötigt man Formulare zur Pflege der AddOn-Konfiguration. Diese werden in der Tabelle `rex_config` abgespeichert und können per `rex_config`-Klasse abgerufen oder gespeichert werden.

Hierzu mussten bis REDAXO 5.4.0 die Formulare manuell erstellt werden und die übermittelten Werte in einem Formular manuell abgerufen und abgespeichert werden. Mit der Klasse `rex_config_form` hat sich das grundlegend geändert. `rex_config_form` erlaubt es, Formulare mittels `rex_form` zu erstellen und diese direkt zu speichern. Die Klasse `rex_config_form` basiert auf `rex_form_base`.

Somit stehen `rex_config_form` alle Eingabe- und Validierung-Möglichkeiten zur Verfügung, die in der Doku zu `rex_form` aufgezählt werden.

- [Instanziieren des Formulars](#Instanz)

- [Formularfelder](#felder)

- [Ausgabe](#ausgabe)

- [Überprüfen, ob Formular gesendet wurde](#versendet)

- [Beispiel-Formular mit rex_config_form](#beispiel1)

- [Beispiel-Formular klassisch](#beispiel2)

## Instanzieren des Formulars

`$form = rex_config_form::factory("addonxyz");`
``n

`addonxyz` ist der Namespace in der Tabelle `rex_config`

## Formularfelder

`$field = $form->addTextField('field_key');`
``n

`field_key` ist der Schlüssel in der Tabelle `rex_config`

Der Absende-Button und die Routinen zum Speichern der Daten werden automatisch hinzugefügt.

## Ausgabe

Damit das Formular im REDAXO-Stil ausgegeben werden kann, wird es an das section-Fragment übergeben.

`$addon = rex_addon::get('beispiel_addon');
$fragment = new rex_fragment();
$fragment->setVar('class', 'edit', false);
$fragment->setVar('title', $addon->i18n('example_title'), false);
$fragment->setVar('body', $form->get(), false);
echo $fragment->parse('core/page/section.php');`
``n

## Überprüfen, ob das Formular gesendet wurde

Um weiteren Code auszuführen, nachdem das Formular abgesendet wurde, kann zusätzlich folgender Code eingesetzt werden:

`$form_name = $form->getName();
if (rex_post($form_name.'_save')) {
  #Code
}`
``n

## Beispiel eines rex_config_form Formulars

`$addon = rex_addon::get('addonxyz');
$form = rex_config_form::factory($addon->name);

$field = $form->addInputField('text', 'vorname', null, ["class" => "form-control"]);
$field->setLabel('Vorname');

$field = $form->addInputField('text', 'nachname', null, ["class" => "form-control"]);
$field->setLabel('Nachname');

$fragment = new rex_fragment();
$fragment->setVar('class', 'edit', false);
$fragment->setVar('title', "Settings", false);
$fragment->setVar('body', $form->get() , false);
echo $fragment->parse('core/page/section.php');
`
``n

## Beispiel einer klassischen Konfiguration ohne rex_config_form

`$addon = rex_addon::get('beispiel_addon');

$content = '';

if (rex_post('config-submit', 'boolean')) {
    $addon->setConfig(rex_post('config', [
        ['vorname', 'string'],
        ['nachname', 'string'],
    ]));

    $content .= rex_view::info('Änderung gespeichert');
}

$content .=  '
<div class="rex-form">
    <form action="' . rex_url::currentBackendPage() . '" method="post">
        <fieldset>';

$formElements = [];

$n = [];
$n['label'] = '<label for="rex-out5-border-text">Vorname</label>';
$n['field'] = '<input class="form-control"  type="text" name="config[vorname]" value="' . $addon->getConfig('vorname') . '"/>';
$formElements[] = $n;

$n['label'] = '<label for="rex-out5-border-farbe">Nachname</label>';
$n['field'] = '<input class="form-control" type="text" name="config[nachname]" value="' . $addon->getConfig('nachname'). '"/>';
$formElements[] = $n;

$fragment = new rex_fragment();
$fragment->setVar('elements', $formElements, false);
$content .= $fragment->parse('core/form/form.php');
$content .= '
        </fieldset>
        <fieldset class="rex-form-action">';
$formElements = [];
$n = [];
$n['field'] = '<div class="btn-toolbar"><button type="submit" name="config-submit" class="btn btn-save rex-form-aligned" value="1">Einstellungen speichern</button></div>';
$formElements[] = $n;
$fragment = new rex_fragment();
$fragment->setVar('elements', $formElements, false);
$content .= $fragment->parse('core/form/submit.php');
$content .= '
        </fieldset>
    </form>
</div>';
$fragment = new rex_fragment();
$fragment->setVar('class', 'edit');
$fragment->setVar('title', 'Beispiel-Einstellungen');
$fragment->setVar('body', $content, false);
echo $fragment->parse('core/page/section.php');`
``n
                
                            [**Artikel bearbeiten](https://github.com/redaxo/docs/edit/main/konfiguration_form.md)
