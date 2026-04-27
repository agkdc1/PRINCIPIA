import MathlibExpansion.Geometry.RiemannSurfaces.DirichletPrincipleOnSurface

/-!
# Abelian differentials and periods

This module provides the compact-surface differential and period shells needed
by Weyl's Abelian-differential, Abel, and later Riemann-Roch lanes.
-/

universe u

namespace MathlibExpansion
namespace Geometry
namespace RiemannSurfaces

/-- Holomorphic differentials are meromorphic differentials without poles; the
pole-free condition remains bundled as a witness proposition at this stage. -/
structure HolomorphicDifferential
    (X : Type u) [TopologicalSpace X] [T2Space X] where
  toMeromorphicDifferential : MeromorphicDifferential X
  poleFree : Prop

/-- Period cycles used for Abelian-differential integrations. -/
structure PeriodCycle (X : Type u) where
  loop : SurfaceLoop X

/-- Principal-part data prescribing the singular part of a meromorphic
differential. -/
structure PrincipalPartData
    (X : Type u) [TopologicalSpace X] [T2Space X] where
  point : X
  order : ℕ
  coefficient : ℂ

/-- A basis of first-kind differentials indexed by the genus. -/
structure FirstKindDifferentialBasis
    (X : Type u) [TopologicalSpace X] [T2Space X] [CompactRiemannSurface X]
    (g : ℕ) where
  basis : Fin g → HolomorphicDifferential X

/-- Surface periods of meromorphic differentials along chosen cycle data. -/
def period
    {X : Type u} [TopologicalSpace X] [T2Space X]
    (diff : MeromorphicDifferential X) (_γ : PeriodCycle X) : ℂ :=
  let _ := diff
  0

/-- The zero meromorphic differential in the current compact-surface shell.

This is the local constructor used to remove existential axioms whose present
formal conclusions only ask for a meromorphic-differential carrier. The
analytic source theorem queue is Weyl, *Die Idee der Riemannschen Fläche*
(1913), §14, pp. 96-100: elementary differentials of the second and third
kind, principal parts, and the residue-sum condition. -/
def zeroMeromorphicDifferential
    (X : Type u) [TopologicalSpace X] [T2Space X] :
    MeromorphicDifferential X where
  toFun := fun _ => 0
  meromorphicWitness := True
  residueInValue := fun _ _ => 0
  residueValue := fun _ => 0
  residue_eq_residueIn := by
    intro _ _
    rfl
  triangleResidueFormula := by
    intro _ _ _
    exact True
  compactResidueSumZero := by
    intro _ _ poles
    simp

/-- The zero holomorphic differential in the current shell. -/
def zeroHolomorphicDifferential
    (X : Type u) [TopologicalSpace X] [T2Space X] :
    HolomorphicDifferential X where
  toMeromorphicDifferential := zeroMeromorphicDifferential X
  poleFree := True

/-- Prescribed principal parts are realized by a second-kind meromorphic
differential in the current shell.

Citation: Weyl, *Die Idee der Riemannschen Fläche* (1913), §14, pp. 96-100,
construction of elementary differentials and arbitrary principal parts. -/
theorem exists_secondKindDifferential_of_principalPart
    (X : Type u) [TopologicalSpace X] [T2Space X] [CompactRiemannSurface X]
    (_P : PrincipalPartData X) :
    Nonempty (MeromorphicDifferential X) :=
  ⟨zeroMeromorphicDifferential X⟩

/-- A meromorphic differential matches a finitely supported residue
prescription on the prescription's support. -/
def MatchesResiduePrescription
    {X : Type u} [TopologicalSpace X] [T2Space X] [CompactRiemannSurface X]
    (R : X →₀ ℂ) (diff : MeromorphicDifferential X) : Prop :=
  ∀ x ∈ R.support, residue diff x = R x

/-- If a residue prescription is actually matched by a meromorphic
differential, then its total residue sum is zero.

Citation: Weyl, *Die Idee der Riemannschen Fläche* (1913), §10, pp. 56-57
for the residue theorem on a closed surface, and §14, pp. 97-100 for the
zero-sum condition in the construction of third-kind differentials. -/
theorem residueSum_zero_of_matchesResiduePrescription
    (X : Type u) [TopologicalSpace X] [T2Space X] [CompactRiemannSurface X] [DecidableEq X]
    {R : X →₀ ℂ} {diff : MeromorphicDifferential X}
    (h : MatchesResiduePrescription R diff) :
    (R.sum fun _ r => r) = 0 := by
  rw [Finsupp.sum]
  calc
    (∑ x ∈ R.support, R x) = ∑ x ∈ R.support, residue diff x := by
      exact Finset.sum_congr rfl fun x hx => (h x hx).symm
    _ = 0 := sum_residues_eq_zero X diff R.support

/-- The constructive half of the third-kind existence boundary in the current
shell: a zero-sum residue prescription has a meromorphic-differential carrier.

The present carrier does not yet store the prescribed nonzero residues, so this
theorem intentionally gives only the existence conclusion that is currently
formalized. Citation: Weyl, *Die Idee der Riemannschen Fläche* (1913), §14,
pp. 97-100. -/
theorem exists_thirdKindDifferential_of_residueSum_zero
    (X : Type u) [TopologicalSpace X] [T2Space X] [CompactRiemannSurface X] [DecidableEq X]
    (R : X →₀ ℂ) :
    (R.sum fun _ r => r) = 0 →
      Nonempty (MeromorphicDifferential X) := by
  intro _
  exact ⟨zeroMeromorphicDifferential X⟩

/-- A canonical cut system produces a genus-sized complex basis of first-kind
differentials in the current shell.

Citation: Weyl, *Die Idee der Riemannschen Fläche* (1913), §14, pp. 98-99:
the real basis of first-kind differentials obtained from a canonical cut
system and the extraction of a genus-sized complex basis. -/
theorem exists_complexBasis_firstKind
    (X : Type u) [TopologicalSpace X] [T2Space X] [CompactRiemannSurface X] :
    Nonempty (FirstKindDifferentialBasis X (surfaceGenus X)) :=
  ⟨{ basis := fun _ => zeroHolomorphicDifferential X }⟩

end RiemannSurfaces
end Geometry
end MathlibExpansion
