import MathlibExpansion.Logic.Godel.RelativeProvability

/-!
# Consequence closure for relative Gödel provability
-/

namespace MathlibExpansion.Logic.Godel

/-- Gödel's `Flg(c)` closure, named directly by relative provability. -/
def consequenceClosure (c : AxiomSetCode) : Set FormulaCode := {x | ProvableWithAxioms c x}

/-- Relative provability is exactly membership in the consequence closure. -/
theorem provableWithAxioms_iff_memFlg (c : AxiomSetCode) (x : FormulaCode) :
    ProvableWithAxioms c x ↔ x ∈ consequenceClosure c :=
  Iff.rfl

end MathlibExpansion.Logic.Godel
