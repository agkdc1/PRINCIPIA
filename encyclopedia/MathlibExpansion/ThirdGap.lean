/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import MathlibExpansion.SecondGap

/-!
# Hecke eigenforms

This file supplies the smallest interface for modular forms that are
eigenvectors for a Hecke operator. It is intended as the third atomic bridge
in the FLT modularity dependency chain, after Galois representations and
Hecke operators on modular forms.
-/

open scoped MatrixGroups

namespace NumberTheory

/--
A modular form `f` is a Hecke eigenform for a Hecke operator `T` with
eigenvalue `a` if applying `T` to `f` is the same as scaling `f` by `a`.
-/
def IsHeckeEigenform {Γ : Subgroup SL(2, ℤ)} {k : ℤ}
    (T : HeckeOperator Γ k) (a : ℂ) (f : ModularForm Γ k) : Prop :=
  T f = a • f

@[simp]
theorem IsHeckeEigenform.zero {Γ : Subgroup SL(2, ℤ)} {k : ℤ}
    (T : HeckeOperator Γ k) (a : ℂ) :
    IsHeckeEigenform T a 0 := by
  simp [IsHeckeEigenform]

theorem IsHeckeEigenform.smul {Γ : Subgroup SL(2, ℤ)} {k : ℤ}
    {T : HeckeOperator Γ k} {a : ℂ} {f : ModularForm Γ k}
    (h : IsHeckeEigenform T a f) (c : ℂ) :
    IsHeckeEigenform T a (c • f) := by
  rw [IsHeckeEigenform] at h ⊢
  calc
    T (c • f) = c • T f := by
      exact map_smul T c f
    _ = c • (a • f) := by
      rw [h]
    _ = a • (c • f) := by
      rw [smul_smul, smul_smul, mul_comm]

end NumberTheory
