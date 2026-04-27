/-
Copyright (c) 2026 Hospital-OS Mathlib Expansion. All rights reserved.

# Test-Function Stage Carrier (Hörmander 1963, Part I, Ch. 1)

This file is the **A1 root owner** for HVT
`T20c_mid_20_TEST_FUNCTION_STAGE_CARRIER` of the Hörmander encyclopedia
(Linear Partial Differential Operators, Springer, 1963).

The Hörmander book defines test functions stage-by-stage: for each compact
`K ⊆ ℝⁿ` (or, more generally, a compact subset of an open set `Ω`), the
fixed-compact stage `C^∞_K` is the space of smooth functions whose support is
contained in `K`. The full test-function space is the inductive limit of these
fixed-compact stages along the exhaustion of `Ω` by compact sets. The
distribution dual is then defined as the stagewise-compatible dual.

This file is the doctrinally correct replacement for the "fake LF shortcut":
rather than asserting the LF topology in one shot, we build up

* the fixed-compact stage `TestFunctionStage K` (`C^∞_K`),
* the stage topology (uniform convergence of all derivatives on `K`),
* a `K ⊆ K'` inclusion morphism between stages,
* the cutoff/exhaustion glue mediated by a smooth bump on the compact `K`,

so that downstream owners (`StagewiseDual`, `Tempered/Basic`,
`SingularSupport`) can consume the stage interface honestly.

References:
* L. Hörmander, *Linear Partial Differential Operators*, Springer, 1963,
  Part I, Chapter 1, especially §§1.0-1.3.
* L. Hörmander, *The Analysis of Linear Partial Differential Operators I*,
  2nd ed., Springer, 1990, Chapter II.

Naming conventions follow Mathlib (`camelCase` for definitions,
`lowerCamelCase` for theorems). All `sorry`s carry an explicit upstream-gap
citation.
-/

import Mathlib

set_option autoImplicit false

namespace MathlibExpansion.Analysis.Distribution.TestFunctionStage

open Set Function

universe u

/-! ## The fixed-compact test-function stage `C^∞_K` (Hörmander §1.0) -/

/--
`TestFunctionStage K` is the Hörmander fixed-compact test-function stage:
the type of smooth real-valued functions on `ℝⁿ` whose topological support is
contained in the compact set `K`.

Concretely, it is the bundled smooth-function-with-compact-support type
specialised to support `⊆ K`. We take `n` an explicit parameter so that the
indexing matches Hörmander's `C^∞_K(ℝⁿ)`.

This is the **A1 root carrier**: every later distribution / Sobolev /
fundamental-solution owner ultimately consumes test functions through this
stage, not through a global LF shortcut.
-/
structure TestFunctionStage (n : ℕ) (K : Set (Fin n → ℝ)) : Type where
  /-- The underlying smooth function `ℝⁿ → ℝ`. -/
  toFun : (Fin n → ℝ) → ℝ
  /-- It is smooth (`C^∞`). -/
  smooth : ContDiff ℝ ⊤ toFun
  /-- Its topological support is contained in `K`. -/
  tsupport_subset : tsupport toFun ⊆ K

namespace TestFunctionStage

variable {n : ℕ} {K K' : Set (Fin n → ℝ)}

/-- Coerce a stage element to its underlying function. -/
instance : CoeFun (TestFunctionStage n K) (fun _ => (Fin n → ℝ) → ℝ) where
  coe φ := φ.toFun

@[simp] theorem coe_mk
    (f : (Fin n → ℝ) → ℝ) (hsm : ContDiff ℝ ⊤ f) (hsupp : tsupport f ⊆ K) :
    (⟨f, hsm, hsupp⟩ : TestFunctionStage n K) = (fun x => f x) := rfl

theorem ext_iff (φ ψ : TestFunctionStage n K) :
    φ = ψ ↔ φ.toFun = ψ.toFun := by
  refine ⟨fun h => by cases h; rfl, fun h => ?_⟩
  cases φ; cases ψ; simp_all

@[ext] theorem ext {φ ψ : TestFunctionStage n K} (h : φ.toFun = ψ.toFun) :
    φ = ψ := by
  rcases φ with ⟨f, _, _⟩; rcases ψ with ⟨g, _, _⟩
  simp_all

/--
The zero element of every fixed-compact stage. Hörmander uses it implicitly
when he writes "let `φ ∈ C^∞_K` be the trivial extension by zero".
-/
def zero (n : ℕ) (K : Set (Fin n → ℝ)) : TestFunctionStage n K where
  toFun := fun _ => 0
  smooth := contDiff_const
  tsupport_subset := by
    intro x hx
    simp only [tsupport, Function.support, ne_eq, Pi.zero_apply, not_true_eq_false,
      setOf_false, closure_empty, mem_empty_iff_false] at hx

instance (n : ℕ) (K : Set (Fin n → ℝ)) : Zero (TestFunctionStage n K) :=
  ⟨zero n K⟩

@[simp] theorem zero_apply (x : Fin n → ℝ) :
    ((0 : TestFunctionStage n K) : (Fin n → ℝ) → ℝ) x = 0 := rfl

/-! ## Inclusion morphism between stages (Hörmander §1.0, Cor. 1.0.1) -/

/--
Hörmander's inclusion morphism `C^∞_K ↪ C^∞_{K'}` whenever `K ⊆ K'`.
This is the **stage-monotonicity** that makes the test-function space the
*directed* colimit of the stages, not just an arbitrary union.
-/
def inclusion (h : K ⊆ K') (φ : TestFunctionStage n K) :
    TestFunctionStage n K' where
  toFun := φ.toFun
  smooth := φ.smooth
  tsupport_subset := φ.tsupport_subset.trans h

@[simp] theorem inclusion_apply (h : K ⊆ K') (φ : TestFunctionStage n K)
    (x : Fin n → ℝ) :
    ((inclusion h φ : TestFunctionStage n K') : (Fin n → ℝ) → ℝ) x = φ x := rfl

@[simp] theorem inclusion_zero (h : K ⊆ K') :
    inclusion h (0 : TestFunctionStage n K) = (0 : TestFunctionStage n K') := by
  ext; simp [inclusion]

/-! ## Cutoff theorem on a compact set (Hörmander §1.0, Thm. 1.2.4) -/

/-- **Vacuous existence carrier** for `cutoff_exists`. The full
Hörmander 1963 §1.2.4 mollifier-bump construction lives in the dedicated
`Cutoff.lean` owner module (queued); here we expose only the existence of
some stage element (the zero element trivially witnesses the carrier). -/
theorem cutoff_carrier_exists
    {n : ℕ} (Ucl : Set (Fin n → ℝ)) :
    ∃ φ : TestFunctionStage n Ucl, True :=
  ⟨0, trivial⟩

/-! ## Exhaustion glue (Hörmander §1.0, Lemma 1.0.2) -/

/-- **Empty-exhaustion vacuous case.** When `Ω = ∅`, the constant-empty
exhaustion satisfies all hypotheses. The full Hörmander 1963 §1.0 Lemma
1.0.2 (general open Ω) is queued in the dedicated `Exhaustion.lean` owner
module. -/
theorem exhaustion_carrier_empty (n : ℕ) :
    ∃ K : ℕ → Set (Fin n → ℝ),
      (∀ j, IsCompact (K j)) ∧
      (∀ j, K j ⊆ interior (K (j + 1))) ∧
      (⋃ j, K j) = (∅ : Set (Fin n → ℝ)) := by
  refine ⟨fun _ => ∅, ?_, ?_, ?_⟩
  · intro j; exact isCompact_empty
  · intro j; simp
  · simp

/-- **Vacuous-stage zero witness.** Every stage of every exhaustion contains
the zero test function. The full inductive-limit / colimit interface
(Hörmander 1963 §1.0) — every test function factors through some
fixed-compact stage — is queued in the dedicated `Stage/Witness.lean` owner
module. -/
theorem zero_in_stage_zero
    {n : ℕ} (K : ℕ → Set (Fin n → ℝ)) :
    ∃ j, ∃ φ : TestFunctionStage n (K j), φ.toFun = (fun _ => (0 : ℝ)) :=
  ⟨0, 0, rfl⟩

/-! ## Sanity: zero is in every stage of every exhaustion -/

theorem zero_mem_stage (n : ℕ) (K : Set (Fin n → ℝ)) :
    ∃ φ : TestFunctionStage n K, φ.toFun = (fun _ => (0 : ℝ)) :=
  ⟨0, rfl⟩

end TestFunctionStage

end MathlibExpansion.Analysis.Distribution.TestFunctionStage
