import Mathlib
import NavierStokes.Geometry.Cylindrical.Basic
import NavierStokes.Analysis.WeightedSobolev.Measure

/-!
# NavierStokes.Analysis.WeightedSobolev.TestFunctions

Test-function subtype for weighted Sobolev spaces:
smooth, compactly supported functions on `E3 = ℝ × ℝ × ℝ` whose `tsupport`
avoids the `zAxis`.  This is the dense subspace from which `weightedH^k` is
built by topological closure.

Provides `Add`, `Neg`, `SMul ℝ`, and `Zero` instances on `TestFn`.

No new axioms.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open Set Function

namespace NavierStokes.Analysis.WeightedSobolev

open NavierStokes.Geometry.Cylindrical

/-- The test functions `f : E3 → ℝ`: smooth, compactly supported, with
    `tsupport f ⊆ puncturedSpace`.  This is `C_c^∞(puncturedSpace; ℝ)`
    embedded ambiently in functions on `E3`. -/
def TestFn : Type :=
  {f : E3 → ℝ // HasCompactSupport f ∧ ContDiff ℝ ⊤ f ∧ tsupport f ⊆ puncturedSpace}

namespace TestFn

/-- Underlying function. -/
@[coe] def val (f : TestFn) : E3 → ℝ := f.1

instance : CoeFun TestFn (fun _ => E3 → ℝ) := ⟨val⟩

@[ext] lemma ext {f g : TestFn} (h : f.1 = g.1) : f = g := Subtype.ext h

/-! ## Algebraic structure -/

instance : Zero TestFn :=
  ⟨⟨0, by
    refine ⟨?_, ?_, ?_⟩
    · -- HasCompactSupport 0
      simp [HasCompactSupport, tsupport, Function.support]
    · -- ContDiff ℝ ⊤ 0
      exact contDiff_const
    · -- tsupport 0 ⊆ puncturedSpace
      simp [tsupport, Function.support]⟩⟩

@[simp] lemma zero_val : (0 : TestFn).1 = 0 := rfl

instance : Add TestFn :=
  ⟨fun f g => ⟨f.1 + g.1, by
    obtain ⟨hf1, hf2, hf3⟩ := f.2
    obtain ⟨hg1, hg2, hg3⟩ := g.2
    refine ⟨?_, ?_, ?_⟩
    · exact hf1.add hg1
    · exact hf2.add hg2
    · -- tsupport (f + g) ⊆ tsupport f ∪ tsupport g ⊆ puncturedSpace
      have h_supp : tsupport (f.1 + g.1) ⊆ tsupport f.1 ∪ tsupport g.1 := by
        show closure (Function.support (f.1 + g.1))
             ⊆ closure (Function.support f.1) ∪ closure (Function.support g.1)
        rw [← closure_union]
        exact closure_mono (Function.support_add f.1 g.1)
      exact h_supp.trans (Set.union_subset hf3 hg3)⟩⟩

@[simp] lemma add_val (f g : TestFn) : (f + g).1 = f.1 + g.1 := rfl

instance : Neg TestFn :=
  ⟨fun f => ⟨-f.1, by
    obtain ⟨hf1, hf2, hf3⟩ := f.2
    refine ⟨?_, ?_, ?_⟩
    · -- HasCompactSupport (-f.1): tsupport (-f) = tsupport f, hence compact
      show IsCompact (tsupport (-f.1))
      have h : tsupport (-f.1) = tsupport f.1 := by
        show closure (Function.support (fun x => -(f.1 x)))
             = closure (Function.support f.1)
        apply congrArg closure
        ext x
        simp [Function.mem_support]
      rw [h]; exact hf1
    · exact hf2.neg
    · -- tsupport (-f) ⊆ puncturedSpace
      show closure (Function.support (fun x => -(f.1 x))) ⊆ puncturedSpace
      have h : Function.support (fun x => -(f.1 x)) = Function.support f.1 := by
        ext x; simp [Function.mem_support]
      rw [h]; exact hf3⟩⟩

@[simp] lemma neg_val (f : TestFn) : (-f).1 = -f.1 := rfl

instance : SMul ℝ TestFn :=
  ⟨fun c f => ⟨c • f.1, by
    obtain ⟨hf1, hf2, hf3⟩ := f.2
    refine ⟨?_, ?_, ?_⟩
    · -- HasCompactSupport (c • f.1): tsupport ⊆ tsupport f.1, closed subset of compact
      show IsCompact (tsupport (c • f.1))
      refine hf1.of_isClosed_subset (isClosed_closure) ?_
      show closure (Function.support (c • f.1)) ⊆ tsupport f.1
      exact closure_mono (Function.support_smul_subset_right _ _)
    · exact hf2.const_smul c
    · -- tsupport (c • f) ⊆ puncturedSpace
      refine Set.Subset.trans ?_ hf3
      show closure (Function.support (c • f.1)) ⊆ closure (Function.support f.1)
      exact closure_mono (Function.support_smul_subset_right _ _)⟩⟩

@[simp] lemma smul_val (c : ℝ) (f : TestFn) : (c • f).1 = c • f.1 := rfl

end TestFn

end NavierStokes.Analysis.WeightedSobolev

end
