import MathlibExpansion.FieldTheory.PrimitiveElement.MixedDegreeBound

/-!
# Mixed primitive-element criterion boundary

This file discharges the criterion from the mixed degree-bound surface and the
reduced-degree formula.

Primary source:
- E. Steinitz (1910), *Algebraische Theorie der Koerper*, `Sec. 14(4)` and
  `Sec. 14(6)`, pp. 239-242.
-/

noncomputable section

namespace MathlibExpansion.FieldTheory.PrimitiveElement

open IntermediateField
open MathlibExpansion.FieldTheory.PurelyInseparable

variable {F E : Type*} [Field F] [Field E] [Algebra F E]
variable (q : ℕ) [Fact q.Prime] [CharP F q] [FiniteDimensional F E]

/-- Steinitz's mixed primitive-element criterion: a finite extension is simple
exactly when some simple subextension attains the full mixed degree.

Historical source: E. Steinitz (1910), *Algebraische Theorie der Koerper*,
`Sec. 14(4)` and `Sec. 14(6)`, pp. 239-242. -/
theorem simple_iff_exists_element_attaining_sepDegree_pow_insepExponent :
    (∃ α : E, IntermediateField.adjoin F ({α} : Set E) = ⊤) ↔
      ∃ α : E,
        Module.finrank F (IntermediateField.adjoin F ({α} : Set E)) =
          Field.finSepDegree F E * q ^ (extensionInsepExponent F E q) := by
  constructor
  · intro h
    exact exists_element_attaining_sepDegree_pow_insepExponent (F := F) (E := E) q h
  · rintro ⟨α, hα⟩
    refine ⟨α, ?_⟩
    have hfin :
        Module.finrank F (IntermediateField.adjoin F ({α} : Set E)) =
          Module.finrank F (⊤ : IntermediateField F E) := by
      rw [hα, ← finrank_eq_finSepDegree_mul_pow_extensionInsepExponent F E q]
      simp
    exact IntermediateField.eq_of_le_of_finrank_eq le_top hfin

end MathlibExpansion.FieldTheory.PrimitiveElement
