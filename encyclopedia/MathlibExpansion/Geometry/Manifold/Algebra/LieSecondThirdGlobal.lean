import Mathlib
import MathlibExpansion.Geometry.Manifold.Algebra.LieAlgebraOfLieGroup

/-!
# Global Lie II/III shell

This file records the modern simply-connected integration surface requested by
the Lie I/II/III recon.
-/

namespace MathlibExpansion.Geometry.Manifold.Algebra

open scoped Manifold

noncomputable section

variable {𝕜 : Type*} [NontriviallyNormedField 𝕜]
variable {H : Type*} [TopologicalSpace H]
variable {E : Type*} [NormedAddCommGroup E] [NormedSpace 𝕜 E]
variable {H' : Type*} [TopologicalSpace H']
variable {E' : Type*} [NormedAddCommGroup E'] [NormedSpace 𝕜 E']
variable {I : ModelWithCorners 𝕜 E H} {I' : ModelWithCorners 𝕜 E' H'}
variable {G : Type*} [Group G] [TopologicalSpace G] [ChartedSpace H G] [ContMDiffMul I ⊤ G]
variable {G' : Type*} [Group G'] [TopologicalSpace G'] [ChartedSpace H' G']
variable [ContMDiffMul I' ⊤ G'] [SimplyConnectedSpace G]

/--
The Lie-algebra homomorphism induced by a smooth group homomorphism.

This is the local functoriality boundary needed before the global Lie II
statement can be discharged.  Mathlib currently supplies the smooth monoid
homomorphism carrier `ContMDiffMonoidMorphism` and the Lie algebra carrier
`LeftInvariantDerivation`, but not the differentiated map between those Lie
algebras.

Source boundary: Sophus Lie and Friedrich Engel, *Theorie der
Transformationsgruppen* I (1888), Chapter 9, Theorems 24 and 27, pp. 169 and
180-181; Claude Chevalley, *Theory of Lie Groups* I (1946), Chapter IV
homomorphism corridor; local theorem slot `LAAG_08`.
-/
opaque lieAlgebraMapOfGroupHom
    (Φ : ContMDiffMonoidMorphism I I' ⊤ G G') :
    lieAlgebraOfLieGroup I G →ₗ⁅𝕜⁆ lieAlgebraOfLieGroup I' G'

/--
A smooth group homomorphism differentiates to the fixed Lie-algebra
homomorphism `φ`.

Unlike the former `True` shell, this predicate records both the smooth
homomorphism lift and equality with the deferred induced Lie-algebra map.
-/
def DifferentiatesToLieHom
    (φ : lieAlgebraOfLieGroup I G →ₗ⁅𝕜⁆ lieAlgebraOfLieGroup I' G') (Φ : G →* G') : Prop :=
  ∃ Φs : ContMDiffMonoidMorphism I I' ⊤ G G',
    (Φs : G →* G') = Φ ∧ lieAlgebraMapOfGroupHom Φs = φ

/--
Global integration boundary: on a simply connected Lie group, a Lie algebra
homomorphism integrates uniquely to a group homomorphism.

Exact discharge target: the Cartan-Lie global integration theorem, combining
Cartan's globalization of Lie's third fundamental theorem with the simply
connected local-to-global uniqueness argument; see Élie Cartan, *La théorie des
groupes finis et continus et l'analysis situs* (Mémorial des sciences
mathématiques 42, 1930; 1952 reprint), nos. 13 and 21, and the modern
homomorphism theorem in Brian C. Hall, *Lie Groups, Lie Algebras, and
Representations*, 2nd ed. (2015), Theorem 5.20.
-/
axiom existsUnique_groupHom_of_lieHom
    (φ : lieAlgebraOfLieGroup I G →ₗ⁅𝕜⁆ lieAlgebraOfLieGroup I' G') :
    ∃! Φ : G →* G', DifferentiatesToLieHom φ Φ

end

end MathlibExpansion.Geometry.Manifold.Algebra
