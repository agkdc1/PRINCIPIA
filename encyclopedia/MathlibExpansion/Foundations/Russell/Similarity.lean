import Mathlib.Data.Set.Defs
import Mathlib.Logic.Equiv.Defs

/-!
# T20c_05_SCA — Similarity (W2b part 1)

Russell + Whitehead, *Principia Mathematica* (1910), `*73`. PM's "similarity"
relation between classes is what modern set theory calls equinumerosity.
This file packages the Russell-facing wrapper over `Equiv`.

References:
* Russell-Whitehead 1910, PM vol. I, `*73`.
* Cantor 1895/97, *Beiträge zur Begründung der transfiniten Mengenlehre*
  (cited PM `*73`).
-/

universe u v

namespace MathlibExpansion.Foundations.Russell

/-- SCA-01 (`*73·01`): two types are PM-similar when they are in bijection.
Wrapper over `α ≃ β`. -/
def russell_similar (α : Type u) (β : Type v) : Prop := Nonempty (α ≃ β)

/-- SCA-02 (`*73·11` reflexivity of similarity). -/
theorem russell_similar_refl (α : Type u) : russell_similar α α :=
  ⟨Equiv.refl α⟩

/-- SCA-03 (`*73·12` symmetry of similarity). -/
theorem russell_similar_symm {α : Type u} {β : Type v}
    (h : russell_similar α β) : russell_similar β α := by
  obtain ⟨e⟩ := h
  exact ⟨e.symm⟩

/-- SCA-04 (HARD `singleton-image lift`): the similarity of `Unit` and any
class consisting of exactly one object — the "type-raising" wrapper PM uses
to lift singletons through similarity. -/
theorem russell_similar_singleton_lift {α : Type u} (a : α) :
    russell_similar Unit {x : α // x = a} := by
  refine ⟨{
    toFun := fun _ => ⟨a, rfl⟩
    invFun := fun _ => ()
    left_inv := fun _ => rfl
    right_inv := fun ⟨x, hx⟩ => by
      cases hx; rfl }⟩

/-- SCA-05 (HARD `unit-class lowering`): under the similarity of `Unit` to
a unit class, the underlying object is determined uniquely. -/
theorem russell_unitClass_lowering {α : Type u} (a : α)
    (e : Unit ≃ {x : α // x = a}) : (e.toFun ()).1 = a :=
  (e.toFun ()).2

end MathlibExpansion.Foundations.Russell
