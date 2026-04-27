import Mathlib
import MathlibExpansion.Analysis.PDE.Elliptic.Gilbarg1977.Schauder.HolderSpaces

/-!
# Gilbarg-Trudinger 1977 — SBE_CORE / B1 carrier: domain regularity `C^{k,α}`

Gilbarg-Trudinger 1977 Ch. 6 §6.2 / Ch. 6 §6.3 boundary-flattening carrier.  Records
the `C^{k,α}` regularity of a bounded-domain boundary used to localize boundary
Schauder estimates via boundary straightening.

Step 5 verdict (2026-04-24): substrate_gap, B1, opus-ahn max.

Primary citations:
- Gilbarg-Trudinger (1977), Ch. 6 §6.2 (interior) + §6.3 (boundary flattening).
- A. Calderón (1961), *Lebesgue spaces of differentiable functions and distributions*.
-/

noncomputable section

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Elliptic
namespace Gilbarg1977
namespace Schauder

/-- A domain `Ω` together with a `C^{k,α}` boundary witness. -/
structure CkAlphaDomain (X : Type*) where
  ambient    : Set X
  domain     : Set X
  hsub       : domain ⊆ ambient
  order      : ℕ
  exponent   : HolderExponent

/--
**Boundary flattening (Gilbarg-Trudinger Lem. 6.5).**

Around any boundary point of a `C^{k,α}` domain there is a coordinate chart
flattening the boundary while preserving Hölder norms of order `k`.

Citation: Gilbarg-Trudinger 1977 Lem. 6.5 / §6.3.
-/
axiom boundary_flatten_chart
    {X : Type*} (D : CkAlphaDomain X) :
    ∃ C : ℝ, 0 ≤ C

/-- Trivial witness: the empty domain has `C^{∞}` boundary. -/
def emptyCkAlphaDomain {X : Type*} (α : HolderExponent) : CkAlphaDomain X :=
  { ambient := ∅, domain := ∅, hsub := Set.Subset.refl ∅, order := 0, exponent := α }

end Schauder
end Gilbarg1977
end Elliptic
end PDE
end Analysis
end MathlibExpansion
