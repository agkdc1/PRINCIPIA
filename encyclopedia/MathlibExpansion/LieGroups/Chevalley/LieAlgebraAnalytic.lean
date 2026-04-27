import MathlibExpansion.LieGroups.Chevalley.LeftInvariantVectorFields

/-!
# Lie algebra of an analytic group

This file records the Lie-algebra structure carried by left-invariant
derivations, which is the honest Mathlib substrate currently available for the
analytic-group side of Chevalley.
-/

noncomputable section

open scoped Manifold

namespace MathlibExpansion.LieGroups.Chevalley

abbrev lieAlgebraOfAnalyticGroup
    {𝕜 : Type*} [NontriviallyNormedField 𝕜]
    {H : Type*} [TopologicalSpace H]
    {E : Type*} [NormedAddCommGroup E] [NormedSpace 𝕜 E]
    (I : ModelWithCorners 𝕜 E H) (G : Type*)
    [TopologicalSpace G] [ChartedSpace H G] [Monoid G] [ContMDiffMul I ⊤ G] : Type _ :=
  LeftInvariantDerivation I G

section

variable {𝕜 : Type*} [NontriviallyNormedField 𝕜]
variable {H : Type*} [TopologicalSpace H]
variable {E : Type*} [NormedAddCommGroup E] [NormedSpace 𝕜 E]
variable {I : ModelWithCorners 𝕜 E H}
variable {G : Type*} [TopologicalSpace G] [ChartedSpace H G] [Monoid G] [ContMDiffMul I ⊤ G]

theorem lieAlgebraOfAnalyticGroup_def :
    lieAlgebraOfAnalyticGroup I G = LeftInvariantDerivation I G :=
  rfl

instance : Inhabited (lieAlgebraOfAnalyticGroup I G) :=
  inferInstance

instance : AddCommGroup (lieAlgebraOfAnalyticGroup I G) :=
  inferInstance

instance : Module 𝕜 (lieAlgebraOfAnalyticGroup I G) :=
  inferInstance

instance : LieRing (lieAlgebraOfAnalyticGroup I G) :=
  inferInstance

instance : LieAlgebra 𝕜 (lieAlgebraOfAnalyticGroup I G) :=
  inferInstance

/-- Evaluation at the identity is a linear map from the Chevalley Lie algebra. -/
abbrev lieAlgebraEvalAtOne :
    lieAlgebraOfAnalyticGroup I G →ₗ[𝕜] PointDerivation I (1 : G) :=
  LeftInvariantDerivation.evalAt (I := I) (g := (1 : G))

/-- The bracket stays inside the same left-invariant Lie algebra. -/
theorem bracket_mem
    (X Y : lieAlgebraOfAnalyticGroup I G) :
    ⁅X, Y⁆ ∈ (Set.univ : Set (lieAlgebraOfAnalyticGroup I G)) := by
  trivial

end

section GeneralLinear

variable {𝕜 : Type*} [RCLike 𝕜]
variable {V : Type*} [NormedAddCommGroup V] [NormedSpace 𝕜 V] [CompleteSpace V]

/-- Chevalley's concrete Lie algebra model for `GL(V)`: continuous endomorphisms of `V`. -/
abbrev generalLinearLieAlgebra := V →L[𝕜] V

/-- The commutator bracket on the concrete `GL(V)` Lie algebra model. -/
def generalLinearCommutator (X Y : generalLinearLieAlgebra (𝕜 := 𝕜) (V := V)) :
    generalLinearLieAlgebra (𝕜 := 𝕜) (V := V) :=
  X * Y - Y * X

@[simp] theorem generalLinearCommutator_apply
    (X Y : generalLinearLieAlgebra (𝕜 := 𝕜) (V := V)) (v : V) :
    generalLinearCommutator (𝕜 := 𝕜) (V := V) X Y v = X (Y v) - Y (X v) := by
  simp [generalLinearCommutator]

@[simp] theorem generalLinearLeftInvariantField_evalAtOne
    (X : generalLinearLieAlgebra (𝕜 := 𝕜) (V := V)) :
    generalLinearLeftInvariantField (𝕜 := 𝕜) (V := V) X 1 = X := by
  simpa using
    generalLinearLeftInvariantField_one (𝕜 := 𝕜) (V := V) X

theorem generalLinearLeftInvariantField_injective :
    Function.Injective
      (generalLinearLeftInvariantField (𝕜 := 𝕜) (V := V) :
        generalLinearLieAlgebra (𝕜 := 𝕜) (V := V) →
          GeneralLinearGroup (𝕜 := 𝕜) (V := V) → generalLinearLieAlgebra (𝕜 := 𝕜) (V := V)) := by
  intro X Y h
  simpa using congrFun h 1

theorem generalLinearLeftInvariantField_commutator (X Y : generalLinearLieAlgebra (𝕜 := 𝕜) (V := V))
    (g : GeneralLinearGroup (𝕜 := 𝕜) (V := V)) :
    generalLinearLeftInvariantField (𝕜 := 𝕜) (V := V)
        (generalLinearCommutator (𝕜 := 𝕜) (V := V) X Y) g =
      (g : V →L[𝕜] V) * (X * Y) - (g : V →L[𝕜] V) * (Y * X) := by
  simp [generalLinearLeftInvariantField, generalLinearCommutator, mul_assoc, mul_sub]

end GeneralLinear

end MathlibExpansion.LieGroups.Chevalley
