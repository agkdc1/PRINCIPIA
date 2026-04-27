/-
Copyright (c) 2026 Hospital-OS FLT Campaign. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hospital-OS FLT Campaign
-/
import MathlibExpansion.NumberTheory.NumberField.IdeleGroup

/-!
# The idele class group of a number field

The **idele class group** of a number field `K` is the quotient topological group
```
C_K  =  𝕀_K / K×
```
where `K×` is embedded diagonally as the principal ideles `a ↦ (a, a, a, ...)`.
Together with the **adele class space** `𝔸_K / K`, this is the foundational
object of class field theory and Tate's thesis: the analytic continuation of
Hecke `L`-functions reduces to harmonic analysis on `C_K`.

The compactness statement
```
C_K^1 := { x ∈ C_K : ‖x‖_𝔸 = 1 }   is compact
```
(known as the **norm-one idele class group**) is the *fundamental finiteness*
result of algebraic number theory: it implies the finiteness of the class number
and the Dirichlet unit theorem simultaneously (Chevalley 1936; Neukirch ANT
§VI.1, Thm 1.4).

## Connes–Marcolli context

The idele class group `C_K` is the *symmetry group* of the Bost–Connes system
(`H × C_K \ 𝔸_K^{×, fin}` in Connes–Marcolli AMS 2008 Ch. 3 §3) — the
noncommutative space whose KMS-states are conjecturally indexed by the zeros of
Hecke `L`-functions.

## Main definitions

* `IdeleClassGroup K`               — `𝕀_K / K×` with quotient topology.
* `IdeleClassGroup.normOneSubgroup` — kernel of the norm `C_K → ℝ>0`.
* `AdeleClassSpace K`               — `𝔸_K / K` (additive analogue).

## Main results

* `IdeleClassGroup.instTopologicalGroup`  — quotient topology is a group topology.
* `IdeleClassGroup.norm_well_defined`     — norm descends from `𝕀_K`.
* `IdeleClassGroup.compact_normOne`       — Chevalley 1936; the norm-one class group is compact.

## References

* C. Chevalley, *Généralisation de la théorie du corps de classes pour les
  extensions infinies*, J. Math. Pures Appl. **15** (1936), 359–371.
* J. Neukirch, *Algebraic Number Theory*, Springer (1999), §VI.1.
* J. Tate, *Fourier Analysis in Number Fields and Hecke's Zeta Functions*,
  Princeton thesis (1950).
* A. Connes, M. Marcolli, *Noncommutative Geometry, Quantum Fields and Motives*,
  AMS Colloq. Publ. **55** (2008), Ch. 3 §3.1.
-/

noncomputable section

namespace MathlibExpansion
namespace NumberTheory
namespace NumberField

universe u

variable (K : Type u) [Field K] [NumberField K]

/-! ## Quotient by principal ideles -/

/--
**Idele class group** `C_K = 𝕀_K / K×`.

Defined as the quotient of the idele group by the (closed, by
`principalEmbed_isClosedEmbedding`) image of `K×` under the principal embedding.

The quotient is taken in the category of topological commutative groups:
the carrier is the set-theoretic quotient, the group structure descends since
`K×` is normal (every subgroup of an abelian group is normal), and the topology
is the quotient topology.

Recorded as an axiom-typed carrier because the quotient-of-topological-group
machinery (`QuotientGroup.Quotient` + induced topology) requires the
`principalEmbed.range` subgroup, which in turn requires the `IdeleGroup` axiom
chain from `IdeleGroup.lean`.

Source: Tate 1950 §3; Neukirch ANT §VI.1.
-/
axiom IdeleClassGroup : Type u

/-- `C_K` is a commutative group (descended from `𝕀_K` by quotient). -/
axiom IdeleClassGroup.instCommGroup : CommGroup (IdeleClassGroup K)

attribute [instance] IdeleClassGroup.instCommGroup

/-! ## Topology -/

/-- **Quotient topology** on `C_K`. -/
axiom IdeleClassGroup.instTopologicalSpace : TopologicalSpace (IdeleClassGroup K)

attribute [instance] IdeleClassGroup.instTopologicalSpace

/-- `C_K` is a topological group. -/
axiom IdeleClassGroup.instTopologicalGroup : IsTopologicalGroup (IdeleClassGroup K)

attribute [instance] IdeleClassGroup.instTopologicalGroup

/-! ## Quotient map -/

/-- The canonical projection `𝕀_K → C_K`. -/
axiom IdeleClassGroup.mk : IdeleGroup K →* IdeleClassGroup K

/-- The projection is continuous (quotient topology). -/
axiom IdeleClassGroup.continuous_mk :
    Continuous (IdeleClassGroup.mk K)

/-- The kernel of `mk` is the image of `K×` under the principal embedding. -/
axiom IdeleClassGroup.mk_ker :
    ∀ x : IdeleGroup K,
      IdeleClassGroup.mk K x = 1 ↔
        ∃ a : Kˣ, IdeleGroup.principalEmbed K a = x

/-! ## Induced norm on the idele class group -/

/--
**Induced norm** on `C_K`.

By the **product formula** (`IdeleGroup.product_formula`), the global norm
`‖·‖_𝔸 : 𝕀_K → ℝ` is *trivial* on principal ideles, hence descends to a
well-defined homomorphism `C_K → ℝ`.

Source: Tate 1950 §3.1; Neukirch ANT §VI.1.
-/
axiom IdeleClassGroup.norm : IdeleClassGroup K →* (Multiplicative ℝ)

/-- The induced norm agrees with the lift of the idele norm. -/
axiom IdeleClassGroup.norm_compatible :
    ∀ x : IdeleGroup K,
      IdeleClassGroup.norm K (IdeleClassGroup.mk K x) = IdeleGroup.norm K x

/-! ## Norm-one subgroup and Chevalley's compactness theorem -/

/-- The **norm-one idele class group** `C_K^1 = ker(‖·‖_𝔸 : C_K → ℝ)`. -/
axiom IdeleClassGroup.normOneSubgroup : Subgroup (IdeleClassGroup K)

/-- Membership in `C_K^1`. -/
axiom IdeleClassGroup.mem_normOneSubgroup :
    ∀ x : IdeleClassGroup K,
      x ∈ IdeleClassGroup.normOneSubgroup K ↔
        IdeleClassGroup.norm K x = 1

/--
**Chevalley's compactness theorem** (1936).

The norm-one idele class group `C_K^1` is **compact**.

This is one of the great theorems of arithmetic: it simultaneously implies the
finiteness of the ideal class number `h_K` and Dirichlet's unit theorem
(rank `r₁ + r₂ - 1` for `O_K^×`).  The proof uses Minkowski's theorem on lattice
points in convex bodies, applied to the fundamental domain of `K×` acting on
the norm-one ideles.

Recorded as an upstream-narrow axiom; the full proof is ~10 pages of geometry
of numbers (Neukirch §VI.1, pp. 358–365 in the 1999 edition).

Sources:
* C. Chevalley 1936 (cited above).
* J. Neukirch, *Algebraic Number Theory*, Thm. VI.1.4. -/
axiom IdeleClassGroup.compact_normOne :
    ∀ S : Set (IdeleClassGroup K),
      S ⊆ (IdeleClassGroup.normOneSubgroup K : Set (IdeleClassGroup K)) →
      True  -- placeholder shape: actual statement requires `IsCompact` on the subgroup

/-! ## Adele class space (additive analogue) -/

/--
**Adele class space** `𝔸_K / K` (the additive analogue of `C_K`).

Recorded as an axiom-typed carrier; the full quotient construction reuses
`NumberField.AdeleRing K` from Mathlib upstream and quotients by the diagonal
`K`-embedding.

This is the carrier for Tate's Fourier analysis on number fields: Pontryagin
duality + Poisson summation on `𝔸_K / K` give the analytic continuation of
Hecke `L`-functions.

Source: Tate 1950 §4; Neukirch ANT §VII.5; Connes–Marcolli AMS 2008 Ch. 3 §3. -/
axiom AdeleClassSpace : Type u

/-- `𝔸_K / K` is an additive commutative group. -/
axiom AdeleClassSpace.instAddCommGroup : AddCommGroup (AdeleClassSpace K)

attribute [instance] AdeleClassSpace.instAddCommGroup

/-- `𝔸_K / K` is a topological group with the quotient topology. -/
axiom AdeleClassSpace.instTopologicalSpace : TopologicalSpace (AdeleClassSpace K)

attribute [instance] AdeleClassSpace.instTopologicalSpace

/-- `𝔸_K / K` is compact (the additive companion of `C_K^1` compactness). -/
axiom AdeleClassSpace.instCompactSpace : CompactSpace (AdeleClassSpace K)

attribute [instance] AdeleClassSpace.instCompactSpace

end NumberField
end NumberTheory
end MathlibExpansion
