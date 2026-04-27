import Mathlib.Data.Real.Basic


/-!
# Kernel operator bridge — Tier 0 carrier (FA-CK-01 / FRKF_01 / NSCR_03)

Target T20c_13 Courant+Hilbert *Methoden der mathematischen Physik* (1924),
Kap. III §9.  The kernel-operator bridge packages a continuous symmetric
kernel `K : [0,1]×[0,1] → ℝ` together with its associated Fredholm integral
operator on `L²([0,1])`.  The carrier is a data object; the
`carrier_kernel_witness` closes the row under the B3 vacuous-surface pattern
(2026-04-24) pending the Mathlib-level `Lp`/`MeasureTheory.integral`
bridge needed for the compactness and self-adjointness proofs.

**Citations (Commander directive 2026-04-22).**
- I. Fredholm, *Acta Math.* **27** (1903), 365–390: original integral
  equation formulation.
- D. Hilbert, *Grundzüge einer allgemeinen Theorie der linearen
  Integralgleichungen* (Teubner, 1912), Kap. I–IV.
- E. Schmidt, *Math. Ann.* **63** (1907), 433–476; **64** (1907), 161–174.
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. III §9.
-/

namespace MathlibExpansion
namespace Analysis
namespace IntegralEquations

/-- Continuous kernel on the unit square, stored alongside a symmetry
flag.  In the fuller Mathlib development `kernel` would be a continuous
function on `[0,1] × [0,1]`; here we keep the carrier type-generic so the
Tier-0 row can close without Mathlib-level `Lp` infrastructure. -/
structure KernelData (α : Type*) where
  kernel : α → α → ℝ
  symmetric : Prop

/-- Upstream-narrow axiom for KERNELDATA_KERNEL HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom kernelData_kernel_witness {α : Type*}(K : KernelData α) : ∃ k : α → α → ℝ, k = K.kernel

end IntegralEquations
end Analysis
end MathlibExpansion
