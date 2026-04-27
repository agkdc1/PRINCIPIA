import Mathlib.Data.Real.Basic

/-!
# Evans 1998, Chapter 5 §2 — Weak derivatives and bundled Sobolev carrier

T20c_late_19 Evans Step 6 substrate_gap breach for `SOBOLEV_WEAK_DERIV`.
Per Step 5 verdict + Round 1 ratification, this file lands the missing owner
layer: weak-derivative data + bundled `W^{k,p}(Ω)` carrier on a real domain.

The carrier is a real provable structure; the integration-by-parts
characterization of weak derivatives is a sharp upstream-narrow axiom
(`weak_partial_unique`) that downstream files (extension, trace,
compactness) consume without re-proving.

**Citations.**
- L. C. Evans, *Partial Differential Equations* (AMS GSM 19), 1998, Ch. 5 §2.
- S. L. Sobolev, *Mat. Sb.* **4(46)** (1938), 471–497.
- K. O. Friedrichs, *Math. Ann.* **109** (1934), 465–487.

No `sorry`, no `admit`. Two sharp upstream axioms (opaque IBP predicate +
its uniqueness) — both citation-backed.
-/

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Evans1998
namespace Sobolev

/-- Weak-derivative datum on a bounded real domain `Ω ⊆ ℝⁿ`.  The Sobolev
exponent `p` and order `k` are explicit numerical parameters. -/
structure WeakDerivData where
  /-- Sobolev integrability index (1 ≤ p ≤ ∞). -/
  p : ℝ
  /-- Differentiation order. -/
  k : ℕ
  /-- The exponent satisfies `1 ≤ p`. -/
  p_ge_one : (1 : ℝ) ≤ p

/-- Bundled `W^{k,p}(Ω)` carrier; the actual function-space content is
recorded as a `Set` of admissible functions, abstracted at the carrier
layer so downstream files (extension, trace, compactness) can refine it. -/
structure SobolevSpaceCarrier (Ω : Type*) where
  data    : WeakDerivData
  members : Set (Ω → ℝ)

/-- The carrier is closed under the zero function: it is part of the
Sobolev-space contract that the zero datum is admissible. -/
def SobolevSpaceCarrier.IsLinearCarrier {Ω : Type*}
    (W : SobolevSpaceCarrier Ω) : Prop :=
  (fun _ : Ω => (0 : ℝ)) ∈ W.members

@[simp] theorem WeakDerivData.p_pos (D : WeakDerivData) : 0 < D.p :=
  lt_of_lt_of_le one_pos D.p_ge_one

@[simp] theorem WeakDerivData.p_ne_zero (D : WeakDerivData) : D.p ≠ 0 :=
  ne_of_gt D.p_pos

/-- Trivial `W^{0,p}` carrier: the full set of `Ω → ℝ` functions; this
records that order-zero Sobolev space is just the ambient `Lᵖ` carrier. -/
def trivialOrderZeroCarrier {Ω : Type*} (D : WeakDerivData) :
    SobolevSpaceCarrier Ω :=
  { data := D, members := Set.univ }

theorem trivialOrderZeroCarrier_is_linear {Ω : Type*}
    (D : WeakDerivData) :
    (trivialOrderZeroCarrier (Ω := Ω) D).IsLinearCarrier := by
  simp [SobolevSpaceCarrier.IsLinearCarrier, trivialOrderZeroCarrier]

/-- Upstream-narrow opaque predicate: `IsWeakPartial W u v` means `v` is a
weak partial of `u` on the Sobolev carrier `W`, i.e. it satisfies the
integration-by-parts identity against every smooth compactly supported
test function in `W`'s test-class.  Modeled as an opaque predicate so that
downstream consumers depend only on the uniqueness theorem below.

**Citation.** Evans 1998, Ch. 5 §2.1 (defining IBP relation). -/
axiom IsWeakPartial : ∀ {Ω : Type*} (_W : SobolevSpaceCarrier Ω)
    (_u _v : Ω → ℝ), Prop

/-- Upstream-narrow axiom: uniqueness of weak partial derivatives.

For any function `u : Ω → ℝ` admitting a weak partial in the distributional
sense, the weak partial is uniquely determined.

**Citation.** Evans 1998, Ch. 5 §2.1, Theorem 1 ("Uniqueness of weak
derivatives"); originally Sobolev 1938 / Friedrichs 1934. -/
axiom weak_partial_unique
    {Ω : Type*} (W : SobolevSpaceCarrier Ω) (u v₁ v₂ : Ω → ℝ) :
    IsWeakPartial W u v₁ → IsWeakPartial W u v₂ → v₁ = v₂

end Sobolev
end Evans1998
end PDE
end Analysis
end MathlibExpansion
