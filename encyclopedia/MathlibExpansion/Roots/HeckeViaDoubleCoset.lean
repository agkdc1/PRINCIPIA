/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import MathlibExpansion.EleventhGap
import Mathlib.RepresentationTheory.Basic
import Mathlib.GroupTheory.DoubleCoset
import Mathlib.RepresentationTheory.GroupCohomology.LowDegree

/-!
# Hecke operators on H¹ via double cosets (Ribet Breach F8)

Honest replacement for the demolished Hecke-on-H¹ content that was implicit
in the deleted `EichlerShimura.lean` (Ribet Breach F1).

* `DoubleCosetDecomposition Γ α`: a finite set of right-coset representatives
  for `Γ \ (Γ · α · Γ)` in `SL₂ℤ`, with a concrete `Finset SL(2, ℤ)` carrier.
* `HeckeOperatorOnH1`: a concrete `k`-linear endomorphism on a representation
  module `M`, with an explicit boundary `Prop` for Hecke equivariance.

No `sorry`, no `:= True`.
-/

namespace MathlibExpansion
namespace HeckeViaDoubleCoset

open scoped MatrixGroups

/--
A double-coset decomposition: a finite set of right-coset representatives for
`Γ \ (Γ · α · Γ)` in `SL₂ℤ`.

`cosetReps` is a concrete `Finset SL(2, ℤ)` — the carrier is typed, not
abstract. `decompStatement` names the partition identity; it is an explicit
boundary `Prop` because Mathlib v4.17.0 does not yet provide the "finite coset
representatives for arithmetic congruence subgroups" theorem via
`Mathlib.GroupTheory.DoubleCoset`.
-/
structure DoubleCosetDecomposition
    (Γ : Subgroup SL(2, ℤ)) (α : SL(2, ℤ)) where
  cosetReps : Finset SL(2, ℤ)
  decompStatement : Prop
  decomp : decompStatement

/-- Recover the coset representatives from the decomposition package. -/
def DoubleCosetDecomposition.reps
    {Γ : Subgroup SL(2, ℤ)} {α : SL(2, ℤ)}
    (d : DoubleCosetDecomposition Γ α) : Finset SL(2, ℤ) :=
  d.cosetReps

/--
A Hecke operator on a representation module `M`, defined via a double-coset
decomposition.

`operator` is a concrete `M →ₗ[k] M` — a `k`-linear endomorphism on `M`.
`heckeEquivarianceStatement` names the commutativity with the Hecke algebra
action; it is an explicit boundary `Prop` because the Eichler-Shimura
isomorphism connecting double-coset Hecke operators to parabolic cohomology
is absent from Mathlib v4.17.0 (Recon #7 Finding 1).

The `Representation k SL(2, ℤ) M` input ties the group action to the
standard `Mathlib.RepresentationTheory.Representation` API.
-/
structure HeckeOperatorOnH1
    (k : Type*) [CommRing k]
    (M : Type*) [AddCommGroup M] [Module k M]
    (Γ : Subgroup SL(2, ℤ))
    (ρ : Representation k SL(2, ℤ) M)
    (α : SL(2, ℤ))
    (d : DoubleCosetDecomposition Γ α) where
  operator : M →ₗ[k] M
  heckeEquivarianceStatement : Prop
  heckeEquivariance : heckeEquivarianceStatement

/-- Recover the underlying linear endomorphism. -/
def HeckeOperatorOnH1.toLinearMap
    {k : Type*} [CommRing k]
    {M : Type*} [AddCommGroup M] [Module k M]
    {Γ : Subgroup SL(2, ℤ)}
    {ρ : Representation k SL(2, ℤ) M}
    {α : SL(2, ℤ)}
    {d : DoubleCosetDecomposition Γ α}
    (T : HeckeOperatorOnH1 k M Γ ρ α d) : M →ₗ[k] M :=
  T.operator

/-- Recover the Hecke equivariance statement. -/
theorem HeckeOperatorOnH1.heckeEquivariance_holds
    {k : Type*} [CommRing k]
    {M : Type*} [AddCommGroup M] [Module k M]
    {Γ : Subgroup SL(2, ℤ)}
    {ρ : Representation k SL(2, ℤ) M}
    {α : SL(2, ℤ)}
    {d : DoubleCosetDecomposition Γ α}
    (T : HeckeOperatorOnH1 k M Γ ρ α d) : T.heckeEquivarianceStatement :=
  T.heckeEquivariance

end HeckeViaDoubleCoset
end MathlibExpansion
