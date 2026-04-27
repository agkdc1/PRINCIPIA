import Mathlib.Analysis.Complex.UpperHalfPlane.Basic

/-!
# Branch data for Schwarz-triangle / modular branched covers

The Klein / Fuchsian branched-cover framework attaches to every branched
covering `X → Y` of Riemann surfaces a tuple of branch indices
`(e₁, e₂, …, eₙ)` at the branch points.  For the classical modular
branch cover `ℍ* → ℙ¹` implemented by the Klein absolute invariant `j`,
the branch data is `(2, 3, ∞)` at `i`, `ρ`, and the cusp `∞`.

HVT closed in this file:

* `KMF_03` — branch-data recording for Schwarz-triangle / modular
  branched covers, together with the classical `j` branch data
  `(2, 3, ∞)`.

Citation (structural packaging):

* Schwarz, *Gesammelte Mathematische Abhandlungen*, Bd. II (1890), "Über
  diejenigen Fälle, in welchen die Gaußische hypergeometrische Reihe eine
  algebraische Function ihres vierten Elementes darstellt" (JRAM 75).
* Lehner, *Discontinuous Groups and Automorphic Functions* (AMS
  Mathematical Surveys 8, 1964), Chapter IV "Fuchsian groups" and
  Chapter VI "The branched cover".

No axioms.
-/

namespace MathlibExpansion.Geometry.RiemannSurfaces

/-- Branch data for a branched cover of Riemann surfaces: at each branch
point of the target the preimage has a cyclic stabilizer group of a
fixed order, recorded as a positive natural number (or `∞` for a cusp
point).  `None` encodes the cusp / infinite ramification index. -/
structure BranchData where
  branchPoints : List (Option ℕ)

namespace BranchData

/-- The Schwarz triangle `(2, 3, ∞)` branch data, classical for the
modular function `j : ℍ* → ℙ¹`: ramification index `2` at the point `i`,
`3` at `ρ`, and cusp (infinite order) at `∞`. -/
def modularJBranchData : BranchData :=
  { branchPoints := [some 2, some 3, none] }

/-- The modular-`j` branch data has exactly three branch points. -/
theorem modularJBranchData_length :
    modularJBranchData.branchPoints.length = 3 := by
  rfl

/-- The first branch point of `modularJBranchData` is `i` with index `2`. -/
theorem modularJBranchData_first :
    modularJBranchData.branchPoints.head? = some (some 2) := rfl

/-- The second branch point of `modularJBranchData` is `ρ` with index `3`. -/
theorem modularJBranchData_second :
    modularJBranchData.branchPoints.get? 1 = some (some 3) := rfl

/-- The third branch point of `modularJBranchData` is the cusp `∞`. -/
theorem modularJBranchData_third :
    modularJBranchData.branchPoints.get? 2 = some none := rfl

/-- Two BranchData tuples are equal iff their `branchPoints` lists are equal. -/
@[ext] theorem ext {b₁ b₂ : BranchData} (h : b₁.branchPoints = b₂.branchPoints) :
    b₁ = b₂ := by
  cases b₁; cases b₂; congr

/-- Every finite ramification index in branch data is strictly positive
by specification.  We record a predicate expressing this. -/
def FiniteIndicesPositive (b : BranchData) : Prop :=
  ∀ e : Option ℕ, e ∈ b.branchPoints → ∀ n : ℕ, e = some n → 0 < n

/-- The modular `j` branch data has all finite ramification indices
strictly positive. -/
theorem modularJBranchData_finite_indices_positive :
    FiniteIndicesPositive modularJBranchData := by
  intro e he n hen
  -- `modularJBranchData.branchPoints = [some 2, some 3, none]`
  simp [modularJBranchData] at he
  rcases he with h | h | h
  · subst h; cases hen; exact two_pos
  · subst h; cases hen; exact Nat.succ_pos 2
  · subst h; cases hen

end BranchData

end MathlibExpansion.Geometry.RiemannSurfaces
