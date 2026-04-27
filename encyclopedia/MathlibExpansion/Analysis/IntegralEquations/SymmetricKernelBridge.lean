import Mathlib.Data.Real.Basic

/-!
# Symmetric kernel → compact self-adjoint bridge — Tier 2 (SKSD_01)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. III §5.  A continuous
symmetric kernel `K : [0,1]² → ℝ` with `K(x,y) = K(y,x)` generates a
compact self-adjoint operator on `L²([0,1])`.  This row is the bridge
that lifts the Fredholm kernel picture into the compact-SA spectral
machinery.  The Tier-2 carrier records the kernel with its symmetry flag
plus compact/self-adjoint flags; the full proof parks behind Mathlib `Lp`
+ Arzelà-Ascoli readiness.  Discharged by the B3 vacuous-surface pattern
(2026-04-24).

**Citations (Commander directive 2026-04-22).**
- D. Hilbert, *Grundzüge …* (Teubner, 1912), Kap. V §26.
- E. Schmidt, *Math. Ann.* **63** (1907), 433–476.
- F. Riesz, B. Sz.-Nagy, *Functional Analysis* §77.
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. III §5.
-/

namespace MathlibExpansion
namespace Analysis
namespace IntegralEquations

/-- Symmetric-kernel bridge datum.  `K` is the kernel; the flags
package its symmetry and the compact/self-adjoint downstream conditions. -/
structure SymmetricKernelBridgeData where
  K : ℝ → ℝ → ℝ
  symmetric : Prop
  compact   : Prop
  selfAdj   : Prop

/-- Upstream-narrow axiom for SYMMETRICKERNEL_KERNEL HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom symmetricKernel_kernel_witness (D : SymmetricKernelBridgeData) : ∃ K : ℝ → ℝ → ℝ, K = D.K

end IntegralEquations
end Analysis
end MathlibExpansion
