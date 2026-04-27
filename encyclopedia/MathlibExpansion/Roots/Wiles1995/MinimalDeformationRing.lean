import MathlibExpansion.Roots.Schlessinger.ProRepOver

namespace MathlibExpansion.Roots.Wiles1995

universe u v

open MathlibExpansion.Roots.Schlessinger

variable {Λ k : Type u} [CommRing Λ] [Field k] [Algebra Λ k]

abbrev MinimalRamificationCondition (D : DeformationFunctorOver Λ k) :=
  ∀ ⦃A : ArtinLocalAlgOver Λ k⦄, D.F.obj A → Prop

structure MinimalDeformationProblem (Λ k : Type u)
    [CommRing Λ] [Field k] [Algebra Λ k] where
  ambient : DeformationFunctorOver Λ k
  minimal : MinimalRamificationCondition ambient
  functor : DeformationFunctorOver Λ k

def MinimalDeformationRing
    (P : MinimalDeformationProblem Λ k) : Prop :=
  ∃ R : CompleteLocalNoetherianAlgOver Λ k, ProRepresentedByOver P.functor R

theorem minimalDeformationRing_of_isProRepresentable
    (P : MinimalDeformationProblem Λ k)
    (h : IsProRepresentableOver P.functor) :
    MinimalDeformationRing P :=
  h

end MathlibExpansion.Roots.Wiles1995
