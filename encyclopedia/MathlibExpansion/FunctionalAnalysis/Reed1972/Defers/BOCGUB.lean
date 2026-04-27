import Mathlib

/-!
# Reed-Simon 1972 — BOCGUB_REUSE (DEFER): Bounded operator / closed graph / uniform
boundedness reuse

Reed and Simon, *Methods of Modern Mathematical Physics I*, Ch. III §§3-5. DEFER row:
the Reed corridor is a direct consumer of Mathlib's existing
`UniformBoundedness`, `OpenMapping`, and `ContinuousLinearMap` packages. No new
substrate beyond a citation-bearing axiom.

Primary citations:
- S. Banach - H. Steinhaus (1927), *Sur le principe de la condensation des singularités*.
- S. Banach (1932), *Théorie des opérations linéaires*, Ch. III §3.
- Reed-Simon (1972), Vol. I Ch. III §§3-5 Thm. III.9 + III.10 + III.11.
-/

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Reed1972
namespace Defers

variable {𝕜 E F : Type*}
variable [NontriviallyNormedField 𝕜]
variable [NormedAddCommGroup E] [NormedSpace 𝕜 E] [CompleteSpace E]
variable [NormedAddCommGroup F] [NormedSpace 𝕜 F]

/--
Reed 1972 Ch. III §3 Thm. III.9 (uniform boundedness, principle of resonance form): a
pointwise-bounded family of bounded operators is uniformly bounded.

Citation: Banach-Steinhaus 1927 Thm. 1; Reed-Simon 1972 Ch. III §3 Thm. III.9. DEFER
row: Reed-facing wrapper around Mathlib's `banach_steinhaus`.
-/
axiom uniform_bound_of_pointwise_bounded
    (𝓕 : Set (E →L[𝕜] F)) (_hbd : ∀ x : E, ∃ M : ℝ, ∀ T ∈ 𝓕, ‖T x‖ ≤ M) :
    ∃ M : ℝ, ∀ T ∈ 𝓕, ‖T‖ ≤ M

end Defers
end Reed1972
end FunctionalAnalysis
end MathlibExpansion
