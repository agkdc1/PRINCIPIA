import Mathlib.Data.NNReal.Basic
import Mathlib.FieldTheory.IsAlgClosed.AlgebraicClosure
import Mathlib.NumberTheory.Padics.PadicNumbers
import Mathlib.RingTheory.Valuation.ValExtension
import Mathlib.Topology.Algebra.Valued.ValuedField
import Mathlib.Topology.UniformSpace.Completion

/-!
# Valued algebraic closures of `ℚ_[p]`

This file isolates the minimal local boundary needed to form the completion of
`AlgebraicClosure ℚ_[p]` in the pinned Mathlib `v4.17.0` snapshot.

## What is implemented

- the existing `p`-adic norm on `ℚ_[p]`, repackaged as an `NNReal`-valued
  valuation;
- one upstream-narrow boundary package asserting a valuation on
  `AlgebraicClosure ℚ_[p]` extending that base valuation;
- a derived `Valued` instance on `AlgebraicClosure ℚ_[p]`;
- a completion alias that downstream `C_p` work can use immediately.

## Design note

We deliberately install only the `Valued` instance on
`AlgebraicClosure ℚ_[p]`. We do *not* add parallel `UniformSpace`,
`TopologicalSpace`, or `NormedField` instances by hand. This matches the
upstream lesson from the later `C_p` work: duplicating these structures risks
instance diamonds.
-/

noncomputable section

namespace MathlibExpansion.FieldTheory.AlgebraicClosure

/-- The existing `p`-adic norm on `ℚ_[p]`, viewed in `NNReal`. -/
def padicNormNNReal (p : ℕ) [Fact p.Prime] (x : ℚ_[p]) : NNReal :=
  ⟨(padicNormE x : ℝ), by
    exact_mod_cast padicNormE.nonneg x⟩

@[simp]
theorem coe_padicNormNNReal (p : ℕ) [Fact p.Prime] (x : ℚ_[p]) :
    ((padicNormNNReal p x : NNReal) : ℝ) = padicNormE x :=
  rfl

/-- The existing `p`-adic norm on `ℚ_[p]`, repackaged as a valuation. -/
def padicValuation (p : ℕ) [Fact p.Prime] : Valuation ℚ_[p] NNReal where
  toFun := padicNormNNReal p
  map_zero' := by
    ext
    simp [padicNormNNReal]
  map_one' := by
    ext
    simp [padicNormNNReal]
  map_mul' x y := by
    ext
    simp [padicNormNNReal, padicNormE.map_mul]
  map_add_le_max' x y := by
    change ((padicNormE (x + y) : ℚ) : ℝ) ≤
      max (((padicNormE x : ℚ) : ℝ)) (((padicNormE y : ℚ) : ℝ))
    exact_mod_cast padicNormE.nonarchimedean' x y

@[simp]
theorem padicValuation_apply (p : ℕ) [Fact p.Prime] (x : ℚ_[p]) :
    padicValuation p x = padicNormNNReal p x :=
  rfl

/-- A packaged valuation on `AlgebraicClosure ℚ_[p]` extending the existing
`p`-adic norm on `ℚ_[p]`.

This is the single honest local boundary in this file. The missing mathematics
is exactly the construction of the canonical extension of the `p`-adic
valuation to the algebraic closure. -/
structure PadicValuedAlgebraicClosure (p : ℕ) [Fact p.Prime] where
  valuation : Valuation (AlgebraicClosure ℚ_[p]) NNReal
  map_eq :
    ∀ x : ℚ_[p],
      valuation (algebraMap ℚ_[p] (AlgebraicClosure ℚ_[p]) x) = padicNormNNReal p x

/-- Upstream-narrow boundary (Serre, 1979, *Local Fields*, Ch. II §2,
Proposition 3; Neukirch, 1999, *Algebraic Number Theory*, Ch. II,
Theorem 4.8): the complete `p`-adic absolute value on `ℚ_[p]` extends to the
algebraic closure.  This file pins the value group to `NNReal` and records the
strict restriction equality needed by downstream `C_p` code. -/
axiom exists_padicValuedAlgebraicClosure (p : ℕ) [Fact p.Prime] :
    ∃ v : Valuation (AlgebraicClosure ℚ_[p]) NNReal,
      ∀ x : ℚ_[p],
        v (algebraMap ℚ_[p] (AlgebraicClosure ℚ_[p]) x) = padicNormNNReal p x

/-- A packaged chosen extension of the `p`-adic valuation to
`AlgebraicClosure ℚ_[p]`. -/
noncomputable def padicValuedAlgebraicClosure (p : ℕ) [Fact p.Prime] :
    PadicValuedAlgebraicClosure p :=
  let h := exists_padicValuedAlgebraicClosure p
  { valuation := Classical.choose h
    map_eq := Classical.choose_spec h }

/-- The extended `p`-adic valuation on `AlgebraicClosure ℚ_[p]`. -/
def algebraicClosurePadicValuation (p : ℕ) [Fact p.Prime] :
    Valuation (AlgebraicClosure ℚ_[p]) NNReal :=
  (padicValuedAlgebraicClosure p).valuation

@[simp]
theorem algebraicClosurePadicValuation_apply_algebraMap
    (p : ℕ) [Fact p.Prime] (x : ℚ_[p]) :
    algebraicClosurePadicValuation p (algebraMap ℚ_[p] (AlgebraicClosure ℚ_[p]) x) =
      padicNormNNReal p x :=
  (padicValuedAlgebraicClosure p).map_eq x

/-- The extended valuation restricts to the original `p`-adic valuation on the
base field. -/
theorem algebraicClosurePadic_isValExtension (p : ℕ) [Fact p.Prime] :
    IsValExtension (padicValuation p) (algebraicClosurePadicValuation p) where
  val_isEquiv_comap := by
    apply Valuation.IsEquiv.of_eq
    ext x
    simp [padicValuation]

/-- The valued structure on `AlgebraicClosure ℚ_[p]` induced by the extended
`p`-adic valuation. This is the only instance installed in this file. -/
noncomputable instance instValuedAlgebraicClosure (p : ℕ) [Fact p.Prime] :
    Valued (AlgebraicClosure ℚ_[p]) NNReal :=
  Valued.mk' (algebraicClosurePadicValuation p)

/-- The local `C_p` carrier candidate: the completion of the valued algebraic
closure of `ℚ_[p]`. -/
abbrev PadicAlgClosureCompletion (p : ℕ) [Fact p.Prime] :=
  UniformSpace.Completion (AlgebraicClosure ℚ_[p])

end MathlibExpansion.FieldTheory.AlgebraicClosure
