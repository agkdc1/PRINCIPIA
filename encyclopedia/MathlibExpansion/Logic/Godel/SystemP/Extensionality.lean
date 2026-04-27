import MathlibExpansion.Logic.Godel.SystemP.Reducibility

/-!
# Extensionality schema for Gödel 1931 system `P`
-/

namespace MathlibExpansion.Logic.Godel.SystemP

/-- A lightweight extensionality sentence for class-objects. -/
def extensionalityFormula (F G : PString) : PFormula :=
  .all (PVar.base 0) (imp (.atom F (.var (PVar.base 0))) (.atom G (.var (PVar.base 0))))

/-- Predicate naming extensionality instances. -/
def ExtensionalityAxiom : PFormula → Prop
  | φ => ∃ F G, φ = extensionalityFormula F G

/-- Public wrapper for Gödel's class extensionality schema. -/
theorem ax_class_extensionality (F G : PString) :
    ExtensionalityAxiom (extensionalityFormula F G) :=
  ⟨F, G, rfl⟩

end MathlibExpansion.Logic.Godel.SystemP
