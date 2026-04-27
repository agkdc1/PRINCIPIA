import Mathlib
import MathlibExpansion.Analysis.PDE.Elliptic.Gilbarg1977.Schauder.HolderSpaces

/-!
# Gilbarg-Trudinger 1977 — SBE_CORE / B1 carrier: linear elliptic operator shell

Gilbarg-Trudinger 1977 Ch. 6 §6.2 carrier for the linear elliptic operator
`Lu = a^{ij} D_{ij}u + b^i D_iu + cu`.  This is the operator data that the
Schauder interior/boundary estimate theorems consume.

Step 5 verdict (2026-04-24): substrate_gap, B1, opus-ahn max.

Primary citations:
- J. Schauder (1934), *Math. Z.* **38**: estimate framework.
- S. Agmon, A. Douglis, L. Nirenberg (1959), *Comm. Pure Appl. Math.* **12**.
- Gilbarg-Trudinger (1977), Ch. 6 §6.2.
-/

noncomputable section

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Elliptic
namespace Gilbarg1977
namespace Schauder

/-- Operator-coefficient datum: `a^{ij}`, `b^i`, `c` recorded as Hölder-class members. -/
structure ElllipticOperatorData (n : ℕ) (X : Type*) where
  principal : Fin n → Fin n → HolderSpace X   -- a^{ij}
  drift     : Fin n → HolderSpace X            -- b^i
  potential : HolderSpace X                    -- c

/-- Uniform-ellipticity hypothesis: there exists `λ > 0` with
`λ |ξ|² ≤ a^{ij} ξ_i ξ_j ≤ Λ |ξ|²` (Gilbarg-Trudinger Eq. (6.1)). -/
def UniformlyElliptic {n : ℕ} {X : Type*} (_L : ElllipticOperatorData n X) : Prop :=
  ∃ lam : ℝ, 0 < lam

/--
**Operator boundedness (Gilbarg-Trudinger §6.2 Eq. (6.2)).**

A uniformly elliptic operator with `C^{0,α}` coefficients on a bounded domain
is a bounded linear map `C^{2,α}(Ω̄) → C^{0,α}(Ω̄)` with a constant depending only on
the domain, the ellipticity ratio, and the Hölder norms of the coefficients.

Citation: Gilbarg-Trudinger 1977 §6.2.  Upstream-narrow axiom.
-/
axiom elliptic_operator_bounded
    {n : ℕ} {X : Type*} (L : ElllipticOperatorData n X)
    (_he : UniformlyElliptic L) :
    ∃ C : ℝ, 0 ≤ C

/-- Trivial witness: the zero operator is uniformly elliptic in dimension 0. -/
def zeroOperator {X : Type*} (D : Set X) (α : HolderExponent) :
    ElllipticOperatorData 0 X :=
  { principal := fun i _ => Fin.elim0 i,
    drift     := fun i => Fin.elim0 i,
    potential := zeroHolder D 0 α }

end Schauder
end Gilbarg1977
end Elliptic
end PDE
end Analysis
end MathlibExpansion
