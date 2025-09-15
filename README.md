# dlzap

Download video from clipboard, convert for WhatsApp, copy to clipboard.

## Installation

1. Install dependencies:
```bash
brew install yt-dlp ffmpeg
```

2. Install dlzap:
```bash
curl -o /usr/local/bin/dlzap https://raw.githubusercontent.com/yourusername/dlzap/main/dlzap
chmod +x /usr/local/bin/dlzap
```

## Usage

1. Copy a video URL to clipboard
2. Run `dlzap`
3. Paste converted video into WhatsApp

Videos are saved to `~/Downloads/dlzap/`

## Requirements

- macOS
- yt-dlp
- ffmpeg