# Bootstrap Educational Apps - Development Guide

## Overview

This guide explains how to build interactive educational apps using Bootstrap 5, KaTeX, and our shared CSS framework. These apps feature accordion-based UI, mathematical notation, and pedagogical feedback.

---

## Architecture

### Core Components

1. **Bootstrap 5.3.0** - UI framework (accordions, buttons, forms, responsive grid)
2. **KaTeX** - Math rendering (client-side, no server needed)
3. **shared-bootstrap-edu.css** - Shared styles (Solarized Light theme)
4. **Vanilla JavaScript** - Problem generation and interaction logic

### File Structure

```
Apps/
├── shared-bootstrap-edu.css          # Shared styles for all apps
├── crusoe-friday-trade.html          # Example: Trade app
├── PPF-bootstrap.html                # Example: PPF app
└── BOOTSTRAP_APP_GUIDE.md            # This file
```

---

## Standard Template

### HTML Head

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>App Title</title>

    <!-- Bootstrap 5.3.0 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Shared Educational Styles -->
    <link rel="stylesheet" href="shared-bootstrap-edu.css">

    <!-- KaTeX CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">

    <style>
        /* App-specific styles only */
    </style>
</head>
```

### HTML Body Structure

```html
<body>
    <div class="container mt-4" data-app="app-name">
        <!-- Header with utility buttons -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h1 class="mb-0">App Title</h1>
            <div class="btn-toolbar gap-1">
                <button class="btn btn-sm btn-outline-secondary" onclick="expandAll()">Expand All</button>
                <button class="btn btn-sm btn-outline-secondary" onclick="collapseAll()">Collapse All</button>
                <button class="btn btn-sm btn-outline-secondary" onclick="resetApp()">Reset</button>
                <button class="btn btn-sm btn-outline-secondary" onclick="window.print()">Print</button>
            </div>
        </div>

        <!-- Instructor Info -->
        <div class="edu-instructor-info">
            <p><strong>Instructor:</strong> Sérgio O. Parreiras</p>
            <p><strong>Course:</strong> ECON 101 - Introduction to Economics</p>
        </div>

        <!-- Main accordion -->
        <div class="accordion" id="mainAccordion">
            <!-- Problem Setup Section -->
            <div class="accordion-item">
                <h2 class="accordion-header">
                    <button class="accordion-button" type="button"
                            data-bs-toggle="collapse" data-bs-target="#problemSection">
                        Problem Setup
                    </button>
                </h2>
                <div id="problemSection" class="accordion-collapse collapse show">
                    <div class="accordion-body">
                        <!-- Problem content goes here -->
                    </div>
                </div>
            </div>

            <!-- Your Answers Section -->
            <div class="accordion-item">
                <h2 class="accordion-header">
                    <button class="accordion-button" type="button"
                            data-bs-toggle="collapse" data-bs-target="#answersSection">
                        Your Answers
                    </button>
                </h2>
                <div id="answersSection" class="accordion-collapse collapse show">
                    <div class="accordion-body">
                        <!-- Input fields and controls -->
                        <div class="text-center mt-3">
                            <button class="btn btn-primary" onclick="checkAnswers()">Check Answers</button>
                            <button class="btn btn-outline-secondary" onclick="generateNewProblem()">New Problem</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Solution Section -->
            <div class="accordion-item">
                <h2 class="accordion-header">
                    <button class="accordion-button collapsed" type="button"
                            data-bs-toggle="collapse" data-bs-target="#solutionSection">
                        Solution
                    </button>
                </h2>
                <div id="solutionSection" class="accordion-collapse collapse">
                    <div class="accordion-body">
                        <div id="feedback"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- KaTeX JS -->
    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/contrib/auto-render.min.js"></script>

    <script>
        // App JavaScript goes here
    </script>
</body>
</html>
```

---

## Critical Patterns

### 1. Solution Pre-Population (IMPORTANT!)

**Solutions must be generated when the problem is created**, not when the user clicks a button.

```javascript
function generateNewProblem() {
    // Generate problem data
    currentProblem = { /* ... */ };

    // Display the problem
    displayProblem();

    // IMPORTANT: Pre-populate the solution immediately
    displaySolution();

    // Clear any feedback
    clearFeedback();
}

function displaySolution() {
    // Build solution HTML with KaTeX
    const solutionHTML = `
        <div class="edu-code">
            $$\\text{Solution content here}$$
        </div>
    `;

    document.getElementById('feedback').innerHTML = solutionHTML;

    // Render KaTeX
    renderMathInElement(document.getElementById('feedback'), {
        delimiters: [
            {left: '$$', right: '$$', display: true},
            {left: '$', right: '$', display: false}
        ],
        throwOnError: false
    });

    // Do NOT auto-expand - solution stays collapsed until needed
}

function checkAnswers() {
    // Check user answers and show feedback

    // Auto-expand the solution section
    const solutionSection = document.getElementById('solutionSection');
    new bootstrap.Collapse(solutionSection, {toggle: false}).show();
}
```

**Key Points:**
- Solution is always available in the DOM
- Solution section starts COLLAPSED
- User can manually expand at any time
- Auto-expands when user checks answers
- NO "Show Solution" button needed

### 2. KaTeX Math Rendering

**Always use KaTeX for math, never Unicode characters (δ, θ, etc.)**

```javascript
// CORRECT - Use KaTeX
const html = `
    $$\\text{Given: } \\delta = ${delta.toFixed(3)}$$
    $$U_0 = u_0 + \\delta \\cdot u_1 + \\delta^2 \\cdot u_2$$
`;

// WRONG - Don't use Unicode
const html = `
    Given: δ = ${delta.toFixed(3)}
    U₀ = u₀ + δ·u₁ + δ²·u₂
`;
```

**Multi-line equations - use `align*`:**

```javascript
const solutionHTML = `
    $$\\begin{align*}
    \\Delta U &= MU_{\\text{fish}} \\times \\Delta \\text{Fish} + MU_{\\text{coconuts}} \\times \\Delta \\text{Coconuts} \\\\
    &= ${MU_fish} \\times ${deltaFish} + ${MU_coconuts} \\times ${deltaCoconuts} \\\\
    &= ${result}
    \\end{align*}$$
`;
```

**Remember to render after updating innerHTML:**

```javascript
document.getElementById('someElement').innerHTML = htmlWithMath;

renderMathInElement(document.getElementById('someElement'), {
    delimiters: [
        {left: '$$', right: '$$', display: true},
        {left: '$', right: '$', display: false}
    ],
    throwOnError: false
});
```

### 3. Utility Functions (Required in Every App)

```javascript
function expandAll() {
    document.querySelectorAll('.accordion-collapse').forEach(el => {
        new bootstrap.Collapse(el, {toggle: false}).show();
    });
}

function collapseAll() {
    document.querySelectorAll('.accordion-collapse').forEach(el => {
        new bootstrap.Collapse(el, {toggle: false}).hide();
    });
}

function resetApp() {
    // Clear all inputs
    document.querySelectorAll('input[type="number"], input[type="text"]').forEach(i => i.value = '');

    // Clear feedback
    document.getElementById('feedback').innerHTML = '';

    // Collapse solution section
    const solutionSection = document.getElementById('solutionSection');
    new bootstrap.Collapse(solutionSection, {toggle: false}).hide();

    // Reset any app-specific state
}

// Initialize on page load
window.addEventListener('load', function() {
    setTimeout(function() {
        generateNewProblem();
    }, 100);
});
```

### 4. Feedback Display

Use the predefined feedback classes:

```javascript
function showFeedback(message, type) {
    const feedback = document.getElementById('feedback');
    feedback.innerHTML = message;

    const classMap = {
        'success': 'edu-success',
        'error': 'edu-error',
        'warning': 'edu-warning',
        'code': 'edu-code'  // For solutions
    };
    feedback.className = classMap[type] || 'edu-success';

    // Auto-expand solution section
    const solutionSection = document.getElementById('solutionSection');
    new bootstrap.Collapse(solutionSection, {toggle: false}).show();

    // Render KaTeX if message contains math
    renderMathInElement(feedback, {
        delimiters: [
            {left: '$$', right: '$$', display: true},
            {left: '$', right: '$', display: false}
        ],
        throwOnError: false
    });
}
```

---

## Available CSS Classes

### Educational Components

- `.edu-question` - Question boxes (orange left border)
- `.edu-formula` - Formula displays (blue left border)
- `.edu-code` - Solution/code displays (gray background)
- `.edu-instructor-info` - Instructor info box (cyan left border)
- `.edu-two-column` - Two-column responsive grid

### Feedback States

- `.edu-success` - Green success message
- `.edu-error` - Red error message
- `.edu-warning` - Yellow warning message

### Utility Classes

- `.edu-highlight` - Yellow highlight
- `.edu-text-red` - Red bold text
- `.edu-text-blue` - Blue bold text
- `.edu-text-green` - Green bold text

---

## Best Practices

### DO:
✅ Pre-populate solutions when generating problems
✅ Use KaTeX for ALL math notation
✅ Break long text into separate `$$...$$ $$...$$` blocks for readability
✅ Use `align*` for multi-line equations
✅ Use semantic variable names in JavaScript
✅ Keep app-specific styles minimal (use shared CSS)
✅ Test on mobile (Bootstrap's responsive breakpoints)
✅ Use `\text{}` inside math mode for text
✅ Use `\mathrm{}` for non-italic text in math (names like Crusoe, Friday)

### DON'T:
❌ Use Unicode math characters (δ, θ, α, β, etc.)
❌ Create "Show Solution" buttons (solution is always available)
❌ Manually expand solution section in `displaySolution()`
❌ Forget to render KaTeX after updating innerHTML
❌ Put long text in single `$$...$$ ` block (breaks readability)
❌ Override shared CSS unnecessarily
❌ Use `<p>` tags inside `$$...$$` blocks

---

## Example: Problem Generation Pattern

```javascript
let currentProblem = {};

function generateNewProblem() {
    // 1. Generate random problem data
    const param1 = randomInt(1, 10);
    const param2 = randomInt(1, 10);
    const correctAnswer = calculateAnswer(param1, param2);

    // 2. Store in global state
    currentProblem = {
        param1,
        param2,
        correctAnswer
    };

    // 3. Display problem
    displayProblem();

    // 4. Pre-populate solution (CRITICAL!)
    displaySolution();

    // 5. Clear previous feedback and collapse solution
    document.getElementById('feedback').innerHTML = '';
    const solutionSection = document.getElementById('solutionSection');
    new bootstrap.Collapse(solutionSection, {toggle: false}).hide();
}

function displayProblem() {
    const html = `
        $$\\text{Given: } x = ${currentProblem.param1}, y = ${currentProblem.param2}$$
        $$\\text{Calculate: } x + y = ?$$
    `;
    document.getElementById('problem-display').innerHTML = html;

    renderMathInElement(document.getElementById('problem-display'), {
        delimiters: [
            {left: '$$', right: '$$', display: true},
            {left: '$', right: '$', display: false}
        ],
        throwOnError: false
    });
}

function displaySolution() {
    const solutionHTML = `
        <div class="edu-code">
            $$\\begin{align*}
            x + y &= ${currentProblem.param1} + ${currentProblem.param2} \\\\
            &= ${currentProblem.correctAnswer}
            \\end{align*}$$
        </div>
    `;

    document.getElementById('feedback').innerHTML = solutionHTML;

    renderMathInElement(document.getElementById('feedback'), {
        delimiters: [
            {left: '$$', right: '$$', display: true},
            {left: '$', right: '$', display: false}
        ],
        throwOnError: false
    });
}

function checkAnswers() {
    const userAnswer = parseInt(document.getElementById('answer-input').value);

    if (isNaN(userAnswer)) {
        showFeedback('$$\\text{Please enter a valid number.}$$', 'error');
        return;
    }

    if (userAnswer === currentProblem.correctAnswer) {
        showFeedback('$$\\text{Correct! Well done.}$$', 'success');
    } else {
        showFeedback('$$\\text{Incorrect. Check the solution.}$$', 'error');
    }

    // Auto-expand solution
    const solutionSection = document.getElementById('solutionSection');
    new bootstrap.Collapse(solutionSection, {toggle: false}).show();
}
```

---

## Common Pitfalls

### 1. Breaking Long Math Text

**WRONG:**
```javascript
const html = `$$\\text{If Crusoe increases consumption of fish by 5 and increases consumption of coconuts by 3, what is the change in utility?}$$`;
```

**CORRECT:**
```javascript
const html = `
    $$\\text{If Crusoe increases consumption of fish by 5}$$
    $$\\text{and increases consumption of coconuts by 3,}$$
    $$\\text{what is the change in utility?}$$
`;
```

### 2. Forgetting to Render KaTeX

**WRONG:**
```javascript
document.getElementById('display').innerHTML = `$$x = ${value}$$`;
// Forgot to render!
```

**CORRECT:**
```javascript
document.getElementById('display').innerHTML = `$$x = ${value}$$`;
renderMathInElement(document.getElementById('display'), {
    delimiters: [
        {left: '$$', right: '$$', display: true},
        {left: '$', right: '$', display: false}
    ],
    throwOnError: false
});
```

### 3. Not Pre-populating Solution

**WRONG:**
```javascript
function generateNewProblem() {
    currentProblem = { /* ... */ };
    displayProblem();
    // Solution only created when user clicks "Show Solution"
}
```

**CORRECT:**
```javascript
function generateNewProblem() {
    currentProblem = { /* ... */ };
    displayProblem();
    displaySolution(); // Pre-populate immediately!
}
```

---

## Quick Reference: KaTeX Common Patterns

### Text in Math Mode
```latex
$$\text{This is text}$$
```

### Roman (Non-italic) in Math Mode
```latex
$$\mathrm{MRS}_{\mathrm{Crusoe}}$$
```

### Fractions
```latex
$$\frac{numerator}{denominator}$$
```

### Subscripts and Superscripts
```latex
$$x_1, x^2, x_1^2$$
```

### Greek Letters
```latex
$$\alpha, \beta, \gamma, \delta, \theta$$
```

### Multi-line Aligned Equations
```latex
$$\begin{align*}
y &= mx + b \\
&= 2x + 3
\end{align*}$$
```

### Inequalities
```latex
$$a < b \leq c$$
$$x \geq y > z$$
```

---

## Testing Checklist

Before finalizing any app, verify:

- [ ] Solution pre-populates when problem is generated
- [ ] Solution section starts collapsed
- [ ] Solution auto-expands when user checks answers
- [ ] User can manually expand solution anytime
- [ ] All math uses KaTeX (no Unicode δ, θ, etc.)
- [ ] Long text broken into multiple lines
- [ ] Expand All / Collapse All buttons work
- [ ] Reset button clears inputs and collapses solution
- [ ] Print layout looks reasonable
- [ ] Responsive on mobile (768px breakpoint)
- [ ] All calculations produce correct results

---

## File Naming Conventions

- Use lowercase with hyphens: `crusoe-friday-trade.html`
- Include course prefix if needed: `101-supply-demand.html`
- Be descriptive: `ppf-bootstrap.html` not `app1.html`

---

## Questions?

This guide covers the standard patterns. For examples:
- See `crusoe-friday-trade.html` for trade/MRS concepts
- See `PPF-bootstrap.html` for interactive graphs with Plotly
- See `shared-bootstrap-edu.css` for available styles

When building new apps, copy the template above and follow the critical patterns.
