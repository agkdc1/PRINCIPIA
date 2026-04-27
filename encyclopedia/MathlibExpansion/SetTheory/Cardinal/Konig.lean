import Mathlib.SetTheory.Cardinal.Basic

/-!
# Zermelo's theorem-34 König corollary

This file packages the self-family corollary that Zermelo states immediately
after the general `sum_lt_prod` theorem.
-/

namespace MathlibExpansion.SetTheory.Cardinal

open Function

theorem prod_comp_embedding_le {ι : Type*} (f : ι → Cardinal) (e : ι ↪ ι)
    (h0 : ∀ i, f i ≠ 0) :
    Cardinal.prod (fun i => f (e i)) ≤ Cardinal.prod f := by
  classical
  have hrange' :
      Cardinal.mk (∀ i : ι, (f (e i)).out) =
        Cardinal.mk (∀ j : Set.range e, (f j.1).out) := by
    exact Cardinal.mk_pi_congr (Equiv.ofInjective e e.injective) (fun _ => by rfl)
  have hrange :
      Cardinal.prod (fun i => f (e i)) =
        Cardinal.mk (∀ j : Set.range e, (f j.1).out) := by
    simpa only [Cardinal.prod] using hrange'
  let default : ∀ i, (f i).out := fun i =>
    Classical.choice <| Cardinal.mk_ne_zero_iff.mp (by
      rw [Cardinal.mk_out]
      exact h0 i)
  let extend :
      (∀ j : Set.range e, (f j.1).out) → ∀ i, (f i).out := fun x i =>
        if hi : i ∈ Set.range e then x ⟨i, hi⟩
        else default i
  let restrict :
      (∀ i, (f i).out) → ∀ j : Set.range e, (f j.1).out := fun g j => g j.1
  have hle : Cardinal.mk (∀ j : Set.range e, (f j.1).out) ≤ Cardinal.prod f := by
    unfold Cardinal.prod
    exact Cardinal.mk_le_of_injective (fun x y hxy => by
      ext j
      have hjmem : j.1 ∈ Set.range e := j.2
      have hjex : ∃ z, e z = j.1 := j.2
      have hj' : extend x j.1 = extend y j.1 := congr_fun hxy j.1
      have hj'' : x ⟨j.1, hjmem⟩ = y ⟨j.1, hjmem⟩ := by
        simpa [extend, hjex] using hj'
      simpa using hj'')
  exact hrange.le.trans hle

theorem zermelo_nr34_konig_corollary {ι : Type*} (f : ι → Cardinal) (e : ι ↪ ι)
    (h : ∀ i, f i < f (e i)) (h0 : Cardinal.prod f ≠ 0) :
    Cardinal.sum f < Cardinal.prod f := by
  have hsum : Cardinal.sum f < Cardinal.prod (fun i => f (e i)) :=
    Cardinal.sum_lt_prod f (fun i => f (e i)) h
  exact hsum.trans_le <| prod_comp_embedding_le f e ((Cardinal.prod_ne_zero _).mp h0)

end MathlibExpansion.SetTheory.Cardinal
