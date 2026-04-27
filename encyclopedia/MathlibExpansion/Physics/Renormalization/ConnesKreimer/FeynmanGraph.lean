/-
Copyright (c) 2026 Hospital-OS FLT Campaign. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hospital-OS FLT Campaign
-/
import Mathlib.Data.Finset.Basic
import Mathlib.Data.Fintype.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

/-!
# Feynman graphs (Connes–Kreimer renormalization substrate)

A **Feynman graph** is the combinatorial datum carrying a perturbative-QFT amplitude.
Concretely it consists of a finite set of vertices and a finite set of *half-edges*
(also called "stubs"), each half-edge attached to exactly one vertex.  An *internal*
edge of the graph is an unordered pair of half-edges glued to one another; the
unmatched half-edges are the *external legs* (incoming or outgoing particles).

This file packages the *combinatorial* substrate used by `HopfAlgebra.lean` to define
the Connes–Kreimer Hopf algebra of 1PI graphs.  We deliberately keep the residue
type abstract (it is the particle-type label) so the Hopf algebra construction is
universal in the choice of QFT.

## Poison guard

* `Mathlib.Combinatorics.SimpleGraph` is **not** a Feynman graph.  Simple graphs do
  not carry half-edges (they cannot encode tadpoles or self-loops with non-trivial
  combinatorial weight) and have no residue/particle labels.  Build `FeynmanGraph`
  as a fresh structure.

## Main definitions

* `FeynmanGraph (R : Type*)` — finite Feynman graph with residue labels in `R`.
* `FeynmanGraph.numLoops`         — first Betti number `L = I - V + 1`.
* `FeynmanGraph.externalLegs`     — finset of unpaired half-edges.
* `FeynmanGraph.internalEdges`    — finset of paired half-edge pairs.
* `FeynmanGraph.isOnePI`          — predicate: the graph is 1-particle-irreducible.
* `superficialDegree φ⁴`          — `4 - E` superficial divergence in scalar `φ⁴`.
* `IsAdmissibleSubgraph γ Γ`      — `γ` is an admissible subgraph of `Γ`.
* `contractSubgraph Γ γ`          — `Γ/γ` (contract `γ` to a single vertex).

## References

* D. Kreimer, *On the Hopf algebra structure of perturbative quantum field theories*,
  Adv. Theor. Math. Phys. **2** (1998), 303–334.
* A. Connes, D. Kreimer, *Renormalization in quantum field theory and the
  Riemann–Hilbert problem I,II*, Commun. Math. Phys. **210** (2000), 249–273
  and **216** (2001), 215–241.
* A. Connes, M. Marcolli, *Noncommutative Geometry, Quantum Fields and Motives*,
  AMS Colloquium Publications **55** (2008), Chapter 1.
-/

noncomputable section

open Finset

namespace MathlibExpansion
namespace Physics
namespace Renormalization
namespace ConnesKreimer

universe u

/-- A **Feynman graph** with residue labels in `R`.

`vertices` is the finite set of interaction points.  `halfEdges` is the finite set
of half-edges (stubs).  Each half-edge is *attached* to a vertex via `attach`.
The `pairing` is a partial involution on `halfEdges`: paired half-edges form
internal edges; unpaired half-edges are external legs.  `residue` labels each
half-edge with a particle/residue type drawn from `R` — this records the type
of line entering/leaving the graph at that half-edge. -/
structure FeynmanGraph (R : Type u) where
  vertices       : Finset ℕ
  halfEdges      : Finset ℕ
  attachment     : ℕ → ℕ
  pairing        : ℕ → Option ℕ
  residue        : ℕ → R
  attachment_mem : ∀ h ∈ halfEdges, attachment h ∈ vertices
  pair_dom       : ∀ h ∈ halfEdges, ∀ h' ∈ pairing h, h' ∈ halfEdges
  pair_invol     : ∀ h ∈ halfEdges, ∀ h' ∈ pairing h, pairing h' = some h
  pair_ne        : ∀ h ∈ halfEdges, ∀ h' ∈ pairing h, h ≠ h'

namespace FeynmanGraph

variable {R : Type u} (Γ : FeynmanGraph R)

/-- The set of **external legs**: unpaired half-edges. -/
def externalLegs : Finset ℕ :=
  Γ.halfEdges.filter (fun h => Γ.pairing h = none)

/-- The set of **internal edges**, encoded as unordered pairs of half-edges.
We pick the canonical representative `min h h'`. -/
def internalEdgePairs : Finset (ℕ × ℕ) :=
  (Γ.halfEdges.product Γ.halfEdges).filter
    (fun p => Γ.pairing p.1 = some p.2 ∧ p.1 < p.2)

/-- Number of internal edges. -/
def numInternalEdges : ℕ := Γ.internalEdgePairs.card

/-- Number of vertices. -/
def numVertices : ℕ := Γ.vertices.card

/-- **First Betti number** (loop number): `L = I - V + 1` for connected graphs.
We use truncated subtraction; for disconnected graphs the formula gives a lower
bound on the loop number which suffices for residue accounting. -/
def numLoops : ℕ := Γ.numInternalEdges + 1 - Γ.numVertices

/-- The empty Feynman graph (no vertices, no half-edges).

We require `[Nonempty R]` only to supply a vacuous default residue value;
the function is never called on a valid input since `halfEdges = ∅`. -/
def empty (R : Type u) [Nonempty R] : FeynmanGraph R where
  vertices       := ∅
  halfEdges      := ∅
  attachment     := fun _ => 0
  pairing        := fun _ => none
  residue        := fun _ => Classical.arbitrary R  -- vacuous: halfEdges = ∅
  attachment_mem := by intro h hh; simp at hh
  pair_dom       := by intro h hh; simp at hh
  pair_invol     := by intro h hh; simp at hh
  pair_ne        := by intro h hh; simp at hh

/-! ## Connectedness and 1PI -/

/--
**1-particle-irreducible** (1PI): a connected graph that remains connected after
removing any *single* internal edge.  This is the combinatorial-topology condition
that singles out the generators of the Connes–Kreimer Hopf algebra.

The full predicate requires a connectivity primitive on the graph; we record it
here as an axiom-shaped statement on `FeynmanGraph`.  The graph-theoretic version
(in `Mathlib.Combinatorics.SimpleGraph.Connectivity`) does not transfer because
half-edge graphs require a different connectivity definition.

Source: Connes–Kreimer 2000, §1.
-/
axiom isOnePI : ∀ {R : Type u}, FeynmanGraph R → Prop

/-! ## Superficial divergence (scalar φ⁴ as the canonical example) -/

/-- **Superficial degree of divergence** for scalar `φ⁴` in 4 dimensions.
Power-counting: `ω(Γ) = 4 - E(Γ)` where `E(Γ)` is the number of external legs.
Negative values indicate (super-)convergent integrals.

Named per the Commander's plan: `superficialDivergenceOf Γ` is the canonical name. -/
def superficialDivergenceOf : ℤ :=
  4 - (Γ.externalLegs.card : ℤ)

/-- Legacy alias for `superficialDivergenceOf` (preserves any earlier callers). -/
@[deprecated superficialDivergenceOf (since := "2026-04-25")]
def superficialDegreePhi4 : ℤ := Γ.superficialDivergenceOf

/-! ## Admissible subgraphs and contraction -/

/--
**Admissible subgraph**.

`γ` is an *admissible* subgraph of `Γ` when:
* every vertex of `γ` is a vertex of `Γ`;
* every half-edge of `γ` is a half-edge of `Γ` (with the same residue and attachment);
* `γ` is non-empty;
* `γ` is a *disjoint union of 1PI components* whose residues match vertex types of `Γ`
  (so contracting `γ` produces a graph whose vertices are still well-typed in the
  underlying QFT).

This is the predicate appearing in the Connes–Kreimer coproduct.  The full predicate
involves the residue-matching condition for renormalization and is recorded here
as an axiom-shaped statement until the residue type system is concretized.

Source: Connes–Kreimer 2000, Def. 2.1; Connes–Marcolli AMS 2008, Ch. 1 §3.
-/
axiom isAdmissible :
  ∀ {R : Type u}, FeynmanGraph R → FeynmanGraph R → Prop

/-- Legacy alias for `isAdmissible` (preserves any earlier callers). -/
@[deprecated isAdmissible (since := "2026-04-25")]
abbrev IsAdmissibleSubgraph {R : Type u} (γ Γ : FeynmanGraph R) : Prop :=
  isAdmissible γ Γ

/--
**Contraction**.

`Γ.contract γ = Γ/γ` is the Feynman graph obtained from `Γ` by replacing the
admissible subgraph `γ` with a single vertex carrying the residue type of `γ`.
The half-edges of `γ` external to `γ` become half-edges of `Γ/γ` attached to the
new vertex.

Construction (sketch, recorded as axiom-shaped existence statement):
* new vertex set = `(Γ.vertices \ γ.vertices) ∪ {*}`
* new half-edges = half-edges of `Γ` not in `γ.halfEdges \ γ.externalLegs`
* the half-edges that *were* external legs of `γ` are now attached to the new vertex `*`
* pairing and residue inherited from `Γ`

The combinatorial verification of the structure-field axioms is straightforward
but lengthy; recorded as an axiom-shaped existence statement until the supporting
finset lemmas are assembled.

Source: Connes–Kreimer 2000, §2; Connes–Marcolli AMS 2008, Ch. 1 §3.2.
-/
axiom contractSubgraph :
  ∀ {R : Type u} (Γ γ : FeynmanGraph R), IsAdmissibleSubgraph γ Γ → FeynmanGraph R

/--
**Forests of admissible subgraphs** (Zimmermann's forest formula substrate).

The Connes–Kreimer coproduct sums over disjoint unions of admissible subgraphs;
classically these are called *forests*.  We axiomatize the existence of the finset
of forests of `Γ` (each forest a finset of admissible 1PI subgraphs that are
pairwise disjoint).

Source: Zimmermann 1969 (forest formula); Kreimer 1998 §3.
-/
axiom forestsOf : ∀ {R : Type u}, FeynmanGraph R → Finset (Finset (FeynmanGraph R))

end FeynmanGraph

end ConnesKreimer
end Renormalization
end Physics
end MathlibExpansion
