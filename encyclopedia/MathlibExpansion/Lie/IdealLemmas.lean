import Mathlib

/-!
# Elementary Lie-ideal lemmas
-/

namespace MathlibExpansion.Lie

/-- Two ideals with trivial intersection centralize one another. -/
theorem lieIdeal_bracket_eq_bot_of_inf_eq_bot {R : Type*} [CommRing R] {L : Type*}
    [LieRing L] [LieAlgebra R L] (I J : LieIdeal R L) (h : I ⊓ J = ⊥) :
    ⁅I, J⁆ = ⊥ :=
  eq_bot_iff.mpr <| (LieSubmodule.lie_le_inf I J).trans (le_of_eq h)

end MathlibExpansion.Lie
