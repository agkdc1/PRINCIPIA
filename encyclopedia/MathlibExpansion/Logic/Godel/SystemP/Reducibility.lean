import MathlibExpansion.Logic.Godel.SystemP.QuantifierAxioms

/-!
# Reducibility schema for Gödel 1931 system `P`
-/

namespace MathlibExpansion.Logic.Godel.SystemP

/-- A lightweight reducibility / comprehension formula wrapper. -/
def reducibilityFormula (a : PFormula) : PFormula :=
  .all (PVar.base 0) (disj (neg a) a)

/-- Predicate naming reducibility instances. -/
def ReducibilityAxiom : PFormula → Prop
  | φ => ∃ a, φ = reducibilityFormula a

/-- Public wrapper for Gödel's reducibility schema `IV.1`. -/
theorem ax_reducibility (a : PFormula) : ReducibilityAxiom (reducibilityFormula a) :=
  ⟨a, rfl⟩

end MathlibExpansion.Logic.Godel.SystemP
