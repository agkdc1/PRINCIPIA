import MathlibExpansion.Roots.ContinuousGaloisCohomology

/-!
# Continuous first cohomology, special low-degree surface

This module isolates the Selmer-facing `H¹` boundary layer from the larger
continuous Galois cohomology scaffold.  It defines continuous `1`-cocycles,
continuous `1`-coboundaries, and the quotient of cocycles by the relation of
differing by a coboundary.
-/

namespace MathlibExpansion
namespace Roots
namespace ContinuousH1Special

open ContinuousGaloisCohomology

/-- Continuous inhomogeneous `1`-cochains. -/
abbrev ContinuousOneCochain (G M : Type*) [TopologicalSpace G] [TopologicalSpace M] :=
  ContinuousGaloisCohomology.ContinuousCochain G M 1

variable {G M : Type*} [TopologicalSpace G] [TopologicalSpace M]

/-- The inhomogeneous continuous `1`-cocycle identity. -/
def IsContinuousOneCocycle [Mul G] [SMul G M] [Add M]
    (c : ContinuousOneCochain G M) : Prop :=
  ∀ g h : G, c (fun _ : Fin 1 => g * h) =
    g • c (fun _ : Fin 1 => h) + c (fun _ : Fin 1 => g)

/-- A continuous `1`-cochain is a coboundary if it is the degree-zero
inhomogeneous coboundary of an element of the coefficient module. -/
def IsContinuousOneCoboundary [SMul G M] [Sub M]
    (c : ContinuousOneCochain G M) : Prop :=
  ∃ m : M, ∀ g : G, c (fun _ : Fin 1 => g) = g • m - m

/-- Bundled continuous `1`-cocycles. -/
abbrev ContinuousCocycle [Mul G] [SMul G M] [Add M] :=
  { c : ContinuousOneCochain G M // IsContinuousOneCocycle c }

/-- Bundled continuous `1`-coboundaries. -/
abbrev ContinuousCoboundary [SMul G M] [Sub M] :=
  { c : ContinuousOneCochain G M // IsContinuousOneCoboundary c }

/-- The relation identifying continuous `1`-cocycles that differ by a continuous
`1`-coboundary. -/
def continuousOneCoboundaryRel [Mul G] [SMul G M] [Add M] [Sub M] [ContinuousAdd M]
    (c d : ContinuousCocycle (G := G) (M := M)) : Prop :=
  ∃ b : ContinuousOneCochain G M, IsContinuousOneCoboundary b ∧
    (d : ContinuousOneCochain G M) = (c : ContinuousOneCochain G M) + b

/-- The special continuous first cohomology type: continuous `1`-cocycles modulo
continuous `1`-coboundaries. -/
abbrev ContinuousH1 [Mul G] [SMul G M] [Add M] [Sub M] [ContinuousAdd M] :=
  Quot (continuousOneCoboundaryRel (G := G) (M := M))

#check ContinuousOneCochain
#check IsContinuousOneCocycle
#check IsContinuousOneCoboundary
#check ContinuousCocycle
#check ContinuousCoboundary
#check continuousOneCoboundaryRel
#check ContinuousH1

end ContinuousH1Special
end Roots
end MathlibExpansion
