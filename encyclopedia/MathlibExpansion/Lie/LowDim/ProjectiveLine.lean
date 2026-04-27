import Mathlib
import MathlibExpansion.Lie.Examples.Projective

/-!
# The projective-line Lie algebra

The current `ProjectiveLie K 1` carrier inherited from
`MathlibExpansion.Lie.Examples.Projective` is the full `3 x 3` matrix Lie
algebra, not the quotient projective Lie algebra.  This file therefore records
the concrete obstruction to the former classification shell rather than keeping
a false classification axiom.
-/

namespace MathlibExpansion.Lie.LowDim

open MathlibExpansion.Lie.Examples
open scoped MatrixGroups

/-- A projective-line automorphism shell acting on the `3`-dimensional model. -/
abbrev ProjectiveLieAut (K : Type*) [Field K] :=
  Matrix.GeneralLinearGroup (Fin 3) K

/-- The standard Borel subalgebra in the projective-line model. -/
def StandardBorel (K : Type*) [Field K] : LieSubalgebra K (ProjectiveLie K 1) :=
  ⊤

/-- The two matrix units spanning a nilpotent plane in the placeholder model. -/
private def projectiveLineNilpotentPlaneVector (K : Type*) [Field K] :
    Fin 2 → ProjectiveLie K 1 :=
  fun i => Matrix.stdBasisMatrix 0 i.succ 1

private theorem projectiveLineNilpotentPlaneVector_linearIndependent
    (K : Type*) [Field K] :
    LinearIndependent K (projectiveLineNilpotentPlaneVector K) := by
  let b := Matrix.stdBasis K (Fin 3) (Fin 3)
  have hb : LinearIndependent K b := b.linearIndependent
  have hinj : Function.Injective (fun i : Fin 2 => ((0 : Fin 3), i.succ)) := by
    intro i j h
    exact (Fin.succ_injective 2) (congrArg Prod.snd h)
  convert hb.comp (fun i : Fin 2 => ((0 : Fin 3), i.succ)) hinj using 1
  ext i
  simp [projectiveLineNilpotentPlaneVector, b, Matrix.stdBasis_eq_stdBasisMatrix]

/--
A concrete two-dimensional Lie subalgebra of the current placeholder carrier.
It is spanned by `E01` and `E02`, whose pairwise products are zero.
-/
private def projectiveLineNilpotentPlane (K : Type*) [Field K] :
    LieSubalgebra K (ProjectiveLie K 1) where
  __ := Submodule.span K (Set.range (projectiveLineNilpotentPlaneVector K))
  lie_mem' := by
    intro x y hx hy
    refine Submodule.span_induction₂
      (p := fun x y _ _ =>
        ⁅x, y⁆ ∈ Submodule.span K (Set.range (projectiveLineNilpotentPlaneVector K)))
      (s := Set.range (projectiveLineNilpotentPlaneVector K))
      (t := Set.range (projectiveLineNilpotentPlaneVector K))
      ?mem_mem ?zero_left ?zero_right ?add_left ?add_right ?smul_left ?smul_right hx hy
    · rintro _ _ ⟨i, rfl⟩ ⟨j, rfl⟩
      change ⁅projectiveLineNilpotentPlaneVector K i,
          projectiveLineNilpotentPlaneVector K j⁆ ∈
        Submodule.span K (Set.range (projectiveLineNilpotentPlaneVector K))
      rw [LieRing.of_associative_ring_bracket]
      have hmul_left :
          Matrix.stdBasisMatrix (0 : Fin 3) i.succ (1 : K) *
              Matrix.stdBasisMatrix (0 : Fin 3) j.succ (1 : K) = 0 := by
        exact Matrix.StdBasisMatrix.mul_of_ne (1 : K) (0 : Fin 3) i.succ
          (0 : Fin 3) (Fin.succ_ne_zero i) (1 : K)
      have hmul_right :
          Matrix.stdBasisMatrix (0 : Fin 3) j.succ (1 : K) *
              Matrix.stdBasisMatrix (0 : Fin 3) i.succ (1 : K) = 0 := by
        exact Matrix.StdBasisMatrix.mul_of_ne (1 : K) (0 : Fin 3) j.succ
          (0 : Fin 3) (Fin.succ_ne_zero j) (1 : K)
      simp [projectiveLineNilpotentPlaneVector, hmul_left, hmul_right]
    · intro y hy
      simp
    · intro x hx
      simp
    · intro x y z hx hy hz hxz hyz
      simpa [add_lie] using Submodule.add_mem _ hxz hyz
    · intro x y z hx hy hz hxy hxz
      simpa [lie_add] using Submodule.add_mem _ hxy hxz
    · intro a x y hx hy hxy
      simpa [smul_lie] using Submodule.smul_mem _ a hxy
    · intro a x y hx hy hxy
      simpa [lie_smul] using Submodule.smul_mem _ a hxy

private theorem projectiveLineNilpotentPlane_finrank
    (K : Type*) [Field K] :
    Module.finrank K (projectiveLineNilpotentPlane K) = 2 := by
  change Module.finrank K
    (Submodule.span K (Set.range (projectiveLineNilpotentPlaneVector K))) = 2
  simpa using
    finrank_span_eq_card (projectiveLineNilpotentPlaneVector_linearIndependent K)

private theorem projectiveLineNilpotentPlane_ne_standardBorel
    (K : Type*) [Field K] :
    projectiveLineNilpotentPlane K ≠ StandardBorel K := by
  intro htop
  let e10 : ProjectiveLie K 1 := Matrix.stdBasisMatrix 1 0 1
  have hzero_on_span :
      ∀ M ∈ Submodule.span K (Set.range (projectiveLineNilpotentPlaneVector K)),
        M 1 0 = 0 := by
    intro M hM
    refine Submodule.span_induction
      (s := Set.range (projectiveLineNilpotentPlaneVector K)) ?base ?zero ?add ?smul hM
    · rintro _ ⟨i, rfl⟩
      simp [projectiveLineNilpotentPlaneVector]
    · simp
    · intro x y hx hy hx0 hy0
      simp [hx0, hy0]
    · intro a x hx hx0
      simp [hx0]
  have he10mem : e10 ∈ projectiveLineNilpotentPlane K := by
    rw [htop]
    simp [StandardBorel]
  have hentry := hzero_on_span e10 he10mem
  simp [e10] at hentry

/--
The former projective-line classification shell is false for the current
placeholder carrier: the full `3 x 3` matrix Lie algebra contains the
two-dimensional nilpotent plane spanned by `E01` and `E02`, while
`StandardBorel` is currently `⊤`.
-/
theorem not_projectiveLine_subalgebra_classification {K : Type*} [Field K] :
    ¬ (∀ H : LieSubalgebra K (ProjectiveLie K 1),
      Module.finrank K H = 2 → ∃ _g : ProjectiveLieAut K, H = StandardBorel K) := by
  intro hclass
  obtain ⟨_g, hg⟩ :=
    hclass (projectiveLineNilpotentPlane K) (projectiveLineNilpotentPlane_finrank K)
  exact projectiveLineNilpotentPlane_ne_standardBorel K hg

end MathlibExpansion.Lie.LowDim
