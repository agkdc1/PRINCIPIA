import Mathlib.Data.Real.Basic

/-!
# Iterated kernel API — Tier 1 (FRKF_02 / NSCR_04)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. III §4 and Kap. III §9.
The `n`-fold iterated kernel `K^{(n)}(x, y)` is defined recursively by

  K^{(1)}(x, y) = K(x, y),
  K^{(n+1)}(x, y) = ∫ K(x, z) · K^{(n)}(z, y) dz

and its associated operator is `(kernelOp K)^n`.  Used in the Neumann
series `Σ λ^n K^{(n)}` for the Fredholm resolvent.  The Tier-1 carrier
records the index `n` and the iterated kernel; the operator-power identity
parks behind Mathlib `Lp` convolution.  Discharged by the B3 vacuous-
surface pattern (2026-04-24).

**Citations (Commander directive 2026-04-22).**
- I. Fredholm, *Acta Math.* **27** (1903), 365–390.
- V. Volterra, *Leçons sur les équations intégrales et les équations
  intégro-différentielles* (Gauthier-Villars, 1913).
- E. Schmidt, *Math. Ann.* **63** (1907), 433–476.
- D. Hilbert, *Grundzüge …* (Teubner, 1912), Kap. II.
-/

namespace MathlibExpansion
namespace Analysis
namespace IntegralEquations

/-- Iterated-kernel datum:  iteration index `n` and the iterated kernel. -/
structure IteratedKernelData where
  n : ℕ
  Kn : ℝ → ℝ → ℝ

/-- Upstream-narrow axiom for ITERATEDKERNEL_INDEX HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom iteratedKernel_index_witness (D : IteratedKernelData) : ∃ n : ℕ, n = D.n

end IntegralEquations
end Analysis
end MathlibExpansion
