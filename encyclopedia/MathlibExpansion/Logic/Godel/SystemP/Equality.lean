import MathlibExpansion.Logic.Godel.SystemP.Substitution

/-!
# Typed equality shadows for Gödel 1931 system `P`

This file names the Leibniz-style equality corridor used by the Chapter 2
axiom package. It is intentionally small and carrier-facing.
-/

namespace MathlibExpansion.Logic.Godel.SystemP

/-- Leibniz equality on the syntactic string carrier. -/
def PLeibnizEq (x y : PString) : Prop := ∀ P : PString → Prop, P x → P y

theorem pLeibnizEq_refl (x : PString) : PLeibnizEq x x := by
  intro P hx
  exact hx

theorem pLeibnizEq_eq {x y : PString} (hxy : PLeibnizEq x y) : x = y :=
  hxy (fun z => x = z) rfl

end MathlibExpansion.Logic.Godel.SystemP
