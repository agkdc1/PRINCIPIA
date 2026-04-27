import Mathlib

/-!
# Elementary continuity pack for Cauchy 1821

This module packages a textbook-facing bundle of continuity facts for the
elementary one-variable real functions listed by Cauchy.
-/

namespace MathlibExpansion
namespace Textbooks
namespace Cauchy1821

/-- A bundled continuity interface for Cauchy's elementary one-variable real
functions on their natural domains. -/
structure ElementaryContinuityPack where
  add_const : ∀ a : ℝ, Continuous fun x : ℝ => a + x
  sub_const : ∀ a : ℝ, Continuous fun x : ℝ => a - x
  mul_const : ∀ a : ℝ, Continuous fun x : ℝ => a * x
  div_const : ∀ a : ℝ, ContinuousOn (fun x : ℝ => a / x) {x : ℝ | x ≠ 0}
  nat_pow : ∀ n : ℕ, Continuous fun x : ℝ => x ^ n
  rpow_const : ∀ p : ℝ, ContinuousOn (fun x : ℝ => x ^ p) (Set.Ioi 0)
  exp : Continuous Real.exp
  log : ContinuousOn Real.log (Set.Ioi 0)
  sin : Continuous Real.sin
  cos : Continuous Real.cos
  arcsin : Continuous Real.arcsin
  arccos : Continuous Real.arccos

/-- The elementary continuity pack used in Cauchy's Chapter II. -/
theorem cauchyElementaryContinuityPack : ElementaryContinuityPack where
  add_const _ := continuous_const.add continuous_id
  sub_const _ := continuous_const.sub continuous_id
  mul_const _ := continuous_const.mul continuous_id
  div_const _ := (continuous_const.continuousOn.div continuous_id.continuousOn fun _ hx => hx)
  nat_pow n := continuous_id.pow n
  rpow_const _ :=
    continuous_id.continuousOn.rpow_const fun _ hx => Or.inl (ne_of_gt hx)
  exp := Real.continuous_exp
  log := fun _ hx => (Real.continuousAt_log (ne_of_gt hx)).continuousWithinAt
  sin := Real.continuous_sin
  cos := Real.continuous_cos
  arcsin := Real.continuous_arcsin
  arccos := Real.continuous_arccos

end Cauchy1821
end Textbooks
end MathlibExpansion
