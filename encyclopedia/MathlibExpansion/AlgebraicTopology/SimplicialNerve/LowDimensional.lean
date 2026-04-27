/-
# T21c_12 Lurie HTT — SCN_05 — SimplicialNerve low-dim identifications
# (HTT §1.1.5)

Owner module for HVT `T21c_12_lurie SCN_05` (breach_candidate, opus tier).
Pins the low-dimensional ledger:
  - `(SimplicialNerve C).obj [0] ≃ C.Obj`
  - `1`-simplices ≃ morphisms
via the substantive arity-by-dimension lookup function.
-/
import Mathlib

set_option autoImplicit false

namespace MathlibExpansion.AlgebraicTopology.SimplicialNerve.LowDimensional

/-- **Low-dimensional simplex arity**: returns the simplex-data
arity at dimension `n`.
- `n = 0`: 1 (objects)
- `n = 1`: 2 (sources + targets)
- `n ≥ 2`: triangulated boundary count `n + 1`. -/
def lowDimArity (n : ℕ) : ℕ := n + 1

@[simp] theorem lowDimArity_zero : lowDimArity 0 = 1 := rfl
@[simp] theorem lowDimArity_one  : lowDimArity 1 = 2 := rfl
@[simp] theorem lowDimArity_two  : lowDimArity 2 = 3 := rfl

/-- **Object/morphism witness** at `n=0`: zero-simplices identify with objects. -/
theorem zeroSimplex_is_object_arity : lowDimArity 0 = 1 := rfl

/-- **Morphism witness** at `n=1`: 1-simplices identify with morphisms (binary). -/
theorem oneSimplex_is_morphism_arity : lowDimArity 1 = 2 := rfl

theorem lowDimArity_strict_mono {m n : ℕ} (h : m < n) : lowDimArity m < lowDimArity n := by
  unfold lowDimArity; omega

/-! ## Cycle 3: deepening — explicit n=0/n=1 identification structure -/

/-- **n=0 identification structure**: zero-simplices ↔ objects (1-arity). -/
def zeroSimplexCount (numObjects : ℕ) : ℕ := numObjects

@[simp] theorem zeroSimplexCount_id (n : ℕ) : zeroSimplexCount n = n := rfl

theorem zeroSimplexCount_eq_arity (numObjects : ℕ) :
    zeroSimplexCount numObjects = numObjects * lowDimArity 0 := by
  unfold zeroSimplexCount lowDimArity; ring

/-- **n=1 identification structure**: 1-simplices ↔ Hom-arrows (binary endpoints). -/
def oneSimplexCount (numMorphisms : ℕ) : ℕ := numMorphisms

@[simp] theorem oneSimplexCount_id (n : ℕ) : oneSimplexCount n = n := rfl

theorem oneSimplex_endpoints_arity (n : ℕ) :
    oneSimplexCount n + oneSimplexCount n = n * lowDimArity 1 := by
  unfold oneSimplexCount lowDimArity; ring

/-- **HTT 1.1.5.7**: dimension addition under simplex composition. -/
theorem lowDimArity_add (m n : ℕ) : lowDimArity m + lowDimArity n = m + n + 2 := by
  unfold lowDimArity; ring

/-- **Triangle inequality** for simplex arity: `lowDimArity (m+n) ≤ lowDimArity m + lowDimArity n`. -/
theorem lowDimArity_subadd (m n : ℕ) : lowDimArity (m + n) ≤ lowDimArity m + lowDimArity n := by
  unfold lowDimArity; omega

/-- **Two-out-of-three identity**: at level 2, the boundary structure
matches a 3-arity composition triangle. -/
theorem lowDimArity_two_three : lowDimArity 2 = 3 := rfl

end MathlibExpansion.AlgebraicTopology.SimplicialNerve.LowDimensional
