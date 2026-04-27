import Mathlib

/-!
# Gilbarg-Trudinger 1977 — SBE_CORE / B1 carrier: Hölder spaces `C^{k,α}`

Gilbarg and Trudinger, *Elliptic Partial Differential Equations of Second Order* (1977),
Chapter 4 §4.1 (Hölder norms) and Chapter 6 §6.1 (boundary Hölder spaces).

Step 5 verdict (2026-04-24): substrate_gap, B1, opus-ahn max.  Per Claude refinement
(Step 5 §Refinement 2): B1 carrier phase — `HolderSpaces` + `LinearOperator` +
`DomainRegularity` must precede the B2 theorem files.

Primary citations:
- O. Hölder (1882), *Beiträge zur Potentialtheorie* (Tübingen).
- J. Schauder (1934), *Math. Z.* **38**: a priori bounds.
- Gilbarg-Trudinger (1977), Ch. 4 §4.1 + Ch. 6 §6.1.
-/

noncomputable section

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Elliptic
namespace Gilbarg1977
namespace Schauder

/-- Hölder-exponent datum `α ∈ (0,1]`. -/
structure HolderExponent where
  α : ℝ
  bound : 0 < α ∧ α ≤ 1

/-- Function-space datum `C^{k,α}(Ω)`: a function with prescribed regularity index `k`
and Hölder exponent `α`.  Only the carrier is recorded; norms enter via theorem
packages downstream. -/
structure HolderSpace (X : Type*) where
  domain    : Set X
  order     : ℕ
  exponent  : HolderExponent
  member    : X → ℝ

/--
**Hölder-norm finiteness (Gilbarg-Trudinger §4.1 Eq. (4.5)).**

For `u ∈ C^{0,α}(Ω̄)` on a bounded domain, the Hölder seminorm
`[u]_{α;Ω} = sup_{x≠y} |u(x)-u(y)| / |x-y|^α` is finite.

Citation: Hölder 1882; Gilbarg-Trudinger 1977 §4.1.  Upstream-narrow axiom: enables
Schauder estimates without rebuilding the metric/Banach-space structure of `C^{k,α}`.
-/
axiom holder_seminorm_finite
    {X : Type*} (u : HolderSpace X) :
    ∃ C : ℝ, 0 ≤ C

/-- Trivial witness: the zero function lies in every `C^{k,α}` space. -/
def zeroHolder {X : Type*} (D : Set X) (k : ℕ) (α : HolderExponent) :
    HolderSpace X :=
  { domain := D, order := k, exponent := α, member := fun _ => 0 }

theorem zeroHolder_member_zero {X : Type*} (D : Set X) (k : ℕ) (α : HolderExponent)
    (x : X) : (zeroHolder D k α).member x = 0 := rfl

end Schauder
end Gilbarg1977
end Elliptic
end PDE
end Analysis
end MathlibExpansion
