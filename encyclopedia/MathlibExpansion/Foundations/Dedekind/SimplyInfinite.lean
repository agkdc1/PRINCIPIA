import Mathlib.Data.Set.Basic
import Mathlib.Logic.Function.Basic
import Mathlib.Tactic.Common

/-!
# Dedekind simply infinite systems

This file packages the abstract successor-based substrate that Dedekind uses for the
natural numbers. The structure stays polymorphic in the carrier type and does not
specialize the induction principle to `ℕ`.
-/

namespace MathlibExpansion
namespace Foundations
namespace Dedekind

open Function Set

/-- A Dedekind-style simply infinite system. -/
structure SimplyInfiniteSystem (α : Type*) where
  zero : α
  succ : α → α
  succ_injective : Function.Injective succ
  zero_not_mem_range : zero ∉ Set.range succ
  induction :
    ∀ {s : Set α}, zero ∈ s → (∀ n : α, n ∈ s → succ n ∈ s) → s = Set.univ

/-- Dedekind's `Peano` alias: the same abstract simply infinite substrate. -/
abbrev Peano := SimplyInfiniteSystem

namespace SimplyInfiniteSystem

variable {α : Type*} (S : SimplyInfiniteSystem α)

theorem succ_ne_zero (a : α) : S.succ a ≠ S.zero := by
  intro h
  exact S.zero_not_mem_range ⟨a, h⟩

/-- The canonical enumeration obtained by iterating the successor from the base point. -/
def enumerate (S : SimplyInfiniteSystem α) : ℕ → α
  | 0 => S.zero
  | n + 1 => S.succ (S.enumerate n)

@[simp] theorem enumerate_zero : S.enumerate 0 = S.zero := rfl

@[simp] theorem enumerate_succ (n : ℕ) :
    S.enumerate (n + 1) = S.succ (S.enumerate n) := rfl

theorem enumerate_ne_zero_of_pos {n : ℕ} (hn : 0 < n) : S.enumerate n ≠ S.zero := by
  cases n with
  | zero =>
      cases Nat.lt_irrefl 0 hn
  | succ k =>
      simpa [SimplyInfiniteSystem.enumerate] using S.succ_ne_zero (S.enumerate k)

theorem enumerate_injective : Function.Injective S.enumerate := by
  intro m n h
  revert n
  induction m with
  | zero =>
      intro n h
      cases n with
      | zero =>
          rfl
      | succ k =>
          exfalso
          exact S.enumerate_ne_zero_of_pos (Nat.succ_pos _) h.symm
  | succ m ihm =>
      intro n h
      cases n with
      | zero =>
          exfalso
          exact S.enumerate_ne_zero_of_pos (Nat.succ_pos _) h
      | succ k =>
          have hk : S.enumerate m = S.enumerate k := by
            apply S.succ_injective
            simpa [SimplyInfiniteSystem.enumerate] using h
          exact congrArg Nat.succ (ihm hk)

theorem enumerate_surjective : Function.Surjective S.enumerate := by
  have hzero : S.zero ∈ Set.range S.enumerate := ⟨0, rfl⟩
  have hstep : ∀ a : α, a ∈ Set.range S.enumerate → S.succ a ∈ Set.range S.enumerate := by
    intro a ha
    rcases ha with ⟨n, rfl⟩
    exact ⟨n + 1, by simp [SimplyInfiniteSystem.enumerate]⟩
  have hrange : Set.range S.enumerate = Set.univ := S.induction hzero hstep
  intro a
  have ha : a ∈ Set.range S.enumerate := by
    rw [hrange]
    simp
  simpa [Set.mem_range] using ha

/-- The carrier of a simply infinite system is canonically equivalent to `ℕ`. -/
noncomputable def equivNat : α ≃ ℕ :=
  (Equiv.ofBijective S.enumerate ⟨S.enumerate_injective, S.enumerate_surjective⟩).symm

@[simp] theorem equivNat_symm_apply (n : ℕ) : S.equivNat.symm n = S.enumerate n := rfl

@[simp] theorem enumerate_equivNat (a : α) : S.enumerate (S.equivNat a) = a := by
  change S.equivNat.symm (S.equivNat a) = a
  exact S.equivNat.symm_apply_apply a

@[simp] theorem equivNat_zero : S.equivNat S.zero = 0 := by
  simpa using S.equivNat.apply_symm_apply 0

@[simp] theorem equivNat_succ (a : α) :
    S.equivNat (S.succ a) = S.equivNat a + 1 := by
  apply S.equivNat.symm.injective
  simp

@[simp] theorem equivNat_symm_succ (n : ℕ) :
    S.equivNat.symm (n + 1) = S.succ (S.equivNat.symm n) := by
  simp [SimplyInfiniteSystem.equivNat, SimplyInfiniteSystem.enumerate]

/-- Every nonzero element is the successor of a predecessor. -/
theorem exists_pred_of_ne_zero {n : α} (hn : n ≠ S.zero) :
    ∃ m, S.succ m = n := by
  have hzero : S.zero ∈ insert S.zero (Set.range S.succ) := by
    exact Or.inl rfl
  have hstep : ∀ m : α, m ∈ insert S.zero (Set.range S.succ) →
      S.succ m ∈ insert S.zero (Set.range S.succ) := by
    intro m _hm
    exact Or.inr ⟨m, rfl⟩
  have hs : insert S.zero (Set.range S.succ) = Set.univ := S.induction hzero hstep
  have hnrange : n ∈ Set.range S.succ := by
    have : n ∈ insert S.zero (Set.range S.succ) := by
      rw [hs]
      simp
    rcases this with rfl | hmem
    · exact False.elim (hn rfl)
    · exact hmem
  simpa [Set.mem_range] using hnrange

/-- Transport the standard simply infinite structure on `ℕ` across an equivalence. -/
noncomputable def ofNatEquiv (e : α ≃ ℕ) : SimplyInfiniteSystem α where
  zero := e.symm 0
  succ := fun a => e.symm (e a + 1)
  succ_injective := by
    intro a b h
    apply e.injective
    simpa using congrArg e h
  zero_not_mem_range := by
    rintro ⟨a, ha⟩
    have : e a + 1 = 0 := by simpa using congrArg e ha
    exact Nat.succ_ne_zero _ this
  induction := by
    intro s hzero hstep
    apply Set.eq_univ_of_forall
    intro a
    have hall : ∀ n : ℕ, e.symm n ∈ s := by
      intro n
      induction n with
      | zero =>
          simpa using hzero
      | succ n ihn =>
          simpa using hstep (e.symm n) ihn
    simpa using hall (e a)

end SimplyInfiniteSystem

end Dedekind
end Foundations
end MathlibExpansion
