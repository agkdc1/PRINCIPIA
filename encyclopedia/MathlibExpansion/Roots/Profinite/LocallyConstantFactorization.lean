import Mathlib.GroupTheory.QuotientGroup.Basic
import Mathlib.Topology.Algebra.ClopenNhdofOne
import MathlibExpansion.Roots.ContinuousGaloisCohomology

/-!
# Locally Constant Factorization Through Open Normal Quotients

For a profinite group `G` and a discrete target `α`, every locally constant map
`f : G → α` is uniformly locally constant: there exists an open normal subgroup
`N` such that `f (g * h) = f g` for all `h ∈ N`. This lets `f` descend to the
finite quotient `G ⧸ N`.

The main bundled output is `LocallyConstant.OpenNormalFactorization`. We then
specialize it in two directions needed by the current FLT chain:

* locally constant `1`-cocycles in
  `ContinuousGaloisCohomology.locConstOneCocycleSubgroup`;
* continuous homomorphisms into discrete groups.

The cocycle specialization proves the previously exposed wall
`LocallyConstantH1ProfiniteFactorizationWall`.
-/

open scoped Pointwise

namespace MathlibExpansion
namespace Roots
namespace Profinite

open ContinuousGaloisCohomology

universe u v

section LocallyConstant

variable {G : Type u} [Group G] [TopologicalSpace G]
variable [ContinuousMul G] [ContinuousInv G] [CompactSpace G] [TotallyDisconnectedSpace G]
variable {α : Type v} [TopologicalSpace α] [DiscreteTopology α]

namespace LocallyConstant

/-- A locally constant map on a profinite group factors through an open normal
quotient. The descended map is recorded as a plain function on the quotient. -/
structure OpenNormalFactorization (f : LocallyConstant G α) where
  N : OpenNormalSubgroup G
  desc : G ⧸ N.toSubgroup → α
  fac : ∀ g : G, f g = desc (QuotientGroup.mk g)

/-- Factor a locally constant map through an open normal quotient by applying
the tube lemma to the relation `f (g * h) = f g` near `G × {1}`. -/
noncomputable def openNormalFactorization
    (f : LocallyConstant G α) : OpenNormalFactorization f := by
  classical
  letI : IsTopologicalGroup G := {}
  let W : Set (G × G) := {p | f (p.1 * p.2) = f p.1}
  have hWOpen : IsOpen W := by
    let phi : G × G → α × α := fun p => (f (p.1 * p.2), f p.1)
    have hphi : Continuous phi := by
      refine (f.continuous.comp (continuous_fst.mul continuous_snd)).prod_mk
        (f.continuous.comp continuous_fst)
    have hdiag : IsOpen (Set.diagonal α) := isOpen_discrete _
    simpa [W, phi, Set.diagonal] using hdiag.preimage hphi
  have hWContains : Set.univ ×ˢ ({1} : Set G) ⊆ W := by
    rintro ⟨g, h⟩ ⟨-, hh⟩
    simp only [Set.mem_singleton_iff] at hh
    subst hh
    simp [W]
  have hTube := generalized_tube_lemma isCompact_univ isCompact_singleton hWOpen hWContains
  let U : Set G := Classical.choose hTube
  have hTubeU : ∃ V : Set G, IsOpen U ∧ IsOpen V ∧ Set.univ ⊆ U ∧ ({1} : Set G) ⊆ V ∧
      U ×ˢ V ⊆ W := Classical.choose_spec hTube
  let V : Set G := Classical.choose hTubeU
  have hTubeV : IsOpen U ∧ IsOpen V ∧ Set.univ ⊆ U ∧ ({1} : Set G) ⊆ V ∧ U ×ˢ V ⊆ W :=
    Classical.choose_spec hTubeU
  rcases hTubeV with ⟨hUOpen, hVOpen, hU, hV, hUV⟩
  have hVone : (1 : G) ∈ V := hV (by simp)
  have hOpenNormal :
      ∃ N : OpenNormalSubgroup G, (N : Set G) ⊆ V :=
    ProfiniteGrp.exist_openNormalSubgroup_sub_open_nhd_of_one hVOpen hVone
  let N : OpenNormalSubgroup G := Classical.choose hOpenNormal
  have hNV : (N : Set G) ⊆ V := Classical.choose_spec hOpenNormal
  have hrightInv : ∀ g h : G, h ∈ (N : Set G) → f (g * h) = f g := by
    intro g h hh
    have hmem : (g, h) ∈ U ×ˢ V := ⟨hU (by simp), hNV hh⟩
    exact hUV hmem
  refine
    { N := N
      desc := Quotient.lift (fun g : G => f g) ?_
      fac := ?_ }
  · intro a b hab
    change QuotientGroup.leftRel N.toSubgroup a b at hab
    rw [QuotientGroup.leftRel_apply] at hab
    simpa [mul_assoc] using (hrightInv a (a⁻¹ * b) hab).symm
  · intro g
    rfl

end LocallyConstant

/-- A locally constant `1`-cocycle factors through an open normal quotient. -/
theorem locConstOneCocycleSubgroup_factorsThrough_openNormalQuotient
    {M : Type v} [AddCommGroup M] [TopologicalSpace M] [DiscreteTopology M]
    [DistribMulAction G M] [ContinuousSMul G M]
    (f : locConstOneCocycleSubgroup G M) :
    ∃ N : OpenNormalSubgroup G, ∃ fbar : G ⧸ N.toSubgroup → M,
      ∀ g : G, f.1 g = fbar (QuotientGroup.mk g) := by
  let hf := LocallyConstant.openNormalFactorization (G := G) (α := M) f.1
  refine ⟨hf.N, hf.desc, ?_⟩
  simpa using hf.fac

/-- The previously exposed profinite-factorization wall for locally constant
`H¹` is theorem-level: every locally constant `1`-cocycle descends to a finite
quotient `G ⧸ N` for an open normal subgroup `N`. -/
theorem locallyConstantH1ProfiniteFactorization
    {M : Type v} [AddCommGroup M] [TopologicalSpace M] [DiscreteTopology M]
    [DistribMulAction G M] [ContinuousSMul G M] :
    ContinuousGaloisCohomology.LocallyConstantH1ProfiniteFactorizationWall
      (G := G) (M := M) := by
  intro f
  obtain ⟨N, fbar, hfbar⟩ :=
    locConstOneCocycleSubgroup_factorsThrough_openNormalQuotient (G := G) (M := M) f
  exact ⟨N.toSubgroup, inferInstance, N.isOpen', fbar, hfbar⟩

end LocallyConstant

section ContinuousHom

variable {G : Type u} [Group G] [TopologicalSpace G]
variable {A : Type v} [Group A] [TopologicalSpace A] [DiscreteTopology A]

/-- A continuous homomorphism into a discrete group descends through the
quotient by its open kernel. -/
theorem continuousMonoidHom_factorsThroughOpenNormalQuotient
    (ρ : G →* A) (hρ : Continuous ρ) :
    ∃ N : OpenNormalSubgroup G, ∃ ρDesc : G ⧸ N.toSubgroup →* A,
      ∀ g : G, ρDesc (QuotientGroup.mk g) = ρ g := by
  let N : OpenNormalSubgroup G :=
    { toOpenSubgroup := ⟨ρ.ker, by
        simpa [MonoidHom.mem_ker] using (isOpen_discrete ({1} : Set A)).preimage hρ⟩ }
  refine ⟨N, QuotientGroup.lift N.toSubgroup ρ (by intro x hx; exact hx), ?_⟩
  intro g
  simp [N]

end ContinuousHom

end Profinite
end Roots
end MathlibExpansion
