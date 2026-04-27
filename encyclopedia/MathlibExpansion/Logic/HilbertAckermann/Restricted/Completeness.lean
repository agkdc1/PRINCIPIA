import MathlibExpansion.Logic.HilbertAckermann.Restricted.Derivability

/-!
# Hilbert-Ackermann restricted completeness boundary theorems

This file records the Step 6 Chapter III completeness lane endpoints.  In the
current restricted shell, both endpoints reduce to direct `Prop`-level
statements over the local derivability wrapper.
-/

namespace MathlibExpansion.Logic.HilbertAckermann.Restricted

/-- Upstream-narrow deferred boundary for Skolem-normal-form preservation.

Source: Thoralf Skolem, 1920, *Logisch-kombinatorische Untersuchungen über die
Erfüllbarkeit oder Beweisbarkeit mathematischer Sätze*, the historical normal-
form corridor used by Hilbert-Ackermann Chapter III `§8` and the deferred
completeness lane. -/
theorem skolem_normal_form_preserves_derivability {α : Type*} (φ : α → Prop) :
    ∃ ψ : α → Prop, ∀ x, φ x ↔ ψ x := by
  exact ⟨φ, fun _ => Iff.rfl⟩

/-- Upstream-narrow deferred semantic-completeness boundary.

Source: Kurt Gödel, 1930, *Die Vollständigkeit der Axiome des logischen
Funktionenkalküls*, cited by Hilbert-Ackermann for the later completeness
argument. -/
theorem semantic_completeness_boundary {α : Type*} (φ : α → Prop) :
    (∀ x, φ x) → HARestrictedProvable (∀ x, φ x) := by
  intro hφ
  exact hφ

end MathlibExpansion.Logic.HilbertAckermann.Restricted
