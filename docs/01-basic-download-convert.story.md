# Story 1: Basic Download and Convert Workflow

## User Story
As a user, I want to run `dlzap` and have it automatically download the video URL from my clipboard, convert it to WhatsApp format, and copy the result back to my clipboard, so I can paste it directly into a WhatsApp chat.

## Planning
This is the core happy path workflow that implements the main functionality:

1. **Get URL from clipboard** using `pbpaste`
2. **Validate basic requirements** (clipboard not empty)  
3. **Download video** with `yt-dlp` to `$DLZAP_DOWNLOAD_DIR`
4. **Convert to WhatsApp format** with `ffmpeg` 
5. **Copy converted file** to clipboard with `pbcopy`
6. **Show progress messages** during each step
7. **Clean up** temporary files

### Implementation Details
- Use `pbpaste` to read clipboard content
- Create download directory if it doesn't exist
- Use yt-dlp to download, extract video title for filename
- Apply ffmpeg conversion per requirements.md section 1
- Use file naming strategy per requirements.md section 2
- Handle existing files per requirements.md section 3
- Show progress messages per requirements.md section 4

### Files to Create/Modify
- `dlzap` - main script
- `tests/test_helpers.sh` - test assertion functions
- `tests/test_dlzap.sh` - test for this story
- `tests/fixtures/` - test data directory

## Requirements Reference
This story implements:
- **Requirements.md Section 1**: WhatsApp Video Specs
- **Requirements.md Section 2**: File Naming Strategy  
- **Requirements.md Section 3**: Overwrite Behavior
- **Requirements.md Section 4**: Output Verbosity
- **Requirements.md Section 7**: Temporary Files
- **Requirements.md Section 8**: URL Validation

## Acceptance Criteria
- [ ] Script reads URL from clipboard
- [ ] Downloads video to correct directory
- [ ] Converts to H.264/AAC MP4 with mobile resolution
- [ ] Uses proper filename (title + .mp4 extension)
- [ ] Shows progress messages during operation
- [ ] Copies final video to clipboard
- [ ] Skips download if file already exists
- [ ] Exits cleanly on success

## Test Plan
- Test with valid YouTube URL in clipboard
- Test with existing file (should skip and copy)
- Test basic happy path end-to-end
- Mock yt-dlp and ffmpeg for deterministic tests