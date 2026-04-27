import Mathlib.Logic.Equiv.Set
import Mathlib.SetTheory.Cardinal.Basic

/-!
# Cantor covering sets

Cantor's covering-set `(N | M)` is the set of all functions `N → M`. This
file packages that equivalence and the induced cardinal-exponentiation formula.
-/

namespace MathlibExpansion.SetTheory.Cantor

universe u v

noncomputable def cantorCoveringEquivFun (N : Type u) (M : Type v) :
    Set.pi (Set.univ : Set N) (fun _ => (Set.univ : Set M)) ≃ (N → M) :=
  (Equiv.Set.univPi (fun _ => (Set.univ : Set M))).trans
    (Equiv.piCongrRight fun _ => Equiv.Set.univ M)

theorem mk_cantorCovering_eq (N : Type u) (M : Type v) :
    Cardinal.mk (Set.pi (Set.univ : Set N) (fun _ => (Set.univ : Set M))) =
      Cardinal.lift (Cardinal.mk M) ^ Cardinal.lift (Cardinal.mk N) := by
  exact (Cardinal.mk_congr (cantorCoveringEquivFun N M)).trans (Cardinal.mk_arrow N M)

end MathlibExpansion.SetTheory.Cantor
