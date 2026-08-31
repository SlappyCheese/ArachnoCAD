# 🕷️ ArachnoCAD

**Spider Web Construction Planner & Cut Sheet Generator**

A Windows PowerShell GUI tool for calculating rope lengths, generating visual layouts, and exporting printable cut sheets for giant outdoor spider web decorations. Perfect for Halloween haunts, themed events, or any décor project requiring precise web geometry.

---

## ✨ Features

- **Dual Shape Support**: Circular (Center Hub) or Triangular (Corner/Porch) designs
- **Real-Time Preview**: Visual canvas updates as you adjust parameters
- **Intelligent Calculations**: Auto-calculates rope lengths with 20% safety margin
- **Cut Sheet Export**: Generates printable HTML with measurements and assembly guide
- **Share Codes**: Hex-encoded design strings for easy sharing (e.g., `W-A5C3F`)
- **Clove Hitch Guide**: Built-in SVG diagram for proper knot tying
- **Responsive UI**: Sliders and numeric inputs with validation

---

## Screenshots

### Circular Web Design
![Circular Web Preview](https://via.placeholder.com/600x400?text=Circular+Web+Design)
*Real-time preview of a circular web with concentric rings and radial spokes*

### Triangular Web Design
![Triangular Web Preview](https://via.placeholder.com/600x400?text=Triangular+Web+Design)
*Corner/porch-style triangular web with horizontal weave lines*

### HTML Export - Cut Sheet
![HTML Cut Sheet Export](https://via.placeholder.com/600x400?text=HTML+Cut+Sheet)
*Printable cut sheet with itemized rope list and assembly instructions*

---

## Requirements

- **Windows 10+** (any edition)
- **PowerShell 5.0+** (included with Windows)
- **.NET Framework 3.5+** (for Windows.Forms, included with Windows)
- No additional dependencies or installation required

---

## Quick Start

1. **Clone or download** `ArachnoCAD.ps1` to your computer
2. **Right-click** the file → **Run with PowerShell** (or open PowerShell and run):
   ```powershell
   powershell -ExecutionPolicy Bypass -File "C:\path\to\ArachnoCAD.ps1"
   ```
3. **Choose your web shape** (Circular or Triangular)
4. **Adjust parameters** using sliders or numeric input:
   - **Diameter/Base**: Overall width of the web (feet)
   - **Height**: Vertical span (for triangular webs)
   - **Spacing**: Distance between rings or weave lines (feet)
   - **Spokes**: Number of radial lines
5. **Review the cut sheet** → Click **Print Plan** to generate HTML export
6. **Share designs** → Copy the Share Code and send to collaborators

---

## How to Measure

📐 **Pro Tip**: Set your web size **15–20% SMALLER** than the physical gap between your anchor points. This gives you extra space for:
- Tying anchor knots
- Tension adjustments
- Final structural lock-down

**Example**: If your porch is 10 feet wide, design a web ~8.5 feet wide.

---

## Web Geometry Explained

### Circular Webs (Center Hub)
- All spokes radiate from a central hub point
- Concentric rings create the classic orb-web pattern
- Ideal for trees, pergolas, or fence centers

### Triangular Webs (Corner/Porch)
- Spokes connect apex to base points
- Horizontal weave lines span the width
- Perfect for corner anchoring and porch gaps

---

## Assembly Instructions

The tool provides step-by-step guidance:

1. **Anchor the Frame**: Secure main structural lines (cross or triangle) first
2. **Set the Spokes**: Tie radial lines to center or apex
3. **Weave**: Tie ring/weave lines using **Clove Hitches** (see below)
4. **Final Tension**: Tighten master anchor lines to lock the structure

### The Clove Hitch Knot
The preferred knot for this project. It:
- Grips tightly under tension
- Allows fine-tuning by sliding along the spoke
- Holds reliably once locked

**How to tie**:
1. Wrap the cord over and around the spoke
2. Cross back over the first wrap to form an "X"
3. Wrap around the spoke once more
4. Tuck the end under the middle of the "X"
5. Pull both ends tight to lock

---

## Share Codes (Hex Encoding)

ArachnoCAD compresses all configuration into compact share codes:

**Format**: `W-XXXXXX` (hexadecimal)

**Example**: `W-A5C3F`

**Bit Layout**:
- Bits 0–5: Diameter (0–63 ft)
- Bits 6–11: Height (0–63 ft)
- Bits 12–16: Spacing × 10 (0–50 ft, stored as integer)
- Bits 17–20: Spokes (0–15)
- Bit 21: Shape (0=Circular, 1=Triangular)

**To decode**: Simply paste a share code into the config field and press Enter—the app auto-populates all parameters!

---

## Export Formats

### HTML Cut Sheet
- **Offline-ready**: Embeds web preview as base64 PNG
- **Print-friendly**: CSS media queries hide buttons when printing
- **Shareable**: Single-file format, no dependencies
- **Contents**:
  - Share code and specifications
  - Itemized cut list table
  - Visual web preview
  - Assembly step-by-step guide
  - Clove hitch SVG diagram

---

## UI Layout

The application features a split-panel design:

**Left Panel (Input Controls)**
- Shape selector dropdown
- Measurement tip box with emoji guidance
- Diameter / Base width control (slider + numeric input)
- Height control (triangular webs only)
- Spacing control (feet between rings/weaves)
- Spoke count control
- Configuration/share code field
- Print Plan button

**Right Panel (Canvas)**
- Real-time web preview
- Labeled measurements overlay
- Recommended anchor gap annotation

---

## Version History

### v1.2.0 (Current)
- Added shape selection (Circular & Triangular)
- Implemented hex-encoding share codes
- HTML export with embedded image support
- UI scaling and responsive design
- Integrated clove hitch knot guide
- Fixed mobile copy-paste artifacts

### v1.1.0
- Initial release with circular web support

---

## Troubleshooting

**"Cannot be loaded because running scripts is disabled"**
- Run PowerShell as Administrator
- Execute: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

**Preview not updating?**
- Ensure numeric inputs are within valid ranges (1–63 ft for dimensions)
- Check that spacing doesn't exceed web size

**HTML export won't open?**
- Try right-clicking the HTML file → Open with → Your preferred browser

**Share code won't decode?**
- Verify format: `W-` followed by exactly 6 hexadecimal characters (0–9, A–F)
- Ensure parameters are within valid ranges

---

## Tips & Tricks

🎯 **Start Simple**: Use default settings (20 ft diameter, 8 spokes) to familiarize yourself with the tool

🔄 **Test Scaling**: Create multiple designs with the same shape to compare rope consumption

📸 **Screenshot Codes**: Take screenshots of the Share Code field for documentation

🧵 **Material Prep**: Export several cut sheets for different web sizes to pre-cut rope before assembly

⚙️ **Spoke Count**: 
- 6–8 spokes = Classic appearance
- 10–12 spokes = Denser, more detailed web
- 16+ spokes = Intricate but rope-intensive

---

## How It Works (Technical)

ArachnoCAD uses **Windows Forms** (built-in .NET GUI framework) with:
- **GDI+ Graphics**: Anti-aliased rendering for smooth previews
- **Real-time Math**: Pythagorean calculations for spoke/weave lengths
- **Hex Encoding**: Bitwise operations compress 5 parameters into 22 bits
- **Base64 PNG Embedding**: Renders canvas to in-memory bitmap, converts to data URI for offline HTML support

---

## License

This project is provided as-is for personal and non-commercial use.

---

## Contributing

Found a bug or have a feature idea? Feel free to open an issue or submit a pull request!

---

**Happy Web Building! 🕷️🕸️**

*For questions or feedback, reach out via GitHub Issues.*
