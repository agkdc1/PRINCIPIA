import MathlibExpansion.FieldTheory.PurelyInseparable.ReducedDegree

/-!
# Mixed separable / inseparable degree bound boundary

This chapter isolates Steinitz `PEFIF_MIXED_BOUND`: the existence of a simple
subextension attaining the `n * p^f` bound.

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

/-- In a simple finite extension, a primitive generator attains the mixed
`n * p^f` degree bound.

Historical source: E. Steinitz (1910), *Algebraische Theorie der Koerper*,
`Sec. 14(4)` and `Sec. 14(6)`, pp. 239-242. The proof here is the Lean
composition of the primitive-generator hypothesis with the reduced-degree
formula in `finrank_eq_finSepDegree_mul_pow_extensionInsepExponent`. -/
theorem exists_element_attaining_sepDegree_pow_insepExponent
    (h : ∃ α : E, IntermediateField.adjoin F ({α} : Set E) = ⊤) :
    ∃ α : E,
      Module.finrank F (IntermediateField.adjoin F ({α} : Set E)) =
        Field.finSepDegree F E * q ^ (extensionInsepExponent F E q) := by
  rcases h with ⟨α, hα⟩
  refine ⟨α, ?_⟩
  rw [hα]
  simpa using finrank_eq_finSepDegree_mul_pow_extensionInsepExponent F E q

end MathlibExpansion.FieldTheory.PrimitiveElement
