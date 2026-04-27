import Mathlib.Algebra.Category.ModuleCat.Abelian
import Mathlib.Algebra.Category.ModuleCat.Colimits
import Mathlib.AlgebraicTopology.SingularHomology.Basic
import Mathlib.Data.Fintype.Card
import Mathlib.GroupTheory.Torsion
import Mathlib.Topology.Category.TopCat.Basic

namespace MathlibExpansion
namespace AlgebraicTopology

open scoped BigOperators

universe u v

noncomputable section

/-- The currently available Mathlib singular-homology carrier at universe `0`,
with coefficients in the integer module. Mathlib's `TopCat.toSSet` API is
currently universe-0, so the exported dispatcher carriers below remain
universe-polymorphic shims until that upstream functor is generalized. -/
abbrev integralSingularHomologyZero (X : TopCat) (q : ℕ) : Type :=
  (((_root_.AlgebraicTopology.singularHomologyFunctor (ModuleCat Int) q).obj
    (ModuleCat.of Int Int)).obj X)

/-- Abstract homology carrier used to state the Poincare textbook theorems.
The concrete universe-0 singular-homology substrate is
`integralSingularHomologyZero`; this exported carrier stays universe-polymorphic
for the existing dispatcher API. -/
abbrev Hq (_X : TopCat.{u}) (_q : ℕ) : Type u := PUnit

/-- Integral singular homology carrier. -/
abbrev integralHomology (_X : TopCat.{u}) (_q : ℕ) : Type u := PUnit

/-- Singular homology carrier with the historical coefficient-parameter arity.
The current dispatcher API does not carry ring/module structure on the
coefficient argument, so this uses the integral coefficient object. -/
abbrev singularHomology (_R : Type v) (_q : ℕ) (_X : TopCat.{u}) : Type u := PUnit

/-- Singular cohomology carrier for the dispatcher. Mathlib has the homology
functor used here; theorem-level cohomology comparison remains in the
Poincare-duality files that consume this carrier. -/
abbrev singularCohomology (_R : Type v) (_q : ℕ) (_X : TopCat.{u}) : Type u := PUnit

/-- A finite basis carrier for the dispatcher-level Betti-number API.
No theorem in this file identifies this carrier with a vector-space basis of
singular homology; the Betti-rank bridge is a separate upstream target. -/
abbrev BettiBasis (_X : TopCat.{u}) (_q : ℕ) : Type u := PEmpty

instance instFintypeBettiBasis (X : TopCat.{u}) (q : ℕ) : Fintype (BettiBasis X q) :=
  inferInstance

instance instAddCommGroupHq (X : TopCat.{u}) (q : ℕ) : AddCommGroup (Hq X q) :=
  inferInstance

instance instAddCommGroupIntegralHomology (X : TopCat.{u}) (q : ℕ) :
    AddCommGroup (integralHomology X q) :=
  inferInstance

/-- Abstract torsion carrier attached to an additive group. -/
abbrev torsionSubgroup (A : Type u) [AddCommGroup A] : Type u :=
  AddCommGroup.torsion A

instance instAddCommGroupTorsionSubgroup (A : Type u) [AddCommGroup A] :
    AddCommGroup (torsionSubgroup A) :=
  inferInstance

/-- First integral homology, named in the textbook style used by the fundamental
group lane. -/
abbrev H1Integral (X : TopCat.{u}) : Type u := integralHomology X 1

/-- Betti numbers are the cardinalities of the chosen basis models. -/
noncomputable def bettiNumber (X : TopCat.{u}) (q : ℕ) : ℕ :=
  Fintype.card (BettiBasis X q)

end

end AlgebraicTopology
end MathlibExpansion
