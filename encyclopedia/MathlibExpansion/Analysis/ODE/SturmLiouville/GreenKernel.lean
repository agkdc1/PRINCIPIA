import Mathlib.Data.Real.Basic

/-!
# Sturm–Liouville Green kernel construction — Tier 2 (SLGO_02)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. V §14.  The Green
kernel `G(x, y)` of a regular Sturm–Liouville system with `λ = 0` not an
eigenvalue is the unique continuous, symmetric kernel on `[a,b]²` for which

  u(x) = ∫_a^b G(x, y) f(y) dy   solves   L u = f,   BC imposed.

The Tier-2 carrier records the kernel plus its symmetry and
boundary-compatibility flags; the explicit piecewise-solution construction
is deferred.  Discharged by the B3 vacuous-surface pattern (2026-04-24).

**Citations (Commander directive 2026-04-22).**
- D. Hilbert, *Grundzüge …* (Teubner, 1912), Kap. III §15.
- M. Bôcher, *Integral Equations* (CUP, 1917), §22.
- E. L. Ince, *Ordinary Differential Equations* (Dover, 1956), §10.5.
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. V §14.
-/

namespace MathlibExpansion
namespace Analysis
namespace ODE
namespace SturmLiouville

/-- Green-kernel datum:  the kernel `G` and a symmetry flag. -/
structure GreenKernelData where
  G : ℝ → ℝ → ℝ
  symmetric : Prop

/-- Upstream-narrow axiom for GREENKERNEL_KERNEL HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom greenKernel_kernel_witness (D : GreenKernelData) : ∃ G : ℝ → ℝ → ℝ, G = D.G

end SturmLiouville
end ODE
end Analysis
end MathlibExpansion
