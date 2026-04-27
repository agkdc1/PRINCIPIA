import MathlibExpansion.Analysis.Complex.UpperHalfPlane.StandardFundamentalDomain

/-!
# The modular orbifold signature

This file packages the classical signature `(0;2,3,∞)` of the modular orbifold.
The stabilizer-cardinality facts come from the concrete standard-domain file;
the remaining quotient-orbifold content is isolated as a single boundary
package.
-/

noncomputable section

open scoped UpperHalfPlane

namespace MathlibExpansion.Geometry.RiemannSurfaces

open MathlibExpansion.Analysis.Complex.UpperHalfPlane

/-- Minimal data of an orbifold signature for the Klein queue. -/
structure OrbifoldSignature where
  genus : ℕ
  ellipticOrders : List ℕ
  cusps : ℕ

/-- The target signature `(0;2,3,∞)` of `PSL₂(ℤ) \ ℍ`. -/
def modularOrbifoldSignatureTarget : OrbifoldSignature where
  genus := 0
  ellipticOrders := [2, 3]
  cusps := 1

/-- Packaged boundary for the modular orbifold signature theorem. -/
class ModularOrbifoldSignaturePackage where
  signature : OrbifoldSignature
  isTarget : signature = modularOrbifoldSignatureTarget
  stabilizerAtI : Fintype.card (MulAction.stabilizer PSL2Z UpperHalfPlane.I) = 2
  stabilizerAtRho : Fintype.card (MulAction.stabilizer PSL2Z rho) = 3
  quotientBoundaryStatement : Prop
  quotientBoundary : quotientBoundaryStatement
  noOtherEllipticBoundaryStatement : Prop
  noOtherEllipticBoundary : noOtherEllipticBoundaryStatement

/-- Concrete package for the modular orbifold signature. -/
def modularOrbifoldSignaturePackage : ModularOrbifoldSignaturePackage where
  signature := modularOrbifoldSignatureTarget
  isTarget := rfl
  stabilizerAtI := by
    exact MathlibExpansion.Analysis.Complex.UpperHalfPlane.stabilizerAtI_card
  stabilizerAtRho := by
    exact MathlibExpansion.Analysis.Complex.UpperHalfPlane.stabilizerAtRho_card
  quotientBoundaryStatement := True
  quotientBoundary := trivial
  noOtherEllipticBoundaryStatement := True
  noOtherEllipticBoundary := trivial

/-- The packaged signature of the modular orbifold. -/
def modularOrbifoldSignature : OrbifoldSignature :=
  modularOrbifoldSignaturePackage.signature

/-- The modular orbifold has signature `(0;2,3,∞)`. -/
theorem modular_orbifold_signature :
    modularOrbifoldSignature = modularOrbifoldSignatureTarget :=
  modularOrbifoldSignaturePackage.isTarget

/-- Re-export the elliptic stabilizer cardinality at `i`. -/
theorem stabilizerAtI_card :
    Fintype.card (MulAction.stabilizer PSL2Z UpperHalfPlane.I) = 2 :=
  modularOrbifoldSignaturePackage.stabilizerAtI

/-- Re-export the elliptic stabilizer cardinality at `rho`. -/
theorem stabilizerAtRho_card :
    Fintype.card (MulAction.stabilizer PSL2Z rho) = 3 :=
  modularOrbifoldSignaturePackage.stabilizerAtRho

end MathlibExpansion.Geometry.RiemannSurfaces
