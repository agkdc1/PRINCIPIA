import Mathlib.FieldTheory.PurelyInseparable.Basic
import Mathlib.Algebra.CharP.IntermediateField

/-!
# Inseparability exponent boundary

This chapter is the owner surface for `SPI_EXPONENT`. Mathlib v4.17 contains
purely inseparable extensions, separable closures, and separable-degree APIs,
but not the textbook-facing element-level inseparability exponent interface
isolated by Steinitz.  We define that exponent as the least power supplied by
Mathlib's theorem that an algebraic extension is purely inseparable over its
separable closure.

Primary source:
- E. Steinitz (1910), *Algebraische Theorie der Koerper*, `Sec. 13-14`,
  especially `SPI_09`.

Formal substrate:
- `separableClosure.isPurelyInseparable`, Mathlib's formalization of Stacks
  Project, Tag 030K.
- `isPurelyInseparable_iff_pow_mem`, Mathlib's formalization of Stacks
  Project, Tag 09HE.
-/

noncomputable section

namespace MathlibExpansion.FieldTheory.PurelyInseparable

open IntermediateField

variable {F E : Type*} [Field F] [Field E] [Algebra F E]
variable (q : ℕ) [ExpChar F q] [Algebra.IsAlgebraic F E]

private theorem exists_pow_mem_separableClosure (x : E) :
    ∃ n : ℕ, x ^ (q ^ n) ∈ separableClosure F E := by
  let S : IntermediateField F E := separableClosure F E
  haveI : ExpChar S q := IntermediateField.expChar S q
  have hpow : ∃ n : ℕ, x ^ (q ^ n) ∈ (algebraMap S E).range :=
    IsPurelyInseparable.pow_mem S q x
  rcases hpow with ⟨n, y, hy⟩
  refine ⟨n, ?_⟩
  rw [← hy]
  exact y.2

/-- Steinitz's element-level inseparability exponent over the separable stage:
the least `n` such that `x^(q^n)` lies in `separableClosure F E`. -/
noncomputable def insepExponent
    (F : Type*) {E : Type*} [Field F] [Field E] [Algebra F E]
    (q : ℕ) [ExpChar F q] [Algebra.IsAlgebraic F E] (x : E) : ℕ := by
  classical
  exact Nat.find (exists_pow_mem_separableClosure (F := F) (E := E) q x)

/-- Raising an algebraic element to the `q^(e(x))` power lands in the separable
stage. -/
theorem pow_insepExponent_mem_separableClosure (x : E) :
    x ^ (q ^ insepExponent F q x) ∈ separableClosure F E := by
  classical
  simpa [insepExponent] using
    Nat.find_spec (exists_pow_mem_separableClosure (F := F) (E := E) q x)

private theorem pow_q_pow_sub_one_eq_pow_q_pow (x : E) {e : ℕ} (he : 0 < e) :
    (x ^ q) ^ (q ^ (e - 1)) = x ^ (q ^ e) := by
  calc
    (x ^ q) ^ (q ^ (e - 1)) = x ^ (q ^ ((e - 1) + 1)) := by
      rw [← pow_mul, pow_succ']
    _ = x ^ (q ^ e) := by
      rw [Nat.sub_add_cancel (Nat.succ_le_of_lt he)]

private theorem pow_q_pow_succ_eq (x : E) (n : ℕ) :
    (x ^ q) ^ (q ^ n) = x ^ (q ^ (n + 1)) := by
  rw [← pow_mul, pow_succ']

/-- One Frobenius step lowers the inseparability exponent by one. -/
theorem insepExponent_pow_eq_pred (x : E)
    (hx : 0 < insepExponent F q x) :
    insepExponent F q (x ^ q) + 1 =
      insepExponent F q x := by
  classical
  have hy_mem :
      (x ^ q) ^ (q ^ (insepExponent F q x - 1)) ∈ separableClosure F E := by
    simpa [pow_q_pow_sub_one_eq_pow_q_pow (q := q) x hx] using
      pow_insepExponent_mem_separableClosure (F := F) (E := E) q x
  have h_upper : insepExponent F q (x ^ q) ≤ insepExponent F q x - 1 := by
    simpa [insepExponent] using
      Nat.find_min' (exists_pow_mem_separableClosure (F := F) (E := E) q (x ^ q)) hy_mem
  have hy_spec :
      (x ^ q) ^ (q ^ insepExponent F q (x ^ q)) ∈ separableClosure F E :=
    pow_insepExponent_mem_separableClosure (F := F) (E := E) q (x ^ q)
  have hx_from_y :
      x ^ (q ^ (insepExponent F q (x ^ q) + 1)) ∈ separableClosure F E := by
    simpa [pow_q_pow_succ_eq (q := q) x (insepExponent F q (x ^ q))] using hy_spec
  have hnot_lt : ¬ insepExponent F q (x ^ q) + 1 < insepExponent F q x := by
    intro hlt
    exact (Nat.find_min (exists_pow_mem_separableClosure (F := F) (E := E) q x)
      (by simpa [insepExponent] using hlt)) hx_from_y
  have h_lower : insepExponent F q x - 1 ≤ insepExponent F q (x ^ q) := by
    have hle : insepExponent F q x ≤ insepExponent F q (x ^ q) + 1 :=
      Nat.le_of_not_lt hnot_lt
    omega
  have h_eq : insepExponent F q (x ^ q) = insepExponent F q x - 1 :=
    le_antisymm h_upper h_lower
  rw [h_eq]
  exact Nat.sub_add_cancel (Nat.succ_le_of_lt hx)

end MathlibExpansion.FieldTheory.PurelyInseparable
