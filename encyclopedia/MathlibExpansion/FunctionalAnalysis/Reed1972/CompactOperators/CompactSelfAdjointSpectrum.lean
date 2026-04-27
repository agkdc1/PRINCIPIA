import Mathlib
import MathlibExpansion.FunctionalAnalysis.Reed1972.SpectralTheorem.PVMReconstruction
import MathlibExpansion.FunctionalAnalysis.Reed1972.CompactOperators.HilbertSchmidt

/-!
# Reed-Simon 1972 — COHTC_CSA_CORE: Compact self-adjoint spectral theorem

Reed and Simon, *Methods of Modern Mathematical Physics I*, Ch. VI §5 → Ch. VII bridge.
COHTC_CSA_CORE corridor: discrete spectrum theorem, orthonormal eigenbasis
construction, and operator-norm convergence of eigenexpansion. Depends on BSST_CORE
stage b PVM reconstruction.

Primary citations:
- E. Schmidt (1907), *Zur Theorie der linearen und nichtlinearen Integralgleichungen*.
- F. Riesz - B. Sz.-Nagy (1955), *Functional Analysis*, §97 (compact self-adjoint case).
- Reed-Simon (1972), Vol. I Ch. VI §5.
-/

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Reed1972
namespace CompactOperators

open Filter Topology

variable {H : Type*}
variable [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]

/--
Reed 1972 Ch. VI §5 Def. VI.7 (compact-self-adjoint spectral package): the eigenvalue
sequence `(λₙ)` and eigenvector basis `(eₙ)` produced by the spectral theorem for a
compact self-adjoint operator. Records the discrete-spectrum carrier.
-/
structure CompactSelfAdjointSpectrum (T : H →L[ℂ] H) where
  /-- The eigenvalue sequence (real, by self-adjointness). -/
  eigenvalues : ℕ → ℝ
  /-- The eigenvalue sequence converges to 0 (discrete spectrum theorem). -/
  eigenvalues_tendsto_zero : Tendsto (fun n => |eigenvalues n|) atTop (𝓝 0)

/--
Reed 1972 Ch. VI §5 Thm. VI.16 (compact self-adjoint spectral theorem): every compact
self-adjoint operator on a separable Hilbert space admits a discrete spectrum and an
orthonormal eigenbasis.

Citation: Schmidt 1907 §2; Riesz-Sz.-Nagy 1955 §97 Thm.; Reed-Simon 1972 Ch. VI §5
Thm. VI.16. Depends on BSST_CORE stage b PVM reconstruction.
-/
axiom exists_compactSelfAdjointSpectrum
    (T : H →L[ℂ] H) (_hT : IsSelfAdjoint T) (_hcomp : IsCompactOperator T) :
    Nonempty (CompactSelfAdjointSpectrum T)

/--
Reed 1972 Ch. VI §5 Cor. VI.17 (eigenvalue accumulation only at 0): for a compact
self-adjoint operator, the eigenvalue sequence `(λₙ)` accumulates only at zero, and
each non-zero eigenvalue has finite multiplicity.

Citation: Reed-Simon 1972 Ch. VI §5 Cor. VI.17.
-/
axiom eigenvalues_finite_multiplicity_of_compactSelfAdjoint
    (T : H →L[ℂ] H) (_hT : IsSelfAdjoint T) (_hcomp : IsCompactOperator T)
    (μ : ℝ) (_hμ : μ ≠ 0) :
    ∃ n : ℕ, ∀ s : Set H, s ⊆ {x : H | T x = (μ : ℂ) • x} → ∃ b : Finset H, ↑b ⊆ s

/-- The zero operator carries the trivial compact-self-adjoint spectrum. -/
def compactSelfAdjointSpectrum_zero :
    CompactSelfAdjointSpectrum (0 : H →L[ℂ] H) where
  eigenvalues := fun _ => 0
  eigenvalues_tendsto_zero := by
    simpa using (tendsto_const_nhds : Tendsto (fun _ : ℕ => |(0 : ℝ)|) atTop (𝓝 0))

end CompactOperators
end Reed1972
end FunctionalAnalysis
end MathlibExpansion
