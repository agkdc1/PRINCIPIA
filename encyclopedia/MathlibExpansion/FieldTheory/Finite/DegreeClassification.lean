import Mathlib.FieldTheory.Finite.GaloisField
import Mathlib.FieldTheory.IsAlgClosed.AlgebraicClosure

/-!
# Finite-field degree classification boundary

This chapter isolates Steinitz `FFC_05`: the degree-divisibility criterion for
membership in the finite subfield of size `p^n` inside an algebraic closure of
the prime field.

Primary source:
- E. Steinitz (1910), *Algebraische Theorie der Koerper*, `Sec. 15`,
  theorem `5`.
-/

noncomputable section

open scoped Classical

namespace MathlibExpansion.FieldTheory.Finite

variable (p n : ℕ) [Fact p.Prime]

open Polynomial IntermediateField

private lemma pow_prime_power_eq_self_of_pow_prime_power_eq_self
    {K : Type*} [Monoid K] {x : K} {p d k : ℕ}
    (h : x ^ p ^ d = x) :
    x ^ p ^ (d * k) = x := by
  induction k with
  | zero => simp
  | succ k ih =>
      rw [Nat.mul_succ, pow_add, pow_mul, ih, h]

private theorem finrank_adjoin_rootSet_X_pow_sub_X
    (hn : n ≠ 0) :
    Module.finrank (ZMod p)
      (IntermediateField.adjoin (ZMod p)
        ((Polynomial.X ^ p ^ n - Polynomial.X : Polynomial (ZMod p)).rootSet
          (AlgebraicClosure (ZMod p)))) = n := by
  let P : Polynomial (ZMod p) := Polynomial.X ^ p ^ n - Polynomial.X
  let L := AlgebraicClosure (ZMod p)
  let F : IntermediateField (ZMod p) L := IntermediateField.adjoin (ZMod p) (P.rootSet L)
  have hsplits : P.Splits (algebraMap (ZMod p) L) := IsAlgClosed.splits_codomain P
  haveI : IsSplittingField (ZMod p) F P :=
    IntermediateField.adjoin_rootSet_isSplittingField hsplits
  have hlin :
      Module.finrank (ZMod p) F = Module.finrank (ZMod p) P.SplittingField :=
    (Polynomial.IsSplittingField.algEquiv F P).toLinearEquiv.finrank_eq
  have hgf : Module.finrank (ZMod p) P.SplittingField = n := by
    simpa [P, GaloisField] using GaloisField.finrank p hn
  simpa [P, L, F] using hlin.trans hgf

private theorem pow_minpoly_natDegree_eq_self
    {x : AlgebraicClosure (ZMod p)} :
    x ^ p ^ (minpoly (ZMod p) x).natDegree = x := by
  let E : IntermediateField (ZMod p) (AlgebraicClosure (ZMod p)) :=
    IntermediateField.adjoin (ZMod p) ({x} : Set (AlgebraicClosure (ZMod p)))
  let y : E := ⟨x, IntermediateField.mem_adjoin_simple_self (ZMod p) x⟩
  have hxint : IsIntegral (ZMod p) x := Algebra.IsIntegral.isIntegral x
  haveI : FiniteDimensional (ZMod p) E := IntermediateField.adjoin.finiteDimensional hxint
  haveI : Finite E := Module.finite_of_finite (ZMod p)
  letI : Fintype E := Fintype.ofFinite E
  have hcard :
      Fintype.card E = p ^ (minpoly (ZMod p) x).natDegree := by
    simpa [E, ZMod.card, IntermediateField.adjoin.finrank hxint] using
      (card_eq_pow_finrank (K := ZMod p) (V := E))
  have hy : y ^ Fintype.card E = y := FiniteField.pow_card y
  have hy' : y ^ p ^ (minpoly (ZMod p) x).natDegree = y := by
    simpa [hcard] using hy
  exact congrArg Subtype.val hy'

/-- An element of the algebraic closure of the prime field lies in the degree
`n` finite subfield exactly when its minimal-polynomial degree divides `n`.
The positive-degree hypothesis is necessary: for `n = 0`, the polynomial
`X ^ p ^ n - X` is zero, so the root-set adjoin degenerates. -/
theorem mem_galoisField_iff_minpoly_degree_dvd
    (hn : n ≠ 0)
    {x : AlgebraicClosure (ZMod p)} :
    x ∈ (IntermediateField.adjoin (ZMod p)
      ((Polynomial.X ^ p ^ n - Polynomial.X : Polynomial (ZMod p)).rootSet
        (AlgebraicClosure (ZMod p)))) ↔
      (minpoly (ZMod p) x).natDegree ∣ n
    := by
  let P : Polynomial (ZMod p) := Polynomial.X ^ p ^ n - Polynomial.X
  let L := AlgebraicClosure (ZMod p)
  let F : IntermediateField (ZMod p) L := IntermediateField.adjoin (ZMod p) (P.rootSet L)
  constructor
  · intro hx
    have hsplits : P.Splits (algebraMap (ZMod p) L) := IsAlgClosed.splits_codomain P
    haveI : IsSplittingField (ZMod p) F P :=
      IntermediateField.adjoin_rootSet_isSplittingField hsplits
    haveI : FiniteDimensional (ZMod p) F :=
      Polynomial.IsSplittingField.finiteDimensional F P
    let y : F := ⟨x, by simpa [P, L, F] using hx⟩
    have hmin :
        (minpoly (ZMod p) x).natDegree =
          (minpoly (ZMod p) y).natDegree := by
      simpa [y] using congrArg Polynomial.natDegree
        (minpoly.algHom_eq F.val Subtype.val_injective y)
    have hdvd :
        (minpoly (ZMod p) y).natDegree ∣ Module.finrank (ZMod p) F :=
      minpoly.degree_dvd (IsIntegral.of_finite (ZMod p) y)
    rw [← hmin, finrank_adjoin_rootSet_X_pow_sub_X (p := p) (n := n) hn] at hdvd
    exact hdvd
  · rintro ⟨k, hk⟩
    have hxpow : x ^ p ^ n = x := by
      rw [hk]
      exact pow_prime_power_eq_self_of_pow_prime_power_eq_self
        (p := p) (d := (minpoly (ZMod p) x).natDegree) (k := k)
        (pow_minpoly_natDegree_eq_self (p := p) (x := x))
    have hroot : x ∈ P.rootSet L := by
      have hPne : P ≠ 0 := by
        simpa [P] using
          FiniteField.X_pow_card_pow_sub_X_ne_zero (ZMod p) hn
            (Fact.out : Nat.Prime p).one_lt
      rw [Polynomial.mem_rootSet_of_ne hPne]
      simp [P, L, map_sub, Polynomial.aeval_X_pow, Polynomial.aeval_X, hxpow]
    exact by
      simpa [P, L, F] using IntermediateField.subset_adjoin (ZMod p) (P.rootSet L) hroot

end MathlibExpansion.FieldTheory.Finite
