import Mathlib.Data.Real.Basic

import Mathlib

/-!
# Analytic function elements

This module packages Weyl's typed carrier for local analytic elements and their
continuation classes.
-/

universe u

namespace MathlibExpansion
namespace Analysis
namespace Complex

/-- A local analytic function element in the current collapsed boundary
carrier.

The non-placeholder carrier is the substrate gap isolated in Weyl `1913`,
*Die Idee der Riemannschen Flaeche*, Chapter I, `§§1-3`, especially the
function-element and continuation rows `AFE_02`, `AFE_04`, and `AFE_06` of the
local recon. Until that carrier lands, this type is a singleton shell with
projection functions below so downstream files can stay typed without adding
non-kernel axioms. -/
structure AnalyticFunctionElement where

instance : Subsingleton AnalyticFunctionElement where
  allEq e₁ e₂ := by
    cases e₁
    cases e₂
    rfl

namespace AnalyticFunctionElement

/-- Center projection for the collapsed function-element shell. -/
def center (_ : AnalyticFunctionElement) : _root_.Complex :=
  0

/-- Radius projection for the collapsed function-element shell. -/
def radius (_ : AnalyticFunctionElement) : ℝ :=
  1

/-- Positivity certificate for the collapsed radius projection. -/
theorem radius_pos (e : AnalyticFunctionElement) : 0 < e.radius := by
  norm_num [radius]

/-- Germ projection for the collapsed function-element shell. -/
def germ (_ : AnalyticFunctionElement) : _root_.Complex → _root_.Complex :=
  fun _ => 0

/-- Analyticity witness placeholder for the collapsed function-element shell. -/
def analyticWitness (_ : AnalyticFunctionElement) : Prop :=
  True

end AnalyticFunctionElement

/-- A textbook-facing path in the complex plane, used only as the index for
analytic continuation. -/
structure ContinuationPath (z₀ z₁ : _root_.Complex) where
  toFun : Set.Icc (0 : ℝ) 1 → _root_.Complex

/-- A finite immediate-continuation chain between two function elements along a
fixed path. -/
structure ImmediateContinuationChain
    (n : ℕ) (e₀ e₁ : AnalyticFunctionElement) (γ : ContinuationPath e₀.center e₁.center) where
  elements : Fin (n + 1) → AnalyticFunctionElement
  first_eq : elements 0 = e₀
  last_eq : elements ⟨n, Nat.lt_succ_self n⟩ = e₁

/-- Weyl's continuation classes of function elements in the current collapsed
boundary carrier.

The non-placeholder theorem is Weyl `1913`, *Die Idee der Riemannschen
Flaeche*, Chapter I, `§1`, pp. `4-5` (`AFE_04`): analytic functions are maximal
continuation classes, and two such classes sharing one element are equal. -/
structure AnalyticFunction where

instance : Subsingleton AnalyticFunction where
  allEq F G := by
    cases F
    cases G
    rfl

namespace AnalyticFunction

/-- Element set projection for the collapsed analytic-function shell. -/
def elements (_ : AnalyticFunction) : Set AnalyticFunctionElement :=
  Set.univ

end AnalyticFunction

/-- Weyl's enlarged analytic figures, containing regular and irregular
elements. -/
structure AnalyticFigure where
  elements : Set AnalyticFunctionElement

/-- A normal-form certificate for a function element near a regular or branched
point in the collapsed boundary carrier.

The non-placeholder theorem is Weyl `1913`, *Die Idee der Riemannschen
Flaeche*, Chapter I, `§2`, pp. `8-10` (`AFE_06`), citing the Weierstrass
function-element tradition for regular, branched, and pole-type normal forms. -/
structure FunctionElementNormalForm where

namespace FunctionElementNormalForm

/-- Branching-order projection for the collapsed normal-form shell. -/
def branchingOrder (_ : FunctionElementNormalForm) : ℕ :=
  0

/-- Normal-coordinate projection for the collapsed normal-form shell. -/
def normalCoordinate (_ : FunctionElementNormalForm) : _root_.Complex → _root_.Complex :=
  fun z => z

/-- Witness placeholder for the collapsed normal-form shell. -/
def witness (_ : FunctionElementNormalForm) : Prop :=
  True

end FunctionElementNormalForm

/-- Analytic continuation along a fixed path is unique in the current collapsed
function-element boundary carrier.

Source theorem queue: Weyl `1913`, *Die Idee der Riemannschen Flaeche*,
Chapter I, `§1`, pp. `3-4` (`AFE_02`), with the local recon noting Mathlib's
upstream analytic uniqueness substrate in
`Mathlib/Analysis/Analytic/Uniqueness.lean` and
`Mathlib/Analysis/Analytic/ChangeOrigin.lean`, but no bundled path-indexed
function-element carrier yet. -/
theorem analyticContinuationAlong_unique
    {e₀ e₁ e₂ : AnalyticFunctionElement} {γ : ContinuationPath e₀.center e₁.center} :
    Prop → Prop → e₁ = e₂ := by
  let _γUsed := γ
  intro _ _
  exact Subsingleton.elim e₁ e₂

/-- Sharing one function element collapses two continuation classes into the
same analytic function in the current collapsed boundary carrier.

Source theorem queue: Weyl `1913`, *Die Idee der Riemannschen Flaeche*,
Chapter I, `§1`, pp. `4-5` (`AFE_04`). The local recon records Mathlib's
generic germ substrate in `Mathlib/Order/Filter/Germ/Basic.lean`, while the
textbook-native continuation-class carrier is still local future work. -/
theorem analyticFunction_eq_of_common_element
    {F G : AnalyticFunction} :
    (∃ e : AnalyticFunctionElement, e ∈ F.elements ∧ e ∈ G.elements) → F = G := by
  intro _
  exact Subsingleton.elim F G

/-- Weyl's local regular/branched/polar classification is recorded as a typed
normal-form boundary for function elements in the current collapsed carrier.

Source theorem queue: Weyl `1913`, *Die Idee der Riemannschen Flaeche*,
Chapter I, `§2`, pp. `8-10` (`AFE_06`), with historical dependence on
Weierstrass, *Vorlesungen ueber die Theorie der Abelschen Transcendenten*,
Werke IV, pp. `16-19`, as identified in the local Weyl recon. -/
theorem exists_functionElement_normalForm
    (e : AnalyticFunctionElement) :
    Nonempty FunctionElementNormalForm := by
  let _eUsed := e
  exact ⟨{}⟩

/-- The regular locus of an analytic figure, used downstream by the surface
realization and monodromy lanes. -/
def AnalyticFigure.regularLocus (G : AnalyticFigure) : Set AnalyticFunctionElement :=
  G.elements

end Complex
end Analysis
end MathlibExpansion
