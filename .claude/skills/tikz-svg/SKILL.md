---
name: tikz-svg
description: SVG automata, node-edge diagrams, and callouts for lecture pages using the tikz-svg JS library. Use when adding state-machine diagrams, decision/game trees, or callout annotations.
---

# tikz-svg Library

Pure JavaScript library hosted at `https://sergio0p.github.io/tikz-svg/` (source: `/Users/sergioparreiras/Dropbox/Scripts/tikz-svg/`). Renders TikZ/PGF graphics as SVG. No LaTeX required. Always import from the GitHub Pages URL so it works both locally and when deployed.

**IMPORTANT: Always use the v2 render pipeline.** Import `render` from `src-v2/index.js`, never from `src/index.js`. The v1 pipeline (`src/index.js`) does not auto-size nodes to fit label text. `renderAutomaton()` internally delegates to v2.

**Coordinate convention for `xshift`/`yshift`:** These use **SVG coordinates** (y-down), not TikZ convention. `xshift: 50` = right, `yshift: 50` = **down**, `yshift: -50` = **up**. This differs from TikZ where positive y is up. Directional positions (`above`, `below`, `left`, `right`) follow TikZ naming but map to SVG internally.

**Local preview requires an HTTP server.** ES module imports (`import { render } from '...'`) are blocked over `file://` URLs. Before previewing, start a server:

```bash
python3 -m http.server 8080 --directory /Users/sergiop/Dropbox/Teaching/Projects/LECWeb &>/dev/null &
```

Then open pages via `http://localhost:8080/...` instead of `file:///...`.

## What it provides

1. **Automata** — finite state machines, DFAs, Turing machines via `renderAutomaton()`
2. **Inline SVG diagrams** — decision trees, game trees, asset return trees (hand-written SVG, no JS dependency)
3. **Callouts** — rectangle and ellipse speech-bubble annotations for graphs

---

## Automata: `renderAutomaton()`

### Loading

```html
<script type="module">
  import { renderAutomaton } from 'https://sergio0p.github.io/tikz-svg/src/automata/automata.js';
</script>
```

### Basic usage

```javascript
const svg = document.getElementById('automaton');

renderAutomaton(svg, {
  nodeDistance: 80,
  onGrid: true,
  stateStyle: {
    radius: 22,
    fill: '#f97316',
    stroke: 'none',
    labelColor: '#ffffff',
    fontSize: 16,
    fontFamily: 'serif',
  },
  edgeStyle: {
    stroke: '#333',
    strokeWidth: 2,
    arrow: 'stealth',
  },
  states: {
    q0: { initial: true, label: 'q\u2080' },
    q1: { position: { 'above right': 'q0' }, label: 'q\u2081' },
    q2: { position: { 'below right': 'q0' }, label: 'q\u2082' },
    q3: { position: { 'below right': 'q1' }, label: 'q\u2083', accepting: true },
  },
  edges: [
    { from: 'q0', to: 'q1', label: '0' },
    { from: 'q0', to: 'q2', label: '1' },
    { from: 'q1', to: 'q3', label: '1' },
    { from: 'q1', to: 'q1', label: '0', loop: 'above' },
    { from: 'q2', to: 'q3', label: '0' },
    { from: 'q2', to: 'q2', label: '1', loop: 'below' },
  ],
});
```

### Config object

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `states` | `Object` | *required* | Map of state IDs to state configs |
| `edges` | `Array` | `[]` | Array of edge objects |
| `stateStyle` | `Object` | `{}` | Default style for all states |
| `edgeStyle` | `Object` | `{}` | Default style for all edges |
| `nodeDistance` | `number` | `60` | Distance between nodes for relative positioning |
| `onGrid` | `boolean` | `false` | Snap positions to grid |

### State config

| Key | Type | Description |
|-----|------|-------------|
| `label` | `string` | Display label (use Unicode subscripts: q\u2080 q\u2081 q\u2082) |
| `position` | `Object` | Relative: `{ 'above right': 'q0' }` |
| `initial` | `boolean` | Show initial arrow |
| `accepting` | `boolean` | Show double circle |
| `fill` | `string` | Per-state fill override |
| `stroke` | `string` | Per-state stroke override |
| `radius` | `number` | Per-state radius override |
| `shadow` | `Object` | `{ dx, dy, blur, color }` |

Positions: `above`, `below`, `left`, `right`, `above left`, `above right`, `below left`, `below right`.

### stateStyle defaults

```javascript
{
  shape: 'circle',       // 'circle' | 'rectangle' | 'ellipse'
  radius: 20,
  fill: '#FFFFFF',
  stroke: '#000000',
  strokeWidth: 1.5,
  fontSize: 14,
  fontFamily: 'serif',
  labelColor: '#000000',
  dashed: false,
  shadow: false,          // true | { dx, dy, blur, color }
  acceptingInset: 3,
}
```

### Edge config

| Key | Type | Description |
|-----|------|-------------|
| `from` | `string` | Source state ID |
| `to` | `string` | Target state ID |
| `label` | `string` | Edge label |
| `bend` | `string\|number` | `'left'`, `'right'`, or angle in degrees |
| `loop` | `string` | `'above'`, `'below'`, `'left'`, `'right'` |
| `looseness` | `number` | Loop/bend looseness multiplier |

### edgeStyle defaults

```javascript
{
  stroke: '#000000',
  strokeWidth: 1.5,
  arrow: 'stealth',
  dashed: false,
}
```

### Arrow tips

Built-in: Stealth, Latex, To, Bar, Circle, Bracket. Set via `edgeStyle.arrow`.

### Core modules (available for standalone use)

- **Transform / TransformStack** (`core/transform.js`) — 2D affine transforms
- **ArrowTipRegistry** (`core/arrow-tips.js`) — pluggable arrow tip definitions
- **Path** (`core/path.js`) — soft-path builder with `roundCorners()`, `transform()`, SVG serialization

### HTML template for automata demos

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Automaton Demo</title>
  <style>
    body { font-family: sans-serif; display: flex; flex-direction: column; align-items: center; padding: 2rem; }
    svg { width: 500px; height: 400px; }
  </style>
</head>
<body>
  <svg id="automaton"></svg>
  <script type="module">
    import { renderAutomaton } from 'https://sergio0p.github.io/tikz-svg/src/automata/automata.js';
    const svg = document.getElementById('automaton');
    renderAutomaton(svg, { /* config */ });
  </script>
</body>
</html>
```

---

## Inline SVG Node-Edge Diagrams (Decision Trees, Game Trees)

For simple TikZ node-edge diagrams (decision trees, asset return trees, small game trees), skip the JS library and write inline SVG directly in the HTML. This is faster and has zero dependencies.

### Construction order (follow strictly to avoid duplication bugs)

1. **Plan the layout** — decide node centers and viewBox before writing any SVG
2. **Write `<defs>`** — arrow markers and filters (once)
3. **Write edges** — `<line>` or `<path>` elements (drawn first = behind nodes)
4. **Write edge labels** — `<text>` elements near edge midpoints
5. **Write nodes** — shape (`<ellipse>`, `<circle>`, `<rect>`) then its `<text>` label, as a pair. Never separate them. Never duplicate.
6. **Review** — count that each node has exactly one shape + one text element

### Template: 3-node branching tree

```html
<svg viewBox="0 0 420 200" style="max-width: 420px; width: 100%; display: block; margin: 0.75rem auto;">
  <defs>
    <marker id="arr" markerWidth="10" markerHeight="6" refX="9" refY="3" orient="auto">
      <polygon points="0 0, 10 3, 0 6" fill="#586e75"/>
    </marker>
    <filter id="ds" x="-10%" y="-10%" width="130%" height="130%">
      <feDropShadow dx="2" dy="2" stdDeviation="2" flood-opacity="0.25"/>
    </filter>
  </defs>
  <!-- 1. Edges (behind nodes) -->
  <line x1="135" y1="93" x2="245" y2="47" stroke="#586e75" stroke-width="2" marker-end="url(#arr)"/>
  <line x1="135" y1="107" x2="245" y2="155" stroke="#586e75" stroke-width="2" marker-end="url(#arr)"/>
  <!-- 2. Edge labels -->
  <text x="178" y="56" text-anchor="middle" font-family="'Times New Roman', serif" font-size="18" font-style="italic" fill="#586e75">²⁄₃</text>
  <text x="178" y="150" text-anchor="middle" font-family="'Times New Roman', serif" font-size="18" font-style="italic" fill="#586e75">¹⁄₃</text>
  <!-- 3. Nodes: each is exactly ONE shape + ONE text -->
  <!-- Root node -->
  <ellipse cx="80" cy="100" rx="58" ry="22" fill="#dc322f" filter="url(#ds)"/>
  <text x="80" y="106" text-anchor="middle" font-family="'Times New Roman', serif" font-size="15" fill="#fff" font-style="italic">Root label</text>
  <!-- Child node (upper) -->
  <ellipse cx="310" cy="40" rx="55" ry="22" fill="#2e8b34" filter="url(#ds)"/>
  <text x="310" y="46" text-anchor="middle" font-family="'Times New Roman', serif" font-size="15" fill="#fff" font-style="italic">Upper label</text>
  <!-- Child node (lower) -->
  <ellipse cx="310" cy="160" rx="55" ry="22" fill="#2e8b34" filter="url(#ds)"/>
  <text x="310" y="166" text-anchor="middle" font-family="'Times New Roman', serif" font-size="15" fill="#fff" font-style="italic">Lower label</text>
</svg>
```

### SVG subscript/superscript pattern

SVG `<text>` has no native sub/superscript. Use `<tspan>` with `dy` offsets. The pattern for $r_\alpha^0$ is:

```xml
<text x="80" y="106" text-anchor="middle" font-family="'Times New Roman', serif" font-size="15" fill="#fff" font-style="italic">
  <tspan>r</tspan><tspan font-size="10" dy="-6">0</tspan><tspan font-size="10" dy="9" dx="-7">α</tspan><tspan dy="-3" dx="2"> = −1</tspan>
</text>
```

Key rules for `dy`-based sub/superscripts:
- **Superscript**: `dy="-6"` (shift up), `font-size="10"` (smaller)
- **Subscript after superscript**: `dy="9"` (shift back down past baseline), `dx="-7"` (shift left to tuck under)
- **Return to baseline**: `dy="-3"` on the next tspan
- `dy` values are **cumulative** — each tspan shifts relative to the previous one, so you must always return to baseline

### Unicode fraction characters

KaTeX does not render inside SVG `<text>`. For simple fractions on edge labels, use Unicode:

| Fraction | Unicode |
|----------|---------|
| ½ | `½` |
| ⅓ | `⅓` |
| ⅔ | `⅔` |
| ¼ | `¼` |
| ¾ | `¾` |
| ¹⁄₃ | `¹⁄₃` (superscript 1 + fraction slash + subscript 3) |
| ²⁄₃ | `²⁄₃` |

For complex math labels, use the HTML-overlay technique from lecture-compose (`positionKatexLabel`).

### Style reference

| Element | Color | Notes |
|---------|-------|-------|
| Edges & labels | `#586e75` | Solarized base01 |
| Initial/root node | `#dc322f` | Solarized red |
| Outcome nodes | `#2e8b34` | Green (TikZ green!50!black) |
| Node text | `#fff` | White on colored fills |
| Arrow marker | `#586e75` | Same as edges |
| Drop shadow | `filter="url(#ds)"` | feDropShadow, opacity 0.25 |

### Edge coordinates

Start edge lines from the ellipse border, not the center. For an ellipse at `(cx, cy)` with `rx, ry`:
- Right edge: `x1 = cx + rx`
- Approximate: offset `x1` by ~`rx` and nudge `y1` by ±7 for upper/lower branches

---

## Callouts

Rectangle and ellipse speech-bubble shapes with pointers, for annotating graph elements. Loaded as a standalone IIFE — no ES module import needed.

### Loading

```html
<script src="js/callouts.js"></script>
```

Exposes globals: `rectangleCallout()` and `ellipseCallout()`. File lives at `101/js/callouts.js`.

### API

**Explicit positions:**
```javascript
const callout = rectangleCallout(center, target, text, options);
const callout = ellipseCallout(center, target, text, options);
svg.appendChild(callout);
```

**Polar mode:**
```javascript
const callout = rectangleCallout(target, text, { angle, distance, ...options });
const callout = ellipseCallout(target, text, { angle, distance, ...options });
```

### Point formats

- `{x, y}` — raw SVG coordinates
- `{Q, P}` — economics coordinates (requires `coordSystem` option)
- `'#my-dot'` — CSS selector (resolves via `getBBox` center)

### Economics coordinate system

```javascript
const coordSystem = { toX: Q => 20 + Q * 3.133, toY: P => 350 - P * 2.46 };
const callout = ellipseCallout({Q: 80, P: 110}, {Q: 46, P: 97}, "Equilibrium", { coordSystem });
```

### Options

| Option | Default | Description |
|--------|---------|-------------|
| `fill` | `'#fdf6e3'` | Background fill |
| `stroke` | `'#586e75'` | Border stroke |
| `strokeWidth` | `2` | Border width |
| `pointerWidth` | `14` | Pointer base width |
| `pointerShorten` | `0` | Pull tip toward center |
| `cornerRadius` | `4` | Rectangle only |
| `pointerArc` | `20` | Ellipse only (degrees) |
| `padding` | `{x: 12, y: 8}` | Text padding |
| `fontSize` | `18` | Text size |
| `fontFamily` | `"'Times New Roman', serif"` | Font |
| `fontStyle` | `'italic'` | Font style |
| `textFill` | `'#586e75'` | Text color |
| `width` / `height` | auto | Skip text measurement |
| `angle` | `null` | Polar: degrees (0=right, 90=down) |
| `distance` | `null` | Polar: center distance from target |
| `pointerGap` | `0` | Polar: gap from target to tip |

Multi-line: pass `["Line one", "Line two"]` as text.

### Anchors

Returned `<g>` has `.anchors`: `center`, `pointer`, `north`, `south`, `east`, `west`.

### GSAP integration

```javascript
const callout = ellipseCallout(TARGET, "Label", { angle: -60, distance: 80, coordSystem });
callout.style.opacity = '0';
svg.appendChild(callout);
tl.to(callout, { opacity: 1, duration: 0.5 }, 3);
tl.to(callout, { opacity: 0, duration: 0.5 }, 5);
```

---

## Source location

Library source: `/Users/sergioparreiras/Dropbox/Scripts/tikz-svg/`
GitHub Pages: `https://sergio0p.github.io/tikz-svg/`
- Full API docs: `README.md`
- Callout integration plan: `PLAN-callouts-integration.md`
- Legacy callout source: `src/legacy-callouts.js`
- Live callout file used by lectures: `101/js/callouts.js`
