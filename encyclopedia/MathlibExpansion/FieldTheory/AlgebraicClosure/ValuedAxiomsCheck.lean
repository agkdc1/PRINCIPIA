import MathlibExpansion.FieldTheory.AlgebraicClosure.Valued

/-!
# Axiom check for valued algebraic closures of `ℚ_[p]`

This file is an executable probe target:

- it checks that `UniformSpace (AlgebraicClosure ℚ_[p])` now synthesizes;
- it checks that the completion type is formable;
- it prints the axiom ledger for the single upstream-narrow boundary and the
  derived extension theorem.
-/

namespace MathlibExpansion.FieldTheory.AlgebraicClosure.AxiomsCheck

open MathlibExpansion.FieldTheory.AlgebraicClosure

#check (inferInstance : Valued (AlgebraicClosure ℚ_[3]) NNReal)
#check UniformSpace.Completion (AlgebraicClosure ℚ_[3])
#check PadicAlgClosureCompletion 3

#print axioms padicValuedAlgebraicClosure
#print axioms algebraicClosurePadic_isValExtension

end MathlibExpansion.FieldTheory.AlgebraicClosure.AxiomsCheck
