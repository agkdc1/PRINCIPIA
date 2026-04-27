import MathlibExpansion.Roots.BCDT2001.CompleteLocalOAlg
import MathlibExpansion.Roots.Diamond1996.AlgebraicCriterion

/-!
# BCDT 2001 — Bucket 4: Fitting + length + congruence numerics (consumer)

Thin re-export layer that consumes the `FittingLengthAPI` substrate landed
by the Diamond 1996 breach (`Roots/Diamond1996/AlgebraicCriterion.lean`).

**Axiom 2 reclamation.** The fixed Axiom-2 slot — Diamond's numerical /
Fitting-ideal API — is **reclaimed** at BCDT level: BCDT does not declare
a new numerics axiom, it consumes Diamond's definition-land
`fittingLengthAPI_ofFiniteLength` constructor and the theorem-land
Diamond criterion whose kernel-side comparison data is now explicit caller
input packaged by `cotangentComparisonBridge`.

**T0/T1 classification.** Every exported primitive is T0 (data) or
T1-caller-data (predicate on caller-supplied data). No T2/T3 poison.
-/

namespace MathlibExpansion.Roots.BCDT2001

universe u

open MathlibExpansion.Roots.Diamond1996

/-! ## Re-exports of Diamond substrate (no new axioms) -/

/-- BCDT-facing alias of Diamond's `FittingLengthAPI`. The cotangent/
congruence carriers are supplied by the caller (typically the `OAlg`
cotangent and a BCDT-specific congruence module). T0. -/
abbrev NumericsAPI (O : Type u) [CommRing O]
    (Φ : Type u) [AddCommGroup Φ] [Module O Φ]
    (ψ : Type u) [AddCommGroup ψ] [Module O ψ] : Type u :=
  FittingLengthAPI O Φ ψ

/-- BCDT-facing alias of Diamond's `HeckeProjection`. T0 (data). -/
abbrev BCDTHeckeProjection (T O : Type u) [CommRing T] [CommRing O] : Type u :=
  HeckeProjection T O

/-- BCDT-facing alias of Diamond's `ComparisonMap`. T0 (data, with
surjectivity obligation). -/
abbrev BCDTComparisonMap
    (O R T : Type u) [CommRing O] [CommRing R] [CommRing T]
    [Algebra O R] [Algebra O T] : Type u :=
  ComparisonMap O R T

/-- BCDT-facing alias of Diamond's typed criterion-data bundle. T0. -/
abbrev BCDTCriterionData
    (Λ k O R T : Type u)
    [CommRing Λ] [Field k] [CommRing O] [CommRing R] [CommRing T]
    [Algebra Λ O] [Algebra O R] [Algebra O T] : Type (u+1) :=
  AlgebraicCriterionData Λ k O R T

/-! ## Diamond numerics bridge — re-exposed, not re-declared -/

/-- **Diamond boundary constructor (re-export).** Given finite-length
cotangent and congruence modules, produce the typed Fitting/length API.
This is definition-land data packaged by Diamond's
`fittingLengthAPI_ofFiniteLength`. -/
def numericsAPI_ofFiniteLength
    {O : Type u} [CommRing O]
    {Φ : Type u} [AddCommGroup Φ] [Module O Φ]
    {ψ : Type u} [AddCommGroup ψ] [Module O ψ]
    (hΦ : IsFiniteLength O Φ) (hψ : IsFiniteLength O ψ) :
    NumericsAPI O Φ ψ :=
  fittingLengthAPI_ofFiniteLength hΦ hψ

/-- **Diamond's algebraic criterion (re-export).** Fitting equality on the
cotangent/congruence pair forces bijectivity of the comparison map.
No transitive Diamond axiom remains here: `cotangentComparisonBridge` is now a
definition packaging caller data. -/
theorem numericalCriterion_forcesBijection
    {Λ k O R T : Type u}
    [CommRing Λ] [Field k] [CommRing O] [CommRing R] [CommRing T]
    [Algebra Λ O] [Algebra O R] [Algebra O T]
    (D : BCDTCriterionData Λ k O R T)
    (h : D.api.fittingΦ = D.api.fittingψ) :
    Function.Bijective D.comparison.toAlgHom :=
  algebraicCriterion_RT D h

/-- **Surjectivity half.** Already typed into `ComparisonMap.surjective`. -/
theorem numericalCriterion_surjective
    {Λ k O R T : Type u}
    [CommRing Λ] [Field k] [CommRing O] [CommRing R] [CommRing T]
    [Algebra Λ O] [Algebra O R] [Algebra O T]
    (D : BCDTCriterionData Λ k O R T) :
    Function.Surjective D.comparison.toAlgHom :=
  D.comparison.surjective

/-- **Injectivity half** under the Fitting-equality hypothesis. -/
theorem numericalCriterion_injective
    {Λ k O R T : Type u}
    [CommRing Λ] [Field k] [CommRing O] [CommRing R] [CommRing T]
    [Algebra Λ O] [Algebra O R] [Algebra O T]
    (D : BCDTCriterionData Λ k O R T)
    (h : D.api.fittingΦ = D.api.fittingψ) :
    Function.Injective D.comparison.toAlgHom :=
  (algebraicCriterion_RT D h).1

end MathlibExpansion.Roots.BCDT2001
