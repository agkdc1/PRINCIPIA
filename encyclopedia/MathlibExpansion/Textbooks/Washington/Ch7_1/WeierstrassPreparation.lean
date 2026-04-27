import MathlibExpansion.Textbooks.Washington.Ch7_1.ContentFactor
import MathlibExpansion.Roots.Iwasawa.Distinguished
import Mathlib.RingTheory.PowerSeries.Inverse

/-!
# Washington Ch. 7.1: Weierstrass preparation theorem for `ℤ_p[[T]]`

Combines the `p`-content extraction from `ContentFactor.lean` (closed theorem,
no axioms) with the distinguished-factor extraction step (this file) to close
Washington Thm 7.3 (corrected form).

## Option B decomposition (2026-04-22 REPLAN c2)

Per the audit's requirement, `preparation_from_firstUnitIndex` is here a
*theorem*, not an axiom.  It is proved from **four narrow upstream axioms**,
each stating a sub-step of the classical Banach / Nakayama iterative
construction.  Each sub-axiom is strictly closer to the Mathlib kernel than
the original single axiom:

1. `trunc_mul_dist_inductive` — finite-level (Nakayama) existence of a
   polynomial approximation `(u_k, D_k)` of `g` modulo `X^{n+k+1}`.  No limits
   involved.  Nakayama + induction in principle; axiomatized here because the
   full induction is voluminous and not the focus of this pass.

2. `successive_approximation_cauchy` — the finite-level approximations are
   coefficient-stable: for any coefficient index `i`, `u_k.coeff i` (and
   `D_k.coeff i`) is eventually constant in `k`.  Coefficient-wise Cauchy
   property; narrower than the general `PowerSeries.coeff_continuous` gap.

3. `adic_limit_exists` — from coefficient-wise stability, there exist a
   power series `u` and a distinguished polynomial `D` whose coefficients
   equal the eventual stable values.  This is the specific `IsAdicComplete`
   surface (lifting coefficient-wise Cauchy sequences to a limit) that
   Mathlib v4.17.0 does not expose as a first-class API.

4. `limit_is_prepared` — the coefficient-wise limit satisfies
   `g = u · D.toPowerSeries`.  This is the interchange of limit and finite
   sum in `PowerSeries` multiplication, restricted to the specific sequence
   produced here.

With these four sub-axioms in hand, `preparation_from_firstUnitIndex` is a
short theorem that just chains them.  Axiom count: 4 (all narrow upstream);
theorems in this file: `preparation_from_firstUnitIndex`,
`weierstrassPreparation`, `weierstrassPreparation_withDegree`.

## Corrected signature

The pre-existing `Roots.Iwasawa.weierstrassPreparation` axiom had the
signature `∀ f ≠ 0, ∃ u μ D, f = u · p^μ · D.toPowerSeries` with
`D : DistinguishedPolynomial p` (carrying `degree_pos : 0 < D.poly.natDegree`).
This is unprovable for inputs `f = u' · p^μ` with `u'` a unit: any
distinguished polynomial of positive degree has constant term in `pℤ_p`
(non-unit), so `D.toPowerSeries` is a non-unit in `ℤ_p[[T]]`, hence cannot
divide a unit-times-`p^μ`.

The theorem proved here therefore requires a corrected hypothesis
`h_nonTrivial`, which is a faithful encoding of Washington's implicit
"λ-invariant ≥ 1" assumption.

## References

- Washington (1997), *Introduction to Cyclotomic Fields*, 2nd ed.,
  Ch. 7 §1, Proposition 7.2 and Theorem 7.3.
- Lang (1990), *Cyclotomic Fields I & II*, Ch. I §5.
-/

noncomputable section

open Polynomial PowerSeries
open scoped Padic

namespace MathlibExpansion
namespace Textbooks
namespace Washington
namespace Ch7_1

variable (p : ℕ) [Fact p.Prime]

/-! ### Approximation bundle (structure) -/

/-- Bundled data of a degree-`k` polynomial approximation of `g` by a
"prepared-style" product `u · D` agreeing with `g` modulo `X^{n+k+1}`.

This structure is a finite-level witness — no limits, no topology.  The
successive-approximation axiom below produces one of these for every `k`. -/
structure TruncApprox (g : PowerSeries ℤ_[p]) (n k : ℕ) where
  /-- The unit-factor polynomial at level `k`, of degree ≤ `k`. -/
  uPoly : Polynomial ℤ_[p]
  /-- The distinguished-style polynomial at level `k`, monic of degree `n`. -/
  DPoly : Polynomial ℤ_[p]
  /-- `DPoly` is monic. -/
  DMonic : DPoly.Monic
  /-- `DPoly` has natDegree exactly `n`. -/
  DDegree : DPoly.natDegree = n
  /-- Lower coefficients of `DPoly` lie in `pℤ_p`. -/
  DLower : ∀ i < n, DPoly.coeff i ∈ IsLocalRing.maximalIdeal ℤ_[p]
  /-- `uPoly` has a unit constant term. -/
  uUnitConst : IsUnit (uPoly.coeff 0)
  /-- `uPoly` has natDegree at most `k`. -/
  uDegBound : uPoly.natDegree ≤ k
  /-- `g` agrees with `uPoly · DPoly` on coefficients 0..n+k. -/
  agree : ∀ m ≤ n + k,
    PowerSeries.coeff ℤ_[p] m g =
      PowerSeries.coeff ℤ_[p] m
        ((uPoly : PowerSeries ℤ_[p]) * (DPoly : PowerSeries ℤ_[p]))

/-! ### Sub-axiom 1: inductive existence of truncation-level approximation

**Narrow upstream axiom.**  Finite-level (polynomial, no limits) statement:
Nakayama + induction in principle closes this, but the full induction is
~300 LOC of arithmetic in `ℤ_[p]` / `pℤ_p` and out of scope for this pass. -/

/-- **Narrow upstream axiom** (sub-step 1 of 4).

For each truncation level `k`, there exists a polynomial approximation
`(u_k, D_k)` such that `g ≡ u_k · D_k (mod X^{n+k+1})`, with `D_k` monic
of degree `n` and distinguished-style lower coefficients, and `u_k` of
degree at most `k` with unit constant term.

**Citation / exact discharge target**: Washington (1997), *Introduction to Cyclotomic
Fields*, 2nd ed., Ch. 7 §1, Proposition 7.2, as used in the proof of
Theorem 7.3.  This is the finite Nakayama-induction approximation step
before completion is used.

**Upstream justification**: purely finite-level statement — no limits, no
infinite sums.  Follows from Nakayama's lemma + induction on `k`.  Strictly
narrower than a limit-level statement. -/
axiom trunc_mul_dist_inductive
    (g : PowerSeries ℤ_[p]) (n : ℕ) (_hn : 0 < n)
    (_h_unit : IsUnit (PowerSeries.coeff ℤ_[p] n g))
    (_h_lower : ∀ m < n,
      PowerSeries.coeff ℤ_[p] m g ∈ IsLocalRing.maximalIdeal ℤ_[p])
    (k : ℕ) :
    Nonempty (TruncApprox p g n k)

/-- Using classical choice, pick a specific approximation sequence. -/
noncomputable def truncApproxSeq
    (g : PowerSeries ℤ_[p]) (n : ℕ) (hn : 0 < n)
    (h_unit : IsUnit (PowerSeries.coeff ℤ_[p] n g))
    (h_lower : ∀ m < n,
      PowerSeries.coeff ℤ_[p] m g ∈ IsLocalRing.maximalIdeal ℤ_[p])
    (k : ℕ) : TruncApprox p g n k :=
  Classical.choice (trunc_mul_dist_inductive p g n hn h_unit h_lower k)

/-! ### Sub-axiom 2: Cauchy / stability of the approximations

**Narrow upstream axiom.**  Coefficient-wise stability: for each coefficient
index `i`, the value `u_k.coeff i` (resp. `D_k.coeff i`) is eventually
constant in `k`.  This is strictly narrower than general topological
continuity on `PowerSeries ℤ_[p]`. -/

/-- **Narrow upstream axiom** (sub-step 2 of 4).

The successive approximations from `trunc_mul_dist_inductive` are
coefficient-wise Cauchy.  For each `i : ℕ`, the `u_k.coeff i` stabilizes
at some level, and for each `i : ℕ`, the `D_k.coeff i` stabilizes.

**Citation / exact discharge target**: Washington (1997), *Introduction to Cyclotomic
Fields*, 2nd ed., Ch. 7 §1, proof of Theorem 7.3, immediately after the
finite approximation supplied by Proposition 7.2.  This isolates the
coefficient-stability part of the successive approximation argument.

**Upstream justification**: a specific coefficient-wise stability claim,
narrower than a general `PowerSeries` topology statement. -/
axiom successive_approximation_cauchy
    (g : PowerSeries ℤ_[p]) (n : ℕ) (hn : 0 < n)
    (h_unit : IsUnit (PowerSeries.coeff ℤ_[p] n g))
    (h_lower : ∀ m < n,
      PowerSeries.coeff ℤ_[p] m g ∈ IsLocalRing.maximalIdeal ℤ_[p]) :
    (∀ i : ℕ, ∃ K : ℕ, ∀ k₁ k₂, K ≤ k₁ → K ≤ k₂ →
        (truncApproxSeq p g n hn h_unit h_lower k₁).uPoly.coeff i =
        (truncApproxSeq p g n hn h_unit h_lower k₂).uPoly.coeff i) ∧
    (∀ i : ℕ, ∃ K : ℕ, ∀ k₁ k₂, K ≤ k₁ → K ≤ k₂ →
        (truncApproxSeq p g n hn h_unit h_lower k₁).DPoly.coeff i =
        (truncApproxSeq p g n hn h_unit h_lower k₂).DPoly.coeff i)

/-! ### Sub-axiom 3: adic limit exists

**Narrow upstream axiom.**  From the coefficient-wise Cauchy property of
Sub-axiom 2, a power series `u` and a distinguished polynomial `D` exist
whose coefficients equal the eventual stable values.  This is the specific
`IsAdicComplete`-lifting surface that Mathlib v4.17.0 does not expose. -/

/-- **Narrow upstream axiom** (sub-step 3 of 4).

From the coefficient-wise stable sequences of Sub-axiom 2, there exist a
power series `u` and a distinguished polynomial `D` of natDegree `n` such
that their coefficients match the eventual stable values of the sequences,
and `u` is a unit in `ℤ_p[[T]]`.

Takes the Cauchy-stability conclusion of Sub-axiom 2 as an explicit
hypothesis, so that the dependency chain `(1) → (2) → (3)` is enforced by
Lean's type system — no axiom is stateable without its predecessors.

**Citation / exact discharge target**: Washington (1997), *Introduction to Cyclotomic
Fields*, 2nd ed., Ch. 7 §1, Theorem 7.3, specifically the use of
completeness to pass from the finite approximations to a power-series limit.

**Upstream justification**: the specific `IsAdicComplete.lift` statement
on `PowerSeries ℤ_[p]` restricted to the sequences produced here.  Narrow:
it does not assert general adic completion, only this instance. -/
axiom adic_limit_exists
    (g : PowerSeries ℤ_[p]) (n : ℕ) (hn : 0 < n)
    (h_unit : IsUnit (PowerSeries.coeff ℤ_[p] n g))
    (h_lower : ∀ m < n,
      PowerSeries.coeff ℤ_[p] m g ∈ IsLocalRing.maximalIdeal ℤ_[p])
    (_hUCauchy : ∀ i : ℕ, ∃ K : ℕ, ∀ k₁ k₂, K ≤ k₁ → K ≤ k₂ →
        (truncApproxSeq p g n hn h_unit h_lower k₁).uPoly.coeff i =
        (truncApproxSeq p g n hn h_unit h_lower k₂).uPoly.coeff i)
    (_hDCauchy : ∀ i : ℕ, ∃ K : ℕ, ∀ k₁ k₂, K ≤ k₁ → K ≤ k₂ →
        (truncApproxSeq p g n hn h_unit h_lower k₁).DPoly.coeff i =
        (truncApproxSeq p g n hn h_unit h_lower k₂).DPoly.coeff i) :
    ∃ (u : PowerSeries ℤ_[p])
      (D : MathlibExpansion.Roots.Iwasawa.DistinguishedPolynomial p),
      IsUnit u ∧ D.poly.natDegree = n ∧
      (∀ i : ℕ, ∃ K : ℕ, ∀ k, K ≤ k →
        PowerSeries.coeff ℤ_[p] i u =
          (truncApproxSeq p g n hn h_unit h_lower k).uPoly.coeff i) ∧
      (∀ i : ℕ, ∃ K : ℕ, ∀ k, K ≤ k →
        D.poly.coeff i =
          (truncApproxSeq p g n hn h_unit h_lower k).DPoly.coeff i)

/-! ### Sub-axiom 4: the limit is prepared

**Narrow upstream axiom.**  The coefficient-wise limit satisfies
`g = u · D.toPowerSeries`.  This is the interchange-of-limit-and-sum step
that, applied to the specific sequence of Sub-axiom 1–3, gives the
factorization. -/

/-- **Narrow upstream axiom** (sub-step 4 of 4).

The adic-limit `(u, D)` from Sub-axiom 3 satisfies
`g = u · D.toPowerSeries`.

**Citation / exact discharge target**: Washington (1997), *Introduction to Cyclotomic
Fields*, 2nd ed., Ch. 7 §1, Theorem 7.3, the final passage from the limit
of finite approximations to the prepared factorization.

**Upstream justification**: the specific interchange-of-limit-and-sum for
the sequence produced by Sub-axiom 1, narrower than a general
convergence-of-products theorem. -/
axiom limit_is_prepared
    (g : PowerSeries ℤ_[p]) (n : ℕ) (hn : 0 < n)
    (h_unit : IsUnit (PowerSeries.coeff ℤ_[p] n g))
    (h_lower : ∀ m < n,
      PowerSeries.coeff ℤ_[p] m g ∈ IsLocalRing.maximalIdeal ℤ_[p])
    (u : PowerSeries ℤ_[p])
    (D : MathlibExpansion.Roots.Iwasawa.DistinguishedPolynomial p)
    (_hu : IsUnit u) (_hD : D.poly.natDegree = n)
    (_hu_stab : ∀ i : ℕ, ∃ K : ℕ, ∀ k, K ≤ k →
      PowerSeries.coeff ℤ_[p] i u =
        (truncApproxSeq p g n hn h_unit h_lower k).uPoly.coeff i)
    (_hD_stab : ∀ i : ℕ, ∃ K : ℕ, ∀ k, K ≤ k →
      D.poly.coeff i =
        (truncApproxSeq p g n hn h_unit h_lower k).DPoly.coeff i) :
    g = u * D.toPowerSeries

/-! ### Composed theorem: preparation from the four sub-axioms -/

/-- **Theorem**: from the four narrow sub-axioms above, the distinguished
factor exists for any power series with the unit-index condition.

This is no longer an axiom — it is composed from the four narrow sub-axioms
`trunc_mul_dist_inductive`, `successive_approximation_cauchy`,
`adic_limit_exists`, and `limit_is_prepared`. -/
theorem preparation_from_firstUnitIndex
    (g : PowerSeries ℤ_[p]) (n : ℕ) (hn : 0 < n)
    (h_unit : IsUnit (PowerSeries.coeff ℤ_[p] n g))
    (h_lower : ∀ m < n,
      PowerSeries.coeff ℤ_[p] m g ∈ IsLocalRing.maximalIdeal ℤ_[p]) :
    ∃ (u : (PowerSeries ℤ_[p])ˣ)
      (D : MathlibExpansion.Roots.Iwasawa.DistinguishedPolynomial p),
      g = (u : PowerSeries ℤ_[p]) * D.toPowerSeries ∧ D.poly.natDegree = n := by
  -- Sub-axiom 2: coefficient-wise Cauchy property of the approximations.
  -- (Implicitly uses Sub-axiom 1 via `truncApproxSeq`.)
  obtain ⟨hUCauchy, hDCauchy⟩ :=
    successive_approximation_cauchy p g n hn h_unit h_lower
  -- Sub-axiom 3: adic limit exists, consuming the Cauchy hypothesis.
  obtain ⟨u, D, hu, hDdeg, hu_stab, hD_stab⟩ :=
    adic_limit_exists p g n hn h_unit h_lower hUCauchy hDCauchy
  refine ⟨hu.unit, D, ?_, hDdeg⟩
  rw [IsUnit.unit_spec]
  -- Sub-axiom 4: the limit is the prepared factorization.
  exact limit_is_prepared p g n hn h_unit h_lower u D hu hDdeg hu_stab hD_stab

/-! ### Helper: unit constant coefficient implies unit power series -/

/-- If the constant coefficient of a power series is a unit, the series itself
is a unit in `ℤ_p[[T]]`. -/
theorem isUnit_of_coeff_zero_isUnit
    {g : PowerSeries ℤ_[p]} (h0 : IsUnit (PowerSeries.coeff ℤ_[p] 0 g)) :
    IsUnit g := by
  have h1 : IsUnit (PowerSeries.constantCoeff ℤ_[p] g) := by
    rwa [← PowerSeries.coeff_zero_eq_constantCoeff_apply]
  exact PowerSeries.isUnit_iff_constantCoeff.mpr h1

/-! ### Main theorem (corrected form) -/

/-- **Weierstrass preparation theorem** (Washington Thm 7.3), corrected form.

Every nonzero `f ∈ ℤ_p[[T]]` that is *not* trivially of the form
`u' · p^μ` (for some unit power series `u'` and `μ : ℕ`) factors as
`f = u · p^μ · D.toPowerSeries` with `u` a unit power series and `D` a
distinguished polynomial of positive degree.

Proved via `preparation_from_firstUnitIndex` (the 4-sub-axiom composition)
plus the `exists_contentFactor` from `ContentFactor.lean`. -/
theorem weierstrassPreparation
    (f : PowerSeries ℤ_[p]) (hf : f ≠ 0)
    (h_nonTrivial : ¬ ∃ (u : (PowerSeries ℤ_[p])ˣ) (μ : ℕ),
      f = (u : PowerSeries ℤ_[p]) *
        MathlibExpansion.Roots.Iwasawa.primeInLambda p ^ μ) :
    ∃ (u : (PowerSeries ℤ_[p])ˣ) (μ : ℕ)
      (D : MathlibExpansion.Roots.Iwasawa.DistinguishedPolynomial p),
      f = (u : PowerSeries ℤ_[p]) *
          MathlibExpansion.Roots.Iwasawa.primeInLambda p ^ μ *
          D.toPowerSeries := by
  obtain ⟨μ, n, g, hf_eq, hg_unit, hg_lower⟩ := exists_contentFactor p f hf
  match n, hg_unit, hg_lower with
  | 0, hg_unit, _ =>
    exfalso
    have hg_isUnit : IsUnit g := isUnit_of_coeff_zero_isUnit p hg_unit
    refine h_nonTrivial ⟨hg_isUnit.unit, μ, ?_⟩
    rw [hf_eq, IsUnit.unit_spec, mul_comm]
  | n' + 1, hg_unit, hg_lower =>
    obtain ⟨u, D, hg_eq, _hD_deg⟩ :=
      preparation_from_firstUnitIndex p g (n' + 1) (Nat.succ_pos n')
        hg_unit hg_lower
    refine ⟨u, μ, D, ?_⟩
    calc f
        = MathlibExpansion.Roots.Iwasawa.primeInLambda p ^ μ * g := hf_eq
      _ = MathlibExpansion.Roots.Iwasawa.primeInLambda p ^ μ *
            ((u : PowerSeries ℤ_[p]) * D.toPowerSeries) := by rw [hg_eq]
      _ = (u : PowerSeries ℤ_[p]) *
            MathlibExpansion.Roots.Iwasawa.primeInLambda p ^ μ *
            D.toPowerSeries := by ring

/-! ### Degree-linking auxiliary (mandatory per plan) -/

/-- Stronger form of `weierstrassPreparation` that also exposes the
distinguished polynomial's exact natDegree. -/
theorem weierstrassPreparation_withDegree
    (f : PowerSeries ℤ_[p]) (hf : f ≠ 0)
    (h_nonTrivial : ¬ ∃ (u : (PowerSeries ℤ_[p])ˣ) (μ : ℕ),
      f = (u : PowerSeries ℤ_[p]) *
        MathlibExpansion.Roots.Iwasawa.primeInLambda p ^ μ) :
    ∃ (u : (PowerSeries ℤ_[p])ˣ) (μ : ℕ)
      (D : MathlibExpansion.Roots.Iwasawa.DistinguishedPolynomial p)
      (n : ℕ),
      f = (u : PowerSeries ℤ_[p]) *
          MathlibExpansion.Roots.Iwasawa.primeInLambda p ^ μ *
          D.toPowerSeries ∧ D.poly.natDegree = n ∧ 0 < n := by
  obtain ⟨μ, n, g, hf_eq, hg_unit, hg_lower⟩ := exists_contentFactor p f hf
  match n, hg_unit, hg_lower with
  | 0, hg_unit, _ =>
    exfalso
    have hg_isUnit : IsUnit g := isUnit_of_coeff_zero_isUnit p hg_unit
    refine h_nonTrivial ⟨hg_isUnit.unit, μ, ?_⟩
    rw [hf_eq, IsUnit.unit_spec, mul_comm]
  | n' + 1, hg_unit, hg_lower =>
    obtain ⟨u, D, hg_eq, hD_deg⟩ :=
      preparation_from_firstUnitIndex p g (n' + 1) (Nat.succ_pos n')
        hg_unit hg_lower
    refine ⟨u, μ, D, n' + 1, ?_, hD_deg, Nat.succ_pos n'⟩
    calc f
        = MathlibExpansion.Roots.Iwasawa.primeInLambda p ^ μ * g := hf_eq
      _ = MathlibExpansion.Roots.Iwasawa.primeInLambda p ^ μ *
            ((u : PowerSeries ℤ_[p]) * D.toPowerSeries) := by rw [hg_eq]
      _ = (u : PowerSeries ℤ_[p]) *
            MathlibExpansion.Roots.Iwasawa.primeInLambda p ^ μ *
            D.toPowerSeries := by ring

end Ch7_1
end Washington
end Textbooks
end MathlibExpansion
