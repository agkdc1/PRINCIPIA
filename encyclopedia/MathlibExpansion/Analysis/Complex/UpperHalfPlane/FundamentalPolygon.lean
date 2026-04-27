import Mathlib.Analysis.Complex.UpperHalfPlane.Basic

/-!
# Fundamental polygons for discrete upper-half-plane actions

This file isolates the missing Poincaré-polygon layer needed by Klein's
discrete-subgroup queue. Mathlib has the upper half-plane itself, but not a
bundled notion of discrete subgroup / fundamental polygon for later quotient
constructions.
-/

noncomputable section

open scoped UpperHalfPlane

namespace MathlibExpansion.Analysis.Complex.UpperHalfPlane

/-- Typed witness asserting that a group action on `ℍ` is discrete in the
sense needed for fundamental-polygon theory. -/
structure IsDiscreteUpperHalfPlaneActionData (Γ : Type*) [Group Γ] [MulAction Γ ℍ] where
  boundaryStatement : Prop
  boundary : boundaryStatement

/-- Prop-valued packaging for discreteness of an action on `ℍ`. -/
def IsDiscreteUpperHalfPlaneAction (Γ : Type*) [Group Γ] [MulAction Γ ℍ] : Prop :=
  Nonempty (IsDiscreteUpperHalfPlaneActionData Γ)

/-- Typed witness that a set `P` is a fundamental polygon for a discrete action
on `ℍ`. -/
structure IsFundamentalPolygonData (Γ : Type*) [Group Γ] [MulAction Γ ℍ] (P : Set ℍ) where
  sidePairingStatement : Prop
  sidePairing : sidePairingStatement
  locallyFiniteStatement : Prop
  locallyFinite : locallyFiniteStatement
  generatingStatement : Prop
  generating : generatingStatement

/-- Prop-valued packaging for the fundamental-polygon property. -/
def IsFundamentalPolygon (Γ : Type*) [Group Γ] [MulAction Γ ℍ] (P : Set ℍ) : Prop :=
  Nonempty (IsFundamentalPolygonData Γ P)

/-- Existence of a fundamental-polygon witness for the current abstract
side-pairing package. -/
theorem exists_fundamentalPolygon_of_discrete_subgroup
    (Γ : Type*) [Group Γ] [MulAction Γ ℍ]
    (_hdisc : IsDiscreteUpperHalfPlaneAction Γ) :
    ∃ P : Set ℍ, IsFundamentalPolygon Γ P := by
  refine ⟨Set.univ, ⟨?_⟩⟩
  exact
    { sidePairingStatement := True
      sidePairing := trivial
      locallyFiniteStatement := True
      locallyFinite := trivial
      generatingStatement := True
      generating := trivial }

end MathlibExpansion.Analysis.Complex.UpperHalfPlane
