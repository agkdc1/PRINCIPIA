/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import Mathlib.FieldTheory.AbsoluteGaloisGroup
import Mathlib.Topology.Algebra.ContinuousMonoidHom
import Mathlib.Topology.Algebra.Module.Basic

/-!
# Galois representations

This file supplies a small interface for Galois representations, intended as
the first atomic bridge between Mathlib's Galois theory and the FLT
modularity dependency chain.
-/

universe u v w

namespace NumberTheory

/--
A continuous Galois representation on a module `M` over a coefficient semiring
`R`, with source a topological monoid `G`, is a continuous monoid homomorphism
from `G` to the multiplicative monoid of linear automorphisms of `M`.

In arithmetic applications `G` is typically an absolute Galois group.
-/
abbrev GaloisRepresentation (G : Type u) (R : Type v) (M : Type w)
    [TopologicalSpace G] [Monoid G] [TopologicalSpace R] [Semiring R]
    [TopologicalSpace M] [AddCommMonoid M] [Module R M]
    [TopologicalSpace (M ≃ₗ[R] M)] :=
  ContinuousMonoidHom G (M ≃ₗ[R] M)

end NumberTheory
