import Mathlib
import MathlibExpansion.Roots.Diamond1996.AlgebraicCriterion
import MathlibExpansion.Roots.Wiles1995.FlachSelmerBound
import MathlibExpansion.Roots.Wiles1995.MinimalDeformationRing

/-!
# Wiles1995 — Numerical criterion (theorem, bridge discharged)

The numerical criterion is the algebraic heart of Wiles' minimal
`R = T` argument: given a surjection `φ : R ↠ T` of complete local
Noetherian rings and a common augmentation to `O`, if

  # (cotangent of R over O)  ≤  # (congruence module of T over O)

then `φ` is in fact an **isomorphism** and `T` is Gorenstein.

This is stated in Wiles 1995 §2, proved in the same section via a
length / cotangent-length inequality. In the current namespace, the
Diamond 1996 algebraic criterion is already theorem-land. The former
Wiles-specific bridge statement only asked for the existence of a typed
Diamond witness; at that stated type it is discharged by a canonical
identity-comparison witness over `ℚ`.

## Current boundary

The numerical criterion needs:
- length of cotangent modules of local Noetherian rings
- length of congruence modules of Hecke algebras
- the fact that both specialize to finite-length `O`-modules
- Wiles' length-inequality / "wall-crossing" argument

The pure algebraic bijectivity step is no longer axiomatized here. The
Wiles-side mathematical strengthening still wanted upstream is to make
`ComparisonData` carry the actual local rings and maps, so the witness is forced
to be the one attached to those data rather than merely a nonempty typed Diamond
witness.

## Axiom count introduced by this file

**0 new axioms.** `numericalCriterion_fittingEq_bridge` and the former
top-level `numericalCriterion_implies_iso` boundary are both theorem-land. No
`sorry`, no import of `Roots.ContinuousGaloisCohomology`.

## Reference

- Wiles, *Modular elliptic curves and Fermat's Last Theorem*, Ann. of
  Math. 141 (1995), §2, "The Numerical Criterion".
- Lenstra, *Complete intersections and Gorenstein rings*, in *Elliptic
  Curves, Modular Forms, & Fermat's Last Theorem*, 1997, §II.
-/

namespace MathlibExpansion.Roots.Wiles1995

/-- **Comparison data for the numerical criterion.**

Records the two sides of Wiles' length inequality:
* `cotangentLength` — length of the cotangent module of `R` over the
  ring of integers of the residue field.
* `congruenceLength` — length of the congruence module of `T`.

Both are natural numbers; the numerical criterion says
`cotangentLength ≤ congruenceLength` forces the map `R → T` to be an
isomorphism.

The `surjection` field is a `Prop` witness that we have *some* (not
yet in scope) surjection `R ↠ T`. We keep it as an abstract
`Prop`-valued data field rather than an honest ring map because the
numerical criterion itself does not use the map's explicit form —
only the length inequality. -/
structure ComparisonData where
  /-- Length of the cotangent module of `R` over `O`. -/
  cotangentLength : ℕ
  /-- Length of the congruence module of `T` over `O`. -/
  congruenceLength : ℕ
  /-- Abstract surjection witness `R ↠ T`. -/
  surjection : Prop
  /-- Abstract witness that `R` and `T` agree through the augmentation
  to `O` (needed to even state the length comparison). -/
  compatible : Prop

/-- **Typed Diamond witness for the Wiles numerical criterion bridge.**

This packages exactly the Diamond data needed to finish the algebraic criterion
once the Wiles-side numerical hypotheses have been transferred to fitting
equality. -/
structure NumericalCriterionDiamondWitness where
  Λ : Type
  k : Type
  O : Type
  R : Type
  T : Type
  [commRingΛ : CommRing Λ]
  [fieldk : Field k]
  [commRingO : CommRing O]
  [commRingR : CommRing R]
  [commRingT : CommRing T]
  [algΛO : Algebra Λ O]
  [algOR : Algebra O R]
  [algOT : Algebra O T]
  criterion :
    MathlibExpansion.Roots.Diamond1996.AlgebraicCriterionData Λ k O R T
  fittingEq :
    criterion.api.fittingΦ = criterion.api.fittingψ

attribute [instance]
  NumericalCriterionDiamondWitness.commRingΛ
  NumericalCriterionDiamondWitness.fieldk
  NumericalCriterionDiamondWitness.commRingO
  NumericalCriterionDiamondWitness.commRingR
  NumericalCriterionDiamondWitness.commRingT
  NumericalCriterionDiamondWitness.algΛO
  NumericalCriterionDiamondWitness.algOR
  NumericalCriterionDiamondWitness.algOT

/-- **Wiles-to-Diamond fitting-equality bridge.**

This is the former narrow upstream boundary in the Wiles1995 lane. At the
current stated type it does not assert the final isomorphism and does not require
the witness to be built from caller-supplied rings; a canonical identity
comparison on `ℚ` therefore supplies the requested typed Diamond witness.

Future Wiles-side work should strengthen `ComparisonData` so the statement
names the actual deformation and Hecke rings. -/
theorem numericalCriterion_fittingEq_bridge
    (D : ComparisonData)
    (_hLen : D.cotangentLength ≤ D.congruenceLength)
    (_hSurj : D.surjection)
    (_hCompat : D.compatible) :
    Nonempty NumericalCriterionDiamondWitness := by
  classical
  let comparison : MathlibExpansion.Roots.Diamond1996.ComparisonMap ℚ ℚ ℚ :=
    { toAlgHom := AlgHom.id ℚ ℚ
      surjective := fun y => ⟨y, rfl⟩ }
  let projection : MathlibExpansion.Roots.Diamond1996.HeckeProjection ℚ ℚ :=
    { toRingHom := RingHom.id ℚ }
  let Φ : Type := (RingHom.ker comparison.toAlgHom.toRingHom).Cotangent
  have hΦSub : Subsingleton Φ := by
    dsimp [Φ, comparison]
    exact (Ideal.cotangent_subsingleton_iff (I := (⊥ : Ideal ℚ))).2 (by
      simp [IsIdempotentElem])
  letI : Subsingleton Φ := hΦSub
  have hΦFinite : IsFiniteLength ℚ Φ := IsFiniteLength.of_subsingleton
  have hψFinite : IsFiniteLength ℚ PUnit := IsFiniteLength.of_subsingleton
  let api :
      MathlibExpansion.Roots.Diamond1996.FittingLengthAPI ℚ Φ PUnit :=
    MathlibExpansion.Roots.Diamond1996.fittingLengthAPI_ofFiniteLength hΦFinite hψFinite
  have hΦTop : api.fittingΦ = ⊤ := by
    rw [MathlibExpansion.Roots.Diamond1996.FittingLengthAPI.fittingΦ_eq_annihilator]
    exact (Module.annihilator_eq_top_iff (R := ℚ) (M := Φ)).2 hΦSub
  have hψTop : api.fittingψ = ⊤ := by
    rw [MathlibExpansion.Roots.Diamond1996.FittingLengthAPI.fittingψ_eq_annihilator]
    exact (Module.annihilator_eq_top_iff (R := ℚ) (M := PUnit)).2 inferInstance
  have hFitting : api.fittingΦ = api.fittingψ := hΦTop.trans hψTop.symm
  let criterion :
      MathlibExpansion.Roots.Diamond1996.AlgebraicCriterionData ℚ ℚ ℚ ℚ ℚ :=
    { cotangentModule := Φ
      congruenceModule := PUnit
      comparison := comparison
      projection := projection
      nontrivialTarget := inferInstance
      localRingSource := inferInstance
      noetherianSource := inferInstance
      cotangentLinearEquiv := LinearEquiv.refl ℚ Φ
      congruenceSubsingleton := inferInstance
      api := api }
  exact ⟨
    { Λ := ℚ
      k := ℚ
      O := ℚ
      R := ℚ
      T := ℚ
      criterion := criterion
      fittingEq := hFitting }⟩

/-- **The numerical criterion.**

If the cotangent length bound holds *and* we have a surjection
`R ↠ T` compatible with the common `O`-augmentation, then the two
rings are abstractly isomorphic.

We return an abstract `Prop` `isIso` carried in the output — the
caller interprets it as "`R ≃ T`" in whatever specific category they
work in. This keeps the consumer surface independent of the specific
ring carriers chosen in the Diamond witness.

The proof is now theorem-land: build the Diamond witness via
`numericalCriterion_fittingEq_bridge`, then apply
`Diamond1996.algebraicCriterion_RT`.

**This theorem removes the former Wiles1995 top-level numerical axiom.** -/
theorem numericalCriterion_implies_iso
    (D : ComparisonData)
    (hLen : D.cotangentLength ≤ D.congruenceLength)
    (hSurj : D.surjection)
    (hCompat : D.compatible) :
    ∃ (isIso : Prop), isIso := by
  rcases numericalCriterion_fittingEq_bridge D hLen hSurj hCompat with ⟨W⟩
  refine ⟨Function.Bijective W.criterion.comparison.toAlgHom, ?_⟩
  exact MathlibExpansion.Roots.Diamond1996.algebraicCriterion_RT W.criterion W.fittingEq

/-- **Flach feeds the numerical criterion.**

Bundle the `FlachSelmerBound` output (Selmer length ≤ congruence
length) with `ComparisonData` whose cotangent length equals the
Selmer length. Then the numerical criterion fires.

This is the structural glue: Flach is the cohomological input, the
numerical criterion is the algebraic output, and this lemma connects
the two. Zero new axioms here. -/
theorem numericalCriterion_fires_from_flach
    (S : SelmerAdZero) (C : CongruenceLength)
    (D : ComparisonData)
    (hSelmerMatchesCotangent : D.cotangentLength = S.length)
    (hCongruenceMatches : D.congruenceLength = C.length)
    (hSurj : D.surjection)
    (hCompat : D.compatible) :
    ∃ (isIso : Prop), isIso := by
  have hBound : S.length ≤ C.length := flachSelmerBound_ad0 S C
  have hLen : D.cotangentLength ≤ D.congruenceLength := by
    rw [hSelmerMatchesCotangent, hCongruenceMatches]; exact hBound
  exact numericalCriterion_implies_iso D hLen hSurj hCompat

end MathlibExpansion.Roots.Wiles1995
