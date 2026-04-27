import MathlibExpansion.Roots.Diamond1996.CotangentComparison

/-!
# Diamond's algebraic criterion: injectivity from the kernel bridge

This file contains the honest commutative-algebra argument that replaces the old
top-level axiom. The only remaining unreduced content is the upstream bridge
`cotangentComparisonBridge`, which identifies the caller-supplied modules with
the actual kernel-side objects needed by the proof.
-/

namespace MathlibExpansion.Roots.Diamond1996

universe u

section

variable {Λ k O R T : Type u}
variable [CommRing Λ] [Field k] [CommRing O] [CommRing R] [CommRing T]
variable [Algebra Λ O] [Algebra O R] [Algebra O T]

theorem comparisonKernel_ne_top
    (D : AlgebraicCriterionData Λ k O R T)
    (cmp : CotangentComparisonData D) :
    D.comparisonKernel ≠ ⊤ := by
  letI := cmp.instNontrivialTarget
  intro htop
  have hmem : (1 : R) ∈ D.comparisonKernel := by
    simp [htop]
  have hzero : (1 : T) = 0 := by
    have hzero' := hmem
    simp [AlgebraicCriterionData.comparisonKernel] at hzero'
  exact (show (1 : T) ≠ 0 from one_ne_zero) hzero

/-- If the kernel cotangent is trivial, the kernel ideal is idempotent; in a
local ring it must therefore be `⊥` or `⊤`, and surjectivity into a nontrivial
target excludes `⊤`. -/
theorem comparisonKernel_eq_bot_of_cotangentSubsingleton
    (D : AlgebraicCriterionData Λ k O R T)
    (cmp : CotangentComparisonData D)
    (hsub : Subsingleton D.comparisonKernel.Cotangent) :
    D.comparisonKernel = ⊥ := by
  letI := cmp.instLocalRingSource
  letI := cmp.instNoetherianSource
  have hIdem : IsIdempotentElem D.comparisonKernel :=
    (Ideal.cotangent_subsingleton_iff (I := D.comparisonKernel)).1 hsub
  have hbotOrTop : D.comparisonKernel = ⊥ ∨ D.comparisonKernel = ⊤ := by
    simpa using
      (Ideal.isIdempotentElem_iff_eq_bot_or_top_of_isLocalRing (I := D.comparisonKernel)).1 hIdem
  exact hbotOrTop.resolve_right (comparisonKernel_ne_top D cmp)

/-- If the congruence module is trivial and the two Diamond-side ideals agree,
then the kernel cotangent is trivial as well. -/
theorem comparisonKernelCotangent_subsingleton_of_fitting_eq
    (D : AlgebraicCriterionData Λ k O R T)
    (cmp : CotangentComparisonData D)
    (h : D.api.fittingΦ = D.api.fittingψ) :
    Subsingleton D.comparisonKernel.Cotangent := by
  have hcongTop : D.api.fittingψ = ⊤ := by
    rw [D.api.fittingψ_eq_annihilator]
    exact
      (Module.annihilator_eq_top_iff (R := O) (M := D.congruenceModule)).2
        cmp.congruenceSubsingleton
  have hcotTop : D.api.fittingΦ = ⊤ := h.trans hcongTop
  have hcotSub : Subsingleton D.cotangentModule := by
    apply (Module.annihilator_eq_top_iff (R := O) (M := D.cotangentModule)).1
    rw [← D.api.fittingΦ_eq_annihilator]
    exact hcotTop
  letI : Subsingleton D.cotangentModule := hcotSub
  refine ⟨fun x y => ?_⟩
  have hxy : cmp.cotangentLinearEquiv.symm x = cmp.cotangentLinearEquiv.symm y :=
    Subsingleton.elim _ _
  simpa using congrArg cmp.cotangentLinearEquiv hxy

/-- The comparison map is injective once the Diamond-side ideals agree. -/
theorem comparisonInjective_of_fitting_eq
    (D : AlgebraicCriterionData Λ k O R T)
    (cmp : CotangentComparisonData D)
    (h : D.api.fittingΦ = D.api.fittingψ) :
    Function.Injective D.comparison.toAlgHom := by
  have hker :
      D.comparisonKernel = ⊥ :=
    comparisonKernel_eq_bot_of_cotangentSubsingleton D cmp
      (comparisonKernelCotangent_subsingleton_of_fitting_eq D cmp h)
  exact (RingHom.injective_iff_ker_eq_bot D.comparison.toAlgHom.toRingHom).2 hker

/-- Surjectivity is already packaged in `ComparisonMap`; combining it with the
injectivity theorem yields Diamond's current bijectivity surface. -/
theorem comparisonBijective_of_fitting_eq
    (D : AlgebraicCriterionData Λ k O R T)
    (cmp : CotangentComparisonData D)
    (h : D.api.fittingΦ = D.api.fittingψ) :
    Function.Bijective D.comparison.toAlgHom :=
  ⟨comparisonInjective_of_fitting_eq D cmp h, D.comparison.surjective⟩

end

end MathlibExpansion.Roots.Diamond1996
