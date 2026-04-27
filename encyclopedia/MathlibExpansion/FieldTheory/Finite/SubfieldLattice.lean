import Mathlib.FieldTheory.Finite.GaloisField
import Mathlib.Algebra.Field.Subfield.Basic

/-!
# Finite subfield lattice boundary

This chapter isolates the finite-subfield lattice package split out of Steinitz
`Sec. 15`: uniqueness of finite subfields inside an ambient field, divisor
closure, divisor classification, and lcm closure.

The existence/uniqueness headline for finite fields is already upstream. The
actual ambient lattice statements are not exported as a dedicated API, so we
record them here as narrow sibling-library boundaries.

Primary source:
- E. Steinitz (1910), *Algebraische Theorie der Koerper*, `Sec. 15`,
  theorems `2`-`5` and `8`.
-/

noncomputable section

open scoped Classical

namespace MathlibExpansion.FieldTheory.Finite

variable {K : Type*} [Field K]
variable {p n : ℕ} [Fact p.Prime]

private lemma subfield_set_card_eq (A : Subfield K) [Fintype A] :
    Fintype.card (A : Set K) = Fintype.card A := by
  let e : A ≃ (A : Set K) :=
    { toFun := fun x => ⟨x, x.2⟩
      invFun := fun x => ⟨x, x.2⟩
      left_inv := fun x => rfl
      right_inv := fun x => rfl }
  exact Fintype.card_congr e.symm

private lemma mem_rootSet_of_mem_subfield (A : Subfield K) [Fintype A]
    (hA : Fintype.card A = p ^ n) (hn : n ≠ 0) (x : K) (hx : x ∈ A) :
    x ∈ (Polynomial.X ^ p ^ n - Polynomial.X : Polynomial K).rootSet K := by
  have hpnonzero : (Polynomial.X ^ p ^ n - Polynomial.X : Polynomial K) ≠ 0 :=
    FiniteField.X_pow_card_pow_sub_X_ne_zero K hn (Fact.out : Nat.Prime p).one_lt
  rw [Polynomial.mem_rootSet_of_ne hpnonzero]
  simp only [Polynomial.aeval_X_pow, Polynomial.aeval_X, map_sub, sub_eq_zero]
  let xa : A := ⟨x, hx⟩
  have hpowA : xa ^ Fintype.card A = xa := FiniteField.pow_card xa
  have hpowK : (x : K) ^ Fintype.card A = x := congrArg Subtype.val hpowA
  simpa [hA] using hpowK

private lemma card_rootSet_le (hn : n ≠ 0) :
    Fintype.card ((Polynomial.X ^ p ^ n - Polynomial.X : Polynomial K).rootSet K) ≤ p ^ n := by
  have hdeg : (Polynomial.X ^ p ^ n - Polynomial.X : Polynomial K).natDegree = p ^ n :=
    FiniteField.X_pow_card_pow_sub_X_natDegree_eq K hn (Fact.out : Nat.Prime p).one_lt
  calc
    Fintype.card ((Polynomial.X ^ p ^ n - Polynomial.X : Polynomial K).rootSet K)
        = ((Polynomial.X ^ p ^ n - Polynomial.X : Polynomial K).roots.toFinset.card) := by
          simp [Polynomial.rootSet_def, Polynomial.aroots_def]
    _ ≤ ((Polynomial.X ^ p ^ n - Polynomial.X : Polynomial K).roots.card) :=
        Multiset.toFinset_card_le _
    _ ≤ (Polynomial.X ^ p ^ n - Polynomial.X : Polynomial K).natDegree :=
        Polynomial.card_roots' _
    _ = p ^ n := hdeg

private lemma subfield_eq_rootSet_of_card (A : Subfield K) [Fintype A]
    (hA : Fintype.card A = p ^ n) (hn : n ≠ 0) :
    (A : Set K) = (Polynomial.X ^ p ^ n - Polynomial.X : Polynomial K).rootSet K := by
  let roots : Set K := (Polynomial.X ^ p ^ n - Polynomial.X : Polynomial K).rootSet K
  have hsub : (A : Set K) ⊆ roots := by
    intro x hx
    exact mem_rootSet_of_mem_subfield (p := p) (n := n) A hA hn x hx
  have hrootsFinite : roots.Finite := Set.toFinite roots
  apply hrootsFinite.eq_of_subset_of_card_le hsub
  rw [Nat.card_eq_fintype_card, Nat.card_eq_fintype_card]
  rw [subfield_set_card_eq A, hA]
  exact card_rootSet_le (K := K) (p := p) (n := n) hn

/-- Inside a fixed ambient field, there is at most one finite subfield of a
given cardinality `p^n`.

Primary source: E. Steinitz (1910), *Algebraische Theorie der Koerper*,
`Sec. 15`, theorem `2`, printed p. 247. -/
theorem finiteSubfield_unique_of_card_eq [CharP K p]
    (A B : Subfield K) [Fintype A] [Fintype B]
    (hA : Fintype.card A = p ^ n) (hB : Fintype.card B = p ^ n) :
    A = B := by
  have hn : n ≠ 0 := by
    intro hn0
    have hcardA1 : Fintype.card A = 1 := by simpa [hn0] using hA
    have hgt : 1 < Fintype.card A := Fintype.one_lt_card
    exact (Nat.lt_irrefl 1) (hcardA1 ▸ hgt)
  apply Subfield.ext
  intro x
  have hAroot := subfield_eq_rootSet_of_card (K := K) (p := p) (n := n) A hA hn
  have hBroot := subfield_eq_rootSet_of_card (K := K) (p := p) (n := n) B hB hn
  rw [show x ∈ A ↔ x ∈ (A : Set K) from Iff.rfl, hAroot,
    show x ∈ B ↔ x ∈ (B : Set K) from Iff.rfl, hBroot]

variable [CharP K p]

open Polynomial

private lemma X_pow_sub_X_eq_X_mul (R : Type*) [CommRing R] {m : ℕ} (hm : 0 < m) :
    (X ^ m - X : R[X]) = X * (X ^ (m - 1) - 1) := by
  calc
    (X ^ m - X : R[X]) = X ^ (m - 1 + 1) - X := by
      rw [Nat.sub_add_cancel hm]
    _ = X * X ^ (m - 1) - X * 1 := by
      rw [pow_succ']
      simp
    _ = X * (X ^ (m - 1) - 1) := by
      rw [mul_sub]

private lemma X_pow_pow_sub_X_dvd_of_dvd
    {d n : ℕ} (hd : d ∣ n) :
    (X ^ p ^ d - X : (ZMod p)[X]) ∣ (X ^ p ^ n - X : (ZMod p)[X]) := by
  rcases hd with ⟨k, rfl⟩
  have hpd_pos : 0 < p ^ d := pow_pos (Fact.out : Nat.Prime p).pos d
  have hpn_pos : 0 < p ^ (d * k) := pow_pos (Fact.out : Nat.Prime p).pos (d * k)
  rw [X_pow_sub_X_eq_X_mul (ZMod p) hpd_pos, X_pow_sub_X_eq_X_mul (ZMod p) hpn_pos]
  apply mul_dvd_mul_left
  have hnat : p ^ d - 1 ∣ p ^ (d * k) - 1 :=
    nat_pow_one_sub_dvd_pow_mul_sub_one p d k
  rcases hnat with ⟨q, hq⟩
  rw [hq]
  exact pow_one_sub_dvd_pow_mul_sub_one (X : (ZMod p)[X]) (p ^ d - 1) q

private def fixedPowSubfield (d : ℕ) : Subfield K where
  carrier := {x : K | x ^ p ^ d = x}
  zero_mem' := by
    have hpos : 0 < p ^ d := pow_pos (Fact.out : Nat.Prime p).pos d
    simp [hpos.ne']
  one_mem' := by simp
  add_mem' := by
    intro x y hx hy
    change (x + y) ^ p ^ d = x + y
    rw [add_pow_char_pow, hx, hy]
  neg_mem' := by
    intro x hx
    change (-x) ^ p ^ d = -x
    rw [neg_pow, hx, neg_one_pow_char_pow]
    simp
  mul_mem' := by
    intro x y hx hy
    change (x * y) ^ p ^ d = x * y
    rw [mul_pow, hx, hy]
  inv_mem' := by
    intro x hx
    by_cases hx0 : x = 0
    · subst x
      have hpos : 0 < p ^ d := pow_pos (Fact.out : Nat.Prime p).pos d
      simp [hpos.ne']
    · change (x⁻¹) ^ p ^ d = x⁻¹
      rw [inv_pow, hx]

private theorem fixedPowSubfield_card [Fintype K] [Algebra (ZMod p) K] {d : ℕ}
    (hd0 : d ≠ 0)
    (hsplits : (X ^ p ^ d - X : (ZMod p)[X]).Splits (algebraMap (ZMod p) K)) :
    Fintype.card (fixedPowSubfield (K := K) (p := p) d) = p ^ d := by
  let P : Polynomial (ZMod p) := X ^ p ^ d - X
  have hp : 1 < p := (Fact.out : Nat.Prime p).one_lt
  have hPne : P ≠ 0 := by
    simpa [P] using FiniteField.X_pow_card_pow_sub_X_ne_zero (ZMod p) hd0 hp
  have hcarrier :
      ((fixedPowSubfield (K := K) (p := p) d : Subfield K) : Set K) = P.rootSet K := by
    ext x
    change (x ^ p ^ d = x) ↔ x ∈ P.rootSet K
    rw [Polynomial.mem_rootSet_of_ne hPne]
    simp [fixedPowSubfield, P, sub_eq_zero]
  let e : fixedPowSubfield (K := K) (p := p) d ≃ P.rootSet K :=
    { toFun := fun x => ⟨x.1, by
        rw [← hcarrier]
        exact x.2⟩
      invFun := fun x => ⟨x.1, by
        change (x.1 : K) ∈
          ((fixedPowSubfield (K := K) (p := p) d : Subfield K) : Set K)
        rw [hcarrier]
        exact x.2⟩
      left_inv := fun _ => rfl
      right_inv := fun _ => rfl }
  have hcard_root : Fintype.card (P.rootSet K) = P.natDegree := by
    have hsep : P.Separable := by
      simpa [P] using
        (galois_poly_separable (K := ZMod p) p (p ^ d) (dvd_pow (dvd_refl p) hd0))
    simpa [P] using card_rootSet_eq_natDegree hsep hsplits
  calc
    Fintype.card (fixedPowSubfield (K := K) (p := p) d) =
        Fintype.card (P.rootSet K) := Fintype.card_congr e
    _ = P.natDegree := hcard_root
    _ = p ^ d := by
      simpa [P] using FiniteField.X_pow_card_pow_sub_X_natDegree_eq (ZMod p) hd0 hp

/-- Divisor degrees occur as actual finite subfields inside a finite field.

Primary source: E. Steinitz (1910), *Algebraische Theorie der Koerper*,
`Sec. 15`, theorem `3`, printed p. 247. Discharged here from the
splitting-field characterization of finite fields and the root set of
`X^(p^d)-X`. -/
theorem exists_subfield_card_pow_of_dvd [Fintype K]
    (hK : Fintype.card K = p ^ n) {d : ℕ} (hd : d ∣ n) :
    ∃ S : Subfield K, ∃ _ : Fintype S, Fintype.card S = p ^ d := by
  haveI : Algebra (ZMod p) K := ZMod.algebra K p
  have hn0 : n ≠ 0 := by
    intro hn
    have hcard : Fintype.card K = 1 := by simpa [hn] using hK
    exact (Nat.lt_irrefl 1) (hcard ▸ Fintype.one_lt_card)
  have hd0 : d ≠ 0 := by
    intro hd0
    rcases hd with ⟨k, hk⟩
    have hn : n = 0 := by simpa [hd0] using hk
    exact hn0 hn
  have hPn_splits : (X ^ p ^ n - X : (ZMod p)[X]).Splits (algebraMap (ZMod p) K) :=
    (FiniteField.isSplittingField_of_card_eq (p := p) (n := n) hK).splits
  have hPd_splits : (X ^ p ^ d - X : (ZMod p)[X]).Splits (algebraMap (ZMod p) K) := by
    exact Polynomial.splits_of_splits_of_dvd
      (algebraMap (ZMod p) K)
      (FiniteField.X_pow_card_pow_sub_X_ne_zero (ZMod p) hn0 (Fact.out : Nat.Prime p).one_lt)
      hPn_splits
      (X_pow_pow_sub_X_dvd_of_dvd (p := p) hd)
  let S : Subfield K := fixedPowSubfield (K := K) (p := p) d
  refine ⟨S, inferInstance, ?_⟩
  exact fixedPowSubfield_card (K := K) (p := p) hd0 hPd_splits

private noncomputable def finiteSubfieldDegree (S : Subfield K) [Finite S] : ℕ :=
  letI : Fintype S := Fintype.ofFinite S
  letI : CharP S p := RingHom.charP S.subtype S.subtype.injective p
  (Classical.choose (FiniteField.card S p) : ℕ+)

omit [Fact p.Prime] in
private theorem finiteSubfieldDegree_card_eq_canonical (S : Subfield K) [Finite S] :
    @Fintype.card S (Fintype.ofFinite S) = p ^ finiteSubfieldDegree (p := p) S := by
  letI : Fintype S := Fintype.ofFinite S
  letI : CharP S p := RingHom.charP S.subtype S.subtype.injective p
  unfold finiteSubfieldDegree
  exact (Classical.choose_spec (FiniteField.card S p)).2

omit [Fact p.Prime] in
private theorem finiteSubfieldDegree_card_eq_of_fintype (S : Subfield K) [Finite S]
    [instS : Fintype S] :
    Fintype.card S = p ^ finiteSubfieldDegree (p := p) S := by
  have hcard : @Fintype.card S instS = @Fintype.card S (Fintype.ofFinite S) := by
    exact @Fintype.card_congr S S instS (Fintype.ofFinite S) (Equiv.refl S)
  exact hcard.trans (finiteSubfieldDegree_card_eq_canonical (K := K) (p := p) S)

/-- The cardinal degree of any finite subfield of `E_(p,n)` divides `n`.

Primary source: E. Steinitz (1910), *Algebraische Theorie der Koerper*,
`Sec. 15`, theorem `4`, printed p. 247. Discharged here by viewing the
ambient field as a finite vector space over the subfield. -/
theorem finiteSubfieldDegree_dvd_of_card_eq [Fintype K]
    (hK : Fintype.card K = p ^ n) (S : Subfield K) [Finite S] :
    finiteSubfieldDegree (p := p) S ∣ n := by
  letI : Fintype S := Fintype.ofFinite S
  have hS : Fintype.card S = p ^ finiteSubfieldDegree (p := p) S := by
    simpa using finiteSubfieldDegree_card_eq_of_fintype (K := K) (p := p) S
  have hcardKS : Fintype.card K = Fintype.card S ^ Module.finrank S K := by
    simpa using (card_eq_pow_finrank (K := S) (V := K))
  have hpow :
      p ^ n = p ^ (finiteSubfieldDegree (p := p) S * Module.finrank S K) := by
    calc
      p ^ n = Fintype.card K := hK.symm
      _ = Fintype.card S ^ Module.finrank S K := hcardKS
      _ = (p ^ finiteSubfieldDegree (p := p) S) ^ Module.finrank S K := by rw [hS]
      _ = p ^ (finiteSubfieldDegree (p := p) S * Module.finrank S K) := by
        rw [pow_mul]
  exact ⟨Module.finrank S K,
    Nat.pow_right_injective (Fact.out : Nat.Prime p).one_lt hpow⟩

/-- The finite subfields of `E_(p,n)` are classified by the divisors of `n`.

Primary source: E. Steinitz (1910), *Algebraische Theorie der Koerper*,
`Sec. 15`, theorem `4`, printed p. 247. -/
theorem finiteField_subfieldDegrees_equiv_divisors [Fintype K]
    (hK : Fintype.card K = p ^ n) :
    Nonempty ({S : Subfield K // Finite S} ≃ {d : ℕ // d ∣ n}) := by
  refine ⟨?_⟩
  refine
    { toFun := fun S =>
        haveI : Finite S.1 := S.2
        ⟨finiteSubfieldDegree (p := p) S.1,
          finiteSubfieldDegree_dvd_of_card_eq (p := p) hK S.1⟩
      invFun := fun d =>
        let S : Subfield K := Classical.choose (exists_subfield_card_pow_of_dvd (p := p) hK d.2)
        ⟨S, by
          rcases Classical.choose_spec (exists_subfield_card_pow_of_dvd (p := p) hK d.2) with
            ⟨instS, _hS⟩
          exact @Finite.of_fintype S instS⟩
      left_inv := ?_
      right_inv := ?_ }
  · intro S
    apply Subtype.ext
    dsimp
    haveI : Finite S.1 := S.2
    let d := finiteSubfieldDegree (p := p) S.1
    let T : Subfield K :=
      Classical.choose (exists_subfield_card_pow_of_dvd (p := p) hK
        (finiteSubfieldDegree_dvd_of_card_eq (p := p) hK S.1))
    have hTspec := Classical.choose_spec
      (exists_subfield_card_pow_of_dvd (p := p) hK
        (finiteSubfieldDegree_dvd_of_card_eq (p := p) hK S.1))
    rcases hTspec with ⟨instT, hTcard⟩
    letI : Fintype T := instT
    haveI : Fintype S.1 := Fintype.ofFinite S.1
    have hScard : Fintype.card S.1 = p ^ d := by
      simpa [d] using finiteSubfieldDegree_card_eq_of_fintype (K := K) (p := p) S.1
    exact finiteSubfield_unique_of_card_eq (p := p) (n := d) T S.1 hTcard hScard
  · intro d
    apply Subtype.ext
    dsimp
    let T : Subfield K :=
      Classical.choose (exists_subfield_card_pow_of_dvd (p := p) hK d.2)
    have hTspec := Classical.choose_spec
      (exists_subfield_card_pow_of_dvd (p := p) hK d.2)
    rcases hTspec with ⟨instT, hTcard⟩
    letI : Fintype T := instT
    haveI : Finite T := @Finite.of_fintype T instT
    have hTdegCard : Fintype.card T = p ^ finiteSubfieldDegree (p := p) T := by
      simpa using finiteSubfieldDegree_card_eq_of_fintype (K := K) (p := p) T
    have hdeg : finiteSubfieldDegree (p := p) T = d.1 := by
      exact Nat.pow_right_injective (Fact.out : Nat.Prime p).one_lt
        (hTdegCard.symm.trans hTcard)
    exact hdeg

/-- Finite subfields are closed under least common multiples of degrees.

Primary source: E. Steinitz (1910), *Algebraische Theorie der Koerper*,
`Sec. 15`, theorem `8`, printed p. 248. -/
axiom exists_subfield_card_pow_of_lcm
    {n1 n2 : ℕ}
    (h1 : ∃ S1 : Subfield K, ∃ _ : Fintype S1, Fintype.card S1 = p ^ n1)
    (h2 : ∃ S2 : Subfield K, ∃ _ : Fintype S2, Fintype.card S2 = p ^ n2) :
    ∃ S : Subfield K, ∃ _ : Fintype S, Fintype.card S = p ^ Nat.lcm n1 n2

end MathlibExpansion.FieldTheory.Finite
