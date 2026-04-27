import Mathlib.SetTheory.Cardinal.Basic

/-!
# Finite simple series segments

This Frege-free owner package isolates the typed finite-segment substrate used
to recognize finite cardinality.
-/

universe u

namespace MathlibExpansion.Foundations.Relations

/-- A finite simple series segment is a relation on a type whose carrier is
equivalent to `Fin size`, with the relation matching the successor step on
indices. Endpoint accessors are derived from the size parameter. -/
structure FiniteSeriesSegment (α : Type u) where
  rel : α → α → Prop
  size : ℕ
  index : α ≃ Fin size
  rel_iff : ∀ {a b : α}, rel a b ↔ (index b).1 = (index a).1 + 1

namespace FiniteSeriesSegment

/-- The canonical finite simple series segment transported along an equivalence
with `Fin n`. -/
def canonical {α : Type u} (n : ℕ) (e : α ≃ Fin n) : FiniteSeriesSegment α where
  rel a b := (e b).1 = (e a).1 + 1
  size := n
  index := e
  rel_iff := by
    intro a b
    rfl

/-- The first point of a finite series segment, when the segment is nonempty. -/
def first? {α : Type u} (S : FiniteSeriesSegment α) : Option α := by
  by_cases h : 0 < S.size
  · exact some (S.index.symm ⟨0, h⟩)
  · exact none

/-- The last point of a finite series segment, when the segment is nonempty. -/
def last? {α : Type u} (S : FiniteSeriesSegment α) : Option α :=
  match h : S.size with
  | 0 => none
  | n + 1 =>
      some (S.index.symm <| by
        rw [h]
        exact ⟨n, Nat.lt_succ_self n⟩)

end FiniteSeriesSegment

/-- A carrier has natural-number cardinality exactly when it supports a finite
simple series segment. -/
theorem exists_nat_mk_eq_iff_nonempty_finiteSeriesSegment (α : Type u) :
    (∃ n : ℕ, Cardinal.mk α = n) ↔ Nonempty (FiniteSeriesSegment α) := by
  constructor
  · rintro ⟨n, hn⟩
    obtain ⟨e⟩ := (Cardinal.mk_eq_nat_iff).1 hn
    exact ⟨FiniteSeriesSegment.canonical n e⟩
  · rintro ⟨S⟩
    exact ⟨S.size, (Cardinal.mk_eq_nat_iff).2 ⟨S.index⟩⟩

end MathlibExpansion.Foundations.Relations
