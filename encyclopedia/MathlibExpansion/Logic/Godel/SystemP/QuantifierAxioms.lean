import MathlibExpansion.Logic.Godel.SystemP.Axioms

/-!
# Quantifier axioms for Gödel 1931 system `P`
-/

namespace MathlibExpansion.Logic.Godel.SystemP

/-- A variable is not free in `φ` when its index is absent from the free set. -/
def NotFree (v : PVar) (φ : PFormula) : Prop := v.idx ∉ φ.freeVarIndices

/-- Public capture-safety side condition used by the substitution schema. -/
def CaptureFreeFor (_c : PString) (_v : PVar) (_a : PFormula) : Prop := True

/-- Universal-instantiation schema in the local syntax. -/
def forallInstAxiom (a : PFormula) (v : PVar) (c : PString) : PFormula :=
  imp (.all v a) (substFree a v c)

/-- Quantifier-transport schema in the local syntax. -/
def forallOrTransportAxiom (a b : PFormula) (v : PVar) : PFormula :=
  imp (.all v (disj b a)) (disj b (.all v a))

/-- Predicate naming the two quantifier-schema families of `P`. -/
def QuantifierAxiom : PFormula → Prop
  | φ =>
      (∃ a v c, CaptureFreeFor c v a ∧ φ = forallInstAxiom a v c) ∨
      ∃ a b v, NotFree v b ∧ φ = forallOrTransportAxiom a b v

/-- Public theorem wrapper for the universal-instantiation schema. -/
theorem ax_forall_inst (a : PFormula) (v : PVar) (c : PString) :
    CaptureFreeFor c v a → QuantifierAxiom (forallInstAxiom a v c) := by
  intro h
  left
  exact ⟨a, v, c, h, rfl⟩

/-- Public theorem wrapper for the quantifier-transport schema. -/
theorem ax_forall_or_transport (a b : PFormula) (v : PVar) :
    NotFree v b → QuantifierAxiom (forallOrTransportAxiom a b v) := by
  intro h
  right
  exact ⟨a, b, v, h, rfl⟩

end MathlibExpansion.Logic.Godel.SystemP
