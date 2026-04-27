import MathlibExpansion.Logic.Frege.Functions

/-!
# Safe Frege predicate shadow

This file names the minimal higher-order semantic layer needed for the Frege
predicate-calculus rows that do not require a separate syntax or proof system.
-/

universe u

namespace MathlibExpansion.Logic.Frege

/-- The safe object-level shadow of Frege's universal quantifier. -/
def FregeAllObj {α : Type u} (P : FregeConcept α) : Prop := ∀ a, P a

@[simp] theorem fregeAllObj_iff {α : Type u} (P : FregeConcept α) :
    FregeAllObj P ↔ ∀ a, P a := Iff.rfl

/-- Eliminate the safe object-level universal quantifier by direct application. -/
theorem fregeAllObj_elim {α : Type u} {P : FregeConcept α}
    (h : FregeAllObj P) (a : α) : P a :=
  h a

/-- Safe higher-order instantiation for a quantified first-level function. -/
theorem frege_forall_fun_elim {α : Type u} {Φ : FregeConcept α → Prop}
    (h : ∀ F, Φ F) (G : FregeConcept α) : Φ G :=
  h G

/-- Basic Law III in a safe higher-order shadow: identity is equivalent to
agreement under all unary predicates. -/
theorem frege_basicLawIII {α : Type u} {a b : α} :
    a = b ↔ ∀ P : FregeConcept α, P b → P a := by
  constructor
  · intro h P hPb
    simpa [h] using hPb
  · intro h
    exact h (fun x => x = b) rfl

/-- Theorem IIIe in the safe shadow: self-identity follows from Basic Law III. -/
theorem frege_self_identity_from_basicLawIII {α : Type u}
    (hBL3 : ∀ {a b : α}, a = b ↔ ∀ P : FregeConcept α, P b → P a)
    (a : α) : a = a := by
  exact (hBL3 (a := a) (b := a)).2 (fun _ h => h)

end MathlibExpansion.Logic.Frege
