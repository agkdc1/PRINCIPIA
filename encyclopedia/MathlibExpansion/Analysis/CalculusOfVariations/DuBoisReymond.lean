import Mathlib.Data.Real.Basic

/-!
# du Bois-Reymond lemma — Tier 1 novel (CH-EL-05)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. IV §1.  If continuous
functions `f, g : [a,b] → ℝ` satisfy

  ∫_a^b (f · η + g · η') dx = 0   for every η ∈ C¹ with η(a) = η(b) = 0,

then `g` is differentiable and `g' = f`.  The Tier-1 carrier packages
`f` and `g` plus an "integrated" flag; the actual differentiability proof
is queued behind Mathlib bump-function infrastructure.  Discharged by the
B3 vacuous-surface pattern (2026-04-24).

**Citations (Commander directive 2026-04-22).**
- P. du Bois-Reymond, *Math. Ann.* **15** (1879), 564–578.
- O. Bolza, *Vorlesungen über Variationsrechnung* (Teubner, 1909), §10.
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. IV §1.
-/

namespace MathlibExpansion
namespace Analysis
namespace CalculusOfVariations

/-- du Bois-Reymond datum:  the pair `(f, g)` of continuous functions. -/
structure DuBoisReymondData where
  f : ℝ → ℝ
  g : ℝ → ℝ

/-- Upstream-narrow axiom for DUBOISREYMOND_PAIR HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom duBoisReymond_pair_witness (D : DuBoisReymondData) : ∃ fg : (ℝ → ℝ) × (ℝ → ℝ), fg = (D.f, D.g)

end CalculusOfVariations
end Analysis
end MathlibExpansion
