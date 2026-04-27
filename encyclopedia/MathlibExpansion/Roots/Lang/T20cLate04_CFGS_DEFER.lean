import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_late_04 CFGS — Cyclotomic fields & Gauss sums (DEFER)

**Classification.** `defer`. Sidecar only; single open bridge is Galois
action on Gauss/Jacobi sums, held until a live reciprocity consumer asks.

**Citation.** Lang, *Algebraic Number Theory*, GTM 110 (1970), Ch. 4.
Modern: Washington, *Introduction to Cyclotomic Fields*; Ireland-Rosen.
-/

namespace MathlibExpansion
namespace Roots
namespace Lang
namespace T20cLate04_CFGS_DEFER

/-- **CFGS_DEFER** Galois-action on Gauss sums marker. Deferred citation-
backed axiom for `σ ∈ Gal(ℚ(ζ_m)/ℚ)`, `σ(g(χ)) = χ̄(σ) · g(χ)`.
Citation: Lang Ch. 4 §3; Washington §4.3. -/
axiom cfgs_galois_action_gauss_marker : True

end T20cLate04_CFGS_DEFER
end Lang
end Roots
end MathlibExpansion
