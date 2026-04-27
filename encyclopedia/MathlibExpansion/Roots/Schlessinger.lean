import MathlibExpansion.Roots.Schlessinger.ArtinLocal
import MathlibExpansion.Roots.Schlessinger.SmallExtensions
import MathlibExpansion.Roots.Schlessinger.DualNumbers
import MathlibExpansion.Roots.Schlessinger.DeformationFunctor
import MathlibExpansion.Roots.Schlessinger.TangentFunctor
import MathlibExpansion.Roots.Schlessinger.ProRep
import MathlibExpansion.Roots.Schlessinger.ArtinLocalOver
import MathlibExpansion.Roots.Schlessinger.DualNumberArtinian
import MathlibExpansion.Roots.Schlessinger.DeformationFunctorOver
import MathlibExpansion.Roots.Schlessinger.ProRepOver

/-!
# Schlessinger Deformation Theory — Aggregator

Re-exports the Schlessinger breach as a single import point for downstream
FLT work (Mazur deformation theory, Wiles R=T).

## Files

### k-parallel substrate (original R9 breach)
1. `ArtinLocal`         — `ArtinLocalAlg k`, category Art_k, `residueFieldObject`
2. `SmallExtensions`    — `SmallExtension`, `IsSurjectionInArt`, `artinKer`
3. `DualNumbers`        — `dualNumberObj k`, `dualNumberResidueEquiv`
4. `DeformationFunctor` — `DeformationFunctor`, `ArtinPullback`, H1, H2, H2', H3, H4
5. `TangentFunctor`     — `tangentSpace`, `H3Finite`
6. `ProRep`             — `CompleteLocalNoetherianAlg`, `HomFunctor`,
                          `ProRepresentedBy`, `IsProRepresentable`,
                          `schlessinger_prorepresentable` (theorem)

### Λ-parallel substrate (Mazur1989 opus-Delta breach, 2026-04-21)
7.  `ArtinLocalOver`          — `ArtinLocalAlgOver Λ k`, category Art_Λ (residue k)
8.  `DualNumberArtinian`      — `Module.Finite k (DualNumber k)`, `IsArtinianRing (DualNumber k)`
9.  `DeformationFunctorOver`  — `DeformationFunctorOver`, `ArtinPullbackOver`,
                                `H1Over`, `H2Over`, `H3Over`, `H4Over` (typed predicates)
10. `ProRepOver`              — `CompleteLocalNoetherianAlgOver`, `HomFunctorOver`,
                                `ProRepresentedByOver`, `IsProRepresentableOver`,
                                `schlessinger_prorepresentable_over_residue` (theorem)

## Axiom inventory

- `schlessinger_prorepresentable`              : theorem routed through Mazur / Chapter 3.
- `hull_construction`                          : Chapter 3 boundary axiom behind the Λ-surface theorem.
-/
