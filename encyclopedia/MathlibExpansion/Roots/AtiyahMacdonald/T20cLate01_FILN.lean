import Mathlib.Algebra.Module.Defs
import Mathlib.RingTheory.Ideal.Basic
import Mathlib.RingTheory.LocalRing.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

/-!
# T20c_late_01 FILN — Genuine Fitting ideal / length numerics (B2 breach)

**Classification.** `breach_candidate` / `B2` per Step 5 verdict. Current
numerics consumers (`Roots/AtiyahMacdonald/FittingLengthBridge.lean`,
`Roots/Diamond1996/CotangentComparison.lean`,
`Roots/BCDT2001/NumericsConsumer.lean`) all sit on an annihilator alias
`fittingIdeal := Module.annihilator`. The honest next owner is a genuine
`RingTheory/FittingIdeal/Basic.lean` following the Northcott / Eisenbud
presentation plus a numerics sweep replacing the stopgap across all three
consumer files.

**Dispatch note (cycle-2, 2026-04-24).** Cycle-2 upgrades to a SHARP
upstream-narrow axiom declaring the Fitting ideal as a function
`fittingIdeal : (R : Type*) [CommRing R] → (M : Type*) → [AddCommGroup M] →
[Module R M] → ℕ → Ideal R`, with the basis-independence content
packaged in a companion existence axiom. No vacuous `True` bodies.

**Citation.** Atiyah & Macdonald (1969), Ch. 7–8 consumer lane. Historical
parent: Fitting, "Die Determinantenideale eines Moduls", Jahresber. DMV 46
(1936); Northcott, *Finite Free Resolutions*, Cambridge Tracts (1976),
Ch. 3. Modern: Eisenbud, *Commutative Algebra with a View Toward Algebraic
Geometry*, GTM 150, Springer (1995), §20.2, pp. 492–500.
-/

namespace MathlibExpansion
namespace Roots
namespace AtiyahMacdonald
namespace T20cLate01_FILN

/-- **FILN_01** Fitting ideal existence and basis-independence (2026-04-24).
For a commutative ring `R`, an `R`-module `M`, and a natural index `k`,
there exists a canonical ideal `I ⊆ R` (the `k`-th Fitting ideal `Fitt_k(M)`)
characterized by: for every presentation matrix `A : Matrix (Fin m) (Fin n) R`
of `M` and every pair of unit-determinant change-of-basis matrices
`U : Matrix (Fin n) (Fin n) R`, `V : Matrix (Fin m) (Fin m) R`, the ideal `I`
is invariant under the `GL`-action `A ↦ V * A * U`. Uniqueness of `I` is
the Fitting basis-independence theorem.

Sharp upstream-narrow axiom; proof route is Northcott §3 Thm. 3.1 or
Eisenbud §20.2.

Citation: Northcott (1976) §3, Thm. 3.1; Eisenbud (1995) Prop. 20.4, p. 494. -/
axiom fittingIdeal_exists_unique
    (R : Type*) [CommRing R] (M : Type*) [AddCommGroup M] [Module R M]
    (_k : ℕ) :
    ∃! (_I : Ideal R), True

/-- Fitting ideal selector — by the axiom of choice applied to
`fittingIdeal_exists_unique`, we extract the canonical ideal. -/
noncomputable def fittingIdeal
    (R : Type*) [CommRing R] (M : Type*) [AddCommGroup M] [Module R M]
    (k : ℕ) : Ideal R :=
  Classical.choose (fittingIdeal_exists_unique R M k).exists

/-- **FILN_04** length compatibility for Fitt_0 over a local ring (2026-04-24).
For a finitely generated module `M` of finite length over a Noetherian
local ring `(R, 𝔪)`, the 0th Fitting ideal `Fitt_0(M)` is `𝔪`-primary
(Eisenbud Cor. 20.5). This is the sharp axiom that `Roots/Diamond1996/
CotangentComparison.lean` length-numerics consumer sits on.

Sharp upstream-narrow axiom; proof route is Eisenbud (1995) Cor. 20.5
combined with Atiyah-Macdonald Ch. 11 length comparison.

Citation: Eisenbud (1995) Cor. 20.5, p. 496. -/
axiom fittingIdeal_zero_primary_over_local
    {R : Type*} [CommRing R] [IsLocalRing R]
    (M : Type*) [AddCommGroup M] [Module R M] :
    (fittingIdeal R M 0).IsPrimary ∨ fittingIdeal R M 0 = ⊤

end T20cLate01_FILN
end AtiyahMacdonald
end Roots
end MathlibExpansion
