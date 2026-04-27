import Mathlib

/-!
# Boole 1854 Boolean formulas

This is the owner layer for the Boole 1854 breach. A formula is represented
extensionally by the finite set of truth assignments on which it holds. This
keeps the syntax unique across the textbook-local stack while still exposing
evaluation into any Boolean algebra.
-/

namespace MathlibExpansion
namespace Textbooks
namespace Boole1854

/-- A Boolean valuation of the variables indexed by `ι`. -/
abbrev Assignment (ι : Type*) := ι → Bool

/-- A finite Boolean formula, represented by the valuations that satisfy it. -/
abbrev BooleanFormula (ι : Type*) := Finset (Assignment ι)

section Core

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- Truth-table semantics for the extensional formula representation. -/
def Holds (φ : BooleanFormula ι) (σ : Assignment ι) : Prop :=
  σ ∈ φ

/-- Bool-valued truth-table semantics. -/
def truthValue (φ : BooleanFormula ι) (σ : Assignment ι) : Bool :=
  decide (σ ∈ φ)

/-- The atomic formula selecting the assignments on which variable `i` is true. -/
def var (i : ι) : BooleanFormula ι :=
  Finset.univ.filter fun σ => σ i = true

/-- Specialize a formula by fixing variable `i` to the Boolean value `b`. -/
def specialize (i : ι) (b : Bool) (φ : BooleanFormula ι) : BooleanFormula ι :=
  Finset.univ.filter fun σ => Function.update σ i b ∈ φ

/-- Boole's eliminant `f(1) f(0)` at the level of satisfying valuations. -/
def eliminate (i : ι) (φ : BooleanFormula ι) : BooleanFormula ι :=
  specialize i true φ ⊓ specialize i false φ

/-- The coefficient of the constituent indexed by `σ`. -/
def coefficient (φ : BooleanFormula ι) (σ : Assignment ι) : Bool :=
  truthValue φ σ

theorem mem_var_iff (i : ι) (σ : Assignment ι) :
    σ ∈ var i ↔ σ i = true := by
  simp [var]

theorem truthValue_eq_true_iff (φ : BooleanFormula ι) (σ : Assignment ι) :
    truthValue φ σ = true ↔ σ ∈ φ := by
  simp [truthValue]

theorem coefficient_eq_truthValue (φ : BooleanFormula ι) (σ : Assignment ι) :
    coefficient φ σ = truthValue φ σ :=
  rfl

theorem mem_specialize_iff (i : ι) (b : Bool) (φ : BooleanFormula ι) (σ : Assignment ι) :
    σ ∈ specialize i b φ ↔ Function.update σ i b ∈ φ := by
  simp [specialize]

theorem mem_eliminate_iff (i : ι) (φ : BooleanFormula ι) (σ : Assignment ι) :
    σ ∈ eliminate i φ ↔
      Function.update σ i true ∈ φ ∧ Function.update σ i false ∈ φ := by
  simp [eliminate, mem_specialize_iff]

end Core

section BooleanAlgebra

variable {ι α : Type*} [Fintype ι] [DecidableEq ι] [BooleanAlgebra α]

/-- The literal selected by valuation `σ` at variable `i`. -/
def literal (v : ι → α) (σ : Assignment ι) (i : ι) : α :=
  if σ i then v i else (v i)ᶜ

/-- The constituent/minterm indexed by valuation `σ`. -/
def minterm (v : ι → α) (σ : Assignment ι) : α :=
  Finset.univ.inf fun i => literal v σ i

/-- The dual maxterm indexed by valuation `σ`. -/
def maxterm (v : ι → α) (σ : Assignment ι) : α :=
  (minterm v σ)ᶜ

/-- Evaluate an extensional Boolean formula in a Boolean algebra by summing its constituents. -/
def eval (v : ι → α) (φ : BooleanFormula ι) : α :=
  φ.sup (minterm v)

theorem minterm_le_literal (v : ι → α) (σ : Assignment ι) (i : ι) :
    minterm v σ ≤ literal v σ i :=
  Finset.inf_le (by simp)

theorem inf_minterm_eq_ite (v : ι → α) (σ : Assignment ι) (i : ι) :
    v i ⊓ minterm v σ = if σ i then minterm v σ else ⊥ := by
  by_cases h : σ i
  · rw [if_pos h]
    exact inf_eq_right.mpr (by simpa [literal, h] using minterm_le_literal v σ i)
  · rw [if_neg h]
    refine le_bot_iff.mp ?_
    calc
      v i ⊓ minterm v σ ≤ v i ⊓ (v i)ᶜ := by
        gcongr
        simpa [literal, h] using minterm_le_literal v σ i
      _ = ⊥ := inf_compl_eq_bot

theorem minterm_disjoint (v : ι → α) {σ τ : Assignment ι} (hστ : σ ≠ τ) :
    Disjoint (minterm v σ) (minterm v τ) := by
  classical
  obtain ⟨i, hi⟩ : ∃ i, σ i ≠ τ i := by
    by_contra h
    apply hστ
    funext j
    by_contra hj
    exact h ⟨j, hj⟩
  rw [disjoint_iff]
  refine le_antisymm ?_ bot_le
  calc
    minterm v σ ⊓ minterm v τ ≤ literal v σ i ⊓ literal v τ i := by
      exact inf_le_inf (minterm_le_literal v σ i) (minterm_le_literal v τ i)
    _ = ⊥ := by
      cases hs : σ i <;> cases ht : τ i <;> simp [literal, hs, ht] at hi ⊢

/-- The minterms cut out by a finite Boolean valuation partition `⊤`. -/
theorem minterms_sup_univ_eq_top (v : ι → α) :
    (Finset.univ : Finset (Assignment ι)).sup (minterm v) = ⊤ := by
  classical
  let choices : Finset (∀ i, i ∈ (Finset.univ : Finset ι) → Bool) :=
    (Finset.univ : Finset ι).pi fun _ => (Finset.univ : Finset Bool)
  let choiceMinterm (g : ∀ i, i ∈ (Finset.univ : Finset ι) → Bool) : α :=
    (Finset.univ : Finset ι).attach.inf fun i =>
      if g i i.2 then v i else (v i)ᶜ
  have hChoicesTop : choices.sup choiceMinterm = ⊤ := by
    have hDistrib :=
      Finset.inf_sup (α := α) (s := (Finset.univ : Finset ι))
        (t := fun _ => (Finset.univ : Finset Bool))
        (f := fun i b => if b then v i else (v i)ᶜ)
    have hLeft :
        (Finset.univ : Finset ι).inf
            (fun i => (Finset.univ : Finset Bool).sup
              fun b => if b then v i else (v i)ᶜ) = ⊤ := by
      simp
    exact hDistrib ▸ hLeft
  have hAssignments :
      (Finset.univ : Finset (Assignment ι)).sup (minterm v) =
        choices.sup choiceMinterm := by
    apply le_antisymm
    · rw [Finset.sup_le_iff]
      intro σ hσ
      let g : ∀ i, i ∈ (Finset.univ : Finset ι) → Bool := fun i _ => σ i
      have hg : g ∈ choices := by
        simp [choices, g]
      calc
        minterm v σ = choiceMinterm g := by
          simpa [minterm, literal, choiceMinterm, g] using
            (Finset.inf_attach (s := (Finset.univ : Finset ι))
              (f := fun i => if σ i then v i else (v i)ᶜ)).symm
        _ ≤ choices.sup choiceMinterm := Finset.le_sup hg
    · rw [Finset.sup_le_iff]
      intro g hg
      let σ : Assignment ι := fun i => g i (Finset.mem_univ i)
      have hσ : σ ∈ (Finset.univ : Finset (Assignment ι)) := by
        simp
      calc
        choiceMinterm g = minterm v σ := by
          simpa [minterm, literal, choiceMinterm, σ] using
            Finset.inf_attach (s := (Finset.univ : Finset ι))
              (f := fun i => if g i (Finset.mem_univ i) then v i else (v i)ᶜ)
        _ ≤ (Finset.univ : Finset (Assignment ι)).sup (minterm v) := Finset.le_sup hσ
  exact hAssignments.trans hChoicesTop

theorem eval_sup (v : ι → α) (φ ψ : BooleanFormula ι) :
    eval v (φ ⊔ ψ) = eval v φ ⊔ eval v ψ := by
  simpa [eval] using (Finset.sup_union (s₁ := φ) (s₂ := ψ) (f := minterm v))

theorem eval_bot (v : ι → α) :
    eval v (⊥ : BooleanFormula ι) = ⊥ := by
  simp [eval]

theorem eval_top (v : ι → α) :
    eval v (⊤ : BooleanFormula ι) = ⊤ := by
  simpa [eval] using minterms_sup_univ_eq_top v

theorem eval_disjoint_of_disjoint (v : ι → α) {φ ψ : BooleanFormula ι}
    (h : Disjoint φ ψ) : Disjoint (eval v φ) (eval v ψ) := by
  classical
  rw [Finset.disjoint_left] at h
  rw [eval, eval, Finset.disjoint_sup_left]
  intro σ hσ
  rw [Finset.disjoint_sup_right]
  intro τ hτ
  apply minterm_disjoint
  intro hEq
  exact (h hσ) (hEq ▸ hτ)

theorem eval_compl (v : ι → α) (φ : BooleanFormula ι) :
    eval v φᶜ = (eval v φ)ᶜ := by
  apply eq_compl_iff_isCompl.2
  refine IsCompl.of_eq ?_ ?_
  · simpa [inf_comm] using (eval_disjoint_of_disjoint v disjoint_compl_left).eq_bot
  · calc
      eval v φᶜ ⊔ eval v φ = eval v (φᶜ ⊔ φ) := (eval_sup v φᶜ φ).symm
      _ = eval v ⊤ := by simp
      _ = ⊤ := eval_top v

theorem eval_inf (v : ι → α) (φ ψ : BooleanFormula ι) :
    eval v (φ ⊓ ψ) = eval v φ ⊓ eval v ψ := by
  apply compl_injective
  rw [← eval_compl v (φ ⊓ ψ), compl_inf, eval_sup, eval_compl, eval_compl, compl_inf]

theorem eval_var (v : ι → α) (i : ι) :
    eval v (var i) = v i := by
  symm
  calc
    v i = v i ⊓ ⊤ := by simp
    _ = v i ⊓ (Finset.univ : Finset (Assignment ι)).sup (minterm v) := by
      rw [minterms_sup_univ_eq_top]
    _ = (Finset.univ : Finset (Assignment ι)).sup (fun σ => v i ⊓ minterm v σ) := by
      rw [Finset.sup_inf_distrib_left]
    _ = (Finset.univ : Finset (Assignment ι)).sup
          (fun σ => if σ i then minterm v σ else ⊥) := by
      apply Finset.sup_congr rfl
      intro σ _
      cases h : σ i <;> simp [h, inf_minterm_eq_ite, inf_comm]
    _ = (Finset.univ.filter fun σ : Assignment ι => σ i = true).sup (minterm v) := by
      rw [Finset.sup_ite (s := Finset.univ) (p := fun σ : Assignment ι => σ i = true)
        (f := minterm v) (g := fun _ => (⊥ : α))]
      simp
    _ = eval v (var i) := by
      simp [eval, var]

/-- The Boolean-algebra evaluation map attached to a valuation. -/
def evalHom (v : ι → α) : BoundedLatticeHom (BooleanFormula ι) α where
  toFun := eval v
  map_sup' := eval_sup v
  map_inf' := eval_inf v
  map_top' := eval_top v
  map_bot' := eval_bot v

end BooleanAlgebra

end Boole1854
end Textbooks
end MathlibExpansion
