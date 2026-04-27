import Mathlib.FieldTheory.PrimitiveElement

/-!
# Intermediate fields of simple algebraic extensions

This chapter lands Steinitz `PEFIF_06`: every intermediate field of a simple
algebraic extension is simple over the base.

Mathlib already proves:
- a simple algebraic extension has finitely many intermediate fields;
- every intermediate field of an algebraic extension with finitely many
  intermediate fields is simple.

This file packages that composition as the Steinitz-facing theorem.

Primary source:
- E. Steinitz (1910), *Algebraische Theorie der Koerper*, `Sec. 14 II`,
  p. 243.
-/

noncomputable section

open scoped Classical

namespace MathlibExpansion.FieldTheory.PrimitiveElement

open IntermediateField

variable {F E : Type*} [Field F] [Field E] [Algebra F E]

/-- Every intermediate field of a simple algebraic extension is simple. -/
theorem intermediateField_exists_primitive_of_top_primitive [Algebra.IsAlgebraic F E]
    (h : ∃ α : E, IntermediateField.adjoin F ({α} : Set E) = ⊤)
    (K : IntermediateField F E) :
    ∃ β : E, IntermediateField.adjoin F ({β} : Set E) = K := by
  haveI : Finite (IntermediateField F E) := by
    rcases h with ⟨α, hα⟩
    exact
      Field.finite_intermediateField_of_exists_primitive_element
        (F := F) (E := E) ⟨α, by simpa using hα⟩
  rcases
      Field.exists_primitive_element_of_finite_intermediateField
        (F := F) (E := E) K with
    ⟨β, hβ⟩
  exact ⟨β, by simpa using hβ⟩

end MathlibExpansion.FieldTheory.PrimitiveElement
