# localsend-cli

A zero-dependency Python CLI for [LocalSend](https://localsend.org) — send and receive files between devices on your local network. No app store, no cloud, no accounts.

Works with any device running LocalSend (Android, iOS, Windows, macOS, Linux).

## Install

**One-liner (Linux & macOS):**

```bash
curl -fsSL https://raw.githubusercontent.com/Chordlini/localsend-cli/master/install.sh | bash
```

The installer auto-detects your OS and puts the CLI in the right place:

| OS | Install location | Dependencies |
|----|-----------------|--------------|
| **macOS** | `/usr/local/bin/localsend-cli` | Python 3.8+, openssl (both included with macOS) |
| **Linux** | `~/.local/bin/localsend-cli` | Python 3.8+, openssl |

**Manual install:**

```bash
# macOS
curl -fsSL https://raw.githubusercontent.com/Chordlini/localsend-cli/master/localsend-cli -o /usr/local/bin/localsend-cli
chmod +x /usr/local/bin/localsend-cli

# Linux
mkdir -p ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/Chordlini/localsend-cli/master/localsend-cli -o ~/.local/bin/localsend-cli
chmod +x ~/.local/bin/localsend-cli
```

## Usage

### Discover devices

```bash
localsend-cli discover -t 2
```

```
Scanning for 2.0s...

Found 2 device(s):

  Fast Potato
    IP: 192.168.0.148:53317 (https)
    Type: desktop, Model: macOS, Protocol: v2.1

  omarchy
    IP: 192.168.0.110:53317 (https)
    Type: headless, Model: Linux, Protocol: v2.0
```

JSON output for scripting:

```bash
localsend-cli discover --json -t 2
```

### Send files

```bash
# Send a single file
localsend-cli send --to "Fast Potato" photo.jpg

# Send multiple files
localsend-cli send --to "Fast Potato" file1.txt file2.pdf image.png

# Device name is case-insensitive substring match
localsend-cli send --to "potato" photo.jpg
```

### Receive files

```bash
# Start listening (auto-accept all transfers)
localsend-cli receive -y --save-dir ~/Downloads

# With a custom device name
localsend-cli --alias "My Server" receive -y --save-dir ~/incoming
```

Press `Ctrl+C` to stop the receiver.

## Flags

| Flag | Scope | Description |
|------|-------|-------------|
| `--alias NAME` | **Global** (before subcommand) | Device name to advertise on the network |
| `--to NAME` | `send` | Target device (case-insensitive substring match) |
| `-t N` | `discover` | Scan duration in seconds (default: 3) |
| `--json` | `discover` | Machine-readable JSON output |
| `--save-dir DIR` | `receive` | Where to save received files (default: `~/Downloads`) |
| `-y` | `receive` | Auto-accept all incoming transfers |

> **Note:** `--alias` is a global flag and MUST come before the subcommand:
> ```bash
> # Correct
> localsend-cli --alias "My PC" receive -y
>
> # Wrong — will error
> localsend-cli receive --alias "My PC" -y
> ```

## How it works

- Uses the [LocalSend v2 protocol](https://github.com/localsend/protocol)
- Discovers devices via UDP multicast on `224.0.0.167:53317`
- Transfers files over HTTPS with self-signed TLS certificates
- Zero dependencies beyond Python stdlib + `openssl`
- Single-file script — no pip install needed

## Integration

This CLI is used by the [Curtis Bot](https://github.com/Chordlini/curtis-bot) LocalSend skill for OpenClaw, enabling file transfers between your phone and server via Telegram buttons.

Install the OpenClaw skill:
```bash
npx clawhub install localsend
```

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `unrecognized arguments: --alias` | Move `--alias` BEFORE the subcommand |
| No devices found | Open LocalSend on target device, same WiFi, screen on |
| Port 53317 in use | Normal — CLI auto-falls back to 53318/53319 |
| Transfer declined (403) | Use `-y` flag on the receiver side |
| Transfer hangs | Large file on slow WiFi — wait it out |
| `openssl: command not found` | Install OpenSSL: `sudo apt install openssl` or `brew install openssl` |

## License

MIT
