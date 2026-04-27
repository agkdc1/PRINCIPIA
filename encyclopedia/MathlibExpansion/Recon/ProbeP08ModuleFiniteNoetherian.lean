import Mathlib.RingTheory.Noetherian.Basic

section ProbeP08

variable (R M : Type*) [Ring R] [AddCommGroup M] [Module R M]

#check @isNoetherian_of_isNoetherianRing_of_finite

example [IsNoetherianRing R] [Module.Finite R M] : IsNoetherian R M := by
  infer_instance

example [IsNoetherianRing R] [Module.Finite R M] : IsNoetherian R M :=
  isNoetherian_of_isNoetherianRing_of_finite R M

end ProbeP08
