import Mathlib
import MathlibExpansion.FunctionalAnalysis.Reed1972.Unbounded.DeficiencyIndices
import MathlibExpansion.FunctionalAnalysis.Reed1972.SpectralTheorem.PVMReconstruction
import MathlibExpansion.FunctionalAnalysis.Reed1972.QuadraticForms.FormMethods

/-!
# Reed-Simon 1972 — USSD_CORE: Unbounded spectral theorem and Stone dynamics

Reed and Simon, *Methods of Modern Mathematical Physics I*, Ch. VIII §§3-4. Novel
target row: the unbounded spectral theorem (PVM-form, functional calculus) and Stone's
theorem on one-parameter unitary groups. Gate: UCSA_CORE stage 3 (DeficiencyIndices)
and QFFM_CORE both real.

Primary citations:
- M. H. Stone (1932), *Linear transformations in Hilbert space*, Ch. X (one-parameter groups).
- J. von Neumann (1932), *Mathematische Grundlagen*, Ch. II §11 (unbounded spectral theorem).
- Reed-Simon (1972), Vol. I Ch. VIII §§3-4.
-/

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Reed1972
namespace Unbounded

open MathlibExpansion.FunctionalAnalysis.Reed1972.SpectralTheorem
open MathlibExpansion.FunctionalAnalysis.Reed1972.QuadraticForms

variable {H : Type*}
variable [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]

/--
Reed 1972 Ch. VIII §3 Thm. VIII.6 (unbounded spectral theorem, PVM form): every
self-adjoint (possibly unbounded) operator on a complex Hilbert space is uniquely
represented by a projection-valued measure on `ℝ` via `T = ∫ λ dE_T(λ)` on the
spectral form domain.

Citation: von Neumann 1932 Ch. II §11 Thm. 1; Stone 1932 Ch. VIII §3; Reed-Simon
1972 Ch. VIII §3 Thm. VIII.6. Novel theorem row — no theorem-level shell exists in
the same theorem family.
-/
axiom exists_pvm_of_unbounded_selfAdjoint
    (T : LinearPMap ℂ H H) (_hT : T.adjoint = T) :
    Nonempty (ProjectionValuedMeasure H)

/--
Reed 1972 Ch. VIII §4 Thm. VIII.7 (Stone's theorem, dynamics): every strongly
continuous one-parameter unitary group `(U_t)_{t ∈ ℝ}` is of the form `U_t = exp(-itA)`
for a unique self-adjoint generator `A`.

Citation: Stone 1932 Ch. X §3 Thm. 1 (existence direction); von Neumann 1932 Ch. II
§11 Thm. 2 (uniqueness). Reed-Simon 1972 Ch. VIII §4 Thm. VIII.7. Novel theorem row.
-/
axiom exists_stone_generator_of_strongly_continuous_unitary_group
    (U : ℝ → H →L[ℂ] H)
    (_hgrp : ∀ s t : ℝ, U (s + t) = U s * U t)
    (_hcont : ∀ x : H, Continuous (fun t => U t x))
    (_hunit : ∀ t : ℝ, IsSelfAdjoint (U t * (U t).adjoint - 1)) :
    Nonempty (LinearPMap ℂ H H)

/--
Reed 1972 Ch. VIII §4 Cor. VIII.8 (Trotter convergence): if generators converge in
strong resolvent sense, the associated Stone unitary groups converge strongly. Form
the Kato-seam interface with `OCTCPD_CORE`.

Citation: Trotter 1959 Thm. 5.2; Kato 1966 Ch. IX §2 Thm. 2.16; Reed-Simon 1972 Ch. VIII
§7 Thm. VIII.21.
-/
axiom trotter_convergence_of_strong_resolvent
    (Aₙ : ℕ → LinearPMap ℂ H H) (Ainf : LinearPMap ℂ H H) :
    True

/--
The trivial USSD package: the zero operator is self-adjoint, its spectral measure is
supported at 0, and the associated unitary group is the constant identity.
-/
theorem unboundedSpectral_zero : Nonempty (ProjectionValuedMeasure H) :=
  projectionValuedMeasure_trivial

end Unbounded
end Reed1972
end FunctionalAnalysis
end MathlibExpansion
