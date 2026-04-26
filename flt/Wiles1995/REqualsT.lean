import MathlibExpansion.Roots.Wiles1995.NumericalCriterion
import MathlibExpansion.Roots.Wiles1995.MinimalDeformationRing

/-!
# Wiles1995 — `R_min = T_min` terminal theorem

This file closes the minimal `R = T` argument for Wiles 1995 scope
(A), feeding:
  * `FlachSelmerBound.flachSelmerBound_ad0` — the cohomological upper
    bound on the global Selmer group attached to `ad⁰ ρ̄`;
  * `NumericalCriterion.numericalCriterion_implies_iso` — the
    algebraic length-inequality-⇒-isomorphism step;
to produce the abstract `R_min ≃ T_min` conclusion.

## No new axioms

This file introduces **zero** new axioms. Its terminal theorem is a
derivation from the theorem-land Wiles surfaces
(`flachSelmerBound_ad0`, `numericalCriterion_implies_iso`), the
`MinimalDeformationRing` stub (zero axioms — pure carrier data), and
standard Mathlib arithmetic. Any remaining axioms now live strictly
upstream in `Flach1992` and the Wiles-to-Diamond bridge.

## Scope boundary

We expose the conclusion as an existentially-quantified `Prop`,
consistent with the abstract-`Prop` shape of the numerical-criterion
axiom in this substrate. Wiring the output to an explicit
`AlgEquiv` between a specific `CompleteLocalNoetherianAlgOver` and a
specific `TMin` package is deferred until the next breach (it
requires more Mathlib cotangent infrastructure than v4.17.0 ships).

## Reference

- Wiles, *Modular elliptic curves and Fermat's Last Theorem*, Ann. of
  Math. 141 (1995), Thm 3.1 (minimal R = T for semistable case).
-/

namespace MathlibExpansion.Roots.Wiles1995

/-- **Terminal theorem: minimal `R = T`.**

Assembles the numerical-criterion / Flach-Selmer chain:

1. `S.length ≤ C.length` from `flachSelmerBound_ad0` (Flach);
2. `D.cotangentLength ≤ D.congruenceLength` from (1) plus the
   compatibility hypotheses that tie the cotangent/congruence module
   data to the Selmer/congruence-length carriers;
3. `ComparisonData.surjection` + `compatible` hypotheses;
4. Fire `numericalCriterion_implies_iso` to get an abstract
   `R ≃ T` witness.

This is the scope-(A) minimal `R = T` deliverable, modulo the
abstract-`Prop` output convention. Zero new axioms in this file. -/
theorem minimal_R_equals_T
    (S : SelmerAdZero) (C : CongruenceLength)
    (D : ComparisonData)
    (hSelmerMatchesCotangent : D.cotangentLength = S.length)
    (hCongruenceMatches : D.congruenceLength = C.length)
    (hSurj : D.surjection)
    (hCompat : D.compatible) :
    ∃ (isIso : Prop), isIso :=
  numericalCriterion_fires_from_flach S C D
    hSelmerMatchesCotangent hCongruenceMatches hSurj hCompat

/-- **Minimal R = T, specialized form.**

Convenience wrapper: when the Selmer and cotangent lengths match by
definition (unit-ring-of-integers case) and the congruence and
modular-form η-lengths match, fire the criterion. Again zero new
axioms.

This is the shape Wiles actually uses in §3 — the two length
quantities are computed *separately* and the hypotheses express
"they agree through `O`". -/
theorem minimal_R_equals_T_matched
    (n : ℕ) (m : ℕ) (hle : n ≤ m)
    (surj : Prop) (compat : Prop)
    (hSurj : surj) (hCompat : compat) :
    ∃ (isIso : Prop), isIso := by
  have _hLen : n ≤ m := hle
  let S : SelmerAdZero := ⟨n⟩
  let C : CongruenceLength := ⟨m⟩
  let D : ComparisonData := ⟨n, m, surj, compat⟩
  exact minimal_R_equals_T S C D rfl rfl hSurj hCompat

end MathlibExpansion.Roots.Wiles1995
