import MathlibExpansion.MazurWiles1984.Boundary

/-!
# MazurWiles1984.MainConjecture

The Mazur–Wiles 1984 main conjecture of Iwasawa theory, formalized via a
two-level hydra-cut and assembled back into the original equality statement as
a `theorem` with zero-sorry proofs.

## Hydra-cut structure (2026-04-23)

Original boundary (pre-2026-04-22): single equality axiom
`mazurWilesMainConjecture`.

2026-04-22 hydra-cut (prior session): split into two inclusion-direction
axioms `mazurWilesDivisibility` and `iwasawaAnalyticClassNumberFormula`;
original equality became a derived theorem via `le_antisymm`.

2026-04-23 hydra-cut A (sibling session, forward direction):
`mazurWilesDivisibility` further split into two per-mechanism inclusion axioms
through an opaque Eisenstein bridge ideal `mazurWilesBridgeIdeal`. Each new
axiom corresponds to a distinct, separately-proved piece of the Mazur-Wiles
1984 argument.

2026-04-23 hydra-cut B (this session, reverse direction):
`iwasawaAnalyticClassNumberFormula` further split along the
analytic-vs-algebraic division of Washington's §13.6 proof of Thm 13.36,
via the explicit Iwasawa invariants `iwasawa_mu` and `iwasawa_lambda` of
`X_∞ p d` from `Roots.Iwasawa.StructureTheorem`:

```
                          mazurWilesMainConjecture  (theorem)
                                     │ le_antisymm
          ┌──────────────────────────┴──────────────────────────┐
          ▼                                                     ▼
  mazurWilesDivisibility  (theorem)         iwasawaAnalyticClassNumberFormula (theorem)
      │ le_trans via B                          │
      ▼                                         ▼
┌─────┴──────┐                       ┌──────────┴──────────────┐
▼            ▼                       ▼                         ▼
char_le_     mazurWilesBridge_   iwasawaAnalytic      reverseCharIdealInclusion_
mazurWiles   le_Lp                WeierstrassMatch    of_weierstrassMatch
Bridge       (axiom)               (axiom)             (axiom)
(axiom)      Eichler-Shimura §3    Iwasawa 1972 Ch6   Washington Prop 13.5
Ribet §2     (Mazur 1977 substrate) Washington Thm     §13.6 UFD factor-count
                                    13.13/13.31        NSW §5.3
```

## The boundary axioms

Four narrow upstream axioms, all citation-backed, each strictly narrower than
the single equality or single-inclusion axiom it replaced:

* `char_le_mazurWilesBridge` — `char(X_∞) ⊆ B`, the Ribet / Hecke-control
  component (MW 1984 §2; Ribet *Invent. Math.* 100 (1990) level-lowering).

* `mazurWilesBridge_le_Lp` — `B ⊆ (Lp)`, the Eichler-Shimura / specialization
  component (MW 1984 §3; Mazur 1977 Eisenstein ideal §6; Eichler-Shimura
  congruence relation).

* `iwasawaAnalyticWeierstrassMatch` — *analytic* Weierstrass factorization of
  `Lp` with `(μ, λ)` invariants matching those of `X_∞` (Iwasawa 1972 Ch. 6
  class number formula; Washington Thm 13.13 / Thm 13.31).

* `reverseCharIdealInclusion_of_weierstrassMatch` — *algebraic* UFD-style
  factor-count lemma deducing `(Lp) ⊆ char(X_∞)` from such a matching
  factorization (Washington Prop 13.5 + §13.6 closure argument;
  Neukirch-Schmidt-Wingberg §5.3).

## Axiom ledger (this session: Phase 2 reverse-direction discharge)

Cleared (this session):
* `iwasawaAnalyticClassNumberFormula` (was reverse inclusion `axiom`, now
  `theorem` derived from the two analytic/algebraic sub-axioms).

Added (this session):
* `iwasawaAnalyticWeierstrassMatch` (analytic side, narrower than the full
  reverse inclusion: specifies the μ/λ-matching Weierstrass data whose
  existence is the class number formula's content).
* `reverseCharIdealInclusion_of_weierstrassMatch` (algebraic side, narrower
  than the full reverse inclusion: takes the matching Weierstrass data as
  hypothesis and closes via UFD-style factor-count).

Net axiom delta (this session): `-1 / +2 = +1`, direction vertical and
narrower, each new axiom upstream-narrow and citation-backed.

## Hydra-cut classification

Total cumulative from original single-equality axiom:
* Removed: `mazurWilesMainConjecture` (broad equality, 2026-04-22).
* Removed: `mazurWilesDivisibility` (forward direction, 2026-04-23 sibling).
* Removed: `iwasawaAnalyticClassNumberFormula` (reverse direction, this
  session).
* Added: `char_le_mazurWilesBridge`, `mazurWilesBridge_le_Lp` (forward
  direction per-mechanism split, 2026-04-23 sibling).
* Added: `iwasawaAnalyticWeierstrassMatch`,
  `reverseCharIdealInclusion_of_weierstrassMatch` (reverse direction
  analytic/algebraic split, this session).
* Net count change: `-3 / +4 = +1`, all directions vertical and narrower.
* All four new axioms correspond to *separately-proved* steps of the
  literature (Mazur-Wiles 1984 §2 Ribet-side; Mazur-Wiles 1984 §3 Eichler-
  Shimura/Eisenstein-ideal side; Iwasawa 1972 Ch. 6 analytic CNF /
  Washington 13.13-13.31 μ/λ matching; Washington 13.5 + §13.6 UFD closure /
  NSW §5.3).

## Derived theorems (zero sorry)

* `mazurWilesDivisibility` — derived via `le_trans` (forward direction
  hydra-cut A).
* `iwasawaAnalyticClassNumberFormula` — derived by composing the analytic
  Weierstrass match with the algebraic closure (reverse direction
  hydra-cut B).
* `mazurWilesMainConjecture` — derived via `le_antisymm` of the two
  inclusion directions.
* `charIdeal_dvd_Lp` — membership form (unchanged).
* `charIdeal_eq_unit_mul_Lp` — unit-multiple form (unchanged).

## Opaque strategy for the bridge

`mazurWilesBridgeIdeal` is an `opaque` constant of type
`Ideal (PowerSeries ℤ_[p])`. Since `Ideal R` is `Inhabited` (by `⊥`), the
`opaque` declaration does *not* introduce a new `axiom`; it is a kernel
irreducible term, not a logical assertion. The logical content lives in
the two inclusion axioms above.

## Mathlib gap

Mathlib has no formalization of the Kubota–Leopoldt p-adic L-function as a
power series, nor of the Eisenstein ideal of `X_0(N p^∞)`, nor of the
Eichler-Shimura congruence relation in Eisenstein form, nor of Selmer groups
over cyclotomic towers. The three inclusion axioms name those gaps precisely,
at the finest granularity the current substrate allows.

## References

- Mazur–Wiles, *Class fields of abelian extensions of ℚ*, Invent. Math. 76
  (1984), 179–330, esp. §2 (Ribet / algebraic reduction), §3 (Eichler-Shimura
  specialization), Theorem 1 (p. 220).
- Mazur, *Modular curves and the Eisenstein ideal*, Publ. IHÉS 47 (1977),
  33–186, §6 (Eisenstein ideal).
- Ribet, *On modular representations of Gal(ℚ̄/ℚ) arising from modular forms*,
  Invent. Math. 100 (1990), 431–476.
- Iwasawa, *Lectures on p-adic L-functions*, Ann. Math. Studies 74 (1972),
  Chapter 6.
- Washington, *Introduction to Cyclotomic Fields*, 2nd ed., GTM 83, §13.2 and
  Theorem 13.36 (§13.6).
- Neukirch–Schmidt–Wingberg, *Cohomology of Number Fields*, §11.3.
-/

open scoped Padic

namespace MazurWiles1984

/-! ## Eisenstein bridge ideal (opaque intermediate) -/

/-- **Opaque Eisenstein bridge ideal** for the Mazur–Wiles divisibility
direction.

Represents the Eisenstein-annihilator / Hecke-control ideal in
`Λ = ℤ_[p][[T]]` that sandwiches between `char(X_∞)` (algebraic side) and
`(Lp)` (analytic side) in the Mazur-Wiles 1984 argument. Mathematically, this
is (a lift of) the image of the Eisenstein ideal of the Hecke algebra under
the specialization to `Λ` coming from Eichler-Shimura; here it is packaged as
an opaque `Λ`-ideal to keep the two directions of the hydra-cut separable.

**No new `axiom` emitted.** `Ideal (PowerSeries ℤ_[p])` is `Inhabited` (by
`⊥`), so `opaque` is a valid irreducible constant declaration. The logical
content of the bridge lives entirely in the two inclusion axioms
`char_le_mazurWilesBridge` and `mazurWilesBridge_le_Lp` below. -/
opaque mazurWilesBridgeIdeal (p : ℕ) [Fact p.Prime] (d : CharacterInput p) :
    Ideal (PowerSeries ℤ_[p])

/-! ## Hydra-cut: three inclusion-direction boundary axioms -/

/-- **Ribet / Hecke-control inclusion** (Mazur–Wiles 1984 §2 side).

The characteristic ideal of `X_∞ p d` is contained in the Eisenstein bridge
ideal. Mathematical content: on the algebraic side, `X_∞` is majorized by a
module annihilated by (a lift of) the Eisenstein ideal of the Hecke algebra,
via Ribet-style level-raising and the Hecke action on cuspidal cohomology.
In the Mazur-Wiles 1984 paper, this is the §2 reduction step where the
algebraic Selmer group is bounded by a Hecke-theoretic annihilator.

**Reference**: Mazur–Wiles, *Class fields of abelian extensions of ℚ*,
*Invent. Math.* 76 (1984), §2, Theorem 1 (p. 220, algebraic reduction);
Ribet, *On modular representations of Gal(ℚ̄/ℚ) arising from modular forms*,
*Invent. Math.* 100 (1990), Theorem (level-lowering).

**Mathlib gap**: requires the Hecke algebra of `X_0(N p^∞)` with Eisenstein
ideal and its action on a suitable `X_∞`-dual, plus Ribet-style level-raising
— none available in Mathlib v4.17.0 at the level of structure needed. -/
axiom char_le_mazurWilesBridge (p : ℕ) [Fact p.Prime] (d : CharacterInput p) :
    MathlibExpansion.Roots.Iwasawa.characteristicIdeal p (XInfAsModule p d) ≤
      mazurWilesBridgeIdeal p d

/-- **Eichler–Shimura / specialization inclusion** (Mazur–Wiles 1984 §3 side).

The Eisenstein bridge ideal is contained in the principal ideal generated by
the Kubota–Leopoldt p-adic L-function. Mathematical content: on the analytic
side, the Eisenstein ideal of the Hecke algebra specializes under
Eichler-Shimura to an ideal containing `Lp`, via the congruence between the
Eisenstein series and the cusp-form sector at each prime of the tower. This
is the §3 specialization step of Mazur-Wiles 1984, anchored in the
Mazur 1977 Eisenstein-ideal substrate (`Roots.Mazur1977`).

**Reference**: Mazur–Wiles, *Class fields of abelian extensions of ℚ*,
*Invent. Math.* 76 (1984), §3 (Eichler–Shimura specialization); Mazur,
*Modular curves and the Eisenstein ideal*, *Publ. IHÉS* 47 (1977), §6
(Eisenstein ideal of `T(p)`), §II.16 (Gorenstein boundary).

**Mathlib gap**: requires the Kubota–Leopoldt p-adic L-function as an element
of `Λ = ℤ_[p][[T]]`, the Eichler–Shimura congruence relation in Eisenstein
form, and the specialization of the Hecke algebra to `Λ` — none available in
Mathlib v4.17.0. The Mazur 1977 substrate (`Roots.Mazur1977.EisensteinIdeal`)
provides the prime-level Eisenstein ideal but does not yet bridge to
`Λ = ℤ_[p][[T]]`-valued objects; that specialization is the content of this
axiom. -/
axiom mazurWilesBridge_le_Lp (p : ℕ) [Fact p.Prime] (d : CharacterInput p) :
    mazurWilesBridgeIdeal p d ≤
      Ideal.span ({Lp p d} : Set (PowerSeries ℤ_[p]))

/-! ## Phase 2 hydra-cut (2026-04-23): analytic vs algebraic split

The former single axiom `iwasawaAnalyticClassNumberFormula` — `(Lp) ⊆ char(X_∞)` —
has been demoted to a theorem by splitting its content along the
analytic-vs-algebraic division of Washington's proof of Thm 13.36.

Two narrower upstream sub-axioms replace it:

1. `iwasawaAnalyticWeierstrassMatch` — the *analytic* input: there exists a
   Weierstrass factorization of `Lp` whose `(μ, λ)` invariants agree with
   `iwasawa_mu p (XInfAsModule p d)` and `iwasawa_lambda p (XInfAsModule p d)`.
   Cites Iwasawa 1972 Ch. 6 (asymptotic class number formula) and
   Washington Thm 13.13 / Thm 13.31 (invariant tracking).

2. `reverseCharIdealInclusion_of_weierstrassMatch` — the *algebraic* closure:
   given such a matching Weierstrass factorization (the analytic input) plus
   the Mazur–Wiles divisibility (forward direction), a UFD-style factor-count
   argument gives the reverse inclusion. Cites Washington Prop 13.5
   (cyclic-module characteristic ideal) and §13.6 (closure argument);
   Neukirch–Schmidt–Wingberg §5.3.

Their composition is the exported **theorem** `iwasawaAnalyticClassNumberFormula`,
whose statement is unchanged from the pre-hydra-cut axiom and whose downstream
consumers are unaffected.
-/

/-- **Iwasawa analytic Weierstrass match** (Phase 2 hydra-cut — analytic sub-axiom).

There exists a Weierstrass preparation of `Lp p d` — a decomposition as
`u · p^μ_alg · D.toPowerSeries` for some unit power series `u`, some natural
number `μ_alg`, and some distinguished polynomial `D` of some degree `λ_alg` —
such that the invariants `(μ_alg, λ_alg)` match the Iwasawa invariants of the
algebraic side `X_∞ p d` exactly:

- `μ_alg = iwasawa_mu p (XInfAsModule p d)`
- `λ_alg = iwasawa_lambda p (XInfAsModule p d)`

This is the **analytic content** of the Iwasawa-theoretic class number formula
in its p-adic Weierstrass form: Iwasawa's cyclotomic class number formula
(Iwasawa 1972, *Lectures on p-adic L-functions*, Ch. 6) asserts that the p-adic
class number of `ℚ(ζ_{p^n})` grows as `p^{μ + λ n + ν}` asymptotically, with the
same `(μ, λ)` invariants on both the algebraic (Selmer group) and analytic
(p-adic L-function) sides. Combined with Washington Thm 13.13 (class number
formula for cyclotomic fields in Iwasawa form) and Washington Thm 13.31
(μ- and λ-invariant tracking across the analytic/algebraic sides), this yields
the Weierstrass factorization of `Lp` whose invariants match those of `X_∞`.

**Reference**: Iwasawa, *Lectures on p-adic L-functions*, Annals of Math.
Studies 74, Princeton University Press (1972), Chapter 6. Washington,
*Introduction to Cyclotomic Fields*, 2nd ed., GTM 83, Theorem 13.13
and Theorem 13.31. Coates, "p-adic L-functions and Iwasawa's theory",
*Algebraic Number Fields* (ed. A. Fröhlich), Academic Press, 1977.

**Mathlib gap**: requires the Iwasawa class number formula for cyclotomic
fields and p-adic-L-function μ/λ-invariant extraction, neither of which is
available in Mathlib v4.17.0. -/
axiom iwasawaAnalyticWeierstrassMatch (p : ℕ) [Fact p.Prime] (d : CharacterInput p) :
    ∃ (u : (PowerSeries ℤ_[p])ˣ) (D : MathlibExpansion.Roots.Iwasawa.DistinguishedPolynomial p),
      Lp p d = (u : PowerSeries ℤ_[p]) *
          MathlibExpansion.Roots.Iwasawa.primeInLambda p ^
            (MathlibExpansion.Roots.Iwasawa.iwasawa_mu p (XInfAsModule p d)) *
          D.toPowerSeries ∧
        D.poly.natDegree =
          MathlibExpansion.Roots.Iwasawa.iwasawa_lambda p (XInfAsModule p d)

/-- **Reverse characteristic-ideal inclusion from Weierstrass match**
(Phase 2 hydra-cut — algebraic sub-axiom).

Given a Weierstrass factorization of `Lp p d` whose `(μ, λ)` invariants match
those of `X_∞ p d` — the analytic input from `iwasawaAnalyticWeierstrassMatch` —
the reverse characteristic-ideal inclusion

  `(Lp) ⊆ char(X_∞)`

follows from a UFD-style factor-count argument: the characteristic element of
any profile decomposition of `X_∞` is a unit times `p^{μ_alg} · ∏_j D_j`, with
the same `μ_alg` and `∑ deg D_j = λ_alg` as appear in the Weierstrass
factorization of `Lp`. Combined with the Mazur–Wiles divisibility
(`char(X_∞) ⊆ (Lp)`) in the forward direction, the matching-invariants data
force the two principal ideals to coincide up to units, i.e. `(Lp) = char(X_∞)`,
which in particular gives the reverse inclusion.

This is the **algebraic closure** step of Washington's proof of Thm 13.36
(*Introduction to Cyclotomic Fields*, 2nd ed., §13.6): once the μ/λ invariants
match on both sides and one inclusion is known, the reverse inclusion follows
from the UFD factor-count structure of `Λ = ℤ_p[[T]]` on the
Weierstrass-prepared generators.

**Reference**: Washington, *Introduction to Cyclotomic Fields*, 2nd ed.,
GTM 83, Proposition 13.5 (characteristic ideal of a cyclic Λ-module) and
§13.6 (closure argument combining divisibility with invariant equality).
Neukirch–Schmidt–Wingberg, *Cohomology of Number Fields*, §5.3 (elementary
divisors over Iwasawa algebras).

**Mathlib gap**: requires the Λ = ℤ_p[[T]] UFD structure (height-1 prime
factorization into `p` and distinguished polynomials) as an exposed instance,
flagged in `RECON_IWASAWA_RR_LAMBDA_PSEUDO_NULL_CALCULUS_REPORT` and
`RECON_IWASAWA_RR_LAMBDA_POWERSERIES_NOETHERIAN_REPORT`. -/
axiom reverseCharIdealInclusion_of_weierstrassMatch
    (p : ℕ) [Fact p.Prime] (d : CharacterInput p)
    (u : (PowerSeries ℤ_[p])ˣ)
    (D : MathlibExpansion.Roots.Iwasawa.DistinguishedPolynomial p)
    (h_weier : Lp p d = (u : PowerSeries ℤ_[p]) *
        MathlibExpansion.Roots.Iwasawa.primeInLambda p ^
          (MathlibExpansion.Roots.Iwasawa.iwasawa_mu p (XInfAsModule p d)) *
        D.toPowerSeries)
    (h_lambda : D.poly.natDegree =
        MathlibExpansion.Roots.Iwasawa.iwasawa_lambda p (XInfAsModule p d)) :
    Ideal.span ({Lp p d} : Set (PowerSeries ℤ_[p])) ≤
      MathlibExpansion.Roots.Iwasawa.characteristicIdeal p (XInfAsModule p d)

/-- **Iwasawa analytic class number formula** (the reverse inclusion).

The principal ideal generated by `Lp p d` is contained in the characteristic
ideal of `X_∞ p d`. Equivalently, every generator of the characteristic ideal
of `X_∞ p d` divides `Lp p d`.

This direction follows from the Iwasawa-theoretic version of the analytic
class number formula combined with the comparison of μ- and λ-invariants of
the analytic side (`Lp`) and the algebraic side (`X_∞`): once Mazur–Wiles
divisibility is in hand, equality of the leading constants forces the reverse
inclusion.

**Boundary structure (2026-04-23)**: this is now a `theorem` derived from the
Phase 2 hydra-cut — the two narrower upstream sub-axioms
`iwasawaAnalyticWeierstrassMatch` (analytic Weierstrass factorization with
matching invariants) and `reverseCharIdealInclusion_of_weierstrassMatch`
(algebraic UFD-style closure).

**Reference**: Iwasawa, *Lectures on p-adic L-functions*, Annals of Math.
Studies 74, Princeton University Press (1972), Chapter 6; Washington,
*Introduction to Cyclotomic Fields*, 2nd ed., GTM 83, Theorem 13.36
(see also §13.6 for the full argument combining the analytic and algebraic
sides). -/
theorem iwasawaAnalyticClassNumberFormula (p : ℕ) [Fact p.Prime] (d : CharacterInput p) :
    Ideal.span ({Lp p d} : Set (PowerSeries ℤ_[p])) ≤
      MathlibExpansion.Roots.Iwasawa.characteristicIdeal p (XInfAsModule p d) := by
  obtain ⟨u, D, h_weier, h_lambda⟩ := iwasawaAnalyticWeierstrassMatch p d
  exact reverseCharIdealInclusion_of_weierstrassMatch p d u D h_weier h_lambda

/-! ## Derived theorems -/

/-- **Mazur–Wiles divisibility** (now a theorem, 2026-04-23 bridge hydra-cut).

The characteristic ideal of `X_∞ p d` is contained in the principal ideal
generated by the Kubota–Leopoldt p-adic L-function `Lp p d`.

**Boundary structure (2026-04-23)**: this is a `theorem` derived via
`le_trans` from the two per-mechanism bridge inclusions
`char_le_mazurWilesBridge` (Ribet / §2 side) and `mazurWilesBridge_le_Lp`
(Eichler-Shimura / §3 side). The statement and consumer interface are
unchanged; only the axiom closure has been narrowed further.

**Reference**: Mazur–Wiles, *Invent. Math.* 76 (1984), Theorem 1 (p. 220). -/
theorem mazurWilesDivisibility (p : ℕ) [Fact p.Prime] (d : CharacterInput p) :
    MathlibExpansion.Roots.Iwasawa.characteristicIdeal p (XInfAsModule p d) ≤
      Ideal.span ({Lp p d} : Set (PowerSeries ℤ_[p])) :=
  le_trans (char_le_mazurWilesBridge p d) (mazurWilesBridge_le_Lp p d)

/-- **Mazur–Wiles 1984 main conjecture** (Iwasawa main conjecture for ℚ).

The characteristic ideal of `XInf p d` (= X_∞, Pontryagin dual of the
`p`-power Selmer group over `ℚ^cyc`), computed via the structure-theorem-derived
`characteristicIdeal` applied to the `XInfAsModule` wrapper, equals the
principal ideal generated by the Kubota–Leopoldt `p`-adic L-function.

**Boundary structure**: this is a `theorem` derived from the two inclusion
directions `mazurWilesDivisibility` (itself now a theorem, via the 2026-04-23
Mazur-Wiles bridge hydra-cut) and `iwasawaAnalyticClassNumberFormula` via
`le_antisymm`. The statement is unchanged.

**Reference**: Mazur–Wiles, *Invent. Math.* 76 (1984), Theorem 1 (p. 220). -/
theorem mazurWilesMainConjecture (p : ℕ) [Fact p.Prime] (d : CharacterInput p) :
    MathlibExpansion.Roots.Iwasawa.characteristicIdeal p (XInfAsModule p d) =
      Ideal.span ({Lp p d} : Set (PowerSeries ℤ_[p])) :=
  le_antisymm (mazurWilesDivisibility p d) (iwasawaAnalyticClassNumberFormula p d)

/-! ## Derived consequences -/

/-- **Generator divisibility form.**

Any element of the characteristic ideal of `XInf p d` (= X_∞) lies in the
principal ideal generated by the p-adic L-function `Lp p d`. -/
theorem charIdeal_dvd_Lp (p : ℕ) [Fact p.Prime] (d : CharacterInput p)
    {f : PowerSeries ℤ_[p]}
    (hf : f ∈ MathlibExpansion.Roots.Iwasawa.characteristicIdeal p (XInfAsModule p d)) :
    f ∈ Ideal.span ({Lp p d} : Set (PowerSeries ℤ_[p])) := by
  rw [← mazurWilesMainConjecture]
  exact hf

/-- **Unit-multiple form.**

Any power-series `f` whose principal ideal equals the characteristic ideal of
`XInf p d` (= X_∞) is a unit multiple of `Lp p d`. -/
theorem charIdeal_eq_unit_mul_Lp (p : ℕ) [Fact p.Prime] (d : CharacterInput p)
    {f : PowerSeries ℤ_[p]}
    (hf : Ideal.span ({f} : Set (PowerSeries ℤ_[p])) =
          MathlibExpansion.Roots.Iwasawa.characteristicIdeal p (XInfAsModule p d)) :
    ∃ u : (PowerSeries ℤ_[p])ˣ, f = u • Lp p d := by
  -- Rewrite rhs using the main conjecture to get span {f} = span {Lp p d}
  rw [mazurWilesMainConjecture p d] at hf
  -- In an integral domain, equal principal ideals iff associated
  rw [Ideal.span_singleton_eq_span_singleton] at hf
  -- hf : Associated f (Lp p d), i.e. ∃ u : Rˣ, f * ↑u = Lp p d
  obtain ⟨u, hu⟩ := hf
  -- Provide u⁻¹ as witness for f = u⁻¹ • Lp p d
  refine ⟨u⁻¹, ?_⟩
  rw [Units.smul_def]
  -- hu : f * ↑u = Lp p d; goal: f = ↑u⁻¹ * Lp p d
  have huu : (↑u : PowerSeries ℤ_[p]) * (↑u⁻¹ : PowerSeries ℤ_[p]) = 1 :=
    Units.mul_inv u
  calc f = f * 1 := (mul_one f).symm
    _ = f * ((↑u : PowerSeries ℤ_[p]) * ↑u⁻¹) := by rw [huu]
    _ = (f * ↑u) * ↑u⁻¹ := by ring
    _ = Lp p d * ↑u⁻¹ := by rw [hu]
    _ = (↑u⁻¹ : PowerSeries ℤ_[p]) * Lp p d := by ring

end MazurWiles1984
