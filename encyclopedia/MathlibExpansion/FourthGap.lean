/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import MathlibExpansion.ThirdGap

/-!
# Hecke eigenvalue systems

This file supplies the next interface after a single modular Hecke eigenform
predicate: an indexed family of Hecke operators with compatible eigenvalues
for the same modular form. This is the fourth atomic bridge in the FLT
modularity dependency chain, preparing statements that compare Frobenius
traces of attached Galois representations with Hecke eigenvalues.
-/

open scoped MatrixGroups

namespace NumberTheory

/--
A Hecke eigenvalue system for a modular form `f` consists of an eigenvalue for
each Hecke operator in an indexed family `T`, together with the proof that `f`
is an eigenform for every operator in that family.
-/
structure HeckeEigenvalueSystem {Γ : Subgroup SL(2, ℤ)} {k : ℤ} {ι : Type*}
    (T : ι → HeckeOperator Γ k) (f : ModularForm Γ k) where
  eigenvalue : ι → ℂ
  is_eigenform : ∀ i, IsHeckeEigenform (T i) (eigenvalue i) f

/--
Recover the single-operator Hecke eigenform statement at an index from a
Hecke eigenvalue system.
-/
theorem HeckeEigenvalueSystem.isHeckeEigenform {Γ : Subgroup SL(2, ℤ)} {k : ℤ}
    {ι : Type*} {T : ι → HeckeOperator Γ k} {f : ModularForm Γ k}
    (s : HeckeEigenvalueSystem T f) (i : ι) :
    IsHeckeEigenform (T i) (s.eigenvalue i) f :=
  s.is_eigenform i

/--
The zero modular form has a Hecke eigenvalue system for any indexed family of
Hecke operators, with all eigenvalues chosen to be zero.
-/
@[simps]
def HeckeEigenvalueSystem.zero {Γ : Subgroup SL(2, ℤ)} {k : ℤ} {ι : Type*}
    (T : ι → HeckeOperator Γ k) : HeckeEigenvalueSystem T 0 where
  eigenvalue _ := 0
  is_eigenform i := IsHeckeEigenform.zero (T i) 0

/--
Scalar multiples of a modular form inherit the same Hecke eigenvalue system.
-/
@[simps]
def HeckeEigenvalueSystem.smul {Γ : Subgroup SL(2, ℤ)} {k : ℤ} {ι : Type*}
    {T : ι → HeckeOperator Γ k} {f : ModularForm Γ k}
    (s : HeckeEigenvalueSystem T f) (c : ℂ) :
    HeckeEigenvalueSystem T (c • f) where
  eigenvalue := s.eigenvalue
  is_eigenform i := (s.isHeckeEigenform i).smul c

/--
A single Hecke eigenform can be packaged as a one-index Hecke eigenvalue
system.
-/
@[simps]
def HeckeEigenvalueSystem.of_single {Γ : Subgroup SL(2, ℤ)} {k : ℤ}
    (T : HeckeOperator Γ k) (a : ℂ) {f : ModularForm Γ k}
    (h : IsHeckeEigenform T a f) :
    HeckeEigenvalueSystem (fun _ : PUnit => T) f where
  eigenvalue _ := a
  is_eigenform _ := h

end NumberTheory
