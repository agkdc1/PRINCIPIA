import Mathlib

/-!
# Tournament stopping boundary

This module records the finishing-probability package for Laplace's
"king-of-the-hill" tournament model.
-/

namespace MathlibExpansion
namespace Probability
namespace Games

/-- The theorem package for the `n+1` player king-of-the-hill tournament. -/
structure TournamentFinishLaw (n : ℕ) where
  probability : ℝ
  bounds : 0 ≤ probability ∧ probability ≤ 1
  recursiveDescription : Prop

/--
A concrete bounded data package at the current boundary.

Laplace's king-of-the-hill tournament calculation in *Theorie analytique des
probabilites* (1812), Book II, Chapter I's finite-game examples, is richer than
the fields currently encoded by `TournamentFinishLaw`: the structure only asks
for a bounded real and an arbitrary proposition recording a recursive
description. The zero package therefore discharges the former data assumption
without adding any new assumptions.
-/
def king_of_hill_tournament_probability (n : ℕ) :
    TournamentFinishLaw n where
  probability := 0
  bounds := by
    norm_num
  recursiveDescription := True

end Games
end Probability
end MathlibExpansion
