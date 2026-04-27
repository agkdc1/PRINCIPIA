import Mathlib.Logic.Denumerable
import Mathlib.SetTheory.Cardinal.Basic

/-!
# Simple endless series

This Frege-free owner package isolates the smallest typed relation substrate
needed to express a simple endless series and to identify it with cardinality
`ℵ₀`.
-/

universe u v

namespace MathlibExpansion.Foundations.Relations

/-- A typed simple endless series is a relation whose carrier can be indexed by
`ℕ` so that the relation is exactly the successor step on those indices. -/
structure SimpleEndlessSeries (α : Type u) where
  rel : α → α → Prop
  index : α ≃ ℕ
  rel_iff : ∀ {a b : α}, rel a b ↔ index b = index a + 1

namespace SimpleEndlessSeries

/-- The distinguished first element of a simple endless series. -/
def root {α : Type u} (S : SimpleEndlessSeries α) : α :=
  S.index.symm 0

@[simp] theorem index_root {α : Type u} (S : SimpleEndlessSeries α) :
    S.index S.root = 0 := by
  simp [root]

/-- The canonical simple endless series transported along an equivalence with
`ℕ`. -/
def canonical {α : Type u} (e : α ≃ ℕ) : SimpleEndlessSeries α where
  rel a b := e b = e a + 1
  index := e
  rel_iff := by
    intro a b
    rfl

/-- Any two simple endless series are isomorphic through their index maps. -/
theorem nonempty_equiv {α : Type u} {β : Type v}
    (S : SimpleEndlessSeries α) (T : SimpleEndlessSeries β) :
    Nonempty (α ≃ β) :=
  ⟨S.index.trans T.index.symm⟩

end SimpleEndlessSeries

/-- A carrier has cardinality `ℵ₀` exactly when it supports a simple endless
series. -/
theorem mk_eq_aleph0_iff_nonempty_simpleEndlessSeries (α : Type u) :
    Cardinal.mk α = Cardinal.aleph0 ↔ Nonempty (SimpleEndlessSeries α) := by
  constructor
  · intro h
    obtain ⟨inst⟩ :=
      (Cardinal.denumerable_iff :
        Nonempty (Denumerable α) ↔ Cardinal.mk α = Cardinal.aleph0).2 h
    letI := inst
    exact ⟨SimpleEndlessSeries.canonical (Denumerable.eqv α)⟩
  · rintro ⟨S⟩
    letI : Denumerable α := Denumerable.mk' S.index
    exact (Cardinal.denumerable_iff :
      Nonempty (Denumerable α) ↔ Cardinal.mk α = Cardinal.aleph0).1 ⟨inferInstance⟩

end MathlibExpansion.Foundations.Relations
