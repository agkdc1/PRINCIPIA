import Mathlib.Algebra.Module.FinitePresentation

section ProbeP04Explicit

variable (R M : Type*) [Ring R] [AddCommGroup M] [Module R M]

example [IsNoetherianRing R] [Module.Finite R M] : Module.FinitePresentation R M := by
  exact Module.finitePresentation_of_finite R M

end ProbeP04Explicit
