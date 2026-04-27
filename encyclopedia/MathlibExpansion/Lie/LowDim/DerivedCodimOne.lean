import Mathlib

/-!
# Codimension-one ideals from the derived algebra
-/

namespace MathlibExpansion.Lie.LowDim

/-- A codimension-one ideal witness in a finite-dimensional Lie algebra. -/
def DerivedCodimOneCriterion {K : Type*} [Field K] {L : Type*}
    [LieRing L] [LieAlgebra K L] [FiniteDimensional K L] : Prop :=
  ∃ I : LieIdeal K L, Module.finrank K I + 1 = Module.finrank K L

/-- A codimension-one Lie ideal forces the derived ideal to be proper. -/
theorem finrank_derived_lt_of_codimOne_lieIdeal {K : Type*} [Field K] {L : Type*}
    [LieRing L] [LieAlgebra K L] [FiniteDimensional K L]
    (hcodim : DerivedCodimOneCriterion (K := K) (L := L)) :
    Module.finrank K (LieAlgebra.derivedSeries K L 1) < Module.finrank K L := by
  classical
  rcases hcodim with ⟨I, hIcodim⟩
  have hI_ne_top : I.toSubmodule ≠ (⊤ : Submodule K L) := by
    intro htop
    have hfin : Module.finrank K I = Module.finrank K L := by
      rw [← finrank_top K L]
      exact congrArg (fun S : Submodule K L => Module.finrank K S) htop
    omega
  have hI_lt_top : I.toSubmodule < (⊤ : Submodule K L) := lt_top_iff_ne_top.mpr hI_ne_top
  obtain ⟨z, _hz_top, hzI⟩ := SetLike.exists_of_lt hI_lt_top
  have hIcodim_sub : Module.finrank K I.toSubmodule + 1 = Module.finrank K L := by
    simpa using hIcodim
  have hquot_fin_sub : Module.finrank K (L ⧸ I.toSubmodule) = 1 := by
    have h := I.toSubmodule.finrank_quotient_add_finrank
    have h' : Module.finrank K (L ⧸ I.toSubmodule) + Module.finrank K I.toSubmodule =
        1 + Module.finrank K I.toSubmodule := by
      rw [h, ← hIcodim_sub, add_comm]
    exact Nat.add_right_cancel h'
  have hquot_fin : Module.finrank K (L ⧸ I) = 1 := by
    simpa using hquot_fin_sub
  let v : L ⧸ I := LieSubmodule.Quotient.mk (N := I) z
  have hv : v ≠ 0 := by
    change LieSubmodule.Quotient.mk (N := I) z ≠ 0
    rw [ne_eq, LieSubmodule.Quotient.mk_eq_zero']
    exact hzI
  have hspan : ∀ w : L ⧸ I, ∃ c : K, c • v = w :=
    (finrank_eq_one_iff_of_nonzero' v hv).mp hquot_fin
  have hquot_ab : IsLieAbelian (L ⧸ I) := by
    refine ⟨fun a b => ?_⟩
    obtain ⟨ca, ha⟩ := hspan a
    obtain ⟨cb, hb⟩ := hspan b
    rw [← ha, ← hb]
    simp [v]
  have hderived_le_I : LieAlgebra.derivedSeries K L 1 ≤ I := by
    rw [LieAlgebra.derivedSeries_def, LieAlgebra.derivedSeriesOfIdeal_succ,
      LieAlgebra.derivedSeriesOfIdeal_zero]
    rw [LieSubmodule.lie_le_iff]
    intro x _hx y _hy
    have hm : LieSubmodule.Quotient.mk (N := I) ⁅x, y⁆ = 0 := by
      rw [LieSubmodule.Quotient.mk_bracket]
      exact hquot_ab.trivial _ _
    exact (LieSubmodule.Quotient.mk_eq_zero' (N := I)).mp hm
  have hderived_lt_top : (LieAlgebra.derivedSeries K L 1).toSubmodule < (⊤ : Submodule K L) :=
    lt_of_le_of_lt hderived_le_I hI_lt_top
  have hfin_lt := Submodule.finrank_lt_finrank_of_lt hderived_lt_top
  simpa [finrank_top K L] using hfin_lt

/-- A proper derived ideal is contained in a codimension-one Lie ideal. -/
theorem exists_codimOne_lieIdeal_of_finrank_derived_lt {K : Type*} [Field K] {L : Type*}
    [LieRing L] [LieAlgebra K L] [FiniteDimensional K L]
    (hder : Module.finrank K (LieAlgebra.derivedSeries K L 1) < Module.finrank K L) :
    DerivedCodimOneCriterion (K := K) (L := L) := by
  classical
  obtain H | ⟨A, hA, hle⟩ :=
    eq_top_or_exists_le_coatom (LieAlgebra.derivedSeries K L 1).toSubmodule
  · exfalso
    have hfin : Module.finrank K (LieAlgebra.derivedSeries K L 1) = Module.finrank K L := by
      rw [← finrank_top K L]
      exact congrArg (fun S : Submodule K L => Module.finrank K S) H
    omega
  · obtain ⟨z, _hz_top, hzA⟩ := SetLike.exists_of_lt hA.lt_top
    let I : LieIdeal K L :=
      { A with
        lie_mem := fun {x y} _hy =>
          hle <| by
            rw [LieAlgebra.derivedSeries_def, LieAlgebra.derivedSeriesOfIdeal_succ,
              LieAlgebra.derivedSeriesOfIdeal_zero]
            exact LieSubmodule.lie_mem_lie (LieSubmodule.mem_top x) (LieSubmodule.mem_top y) }
    refine ⟨I, ?_⟩
    have hz_ne : z ≠ 0 := by
      intro hz
      exact hzA (hz ▸ A.zero_mem)
    have hcompl : IsCompl A (Submodule.span K ({z} : Set L)) :=
      Submodule.isCompl_span_singleton_of_isCoatom_of_not_mem hA hzA
    have hdim := Submodule.finrank_add_eq_of_isCompl hcompl
    simpa [I, finrank_span_singleton hz_ne] using hdim

/-- Lie's codimension-one criterion in executor-safe wrapper form. -/
theorem exists_codimOne_lieIdeal_iff_finrank_derived_lt {K : Type*} [Field K] {L : Type*}
    [LieRing L] [LieAlgebra K L] [FiniteDimensional K L] :
    DerivedCodimOneCriterion (K := K) (L := L) ↔
      Module.finrank K (LieAlgebra.derivedSeries K L 1) < Module.finrank K L :=
  ⟨finrank_derived_lt_of_codimOne_lieIdeal, exists_codimOne_lieIdeal_of_finrank_derived_lt⟩

end MathlibExpansion.Lie.LowDim
