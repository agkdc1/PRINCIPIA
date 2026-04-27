import Mathlib.FieldTheory.PurelyInseparable.Basic

/-!
# Separable stage in an algebraic extension

This chapter packages Steinitz `PEFIF_STAGE` at the first stage only: the
separable part of an algebraic extension. The heavy finite exponent-filtration
story is split into `ExponentFiltration.lean`.

Primary source:
- E. Steinitz (1910), *Algebraische Theorie der Koerper*, `Sec. 14(1)`.
-/

noncomputable section

namespace MathlibExpansion.FieldTheory.PurelyInseparable

open IntermediateField

variable {F E : Type*} [Field F] [Field E] [Algebra F E] [Algebra.IsAlgebraic F E]

/-- The elements of the first kind in Steinitz's sense form the separable stage,
and the full extension above that stage is purely inseparable. -/
theorem exists_separableClosure_stage :
    ∃ S0 : IntermediateField F E,
      (∀ x : E, x ∈ S0 ↔ IsSeparable F x) ∧ IsPurelyInseparable S0 E := by
  refine ⟨separableClosure F E, ?_, inferInstance⟩
  intro x
  exact mem_separableClosure_iff

end MathlibExpansion.FieldTheory.PurelyInseparable
