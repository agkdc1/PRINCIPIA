/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import Mathlib.NumberTheory.ModularForms.Basic

/-!
# Hecke operators on modular forms

This file supplies the smallest interface for Hecke operators acting on a
fixed space of modular forms. It is intended as the second atomic bridge in
the FLT modularity dependency chain, after the basic Galois representation
interface.
-/

open Complex

open scoped MatrixGroups

namespace NumberTheory

/--
A Hecke operator on modular forms of level `Γ` and weight `k` is a complex
linear endomorphism of the corresponding space of modular forms.
-/
abbrev HeckeOperator (Γ : Subgroup SL(2, ℤ)) (k : ℤ) :=
  Module.End ℂ (ModularForm Γ k)

@[simp]
theorem HeckeOperator.map_zero {Γ : Subgroup SL(2, ℤ)} {k : ℤ}
    (T : HeckeOperator Γ k) :
    T 0 = 0 :=
  LinearMap.map_zero T

end NumberTheory
