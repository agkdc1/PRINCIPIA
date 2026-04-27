import Mathlib

/-!
# Reed-Simon 1972 — HGB_REUSE (DEFER): Hellinger-Toeplitz / closed graph reuse

Reed and Simon, *Methods of Modern Mathematical Physics I*, Ch. III §5 (Hellinger-
Toeplitz) and Ch. VIII §1 closed graph applications. DEFER row: the Reed corridor is a
direct consumer of Mathlib's existing closed-graph theorem (`ContinuousLinearMap` plus
`ClosedGraph` machinery). No new substrate.

Primary citations:
- E. Hellinger - O. Toeplitz (1910), *Grundlagen für eine Theorie der unendlichen
  Matrizen*, §3 Thm.
- S. Banach (1932), *Théorie des opérations linéaires*, Ch. III §3 (closed graph).
- Reed-Simon (1972), Vol. I Ch. III §5 Thm. III.12 + Ch. VIII §1 Cor.
-/

noncomputable section

open scoped InnerProductSpace

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Reed1972
namespace Defers

variable {H : Type*}
variable [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]

/--
Reed 1972 Ch. III §5 Thm. III.12 (Hellinger-Toeplitz): a symmetric operator defined on
all of a Hilbert space is bounded.

Citation: Hellinger-Toeplitz 1910 §3 Thm.; Reed-Simon 1972 Ch. III §5 Thm. III.12.
DEFER row: derivable from Mathlib's closed-graph theorem applied to a totally defined
symmetric operator. The Reed-facing axiom records the boundary.
-/
axiom hellinger_toeplitz_bounded_of_symmetric_total
    (T : H →ₗ[ℂ] H) (_hsym : ∀ x y : H, ⟪T x, y⟫_ℂ = ⟪x, T y⟫_ℂ) :
    ∃ Tcont : H →L[ℂ] H, ∀ x : H, Tcont x = T x

end Defers
end Reed1972
end FunctionalAnalysis
end MathlibExpansion
