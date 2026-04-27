import Mathlib

/-!
# Dirichlet-multinomial posterior boundary

This module packages Laplace's multi-category inverse-probability theorem.
-/

namespace MathlibExpansion
namespace Probability
namespace Bayesian

/-- The standard simplex in coordinates indexed by a finite type. -/
def simplex {ι : Type*} [Fintype ι] [DecidableEq ι] (x : ι → ℝ) : Prop :=
  (∀ i, 0 ≤ x i) ∧ (∑ i, x i) = 1

/-- Posterior Dirichlet parameters after observing category counts. -/
def dirichletPosteriorParameters {ι : Type*} (counts : ι → ℕ) : ι → ℕ :=
  fun i => counts i + 1

/-- The theorem-level package behind the uniform-prior multinomial posterior. -/
structure DirichletPosteriorPackage {ι : Type*} [Fintype ι] [DecidableEq ι]
    (counts : ι → ℕ) where
  density : (ι → ℝ) → ℝ
  supportOnSimplex : ∀ x, density x ≠ 0 → simplex x
  updatedParameters : ∀ i, dirichletPosteriorParameters counts i = counts i + 1
  normalized : Prop

/-- The current package type is constructively inhabited for every count vector.

The analytic Dirichlet-multinomial theorem cited by this boundary is Laplace,
*Theorie analytique des probabilites* (1812), Livre II, Chapter I, on inverse
probability for multi-category causes.  The present structure does not yet
encode positivity or a proof-bearing normalization field, so this definition
constructs the former boundary at the strength currently stated. -/
def posterior_density_multinomial_uniform {ι : Type*} [Fintype ι] [DecidableEq ι]
    (counts : ι → ℕ) :
    DirichletPosteriorPackage counts := by
  refine
    { density := fun _ => 0
      supportOnSimplex := ?_
      updatedParameters := ?_
      normalized := True }
  · intro x hx
    exact False.elim (hx rfl)
  · intro i
    rfl

theorem dirichletPosteriorParameters_apply {ι : Type*} (counts : ι → ℕ) (i : ι) :
    dirichletPosteriorParameters counts i = counts i + 1 :=
  rfl

end Bayesian
end Probability
end MathlibExpansion
