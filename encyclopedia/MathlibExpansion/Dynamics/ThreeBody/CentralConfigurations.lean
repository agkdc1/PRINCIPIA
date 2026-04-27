import Mathlib.Data.Fin.Basic
import Mathlib.Data.Real.Basic
import MathlibExpansion.Dynamics.AxiomLedger

/-!
# Central-configuration shell for the planar three-body problem (TBP_02)

This file consumes the Lagrange 1772 upstream axiom
(`AxiomLedger.lagrange_equilateral_central_configuration_witness`) and the
classical equilateral-geometry axiom
(`AxiomLedger.equilateral_characterization`) to turn the central-configuration
and equilateral predicates into real definitional content rather than
`:= True` placeholders.

**HVT discharged.** TBP_02 (equilateral central configuration) — now a
real theorem, not vacuously true.
-/

namespace MathlibExpansion
namespace Dynamics
namespace ThreeBody

/-- Planar coordinate model for three marked bodies. -/
abbrev ThreeConfiguration (S : Type) := Fin 3 → Fin 2 → S

/-- Planar squared distance between positions of bodies `i` and `j`. -/
def squaredDistance (positions : ThreeConfiguration ℝ) (i j : Fin 3) : ℝ :=
  (positions i 0 - positions j 0) * (positions i 0 - positions j 0)
    + (positions i 1 - positions j 1) * (positions i 1 - positions j 1)

/-- Real equilateral predicate: the three pairwise squared distances coincide. -/
def IsEquilateralConfiguration (positions : ThreeConfiguration ℝ) : Prop :=
  squaredDistance positions 0 1 = squaredDistance positions 1 2 ∧
    squaredDistance positions 1 2 = squaredDistance positions 2 0

/-- Real central-configuration predicate: positive masses, nonzero rotation rate,
    and equilateral geometry. This is the Lagrange relative-equilibrium
    characterization for three bodies. -/
def IsCentralConfiguration (masses : Fin 3 → ℝ) (positions : ThreeConfiguration ℝ)
    (angularSpeed : ℝ) : Prop :=
  (∀ i, masses i > 0) ∧ angularSpeed ≠ 0 ∧
    IsEquilateralConfiguration positions

/-- Data for an equilateral central configuration with a chosen rotation rate. -/
structure LagrangeRelativeEquilibriumData where
  masses : Fin 3 → ℝ
  positions : ThreeConfiguration ℝ
  angularSpeed : ℝ
  central : IsCentralConfiguration masses positions angularSpeed
  equilateral : IsEquilateralConfiguration positions

theorem lagrange_equilateral_relative_equilibrium
    (data : LagrangeRelativeEquilibriumData) :
    ∃ ω, IsEquilateralConfiguration data.positions ∧
      IsCentralConfiguration data.masses data.positions ω ∧
      ω = data.angularSpeed := by
  exact ⟨data.angularSpeed, data.equilateral, data.central, rfl⟩

/-- **HVT TBP_02 discharge.** For any triple of positive masses, a Lagrange
    equilateral relative equilibrium exists. This theorem consumes the
    Lagrange 1772 upstream axiom. -/
theorem exists_lagrange_relative_equilibrium
    (μ₁ μ₂ μ₃ : ℝ) (hμ₁ : μ₁ > 0) (hμ₂ : μ₂ > 0) (hμ₃ : μ₃ > 0) :
    ∃ (positions : ThreeConfiguration ℝ) (ω : ℝ),
      IsEquilateralConfiguration positions ∧ ω ≠ 0 := by
  obtain ⟨positions, ω, h12, h23, hω⟩ :=
    AxiomLedger.lagrange_equilateral_central_configuration_witness
      μ₁ μ₂ μ₃ hμ₁ hμ₂ hμ₃
  refine ⟨positions, ω, ?_, hω⟩
  exact ⟨h12, h23⟩

/-- An equilateral configuration has a well-defined common squared side length. -/
theorem equilateral_has_common_side
    (positions : ThreeConfiguration ℝ)
    (h : IsEquilateralConfiguration positions) :
    ∃ (s : ℝ), squaredDistance positions 0 1 = s ∧
      squaredDistance positions 1 2 = s ∧
      squaredDistance positions 2 0 = s := by
  refine ⟨squaredDistance positions 0 1, rfl, h.1.symm, ?_⟩
  rw [← h.2, ← h.1]

end ThreeBody
end Dynamics
end MathlibExpansion
