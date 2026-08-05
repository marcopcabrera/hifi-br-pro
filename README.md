# 💿 HiFi BR Pro (v4.0)

**HiFi BR Pro** is an automated Bash script designed to build **100% standard Hi-Res Audio Blu-ray ISOs (BDMV)** from your lossless audio collections (FLAC, WAV, ALAC, APE, AIFF, etc.).

By strictly adhering to official Blu-ray specifications without binary hacks, it ensures seamless playback and maximum compatibility across hardware Blu-ray players, AV receivers, PlayStation consoles (PS3/PS4/PS5), and media players like VLC.

---

## ✨ Features

* **True Hi-Res Audio:** Handles 24-bit PCM audio at 48 kHz, 96 kHz, and 192 kHz sample rates.
* **Multilingual UI (i18n):** Automatically detects system language with native support for **9 languages** (English, Spanish, Catalan, Basque, Galician, Portuguese, German, French, and Italian).
* **Millisecond Chapter Mapping:** Generates precise chapter markers mapped directly to track boundaries via `.meta` configuration files.
* **EBU R128 Normalization (Optional):** Loudness matching across tracks to prevent jarring volume jumps without compressing dynamic range.
* **Continuous H.264 Video Stream:** Renders a clean 1080p static video stream generated from your album cover art.
* **Built-in Safety Checks:** Verifies minimum cover resolution (1080p minimum), checks available disk space prior to processing, and handles automatic cleanup of temporary files via `trap`.

---

## 📋 Requirements

Ensure the following tools are installed on your system and available in your `PATH`:

* `ffmpeg` & `ffprobe`
* `genisoimage` (or `mkisofs`)
* `python3`
* `tsMuxeR` *(Must be in your `PATH` or located at `~/.local/bin/tsmuxer`)*

### Installing Dependencies

**Debian / Ubuntu:**
```bash
sudo apt update
sudo apt install ffmpeg genisoimage python3
```

**Arch Linux:**
```bash
sudo pacman -S ffmpeg cdrkit python
```

---

## 🚀 Quick Start

1. Place your audio files and an album cover image (`cover.jpg` or `cover.png`, min. 1080x1080) in the same directory as the script.
2. Make the script executable:
```bash
chmod +x hifi_br_pro.sh
```
3. Run the script:
```bash
./hifi_br_pro.sh
```
4. Follow the interactive prompts to choose your audio sample rate, volume normalization preference, and output ISO filename.

---

## 📄 License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.
