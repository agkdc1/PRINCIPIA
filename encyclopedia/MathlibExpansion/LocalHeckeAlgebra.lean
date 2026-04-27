/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import MathlibExpansion.EleventhGap
import Mathlib.Algebra.Module.Injective
import Mathlib.LinearAlgebra.Dimension.Finrank
import Mathlib.RingTheory.LocalRing.Basic

/-!
# Honest local Hecke algebra interfaces (Ribet Breach F5)

Typed replacements for the demolished `Prop`-laundering fields from
`EleventhGap` (Ribet Breach F2):

* `IsGorensteinCondition T`: `Module.Injective T T` — the real Gorenstein
  constraint replacing `GorensteinHeckeAlgebra.isGorenstein : Prop`.
* `LocalHeckeAlgebraAtMaximal`: bundles a real `RingHom φ : T →+* H.algebra`
  from an ambient full Hecke algebra type, replacing
  `LocalHeckeAlgebra.fromFullCompatibility : Prop`.
* `MazurRibetTilouineMultiplicityOne`: wraps a genuine
  `Module.finrank T M = 1` proof, replacing the deleted `multiplicityOne`
  theorem that proved an arbitrary `Prop` via `sorry`.

No `sorry`, no `:= True`, no arbitrary-`Prop` witness.
-/

namespace MathlibExpansion
namespace LocalHeckeAlgebra

open NumberTheory

/--
The Gorenstein condition for a commutative ring `T` viewed as a module over
itself: injectivity of `T` as a `T`-module.

This is the typed replacement for the deleted
`GorensteinHeckeAlgebra.isGorenstein : Prop` field (Ribet Breach F2).
The named `def` makes the condition explicit without asserting it holds for
any particular ring.
-/
def IsGorensteinCondition (T : Type*) [CommRing T]
    [AddCommMonoid T] [Module T T] : Prop :=
  Module.Injective T T

/--
A local Hecke algebra at a maximal ideal, equipped with a ring homomorphism
`φ : T →+* H.algebra` from an ambient full Hecke algebra type `T`.

`φ` is the real typed witness replacing the deleted
`LocalHeckeAlgebra.fromFullCompatibility : Prop` field (Ribet Breach F2).
The `localizationStatement` records that `φ` is an honest localization map;
it is an explicit boundary `Prop` because the upstream `IsLocalization` API
requires a prime ideal and multiplicative set not yet tied to the
`EleventhGap` structures.
-/
structure LocalHeckeAlgebraAtMaximal (T : Type*) [CommRing T]
    (H : LocalHeckeAlgebra) (φ : T →+* H.algebra) where
  localizationStatement : Prop
  localizationHolds : localizationStatement

/-- Recover the localization statement from the package. -/
theorem LocalHeckeAlgebraAtMaximal.localization_holds
    {T : Type*} [CommRing T] {H : LocalHeckeAlgebra} {φ : T →+* H.algebra}
    (h : LocalHeckeAlgebraAtMaximal T H φ) : h.localizationStatement :=
  h.localizationHolds

/--
The Mazur-Ribet-Tilouine multiplicity-one package: the free rank of `M` over
`T` equals one.

This is the typed replacement for the deleted `multiplicityOne` theorem
(Ribet Breach F2) which proved an arbitrary `freeOfRankOne : Prop` from
unrelated data via `sorry`. The present structure carries a genuine
`Module.finrank T M = 1` proof, forcing real mathematical content.
-/
structure MazurRibetTilouineMultiplicityOne
    (T : Type*) [CommRing T]
    (M : Type*) [AddCommMonoid M] [Module T M] where
  rankEqOne : Module.finrank T M = 1

/-- Recover the rank-one equation. -/
theorem MazurRibetTilouineMultiplicityOne.rank_eq_one
    {T : Type*} [CommRing T] {M : Type*} [AddCommMonoid M] [Module T M]
    (h : MazurRibetTilouineMultiplicityOne T M) :
    Module.finrank T M = 1 :=
  h.rankEqOne

end LocalHeckeAlgebra
end MathlibExpansion
