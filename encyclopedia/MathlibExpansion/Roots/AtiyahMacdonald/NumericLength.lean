import Mathlib.Data.ENat.Lattice
import Mathlib.RingTheory.FiniteLength

/-!
# Atiyah-Macdonald numerics substrate: finite-length module length

This file packages the finite-length API already present in Mathlib into the
canonical numerics surface consumed by the Diamond 1996 breach.

The pinned Mathlib snapshot gives us:

- `IsFiniteLength R M`,
- existence of composition series for finite-length modules,
- Jordan-Hölder length invariance on composition series.

We use those ingredients to expose:

- a chosen composition series for a finite-length module,
- a derived natural-number length,
- an internal `ℕ∞` wrapper that records `⊤` outside the finite-length regime.

This file deliberately stays conservative: it does not try to rebuild the full
upstream `Module.length` API, but it gives the Diamond/BCDT numerics boundary a
canonical length assignment that is theorem-land in the current snapshot.
-/

namespace MathlibExpansion.Roots.AtiyahMacdonald

universe u v

section NumericLength

variable {R : Type u} [Ring R]
variable {M : Type v} [AddCommGroup M] [Module R M]

/-- Choose a composition series for a finite-length module. -/
noncomputable def compositionSeriesOfFiniteLength (h : IsFiniteLength R M) :
    CompositionSeries (Submodule R M) :=
  Classical.choose ((isFiniteLength_iff_exists_compositionSeries (R := R) (M := M)).mp h)

/-- The chosen finite-length composition series starts at `⊥`. -/
theorem compositionSeriesOfFiniteLength_head_eq_bot (h : IsFiniteLength R M) :
    (compositionSeriesOfFiniteLength (R := R) (M := M) h).head = ⊥ :=
  (Classical.choose_spec
    ((isFiniteLength_iff_exists_compositionSeries (R := R) (M := M)).mp h)).1

/-- The chosen finite-length composition series ends at `⊤`. -/
theorem compositionSeriesOfFiniteLength_last_eq_top (h : IsFiniteLength R M) :
    (compositionSeriesOfFiniteLength (R := R) (M := M) h).last = ⊤ :=
  (Classical.choose_spec
    ((isFiniteLength_iff_exists_compositionSeries (R := R) (M := M)).mp h)).2

/-- Natural-number length extracted from a chosen composition series. -/
noncomputable def finiteLengthNat (h : IsFiniteLength R M) : ℕ :=
  (compositionSeriesOfFiniteLength (R := R) (M := M) h).length

/-- By definition, `finiteLengthNat` is the length of the chosen composition series. -/
@[simp]
theorem finiteLengthNat_eq_length (h : IsFiniteLength R M) :
    finiteLengthNat (R := R) (M := M) h =
      (compositionSeriesOfFiniteLength (R := R) (M := M) h).length :=
  rfl

/-- Internal `ℕ∞`-valued length used by the A-M bridge.

Finite-length modules get the natural-number length extracted above; modules
outside the finite-length regime are sent to `⊤`.
-/
noncomputable def moduleLength
    (R : Type u) [Ring R]
    (M : Type v) [AddCommGroup M] [Module R M] : ℕ∞ := by
  classical
  exact if h : IsFiniteLength R M then (finiteLengthNat (R := R) (M := M) h : ℕ∞) else ⊤

/-- In the finite-length regime, `moduleLength` is the coercion of `finiteLengthNat`. -/
theorem moduleLength_eq_coe_finiteLengthNat (h : IsFiniteLength R M) :
    moduleLength (R := R) (M := M) = (finiteLengthNat (R := R) (M := M) h : ℕ∞) := by
  classical
  unfold moduleLength
  rw [dif_pos h]

/-- Outside the finite-length regime, `moduleLength = ⊤`. -/
theorem moduleLength_eq_top (h : ¬ IsFiniteLength R M) :
    moduleLength (R := R) (M := M) = ⊤ := by
  classical
  unfold moduleLength
  rw [dif_neg h]

/-- `moduleLength` is never `⊤` for a finite-length module. -/
theorem moduleLength_ne_top (h : IsFiniteLength R M) :
    moduleLength (R := R) (M := M) ≠ ⊤ := by
  rw [moduleLength_eq_coe_finiteLengthNat (R := R) (M := M) h]
  simp

/-- Every module falls into one of the two canonical `moduleLength` cases. -/
theorem moduleLength_eq_top_or_eq_coe :
    moduleLength (R := R) (M := M) = ⊤ ∨
      ∃ h : IsFiniteLength R M,
        moduleLength (R := R) (M := M) = (finiteLengthNat (R := R) (M := M) h : ℕ∞) := by
  classical
  by_cases h : IsFiniteLength R M
  · right
    exact ⟨h, moduleLength_eq_coe_finiteLengthNat (R := R) (M := M) h⟩
  · left
    exact moduleLength_eq_top (R := R) (M := M) h

end NumericLength

end MathlibExpansion.Roots.AtiyahMacdonald
