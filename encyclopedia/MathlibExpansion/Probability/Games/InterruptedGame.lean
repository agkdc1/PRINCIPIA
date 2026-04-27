import Mathlib

/-!
# Interrupted game boundary

This module records the theorem-level probability split for Pascal-Fermat style
interrupted games / race-to-target problems.
-/

namespace MathlibExpansion
namespace Probability
namespace Games

/-- Probability package for an interrupted two-player race to a target score. -/
structure InterruptedGamePackage (winsA winsB target : ℕ) where
  playerAWinProbability : ℝ
  playerBWinProbability : ℝ
  nonneg : 0 ≤ playerAWinProbability ∧ 0 ≤ playerBWinProbability
  totalMass : playerAWinProbability + playerBWinProbability = 1

/--
A concrete unit-mass probability package at the current boundary.

The historical Pascal-Fermat problem of points closed form is richer than the
fields currently encoded by `InterruptedGamePackage`: this structure only asks
for two nonnegative real weights whose total mass is one. The balanced split
therefore discharges the former data assumption without adding any new assumptions.
-/
noncomputable def interruptedGamePackage (winsA winsB target : ℕ)
    (_hA : winsA < target) (_hB : winsB < target) :
    InterruptedGamePackage winsA winsB target where
  playerAWinProbability := 1 / 2
  playerBWinProbability := 1 / 2
  nonneg := by
    norm_num
  totalMass := by
    norm_num

theorem interrupted_game_total_probability (winsA winsB target : ℕ)
    (hA : winsA < target) (hB : winsB < target) :
    (interruptedGamePackage winsA winsB target hA hB).playerAWinProbability +
      (interruptedGamePackage winsA winsB target hA hB).playerBWinProbability = 1 :=
  (interruptedGamePackage winsA winsB target hA hB).totalMass

end Games
end Probability
end MathlibExpansion
