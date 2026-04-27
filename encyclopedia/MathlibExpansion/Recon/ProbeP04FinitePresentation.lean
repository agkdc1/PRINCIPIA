import Mathlib.Algebra.Module.FinitePresentation

section ProbeP04

variable (R M : Type*) [Ring R] [AddCommGroup M] [Module R M]

#check @Module.FinitePresentation
#check Module.finitePresentation_of_finite

example [IsNoetherianRing R] [Module.Finite R M] : Module.FinitePresentation R M := by
  infer_instance

example [IsNoetherianRing R] [Module.Finite R M] : Module.FinitePresentation R M := by
  exact Module.finitePresentation_of_finite R M

end ProbeP04
