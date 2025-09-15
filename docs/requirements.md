# DLZAP Technical Requirements

## Video Processing Specifications

### 1. WhatsApp Video Specs
**Question:** What exact format/codec should we target?
**Requirement:** 
- Output format: MP4 container
- Video codec: H.264 (libx264)
- Audio codec: AAC
- Additional flags: `+faststart` for web optimization
- Mobile resolution: 720p max (1280x720) to reduce file size
- Complete ffmpeg command template:
```bash
ffmpeg -i "input_file" -c:v libx264 -c:a aac -vf "scale='min(1280,iw)':min(720,ih):force_original_aspect_ratio=decrease" -movflags +faststart "output_file.mp4"
```

### 2. File Naming Strategy
**Question:** How should we name output files? Video title? URL hash? Timestamp?
**Requirement:**
- Primary: Use video title from yt-dlp metadata, sanitized for filesystem
- Sanitization: Remove/replace characters: `< > : " | ? * /` with `_`
- Fallback: If title unavailable, use format: `video_YYYYMMDD_HHMMSS`
- Extension: Always `.mp4`
- Example: `My Awesome Video.mp4` or `video_20231215_143022.mp4`

### 3. Overwrite Behavior
**Question:** What should happen if a file already exists? Skip existing files? Overwrite? Auto-rename?
**Requirement:**
- If file exists: Skip download, display message, exit with code 0
- Message format: `File already exists: {filename}. Skipping download.`
- Copy existing file to clipboard (since user wanted it)
- No auto-rename or overwrite

### 4. Output Verbosity
**Question:** Should the script run silently or show progress/status messages?
**Requirement:**
- Show progress messages to stdout:
  - `downloading {url}...`
  - `converting {title}...`
  - `done! {title} copied to clipboard.`
- Silence yt-dlp and ffmpeg stdout (redirect to /dev/null)
- On error, show stderr from failed command:
  - `error downloading video: {stderr}`
  - `error converting video: {stderr}`
- Exit codes: 0 = success, 1 = error

### 5. Installation Method
**Question:** How should users install dlzap? Just copy to PATH or something more structured?
**Requirement:**
- Manual installation: Copy `dlzap` script to directory in `$PATH`
- Suggested location: `/usr/local/bin/dlzap`
- Make executable: `chmod +x dlzap`
- Dependencies: User must install `yt-dlp` and `ffmpeg` separately

### 6. Basic CLI Support
**Question:** Should we support `dlzap --help` and `dlzap --version`?
**Requirement:**
- `dlzap --help`: Show usage instructions and exit
- `dlzap --version`: Show version number and exit
- `dlzap` (no args): Execute main functionality
- Invalid args: Show error and usage, exit with code 1 

## Smaller Implementation Details

### 7. Temporary Files
**Question:** Where should we store files during processing? How to clean up on failure?
**Requirement:**
- Store all files in `$DLZAP_DOWNLOAD_DIR` during processing
- On failure: Delete incomplete files (downloaded but not converted)
- On success: Keep final converted MP4 file
- Use trap to ensure cleanup on script interruption (Ctrl+C)

### 8. URL Validation
**Question:** Should we validate clipboard content before attempting download?
**Requirement:**
- No pre-validation of clipboard content
- Let yt-dlp handle URL validation and fail if invalid
- Forward yt-dlp error messages to user
- Basic check: Ensure clipboard is not empty

### 9. WhatsApp Limits
**Question:** Should we enforce file size/duration limits that WhatsApp accepts?
**Requirement:**
- Convert to mobile-friendly resolution (720p max) via ffmpeg
- No hard file size or duration limits enforced by script
- Let WhatsApp handle rejection of oversized files
- Scale video maintaining aspect ratio: `scale='min(1280,iw)':min(720,ih):force_original_aspect_ratio=decrease`  

### 10. Error Messages
**Question:** How detailed should error messages be?
**Requirement:**
- Show which step failed: `error downloading video:` or `error converting video:`
- Include stderr from failed command (yt-dlp/ffmpeg/filesystem)
- For missing dependencies: `error: yt-dlp not found. Please install yt-dlp.`
- For empty clipboard: `error: no URL found in clipboard`
- Keep error messages concise but actionable

---

## My Initial Suggestions (for reference):
- WhatsApp format: H.264/AAC in MP4 (most compatible)
- Naming: Sanitized video title with timestamp fallback
- Overwrite: Skip existing (fail fast principle) 
- Verbosity: Minimal progress output
- Installation: Simple copy-to-PATH approach

**My Notes about your suggestions**:
I answered everything before reading your suggestions. Coincidentally I choose
the same as you suggested without knowing your suggestions. Seems we're getting
along well :)

## Implementation Notes
### Clipboard Copy (macOS)
During implementation, discovered that `pbcopy` copies file path as text, not the actual file. WhatsApp needs the actual file in clipboard to recognize it as a video.

**Solution**: Use AppleScript via osascript:
```bash
osascript -e 'tell application "Finder" to set the clipboard to (POSIX file "'"$output_file"'")'
```
This mimics dragging from Finder and allows WhatsApp to paste the video directly.
