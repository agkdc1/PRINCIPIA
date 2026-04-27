import Mathlib.RingTheory.Ideal.Colon

/-!
# Atiyah-Macdonald numerics substrate: canonical ideal assignment

The current pinned Mathlib snapshot already exposes the module annihilator, but
it does not expose a reusable finitely-presented Fitting-ideal API for the
Diamond/BCDT consumer surface.

To discharge the Diamond producer axiom honestly today, we stabilize the
consumer-facing ideal assignment with the annihilator-backed ideal already in
Mathlib. This keeps the boundary canonical and theorem-land, and isolates the
eventual swap to a genuine Fitting-ideal implementation in exactly one file.
-/

namespace MathlibExpansion.Roots.AtiyahMacdonald

universe u v

section FittingIdeal

variable {R : Type u} [CommRing R]
variable {M : Type v} [AddCommGroup M] [Module R M]
variable {M' : Type v} [AddCommGroup M'] [Module R M']

/-- Canonical ideal used at the Diamond/BCDT numerics boundary.

In the current snapshot this is the module annihilator. The point of the
definition is not to hide that fact, but to keep the consumer surface canonical
and localized so that a future presentation-side refinement does not force
another Diamond/BCDT rewrite.
-/
abbrev fittingIdeal : Ideal R :=
  Module.annihilator R M

/-- The boundary ideal is definitionally the annihilator in the current bridge. -/
@[simp]
theorem fittingIdeal_eq_annihilator :
    fittingIdeal (R := R) (M := M) = Module.annihilator R M :=
  rfl

/-- The boundary ideal always lies below the annihilator. -/
theorem fittingIdeal_le_annihilator :
    fittingIdeal (R := R) (M := M) ≤ Module.annihilator R M := by
  intro r hr
  simpa [fittingIdeal] using hr

/-- Linear equivalences preserve the canonical boundary ideal. -/
theorem fittingIdeal_eq_of_linearEquiv (e : M ≃ₗ[R] M') :
    fittingIdeal (R := R) (M := M) = fittingIdeal (R := R) (M := M') := by
  simpa [fittingIdeal] using e.annihilator_eq (R := R)

/-- For quotient modules, the canonical boundary ideal is the usual colon ideal. -/
theorem fittingIdeal_quotient_eq_colon (N : Submodule R M) :
    fittingIdeal (R := R) (M := M ⧸ N) = N.colon ⊤ := by
  simpa [fittingIdeal] using (Submodule.annihilator_quotient (R := R) (M := M) (N := N))

/-- The canonical boundary ideal is `⊤` on subsingleton modules. -/
theorem fittingIdeal_eq_top [Subsingleton M] :
    fittingIdeal (R := R) (M := M) = ⊤ := by
  simpa [fittingIdeal] using
    ((Module.annihilator_eq_top_iff (R := R) (M := M)).2 ‹Subsingleton M›)

end FittingIdeal

end MathlibExpansion.Roots.AtiyahMacdonald
