import MathlibExpansion.Roots.Schlessinger.DeformationFunctor

/-!
# Tangent Space of a Deformation Functor

The tangent space of a deformation functor D is F(k[ε]), the value of D
at the dual numbers. Under H2 this carries a k-vector space structure;
under H3 it is finite-dimensional.

This file defines `tangentSpace` and records the finite-dimensionality
condition as a Prop (the proof that it is a k-module is deferred to a
future Mathlib contribution once the action map is canonically available).
-/

namespace MathlibExpansion.Roots.Schlessinger

universe u v

open IsLocalRing CategoryTheory

variable {k : Type u} [Field k]

/-- The **tangent space** of a deformation functor D is the set F(k[ε]).

Under Schlessinger's H2 axiom this set acquires a k-vector space
structure via the bijective comparison maps. Under H3 it is finite-
dimensional. The type here is the bare set; the vector-space structure
is a consequence of H2 and is stated as a Prop in H3. -/
abbrev tangentSpace (D : DeformationFunctor k) [IsArtinianRing (DualNumber k)] :
    Type v :=
  D.F.obj (dualNumberObj k)

/-- The tangent space is nonempty: it contains the image of the basepoint
via the unique map k → k[ε] in Art_k.

The basepoint lives in F(k), and the unique algebra map k → DualNumber k
(sending r to (r, 0) = TrivSqZeroExt.inl r) produces the canonical
distinguished element of the tangent space. -/
theorem tangentSpace_nonempty (D : DeformationFunctor k)
    [IsArtinianRing (DualNumber k)] :
    Nonempty (tangentSpace D) := by
  -- The map residueFieldObject k → dualNumberObj k is given by
  -- TrivSqZeroExt.inlAlgHom k k k : k →ₐ[k] DualNumber k.
  -- Applying D.F gives an element of the tangent space from the basepoint.
  exact ⟨D.F.map (TrivSqZeroExt.inlAlgHom k k k) D.base⟩

/-- **H3 as a type-level statement**: the tangent space is a finite
k-module. This is Schlessinger's third condition specialised to the
dual-numbers tangent object; callers must supply the `AddCommGroup` and
`Module k` structure on `D.F.obj (dualNumberObj k)` (usually provided
once H2 is in hand). -/
def H3Finite (D : DeformationFunctor k) [IsArtinianRing (DualNumber k)]
    [AddCommGroup (D.F.obj (dualNumberObj k))]
    [Module k (D.F.obj (dualNumberObj k))] : Prop :=
  Module.Finite k (tangentSpace D)

/-- `H3Finite` is definitionally equal to `H3` at the dual-numbers tangent
object. -/
theorem H3Finite_eq_H3 (D : DeformationFunctor k)
    [IsArtinianRing (DualNumber k)]
    [AddCommGroup (D.F.obj (dualNumberObj k))]
    [Module k (D.F.obj (dualNumberObj k))] :
    H3Finite D = H3 D (dualNumberObj k) := rfl

end MathlibExpansion.Roots.Schlessinger
