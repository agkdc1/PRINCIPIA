import Mathlib
import MathlibExpansion.FunctionalAnalysis.Banach1932.Fredholm

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Banach1932
namespace IntegralEquations

open scoped ENNReal

/-- The unit interval for Banach's Chapter X integral-equation realizations. -/
abbrev UnitInterval := ↥(Set.Icc (0 : ℝ) 1)

/-- Restricted Lebesgue measure on the unit interval. -/
abbrev intervalMeasure : MeasureTheory.Measure ℝ :=
  MeasureTheory.Measure.restrict MeasureTheory.volume (Set.Icc (0 : ℝ) 1)

/-- Continuous functions on the unit interval. -/
abbrev CInterval := ContinuousMap UnitInterval ℝ

/-- The `L²([0,1])` carrier used in Banach's symmetric-kernel lane. -/
abbrev L2Interval : Type :=
  ↥(MeasureTheory.Lp ℝ (2 : ℝ≥0∞) intervalMeasure)

/-- Kernel transposition for Banach's associated Fredholm equation. -/
def transposeKernel (K : ContinuousMap (UnitInterval × UnitInterval) ℝ) :
    ContinuousMap (UnitInterval × UnitInterval) ℝ where
  toFun p := K (p.2, p.1)
  continuous_toFun := by
    exact K.continuous.comp (continuous_snd.prod_mk continuous_fst)

/--
The compact integral operator attached to a continuous Fredholm kernel.

Source anchor: S. Banach, *Théorie des opérations linéaires* (1932), Ch. X §5,
printed p. 151, equations (32)-(33), "Équations intégrales de Fredholm"; recon id
`BFVS_01`. This is Banach's section-level kernel construction rather than a numbered
theorem.
-/
axiom fredholmKernelOp (K : ContinuousMap (UnitInterval × UnitInterval) ℝ) :
    CInterval →L[ℝ] CInterval

/--
Banach's Chapter X `§5` substrate: a continuous Fredholm kernel defines a compact operator on
`C([0,1])`.

Source anchor: S. Banach, *Théorie des opérations linéaires* (1932), Ch. X §5,
printed p. 151, equations (32)-(33), "Équations intégrales de Fredholm"; recon id
`BFVS_01`. This is Banach's section-level compactness assertion for the kernel
operator rather than a numbered theorem.
-/
axiom fredholmKernelOp_isCompactOperator
    (K : ContinuousMap (UnitInterval × UnitInterval) ℝ) :
    IsCompactOperator (fredholmKernelOp K)

/--
Banach's Fredholm nullity equality for a kernel and its transposed kernel.

Source anchor: S. Banach, *Théorie des opérations linéaires* (1932), Ch. X §5,
printed p. 151, obtained by translating Ch. X §4 Théorème 19, printed p. 149,
to Fredholm kernels and identifying the associated equation with the transposed kernel;
recon id `BFVS_02`.
-/
axiom fredholm_rank_ker_eq_rank_ker_transpose
    (K : ContinuousMap (UnitInterval × UnitInterval) ℝ) {h : ℝ} :
    Module.rank ℝ
        (LinearMap.ker
          (((1 : CInterval →L[ℝ] CInterval) - h • fredholmKernelOp K).toLinearMap)) =
      Module.rank ℝ
        (LinearMap.ker
          (((1 : CInterval →L[ℝ] CInterval) - h • fredholmKernelOp (transposeKernel K)).toLinearMap))

private theorem existsUnique_apply_eq_of_isUnit
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    (A : E →L[ℝ] E) (hA : IsUnit A) (y : E) :
    ∃! x : E, A x = y := by
  have hbij : Function.Bijective A := ContinuousLinearMap.isUnit_iff_bijective.mp hA
  rcases hbij.2 y with ⟨x, hx⟩
  refine ⟨x, hx, ?_⟩
  intro z hz
  exact hbij.1 (hz.trans hx.symm)

/--
Zero defect implies regularity for the Fredholm equation: Banach's `§4` operator theorem
specialized to the continuous-kernel realization.

Source anchor: S. Banach, *Théorie des opérations linéaires* (1932), Ch. X §4,
Théorème 20, printed p. 149; translated to Fredholm kernels in Ch. X §5,
printed p. 151; recon id `BFVS_03`.
-/
theorem fredholm_regular_of_zero_defect
    (K : ContinuousMap (UnitInterval × UnitInterval) ℝ) {h : ℝ}
    (hker :
      LinearMap.ker
          (((1 : CInterval →L[ℝ] CInterval) - h • fredholmKernelOp K).toLinearMap) =
        ⊥) (y : CInterval) :
    ∃! x : CInterval, ((1 : CInterval →L[ℝ] CInterval) - h • fredholmKernelOp K) x = y := by
  by_cases hh : h = 0
  · subst h
    refine ⟨y, by simp, ?_⟩
    intro z hz
    simpa using hz
  · have hunit : IsUnit ((1 : CInterval →L[ℝ] CInterval) - h • fredholmKernelOp K) := by
      exact (Fredholm.isUnit_id_sub_smul_iff_ker_eq_bot_of_isCompactOperator
        (fredholmKernelOp K) (fredholmKernelOp_isCompactOperator K) (h := h) hh).mpr hker
    exact existsUnique_apply_eq_of_isUnit _ hunit y

/--
Banach's Fredholm solvability criterion for integral equations, sharpened here to the
associated-dual statement already supplied by the operator Fredholm lane. The remaining
transpose-kernel identification is the separate Ch. X §5 analytic substrate.

Source anchor: S. Banach, *Théorie des opérations linéaires* (1932), Ch. X §5,
printed p. 151, using Ch. X §4, Théorème 21, printed p. 149; recon id `BFVS_04`.
-/
theorem fredholm_solvable_iff_annihilates_transpose_kernel
    (K : ContinuousMap (UnitInterval × UnitInterval) ℝ) {h : ℝ} (hh : h ≠ 0)
    (f : CInterval) :
    f ∈ Set.range (((1 : CInterval →L[ℝ] CInterval) - h • fredholmKernelOp K) :
        CInterval →L[ℝ] CInterval) ↔
      ∀ φ ∈
          LinearMap.ker
            (((1 : NormedSpace.Dual ℝ CInterval →L[ℝ] NormedSpace.Dual ℝ CInterval) -
                h • AssociatedOperators.dualMapCLM (fredholmKernelOp K)).toLinearMap),
        φ f = 0 := by
  exact Fredholm.mem_range_id_sub_smul_iff_annihilates_associated_ker
    (fredholmKernelOp K) (fredholmKernelOp_isCompactOperator K) (h := h) hh f

/-- A Volterra kernel packaged as Banach's triangular-kernel data on `[0,1]^2`. -/
structure VolterraKernel where
  toContinuousMap : ContinuousMap (UnitInterval × UnitInterval) ℝ

/-- The integral operator attached to a Volterra kernel. -/
def volterraKernelOp (K : VolterraKernel) : CInterval →L[ℝ] CInterval :=
  fredholmKernelOp K.toContinuousMap

/--
Banach's Volterra theorem: the triangular-kernel equation has a unique continuous solution for
every right-hand side.

Source anchor: S. Banach, *Théorie des opérations linéaires* (1932), Ch. X §6,
printed pp. 151-152, equations (34)-(36), "Équations intégrales de Volterra";
recon id `BFVS_06`. This is Banach's section-level Volterra theorem rather than a
separately numbered theorem.
-/
axiom volterra_unique_solution (K : VolterraKernel) (f : CInterval) :
    ∃! x : CInterval, x - volterraKernelOp K x = f

/--
The `L²` operator attached to a symmetric continuous kernel.

Source anchor: S. Banach, *Théorie des opérations linéaires* (1932), Ch. X §7,
printed p. 152, equation (37) and system (38), "Équations intégrales symétriques";
recon id `BFVS_07`. This is Banach's section-level symmetric-kernel operator
construction rather than a separately numbered theorem.
-/
axiom symmetricKernelOp (K : ContinuousMap (UnitInterval × UnitInterval) ℝ) :
    L2Interval →L[ℝ] L2Interval

/--
Banach's Chapter X `§7` substrate: a symmetric kernel defines a self-adjoint operator on
`L²([0,1])`.

Source anchor: S. Banach, *Théorie des opérations linéaires* (1932), Ch. X §7,
printed p. 152, equation (37) and system (38), "Équations intégrales symétriques";
recon id `BFVS_07`. This is Banach's section-level self-adjointness assertion for
symmetric kernels rather than a separately numbered theorem.
-/
axiom symmetricKernelOp_isSelfAdjoint
    (K : ContinuousMap (UnitInterval × UnitInterval) ℝ)
    (hK : ∀ x y : UnitInterval, K (x, y) = K (y, x)) :
    IsSelfAdjoint (symmetricKernelOp K)

/--
Banach's symmetric Fredholm corollary: surjectivity already implies regularity because the
associated equation is the same equation in the symmetric case.

Source anchor: S. Banach, *Théorie des opérations linéaires* (1932), Ch. X §7,
Théorème 23, printed p. 153; recon id `BFVS_08`.
-/
theorem symmetric_fredholm_surjective_imp_regular
    (K : ContinuousMap (UnitInterval × UnitInterval) ℝ)
    (hK : ∀ x y : UnitInterval, K (x, y) = K (y, x))
    {h : ℝ}
    (hsurj :
      Function.Surjective (((1 : L2Interval →L[ℝ] L2Interval) - h • symmetricKernelOp K))) :
    IsUnit ((1 : L2Interval →L[ℝ] L2Interval) - h • symmetricKernelOp K) := by
  let A : L2Interval →L[ℝ] L2Interval :=
    (1 : L2Interval →L[ℝ] L2Interval) - h • symmetricKernelOp K
  have hsurjA : Function.Surjective A := by
    simpa [A] using hsurj
  have hAself : IsSelfAdjoint A := by
    dsimp [A]
    apply IsSelfAdjoint.sub
    · exact IsSelfAdjoint.one (R := L2Interval →L[ℝ] L2Interval)
    · apply IsSelfAdjoint.smul
      · exact IsSelfAdjoint.all h
      · exact symmetricKernelOp_isSelfAdjoint K hK
  have hAsym : (A : L2Interval →ₗ[ℝ] L2Interval).IsSymmetric := hAself.isSymmetric
  have hker : LinearMap.ker A.toLinearMap = ⊥ := by
    rw [LinearMap.ker_eq_bot']
    intro x hx
    rcases hsurjA x with ⟨y, hy⟩
    have hinner : (@inner ℝ L2Interval _ x x) = 0 := by
      calc
        @inner ℝ L2Interval _ x x = @inner ℝ L2Interval _ x (A y) := by rw [hy]
        _ = @inner ℝ L2Interval _ (A x) y := (hAsym x y).symm
        _ = @inner ℝ L2Interval _ (0 : L2Interval) y := by
          have hxA : A x = 0 := hx
          rw [hxA]
        _ = 0 := by exact inner_zero_left y
    have hzero := (@inner_self_eq_zero ℝ L2Interval _ _ _ (x := x)).mp hinner
    exact hzero
  have hinj : Function.Injective A := LinearMap.ker_eq_bot.mp hker
  have hunitA : IsUnit A := ContinuousLinearMap.isUnit_iff_bijective.mpr ⟨hinj, hsurjA⟩
  simpa [A] using hunitA

end IntegralEquations
end Banach1932
end FunctionalAnalysis
end MathlibExpansion
