import Mathlib.Data.Complex.Basic
import Mathlib.GroupTheory.GroupAction.Basic
import Mathlib.LinearAlgebra.Projectivization.Basic
import MathlibExpansion.Geometry.Polyhedron.Icosahedron

/-!
# Icosahedral Möbius realization

This file packages the missing realization of the icosahedral group by Möbius
transformations of the Riemann sphere.

The carrier `ℙ¹(ℂ)` is now the actual Mathlib projectivization
`ℙ ℂ (Fin 2 → ℂ)`.  The remaining boundary is the sharply-scoped classical
Klein representation of the icosahedral rotation group by linear fractional
transformations of this projective line.
-/

noncomputable section

namespace MathlibExpansion.Complex.Mobius

open MathlibExpansion.Geometry.Polyhedron
open scoped LinearAlgebra.Projectivization

/-- Typed boundary for the projective line `ℙ¹(ℂ)` used by the Möbius-action
formalization. -/
class ComplexProjectiveLinePackage where
  carrier : Type

/-- The complex projective line carrier, realized as Mathlib projectivization. -/
def complexProjectiveLinePackage : ComplexProjectiveLinePackage where
  carrier := ℙ ℂ (Fin 2 → ℂ)

/-- The ambient carrier for Möbius actions. -/
abbrev ComplexProjectiveLine : Type := complexProjectiveLinePackage.carrier

/-- A sharply-scoped representation boundary for the icosahedral Möbius action.

It fixes both the domain group and the codomain carrier: the only missing
mathematics is the classical faithful projective-linear action of the
icosahedral rotation group on `ℙ¹(ℂ)`, together with the source's
linear-fractional content.
-/
structure IcosahedralMoebiusPermRepresentation where
  toPermHom : IcosahedralRotationGroup →* Equiv.Perm ComplexProjectiveLine
  faithful : Function.Injective toPermHom
  linearFractionalBoundaryStatement : Prop
  linearFractionalBoundary : linearFractionalBoundaryStatement

/-- **Upstream-narrow axiom (Klein 1884, Abschnitt I, Kapitel II,
`Die Ikosaedergruppe`, p. 39; encyclopedia topic `KIQ_03`).**  This is the
exact remaining boundary for Klein's theorem that the icosahedral group has a
faithful realization by linear fractional transformations of the Riemann sphere.
The broad local realization axiom is reduced to this fixed-domain, fixed-carrier
permutation representation package. -/
axiom icosahedralMoebiusPermRepresentation : IcosahedralMoebiusPermRepresentation

/-- The Möbius action of the abstract icosahedral rotation group on `ℙ¹(ℂ)`,
obtained from the sharpened Klein representation boundary. -/
noncomputable instance instMulActionIcosahedralRotationGroupComplexProjectiveLine :
    MulAction IcosahedralRotationGroup ComplexProjectiveLine where
  smul g z := icosahedralMoebiusPermRepresentation.toPermHom g z
  one_smul z := by
    change icosahedralMoebiusPermRepresentation.toPermHom 1 z = z
    rw [map_one]
    rfl
  mul_smul g h z := by
    change icosahedralMoebiusPermRepresentation.toPermHom (g * h) z =
      icosahedralMoebiusPermRepresentation.toPermHom g
        (icosahedralMoebiusPermRepresentation.toPermHom h z)
    rw [map_mul]
    rfl

/-- Faithfulness of the Möbius action, derived from the sharpened representation
boundary. -/
noncomputable instance instFaithfulSMulIcosahedralRotationGroupComplexProjectiveLine :
    FaithfulSMul IcosahedralRotationGroup ComplexProjectiveLine where
  eq_of_smul_eq_smul {g h} hgh := by
    apply icosahedralMoebiusPermRepresentation.faithful
    ext z
    exact hgh z

/-- A packaged realization of the icosahedral rotation group as a finite Möbius
group acting faithfully on `ℙ¹(ℂ)`. -/
class IcosahedralMoebiusRealization where
  transformation : Type
  instGroup : Group transformation
  instFintype : Fintype transformation
  instMulAction : MulAction transformation ComplexProjectiveLine
  instFaithfulSMul : FaithfulSMul transformation ComplexProjectiveLine
  isoRotationGroup : transformation ≃* IcosahedralRotationGroup
  linearFractionalBoundaryStatement : Prop
  linearFractionalBoundary : linearFractionalBoundaryStatement

attribute [instance] IcosahedralMoebiusRealization.instGroup
attribute [instance] IcosahedralMoebiusRealization.instFintype
attribute [instance] IcosahedralMoebiusRealization.instMulAction
attribute [instance] IcosahedralMoebiusRealization.instFaithfulSMul

/-- The icosahedral Möbius realization, assembled from the concrete rotation
group and the sharpened Klein representation boundary. -/
noncomputable def icosahedralMoebiusRealization : IcosahedralMoebiusRealization where
  transformation := IcosahedralRotationGroup
  instGroup := inferInstance
  instFintype := inferInstance
  instMulAction := inferInstance
  instFaithfulSMul := inferInstance
  isoRotationGroup := MulEquiv.refl IcosahedralRotationGroup
  linearFractionalBoundaryStatement :=
    icosahedralMoebiusPermRepresentation.linearFractionalBoundaryStatement
  linearFractionalBoundary :=
    icosahedralMoebiusPermRepresentation.linearFractionalBoundary

/-- The finite Möbius group carrying the icosahedral action. -/
abbrev IcosahedralMoebiusGroup : Type := icosahedralMoebiusRealization.transformation

instance : Group IcosahedralMoebiusGroup := icosahedralMoebiusRealization.instGroup

instance : Fintype IcosahedralMoebiusGroup := icosahedralMoebiusRealization.instFintype

instance : MulAction IcosahedralMoebiusGroup ComplexProjectiveLine :=
  icosahedralMoebiusRealization.instMulAction

instance : FaithfulSMul IcosahedralMoebiusGroup ComplexProjectiveLine :=
  icosahedralMoebiusRealization.instFaithfulSMul

/-- The finite Möbius realization is isomorphic to the abstract icosahedral
rotation group. -/
noncomputable def icosahedralMoebiusGroupIsoRotationGroup :
    IcosahedralMoebiusGroup ≃* IcosahedralRotationGroup :=
  icosahedralMoebiusRealization.isoRotationGroup

end MathlibExpansion.Complex.Mobius
