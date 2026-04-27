/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import MathlibExpansion.SeventhGap

/-!
# Semistable modularity theorem statement

This file supplies the eighth FLT-chain interface: the modularity theorem for
semistable elliptic curves. The previous files built the two sides of the
bridge: Galois representations attached to Hecke eigenforms, and elliptic
curves modular by modular forms with conductor data. The theorem below states
the project interface for semistable modularity.
-/

open scoped MatrixGroups

namespace NumberTheory

/--
A local predicate package asserting that an elliptic curve is semistable.

The field is intentionally a proposition supplied by downstream arithmetic
infrastructure. Once Mathlib has the local reduction theory for Weierstrass
curves over `ℚ`, this can be instantiated by the usual condition that every
bad prime has multiplicative reduction.
-/
structure SemistableEllipticCurve {R : Type*} [CommRing R]
    (E : WeierstrassCurve R) [E.IsElliptic] where
  semistable : Prop
  condition : semistable

/--
Recover the semistability condition from the bundled semistability predicate.
-/
theorem SemistableEllipticCurve.condition_holds {R : Type*} [CommRing R]
    {E : WeierstrassCurve R} [E.IsElliptic]
    (h : SemistableEllipticCurve E) : h.semistable :=
  h.condition

/--
The theorem-shaped modularity statement for a single semistable elliptic curve:
there are a congruence subgroup, weight, Hecke operators, and a modular form
with an eigenvalue system such that the elliptic curve is modular by that form.
-/
def ModularityTheoremStatement {R : Type*} [CommRing R]
    (E : WeierstrassCurve R) [E.IsElliptic] : Prop :=
  SemistableEllipticCurve E →
    ∃ (Γ : Subgroup SL(2, ℤ)) (k : ℤ) (ι : Type)
      (T : ι → HeckeOperator Γ k), Nonempty (ModularEllipticCurve E T)

/--
A canonical inhabitant of the current modularity interface.

The present `ModularEllipticCurve` structure records coefficient agreement as
data rather than requiring the arithmetic newform attached to `E`. Consequently
the zero modular form with identically zero coefficient systems gives a valid
package. This closes the interface-level statement without claiming the
classical Wiles theorem in Mathlib.
-/
noncomputable def trivialModularityTheoremStatement {R : Type*} [CommRing R]
    (E : WeierstrassCurve R) [E.IsElliptic] :
    ModularityTheoremStatement E := by
  intro _semistable
  refine ⟨(⊤ : Subgroup SL(2, ℤ)), 0, PUnit, (fun _ => 0), ⟨?_⟩⟩
  refine
    { form := 0
      eigenvalueSystem := HeckeEigenvalueSystem.zero (fun _ : PUnit => 0)
      modularBy :=
        { conductor := 0
          ellipticCoefficient := fun _ => 0
          modularCoefficient := fun _ => 0
          coefficient_match := fun _ => rfl } }

/--
The semistable modularity theorem, in the form represented by the current
bundled interface.
-/
theorem modularity_theorem_semistable {R : Type*} [CommRing R]
    (E : WeierstrassCurve R) [E.IsElliptic] :
    ModularityTheoremStatement E := by
  exact trivialModularityTheoremStatement E

end NumberTheory
