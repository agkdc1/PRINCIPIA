import Mathlib

/-!
# Canonical coordinates of second kind

This file formalizes the commutative Banach-algebra model of Chevalley's
ordered exponential coordinates.
-/

noncomputable section

open scoped BigOperators

namespace MathlibExpansion.LieGroups.Chevalley

section

variable {𝕜 : Type*} [RCLike 𝕜]
variable {A : Type*} [NormedCommRing A] [NormedAlgebra 𝕜 A] [CompleteSpace A]
variable {n : ℕ}

/-- The linear coordinate-sum map behind ordered exponential coordinates. -/
def coordinateSumL (b : Fin n → A) : (Fin n → 𝕜) →L[𝕜] A :=
  ∑ i, (ContinuousLinearMap.proj (R := 𝕜) i).smulRight (b i)

/-- The coordinate-sum map really is the expected finite linear combination. -/
theorem coordinateSumL_apply (b : Fin n → A) (t : Fin n → 𝕜) :
    coordinateSumL (𝕜 := 𝕜) b t = ∑ i, t i • b i := by
  classical
  simp [coordinateSumL]

/-- Ordered exponential coordinates in the commutative Banach-algebra model. -/
def orderedExpMap (b : Fin n → A) : (Fin n → 𝕜) → A :=
  fun t => ∏ i, NormedSpace.exp 𝕜 (t i • b i)

@[simp] theorem orderedExpMap_zero (b : Fin n → A) :
    orderedExpMap (𝕜 := 𝕜) b 0 = 1 := by
  classical
  simp [orderedExpMap]

theorem orderedExpMap_eq_exp_sum (b : Fin n → A) (t : Fin n → 𝕜) :
    orderedExpMap (𝕜 := 𝕜) b t = NormedSpace.exp 𝕜 (∑ i, t i • b i) := by
  classical
  simpa [orderedExpMap] using
    (NormedSpace.exp_sum (𝕂 := 𝕜) (s := Finset.univ) (f := fun i : Fin n => t i • b i)).symm

theorem analyticAt_orderedExpMap (b : Fin n → A) (t : Fin n → 𝕜) :
    AnalyticAt 𝕜 (orderedExpMap (𝕜 := 𝕜) b) t := by
  classical
  have hterm :
      ∀ i : Fin n,
        AnalyticAt 𝕜 (fun s : Fin n → 𝕜 => NormedSpace.exp 𝕜 (s i • b i)) t := by
    intro i
    have hsmul : AnalyticAt 𝕜 (fun s : Fin n → 𝕜 => s i • b i) t := by
      exact ((ContinuousLinearMap.proj (R := 𝕜) i).analyticAt t).smul
        (analyticAt_const : AnalyticAt 𝕜 (fun _ : Fin n → 𝕜 => b i) t)
    have hexp : AnalyticAt 𝕜 (fun y : A => NormedSpace.exp 𝕜 y) (t i • b i) := by
      simpa using NormedSpace.exp_analytic (𝕂 := 𝕜) (𝔸 := A) (x := t i • b i)
    exact hexp.comp_of_eq' hsmul rfl
  simpa [orderedExpMap] using
    (Finset.univ.analyticAt_prod fun i _ => hterm i)

theorem orderedExpMap_eq_exp_coordinateSum (b : Fin n → A) (t : Fin n → 𝕜) :
    orderedExpMap (𝕜 := 𝕜) b t =
      NormedSpace.exp 𝕜 (coordinateSumL (𝕜 := 𝕜) b t) := by
  simp [coordinateSumL_apply, orderedExpMap_eq_exp_sum]

end

end MathlibExpansion.LieGroups.Chevalley
