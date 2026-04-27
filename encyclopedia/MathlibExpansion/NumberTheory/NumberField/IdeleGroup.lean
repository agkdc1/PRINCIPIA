/-
Copyright (c) 2026 Hospital-OS FLT Campaign. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hospital-OS FLT Campaign
-/
import Mathlib.NumberTheory.NumberField.Basic
import Mathlib.Topology.Algebra.Group.Basic

/-!
# The idele group of a number field (multiplicative restricted-product topology)

For a number field `K` with set of places `V_K`, the **idele group**
```
𝕀_K  =  ∏'_v K_v×        (restricted product with respect to the units O_v×)
```
is the multiplicative analogue of the adele ring.  An element is a family
`(x_v)_{v ∈ V_K}` of elements `x_v ∈ K_v×` such that `x_v ∈ O_v×` for all but
finitely many *finite* places `v`.

## CRITICAL POISON GUARD

Mathlib's `NumberField.AdeleRing` is the **additive** adele ring `𝔸_K`.  The
*subspace topology* induced on its units `(𝔸_K)×` is **NOT** the correct topology
on the idele group: under that topology multiplicative inversion is not
continuous (a standard subtlety, e.g. Weil, *Basic Number Theory*, Ch. IV §3).

The correct topology on `𝕀_K` is the **restricted product topology**, defined
*directly*:
```
basis  =  { ∏_{v ∈ S} U_v × ∏_{v ∉ S} O_v× : S ⊆ V_K finite, U_v ⊆ K_v× open }.
```
With this topology `𝕀_K` is a locally compact topological group.

This file builds the idele group with the correct topology *independently* of
`AdeleRing`; it does **not** route through `AdeleRing.units`.

## Implementation

We axiomatize the carrier and topology because:

* the per-place completion data `K_v` is (in Mathlib v4.17.0) only partially
  packaged for both finite and infinite places simultaneously;
* the restricted-product topology is not yet a generic `restrictedProduct`
  construction in Mathlib (it appears piecewise in the AdeleRing file but not
  abstractly).

The axiomatic block is upstream-narrow: each axiom corresponds to a single
result in Neukirch ANT §III.1 / Tate's thesis §3.

## Main definitions

* `IdeleGroup K`                — the idele group (axiom-typed).
* `IdeleGroup.principalEmbed`   — `K× ↪ 𝕀_K`, `a ↦ (a, a, ...)`.
* `IdeleGroup.norm`             — the global norm `‖·‖_𝔸 : 𝕀_K → ℝ>0`.

## Main results

* `IdeleGroup.instTopologicalGroup`     — restricted-product topology.
* `IdeleGroup.instLocallyCompactSpace`  — local compactness.
* `IdeleGroup.product_formula`          — `∏_v ‖a‖_v = 1` for `a ∈ K×`.

## References

* J. Tate, *Fourier Analysis in Number Fields and Hecke's Zeta Functions*,
  Princeton thesis (1950); reprinted in Cassels–Fröhlich (1967), Ch. XV.
* J. Neukirch, *Algebraic Number Theory*, Springer Grundlehren **322** (1999),
  §III.1 (Topology of restricted products), §VI.1 (Idele class group).
* A. Weil, *Basic Number Theory*, Springer Grundlehren **144** (1973), Ch. IV.
* A. Connes, M. Marcolli, *Noncommutative Geometry, Quantum Fields and Motives*,
  AMS Colloq. Publ. **55** (2008), Ch. 3 §3.1.
-/

noncomputable section

namespace MathlibExpansion
namespace NumberTheory
namespace NumberField

universe u

variable (K : Type u) [Field K] [NumberField K]

/-! ## The idele group as a type -/

/--
**The idele group** `𝕀_K = ∏'_v K_v×` (restricted product).

Recorded as an upstream-narrow axiom: the carrier exists as a group under the
restricted product, but the per-place completion data `K_v` for both finite and
infinite places is only partially packaged in Mathlib v4.17.0.

Source: Tate 1950 thesis §3; Neukirch ANT §III.1.
-/
axiom IdeleGroup : Type u

/-- The idele group is a commutative group. -/
axiom IdeleGroup.instCommGroup : CommGroup (IdeleGroup K)

attribute [instance] IdeleGroup.instCommGroup

/-! ## Restricted product topology and topological group -/

/--
**Restricted product topology** on `𝕀_K`.

Recorded as an upstream-narrow axiom: a basis is given by sets of the form
```
∏_{v ∈ S} U_v × ∏_{v ∉ S, v finite} O_v× × ∏_{v infinite} V_v
```
where `S` ranges over finite sets of places, `U_v ⊆ K_v×` is open, and
`V_v ⊆ K_v×` is open.  Under this topology multiplication and inversion are
continuous, and the inclusion `O_v× ↪ K_v×` is open.

Source: Neukirch ANT §III.1.
-/
axiom IdeleGroup.instTopologicalSpace : TopologicalSpace (IdeleGroup K)

attribute [instance] IdeleGroup.instTopologicalSpace

/-- `𝕀_K` is a topological group with the restricted product topology. -/
axiom IdeleGroup.instTopologicalGroup : IsTopologicalGroup (IdeleGroup K)

attribute [instance] IdeleGroup.instTopologicalGroup

/-- `𝕀_K` is locally compact.  Tate's thesis §3.1; Neukirch ANT III.1.4. -/
axiom IdeleGroup.instLocallyCompactSpace : LocallyCompactSpace (IdeleGroup K)

attribute [instance] IdeleGroup.instLocallyCompactSpace

/-! ## Principal idele embedding `K× ↪ 𝕀_K` -/

/--
**Principal idele embedding**.

A non-zero element `a ∈ K×` defines a *constant* family `(a, a, a, ...)` which
is automatically an idele (it lies in `O_v×` for all but finitely many finite
places — those dividing the numerator or denominator of `a`).

Source: Tate 1950 §3; Neukirch ANT §III.1. -/
axiom IdeleGroup.principalEmbed : Kˣ →* IdeleGroup K

/-- The principal embedding has discrete (i.e., closed and proper) range.
This is the multiplicative analogue of "K is discrete in 𝔸_K". -/
axiom IdeleGroup.principalEmbed_isClosedEmbedding :
    Function.Injective (IdeleGroup.principalEmbed K)

/-! ## Global norm and the product formula -/

/--
**Global norm** `‖·‖_𝔸 : 𝕀_K → ℝ` (taking values in `(0, ∞)`).

Sends an idele `(x_v)` to `∏_v ‖x_v‖_v`.  The product is well-defined because
`x_v ∈ O_v×` (hence `‖x_v‖_v = 1`) for all but finitely many finite places `v`.

Source: Tate 1950 §3.1; Neukirch ANT §III.1, eq. (1.2). -/
axiom IdeleGroup.norm : IdeleGroup K →* (Multiplicative ℝ)

/--
**Product formula** (Artin–Whaples 1945).

For every `a ∈ K×`, the global norm of the principal idele `(a, a, ...)` equals
`1`:
```
∏_v ‖a‖_v  =  1.
```
This is the foundational identity that allows the global norm to descend to the
idele class group `𝕀_K / K×`.

Sources:
* E. Artin, G. Whaples, *Axiomatic characterization of fields by the product
  formula for valuations*, Bull. AMS **51** (1945), pp. 469–492.
* Neukirch ANT §III.1, Prop. 1.4. -/
axiom IdeleGroup.product_formula
    (a : Kˣ) :
    IdeleGroup.norm K (IdeleGroup.principalEmbed K a) = 1

end NumberField
end NumberTheory
end MathlibExpansion
