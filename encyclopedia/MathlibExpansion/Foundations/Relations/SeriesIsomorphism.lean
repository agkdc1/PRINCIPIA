import MathlibExpansion.Foundations.Relations.SimpleSeries

/-!
# Isomorphism of simple endless series

This file isolates the structural payoff theorem for the generic endless-series
substrate.
-/

universe u v

namespace MathlibExpansion.Foundations.Relations

/-- Any two carriers supporting a simple endless series are isomorphic. -/
theorem simpleEndlessSeries_iso {α : Type u} {β : Type v}
    (hα : Nonempty (SimpleEndlessSeries α))
    (hβ : Nonempty (SimpleEndlessSeries β)) :
    Nonempty (α ≃ β) := by
  rcases hα with ⟨S⟩
  rcases hβ with ⟨T⟩
  exact S.nonempty_equiv T

end MathlibExpansion.Foundations.Relations
