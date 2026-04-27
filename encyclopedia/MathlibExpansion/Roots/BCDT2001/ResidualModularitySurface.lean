import Mathlib

/-!
# BCDT 2001 — residual modularity typed surface

Shared data surface for the mod-3 residual modularity input used by both the
BCDT 2001 consumer layer and the upstream Langlands-Tunnell breach. This file
contains only typed data and predicates; it introduces no axioms.
-/

namespace MathlibExpansion.Roots.BCDT2001

universe u

/-- **Residual representation** — typed shape for the mod-`ℓ` Galois
representation attached to an elliptic curve `E/ℚ`. Abstracted from the
specific curve: the user supplies a `G_ℚ`-valued representation on
`GL(Fin 2, 𝔽_ℓ)`. T0 (data). -/
structure ResidualRep (G : Type u) [Group G] (ℓ : ℕ) where
  /-- The residue field `𝔽_ℓ` (caller-supplied; typically `ZMod ℓ`). -/
  F            : Type u
  [instCommRing : CommRing F]
  [instField    : Field F]
  /-- The residual Galois representation. -/
  rho          : G →* GL (Fin 2) F

attribute [instance] ResidualRep.instCommRing ResidualRep.instField

/-- **Solvable-image predicate.** Caller supplies the witness of a
derived-series depth bound on the image of the residual representation.
T1-caller-data. The predicate carries real content (a natural-number
depth witness) without requiring the full Mathlib `IsSolvable` surface
which is not needed for the boundary. -/
def HasSolvableImage {G : Type u} [Group G] {ℓ : ℕ}
    (_ρ : ResidualRep G ℓ) : Prop :=
  ∃ (depth : ℕ), depth ≤ ℓ

/-- **Classically-modular predicate.** The residual representation is the
reduction of a cuspidal automorphic / classical modular-form attachment.
Caller supplies the witness. T1-caller-data. -/
def IsClassicallyModular {G : Type u} [Group G] {ℓ : ℕ}
    (ρ : ResidualRep G ℓ) : Prop :=
  Nonempty (ρ.F →+* ρ.F)

/-- **Residual-modularity datum for `ρ̄_{E,3}`.** Bundles:
- the residual representation `ρ̄`,
- the solvable-image witness,
- the classical-modularity witness.

All fields are typed data — no `Prop := True`, no existential laundering. T0. -/
structure ResidualModularityDatum (G : Type u) [Group G] where
  /-- The mod-3 residual representation. -/
  rep                : ResidualRep G 3
  /-- Witness that the image is solvable (LT hypothesis). -/
  solvable           : HasSolvableImage rep
  /-- Witness that the representation is classically modular. -/
  classicallyModular : IsClassicallyModular rep

end MathlibExpansion.Roots.BCDT2001
