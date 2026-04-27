import Mathlib.FieldTheory.Finite.GaloisField
import Mathlib.Algebra.Squarefree.Basic
import Mathlib.RingTheory.UniqueFactorizationDomain.NormalizedFactors

/-!
# Factorization of `X^(p^n) - X`

This chapter isolates Steinitz `FFC_FACTORIZATION`.

Mathlib already supplies the splitting-field and root-set infrastructure for
`X^(p^n) - X`. The missing theorem surface is the explicit factorization over
all monic irreducibles of divisor degree.

Primary source:
- E. Steinitz (1910), *Algebraische Theorie der Koerper*, `Sec. 15`,
  theorem `10`.
-/

noncomputable section

namespace MathlibExpansion.FieldTheory.Finite

open Polynomial UniqueFactorizationMonoid

variable (p n : ℕ) [Fact p.Prime]

private lemma X_pow_pow_sub_X_monic (hn : n ≠ 0) :
    (Polynomial.X ^ (p ^ n) - Polynomial.X : Polynomial (ZMod p)).Monic := by
  apply Polynomial.monic_X_pow_sub
  rw [Polynomial.degree_X]
  exact_mod_cast Nat.one_lt_pow hn (Fact.out : Nat.Prime p).one_lt

private lemma normalized_factor_natDegree_dvd
    (hn : n ≠ 0) {f : Polynomial (ZMod p)}
    (hf : f ∈ normalizedFactors
      (Polynomial.X ^ (p ^ n) - Polynomial.X : Polynomial (ZMod p))) :
    f.natDegree ∣ n := by
  classical
  let g : Polynomial (ZMod p) := Polynomial.X ^ (p ^ n) - Polynomial.X
  have hp : 1 < p := (Fact.out : Nat.Prime p).one_lt
  have hg0 : g ≠ 0 := by
    simpa [g] using FiniteField.X_pow_card_pow_sub_X_ne_zero (ZMod p) hn hp
  have hfirr : Irreducible f := irreducible_of_normalized_factor f hf
  have hfmonic : f.Monic := by
    have hnorm : normalize f = f := normalize_normalized_factor f hf
    simpa [hnorm] using Polynomial.monic_normalize hfirr.ne_zero
  have hfdvd : f ∣ g := dvd_of_mem_normalizedFactors hf
  have hfsplits : f.Splits (algebraMap (ZMod p) (GaloisField p n)) := by
    simpa [g] using Polynomial.splits_of_splits_of_dvd
      (algebraMap (ZMod p) (GaloisField p n)) hg0 (SplittingField.splits g) hfdvd
  obtain ⟨x, hx⟩ := Polynomial.exists_root_of_splits
    (algebraMap (ZMod p) (GaloisField p n)) hfsplits
    (Polynomial.degree_pos_of_irreducible hfirr).ne'
  have hx' : Polynomial.aeval x f = 0 := by
    simpa [Polynomial.aeval_def] using hx
  have hmin : f = minpoly (ZMod p) x :=
    minpoly.eq_of_irreducible_of_monic hfirr hx' hfmonic
  have hdegdvd : (minpoly (ZMod p) x).natDegree ∣
      Module.finrank (ZMod p) (GaloisField p n) :=
    minpoly.degree_dvd (IsIntegral.of_finite (ZMod p) x)
  rw [GaloisField.finrank p hn] at hdegdvd
  simpa [hmin] using hdegdvd

/-- `X^(p^n) - X` factors as the product of its monic irreducible factors over
`ZMod p` when `n` is positive. The original unconditional surface is false at
`n = 0`, where the left side is zero.

Primary source: E. Steinitz (1910), *Algebraische Theorie der Koerper*,
`Sec. 15`, theorem `10`. Discharged using Mathlib's normalized-factorization,
separability, splitting-field, and finite-field degree APIs. -/
theorem X_pow_pow_sub_X_factorization (hn : n ≠ 0) :
    ∃ s : Finset (Polynomial (ZMod p)),
      (Polynomial.X ^ (p ^ n) - Polynomial.X : Polynomial (ZMod p)) = ∏ f ∈ s, f ∧
      (∀ f ∈ s, Irreducible f ∧ f.Monic ∧ f.natDegree ∣ n) := by
  classical
  let g : Polynomial (ZMod p) := Polynomial.X ^ (p ^ n) - Polynomial.X
  have hp : 1 < p := (Fact.out : Nat.Prime p).one_lt
  have hg0 : g ≠ 0 := by
    simpa [g] using FiniteField.X_pow_card_pow_sub_X_ne_zero (ZMod p) hn hp
  have hgsep : g.Separable := by
    simpa [g] using (galois_poly_separable (K := ZMod p) p (p ^ n) (dvd_pow (dvd_refl p) hn))
  have hnodup : (normalizedFactors g).Nodup :=
    (squarefree_iff_nodup_normalizedFactors hg0).mp hgsep.squarefree
  have hgprod : (normalizedFactors g).prod = g := by
    have h := Polynomial.leadingCoeff_mul_prod_normalizedFactors g
    rw [(X_pow_pow_sub_X_monic (p := p) (n := n) hn).leadingCoeff] at h
    simpa [g] using h
  refine ⟨(normalizedFactors g).toFinset, ?_, ?_⟩
  · have hs_eq : (normalizedFactors g).toFinset = ⟨normalizedFactors g, hnodup⟩ := by
      ext f
      simp
    calc
      (Polynomial.X ^ (p ^ n) - Polynomial.X : Polynomial (ZMod p)) = g := by rfl
      _ = (normalizedFactors g).prod := hgprod.symm
      _ = ∏ f ∈ (normalizedFactors g).toFinset, f := by
        rw [hs_eq]
        simp
  · intro f hf
    have hfmem : f ∈ normalizedFactors g := by simpa using hf
    have hfirr : Irreducible f := irreducible_of_normalized_factor f hfmem
    have hfmonic : f.Monic := by
      have hnorm : normalize f = f := normalize_normalized_factor f hfmem
      simpa [hnorm] using Polynomial.monic_normalize hfirr.ne_zero
    exact ⟨hfirr, hfmonic, normalized_factor_natDegree_dvd (p := p) (n := n) hn hfmem⟩

end MathlibExpansion.FieldTheory.Finite
