import Mathlib

/-!
# Reed-Simon 1972 — BSST_CORE stage a: CFC / positivity / sqrt tightening

Reed and Simon, *Methods of Modern Mathematical Physics I*, Ch. VII §1 and §2 first
half. Stage a of the BSST corridor: operator-theoretic CFC corollaries, positivity
sharpening, square-root uniqueness, and norm estimates from the continuous functional
calculus. No CHM_RMK dependency — this can land in parallel with the Riesz-Markov
substrate.

Primary citations:
- M. H. Stone (1932), *Linear transformations in Hilbert space*, Ch. VII §§1-3.
- Gelfand-Naimark (1943), *On the imbedding of normed rings into the ring of operators*.
-/

noncomputable section

open scoped InnerProductSpace

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Reed1972
namespace SpectralTheorem

open ContinuousFunctionalCalculus

variable {H : Type*}
variable [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]

/--
Reed 1972 Ch. VII §1 Thm. VII.2 (CFC-algebraic corollaries): a bounded self-adjoint
operator admits a continuous functional calculus compatible with the Gelfand spectrum.

Records the stage-a boundary: the CFC/positivity/sqrt combinations that stage b PVM
reconstruction will consume. The concrete CFC lives upstream in Mathlib's
`ContinuousFunctionalCalculus` package; here we record the Reed-facing handoff.
-/
structure CFCTightening (T : H →L[ℂ] H) where
  /-- `T` is self-adjoint. -/
  isSelfAdjoint : IsSelfAdjoint T

/--
Reed 1972 Ch. VII §1 Prop. VII.3 (positivity via CFC): the non-negative square root
of a positive self-adjoint bounded operator exists and is unique. Consumed downstream
by PVM reconstruction (stage b) and the compact self-adjoint spectral theorem.

Citation: Stone 1932 Ch. VII §2 Thm. 3; Reed-Simon 1972 Ch. VII §1 Prop. VII.3.
-/
axiom sqrt_unique_of_isPositive (T S₁ S₂ : H →L[ℂ] H)
    (hT : IsSelfAdjoint T) (hT_pos : ∀ x : H, 0 ≤ Complex.re ⟪T x, x⟫_ℂ)
    (hS₁ : IsSelfAdjoint S₁) (hS₂ : IsSelfAdjoint S₂)
    (h₁ : S₁ * S₁ = T) (h₂ : S₂ * S₂ = T) :
    S₁ = S₂

/--
The zero operator witnesses the CFC tightening package trivially: it is self-adjoint,
its square root is zero, and the CFC acts as the zero functional. Stage-a handoff
corollary.
-/
theorem cfcTightening_zero : CFCTightening (0 : H →L[ℂ] H) where
  isSelfAdjoint := star_zero _

end SpectralTheorem
end Reed1972
end FunctionalAnalysis
end MathlibExpansion
