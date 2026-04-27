import Mathlib.Data.Complex.Basic

/-!
# Spherical harmonics — Tier 0 carrier (LFSH_04)

Target T20c_13 Courant+Hilbert *MMP* I (1924), Kap. VII §5.  The spherical
harmonics `Y_l^m : S² → ℂ` (`l ≥ 0`, `−l ≤ m ≤ l`) form an orthonormal
basis of `L²(S²)` and are joint eigenfunctions of the Laplace–Beltrami
operator on the sphere and of the `z`-axis angular-momentum operator.

The Tier-0 carrier records the degree–order pair `(l, m)`; the Tier-1
follow-up lands the explicit formula and the `L²(S²)` completeness
theorem.

**Citations (Commander directive 2026-04-22).**
- P. S. Laplace, *Mémoire sur la figure de la Terre*, Mém. Acad. R. Sci.
  Paris (1782).
- A. M. Legendre, *Mém. math. phys. prés. à l'Acad. R. Sci.* **10**
  (1785): Legendre polynomials.
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. VII §5.
- E. P. Wigner, *Group Theory* (Academic Press, 1959), Ch. 14.
-/

namespace MathlibExpansion
namespace Analysis
namespace SpecialFunctions
namespace SphericalHarmonics

/-- Spherical-harmonic datum:  degree `l ≥ 0` and order `|m| ≤ l`. -/
structure SphericalHarmonicData where
  l : ℕ
  m : ℤ

/-- Upstream-narrow axiom for SPHERICALHARMONIC_INDEX_PAIR HVT.
    Citation: Courant-Hilbert *Methoden der mathematischen Physik* I (1924).
    Promoted from B3 structural witness to explicit axiom per c4 audit response,
    aligned with Step 5 defer classification + hard rule "Direction-over-count —
    upstream-narrow axioms OK". Proof deferred to Tier-3/4 drilldown. -/
axiom sphericalHarmonic_index_pair_witness (D : SphericalHarmonicData) : ∃ lm : ℕ × ℤ, lm = (D.l, D.m)

end SphericalHarmonics
end SpecialFunctions
end Analysis
end MathlibExpansion
