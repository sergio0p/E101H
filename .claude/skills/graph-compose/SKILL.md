---
name: graph-compose
description: Use when composing animated economics SVG graphs for lecture pages. Covers tikz-svg render() API as the coordinate vocabulary, scroll-driven GSAP animation patterns, and named recipes for common economics diagram sequences (equilibrium reveal, welfare areas, curve shifts, side comments).
---

# Graph Composition v2 — tikz-svg + GSAP Patterns

Compose animated economics diagrams using tikz-svg coordinates as the shared vocabulary. All positions are expressed in tikz-svg's coordinate system — no raw SVG pixel math.

## Coordinate Vocabulary

All spatial discussion uses tikz-svg coordinates. When the user says "place the label at (3, 2)" or "above right of the equilibrium", these map directly to `render()` config:

```js
// Absolute position
{ position: { x: 3, y: 2 } }

// Relative to another node
{ position: { 'above right': 'eq-dot' } }

// On a plot curve
{ at: { plot: 0, point: 5, above: 0.1 } }

// Scale converts tikz coords to SVG pixels
render(svg, { scale: 200, originX: 100, originY: 90, draw: [...] });
```

**Convention**: Economics graphs use y-up (math convention). `config.scale` and `config.originX/Y` handle the mapping. Path coordinates are in SVG y-down; node/plot coordinates use the scale transform.

## Graph Construction via render()

Use `config.draw` for ordered paint (tikz-svg's `\draw` equivalent):

```js
import { render } from 'https://sergio0p.github.io/tikz-svg/src-v2/index.js';

render(svgEl, {
  scale: 200,
  originX: 100, originY: 90,
  draw: [
    // Axes
    { type: 'path', points: [{x:0,y:-0.1},{x:0,y:1.5}], arrow: '->' },
    { type: 'path', points: [{x:-0.1,y:0},{x:1.5,y:0}], arrow: '->' },
    // Axis labels
    { type: 'node', id: 'ylabel', position: {x:-0.15, y:1.5}, label: '$P$', anchor: 'east', fill: 'none', stroke: 'none' },
    { type: 'node', id: 'xlabel', position: {x:1.5, y:-0.1}, label: '$Q$', anchor: 'north', fill: 'none', stroke: 'none' },
    // Curves
    { type: 'plot', expr: x => 1.2 - 0.8*x, domain: [0,1.4], handler: 'smooth', stroke: '#dc322f' },
    { type: 'plot', expr: x => 0.2 + 0.8*x, domain: [0,1.4], handler: 'smooth', stroke: '#268bd2' },
    // Curve labels
    { type: 'node', id: 'dlabel', position: {x:1.42, y:0.06}, label: '$D$', fill: 'none', stroke: 'none' },
    { type: 'node', id: 'slabel', position: {x:1.42, y:1.32}, label: '$S$', fill: 'none', stroke: 'none' },
  ],
});
```

### KaTeX math labels

Labels with `$...$` render via KaTeX. Requires CDN in HTML head:

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.22/dist/katex.min.css">
<script src="https://cdn.jsdelivr.net/npm/katex@0.16.22/dist/katex.min.js"></script>
```

### Required HTML shims

Every page using tikz-svg needs the mathjs UMD bundle (the library's internal shim handles the rest):

```html
<script src="https://cdn.jsdelivr.net/npm/mathjs@15.1.1/lib/browser/math.js"></script>
```

No importmap needed — the library resolves mathjs internally.

## Color Scheme (Solarized Light)

| Role | Color | Hex |
|------|-------|-----|
| Graph background | base3 | `#fdf6e3` |
| Axes/text | base01 | `#586e75` |
| Demand / CS | red | `#dc322f` |
| Supply / PS | blue | `#268bd2` |
| MC / profit | green | `#859900` |
| DWL / warning | yellow | `#b58900` |
| Highlight | magenta | `#d33682` |
| Additional | cyan | `#2aa198` |
| Additional | orange | `#cb4b16` |
| Additional | violet | `#6c71c4` |

Welfare areas: use `fill-opacity: 0.3` on `<polygon>` elements.

## Node Proportions

Default `nodeDistance: 90` with `radius: 20` gives TikZ-faithful 22% ratio. For economics graphs without automata nodes, use invisible nodes (`fill: 'none', stroke: 'none'`) as positioned labels.

## Animation Patterns

All patterns use GSAP + ScrollTrigger. Standard timeline setup:

```js
gsap.registerPlugin(ScrollTrigger);
const tl = gsap.timeline({
  scrollTrigger: {
    trigger: '#section-id',
    start: 'top top',
    end: '+=N%',        // 200-300% simple, 400-600% medium, 700-900% complex
    pin: true,
    scrub: 1,
    anticipatePin: 1
  }
});
```

### Assigning SVG element IDs for animation

tikz-svg generates SVG elements with predictable IDs. To animate individual elements, assign IDs in `config.draw` and target them via `#node-{id}` in GSAP:

```js
// In render config
{ type: 'node', id: 'eq-dot', ... }
{ type: 'path', id: 'dashed-h', ... }

// In GSAP
gsap.set('#node-eq-dot', { opacity: 0 });
tl.to('#node-eq-dot', { opacity: 1, duration: 0.3 }, 2);
```

For plots, use `svg.querySelector` after render to find `<path>` elements by position.

---

### Pattern 1: Equilibrium Reveal

The backbone sequence: dot appears → dashed lines extend → labels fade in.

```
Phase N:   eq-dot opacity 0→1 (0.3s)
Phase N+1: dashed-h line extends from dot to y-axis (1s)
           dashed-v line extends from dot to x-axis (1s)
Phase N+2: P* label opacity 0→1 (0.3s)
           Q* label opacity 0→1 (0.3s)
```

**Frequency**: VERY COMMON — every supply-demand, monopoly, and tax graph uses this.

### Pattern 2: Curve Draw-In

Animate a curve appearing as if drawn by hand using stroke-dashoffset:

```js
const path = svg.querySelector('#my-curve');
const len = path.getTotalLength();
gsap.set(path, { strokeDasharray: len, strokeDashoffset: len });
tl.to(path, { strokeDashoffset: 0, duration: 1, ease: 'none' }, 0);
```

Often paired with label fade-in at 70% through the draw.

**Frequency**: COMMON — used for introducing supply/demand curves.

### Pattern 3: Welfare Polygon

Shaded triangular/trapezoidal areas for CS, PS, DWL, tax revenue:

```html
<polygon id="cs-area" points="..." fill="#dc322f" fill-opacity="0.3" opacity="0"/>
```

```js
tl.to('#cs-area', { opacity: 1, duration: 0.5 }, 3);
```

Use tikz-svg coordinates to compute polygon vertices. Often revealed in sequence: CS first, then PS, then DWL.

**Frequency**: COMMON for welfare analysis.

### Pattern 4: Multi-Phase Erase-and-Reverse

Phase 1 elements fade out before Phase 2 elements appear. Reversible on scroll-back thanks to `scrub: 1`.

```js
// Phase 1 appears
tl.to('#scenario-a', { opacity: 1, duration: 1 }, 0);
// Phase 1 fades, Phase 2 appears
tl.to('#scenario-a', { opacity: 0.25, duration: 0.5 }, 3);
tl.to('#scenario-b', { opacity: 1, duration: 1 }, 3);
```

Use `opacity: 0.25` (not 0) to keep context visible but de-emphasized.

**Frequency**: MODERATE — curve shifts, before/after comparisons.

### Pattern 5: Side Comment Slide-In

Fixed-position panel slides from screen edge. For tangential info, comparisons, or "professor's notes":

```css
.side-comment {
  position: fixed; top: 50%; right: -500px; transform: translateY(-50%);
  width: 350px; padding: 1.5rem; background: #fff8e1;
  border-left: 4px solid #f9a825; border-radius: 8px;
  box-shadow: -8px 8px 30px rgba(0,0,0,0.25);
  font-size: 0.95rem; z-index: 100; opacity: 0;
}
```

```js
tl.to('#comment', { right: 20, opacity: 1, duration: 1, ease: 'power2.out' }, 2);
// Reading pause (1.5 timeline units)
tl.to('#comment', { right: -500, opacity: 0, duration: 1, ease: 'power2.in' }, 3.5);
```

**Frequency**: RARE but visually impactful. Underused because of positioning complexity.

**Variant — Opposing panels**: Two panels from opposite sides for direct comparison (e.g., buyer vs seller remitted tax).

### Pattern 6: Horizontal Panel Transition

Swap between two graph views. Rare because labor-intensive, but powerful:

```js
tl.to('#panel-2', { left: '0%', duration: 1, ease: 'none' }, 5);
tl.to('#panel-1', { x: '100vw', duration: 1, ease: 'none' }, 5);
```

**Frequency**: VERY RARE — only taxes dual graph. High-value pattern worth making easier.

### Pattern 7: Overlay Reveal (Beamer \pause)

Sequential text block reveals on scroll. Implemented in `scroll-animations.js`:

```html
<section class="frame overlay-frame">
  <div class="block overlay" data-overlay="1">First item</div>
  <div class="block overlay" data-overlay="2">Second item</div>
</section>
```

No GSAP needed — handled by `scroll-animations.js` automatically.

**Frequency**: UNIVERSAL for text slides.

### Pattern 8: Arrow Key Interactive

Parameter control (price sweep, tax slider, demand slope) gated by ScrollTrigger:

```js
let navEnabled = false;
ScrollTrigger.create({
  trigger: '#section', start: 'top top', end: '+=200%',
  pin: true,
  onEnter: () => { navEnabled = true; },
  onLeave: () => { navEnabled = false; },
  onEnterBack: () => { navEnabled = true; },
  onLeaveBack: () => { navEnabled = false; },
});

document.addEventListener('keydown', e => {
  if (!navEnabled) return;
  if (e.key === 'ArrowRight') { param++; update(); e.preventDefault(); }
  if (e.key === 'ArrowLeft') { param--; update(); e.preventDefault(); }
});
```

The `update()` function re-renders or repositions SVG elements using tikz-svg coordinates.

**Frequency**: COMMON for interactive sections.

### Pattern 9: Callout Annotation

Polar-positioned callouts pointing to specific graph features:

```js
const callout = ellipseCallout(targetPoint, ["Line 1", "Line 2"], {
  angle: -151, distance: 188, pointerGap: 25,
  fill: '#dc322f', textColor: '#fff'
});
```

**Frequency**: RARE — requires `callouts.js`, angle/distance tuning. Very effective for storytelling.

## Animation Budget

**Animation should be used sparingly.** Constant animation loses potency. Reserve it for moments where seeing the transition teaches something static text cannot:

- A curve shifting to show policy impact
- An area appearing to show welfare changes
- A step-by-step derivation reveal

**~Half the lecture pages are appropriately static.** Not every page needs animation.

## Graph Frame HTML Template

```html
<section class="scroll-frame graph-frame" id="my-graph">
  <div class="scroll-frame-inner" style="position: relative; background: #fdf6e3;">
    <!-- KaTeX labels outside SVG (for complex math) -->
    <div id="katex-label" style="position: absolute;">$P^*$</div>
    <!-- tikz-svg renders into this -->
    <svg id="graph-svg" style="max-width: 700px; width: 100%;"></svg>
  </div>
</section>
```

## Workflow

This skill supports collaborative composition. The user describes what they want in natural language using tikz-svg positioning vocabulary. Claude translates to `render()` config + GSAP patterns:

1. **User**: "Draw supply and demand, intersection at (0.5, 0.6)"
2. **Claude**: Writes `render()` config with those coordinates
3. **User**: "Now animate: draw supply first, pause, then demand, then show equilibrium"
4. **Claude**: Applies Pattern 2 (curve draw-in) + Pattern 1 (equilibrium reveal)
5. **User**: "Add a side comment about elasticity when the curves appear"
6. **Claude**: Applies Pattern 5 (side comment slide-in)
7. **Visual inspection** → tweaks → iterate

The tikz-svg coordinates eliminate ambiguity about WHERE things go. The named patterns eliminate boilerplate about HOW things animate.

## Checklist

- [ ] Import tikz-svg from correct path
- [ ] mathjs importmap shim included (silent failure if missing)
- [ ] KaTeX CDN included if using `$...$` labels
- [ ] Solarized colors for all graph elements
- [ ] Timeline phases have pauses between them for reading
- [ ] Side comments have slide-in AND slide-out with gap
- [ ] Arrow key handlers gated by ScrollTrigger onEnter/onLeave
- [ ] Animation used purposefully, not decoratively
