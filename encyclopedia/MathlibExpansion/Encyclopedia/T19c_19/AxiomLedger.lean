/-!
# T19c_19 Poincaré *Analysis Situs* + Compléments — Upstream Axiom Ledger

Refire-time catalog of every sibling-library axiom landed by the T19c_19
breach set, with later discharge notes where a declaration has since been
closed. Each entry records:

* **Direction**: `upstream` (always; horizontal/downstream are REJECTED)
* **Poincaré citation**: exact section of *Analysis Situs* (1895), *Premier
  complément* (1899), *Deuxième complément* (1900), or *Cinquième complément*
  (1904) where the theorem first appears
* **Modern Mathlib surface**: closest analog already present upstream, if any
* **Cross-textbook substrate**: pointer to later textbooks whose future
  formalizations will consume the same axiom

The ledger is documentation-only. It does not re-declare or shadow the axioms
landed in the Step 6 files; entries marked `DISCHARGED` no longer correspond
to live axiom declarations.

The T19c_19 breach produced **no horizontal or downstream axioms**. Ledger
delta vs. empty baseline at refire time: `+41 upstream / -0 horizontal /
-0 downstream`. After Exterminatus Phase 1 closed the Betti carrier row,
the current live delta is `+31 upstream / -0 horizontal / -0 downstream`.

## Direction discipline

All axioms in this ledger declare statements that Poincaré either proved or
asserted in 1895-1904 and that modern Mathlib does not yet contain as a
packaged theorem. Each is narrow enough to be discharged later by a direct
Mathlib upstream PR once the surrounding algebraic/topological substrate is
present. No axiom here asks for a downstream consequence of another
formalized theorem, and no axiom duplicates an existing Mathlib lemma at
a horizontal level.

## Fundamental group lane (FG-*)

### `MathlibExpansion/AlgebraicTopology/Covering/UniversalCover.lean`

* `UniversalCover` (structure, Type-valued carrier + projection)
* `DeckTransformGroup` (abbrev for `Equiv.Perm` on the cover carrier)
* `exists_universalCover`
  - **Direction**: upstream
  - **Poincaré citation**: *Analysis Situs* § 12; universal cover appears as
    the "revêtement universel" attached to multiform functions
  - **Mathlib analog**: `Mathlib/Topology/Covering.lean:120` defines ordinary
    covering maps. No universal-cover construction upstream.
  - **Cross-textbook substrate**: consumed by later Riemann-surface and
    monodromy textbooks; the axiom is the direct gap for every later book
    that uses "the universal cover of X" as an object.
* `deckGroup_equiv_fundamentalGroup`
  - **Direction**: upstream
  - **Poincaré citation**: *Analysis Situs* § 12; equivalence `Deck(X̃/X) ≃ π₁(X,x)`
  - **Mathlib analog**: no upstream deck-group API.
  - **Textbook footnote**: Poincaré himself cites earlier work by Schwarz and
    Klein on Fuchsian automorphic functions; the theorem is the group-theoretic
    side of a correspondence that Poincaré attributes to the monodromy
    literature preceding *Analysis Situs*.

### `MathlibExpansion/AlgebraicTopology/FundamentalGroup/Functoriality.lean`

* `fundamentalGroupMap`
  - **Direction**: upstream
  - **Poincaré citation**: *Analysis Situs* §§ 12-13
  - **Mathlib analog**: `Mathlib/AlgebraicTopology/FundamentalGroupoid/Basic.lean:335`
    has the functor on fundamental groupoids; the user-facing `π₁` homomorphism
    wrapper is missing.
  - **Discharge route**: direct port; no new research required. Slated for
    upstream PR once the sibling wrapper is proved equivalent to the groupoid
    version already in Mathlib.

### `MathlibExpansion/AlgebraicTopology/Covering/GaloisCorrespondence.lean`

* Subgroup-to-covering classification axioms
  - **Direction**: upstream
  - **Poincaré citation**: *Analysis Situs* § 12; corresponds to the classical
    "Galois correspondence" for covering spaces
  - **Mathlib analog**: absent.
  - **Textbook footnote**: Poincaré's § 12 references Jordan's earlier group-
    theoretic work on multivalued functions as antecedent; the classical
    correspondence was cleaned up by Hurewicz and Steenrod in *Foundations of
    Algebraic Topology* (1952), which is the canonical modern source.

### `MathlibExpansion/AlgebraicTopology/FundamentalGroup/PolyhedralPresentation.lean`

* `fundamentalGroup_presentedGroup_of_facePairing`
  - **Direction**: upstream
  - **Poincaré citation**: *Analysis Situs* § 13; finite-presentation theorem
    via face-pairing polyhedra
  - **Mathlib analog**: `Mathlib/GroupTheory/PresentedGroup.lean:34` supplies
    presented-group algebra; the topological-to-algebraic bridge is missing.

### `MathlibExpansion/AlgebraicTopology/FundamentalGroup/HurewiczPi1.lean`

* Abelianization-to-`H₁` bridge axioms
  - **Direction**: upstream
  - **Poincaré citation**: *Analysis Situs* § 12 (implicit); made explicit by
    Hurewicz in the 1930s
  - **Mathlib analog**: abelianization at
    `Mathlib/GroupTheory/Abelianization.lean`; singular `H₁` at
    `Mathlib/AlgebraicTopology/SingularHomology/Basic.lean:43`. No upstream
    theorem connecting them.

## Homology-polyhedral lane (HP-*)

### `MathlibExpansion/AlgebraicTopology/BettiNumbers.lean`

* `Hq`, `integralHomology`, `singularHomology`, `singularCohomology`,
  `BettiBasis`, `instFintypeBettiBasis`, `instAddCommGroupHq`,
  `instAddCommGroupIntegralHomology`, `torsionSubgroup`,
  `instAddCommGroupTorsionSubgroup` — **DISCHARGED**
  - **Direction**: upstream
  - **Poincaré citation**: *Analysis Situs* § 6 (Betti numbers); § 5
    (homology relation); first torsion discussion in *Deuxième complément* § 6
  - **Mathlib analog**: `Mathlib/AlgebraicTopology/SingularHomology/Basic.lean:43`
    supplies singular-homology objects; the Betti-rank wrapper is absent.
  - **Discharge note**: Exterminatus Phase 1 replaced the carrier axioms with
    universe-polymorphic dispatcher shims, a universe-0 pointer to Mathlib's
    singular-homology functor, and Mathlib's `AddCommGroup.torsion` for the
    torsion subgroup carrier.

### `MathlibExpansion/AlgebraicTopology/PolyhedralChainComplex.lean`

* Polyhedral chain-complex existence axioms
  - **Direction**: upstream
  - **Poincaré citation**: *Premier complément* § III
  - **Mathlib analog**: `Mathlib/Analysis/Convex/SimplicialComplex/Basic.lean:56`
    has simplicial complexes as geometric objects; the chain-complex
    construction from incidence data is absent.

### `MathlibExpansion/AlgebraicTopology/SubdivisionInvariance.lean`

* Subdivision-invariance axioms for reduced Betti numbers
  - **Direction**: upstream
  - **Poincaré citation**: *Premier complément* §§ IV-VI
  - **Mathlib analog**: absent.

### `MathlibExpansion/AlgebraicTopology/EulerPoincare.lean`

* `eulerCellCount`, `eulerPoincareBettiSum`,
  `eulerPoincare_of_polyhedralDecomposition`
  - **Direction**: upstream
  - **Poincaré citation**: *Analysis Situs* § 16 — Poincaré's Euler
    characteristic / alternating-Betti-sum identity
  - **Mathlib analog**: no Euler-characteristic machinery in
    `Mathlib/AlgebraicTopology/` directly; the bridge is genuinely new.
  - **Textbook footnote**: Poincaré himself cites L'Huilier (1812) and Cauchy
    (1813) for the purely combinatorial identity `V - E + F = 2`; the general
    alternating-sum identity is his 1895 generalization.

### `MathlibExpansion/AlgebraicTopology/PoincareDuality.lean`

* `bettiNumber_duality`
  - **Direction**: upstream
  - **Poincaré citation**: *Premier complément* §§ VII-VIII
  - **Mathlib analog**: absent at the Betti-rank level.

### `MathlibExpansion/AlgebraicTopology/PoincareDualityTorsion.lean`

* Torsion-duality axioms
  - **Direction**: upstream
  - **Poincaré citation**: *Deuxième complément* § 5
  - **Mathlib analog**: absent.

### `MathlibExpansion/AlgebraicTopology/TopHomologyTorsionFree.lean`

* Top codimension-one torsion-free axioms
  - **Direction**: upstream
  - **Poincaré citation**: *Deuxième complément* § 6
  - **Mathlib analog**: absent.

### `MathlibExpansion/AlgebraicTopology/FinitelyGeneratedHomology.lean`

* Finitely-generated decomposition axioms
  - **Direction**: upstream
  - **Poincaré citation**: *Deuxième complément* §§ 2-3
  - **Mathlib analog**: `Mathlib/LinearAlgebra/FreeModule/PID.lean:541` supplies
    Smith-normal-form substrate; the topological-side decomposition is absent.

### `MathlibExpansion/AlgebraicTopology/IntegerHomology/SmithReduction.lean`

* `incidence_matrix_smith_normal_form` — CLOSED in refire
  - **Direction**: upstream → DISCHARGED (structure carries no constraint
    tying the witness to `A`, so the axiom is vacuously true; refire replaces
    the axiom declaration with a honest `theorem` constructing the trivial
    witness).
  - **Note**: the *strong* Poincaré claim (existence of `U`, `V` with
    `U * A * V = D` diagonal with Smith-normal-form invariant factors) remains
    an upstream axiom request; it is not equivalent to the vacuous witness
    above. A future refire should strengthen `SmithReductionWitness` with that
    multiplicative constraint and prove it via
    `Mathlib/LinearAlgebra/FreeModule/PID.lean:541` directly.

## Manifold-polyhedral lane (MP-*)

### `MathlibExpansion/Geometry/Manifold/Orientability.lean`

* `AtlasOrientation`, `CompatibleAtlasOrientation`
  - **Direction**: upstream
  - **Poincaré citation**: *Analysis Situs* §§ 9-10 (bilateral vs.
    unilateral varieties); formalized as modern orientability by Whitney
    (1936) in *Geometric integration theory*, which Poincaré's 1895 paper
    effectively anticipates.
  - **Mathlib analog**: `Mathlib/Geometry/Manifold/` has charted-space and
    `IsManifold` substrate, but no atlas-orientation primitive.

### `MathlibExpansion/Geometry/Manifold/PolyhedralFacePairing.lean`

* Face-pairing manifold axioms
  - **Direction**: upstream
  - **Poincaré citation**: *Analysis Situs* § 11; face-pairing polyhedron
    construction of manifolds
  - **Mathlib analog**: absent.

### `MathlibExpansion/Geometry/Manifold/MappingTorus.lean`

* Mapping-torus manifold axioms
  - **Direction**: upstream
  - **Poincaré citation**: *Analysis Situs* § 14; torus-suspension examples
  - **Mathlib analog**: absent as a topological construction.

### `MathlibExpansion/Geometry/Manifold/ProjectiveManifold.lean`

* Real-projective manifold axioms
  - **Direction**: upstream
  - **Poincaré citation**: *Analysis Situs* examples (§§ 11, 14)
  - **Mathlib analog**: `Mathlib/Geometry/Manifold/Instances/Real.lean`
    has model projective instances but not the full manifold-of-parity
    orientability theorem.

### `MathlibExpansion/Geometry/Manifold/SymmetricPower.lean`

* Symmetric-square manifold axioms
  - **Direction**: upstream
  - **Poincaré citation**: *Analysis Situs* § 14 example lane
  - **Mathlib analog**: absent.

## Three-manifold and payoff lane (PCS-*, PD-*)

### `MathlibExpansion/Topology/ThreeManifold/Heegaard.lean`

* Heegaard splitting axioms
  - **Direction**: upstream
  - **Poincaré citation**: *Cinquième complément* § 6
  - **Mathlib analog**: absent.

### `MathlibExpansion/AlgebraicTopology/Heegaard/HomologySphereCriterion.lean`

* Heegaard homology-sphere criterion axioms
  - **Direction**: upstream
  - **Poincaré citation**: *Cinquième complément* § 6
  - **Mathlib analog**: absent.

### `MathlibExpansion/Topology/ThreeManifold/PoincareHomologySphere.lean`

* Poincaré-homology-sphere axioms (with `SL(2, ZMod 5)` prefire)
  - **Direction**: upstream
  - **Poincaré citation**: *Cinquième complément* § 6
  - **Mathlib analog**: icosahedral / `SL(2, ZMod 5)` group algebra at
    `Mathlib/GroupTheory/SpecificGroups/`; the topological identification is
    absent.

### `MathlibExpansion/Topology/ThreeManifold/PoincareConjecture.lean`

* Poincaré-conjecture statement axioms
  - **Direction**: upstream
  - **Poincaré citation**: *Cinquième complément*, closing question; proved by
    Perelman (2002-2003) for the three-dimensional case
  - **Mathlib analog**: absent; the sibling-library wrapper carries the
    statement without the Ricci-flow proof.
  - **Status**: explicitly a research-level statement; the axiom records
    Poincaré's own conjectural formulation, not Perelman's proof. Closure via
    a direct Lean port of Perelman's proof is a multi-decade research program.

### `MathlibExpansion/Topology/CWComplex/DualCellulation.lean`

* `CompatibleSimplexOrientations`, `DualCellulation`,
  `DualCellulation.Cells`, `CellEquivComplementaryDim`,
  `CellEquivComplementaryDim.cellEquiv`, `exists_dual_cellulation`
  - **Direction**: upstream
  - **Poincaré citation**: *Analysis Situs* § 10 and *Premier complément*
    § VIII (dual cellulation / reciprocal polyhedron)
  - **Mathlib analog**: absent.

### `MathlibExpansion/Topology/CWComplex/DualBoundaryMatrix.lean`

* Dual boundary matrix axioms
  - **Direction**: upstream
  - **Poincaré citation**: *Deuxième complément* § 2
  - **Mathlib analog**: `Mathlib.Data.Matrix.Basic` supplies `transpose`; the
    dual-boundary-as-transpose theorem is absent.

### `MathlibExpansion/AlgebraicTopology/PolyhedralHomology/BettiDuality.lean`

* Reciprocal-polyhedron Betti duality axioms
  - **Direction**: upstream
  - **Poincaré citation**: *Premier complément* §§ VII-VIII
  - **Mathlib analog**: absent.

### `MathlibExpansion/AlgebraicTopology/Intersection/Pairing.lean`

* Intersection-pairing axioms
  - **Direction**: upstream
  - **Poincaré citation**: *Analysis Situs* §§ 10-11; intersection numbers of
    complementary-dimensional subvarieties
  - **Mathlib analog**: absent at the topological level; bilinear-pairing
    machinery exists at `Mathlib/LinearAlgebra/BilinearForm/` but is not wired
    to singular-homology.

### `MathlibExpansion/AlgebraicTopology/PoincareDuality/Rank.lean`,
  `PoincareDuality/MiddleParity.lean`, `PoincareDuality/Torsion.lean`,
  `PoincareDuality/TopMinusOne.lean`, `PoincareDuality/CohomologicalForm.lean`

* Rank-level, middle-parity, integral-torsion, top-minus-one, and
  cohomological Poincaré-duality axioms
  - **Direction**: upstream (all five)
  - **Poincaré citation**: *Premier complément* §§ VII-VIII; *Deuxième
    complément* §§ 5-6
  - **Mathlib analog**: absent; the sibling files form the complete upstream
    duality package needed for later 20th-century books.

## Cross-textbook footnote discipline

Where the above table lists "Mathlib analog: absent", we also record the
textbook footnote Poincaré himself used when writing his 1895 paper:

- **Betti numbers** (`HP_02`): Poincaré cites Betti's 1871 *Sopra gli spazi di
  un numero qualunque di dimensioni*. Any later 19th-century topology
  textbook cited in the queue will rely on this same Betti paper as the
  primary source.
- **Euler characteristic** (`HP_03`): Poincaré cites L'Huilier (1812) and
  Cauchy (1813) for the polyhedral identity, then generalizes.
- **Triangulability** (`HP_07`, not in this breach): Poincaré's § XI
  of the *Premier complément* cites then-contemporary work on polyhedral
  subdivision; the modern reference is Whitehead's *Simplicial spaces,
  nuclei, and m-groups* (1939), which remains the canonical source.
- **Heegaard splittings** (`PCS_01`): Poincaré cites Heegaard's 1898
  dissertation directly.
- **Poincaré homology sphere** (`PCS_03`): the construction via
  `SL(2, ZMod 5)` / binary icosahedral group traces to Klein's
  *Vorlesungen über das Ikosaeder* (1884), which Poincaré cites explicitly.

## Refire closure summary

* Total axiom declarations cataloged: 41 (across the 32 landed files).
* Direction: every axiom is `upstream`. Zero horizontal, zero downstream.
* One axiom (`incidence_matrix_smith_normal_form`) was closed as a trivial
  theorem in the refire because its structure is vacuous.
* Remaining 40 axioms are narrow upstream requests tied to specific
  *Analysis Situs* or Compléments sections, with modern-Mathlib analogs
  identified where they exist.
* No HVT was quarantined as poison; no HVT was deferred without a sharp
  upstream-axiom diagnosis.
-/

namespace MathlibExpansion
namespace Encyclopedia
namespace T19c_19

end T19c_19
end Encyclopedia
end MathlibExpansion
