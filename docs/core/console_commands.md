# Console Commands

**Keywords:** CLI Command Console Symfony Cache Package User DB Config Terminal

## Übersicht

CLI-Command-System basierend auf Symfony Console für Cache, Package, User, DB und Config-Management.

## Methoden

### rex_console_command (Abstract Base)

| Methode | Parameter | Rückgabe | Beschreibung |
|---------|-----------|----------|--------------|
| `setPackage($package)` | rex_package\|null | $this | Setzt zugehöriges Package |
| `getPackage()` | - | rex_package\|null | Liefert Package (null bei Core-Commands) |
| `getStyle($input, $output)` | InputInterface, OutputInterface | SymfonyStyle | Symfony IO-Helper |
| `decodeMessage($message)` | string | string | HTML→CLI (strip_tags, htmlspecialchars_decode) |
| `configure()` | - | void | Abstract: Command konfigurieren |
| `execute($input, $output)` | InputInterface, OutputInterface | int | Abstract: Command ausführen (0=success) |

## Built-in Commands

### Cache Commands

| Command | Beschreibung | Beispiel |
|---------|--------------|----------|
| `cache:clear` | Löscht REDAXO Core-Cache | `php bin/console cache:clear` |

### Package Commands

| Command | Beschreibung | Beispiel |
|---------|--------------|----------|
| `package:install <id>` | Installiert Package | `php bin/console package:install yform` |
| `package:install <id> --re-install` | Reinstalliert Package | `php bin/console package:install yform -r` |
| `package:uninstall <id>` | Deinstalliert Package | `php bin/console package:uninstall debug` |
| `package:activate <id>` | Aktiviert Package | `php bin/console package:activate cronjob` |
| `package:deactivate <id>` | Deaktiviert Package | `php bin/console package:deactivate debug` |
| `package:delete <id>` | Löscht Package-Dateien | `php bin/console package:delete old_addon` |
| `package:list` | Listet alle Packages | `php bin/console package:list` |
| `package:run-update-script <id>` | Führt Update-Script aus | `php bin/console package:run-update-script yform` |

### User Commands

| Command | Beschreibung | Beispiel |
|---------|--------------|----------|
| `user:create <login> [password]` | Erstellt neuen User | `php bin/console user:create admin` |
| `user:create --admin` | User mit Admin-Rechten | `php bin/console user:create admin secret --admin` |
| `user:create --name "Name"` | Mit Display-Name | `php bin/console user:create john pwd --name "John Doe"` |
| `user:create --password-change-required` | Passwort-Änderung erzwingen | `php bin/console user:create temp pwd --password-change-required` |
| `user:set-password <login> [password]` | Passwort ändern | `php bin/console user:set-password admin` |
| `user:list` | Listet alle User | `php bin/console user:list` |
| `user:delete <login>` | Löscht User | `php bin/console user:delete old_user` |

### DB Commands

| Command | Beschreibung | Beispiel |
|---------|--------------|----------|
| `db:connection-options` | Zeigt DB-Connection-Params | `php bin/console db:connection-options` |
| `db:set-connection <id>` | Setzt aktive DB-Connection | `php bin/console db:set-connection 2` |
| `db:update` | Führt DB-Updates aus | `php bin/console db:update` |

### Config Commands

| Command | Beschreibung | Beispiel |
|---------|--------------|----------|
| `config:get <namespace> <key>` | Liest Config-Wert | `php bin/console config:get yform settings` |
| `config:set <namespace> <key> <value>` | Setzt Config-Wert | `php bin/console config:set myAddon api_key xyz` |

### System Commands

| Command | Beschreibung | Beispiel |
|---------|--------------|----------|
| `system:report` | System-Report ausgeben | `php bin/console system:report` |
| `assets:sync` | Assets synchronisieren | `php bin/console assets:sync` |

## Praxisbeispiele

### Cache löschen

```bash
# Core-Cache löschen
php bin/console cache:clear

# Output:
# [OK] Der Cache wurde erfolgreich gelöscht!
```

### Package installieren

```bash
# Addon installieren
php bin/console package:install yform

# Mit Re-Install-Option (ohne Nachfrage)
php bin/console package:install yform --re-install
php bin/console package:install yform -r

# Plugin installieren
php bin/console package:install yform/manager

# Mehrere Packages nacheinander
php bin/console package:install phpmailer
php bin/console package:install yform
php bin/console package:install cronjob
```

### Package-Lifecycle

```bash
# Installieren
php bin/console package:install debug

# Aktivieren (falls deaktiviert)
php bin/console package:activate debug

# Deaktivieren
php bin/console package:deactivate debug

# Update-Script ausführen
php bin/console package:run-update-script yform

# Deinstallieren
php bin/console package:uninstall debug

# Löschen (entfernt Dateien)
php bin/console package:delete debug
```

### Package-Liste

```bash
# Alle Packages anzeigen
php bin/console package:list

# Output:
# +-----------+--------+-----------+
# | Package   | Status | Version   |
# +-----------+--------+-----------+
# | phpmailer | active | 3.3.0     |
# | yform     | active | 4.0.0     |
# | cronjob   | active | 2.3.0     |
# +-----------+--------+-----------+
```

### User erstellen

```bash
# Interaktiv (fragt Passwort ab)
php bin/console user:create admin

# Mit Passwort als Parameter
php bin/console user:create admin mySecretPassword

# Admin-User
php bin/console user:create admin secret --admin

# Mit Name
php bin/console user:create john pwd --name "John Doe"

# Passwort-Änderung bei Login erzwingen
php bin/console user:create temp pwd --password-change-required

# Kombination
php bin/console user:create superadmin secret --admin --name "Super Admin"
```

### User-Management

```bash
# Alle User auflisten
php bin/console user:list

# Passwort ändern (interaktiv)
php bin/console user:set-password admin

# Passwort ändern (mit Parameter)
php bin/console user:set-password admin newPassword

# User löschen
php bin/console user:delete old_user
```

### DB-Commands

```bash
# DB-Connection-Optionen anzeigen
php bin/console db:connection-options

# Output:
# Host: localhost
# Database: redaxo5
# User: root
# ...

# DB-Connection wechseln
php bin/console db:set-connection 2

# DB-Updates ausführen (nach REDAXO-Update)
php bin/console db:update
```

### Config-Werte

```bash
# Config-Wert lesen
php bin/console config:get yform settings

# Config-Wert setzen
php bin/console config:set myAddon api_key xyz123

# Mehrere Werte setzen
php bin/console config:set myAddon api_key xyz123
php bin/console config:set myAddon api_secret abc456
php bin/console config:set myAddon mode production
```

### Custom Command erstellen

```php
// In lib/console/my_command.php

use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Output\OutputInterface;

class rex_command_my_custom extends rex_console_command
{
    protected function configure(): void
    {
        $this
            ->setDescription('Does something custom')
            ->addArgument('name', InputArgument::REQUIRED, 'Name parameter')
            ->addOption('force', 'f', InputOption::VALUE_NONE, 'Force execution');
    }
    
    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = $this->getStyle($input, $output);
        
        $name = $input->getArgument('name');
        $force = $input->getOption('force');
        
        // Logik
        if (!$force && !$this->confirm('Really proceed?')) {
            $io->warning('Aborted');
            return 1;
        }
        
        // Verarbeitung
        $io->success('Successfully processed: ' . $name);
        
        return 0; // 0 = success, 1+ = error
    }
}
```

### Command in Boot registrieren

```php
// In boot.php eines Addons

if (rex::isConsole()) {
    rex_console::addCommand('myAddon:import', new rex_command_my_import());
    rex_console::addCommand('myAddon:export', new rex_command_my_export());
    rex_console::addCommand('myAddon:sync', new rex_command_my_sync());
}

// Verwendung
// php bin/console myAddon:import data.json
// php bin/console myAddon:export output.json
```

### Input-Argumente & Options

```php
class rex_command_example extends rex_console_command
{
    protected function configure(): void
    {
        $this
            ->setDescription('Example command')
            // Required Argument
            ->addArgument('file', InputArgument::REQUIRED, 'File path')
            // Optional Argument
            ->addArgument('output', InputArgument::OPTIONAL, 'Output file', 'default.txt')
            // Array Argument (mehrere Werte)
            ->addArgument('ids', InputArgument::IS_ARRAY, 'Multiple IDs')
            
            // Boolean Option (Flag)
            ->addOption('force', 'f', InputOption::VALUE_NONE, 'Force')
            // Option mit Wert
            ->addOption('format', null, InputOption::VALUE_REQUIRED, 'Format', 'json')
            // Option mit optionalem Wert
            ->addOption('verbose', 'v', InputOption::VALUE_OPTIONAL, 'Verbose level', 1);
    }
    
    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = $this->getStyle($input, $output);
        
        // Arguments
        $file = $input->getArgument('file');
        $outputFile = $input->getArgument('output');
        $ids = $input->getArgument('ids'); // Array
        
        // Options
        $force = $input->getOption('force'); // bool
        $format = $input->getOption('format'); // string
        $verbose = $input->getOption('verbose'); // int|null
        
        $io->success('Done');
        return 0;
    }
}

// Aufruf:
// php bin/console example input.json output.json 1 2 3 --force --format=xml -v
```

### User-Interaktion

```php
class rex_command_interactive extends rex_console_command
{
    protected function configure(): void
    {
        $this->setDescription('Interactive command');
    }
    
    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = $this->getStyle($input, $output);
        
        // Frage stellen
        $name = $io->ask('What is your name?', 'default');
        
        // Passwort abfragen (hidden)
        $password = $io->askHidden('Enter password');
        
        // Ja/Nein-Frage
        if ($io->confirm('Continue?', true)) {
            // ...
        }
        
        // Auswahl (Choice)
        $format = $io->choice('Select format', ['json', 'xml', 'csv'], 'json');
        
        // Ausgabe
        $io->title('My Command');
        $io->section('Processing');
        $io->text('Some text');
        $io->success('Success message');
        $io->error('Error message');
        $io->warning('Warning message');
        $io->note('Note message');
        $io->caution('Caution message');
        
        // Tabelle
        $io->table(
            ['ID', 'Name', 'Status'],
            [
                [1, 'Item 1', 'Active'],
                [2, 'Item 2', 'Inactive'],
            ]
        );
        
        // Progress Bar
        $io->progressStart(100);
        for ($i = 0; $i < 100; $i++) {
            $io->progressAdvance();
            usleep(10000);
        }
        $io->progressFinish();
        
        return 0;
    }
}
```

### Batch-Installation (Deployment)

```bash
#!/bin/bash
# install-packages.sh

# Core-Addons
php bin/console package:install phpmailer
php bin/console package:install yform
php bin/console package:install cronjob
php bin/console package:install yrewrite

# Optional
php bin/console package:install debug
php bin/console package:install developer

# Custom
php bin/console package:install myAddon

echo "✓ All packages installed"
```

### Error Handling

```php
class rex_command_safe extends rex_console_command
{
    protected function configure(): void
    {
        $this->setDescription('Safe command');
    }
    
    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = $this->getStyle($input, $output);
        
        try {
            // Risikante Operation
            $this->doSomethingRisky();
            
            $io->success('Success');
            return 0;
            
        } catch (Exception $e) {
            // Fehler ausgeben
            $io->error($e->getMessage());
            
            // Optional: Stack Trace
            if ($input->getOption('verbose')) {
                $io->text($e->getTraceAsString());
            }
            
            return 1; // Error-Code
        }
    }
}
```

### Validation

```php
class rex_command_validate extends rex_console_command
{
    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = $this->getStyle($input, $output);
        
        $file = $input->getArgument('file');
        
        // File existiert?
        if (!file_exists($file)) {
            throw new InvalidArgumentException('File not found: ' . $file);
        }
        
        // Format korrekt?
        $format = $input->getOption('format');
        if (!in_array($format, ['json', 'xml', 'csv'])) {
            throw new InvalidArgumentException('Invalid format: ' . $format);
        }
        
        $io->success('Validation passed');
        return 0;
    }
}
```

### HTML-Messages dekodieren

```php
class rex_command_i18n extends rex_console_command
{
    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = $this->getStyle($input, $output);
        
        // rex_i18n liefert HTML (z.B. <br>)
        $message = rex_i18n::msg('my_message');
        // Output: "Line 1<br />Line 2"
        
        // Für CLI dekodieren
        $cliMessage = $this->decodeMessage($message);
        // Output: "Line 1\nLine 2"
        
        $io->text($cliMessage);
        
        return 0;
    }
}
```

### Package-Kontext

```php
// Command mit Package-Kontext
class myAddon_command extends rex_console_command
{
    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = $this->getStyle($input, $output);
        
        // Package abrufen
        $package = $this->getPackage();
        
        if ($package) {
            $io->text('Package: ' . $package->getPackageId());
            $io->text('Version: ' . $package->getVersion());
            $io->text('Path: ' . $package->getPath());
        }
        
        return 0;
    }
}

// Registrierung mit Package
if (rex::isConsole()) {
    $addon = rex_addon::get('myAddon');
    $command = new myAddon_command();
    $command->setPackage($addon);
    rex_console::addCommand('myAddon:info', $command);
}
```

### Cronjob via Console

```bash
# Cronjob-Skript
#!/bin/bash
# /usr/local/bin/redaxo-cronjobs.sh

cd /var/www/html

# Cache aufräumen
php bin/console cache:clear

# Custom Commands
php bin/console myAddon:cleanup
php bin/console myAddon:sync
php bin/console myAddon:backup

# Log
echo "$(date): Cronjobs executed" >> /var/log/redaxo-cron.log
```

### Crontab-Eintrag

```cron
# Täglich um 2:00 Uhr
0 2 * * * /usr/local/bin/redaxo-cronjobs.sh

# Alle 5 Minuten
*/5 * * * * cd /var/www/html && php bin/console myAddon:sync
```

### DB-Update in CI/CD

```yaml
# .gitlab-ci.yml / .github/workflows/deploy.yml

deploy:
  script:
    - php bin/console cache:clear
    - php bin/console db:update
    - php bin/console package:run-update-script yform
    - php bin/console assets:sync
```

### Setup-Automation

```bash
#!/bin/bash
# setup.sh - Komplettes REDAXO-Setup

# User erstellen
php bin/console user:create admin "$ADMIN_PASSWORD" --admin --name "Administrator"

# Packages installieren
php bin/console package:install phpmailer
php bin/console package:install yform
php bin/console package:install yrewrite
php bin/console package:install cronjob

# Config setzen
php bin/console config:set yrewrite url "https://example.com"
php bin/console config:set yrewrite ssl 1

# Cache löschen
php bin/console cache:clear

echo "✓ Setup complete"
```

### Testing Commands

```php
// In tests/console_test.php

use Symfony\Component\Console\Application;
use Symfony\Component\Console\Tester\CommandTester;

class ConsoleTest extends PHPUnit\Framework\TestCase
{
    public function testCacheClear()
    {
        $application = new Application();
        $application->add(new rex_command_cache_clear());
        
        $command = $application->find('cache:clear');
        $tester = new CommandTester($command);
        $tester->execute([]);
        
        $output = $tester->getDisplay();
        $this->assertStringContainsString('erfolgreich', $output);
        $this->assertEquals(0, $tester->getStatusCode());
    }
}
```

### Multi-Step-Command

```php
class rex_command_multi_step extends rex_console_command
{
    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = $this->getStyle($input, $output);
        
        $io->title('Multi-Step Process');
        
        // Step 1
        $io->section('Step 1: Validation');
        if (!$this->validate()) {
            $io->error('Validation failed');
            return 1;
        }
        $io->success('Validation passed');
        
        // Step 2
        $io->section('Step 2: Processing');
        $io->progressStart(100);
        for ($i = 0; $i < 100; $i++) {
            $this->process($i);
            $io->progressAdvance();
        }
        $io->progressFinish();
        
        // Step 3
        $io->section('Step 3: Cleanup');
        $this->cleanup();
        $io->success('Cleanup done');
        
        $io->success('All steps completed successfully');
        return 0;
    }
}
```

### Logging in Commands

```php
class rex_command_logged extends rex_console_command
{
    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = $this->getStyle($input, $output);
        $logger = rex_logger::factory();
        
        $logger->info('Command started', ['command' => $this->getName()]);
        
        try {
            // Verarbeitung
            $result = $this->doSomething();
            
            $logger->info('Command completed', ['result' => $result]);
            $io->success('Done');
            return 0;
            
        } catch (Exception $e) {
            $logger->error('Command failed', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            
            $io->error($e->getMessage());
            return 1;
        }
    }
}
```

### Silent Mode

```php
class rex_command_silent extends rex_console_command
{
    protected function configure(): void
    {
        $this
            ->setDescription('Silent command')
            ->addOption('quiet', 'q', InputOption::VALUE_NONE, 'No output');
    }
    
    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = $this->getStyle($input, $output);
        $quiet = $input->getOption('quiet');
        
        // Verarbeitung
        $result = $this->process();
        
        if (!$quiet) {
            $io->success('Processed: ' . $result);
        }
        
        return 0;
    }
}

// Aufruf:
// php bin/console silent:command --quiet
```

### Dry-Run-Modus

```php
class rex_command_dryrun extends rex_console_command
{
    protected function configure(): void
    {
        $this
            ->setDescription('Command with dry-run')
            ->addOption('dry-run', null, InputOption::VALUE_NONE, 'Simulate without changes');
    }
    
    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = $this->getStyle($input, $output);
        $dryRun = $input->getOption('dry-run');
        
        if ($dryRun) {
            $io->note('DRY-RUN MODE - No changes will be made');
        }
        
        $items = $this->getItems();
        
        foreach ($items as $item) {
            if ($dryRun) {
                $io->text('Would delete: ' . $item);
            } else {
                $this->delete($item);
                $io->text('Deleted: ' . $item);
            }
        }
        
        $io->success($dryRun ? 'Dry-run completed' : 'Completed');
        return 0;
    }
}
```
