import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic

import Mathlib.Analysis.InnerProductSpace.StarOrder
import Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Order

/-!
# Quadratic-form bounds for bounded self-adjoint operators

This file proves the bounded-self-adjoint quadratic-form criterion from
von Neumann II.§5.

Primary sources:
- J. von Neumann (1932), *Mathematische Grundlagen der Quantenmechanik*, Ch. II §5, Satz 18.
- E. Hellinger and O. Toeplitz (1927), *Integralgleichungen und Gleichungen mit unendlich vielen
  Unbekannten*, Enzyklopädie der mathematischen Wissenschaften, IV C 2, §§ 8-10.
-/

noncomputable section

open scoped InnerProductSpace
open RCLike

namespace MathlibExpansion
namespace Analysis
namespace InnerProductSpace

variable {E : Type*}
variable [NormedAddCommGroup E] [_root_.InnerProductSpace ℂ E] [CompleteSpace E]

local notation "⟪" x ", " y "⟫" => @inner ℂ _ _ x y

/-- The real scalar operator has quadratic form `c * ‖x‖ ^ 2`. -/
theorem ContinuousLinearMap.re_inner_algebraMap_apply (c : ℝ) (x : E) :
    RCLike.re ⟪(algebraMap ℝ (E →L[ℂ] E) c) x, x⟫ = c * ‖x‖ ^ 2 := by
  rw [Algebra.algebraMap_eq_smul_one, ← algebraMap_smul ℂ c (1 : E →L[ℂ] E),
    ContinuousLinearMap.coe_smul', Pi.smul_apply, ContinuousLinearMap.one_apply, inner_smul_left,
    RCLike.algebraMap_eq_ofReal, conj_ofReal, re_ofReal_mul, inner_self_eq_norm_sq, mul_comm]

/-- Quadratic-form boundedness criterion for bounded self-adjoint operators.

This is the bounded self-adjoint norm criterion used in von Neumann (1932),
*Mathematische Grundlagen der Quantenmechanik*, Ch. II §5, Satz 18. -/
theorem ContinuousLinearMap.norm_le_of_isSelfAdjoint_quadratic_form_bound
    {R : E →L[ℂ] E} {C : ℝ} (hR : IsSelfAdjoint R) (hC : 0 ≤ C)
    (hbound : ∀ x, ‖⟪R x, x⟫‖ ≤ C * ‖x‖ ^ 2) :
    ‖R‖ ≤ C := by
  let A := E →L[ℂ] E
  have hR_le_alg : R ≤ algebraMap ℝ A C := by
    rw [ContinuousLinearMap.le_def]
    refine ⟨(IsSelfAdjoint.algebraMap A (IsSelfAdjoint.all C)).sub hR, fun x => ?_⟩
    rw [ContinuousLinearMap.reApplyInnerSelf_apply, ContinuousLinearMap.sub_apply, inner_sub_left, map_sub,
      ContinuousLinearMap.re_inner_algebraMap_apply]
    exact sub_nonneg.mpr ((RCLike.re_le_norm ⟪R x, x⟫).trans (hbound x))
  have hneg_alg_le_R : algebraMap ℝ A (-C) ≤ R := by
    rw [ContinuousLinearMap.le_def]
    refine ⟨hR.sub (IsSelfAdjoint.algebraMap A (IsSelfAdjoint.all (-C))), fun x => ?_⟩
    have hre_lower : -(C * ‖x‖ ^ 2) ≤ RCLike.re ⟪R x, x⟫ := by
      exact (neg_le_neg (hbound x)).trans ((abs_le.mp (RCLike.abs_re_le_norm ⟪R x, x⟫)).1)
    rw [ContinuousLinearMap.reApplyInnerSelf_apply, ContinuousLinearMap.sub_apply, inner_sub_left, map_sub,
      ContinuousLinearMap.re_inner_algebraMap_apply]
    linarith
  have hspectrum_le :
      ∀ r ∈ spectrum ℝ R, r ≤ C :=
    (le_algebraMap_iff_spectrum_le (a := R) (r := C) (ha := hR)).mp hR_le_alg
  have hneg_le_spectrum :
      ∀ r ∈ spectrum ℝ R, -C ≤ r :=
    (algebraMap_le_iff_le_spectrum (a := R) (r := -C) (ha := hR)).mp hneg_alg_le_R
  obtain hsub | hnontriv := subsingleton_or_nontrivial A
  · have hzero : R = 0 := Subsingleton.elim R 0
    rw [hzero, norm_zero]
    exact hC
  · letI := hnontriv
    rcases CStarAlgebra.norm_or_neg_norm_mem_spectrum (a := R) hR with hnorm_mem | hneg_norm_mem
    · exact hspectrum_le ‖R‖ hnorm_mem
    · have hneg_bound := hneg_le_spectrum (-‖R‖) hneg_norm_mem
      linarith [norm_nonneg R]

end InnerProductSpace
end Analysis
end MathlibExpansion
