import Mathlib
import MathlibExpansion.FunctionalAnalysis.Banach1932.AssociatedOperators

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Banach1932
namespace Fredholm

variable {𝕜 E : Type*}
variable [RCLike 𝕜]
variable [NormedAddCommGroup E] [NormedSpace 𝕜 E] [CompleteSpace E]

@[simp]
theorem dualMapCLM_smul (T : E →L[𝕜] E) (a : 𝕜) :
    AssociatedOperators.dualMapCLM (a • T) = a • AssociatedOperators.dualMapCLM T := by
  ext φ x
  simp [AssociatedOperators.dualMapCLM_apply]

private theorem isCompactOperator_smul_of_isCompactOperator
    (T : E →L[𝕜] E) (hT : IsCompactOperator T) (a : 𝕜) :
    IsCompactOperator (a • T) := by
  simpa using hT.smul a

/--
Banach `1932`, *Théorie des opérations linéaires*, Ch. X, §1, Théorème 11,
pp. 143-144: if `U` is totally continuous, the range of `I - U` is closed. Banach's
same Fredholm block cites the historical parents F. Riesz, *Acta Mathematica* 41 (1918),
pp. 96-98; T. H. Hildebrandt, *Acta Mathematica* 51 (1928), pp. 311-318; and
J. Schauder, *Studia Mathematica* 2 (1930), pp. 183-196.
-/
axiom isClosed_range_id_sub_of_isCompactOperator
    (T : E →L[𝕜] E) (hT : IsCompactOperator T) :
    IsClosed (Set.range (((1 : E →L[𝕜] E) - T) : E →L[𝕜] E))

/--
Banach `1932`, *Théorie des opérations linéaires*, Ch. X, §1, Théorème 12,
p. 144: if `U` is totally continuous, the homogeneous equation `(I - U)x = 0`
has only finitely many linearly independent solutions.
-/
axiom finiteDimensional_ker_id_sub_of_isCompactOperator
    (T : E →L[𝕜] E) (hT : IsCompactOperator T) :
    FiniteDimensional 𝕜 (LinearMap.ker (((1 : E →L[𝕜] E) - T).toLinearMap))

/--
Scalar Fredholm-kernel finite-dimensionality, obtained by applying Banach `1932`, Ch. X,
§1, Théorème 12 to the compact operator `h • T`.
-/
theorem finiteDimensional_ker_id_sub_smul_of_isCompactOperator
    (T : E →L[𝕜] E) (hT : IsCompactOperator T) {h : 𝕜} (hh : h ≠ 0) :
    FiniteDimensional 𝕜 (LinearMap.ker (((1 : E →L[𝕜] E) - h • T).toLinearMap)) := by
  have _ := hh
  simpa using
    finiteDimensional_ker_id_sub_of_isCompactOperator (𝕜 := 𝕜) (E := E) (h • T)
      (isCompactOperator_smul_of_isCompactOperator (𝕜 := 𝕜) (E := E) T hT h)

/--
Banach `1932`, *Théorie des opérations linéaires*, Ch. X, §1, Théorème 15,
pp. 145-147: the homogeneous equations `(I - U)x = 0` and `(I - U*)X = 0`
have the same number of linearly independent solutions. Banach's footnote gives the
paper lineage: F. Riesz, *Acta Mathematica* 41 (1918), pp. 96-98; T. H. Hildebrandt,
*Acta Mathematica* 51 (1928), pp. 311-318; J. Schauder, *Studia Mathematica* 2
(1930), pp. 183-196.
-/
axiom rank_ker_id_sub_eq_rank_ker_id_sub_associated
    (T : E →L[𝕜] E) (hT : IsCompactOperator T) :
    Cardinal.lift
        (Module.rank 𝕜 (LinearMap.ker (((1 : E →L[𝕜] E) - T).toLinearMap))) =
      Module.rank 𝕜
        (LinearMap.ker
          (((1 : NormedSpace.Dual 𝕜 E →L[𝕜] NormedSpace.Dual 𝕜 E) -
              AssociatedOperators.dualMapCLM T).toLinearMap))

/--
Scalar associated-nullity equality, obtained by applying Banach `1932`, Ch. X, §1,
Théorème 15 to the compact operator `h • T`.
-/
theorem rank_ker_id_sub_smul_eq_rank_ker_id_sub_smul_associated
    (T : E →L[𝕜] E) (hT : IsCompactOperator T) {h : 𝕜} (hh : h ≠ 0) :
    Cardinal.lift
        (Module.rank 𝕜 (LinearMap.ker (((1 : E →L[𝕜] E) - h • T).toLinearMap))) =
      Module.rank 𝕜
        (LinearMap.ker
          (((1 : NormedSpace.Dual 𝕜 E →L[𝕜] NormedSpace.Dual 𝕜 E) -
              h • AssociatedOperators.dualMapCLM T).toLinearMap)) := by
  have _ := hh
  have hbase :=
    rank_ker_id_sub_eq_rank_ker_id_sub_associated (𝕜 := 𝕜) (E := E) (h • T)
      (isCompactOperator_smul_of_isCompactOperator (𝕜 := 𝕜) (E := E) T hT h)
  have hmap :
      (((1 : NormedSpace.Dual 𝕜 E →L[𝕜] NormedSpace.Dual 𝕜 E) -
          AssociatedOperators.dualMapCLM (h • T)).toLinearMap) =
        (((1 : NormedSpace.Dual 𝕜 E →L[𝕜] NormedSpace.Dual 𝕜 E) -
          h • AssociatedOperators.dualMapCLM T).toLinearMap) := by
    ext φ x
    simp [AssociatedOperators.dualMapCLM_apply]
  rw [congrArg LinearMap.ker hmap] at hbase
  exact hbase

/--
Banach `1932`, *Théorie des opérations linéaires*, Ch. X, §4, Théorème 21,
p. 149: the Fredholm equation is solvable exactly for right-hand sides orthogonal
to the associated homogeneous solutions; the theorem is derived there from Ch. X,
Théorèmes 8, 9, and 11.
-/
axiom mem_range_id_sub_iff_annihilates_associated_ker
    (T : E →L[𝕜] E) (hT : IsCompactOperator T) (y : E) :
    y ∈ Set.range (((1 : E →L[𝕜] E) - T) : E →L[𝕜] E) ↔
      ∀ φ ∈
          LinearMap.ker
            (((1 : NormedSpace.Dual 𝕜 E →L[𝕜] NormedSpace.Dual 𝕜 E) -
                AssociatedOperators.dualMapCLM T).toLinearMap),
        φ y = 0

/--
Scalar Fredholm solvability criterion, obtained by applying Banach `1932`, Ch. X, §4,
Théorème 21 to the compact operator `h • T`.
-/
theorem mem_range_id_sub_smul_iff_annihilates_associated_ker
    (T : E →L[𝕜] E) (hT : IsCompactOperator T) {h : 𝕜} (hh : h ≠ 0) (y : E) :
    y ∈ Set.range (((1 : E →L[𝕜] E) - h • T) : E →L[𝕜] E) ↔
      ∀ φ ∈
          LinearMap.ker
            (((1 : NormedSpace.Dual 𝕜 E →L[𝕜] NormedSpace.Dual 𝕜 E) -
                h • AssociatedOperators.dualMapCLM T).toLinearMap),
        φ y = 0 := by
  have _ := hh
  simpa [dualMapCLM_smul] using
    mem_range_id_sub_iff_annihilates_associated_ker (𝕜 := 𝕜) (E := E) (h • T)
      (isCompactOperator_smul_of_isCompactOperator (𝕜 := 𝕜) (E := E) T hT h) y

/--
Banach's Fredholm alternative in the invertible case: injectivity of `1 - hT` is equivalent to
invertibility when `T` is compact and `h ≠ 0`.
-/
theorem isUnit_id_sub_smul_iff_ker_eq_bot_of_isCompactOperator
    (T : E →L[𝕜] E) (hT : IsCompactOperator T) {h : 𝕜} (hh : h ≠ 0) :
    IsUnit ((1 : E →L[𝕜] E) - h • T) ↔
      LinearMap.ker (((1 : E →L[𝕜] E) - h • T).toLinearMap) = ⊥ := by
  let A : E →L[𝕜] E := (1 : E →L[𝕜] E) - h • T
  let B : NormedSpace.Dual 𝕜 E →L[𝕜] NormedSpace.Dual 𝕜 E :=
    (1 : NormedSpace.Dual 𝕜 E →L[𝕜] NormedSpace.Dual 𝕜 E) -
      h • AssociatedOperators.dualMapCLM T
  change IsUnit A ↔ LinearMap.ker A.toLinearMap = ⊥
  constructor
  · intro hA
    exact LinearMap.ker_eq_bot.mpr (ContinuousLinearMap.isUnit_iff_bijective.mp hA).1
  · intro hker
    rw [ContinuousLinearMap.isUnit_iff_bijective]
    refine ⟨LinearMap.ker_eq_bot.mp hker, ?_⟩
    intro y
    have hRank :=
      rank_ker_id_sub_smul_eq_rank_ker_id_sub_smul_associated (𝕜 := 𝕜) (E := E) T hT hh
    have hBker : LinearMap.ker B.toLinearMap = ⊥ := by
      apply (Submodule.rank_eq_zero (R := 𝕜) (M := NormedSpace.Dual 𝕜 E)).mp
      rw [← hRank]
      simpa [A, hker]
    have hy :=
      (mem_range_id_sub_smul_iff_annihilates_associated_ker (𝕜 := 𝕜) (E := E) T hT hh y).mpr
        (by
          intro φ hφ
          have hφ0 : φ = 0 := by
            have hφB : φ ∈ LinearMap.ker B.toLinearMap := by
              simpa [B] using hφ
            have hφBot : φ ∈ (⊥ : Submodule 𝕜 (NormedSpace.Dual 𝕜 E)) := by
              simpa [hBker] using hφB
            simpa using hφBot
          simp [hφ0])
    rcases hy with ⟨x, hx⟩
    exact ⟨x, by simpa [A] using hx⟩

/--
Distinct primal and associated eigenmodes are orthogonal. This is the one algebraic Chapter X
theorem in the Fredholm lane that reduces cleanly to the shared associated-operator API.
-/
theorem eigenfunctional_apply_eigenvector_eq_zero_of_ne
    (T : E →L[𝕜] E) {μ ν : 𝕜} {x : E} {φ : NormedSpace.Dual 𝕜 E}
    (hx : T x = μ • x)
    (hφ : AssociatedOperators.dualMapCLM T φ = ν • φ)
    (hμν : μ ≠ ν) :
    φ x = 0 := by
  have hDual : φ (T x) = ν * φ x := by
    have h := congrArg (fun ψ : NormedSpace.Dual 𝕜 E => ψ x) hφ
    simpa [AssociatedOperators.dualMapCLM_apply] using h
  have hPrimal : φ (T x) = μ * φ x := by
    simp [hx]
  have hEq : ν * φ x = μ * φ x := by
    calc
      ν * φ x = φ (T x) := hDual.symm
      _ = μ * φ x := hPrimal
  have hZero : (ν - μ) * φ x = 0 := by
    rw [sub_mul, hEq, sub_self]
  exact (mul_eq_zero.mp hZero).resolve_left (sub_ne_zero.mpr (Ne.symm hμν))

/--
Banach `1932`, *Théorie des opérations linéaires*, Ch. X, §4, Théorème 22,
pp. 149-150: the eigenvalues of `y = x - hU(x)` form an isolated set. Banach cites
F. Riesz, *Acta Mathematica* 41 (1918), p. 90, Satz 12, for this discreteness theorem.
-/
axiom exists_ball_inter_spectrum_eq_singleton_of_mem_spectrum_ne_zero_of_isCompactOperator
    (T : E →L[𝕜] E) (hT : IsCompactOperator T) {μ : 𝕜}
    (hμ : μ ∈ spectrum 𝕜 T) (hμ0 : μ ≠ 0) :
    ∃ ε : ℝ, 0 < ε ∧ spectrum 𝕜 T ∩ Metric.ball μ ε = {μ}

end Fredholm
end Banach1932
end FunctionalAnalysis
end MathlibExpansion
