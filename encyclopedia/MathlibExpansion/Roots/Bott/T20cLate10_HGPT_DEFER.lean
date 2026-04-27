import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_10 HGPT_DEFER — Homotopy Groups & Postnikov Towers (Bott–Tu 1982 §III.17 appendix, defer, DEFER)
    **Classification.** defer — homotopy groups + Postnikov towers are referenced but not the
    primary engine of Bott–Tu's characteristic-class apparatus; reserved for later wave.
    Single axiom.
    **Citation.** Bott–Tu §III.17 (homotopy groups aside, Hurewicz, Postnikov); Postnikov 1951;
    Whitehead 1978 *Elements of Homotopy Theory*. -/
namespace MathlibExpansion
namespace Roots
namespace Bott
namespace T20cLate10_HGPT_DEFER

/-- **HGPT_01** (deferred) homotopy groups `π_n(X)` + Hurewicz map `π_n(X) → H_n(X; ℤ)` +
    Postnikov tower `X → … → X_n → X_{n-1} → …` with fibres `K(π_n X, n)` (Bott–Tu §III.17
    aside; Postnikov 1951; Whitehead 1978). -/
axiom hgpt_homotopy_postnikov_deferred_marker : True

end T20cLate10_HGPT_DEFER
end Bott
end Roots
end MathlibExpansion
