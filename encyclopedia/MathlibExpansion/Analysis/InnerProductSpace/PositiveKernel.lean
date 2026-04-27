import Mathlib.Data.Complex.Basic

import Mathlib.Analysis.InnerProductSpace.StarOrder

/-!
# Positive-operator kernel lemma

This file lands the bounded positive-operator kernel criterion used by the
von Neumann II.§5 queue.
-/

noncomputable section

open scoped InnerProductSpace
open ContinuousLinearMap

namespace MathlibExpansion
namespace Analysis
namespace InnerProductSpace

variable {E : Type*}
variable [NormedAddCommGroup E] [_root_.InnerProductSpace ℂ E] [CompleteSpace E]

local notation "⟪" x ", " y "⟫" => @inner ℂ _ _ x y

/-- For a positive bounded operator, vanishing quadratic form at `x` forces `T x = 0`. -/
theorem ContinuousLinearMap.IsPositive.apply_eq_zero_of_inner_eq_zero
    {T : E →L[ℂ] E} (hT : T.IsPositive) {x : E} (hx : ⟪T x, x⟫ = 0) :
    T x = 0 := by
  obtain ⟨S, hSsa, _, hSq⟩ :=
    CFC.exists_sqrt_of_isSelfAdjoint_of_spectrumRestricts hT.isSelfAdjoint hT.spectrumRestricts
  have hSx_inner : ⟪S x, S x⟫ = 0 := by
    calc
      ⟪S x, S x⟫ = ⟪(S ^ 2) x, x⟫ := by
        rw [pow_two, mul_apply, ← ContinuousLinearMap.adjoint_inner_left]
        simp [hSsa.adjoint_eq]
      _ = ⟪T x, x⟫ := by simpa [hSq]
      _ = 0 := hx
  have hSx : S x = 0 := inner_self_eq_zero.mp hSx_inner
  calc
    T x = (S ^ 2) x := by simpa [hSq]
    _ = S (S x) := by simp [pow_two]
    _ = 0 := by simp [hSx]

end InnerProductSpace
end Analysis
end MathlibExpansion
