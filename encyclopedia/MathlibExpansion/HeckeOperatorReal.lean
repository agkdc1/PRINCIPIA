/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import Mathlib.NumberTheory.ModularForms.Basic
import Mathlib.NumberTheory.ModularForms.CongruenceSubgroups
import Mathlib.Data.Nat.Prime.Basic
import MathlibExpansion.SecondGap
import MathlibExpansion.ThirdGap
import MathlibExpansion.FourthGap

/-!
# Concrete Hecke operators on modular forms

This file adds a concrete pointwise formula for the prime Hecke operator on
`Mathlib` modular forms of level `Gamma0 N`. The analytic preservation results
are isolated as theorem statements, so the exported operator is an actual
endomorphism of `ModularForm (Gamma0 N) k` while exposing the standard formula
on functions.
-/

noncomputable section

open Complex Finset UpperHalfPlane
open scoped BigOperators MatrixGroups ModularForm UpperHalfPlane Manifold
open CongruenceSubgroup

namespace NumberTheory
namespace HeckeOperatorReal

/-- The upper-half-plane map `z ↦ p z` for a positive natural number `p`. -/
def mulNatMap (p : ℕ) (hp : 0 < p) (z : ℍ) : ℍ :=
  UpperHalfPlane.mk ((p : ℂ) * z) <| by
    simpa [Complex.mul_im, UpperHalfPlane.coe_im] using
      mul_pos (Nat.cast_pos.mpr hp : 0 < (p : ℝ)) z.im_pos

@[simp]
theorem coe_mulNatMap (p : ℕ) (hp : 0 < p) (z : ℍ) :
    (mulNatMap p hp z : ℂ) = (p : ℂ) * z :=
  UpperHalfPlane.coe_mk _ _

/-- The upper-half-plane map `z ↦ (z + j) / p` for a positive natural number `p`. -/
def addNatDivMap (p : ℕ) (hp : 0 < p) (j : ℕ) (z : ℍ) : ℍ :=
  UpperHalfPlane.mk (((z : ℂ) + (j : ℂ)) / (p : ℂ)) <| by
    have hpR : 0 < (p : ℝ) := Nat.cast_pos.mpr hp
    have hpR_ne : (p : ℝ) ≠ 0 := ne_of_gt hpR
    have hnorm : Complex.normSq (p : ℂ) = (p : ℝ) * (p : ℝ) := by
      simp [Complex.normSq]
    have him :
        (((z : ℂ) + (j : ℂ)) / (p : ℂ)).im = z.im / (p : ℝ) := by
      simp [Complex.div_im, Complex.add_im, UpperHalfPlane.coe_im, Complex.normSq, hpR_ne,
        div_eq_mul_inv, mul_assoc, mul_left_comm, mul_comm]
    rw [him]
    exact div_pos z.im_pos hpR

@[simp]
theorem coe_addNatDivMap (p : ℕ) (hp : 0 < p) (j : ℕ) (z : ℍ) :
    (addNatDivMap p hp j z : ℂ) = ((z : ℂ) + (j : ℂ)) / (p : ℂ) :=
  UpperHalfPlane.coe_mk _ _

/--
The standard pointwise prime Hecke formula
`p^(k-1) f(pz) + p⁻¹ ∑_{j=0}^{p-1} f((z+j)/p)`.
-/
def primeHeckeFunction (N p : ℕ) (k : ℤ) (hp : p.Prime)
    (f : ModularForm (Gamma0 N) k) : ℍ → ℂ :=
  fun z =>
    (p : ℂ) ^ (k - 1) * f (mulNatMap p hp.pos z)
      + ((p : ℂ)⁻¹) * ∑ j ∈ Finset.range p, f (addNatDivMap p hp.pos j z)

@[simp]
theorem primeHeckeFunction_apply (N p : ℕ) (k : ℤ) (hp : p.Prime)
    (f : ModularForm (Gamma0 N) k) (z : ℍ) :
    primeHeckeFunction N p k hp f z =
      (p : ℂ) ^ (k - 1) * f (mulNatMap p hp.pos z)
        + ((p : ℂ)⁻¹) * ∑ j ∈ Finset.range p, f (addNatDivMap p hp.pos j z) :=
  rfl

/-- Slash invariance of the prime Hecke formula. -/
theorem primeHecke_slash_invariant (N p : ℕ) (k : ℤ) (hp : p.Prime)
    (hcop : Nat.Coprime p N) (f : ModularForm (Gamma0 N) k) :
    ∀ γ ∈ Gamma0 N, primeHeckeFunction N p k hp f ∣[k] γ =
      primeHeckeFunction N p k hp f := by
  sorry

/-- Holomorphicity of the prime Hecke formula. -/
theorem primeHecke_holomorphic (N p : ℕ) (k : ℤ) (hp : p.Prime)
    (hcop : Nat.Coprime p N) (f : ModularForm (Gamma0 N) k) :
    MDifferentiable 𝓘(ℂ) 𝓘(ℂ) (primeHeckeFunction N p k hp f) := by
  sorry

/-- Boundedness at infinity of the prime Hecke formula. -/
theorem primeHecke_bounded_at_infty (N p : ℕ) (k : ℤ) (hp : p.Prime)
    (hcop : Nat.Coprime p N) (f : ModularForm (Gamma0 N) k) :
    ∀ A : SL(2, ℤ), IsBoundedAtImInfty (primeHeckeFunction N p k hp f ∣[k] A) := by
  sorry

/-- The bundled modular form obtained from the concrete prime Hecke formula. -/
def primeHeckeModularForm (N p : ℕ) (k : ℤ) (hp : p.Prime)
    (hcop : Nat.Coprime p N) (f : ModularForm (Gamma0 N) k) :
    ModularForm (Gamma0 N) k where
  toSlashInvariantForm :=
    { toFun := primeHeckeFunction N p k hp f
      slash_action_eq' := primeHecke_slash_invariant N p k hp hcop f }
  holo' := primeHecke_holomorphic N p k hp hcop f
  bdd_at_infty' := primeHecke_bounded_at_infty N p k hp hcop f

@[simp]
theorem primeHeckeModularForm_apply (N p : ℕ) (k : ℤ) (hp : p.Prime)
    (hcop : Nat.Coprime p N) (f : ModularForm (Gamma0 N) k) (z : ℍ) :
    primeHeckeModularForm N p k hp hcop f z =
      (p : ℂ) ^ (k - 1) * f (mulNatMap p hp.pos z)
        + ((p : ℂ)⁻¹) * ∑ j ∈ Finset.range p, f (addNatDivMap p hp.pos j z) :=
  rfl

/-- The prime Hecke operator on modular forms of level `Gamma0 N`, for `p ∤ N`. -/
def primeHeckeOperator (N p : ℕ) (k : ℤ) (hp : p.Prime)
    (hcop : Nat.Coprime p N) : HeckeOperator (Gamma0 N) k where
  toFun := primeHeckeModularForm N p k hp hcop
  map_add' := by
    intro f g
    ext z
    simp [primeHeckeFunction, Finset.sum_add_distrib, mul_add]
    ring
  map_smul' := by
    intro c f
    ext z
    simp [primeHeckeFunction, Finset.mul_sum, Algebra.id.smul_eq_mul]
    have hsum :
        (∑ x ∈ Finset.range p, (p : ℂ)⁻¹ * (c * f (addNatDivMap p hp.pos x z))) =
          c * ∑ x ∈ Finset.range p, (p : ℂ)⁻¹ * f (addNatDivMap p hp.pos x z) := by
      rw [Finset.mul_sum]
      exact Finset.sum_congr rfl fun x _ => by ring
    rw [hsum]
    ring

/-- The prime Hecke formula on cusp forms, viewed as a pointwise function. -/
def primeHeckeCuspFunction (N p : ℕ) (k : ℤ) (hp : p.Prime)
    (f : CuspForm (Gamma0 N) k) : ℍ → ℂ :=
  fun z =>
    (p : ℂ) ^ (k - 1) * f (mulNatMap p hp.pos z)
      + ((p : ℂ)⁻¹) * ∑ j ∈ Finset.range p, f (addNatDivMap p hp.pos j z)

@[simp]
theorem primeHeckeCuspFunction_apply (N p : ℕ) (k : ℤ) (hp : p.Prime)
    (f : CuspForm (Gamma0 N) k) (z : ℍ) :
    primeHeckeCuspFunction N p k hp f z =
      (p : ℂ) ^ (k - 1) * f (mulNatMap p hp.pos z)
        + ((p : ℂ)⁻¹) * ∑ j ∈ Finset.range p, f (addNatDivMap p hp.pos j z) :=
  rfl

/-- Slash invariance of the prime Hecke formula on cusp forms. -/
theorem primeHeckeCusp_slash_invariant (N p : ℕ) (k : ℤ) (hp : p.Prime)
    (hcop : Nat.Coprime p N) (f : CuspForm (Gamma0 N) k) :
    ∀ γ ∈ Gamma0 N, primeHeckeCuspFunction N p k hp f ∣[k] γ =
      primeHeckeCuspFunction N p k hp f := by
  sorry

/-- Holomorphicity of the prime Hecke formula on cusp forms. -/
theorem primeHeckeCusp_holomorphic (N p : ℕ) (k : ℤ) (hp : p.Prime)
    (hcop : Nat.Coprime p N) (f : CuspForm (Gamma0 N) k) :
    MDifferentiable 𝓘(ℂ) 𝓘(ℂ) (primeHeckeCuspFunction N p k hp f) := by
  sorry

/-- Vanishing at infinity of the prime Hecke formula on cusp forms. -/
theorem primeHecke_zero_at_infty (N p : ℕ) (k : ℤ) (hp : p.Prime)
    (hcop : Nat.Coprime p N) (f : CuspForm (Gamma0 N) k) :
    ∀ A : SL(2, ℤ), IsZeroAtImInfty (primeHeckeCuspFunction N p k hp f ∣[k] A) := by
  sorry

/-- The bundled cusp form obtained from the concrete prime Hecke formula. -/
def primeHeckeCuspFormAux (N p : ℕ) (k : ℤ) (hp : p.Prime)
    (hcop : Nat.Coprime p N) (f : CuspForm (Gamma0 N) k) :
    CuspForm (Gamma0 N) k where
  toSlashInvariantForm :=
    { toFun := primeHeckeCuspFunction N p k hp f
      slash_action_eq' := primeHeckeCusp_slash_invariant N p k hp hcop f }
  holo' := primeHeckeCusp_holomorphic N p k hp hcop f
  zero_at_infty' := primeHecke_zero_at_infty N p k hp hcop f

@[simp]
theorem primeHeckeCuspFormAux_apply (N p : ℕ) (k : ℤ) (hp : p.Prime)
    (hcop : Nat.Coprime p N) (f : CuspForm (Gamma0 N) k) (z : ℍ) :
    primeHeckeCuspFormAux N p k hp hcop f z =
      (p : ℂ) ^ (k - 1) * f (mulNatMap p hp.pos z)
        + ((p : ℂ)⁻¹) * ∑ j ∈ Finset.range p, f (addNatDivMap p hp.pos j z) :=
  rfl

/-- The prime Hecke operator on cusp forms of level `Gamma0 N`, for `p ∤ N`. -/
def primeHeckeCuspForm (N p : ℕ) (k : ℤ) (hp : p.Prime)
    (hcop : Nat.Coprime p N) : CuspForm (Gamma0 N) k →ₗ[ℂ] CuspForm (Gamma0 N) k where
  toFun := primeHeckeCuspFormAux N p k hp hcop
  map_add' := by
    intro f g
    ext z
    simp [primeHeckeCuspFunction, Finset.sum_add_distrib, mul_add]
    ring
  map_smul' := by
    intro c f
    ext z
    simp [primeHeckeCuspFunction, Finset.mul_sum, Algebra.id.smul_eq_mul]
    have hsum :
        (∑ x ∈ Finset.range p, (p : ℂ)⁻¹ * (c * f (addNatDivMap p hp.pos x z))) =
          c * ∑ x ∈ Finset.range p, (p : ℂ)⁻¹ * f (addNatDivMap p hp.pos x z) := by
      rw [Finset.mul_sum]
      exact Finset.sum_congr rfl fun x _ => by ring
    rw [hsum]
    ring

/-- A concrete eigenform predicate for all prime Hecke operators away from `N`. -/
def IsPrimeHeckeEigenform (N : ℕ) (k : ℤ)
    (f : ModularForm (Gamma0 N) k) (a : ℕ → ℂ) : Prop :=
  ∀ p : ℕ, ∀ hp : p.Prime, ∀ hcop : Nat.Coprime p N,
    primeHeckeOperator N p k hp hcop f = a p • f

/-- Eigenvalue data for the concrete prime Hecke operators away from `N`. -/
structure PrimeHeckeEigenvalueSystem (N : ℕ) (k : ℤ)
    (f : ModularForm (Gamma0 N) k) where
  eigenvalue : ℕ → ℂ
  is_eigenform : IsPrimeHeckeEigenform N k f eigenvalue

/-- Convert concrete prime Hecke eigenvalue data to the abstract indexed interface. -/
def PrimeHeckeEigenvalueSystem.toAbstract {N : ℕ} {k : ℤ}
    {f : ModularForm (Gamma0 N) k} (s : PrimeHeckeEigenvalueSystem N k f) :
    HeckeEigenvalueSystem
      (fun q : {p : ℕ // p.Prime ∧ Nat.Coprime p N} =>
        primeHeckeOperator N q.1 k q.2.1 q.2.2) f where
  eigenvalue q := s.eigenvalue q.1
  is_eigenform q := s.is_eigenform q.1 q.2.1 q.2.2

end HeckeOperatorReal
end NumberTheory
