import Mathlib.Data.Set.Defs

/-!
# T20c_05_UCC — Unit classes and couples (W1d)

Russell + Whitehead, *Principia Mathematica* (1910), `*51`-`*56`. Five wrapper
items establishing typed Russell-facing carriers for unit classes, unordered
couples, and ordered couples (= unit relations) plus singleton-relation
domain/range API.

References:
* Russell-Whitehead 1910, PM vol. I, `*51` (unit classes), `*52` (singleton
  classes via descriptions), `*54` (cardinal one), `*55`-`*56` (couples).
-/

universe u v

namespace MathlibExpansion.Logic.Russell

/-- UCC-01 (`*51·11` `RussellOne`): the typed unit-class carrier for PM's
`ι'a`. The single inhabitant is exactly the object `a`. -/
structure RussellOne {α : Type u} (a : α) where
  val : α
  is_a : val = a

/-- UCC-01-iso: the unit class is in canonical bijection with the singleton
predicate `fun x => x = a`. -/
@[simp] theorem RussellOne.eq_iff {α : Type u} (a : α) (r : RussellOne a) :
    r.val = a := r.is_a

/-- UCC-02 (`*54·02` `RussellTwo`): the typed unordered-couple carrier
`{a, b}` as a subtype. -/
structure RussellTwo {α : Type u} (a b : α) where
  val : α
  is_a_or_b : val = a ∨ val = b

/-- UCC-02-iso: `RussellTwo`'s underlying-value predicate. -/
@[simp] theorem RussellTwo.mem_iff {α : Type u} (a b : α) (r : RussellTwo a b) :
    r.val = a ∨ r.val = b := r.is_a_or_b

/-- UCC-03 (`*55·02` `RussellTwoRel`): the typed ordered-couple / unit
relation carrier. The single inhabitant is exactly the pair `(a, b)`. -/
structure RussellTwoRel {α : Type u} {β : Type v} (a : α) (b : β) where
  val : α × β
  is_pair : val = (a, b)

/-- UCC-04 (`*55·12` unit-relation domain singleton): the domain of the unit
relation `{(a,b)}` (as a Prop predicate) is the singleton predicate `· = a`. -/
theorem unitClass_domain {α : Type u} {β : Type v} (a : α) (b : β) (x : α) :
    (∃ y, (x, y) = (a, b)) ↔ x = a := by
  constructor
  · rintro ⟨y, hxy⟩
    exact (Prod.mk.inj hxy).1
  · intro hx
    exact ⟨b, by rw [hx]⟩

/-- UCC-05 (`*55·13` unit-relation range singleton): the range of the unit
relation `{(a,b)}` (as a Prop predicate) is the singleton predicate `· = b`. -/
theorem unitClass_range {α : Type u} {β : Type v} (a : α) (b : β) (y : β) :
    (∃ x, (x, y) = (a, b)) ↔ y = b := by
  constructor
  · rintro ⟨x, hxy⟩
    exact (Prod.mk.inj hxy).2
  · intro hy
    exact ⟨a, by rw [hy]⟩

end MathlibExpansion.Logic.Russell
