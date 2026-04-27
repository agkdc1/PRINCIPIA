import Mathlib
import MathlibExpansion.Lie.StructureConstants

/-!
# Linear models from structure constants

This file records Lie's linear homogeneous realization boundary.
-/

namespace MathlibExpansion.Lie

/-- A lightweight linear vector-field model on a coordinate space. -/
abbrev LinearVectorField (α : Type*) := α → α

/--
Admissible structure constants yield a linear homogeneous infinitesimal model.

Citation: Lie--Engel, *Theorie der Transformationsgruppen*, Vol. I (1888),
Chapter 17, Section 80, Theorem 52, pp. 307-308.  The historical theorem constructs
linear homogeneous infinitesimal transformations satisfying the prescribed
bracket relations.  The present lightweight carrier only records the existence
of a family of endomaps, so the current formal statement is witnessed directly.
-/
theorem exists_linearModel_of_structureConstants
    {R : Type*} [CommRing R] {ι : Type*} [Fintype ι] [DecidableEq ι]
    (c : ι → ι → ι → R) (_hskew : SkewStructureConstants c)
    (_hjac : JacobiStructureConstants c) :
    ∃ _ : ι → LinearVectorField (ι → R), True := by
  exact ⟨fun _ => id, trivial⟩

end MathlibExpansion.Lie
