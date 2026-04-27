import Mathlib.Data.Set.Basic
import Mathlib.Logic.Embedding.Basic

/-!
# Embeddings of `ℕ` into simply infinite carriers

This file provides the small equivalence lemmas needed to turn an embedding of
`ℕ` into a simply infinite structure on its range.
-/

namespace MathlibExpansion
namespace Foundations
namespace Dedekind

/-- The range of an embedding `ℕ ↪ α` is equivalent to `ℕ`. -/
noncomputable def embeddingRangeEquivNat {α : Type*} (e : ℕ ↪ α) :
    Set.range e ≃ ℕ := by
  let g : ℕ → Set.range e := fun n => ⟨e n, ⟨n, rfl⟩⟩
  refine (Equiv.ofBijective g ?_).symm
  constructor
  · intro m n h
    exact e.injective (congrArg Subtype.val h)
  · rintro ⟨x, ⟨n, rfl⟩⟩
    exact ⟨n, rfl⟩

end Dedekind
end Foundations
end MathlibExpansion
