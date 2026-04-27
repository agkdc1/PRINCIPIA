import Mathlib.Computability.Primrec

/-!
# Bounded search wrapper for Gödel 1931 Proposition IV

This file isolates the exact bounded-search closure package used by the Gödel
1931 queue.
-/

namespace MathlibExpansion.Logic.Godel.PrimitiveRecursive

/--
Gödel 1931, *Über formal unentscheidbare Sätze der Principia Mathematica
und verwandter Systeme I*, Proposition IV: bounded existential quantification
preserves primitive recursiveness.  This wrapper is discharged from Mathlib's
primitive-recursive `Nat.findGreatest` bounded search.
-/
theorem primrec_boundedExists
    {α : Type*} [Primcodable α] {b : α → ℕ} {R : α → ℕ → Prop}
    [∀ a n, Decidable (R a n)] :
    Primrec b → PrimrecRel R → PrimrecPred (fun a => ∃ n ≤ b a, R a n) := by
  intro hb hR
  have hsearch : Primrec fun a => (b a).findGreatest (R a) :=
    Primrec.nat_findGreatest hb hR
  refine (hR.comp Primrec.id hsearch).of_eq ?_
  intro a
  constructor
  · intro h
    exact ⟨(b a).findGreatest (R a), Nat.findGreatest_le (P := R a) (b a), h⟩
  · rintro ⟨n, hnle, hnR⟩
    exact Nat.findGreatest_spec (P := R a) hnle hnR

/--
Gödel 1931, *Über formal unentscheidbare Sätze der Principia Mathematica
und verwandter Systeme I*, Proposition IV: bounded universal quantification
preserves primitive recursiveness.  It follows by applying the bounded
existential wrapper to the negated relation.
-/
theorem primrec_boundedForall
    {α : Type*} [Primcodable α] {b : α → ℕ} {R : α → ℕ → Prop}
    [∀ a n, Decidable (R a n)] :
    Primrec b → PrimrecRel R → PrimrecPred (fun a => ∀ n ≤ b a, R a n) := by
  intro hb hR
  have hnotR : PrimrecRel (fun a n => ¬ R a n) := by
    exact (Primrec.not.comp₂ hR).of_eq fun a n => by simp
  have hnone : PrimrecPred (fun a => ¬ ∃ n ≤ b a, ¬ R a n) :=
    (primrec_boundedExists (b := b) (R := fun a n => ¬ R a n) hb hnotR).not
  refine hnone.of_eq ?_
  intro a
  constructor
  · intro h n hn
    by_contra hnR
    exact h ⟨n, hn, hnR⟩
  · intro h
    rintro ⟨n, hn, hnR⟩
    exact hnR (h n hn)

/--
Gödel 1931, *Über formal unentscheidbare Sätze der Principia Mathematica
und verwandter Systeme I*, Proposition IV: bounded minimization with default
zero preserves primitive recursiveness.  The proof searches from the upper
bound downward with `Nat.findGreatest`, then converts the reversed greatest
witness back into the least bounded witness.
-/
theorem primrec_boundedMuZero
    {α : Type*} [Primcodable α] {b : α → ℕ} {R : α → ℕ → Prop}
    [∀ a n, Decidable (R a n)] :
    Primrec b → PrimrecRel R →
      Primrec fun a => if h : ∃ n ≤ b a, R a n then Nat.find h else 0 := by
  intro hb hR
  have hba : Primrec₂ (fun (a : α) (_ : ℕ) => b a) :=
    hb.comp₂ Primrec₂.left
  have hsub : Primrec₂ (fun (a : α) m => b a - m) :=
    Primrec.nat_sub.comp₂ hba Primrec₂.right
  have hq : PrimrecRel (fun a m => R a (b a - m)) :=
    hR.comp₂ Primrec₂.left hsub
  have hgreat : Primrec fun a => (b a).findGreatest (fun m => R a (b a - m)) :=
    Primrec.nat_findGreatest hb hq
  have hcandidate : Primrec fun a => b a - (b a).findGreatest (fun m => R a (b a - m)) :=
    Primrec.nat_sub.comp hb hgreat
  have hexists : PrimrecPred (fun a => ∃ n ≤ b a, R a n) :=
    primrec_boundedExists (b := b) (R := R) hb hR
  have hite : Primrec fun a =>
      if ∃ n ≤ b a, R a n then
        b a - (b a).findGreatest (fun m => R a (b a - m))
      else 0 :=
    Primrec.ite hexists hcandidate (Primrec.const 0)
  refine hite.of_eq fun a => ?_
  by_cases h : ∃ n ≤ b a, R a n
  · simp [h]
    let B := b a
    change B - Nat.findGreatest (fun m => R a (B - m)) B = Nat.find h
    let k := Nat.findGreatest (fun m => R a (B - m)) B
    change B - k = Nat.find h
    have hfind_spec := Nat.find_spec h
    have hfind_le : Nat.find h ≤ B := hfind_spec.1
    have hfind_R : R a (Nat.find h) := hfind_spec.2
    have hwitness_le : B - Nat.find h ≤ B := Nat.sub_le B (Nat.find h)
    have hwitness_R : R a (B - (B - Nat.find h)) := by
      have : B - (B - Nat.find h) = Nat.find h := by omega
      simpa [this] using hfind_R
    have hk_ge : B - Nat.find h ≤ k :=
      Nat.le_findGreatest (P := fun m => R a (B - m)) hwitness_le hwitness_R
    have hk_R : R a (B - k) :=
      Nat.findGreatest_spec (P := fun m => R a (B - m)) hwitness_le hwitness_R
    have hcandidate_le_find : B - k ≤ Nat.find h := by omega
    have hfind_le_candidate : Nat.find h ≤ B - k :=
      Nat.find_min' h ⟨Nat.sub_le B k, hk_R⟩
    exact le_antisymm hcandidate_le_find hfind_le_candidate
  · simp [h]

end MathlibExpansion.Logic.Godel.PrimitiveRecursive
