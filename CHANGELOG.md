## [1.0.0] - 2024-12-11
### 🎉 Initial Release
- **Analyze Text Files**:
  - Display total word count.
  - Count unique words.
  - Identify the most frequent word and its occurrence.
- **Search Words**:
  - Search for a specific word and display how many times it appears in the text.
- **Generate Random Word File**:
  - Create a file with 1,000 random words and save it locally.
- **Real-time Progress**:
  - Show a progress indicator while analyzing large files.
- **Export Results**:
  - Option to save the analysis results to a `.txt` file.
- **File Handling**:
  - Integrated `file_picker` for selecting text files.
  - Used `path_provider` for saving files to the local storage.
- **Performance Optimization**:
  - Implemented **Isolates** for parallel processing of text, ensuring the main UI remains responsive.
- **User Interface**:
  - Clean and responsive design for selecting files and displaying analysis.
  - Validated input for the search field to prevent invalid operations.

### 🐛 Bug Fixes
- Fixed crashes when selecting an empty file.
- Addressed incorrect word counts for case-sensitive matches (e.g., `Word` vs. `word`).
- Improved error handling for file read/write operations.
- Resolved issues with displaying file paths on certain devices.