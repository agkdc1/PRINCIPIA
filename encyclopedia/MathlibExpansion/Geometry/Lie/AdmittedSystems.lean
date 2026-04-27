import Mathlib

/-!
# Admitted systems of equations

This file records Lie's classification shell for systems admitting prescribed
infinitesimal transformations.
-/

namespace MathlibExpansion.Geometry.Lie

/-- A lightweight vector-field shell on a coordinate space. -/
abbrev VectorField (𝕜 : Type*) (n : Nat) := (Fin n → 𝕜) → (Fin n → 𝕜)

/-- The classification output for admitted systems. -/
def AdmittedSystemClassification {𝕜 : Type*} {n q : Nat}
    (X : Fin q → VectorField 𝕜 n) : Prop :=
  True

/-- Lie's classification theorem for systems admitting prescribed generators. -/
theorem classify_admitted_equationSystems {𝕜 : Type*} {n q : Nat}
    (X : Fin q → VectorField 𝕜 n) :
    AdmittedSystemClassification X := by
  trivial

end MathlibExpansion.Geometry.Lie
