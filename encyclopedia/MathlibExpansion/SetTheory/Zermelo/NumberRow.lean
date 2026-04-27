import Mathlib.Logic.Denumerable
import Mathlib.SetTheory.Cardinal.Basic
import Mathlib.SetTheory.ZFC.Basic
import MathlibExpansion.Foundations.Dedekind.SimplyInfinite
import MathlibExpansion.SetTheory.DedekindInfinite

/-!
# Zermelo's singleton-successor number row

This file formalizes the `1908` number-row lane using the successor
`a ↦ {a}` rather than the modern von Neumann successor.
-/

universe u

namespace MathlibExpansion.SetTheory.Zermelo

open ZFSet
open MathlibExpansion.Foundations.Dedekind

/-- Zermelo's singleton-successor iterate starting from `∅`. -/
def singletonIterate : ℕ → ZFSet.{u}
  | 0 => ∅
  | n + 1 => {singletonIterate n}

@[simp] theorem singletonIterate_zero : singletonIterate 0 = ∅ := rfl

@[simp] theorem singletonIterate_succ (n : ℕ) :
    singletonIterate (n + 1) = {singletonIterate n} := rfl

lemma singleton_ne_empty (x : ZFSet.{u}) : ({x} : ZFSet) ≠ ∅ := by
  intro hx
  have : x ∈ (∅ : ZFSet.{u}) := by
    simpa [hx] using (ZFSet.mem_singleton (x := x) (y := x)).2 rfl
  exact ZFSet.not_mem_empty x this

theorem singletonIterate_injective : Function.Injective singletonIterate := by
  intro m
  induction m with
  | zero =>
      intro n h
      cases n with
      | zero =>
          rfl
      | succ n =>
          exfalso
          exact singleton_ne_empty _ (by simpa using h.symm)
  | succ m ihm =>
      intro n h
      cases n with
      | zero =>
          exfalso
          exact singleton_ne_empty _ (by simpa using h)
      | succ n =>
          apply congrArg Nat.succ
          apply ihm
          exact ZFSet.singleton_injective (by simpa using h)

/-- The explicit singleton-successor witness used for Zermelo's infinity axiom. -/
noncomputable def numberRow : ZFSet.{u} :=
  ZFSet.mk <| PSet.mk (ULift ℕ) fun n => (singletonIterate n.down).out

theorem mem_numberRow_iff {x : ZFSet.{u}} :
    x ∈ numberRow ↔ ∃ n : ℕ, singletonIterate n = x := by
  constructor
  · intro hx
    rw [numberRow, ← ZFSet.mk_out x, ZFSet.mk_mem_iff] at hx
    rcases hx with ⟨n, hn⟩
    exact ⟨n.down, by simpa using (ZFSet.sound hn).symm⟩
  · rintro ⟨n, rfl⟩
    rw [numberRow, ← ZFSet.mk_out (singletonIterate n), ZFSet.mk_mem_iff]
    exact PSet.Mem.mk (fun n : ULift ℕ => (singletonIterate n.down).out) ⟨n⟩

theorem singletonIterate_mem_numberRow (n : ℕ) :
    singletonIterate n ∈ numberRow :=
  mem_numberRow_iff.mpr ⟨n, rfl⟩

/-- A `ZFSet` is singleton-inductive when it contains `∅` and is closed under
Zermelo's successor `a ↦ {a}`. -/
def IsSingletonInductive (Z : ZFSet.{u}) : Prop :=
  ∅ ∈ Z ∧ ∀ ⦃a : ZFSet.{u}⦄, a ∈ Z → ({a} : ZFSet) ∈ Z

theorem singletonIterate_mem_of_isSingletonInductive {Z : ZFSet.{u}}
    (hZ : IsSingletonInductive Z) : ∀ n : ℕ, singletonIterate n ∈ Z
  | 0 => hZ.1
  | n + 1 => hZ.2 (singletonIterate_mem_of_isSingletonInductive hZ n)

theorem numberRow_subset_of_isSingletonInductive {Z : ZFSet.{u}}
    (hZ : IsSingletonInductive Z) : numberRow ⊆ Z := by
  intro x hx
  rcases mem_numberRow_iff.mp hx with ⟨n, rfl⟩
  exact singletonIterate_mem_of_isSingletonInductive hZ n

theorem numberRow_isSingletonInductive : IsSingletonInductive numberRow := by
  refine ⟨singletonIterate_mem_numberRow 0, ?_⟩
  intro a ha
  rcases mem_numberRow_iff.mp ha with ⟨n, rfl⟩
  simpa using singletonIterate_mem_numberRow (n + 1)

theorem exists_singleton_inductive_zfset :
    ∃ Z : ZFSet.{u}, ∅ ∈ Z ∧ ∀ ⦃a : ZFSet.{u}⦄, a ∈ Z → ({a} : ZFSet) ∈ Z := by
  exact ⟨numberRow, numberRow_isSingletonInductive.1, numberRow_isSingletonInductive.2⟩

theorem exists_least_singleton_inductive_subset (Z : ZFSet.{u}) (hZ0 : ∅ ∈ Z)
    (hZs : ∀ ⦃a : ZFSet.{u}⦄, a ∈ Z → ({a} : ZFSet) ∈ Z) :
    ∃ Z0 : ZFSet.{u},
      Z0 ⊆ Z ∧
      ∅ ∈ Z0 ∧
      (∀ ⦃a : ZFSet.{u}⦄, a ∈ Z0 → ({a} : ZFSet) ∈ Z0) ∧
      ∀ Y : ZFSet.{u}, Y ⊆ Z → ∅ ∈ Y →
        (∀ ⦃a : ZFSet.{u}⦄, a ∈ Y → ({a} : ZFSet) ∈ Y) → Z0 ⊆ Y := by
  refine ⟨numberRow, numberRow_subset_of_isSingletonInductive ⟨hZ0, hZs⟩,
    numberRow_isSingletonInductive.1, numberRow_isSingletonInductive.2, ?_⟩
  intro Y _hYZ hY0 hYs
  exact numberRow_subset_of_isSingletonInductive ⟨hY0, hYs⟩

/-- The global canonical singleton-successor number row. -/
def IsZermeloNumberRow (Z0 : ZFSet.{u}) : Prop :=
  IsSingletonInductive Z0 ∧ ∀ Y : ZFSet.{u}, IsSingletonInductive Y → Z0 ⊆ Y

theorem numberRow_isZermeloNumberRow : IsZermeloNumberRow numberRow :=
  ⟨numberRow_isSingletonInductive, fun Y hY => numberRow_subset_of_isSingletonInductive hY⟩

theorem numberRow_eq_of_isZermeloNumberRow {Z0 : ZFSet.{u}}
    (hZ0 : IsZermeloNumberRow Z0) : Z0 = numberRow := by
  apply ZFSet.ext
  intro x
  constructor
  · intro hx
    exact hZ0.2 _ numberRow_isSingletonInductive hx
  · intro hx
    exact numberRow_isZermeloNumberRow.2 _ hZ0.1 hx

theorem exists_unique_numberRow :
    ∃! Z0 : ZFSet.{u},
      ∅ ∈ Z0 ∧
      (∀ ⦃a : ZFSet.{u}⦄, a ∈ Z0 → ({a} : ZFSet) ∈ Z0) ∧
      ∀ Y : ZFSet.{u}, ∅ ∈ Y → (∀ ⦃a : ZFSet.{u}⦄, a ∈ Y → ({a} : ZFSet) ∈ Y) → Z0 ⊆ Y := by
  refine ⟨numberRow, ?_, ?_⟩
  · exact ⟨numberRow_isSingletonInductive.1, numberRow_isSingletonInductive.2,
      fun Y hY0 hYs => numberRow_subset_of_isSingletonInductive ⟨hY0, hYs⟩⟩
  · intro Z0 hZ0
    exact numberRow_eq_of_isZermeloNumberRow
      ⟨⟨hZ0.1, hZ0.2.1⟩, fun Y hY => hZ0.2.2 _ hY.1 hY.2⟩

noncomputable def natEquivNumberRow : ℕ ≃ numberRow.toSet :=
  Equiv.ofBijective
    (fun n => ⟨singletonIterate n, singletonIterate_mem_numberRow n⟩)
    ⟨fun m n h => singletonIterate_injective (Subtype.ext_iff.mp h),
      fun x => by
        rcases mem_numberRow_iff.mp x.2 with ⟨n, hn⟩
        exact ⟨n, Subtype.ext hn⟩⟩

theorem zermeloNumberRow_nonempty_denumerable (Z0 : ZFSet.{u})
    (hZ0 : IsZermeloNumberRow Z0) :
    Nonempty (Denumerable Z0.toSet) := by
  refine ⟨Denumerable.mk' ?_⟩
  simpa [numberRow_eq_of_isZermeloNumberRow hZ0] using natEquivNumberRow.symm

theorem exists_subset_equiv_numberRow {α : Type*} {M : Set α} (hM : M.Infinite)
    (Z0 : ZFSet.{u}) (hZ0 : IsZermeloNumberRow Z0) :
    ∃ M0 : Set α, M0 ⊆ M ∧ Nonempty (M0 ≃ Z0.toSet) := by
  rcases MathlibExpansion.SetTheory.exists_simplyInfinite_subset hM with ⟨M0, hM0, hS⟩
  rcases hS with ⟨S⟩
  have hZEq : Z0.toSet ≃ ℕ := by
    simpa [numberRow_eq_of_isZermeloNumberRow hZ0] using natEquivNumberRow.symm
  exact ⟨M0, hM0, ⟨S.equivNat.trans hZEq.symm⟩⟩

theorem exists_countablyInfinite_subset {α : Type*} {M : Set α} (hM : M.Infinite) :
    ∃ M0 : Set α, M0 ⊆ M ∧ Countable M0 ∧ Infinite M0 := by
  rcases MathlibExpansion.SetTheory.exists_simplyInfinite_subset hM with ⟨M0, hM0, hS⟩
  rcases hS with ⟨S⟩
  have hden : Nonempty (Denumerable M0) := ⟨Denumerable.mk' S.equivNat⟩
  rcases nonempty_denumerable_iff.mp hden with ⟨hCount, hInf⟩
  exact ⟨M0, hM0, hCount, hInf⟩

end MathlibExpansion.SetTheory.Zermelo
