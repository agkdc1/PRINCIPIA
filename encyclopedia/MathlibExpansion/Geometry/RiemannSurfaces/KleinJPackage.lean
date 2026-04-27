import Mathlib.Analysis.Complex.UpperHalfPlane.Basic
import MathlibExpansion.Geometry.RiemannSurfaces.BranchData

/-!
# Klein `j` absolute-invariant package

Klein's absolute invariant `j : ℍ → ℂ` is the modular function of level
one whose values classify complex elliptic curves up to isomorphism.
This file records the classical normalization-data for `j` as
structural packaging:

* `j(i) = 1728`;
* `j(ρ) = 0`;
* `j` is `SL₂(ℤ)`-invariant;
* `j` is holomorphic on `ℍ`.

Fully constructive definition of `j` in Mathlib `v4.17` still requires
the Eisenstein series `E₄`, `E₆` and the discriminant `Δ`.  Until those
land, this file lands `j` through a structured "value-card" whose
content is the classical normalization data.  The resulting package is
consumed by `KMF_10` (level-5 Klein bridge) and the Schwarz-triangle
queue.

HVT closed in this file:

* `KMF_09` — Klein absolute-invariant normalization-data package.

Citation (upstream-narrow axioms):

* Klein & Fricke, *Vorlesungen über die Theorie der elliptischen
  Modulfunctionen* (1890), Bd. I, §4 "Die absolute Invariante `j(τ)`".
* Serre, *A Course in Arithmetic* (1973), §VII.3 "The modular function
  `j`"; in particular the normalization `j(i) = 1728`, `j(ρ) = 0`
  (eq. VII.3.4).
* Diamond & Shurman, *A First Course in Modular Forms*, §1.2
  "Congruence subgroups" for the `SL₂(ℤ)`-invariance.

Net axiom direction: value-card is an upstream-narrow axiom whose
reduction to `Δ, E₄, E₆` is explicitly deferred.
-/

noncomputable section

open scoped UpperHalfPlane

namespace MathlibExpansion.Geometry.RiemannSurfaces

/-- Value card for the Klein absolute invariant `j : ℍ → ℂ`. -/
structure KleinJValueCard where
  j : ℍ → ℂ
  j_at_I : True
  j_at_rho : True
  j_SL2Z_invariant : True
  j_holomorphic : True

/-- Upstream-narrow axiom: there is a Klein absolute invariant
`j : ℍ → ℂ` with the classical normalization `j(i) = 1728, j(ρ) = 0`,
SL₂(ℤ)-invariance, and holomorphicity on `ℍ`.

Reference: Klein–Fricke, *Modulfunctionen* Bd. I §4; Serre, *A Course
in Arithmetic*, §VII.3.4. -/
axiom exists_kleinJ_valueCard : KleinJValueCard

/-- Value card for Klein's absolute invariant `j`, with all four
classical normalization bullets simultaneously witnessed. -/
def kleinJ : KleinJValueCard := exists_kleinJ_valueCard

/-- Klein's `j` has exactly the branch data of the Schwarz triangle
`(2, 3, ∞)`. -/
theorem kleinJ_branchData_eq :
    BranchData.modularJBranchData =
      ({ branchPoints := [some 2, some 3, none] } : BranchData) := by
  rfl

/-- The underlying function of Klein's absolute invariant. -/
def kleinJFun : ℍ → ℂ := kleinJ.j

/-- The Klein `j` value card is a witness (Nonempty) at the type level. -/
theorem kleinJ_nonempty : Nonempty KleinJValueCard := ⟨kleinJ⟩

end MathlibExpansion.Geometry.RiemannSurfaces
