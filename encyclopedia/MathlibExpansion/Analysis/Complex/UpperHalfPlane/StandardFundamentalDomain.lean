import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic

import MathlibExpansion.Roots.Valence.SL2ZFundamentalDomain
import MathlibExpansion.Roots.Valence.EllipticStabilizers

/-!
# Standard fundamental-domain package for `PSL₂(ℤ)`

This textbook-facing module repackages the local `Roots.Valence` scaffold for the
closed standard fundamental domain of the modular group.

The goal is intentionally narrow:

- expose the distinguished elliptic point `rho`;
- expose the three classical boundary pieces `leftSide`, `rightSide`, `unitArc`;
- package the boundary decomposition of the closed domain;
- package the elementary `T` and `S` side-pairing lemmas;
- record the cardinalities of the elliptic stabilizers at `i` and `rho`.

This file does not introduce quotient orbifolds, modular curves, or cusp
compactifications.
-/

noncomputable section

open Matrix Matrix.SpecialLinearGroup UpperHalfPlane ModularGroup
open scoped MatrixGroups UpperHalfPlane Modular

namespace MathlibExpansion.Analysis.Complex.UpperHalfPlane

/-- The projective modular group acting on the upper half-plane. -/
abbrev PSL2Z := MathlibExpansion.Roots.Valence.PSL2Z

/-- The order-three elliptic point in the closed standard fundamental domain. -/
abbrev rho : ℍ := MathlibExpansion.Roots.Valence.rho

/-- The left vertical side `Re(z) = -1/2` of the closed standard domain. -/
abbrev leftSide : Set ℍ := MathlibExpansion.Roots.Valence.leftSide

/-- The right vertical side `Re(z) = 1/2` of the closed standard domain. -/
abbrev rightSide : Set ℍ := MathlibExpansion.Roots.Valence.rightSide

/-- The unit-circle boundary arc of the closed standard domain. -/
abbrev unitArc : Set ℍ := MathlibExpansion.Roots.Valence.unitArc

@[simp]
theorem rho_coe :
    (rho : ℂ) = (-(1 : ℝ) / 2 : ℂ) + (Real.sqrt 3 / 2) * Complex.I :=
  MathlibExpansion.Roots.Valence.rho_coe

@[simp]
theorem rho_re : rho.re = -(1 : ℝ) / 2 :=
  MathlibExpansion.Roots.Valence.rho_re

@[simp]
theorem rho_im : rho.im = Real.sqrt 3 / 2 :=
  MathlibExpansion.Roots.Valence.rho_im

@[simp]
theorem rho_normSq : Complex.normSq (rho : ℂ) = 1 :=
  MathlibExpansion.Roots.Valence.rho_normSq

theorem rho_quad : (rho : ℂ) ^ 2 + rho + 1 = 0 :=
  MathlibExpansion.Roots.Valence.rho_quad

@[simp]
theorem I_mem_unitArc : UpperHalfPlane.I ∈ unitArc :=
  MathlibExpansion.Roots.Valence.I_mem_unitArc

@[simp]
theorem rho_mem_leftSide : rho ∈ leftSide :=
  MathlibExpansion.Roots.Valence.rho_mem_leftSide

@[simp]
theorem rho_mem_unitArc : rho ∈ unitArc :=
  MathlibExpansion.Roots.Valence.rho_mem_unitArc

/-- Boundary points of the closed standard domain are exactly the two vertical
sides together with the unit-circle arc. -/
theorem mem_boundary_iff (z : ℍ) :
    z ∈ ModularGroup.fd ∧ z ∉ ModularGroup.fdo ↔
      z ∈ leftSide ∨ z ∈ rightSide ∨ z ∈ unitArc :=
  MathlibExpansion.Roots.Valence.mem_boundary_iff z

/-- Translation by `T` pairs the left side with the right side. -/
theorem T_maps_leftSide {z : ℍ} (hz : z ∈ leftSide) :
    ModularGroup.T • z ∈ rightSide :=
  MathlibExpansion.Roots.Valence.T_maps_leftSide hz

/-- Translation by `T⁻¹` pairs the right side with the left side. -/
theorem T_inv_maps_rightSide {z : ℍ} (hz : z ∈ rightSide) :
    ModularGroup.T⁻¹ • z ∈ leftSide :=
  MathlibExpansion.Roots.Valence.T_inv_maps_rightSide hz

/-- Inversion by `S` preserves the unit-circle arc. -/
theorem S_maps_unitArc {z : ℍ} (hz : z ∈ unitArc) :
    ModularGroup.S • z ∈ unitArc :=
  MathlibExpansion.Roots.Valence.S_maps_unitArc hz

/-- The elliptic stabilizer at `i` in `PSL₂(ℤ)` has order `2`. -/
theorem stabilizerAtI_card :
    Fintype.card (MulAction.stabilizer PSL2Z UpperHalfPlane.I) = 2 := by
  simpa [PSL2Z] using MathlibExpansion.Roots.Valence.Matrix.Stab_I_card

/-- The elliptic stabilizer at `rho` in `PSL₂(ℤ)` has order `3`. -/
theorem stabilizerAtRho_card :
    Fintype.card (MulAction.stabilizer PSL2Z rho) = 3 := by
  simpa [PSL2Z, rho] using MathlibExpansion.Roots.Valence.Matrix.Stab_rho_card

end MathlibExpansion.Analysis.Complex.UpperHalfPlane
