# addons-mcp

Ein Repository, das Verweise auf meine wichtigsten privaten REDAXO CMS Add-ons enthält, um sie in einem MCP-Server nutzen zu können.

## Über dieses Repository

Dieses Repository verwendet Git Submodules, um auf private GitHub-Repositories zu verweisen, ohne deren Inhalte direkt hier zu speichern. Die eigentlichen Dateien bleiben in den privaten Repositories und werden nur lokal auf deinem Rechner geladen.

## Enthaltene Add-ons

- **neues** - `alexplusde/neues`
- **events** - `alexplusde/events`
- **maintenance** - `alexplusde/maintenance`

## Erstmaliges Klonen mit GitHub Desktop

1. Öffne GitHub Desktop
2. Klone dieses Repository (`alexplusde/addons-mcp`)
3. **Wichtig**: Das Klonen lädt zunächst nur die Verweise auf die Submodules, nicht deren Inhalte
4. Öffne ein Terminal im Repository-Ordner
5. Führe **zwingend** einen der folgenden Befehle aus, um die Submodules zu initialisieren und deren Inhalte zu laden:

### Windows (PowerShell):
```powershell
.\update-submodules.ps1
```

### macOS/Linux (Bash):
```bash
./update-submodules.sh
```

### Alternativ (Git-Befehl):
```bash
git submodule update --init --recursive
```

## Submodules aktualisieren

Um alle enthaltenen Add-ons auf den neuesten Stand zu bringen:

### Windows (PowerShell):
```powershell
.\update-submodules.ps1
```

### macOS/Linux (Bash):
```bash
./update-submodules.sh
```

### Alternativ (Git-Befehl):
```bash
git submodule update --remote --merge
```

## Wichtige Hinweise

- **SSH-Zugriff erforderlich**: Die Submodules verwenden SSH-URLs (`git@github.com:...`). Stelle sicher, dass du SSH-Keys für GitHub eingerichtet hast.
- **Private Repositories**: Du benötigst Zugriff auf die referenzierten privaten Repositories.
- **Lokale Dateien**: Die Dateien der Submodules werden nur lokal geladen und nicht in diesem Repository gespeichert.
- **Automatische Updates**: Die Skripte holen automatisch die neuesten Änderungen aus den Submodules.

## SSH-Keys einrichten

Falls du noch keine SSH-Keys für GitHub eingerichtet hast:

1. [GitHub SSH-Keys Anleitung](https://docs.github.com/de/authentication/connecting-to-github-with-ssh)
2. Generiere einen SSH-Key: `ssh-keygen -t ed25519 -C "deine-email@example.com"`
3. Füge den Public Key zu deinem GitHub-Konto hinzu

## Technische Details

Die Konfiguration der Submodules findest du in der Datei `.gitmodules`. Git speichert in diesem Repository nur die Verweise (Commits) auf die Submodules, nicht deren Inhalte.
