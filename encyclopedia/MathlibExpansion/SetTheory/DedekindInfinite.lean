import Mathlib.Data.Set.Basic
import Mathlib.Data.Set.Finite.Basic
import Mathlib.Logic.Embedding.Basic
import Mathlib.Logic.Function.Basic
import MathlibExpansion.Foundations.Dedekind.SimplyInfinite

/-!
# Dedekind-infinite types

This file packages the textbook notion of a type that is similar to a proper subset
of itself, expressed through an injective self-map with proper range.
-/

namespace MathlibExpansion
namespace SetTheory

open Function Set
open MathlibExpansion.Foundations.Dedekind

/-- A type is Dedekind-infinite if it admits an injective self-map with proper range. -/
def DedekindInfinite (α : Type*) : Prop :=
  ∃ f : α ↪ α, Set.range f ⊂ Set.univ

theorem dedekindInfinite_iff_exists_embedding (α : Type*) :
    DedekindInfinite α ↔ ∃ f : α ↪ α, Set.range f ⊂ Set.univ := Iff.rfl

theorem not_surjective_of_range_ssubset_univ {α : Type*} {f : α ↪ α}
    (h : Set.range f ⊂ Set.univ) : ¬ Function.Surjective f := by
  intro hsurj
  apply h.2
  intro x _hx
  rcases hsurj x with ⟨y, rfl⟩
  exact Set.mem_range_self y

theorem exists_simplyInfinite_subset {α : Type*} {s : Set α} (hs : s.Infinite) :
    ∃ t : Set α, t ⊆ s ∧ Nonempty (SimplyInfiniteSystem t) := by
  let e : ℕ ↪ s := hs.natEmbedding s
  let t : Set α := Set.range fun n : ℕ => ((e n : s) : α)
  have ht_subset : t ⊆ s := by
    rintro x ⟨n, rfl⟩
    exact (e n).property
  let f : ℕ → t := fun n => ⟨((e n : s) : α), ⟨n, rfl⟩⟩
  have hf_inj : Function.Injective f := by
    intro m n h
    have hval : (((e m : s) : α)) = (((e n : s) : α)) := by
      exact congrArg (fun z : t => (z : α)) h
    exact e.injective (Subtype.ext hval)
  have hf_surj : Function.Surjective f := by
    intro x
    rcases x.2 with ⟨n, hn⟩
    refine ⟨n, Subtype.ext hn⟩
  refine ⟨t, ht_subset, ?_⟩
  let et : t ≃ ℕ := (Equiv.ofBijective f ⟨hf_inj, hf_surj⟩).symm
  exact ⟨SimplyInfiniteSystem.ofNatEquiv et⟩

end SetTheory
end MathlibExpansion
