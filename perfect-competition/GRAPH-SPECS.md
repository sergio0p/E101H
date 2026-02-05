# Graph Specifications Reference

## SVG ViewBox & Coordinate System

```
viewBox="-45 -20 585 400"
```

- **Start**: (-45, -20) - extends left and up to accommodate labels
- **Width**: 585px (from x=-45 to x=540)
- **Height**: 400px (from y=-20 to y=380)

### Coordinate Conversion

```javascript
const xOrigin = 20;      // Y-axis position
const yOrigin = 350;     // X-axis position
const xScale = 470 / 150;  // ≈3.133 px per Q unit
const yScale = 2.46;       // px per P unit

toX(Q) = 20 + Q * 3.133
toY(P) = 350 - P * 2.46
```

### Axis Ranges

- **Q-axis**: 0 to 150
  - Starts at x=20, ends at x=490
  - Arrow ends at x=495

- **P-axis**: 0 to 140
  - Starts at y=350, ends at y=6
  - Arrow ends at y=6

## Axis Labels

### Position Conventions

- **P label**: (20, -2) - centered above Y-axis arrow
- **Q label**: (505, 355) - to the right of X-axis arrow

### Numeric Labels

- **Price labels** (on Y-axis):
  - x = -5 (25px left of Y-axis)
  - text-anchor = "end" (right-aligned)
  - Example: eq-p-label, atc-p-label

- **Quantity labels** (on X-axis):
  - y = 375 (25px below X-axis)
  - text-anchor = "middle" (centered)
  - Example: eq-q-label

## Color Scheme (Solarized Light for Graphs)

### Background
- Frame background: `#fdf6e3` (Solarized base3)

### Curves
- **Demand**: `#dc322f` (red)
- **Supply**: `#268bd2` (blue)
- **ATC**: `#859900` (green)

### Regions
- **Profits**: `#2aa198` (cyan), opacity 0.4
- **Losses**: `#d33682` (magenta), opacity 0.4

### Lines & Axes
- **Axes**: `#586e75` (base01), stroke-width: 3
- **Dotted lines**: `#586e75`, stroke-dasharray: 8,6

### Text
- **Labels**: `#586e75`, font-size: 20-24px
- **Curve labels**: match curve color

## Curve Label Positioning

### Static Labels
- **D (Demand)**: (455, 268) - near lower-right end of demand curve
- **ATC**: (415, 20) - near upper-right end of ATC curve

### Dynamic Labels
- **S (Supply)**: Follows supply curve endpoint
  ```javascript
  labelX = xOrigin + 0.8 * (supplyEndX - xOrigin)
  labelY = yOrigin + 0.8 * (supplyEndY - yOrigin) - 30
  ```
  Positioned at 80% of curve length, 30px above

## Animation Timeline Structure

### Total Scroll Distance
- `end: '+=680%'` of viewport height

### Phase Breakdown

| Phase | Timeline Start | Duration | Description |
|-------|---------------|----------|-------------|
| 1 | 0 | 1.0 | Equilibrium dotted lines |
| 2 | 1.0-2.0 | - | Pause/delay |
| 3 | 2.0 | 1.0 | ATC curve draws |
| 3b | 3.0 | - | ATC label appears |
| 4 | 3.5 | 0.8 | ATC horizontal line |
| 4b | 4.0 | 0.3 | ATC price label |
| 5 | 4.3 | 1.0 | Profit/loss rectangle fills |
| 5b | 5.0 | 0.3 | Profit/loss label |
| 6 | 5.8 | 2.0 | Supply curve shift (k animation) |
| 7 | 7.8+ | - | Delay before unpin |

### Animation Easing
- All animations use `ease: 'none'` for linear progression with scroll

## Economic Model Parameters

### Current Implementation

```javascript
// Demand: P = demandIntercept - demandSlope * Q
const demandIntercept = 120;
const demandSlope = 0.5;

// Supply (MC): P = supplyIntercept + supplySlope * k * Q
const supplyIntercept = 5;
const supplySlope = 2;

// ATC: ATC = atcFixed/Q + atcConstant + atcLinear * Q
const atcFixed = 100;
const atcConstant = 5;
const atcLinear = 1;

// Supply shift parameter
const kInitial = 1;      // Q*=46, P*=97
const kFinal = 11/48;    // ≈0.229, Q*=120, P*=60
```

### Equilibrium Calculations

At any k:
```javascript
Q* = (demandIntercept - supplyIntercept) / (demandSlope + supplySlope * k)
P* = supplyIntercept + supplySlope * k * Q*
ATC(Q*) = atcFixed / Q* + atcConstant + atcLinear * Q*
```

## ATC Curve Drawing

### Approach
- Hand-crafted SVG path using:
  - Cubic Bézier curves (C) for smooth sections
  - Line segments (L) for detailed sections

### Critical Region Detail
Extra points in Q=10 to Q=23 range (near minimum):
- Q=10, 12, 14, 16, 18, 20, 23
- Uses straight line segments (L) for accuracy

### Key Points
```
Q=2:   ATC=57    (x=26,  y=210)
Q=10:  ATC=25    (x=51,  y=288) - minimum
Q=20:  ATC=30    (x=83,  y=276)
Q=46:  ATC=51    (initial equilibrium)
Q=120: ATC=130.8 (final equilibrium)
Q=125: ATC=130.8 (x=412, y=28) - near top
```

## CSS Specifications

### Graph Container
```css
.graph-frame {
  min-height: 100vh;
  padding: 0;
  background: #fdf6e3;
}
```

### SVG Sizing
```css
#equilibrium-graph {
  max-width: 700px;
  width: 100%;
}
```

## Text Styling

### Axis Labels
```css
.axis-label {
  font-family: 'Times New Roman', serif;
  font-size: 24px;
  font-style: italic;
  fill: #586e75;
}
```

### Equilibrium Labels
```css
.eq-label {
  font-family: 'Times New Roman', serif;
  font-size: 20px;
  font-style: italic;
  fill: #586e75;
}
```

### Profit/Loss Label
- font-weight: bold
- fill: #fdf6e3 (light text on colored background)
- text-anchor: middle
- Centered in rectangle

## Label Spacing Conventions

- **Y-axis price labels**: 25px left of axis (at x=-5)
- **X-axis quantity labels**: 25px below axis (at y=375)
- **Curve labels**:
  - Supply: 30px above curve at 80% point
  - Demand: positioned near endpoint
  - ATC: positioned near endpoint

## Dynamic Elements (Created in JavaScript)

1. **ATC horizontal line** (`atc-line-h`)
2. **ATC price label** (`atc-p-label`)
3. **Profit/loss rectangle** (`profit-rect`)
4. **Profit/loss label** (`profit-label`)
5. **Supply curve label** (`supply-label`)

## Notes for Future Slides

1. **Consistency**: Use same viewBox dimensions and coordinate system across all graphs
2. **Colors**: Maintain Solarized Light palette for all economic graphs
3. **Spacing**: Use 25px spacing convention for all axis labels
4. **Animation timing**: Keep phase durations similar for consistent feel
5. **Text styling**: Use Times New Roman italic for all mathematical labels
6. **Label positioning**: Dynamic labels should update in `updateForK()` function
7. **Curve drawing**: Use line segments (L) for regions needing precision, Bézier (C) for smooth sections

## File Structure

```
101h-perfect-competition/
├── index.html              # Main HTML with embedded SVG and animations
├── css/
│   └── beamer-theme.css    # Theme styling
├── js/
│   ├── katex-macros.js     # Math rendering macros
│   └── scroll-animations.js # General animation utilities
├── svg/                    # (future: external SVG files)
└── GRAPH-SPECS.md          # This file
```

## Testing Checklist

When creating new graph slides:
- [ ] Labels don't clip at viewBox boundaries
- [ ] 25px spacing maintained for axis labels
- [ ] Curve colors match Solarized palette
- [ ] Animation phases have clear pauses between them
- [ ] Dynamic elements update smoothly during animation
- [ ] Text is readable at all scroll positions
- [ ] Graph works on mobile (test at 768px width)
- [ ] Print/PDF export shows final state cleanly
