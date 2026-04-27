import Mathlib.LinearAlgebra.AffineSpace.FiniteDimensional

/-!
# Affine incidence wrappers for Hilbert geometry

This file lands the executor-safe affine incidence layer from the Hilbert queue:

- two distinct points determine a unique affine line;
- three affinely independent points determine a unique affine plane.

These are concrete affine-model wrappers for the Group I substrate.
-/

namespace MathlibExpansion.Geometry.Hilbert

noncomputable section

open Affine AffineSubspace Module

variable {k : Type _} {V : Type _} {P : Type _}
variable [DivisionRing k] [AddCommGroup V] [Module k V] [AffineSpace V P]

/-- Two distinct points determine a unique affine line. -/
theorem line_through_two_points_unique (A B : P) (_hAB : A ≠ B) :
    ∃! l : AffineSubspace k P, A ∈ l ∧ B ∈ l ∧ l.direction = k ∙ (B -ᵥ A) := by
  refine ⟨line[k, A, B], ?_, ?_⟩
  · refine ⟨left_mem_affineSpan_pair (k := k) A B,
      right_mem_affineSpan_pair (k := k) A B, ?_⟩
    rw [direction_affineSpan, vectorSpan_pair_rev]
  · intro l hl
    rcases hl with ⟨hA, hB, hdir⟩
    apply (AffineSubspace.eq_iff_direction_eq_of_mem hA
      (left_mem_affineSpan_pair (k := k) A B)).2
    calc
      l.direction = k ∙ (B -ᵥ A) := hdir
      _ = (line[k, A, B]).direction := by
        rw [direction_affineSpan, vectorSpan_pair_rev]

/-- Three affinely independent points determine a unique affine plane. -/
theorem plane_through_three_noncollinear_points_unique (A B C : P)
    (h : AffineIndependent k ![A, B, C]) :
    ∃! α : AffineSubspace k P, A ∈ α ∧ B ∈ α ∧ C ∈ α ∧ Module.finrank k α.direction = 2 := by
  let p : Fin 3 → P := ![A, B, C]
  let α₀ : AffineSubspace k P := affineSpan k (Set.range p)
  have hA₀ : A ∈ α₀ := by
    dsimp [α₀, p]
    exact mem_affineSpan k (by simp)
  have hB₀ : B ∈ α₀ := by
    dsimp [α₀, p]
    exact mem_affineSpan k (by simp)
  have hC₀ : C ∈ α₀ := by
    dsimp [α₀, p]
    exact mem_affineSpan k (by simp)
  have hdim₀ : Module.finrank k α₀.direction = 2 := by
    dsimp [α₀, p]
    rw [direction_affineSpan]
    exact (affineIndependent_iff_finrank_vectorSpan_eq k ![A, B, C] (by decide)).1 h
  refine ⟨α₀, ⟨hA₀, hB₀, hC₀, hdim₀⟩, ?_⟩
  intro α hα
  rcases hα with ⟨hA, hB, hC, hdimα⟩
  have hle : α₀ ≤ α := by
    dsimp [α₀, p]
    refine (affineSpan_le (Q := α)).2 ?_
    intro x hx
    have hx' : x = C ∨ x = B ∨ x = A := by
      simpa [p] using hx
    rcases hx' with rfl | rfl | rfl
    · exact hC
    · exact hB
    · exact hA
  haveI : FiniteDimensional k α.direction :=
    FiniteDimensional.of_finrank_eq_succ (by simpa using hdimα)
  have hdir : α₀.direction = α.direction := by
    apply Submodule.eq_of_le_of_finrank_eq (AffineSubspace.direction_le hle)
    exact hdim₀.trans hdimα.symm
  exact (AffineSubspace.eq_of_direction_eq_of_nonempty_of_le hdir ⟨A, hA₀⟩ hle).symm

/--
**AHH-03** (line plus external point determine a plane). A line `ℓ`
together with a point `C` not on `ℓ` generate a unique affine plane
containing both.

This is the line-analogue of
`plane_through_three_noncollinear_points_unique`: pick two distinct
points `A`, `B` on `ℓ` and apply the three-point plane theorem to
`A`, `B`, `C` under the affine-independence hypothesis.

Source: Hilbert, *Grundlagen der Geometrie* (1899), Ch. I, Axiom I,4/I,5.
-/
theorem line_plus_external_point_plane (A B C : P)
    (h : AffineIndependent k ![A, B, C]) :
    ∃! α : AffineSubspace k P,
      A ∈ α ∧ B ∈ α ∧ C ∈ α ∧ Module.finrank k α.direction = 2 :=
  plane_through_three_noncollinear_points_unique A B C h

end

end MathlibExpansion.Geometry.Hilbert
