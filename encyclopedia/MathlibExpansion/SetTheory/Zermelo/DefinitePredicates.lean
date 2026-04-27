import Mathlib.SetTheory.ZFC.Basic

/-!
# Zermelo definite predicates

Zermelo's `1908` separation axiom is not just raw subset construction; it is
bounded by a prior notion of a "definite" predicate. This file provides a
small executable syntax/semantics boundary for unary predicates on `ZFSet`.

The boundary is intentionally narrow:

- atomic formulas are equality and membership of set terms;
- formulas are closed under the usual propositional connectives;
- quantifiers are bounded by an explicit set term.

This is not a complete formalization of Zermelo's Definition `4`, but it is a
real syntax layer that prevents the separation theorem from accepting an
unexplained arbitrary `ZFSet → Prop` without evidence.
-/

namespace MathlibExpansion.SetTheory.Zermelo

open ZFSet

/-- Variables and set-valued constants used by the executable definite-predicate syntax. -/
inductive ZermeloTerm where
  | var : Nat → ZermeloTerm
  | param : ZFSet → ZermeloTerm
  | empty : ZermeloTerm
  | singleton : ZermeloTerm → ZermeloTerm
  | union : ZermeloTerm → ZermeloTerm → ZermeloTerm
  | inter : ZermeloTerm → ZermeloTerm → ZermeloTerm
  | sUnion : ZermeloTerm → ZermeloTerm

/-- The unary/bounded first-order fragment used for Zermelo's "definite" predicates. -/
inductive ZermeloFormula where
  | falsum : ZermeloFormula
  | eq : ZermeloTerm → ZermeloTerm → ZermeloFormula
  | mem : ZermeloTerm → ZermeloTerm → ZermeloFormula
  | not : ZermeloFormula → ZermeloFormula
  | and : ZermeloFormula → ZermeloFormula → ZermeloFormula
  | or : ZermeloFormula → ZermeloFormula → ZermeloFormula
  | imp : ZermeloFormula → ZermeloFormula → ZermeloFormula
  | boundedForall : ZermeloTerm → ZermeloFormula → ZermeloFormula
  | boundedExists : ZermeloTerm → ZermeloFormula → ZermeloFormula

abbrev ZermeloEnv := Nat → ZFSet

def ZermeloEnv.cons (x : ZFSet) (ρ : ZermeloEnv) : ZermeloEnv
  | 0 => x
  | n + 1 => ρ n

def ZermeloTerm.eval : ZermeloTerm → ZermeloEnv → ZFSet
  | .var n, ρ => ρ n
  | .param x, _ => x
  | .empty, _ => ∅
  | .singleton t, ρ => {t.eval ρ}
  | .union s t, ρ => s.eval ρ ∪ t.eval ρ
  | .inter s t, ρ => s.eval ρ ∩ t.eval ρ
  | .sUnion t, ρ => ⋃₀ t.eval ρ

def ZermeloFormula.Holds : ZermeloFormula → ZermeloEnv → Prop
  | .falsum, _ => False
  | .eq s t, ρ => s.eval ρ = t.eval ρ
  | .mem s t, ρ => s.eval ρ ∈ t.eval ρ
  | .not φ, ρ => ¬φ.Holds ρ
  | .and φ ψ, ρ => φ.Holds ρ ∧ ψ.Holds ρ
  | .or φ ψ, ρ => φ.Holds ρ ∨ ψ.Holds ρ
  | .imp φ ψ, ρ => φ.Holds ρ → ψ.Holds ρ
  | .boundedForall t φ, ρ => ∀ x : ZFSet, x ∈ t.eval ρ → φ.Holds (ρ.cons x)
  | .boundedExists t φ, ρ => ∃ x : ZFSet, x ∈ t.eval ρ ∧ φ.Holds (ρ.cons x)

def ZermeloFormula.Holds1 (φ : ZermeloFormula) (x : ZFSet) : Prop :=
  φ.Holds (fun
    | 0 => x
    | _ + 1 => ∅)

/-- A unary predicate on `M` is "definite" if it is represented by the
executable bounded formula language on every element of `M`. -/
def ZermeloDefiniteOn (M : ZFSet) (φ : ZFSet → Prop) : Prop :=
  ∃ ψ : ZermeloFormula, ∀ ⦃x : ZFSet⦄, x ∈ M → (ψ.Holds1 x ↔ φ x)

theorem selfNonMem_definiteOn (M : ZFSet) :
    ZermeloDefiniteOn M (fun x => x ∉ x) := by
  refine ⟨.not (.mem (.var 0) (.var 0)), ?_⟩
  intro x _hx
  simp [ZermeloFormula.Holds1, ZermeloFormula.Holds, ZermeloTerm.eval]

end MathlibExpansion.SetTheory.Zermelo
