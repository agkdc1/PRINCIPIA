import MathlibExpansion.Roots.BCDT2001.ResidualModularitySurface
import MathlibExpansion.Roots.LanglandsTunnell.ResidualModularity

/-!
# BCDT 2001 — Bucket 5: Langlands-Tunnell residual modularity (consumer)

Thin BCDT consumer wrapper around the upstream Langlands-Tunnell breach. The
typed residual-modularity surface lives in
`Roots.BCDT2001.ResidualModularitySurface`; the single upstream LT axiom lives
in `Roots.LanglandsTunnell.ResidualModularity`.

**Discharge status.** `bcdt_langlandsTunnell_mod3_modularity` is no longer a
BCDT-local axiom. It is a definition that packages the upstream
`langlandsTunnellResidualModular` witness with the caller's representation and
solvability proof. This reclaims BCDT's former contingent Axiom 3.

**Poison dodge.** Imports only the shared residual-modularity surface and the
upstream LT breach module. No `Quarantine/TwelfthGap`,
`Roots/FontaineLaffaille*`, `DeligneAttachedRep*`, or poisoned siblings.
-/

namespace MathlibExpansion.Roots.BCDT2001

universe u

open MathlibExpansion.Roots.LanglandsTunnell

/-- **BCDT discharge of Langlands-Tunnell residual modularity at `p = 3`.**

This is a thin wrapper over the upstream LT breach theorem. The returned datum
remembers the caller's residual representation and the exact solvability witness,
so downstream BCDT consumers no longer need any `∨ True` escape hatch. -/
noncomputable def bcdt_langlandsTunnell_mod3_modularity
    {G : Type u} [Group G]
    (ρ : ResidualRep G 3)
    (h_solv : HasSolvableImage ρ) :
    ResidualModularityDatum G :=
  langlandsTunnell_discharges_bcdt_axiom3 ρ h_solv

/-- **Consumer-facing LT producer.** Wraps the upstream LT discharge theorem
with a clean BCDT-local signature and preserves the caller's solvability
witness exactly. -/
theorem langlandsTunnell_of_solvable
    {G : Type u} [Group G]
    (ρ : ResidualRep G 3)
    (h_solv : HasSolvableImage ρ) :
    ∃ datum : ResidualModularityDatum G,
      datum.rep = ρ ∧ datum.solvable = h_solv := by
  refine ⟨bcdt_langlandsTunnell_mod3_modularity ρ h_solv, rfl, ?_⟩
  exact Subsingleton.elim _ _

/-- **Projection to the classical-modularity witness.** Extracts the
T1-caller-data witness from the typed datum. -/
theorem langlandsTunnell_modularity
    {G : Type u} [Group G]
    (datum : ResidualModularityDatum G) :
    IsClassicallyModular datum.rep :=
  datum.classicallyModular

end MathlibExpansion.Roots.BCDT2001
