/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import MathlibExpansion.FifthGap
import MathlibExpansion.SeventhGap
import Mathlib.RingTheory.Ideal.Basic
import Mathlib.RingTheory.LocalRing.Basic

/-!
# Local Hecke algebras and Hecke-Galois compatibility

This file supplies the eleventh FLT-chain interface: the Hecke-algebra side of
the "R = T" identification used by Wiles and Taylor-Wiles. The previous gaps
introduced the Galois side (deformation theory, local conditions). This gap
records the Hecke side:

* local (completed) Hecke algebras localised at a maximal ideal;
* a Gorenstein package refining a local Hecke algebra;
* congruence modules;
* Hecke-Galois compatibility via Deligne's trace relations;
* the module of modular symbols as a Hecke module;
* a Néron component group package used in Ribet's level-lowering argument.

**Demolition note (2026-04-20, Ribet Breach F2):** The following laundered
`Prop` fields have been removed per the Recon #1/#4/#8 audit (fire-spec §5):
- `LocalHeckeAlgebra.fromFullCompatibility : Prop`
- `GorensteinHeckeAlgebra.isGorenstein : Prop`
- `CongruenceModule.fittingEq : Prop` / `lengthEq : Prop`
- `ModularSymbolsHeckeAction.compatibleWithFull : Prop`
- `NeronComponentGroup.exactSequence : Prop`
- `multiplicityOne : ∀ (freeOfRankOne : Prop), freeOfRankOne` (unsound signature)

Honest replacements land in `MathlibExpansion.LocalHeckeAlgebra` (Ribet Breach F5).
-/

universe u v w

open scoped MatrixGroups

namespace NumberTheory

/--
A local (completed) Hecke algebra localised at a maximal ideal `m` of the full
Hecke algebra.

The underlying type `algebra` carries its own `CommRing` and `IsLocalRing`
instances. The `fromFullCompatibility : Prop` field has been removed (Ribet
Breach F2); see `MathlibExpansion.LocalHeckeAlgebra` for the honest typed
replacement using a real localization map.
-/
structure LocalHeckeAlgebra where
  algebra : Type*
  commRing : CommRing algebra
  isLocal : IsLocalRing algebra

attribute [instance] LocalHeckeAlgebra.commRing
attribute [instance] LocalHeckeAlgebra.isLocal

/--
A Gorenstein refinement of a local Hecke algebra.

The `isGorenstein : Prop` field has been removed (Ribet Breach F2). The honest
replacement uses `Module.Injective T T` as a real typeclass constraint; see
`MathlibExpansion.LocalHeckeAlgebra.IsGorensteinArtinLocal`.
-/
structure GorensteinHeckeAlgebra where
  toLocal : LocalHeckeAlgebra

/--
A congruence-module package.

The `fittingEq : Prop` and `lengthEq : Prop` fields have been removed (Ribet
Breach F2). The honest replacement requires a real `Module.finrank` equation;
see `MathlibExpansion.LocalHeckeAlgebra.MazurRibetTilouineMultiplicityOne`.
-/
structure CongruenceModule where
  ring : Type*
  commRing : CommRing ring
  idealJ : Ideal ring
  length : ℕ

attribute [instance] CongruenceModule.commRing

/--
A Hecke-Galois compatibility package: a Hecke eigenvalue system, an attached
Galois representation, and an indexed `Prop` expressing the Deligne trace
relation `tr ρ (Frob_l) = a_l(f)` at every unramified prime. The relation is
bundled as an indexed proposition, so no content is asserted by this interface.
-/
structure HeckeGaloisCompatibility {Γ : Subgroup SL(2, ℤ)} {k : ℤ} {ι : Type*}
    {G : Type u} {R : Type v} {M : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace R] [Semiring R]
    [TopologicalSpace M] [AddCommMonoid M] [Module R M]
    [TopologicalSpace (M ≃ₗ[R] M)]
    (T : ι → HeckeOperator Γ k) (f : ModularForm Γ k)
    (system : HeckeEigenvalueSystem T f)
    (ρ : GaloisRepresentation G R M)
    (attached : GaloisRepresentationAttachedToEigenform T f system ρ) where
  deligneTraceAgreement : ι → Prop
  traceAgrees : ∀ i, deligneTraceAgreement i

/--
Recover the indexed Deligne trace agreement from a Hecke-Galois compatibility
package.
-/
theorem HeckeGaloisCompatibility.traceAgrees_at {Γ : Subgroup SL(2, ℤ)}
    {k : ℤ} {ι : Type*} {G : Type u} {R : Type v} {M : Type w}
    [TopologicalSpace G] [Monoid G] [TopologicalSpace R] [Semiring R]
    [TopologicalSpace M] [AddCommMonoid M] [Module R M]
    [TopologicalSpace (M ≃ₗ[R] M)] {T : ι → HeckeOperator Γ k}
    {f : ModularForm Γ k} {system : HeckeEigenvalueSystem T f}
    {ρ : GaloisRepresentation G R M}
    {attached : GaloisRepresentationAttachedToEigenform T f system ρ}
    (h : HeckeGaloisCompatibility T f system ρ attached) (i : ι) :
    h.deligneTraceAgreement i :=
  h.traceAgrees i

/--
A Hecke action on the module of modular symbols.

The `compatibleWithFull : Prop` field has been removed (Ribet Breach F2).
See `MathlibExpansion.LocalHeckeAlgebra.LocalizedModularSymbols` for the
honest typed replacement with a real quotient module.
-/
structure ModularSymbolsHeckeAction where
  H : LocalHeckeAlgebra
  symbols : Type*
  addCommGroup : AddCommGroup symbols
  module : Module H.algebra symbols

attribute [instance] ModularSymbolsHeckeAction.addCommGroup
attribute [instance] ModularSymbolsHeckeAction.module

-- multiplicityOne DELETED (Ribet Breach F2):
--   `theorem multiplicityOne (M : ModularSymbolsHeckeAction)
--       (irreducibleResidual : Prop) (_hirr : irreducibleResidual)
--       (freeOfRankOne : Prop) : freeOfRankOne`
-- proves an arbitrary Prop from unrelated data (Recon #4 Finding, Recon #8
-- Finding 3). Honest replacement:
-- `MathlibExpansion.LocalHeckeAlgebra.MazurRibetTilouineMultiplicityOne`

/--
The Néron component group package used in Ribet's level-lowering argument.

The `exactSequence : Prop` field has been removed (Ribet Breach F2). The
genuine short exact sequence `0 → T_l(J₀) → T_l(J₁) → Φ_l → 0` requires
`J₀(N)` and Néron models, which are absent from Mathlib v4.17.0 (Recon #7).
See `MathlibExpansion.RibetConductorDrop` for the honest algebraic replacement.
-/
structure NeronComponentGroup where
  components : Type*
  addCommGroup : AddCommGroup components

attribute [instance] NeronComponentGroup.addCommGroup

end NumberTheory
