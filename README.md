# LightCraft für Unraid

Inoffizielles Docker-Image von [LightCraft](https://github.com/storytold/lightcraft) – die native Linux-Version läuft auf dem LinuxServer-Selkies-Basisimage und wird in den Browser gestreamt. Katalog, Vorschauen und XMP-Dateien liegen auf dem Server.

**Image:** `ghcr.io/michaelbar91/lightcraft-unraid:latest`

Ein GitHub-Workflow prüft täglich, ob es eine neue LightCraft-Version gibt, und baut das Image dann neu (Tags `latest` und die Versionsnummer). Manuell: *Actions → Image bauen → Run workflow*.

## Unraid

1. Vorlage auf den Server kopieren:
   ```
   wget -O /boot/config/plugins/dockerMan/templates-user/my-lightcraft.xml \
     https://raw.githubusercontent.com/Michaelbar91/lightcraft-unraid/main/unraid/my-lightcraft.xml
   ```
2. Docker-Tab → **Add Container** → Template **lightcraft** → Passwort eintragen → **Apply**.
3. Aufruf: `https://<Unraid-IP>:3443`

Updates erscheinen im Docker-Tab als „Update ready“.

## Wichtige Einstellungen

| Variable | Wert | Zweck |
|---|---|---|
| `LIGHTCRAFT_WAYLAND` | `1` | LightCraft nativ unter Wayland statt XWayland – sonst unscharf bei HiDPI |
| `SELKIES_ENCODER` | `jpeg,h264enc` | JPEG mit Nachzeichnen in Qualität 100 für scharfe Schrift |
| `SELKIES_USE_CSS_SCALING` | `false` | HiDPI statt hochskaliertem Bild |

Volumes: `/config` (Einstellungen und Katalog), `/photos` (Fotos, beschreibbar für XMP). Gerät: `/dev/dri` für die Intel-iGPU.
