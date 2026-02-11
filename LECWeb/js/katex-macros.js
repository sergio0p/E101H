// KaTeX Custom Macros for Economics

const katexMacros = {
  // Calculus
  "\\diff": "\\frac{\\partial #1}{\\partial #2}",
  "\\sdiff": "\\tfrac{\\partial #1}{\\partial #2}",
  "\\ddiff": "\\frac{d #1}{d #2}",
  "\\sddiff": "\\tfrac{d #1}{d #2}",

  // Sets and brackets
  "\\set": "\\left\\{ #1 \\right\\}",
  "\\abs": "\\left| #1 \\right|",
  "\\norm": "\\left\\| #1 \\right\\|",
  "\\paren": "\\left( #1 \\right)",
  "\\bracket": "\\left[ #1 \\right]",

  // Optimization
  "\\argmax": "\\mathop{\\mathrm{arg\\,max}}\\limits_{#1}",
  "\\argmin": "\\mathop{\\mathrm{arg\\,min}}\\limits_{#1}",
  "\\max": "\\mathop{\\mathrm{max}}\\limits_{#1}",
  "\\min": "\\mathop{\\mathrm{min}}\\limits_{#1}",

  // Economics notation
  "\\MU": "\\mathrm{MU}",
  "\\MR": "\\mathrm{MR}",
  "\\MC": "\\mathrm{MC}",
  "\\AC": "\\mathrm{AC}",
  "\\ATC": "\\mathrm{ATC}",
  "\\AVC": "\\mathrm{AVC}",
  "\\AFC": "\\mathrm{AFC}",
  "\\TR": "\\mathrm{TR}",
  "\\TC": "\\mathrm{TC}",
  "\\TVC": "\\mathrm{TVC}",
  "\\TFC": "\\mathrm{TFC}",
  "\\CS": "\\mathrm{CS}",
  "\\PS": "\\mathrm{PS}",
  "\\DWL": "\\mathrm{DWL}",

  // Common symbols
  "\\R": "\\mathbb{R}",
  "\\N": "\\mathbb{N}",
  "\\Z": "\\mathbb{Z}",
  "\\Q": "\\mathbb{Q}",
  "\\E": "\\mathbb{E}",
  "\\Var": "\\mathrm{Var}",
  "\\Cov": "\\mathrm{Cov}",

  // Greek shortcuts
  "\\eps": "\\varepsilon",
  "\\vphi": "\\varphi",

  // Text in math
  "\\st": "\\text{ s.t. }",
  "\\and": "\\text{ and }",
  "\\or": "\\text{ or }",
  "\\for": "\\text{ for }",
  "\\where": "\\text{ where }",

  // Euler font (approximation)
  "\\euler": "\\mathrm"
};

// Initialize KaTeX on page load
function initKaTeX() {
  // Render all elements with class "math" or "math-display"
  document.querySelectorAll('.math').forEach(el => {
    katex.render(el.textContent, el, {
      throwOnError: false,
      macros: katexMacros
    });
  });

  document.querySelectorAll('.math-display').forEach(el => {
    katex.render(el.textContent, el, {
      throwOnError: false,
      displayMode: true,
      macros: katexMacros
    });
  });

  // Auto-render for $...$ and $$...$$ syntax
  renderMathInElement(document.body, {
    delimiters: [
      {left: '$$', right: '$$', display: true},
      {left: '$', right: '$', display: false},
      {left: '\\(', right: '\\)', display: false},
      {left: '\\[', right: '\\]', display: true}
    ],
    macros: katexMacros,
    throwOnError: false
  });
}

// Run when DOM is ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initKaTeX);
} else {
  initKaTeX();
}
