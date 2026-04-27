import Mathlib.FieldTheory.PurelyInseparable.Basic

/-!
# Exponent filtration boundary

This chapter isolates the Steinitz finite-stage filtration by inseparability
exponent. Mathlib has the terminal purely inseparable closure and the separable
stage, but not the finite intermediate stages `S_f`.

Primary source:
- E. Steinitz (1910), *Algebraische Theorie der Koerper*, `Sec. 14(2)-(3)`.
-/

noncomputable section

namespace MathlibExpansion.FieldTheory.PurelyInseparable

open IntermediateField

variable {F E : Type*} [Field F] [Field E] [Algebra F E]
variable (q : ℕ) [ExpChar F q] [Algebra.IsAlgebraic F E]

omit [Algebra.IsAlgebraic F E] in
/-- Steinitz's exponent filtration through the separable stage. -/
theorem exists_exponent_filtration :
    ∀ f : ℕ, ∃ Sf : IntermediateField F E,
      ∀ x : E, x ∈ Sf ↔ x ^ (q ^ f) ∈ separableClosure F E := by
  intro f
  haveI : ExpChar E q := expChar_of_injective_algebraMap (algebraMap F E).injective q
  refine ⟨
    { carrier := {x | x ^ (q ^ f) ∈ separableClosure F E}
      zero_mem' := by
        simpa [zero_pow (expChar_pow_pos E q f).ne'] using
          (separableClosure F E).zero_mem
      one_mem' := by
        simpa using (separableClosure F E).one_mem
      mul_mem' := by
        intro x y hx hy
        simpa [mul_pow] using (separableClosure F E).mul_mem hx hy
      add_mem' := by
        intro x y hx hy
        simpa [add_pow_expChar_pow] using (separableClosure F E).add_mem hx hy
      algebraMap_mem' := by
        intro x
        simpa [map_pow] using (separableClosure F E).algebraMap_mem (x ^ (q ^ f))
      inv_mem' := by
        intro x hx
        simpa [inv_pow] using (separableClosure F E).inv_mem hx }, ?_⟩
  · intro x
    rfl

end MathlibExpansion.FieldTheory.PurelyInseparable
