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

## Side Comments (Slide-In Annotations)

Side comments are supplementary notes that slide in from the edge of the screen, remain visible briefly, then slide back out. Useful for comparisons, definitions, or tangential information.

### CSS

```css
.side-comment {
  position: fixed;
  top: 50%;
  right: -500px;              /* Start off-screen */
  transform: translateY(-50%); /* Vertical centering */
  width: 350px;
  padding: 1.5rem;
  background: #fff8e1;        /* Light yellow */
  border-left: 4px solid var(--crane-amber);
  border-radius: 8px;
  box-shadow: -8px 8px 30px rgba(0,0,0,0.25), -4px 4px 15px rgba(0,0,0,0.15);
  font-size: 0.95rem;
  line-height: 1.6;
  z-index: 100;
  opacity: 0;
}

.side-comment-title {
  font-weight: bold;
  color: var(--crane-amber);
  margin-bottom: 0.5rem;
  font-size: 0.85rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}
```

### HTML

```html
<section class="scroll-frame" id="my-frame">
  <div class="scroll-frame-inner">
    <!-- Main content -->
  </div>

  <!-- Side comment (inside section, outside scroll-frame-inner) -->
  <div class="side-comment" id="my-side-comment">
    <div class="side-comment-title">Compare: Something</div>
    Your annotation text here...
  </div>
</section>
```

### GSAP Animation

```javascript
const tl = gsap.timeline({
  scrollTrigger: {
    trigger: '#my-frame',
    start: 'top top',
    end: '+=300%',
    pin: true,
    scrub: 1
  }
});

// Slide in from right
tl.to('#my-side-comment', {
  right: 20,           /* Final position: 20px from right edge */
  opacity: 1,
  duration: 1,
  ease: 'power2.out'
}, 2);

// Slide out to right (after a pause)
tl.to('#my-side-comment', {
  right: -500,         /* Back off-screen */
  opacity: 0,
  duration: 1,
  ease: 'power2.in'
}, 3.5);

// Set initial state
gsap.set('#my-side-comment', { opacity: 0, right: -500 });
```

### Tips

- Use `position: fixed` so the comment stays in place while main content scrolls
- The comment should be a sibling of `.scroll-frame-inner`, not inside it
- Add a gap between slide-in and slide-out (e.g., timeline positions 2 and 3.5) to give users time to read
- Use `ease: 'power2.out'` for slide-in (decelerates) and `ease: 'power2.in'` for slide-out (accelerates)

## Horizontal Scroll Transitions Between Graphs

To create a horizontal "page turn" effect between two graphs (e.g., showing equivalent perspectives), use absolutely positioned panels animated with GSAP.

### HTML Structure

```html
<section class="scroll-frame graph-frame" id="my-graph-frame">
  <!-- Primary graph (starts visible) -->
  <div class="scroll-frame-inner" style="background: #fdf6e3;">
    <svg id="primary-graph" viewBox="0 0 530 395" style="max-width: 640px; width: 100%;">
      <!-- Graph content -->
    </svg>
  </div>

  <!-- Secondary graph panel (starts off-screen) -->
  <div id="secondary-panel" style="position: absolute; left: -100%; top: 0; width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; background: #fdf6e3;">
    <svg id="secondary-graph" viewBox="0 0 530 395" style="max-width: 640px; width: 100%;">
      <!-- Graph content -->
    </svg>
  </div>
</section>
```

Key points:
- Secondary panel starts at `left: -100%` (off-screen to the left)
- Both panels have `width: 100%` and `height: 100%`
- Use `position: absolute` for the secondary panel

### GSAP Animation

```javascript
const tl = gsap.timeline({
  scrollTrigger: {
    trigger: '#my-graph-frame',
    start: 'top top',
    end: '+=900%',  // Long scroll distance for multi-phase animation
    pin: true,
    scrub: 1,
    anticipatePin: 1
  }
});

// ... earlier animation phases ...

// Horizontal scroll transition (at timeline position 5)
// Direction: left-to-right (secondary slides in from left, primary exits right)
tl.to('#secondary-panel', { left: '0%', duration: 1, ease: 'none' }, 5);
tl.to('#primary-graph', { x: '100vw', duration: 1, ease: 'none' }, 5);
```

### Direction Variants

**Left-to-right** (new content enters from left):
```javascript
// Secondary starts at left: -100%, animates to left: 0%
// Primary animates x: 0 → 100vw
tl.to('#secondary-panel', { left: '0%', duration: 1 }, 5);
tl.to('#primary-graph', { x: '100vw', duration: 1 }, 5);
```

**Right-to-left** (new content enters from right):
```javascript
// Secondary starts at left: 100%, animates to left: 0%
// Primary animates x: 0 → -100vw
gsap.set('#secondary-panel', { left: '100%' });  // Initial position
tl.to('#secondary-panel', { left: '0%', duration: 1 }, 5);
tl.to('#primary-graph', { x: '-100vw', duration: 1 }, 5);
```

### Coordinating State with Transitions

Disable/enable interactive features during transitions:

```javascript
let primaryNavEnabled = false;
let secondaryNavEnabled = false;

// Disable primary nav when transition starts
tl.call(() => { primaryNavEnabled = false; }, [], 5);

// Enable secondary nav after transition completes
tl.call(() => { secondaryNavEnabled = true; }, [], 6);

// Also handle scroll direction changes
scrollTrigger: {
  onLeave: () => { secondaryNavEnabled = false; },
  onEnterBack: () => { secondaryNavEnabled = true; }
}
```

### CSS Requirements

```css
.graph-frame {
  overflow: hidden;  /* Hide off-screen panels */
}

.graph-frame .scroll-frame-inner {
  position: relative;  /* Positioning context for absolute panels */
}
```

## Inserting KaTeX Labels into SVG Figures

SVG `<text>` elements don't support KaTeX rendering directly. To display properly typeset math labels (subscripts, fractions, etc.) alongside SVG graphics, use **absolutely positioned HTML divs** outside the SVG.

### Method

1. **Wrap the SVG in a container with `position: relative`**:
   ```html
   <div class="scroll-frame-inner" style="position: relative;">
     <!-- KaTeX labels go here, outside the SVG -->
     <div id="my-katex-label" style="position: absolute; font-size: 0.9rem; color: #586e75;">
       $P_B=$
     </div>

     <svg id="my-graph" viewBox="0 0 530 395">
       <!-- SVG content -->
     </svg>
   </div>
   ```

2. **Calculate screen positions from SVG coordinates**:
   ```javascript
   function positionKatexLabel(svgId, labelId, svgX, svgY) {
     const svg = document.getElementById(svgId);
     const svgRect = svg.getBoundingClientRect();
     const container = svg.parentElement;
     const containerRect = container.getBoundingClientRect();

     // SVG viewBox dimensions (e.g., "0 0 530 395")
     const viewBoxWidth = 530;
     const viewBoxHeight = 395;
     const scaleX = svgRect.width / viewBoxWidth;
     const scaleY = svgRect.height / viewBoxHeight;

     // Convert SVG coords to screen coords relative to container
     const screenX = (svgRect.left - containerRect.left) + svgX * scaleX;
     const screenY = (svgRect.top - containerRect.top) + svgY * scaleY;

     const label = document.getElementById(labelId);
     label.style.left = screenX + 'px';
     label.style.top = (screenY - 8) + 'px';  // Adjust for vertical centering
   }
   ```

3. **Render KaTeX on page load** (with required options):
   ```javascript
   document.addEventListener('DOMContentLoaded', function() {
     // KaTeX options - REQUIRED for renderMathInElement to work
     const katexOptions = {
       delimiters: [
         {left: '$$', right: '$$', display: true},
         {left: '$', right: '$', display: false}
       ],
       throwOnError: false
     };

     const label = document.getElementById('my-katex-label');
     if (typeof renderMathInElement !== 'undefined') {
       renderMathInElement(label, katexOptions);  // Must pass options!
     }
   });
   ```

4. **Update positions dynamically** when values change or window resizes:
   ```javascript
   window.addEventListener('resize', updateLabelPositions);
   ```

### Example: Y-Axis Price Labels with Subscripts

For labels like "$P_B=$" and "$P_S=$" next to numeric values on the y-axis:

```html
<!-- Outside SVG, inside relative container -->
<div id="pb-katex" style="position: absolute; font-size: 0.9rem; color: #586e75;">
  $P_B=$
</div>
<div id="ps-katex" style="position: absolute; font-size: 0.9rem; color: #586e75; opacity: 0;">
  $P_S=$
</div>

<!-- SVG keeps numeric labels only -->
<svg viewBox="0 0 530 395">
  <text id="pb-num" x="50" y="200" text-anchor="end" font-size="16">130</text>
  <text id="ps-num" x="50" y="260" text-anchor="end" font-size="16">90</text>
</svg>
```

Then position the KaTeX labels at approximately x=5 (far left of SVG) at the same y-coordinates as the numeric labels.

### Why This Approach?

- **SVG text limitations**: SVG `<text>` can't render complex math (only plain text, basic tspan for subscripts)
- **KaTeX requires DOM**: KaTeX transforms `$...$` into HTML/CSS spans, which don't work inside SVG
- **foreignObject alternative**: `<foreignObject>` can embed HTML in SVG but has browser quirks and positioning issues
- **Clean separation**: Keeping KaTeX outside SVG maintains clean, debuggable code

### Tips

- Use `white-space: nowrap` on KaTeX divs to prevent line breaks
- Adjust vertical centering with small offsets (e.g., `top - 8px`)
- Match font-size to nearby SVG text (typically 0.9rem ≈ 16px)
- Use Solarized `#586e75` for consistent text color

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
