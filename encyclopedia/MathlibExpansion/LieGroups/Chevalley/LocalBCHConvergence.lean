import Mathlib

/-!
# Local BCH convergence

This file packages the commuting/Banach-algebra model of the BCH law, where the
local BCH series collapses to the additive formula `x + y`.
-/

namespace MathlibExpansion.LieGroups.Chevalley

section

variable {𝕜 : Type*} [RCLike 𝕜]
variable {A : Type*} [NormedRing A] [NormedAlgebra 𝕜 A] [CompleteSpace A]

/-- In the commuting model, the local BCH law is ordinary addition. -/
def commutingBCH (x y : A) : A := x + y

@[simp] theorem commutingBCH_comm (x y : A) :
    commutingBCH x y = commutingBCH y x := by
  simp [commutingBCH, add_comm]

@[simp] theorem commutingBCH_zero_left (x : A) : commutingBCH 0 x = x := by
  simp [commutingBCH]

@[simp] theorem commutingBCH_zero_right (x : A) : commutingBCH x 0 = x := by
  simp [commutingBCH]

@[simp] theorem commutingBCH_assoc (x y z : A) :
    commutingBCH (commutingBCH x y) z = commutingBCH x (commutingBCH y z) := by
  simp [commutingBCH, add_assoc]

@[simp] theorem commutingBCH_neg_left (x : A) : commutingBCH (-x) x = 0 := by
  simp [commutingBCH]

@[simp] theorem commutingBCH_neg_right (x : A) : commutingBCH x (-x) = 0 := by
  simp [commutingBCH]

theorem exp_commutingBCH_eq (x y : A) (hxy : Commute x y) :
    NormedSpace.exp 𝕜 (commutingBCH x y) =
      NormedSpace.exp 𝕜 x * NormedSpace.exp 𝕜 y := by
  simpa [commutingBCH] using
    (NormedSpace.exp_add_of_commute (𝕂 := 𝕜) (x := x) (y := y) hxy)

theorem analyticAt_commutingBCH (z : A × A) :
    AnalyticAt 𝕜 (fun p : A × A => commutingBCH p.1 p.2) z := by
  simpa [commutingBCH] using
    (analyticAt_fst : AnalyticAt 𝕜 (fun p : A × A => p.1) z).add analyticAt_snd

end

end MathlibExpansion.LieGroups.Chevalley
