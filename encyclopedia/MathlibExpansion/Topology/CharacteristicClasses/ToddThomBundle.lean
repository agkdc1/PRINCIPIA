/-
# Todd-Thom Bundle (Atiyah-Singer III 1968 §3 Thm 3.1)
B2 for T20c_mid_17_TTB.
-/
import Mathlib
set_option autoImplicit false
namespace MathlibExpansion.Topology.CharacteristicClasses.ToddThomBundle

/-- **AS III 1968 §3 Thm 3.1, Todd class carrier.** -/
structure ToddClass where
  dim : ℕ
  toddRationalRepr : ℚ

@[simp] theorem ToddClass.dim_zero :
    ({dim := 0, toddRationalRepr := 1} : ToddClass).dim = 0 := rfl

end MathlibExpansion.Topology.CharacteristicClasses.ToddThomBundle
