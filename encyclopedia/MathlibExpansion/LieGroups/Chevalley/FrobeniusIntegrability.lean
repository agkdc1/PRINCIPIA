import Mathlib

/-!
# Frobenius integrability

This file formalizes the constant-distribution model case: the horizontal
distribution on a product `E × F` integrates to affine horizontal slices.
-/

namespace MathlibExpansion.LieGroups.Chevalley

section

variable {𝕜 : Type*} [NontriviallyNormedField 𝕜]
variable {E : Type*} [NormedAddCommGroup E] [NormedSpace 𝕜 E]
variable {F : Type*} [NormedAddCommGroup F] [NormedSpace 𝕜 F]

/-- The horizontal affine slice through the fiber value `y`. -/
def horizontalSlice (y : F) : Set (E × F) := {p | p.2 = y}

/-- An affine parameterization of the horizontal slice through `p`. -/
def horizontalLeaf (p : E × F) : E → E × F := fun x => (p.1 + x, p.2)

@[simp] theorem horizontalLeaf_zero (p : E × F) :
    horizontalLeaf p 0 = p := by
  simp [horizontalLeaf]

theorem range_horizontalLeaf (p : E × F) :
    Set.range (horizontalLeaf p) = horizontalSlice p.2 := by
  ext q
  constructor
  · rintro ⟨x, rfl⟩
    simp [horizontalLeaf, horizontalSlice]
  · intro hq
    have hq' : q.2 = p.2 := by
      simpa [horizontalSlice] using hq
    refine ⟨q.1 - p.1, ?_⟩
    ext <;> simp [horizontalLeaf, hq']

theorem analyticAt_horizontalLeaf (p : E × F) (x : E) :
    AnalyticAt 𝕜 (horizontalLeaf p) x := by
  exact ((analyticAt_const.add analyticAt_id).prod analyticAt_const)

/-- The constant horizontal distribution admits an analytic integral leaf through every point. -/
theorem exists_analytic_integral_leaf_through (p : E × F) :
    ∃ f : E → E × F, AnalyticAt 𝕜 f 0 ∧ f 0 = p ∧ Set.range f = horizontalSlice p.2 := by
  refine ⟨horizontalLeaf p, analyticAt_horizontalLeaf p 0, horizontalLeaf_zero p, ?_⟩
  exact range_horizontalLeaf p

end

end MathlibExpansion.LieGroups.Chevalley
