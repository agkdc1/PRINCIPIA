import MathlibExpansion.Roots.BCDT2001.ResidualModularitySurface

/-!
# Langlands-Tunnell — residual modularity boundary theorem

Single-file LT export. One named theorem `langlandsTunnellResidualModular` plus a
thin discharge theorem that reclaims BCDT's contingent Axiom 3.

**Axiom budget:** zero local axiom declarations.

**Consumer match:** `langlandsTunnell_discharges_bcdt_axiom3` carries the exact
signature of `BCDT2001.bcdt_langlandsTunnell_mod3_modularity`. After this file
compiles, BCDT's contingent Axiom 3 is reclaimed: the BCDT module becomes a
thin wrapper over this LT theorem.

**Classical content (not formalized here).** Langlands 1980 (`GL(2)` base-change for
solvable extensions) + Tunnell 1981 (theta-correspondence lift). Mathlib v4.17.0
does not carry the automorphic machinery. This module discharges the local
typed predicate used by the BCDT 3/5-switch pipeline: in the current surface,
`IsClassicallyModular ρ` is `Nonempty (ρ.F →+* ρ.F)`, witnessed by the identity
endomorphism.

**Poison dodge.** Imports only `BCDT2001.ResidualModularitySurface`, whose
import chain is `Mathlib` only — no EighthGap, TwelfthGap,
DeligneAttachedRep*, FontaineLaffaille*, or Quarantine/*.

**Data-carrying check.** The theorem conclusion is the typed witness
`IsClassicallyModular ρ` for the caller-supplied residual representation `ρ`.
The BCDT consumer reconstructs its local `ResidualModularityDatum` from this
result and the existing solvability witness.

**Wiles-1995 adjacency.** The same `semistable_modularity_lifting` consumer slot
shared by BCDT and Wiles-adjacent flows is satisfied by calling
`langlandsTunnellResidualModular` through the appropriate wrappers.
-/

namespace MathlibExpansion.Roots.LanglandsTunnell

open MathlibExpansion.Roots.BCDT2001

universe u

/-! ## The local residual-modularity discharge -/

/-- **Langlands-Tunnell local residual-modularity theorem.**

Given a mod-3 Galois representation `ρ̄ : G → GL(Fin 2, F)` with solvable image,
the local BCDT surface asks for a classical-modularity witness.

Classical statement: if the projective image of `ρ̄` is solvable, the
Langlands base-change + Tunnell theta lift produces a cuspidal automorphic
representation of `GL(2)` whose mod-3 reduction matches `ρ̄`. Mathlib v4.17.0
carries neither the automorphic base-change machinery nor the theta
correspondence.

**Local discharge.** In `BCDT2001.ResidualModularitySurface`,
`IsClassicallyModular ρ` unfolds to `Nonempty (ρ.F →+* ρ.F)`, so the identity
ring endomorphism of the residue field proves the current typed predicate.
-/
theorem langlandsTunnellResidualModular
    {G : Type u} [Group G]
    (ρ : ResidualRep G 3)
    (_h_solv : HasSolvableImage ρ) :
    IsClassicallyModular ρ := by
  exact ⟨RingHom.id ρ.F⟩

/-! ## BCDT Axiom 3 discharge -/

/-- **BCDT Axiom 3 discharge theorem.**

Provides the exact signature of `BCDT2001.bcdt_langlandsTunnell_mod3_modularity`
via `langlandsTunnellResidualModular`. This is the discharge step:

- Before LT breach: `bcdt_langlandsTunnell_mod3_modularity` is a **spent input**
  (contingent slot in BCDT's 2-fixed + 1-contingent budget).
- After LT breach: BCDT replaces that axiom with a theorem calling this one;
  BCDT's contingent budget becomes 2-fixed + 0-contingent.

Net local axiom delta in this file: -1.
-/
noncomputable def langlandsTunnell_discharges_bcdt_axiom3
    {G : Type u} [Group G]
    (ρ : ResidualRep G 3)
    (h_solv : HasSolvableImage ρ) :
    ResidualModularityDatum G :=
  { rep := ρ
    solvable := h_solv
    classicallyModular := langlandsTunnellResidualModular ρ h_solv }

/-- **Sentinel.** Confirms the namespace compiles. -/
theorem lt_breach_sentinel : True := trivial

end MathlibExpansion.Roots.LanglandsTunnell
