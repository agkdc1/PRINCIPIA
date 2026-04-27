import Mathlib.GroupTheory.QuotientGroup.Defs
import Mathlib.GroupTheory.Coset.Defs

#check QuotientGroup.lift
#check QuotientGroup.lift_mk
#check QuotientGroup.mk
#check Quotient.liftOn'

section

variable {G M : Type*} [Group G] [Group M]
variable (N : Subgroup G) [N.Normal]
variable (φ : G →* M) (hN : N ≤ φ.ker)

example : G ⧸ N →* M := QuotientGroup.lift N φ hN

example (g : G) : QuotientGroup.lift N φ hN (QuotientGroup.mk g) = φ g := by
  simp

end
