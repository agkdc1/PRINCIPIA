import Mathlib.Algebra.Module.PID
import Mathlib.RingTheory.Finiteness.Basic
import Mathlib.RingTheory.Finiteness.Prod
import Mathlib.RingTheory.PowerSeries.Basic

/-!
# Iwasawa Basic: Lambda algebra and elementary quotients

Foundational types for the Iwasawa theory of finitely generated Λ-modules.
`Lambda R = PowerSeries R` models the one-variable Iwasawa algebra.

This file is dependency-free within the Iwasawa directory and can be
imported by all other `Iwasawa/*.lean` files.
-/

namespace MathlibExpansion
namespace Roots
namespace Iwasawa

universe u v

open scoped DirectSum

/-- The one-variable Iwasawa algebra over coefficient ring `R`.

Classical instantiation: `R = ℤ_p`, giving `Λ = ℤ_p[[T]]`. -/
abbrev Lambda (R : Type u) [CommSemiring R] : Type u :=
  PowerSeries R

/-- A finitely generated module over the Iwasawa algebra `Λ = PowerSeries R`. -/
structure FinitelyGeneratedLambdaModule (R : Type u) [CommRing R] where
  carrier : Type v
  [addCommGroup : AddCommGroup carrier]
  [module : Module (Lambda R) carrier]
  finite : Module.Finite (Lambda R) carrier

attribute [instance] FinitelyGeneratedLambdaModule.addCommGroup
attribute [instance] FinitelyGeneratedLambdaModule.module

namespace FinitelyGeneratedLambdaModule

instance (R : Type u) [CommRing R] (M : FinitelyGeneratedLambdaModule.{u, v} R) :
    Module.Finite (Lambda R) M.carrier :=
  M.finite

end FinitelyGeneratedLambdaModule

/-- The cyclic elementary quotient `Λ/(a)`. -/
abbrev cyclicQuotient (R : Type u) [CommRing R] (a : Lambda R) : Type u :=
  Lambda R ⧸ Ideal.span ({a} : Set (Lambda R))

/-- The `Λ/(p^n)` elementary summand attached to a prime element `p : Λ`. -/
abbrev pPowerElementary (R : Type u) [CommRing R] (p : Lambda R) (n : ℕ) : Type u :=
  cyclicQuotient R (p ^ n)

/-! ## Basic torsion normalization -/

theorem cyclicQuotient_one_subsingleton (R : Type u) [CommRing R] :
    Subsingleton (cyclicQuotient R 1) := by
  change Subsingleton (Lambda R ⧸ Ideal.span ({(1 : Lambda R)} : Set (Lambda R)))
  have htop : Ideal.span ({(1 : Lambda R)} : Set (Lambda R)) = ⊤ := by
    rw [Ideal.eq_top_iff_one]
    exact Ideal.subset_span (by simp)
  rw [htop]; infer_instance

theorem cyclicQuotient_one_finite (R : Type u) [CommRing R] :
    Finite (cyclicQuotient R 1) := by
  haveI : Subsingleton (cyclicQuotient R 1) := cyclicQuotient_one_subsingleton R
  haveI : Fintype (cyclicQuotient R 1) := Fintype.ofSubsingleton 0
  infer_instance

theorem pPowerElementary_zero_subsingleton (R : Type u) [CommRing R] (p : Lambda R) :
    Subsingleton (pPowerElementary R p 0) := by
  simpa [pPowerElementary] using cyclicQuotient_one_subsingleton R

theorem pPowerElementary_zero_finite (R : Type u) [CommRing R] (p : Lambda R) :
    Finite (pPowerElementary R p 0) := by
  simpa [pPowerElementary] using cyclicQuotient_one_finite R

theorem cyclicQuotient_isUnit_subsingleton (R : Type u) [CommRing R] (a : Lambda R)
    (ha : IsUnit a) : Subsingleton (cyclicQuotient R a) := by
  change Subsingleton (Lambda R ⧸ Ideal.span ({a} : Set (Lambda R)))
  have htop : Ideal.span ({a} : Set (Lambda R)) = ⊤ := by
    rw [Ideal.eq_top_iff_one]
    rcases ha with ⟨u, rfl⟩
    have hu : ((u : Lambda R) : Lambda R) ∈
        Ideal.span ({((u : Lambda R) : Lambda R)} : Set (Lambda R)) :=
      Ideal.subset_span (by simp)
    simpa using Ideal.mul_mem_left
      (Ideal.span ({((u : Lambda R) : Lambda R)} : Set (Lambda R)))
      ((↑u⁻¹ : Lambda R)) hu
  rw [htop]; infer_instance

theorem cyclicQuotient_isUnit_finite (R : Type u) [CommRing R] (a : Lambda R)
    (ha : IsUnit a) : Finite (cyclicQuotient R a) := by
  haveI : Subsingleton (cyclicQuotient R a) := cyclicQuotient_isUnit_subsingleton R a ha
  haveI : Fintype (cyclicQuotient R a) := Fintype.ofSubsingleton 0
  infer_instance

theorem pPowerElementary_isUnit_subsingleton (R : Type u) [CommRing R] (p : Lambda R)
    (n : ℕ) (hpn : IsUnit (p ^ n)) : Subsingleton (pPowerElementary R p n) :=
  cyclicQuotient_isUnit_subsingleton R (p ^ n) hpn

theorem pPowerElementary_isUnit_finite (R : Type u) [CommRing R] (p : Lambda R)
    (n : ℕ) (hpn : IsUnit (p ^ n)) : Finite (pPowerElementary R p n) :=
  cyclicQuotient_isUnit_finite R (p ^ n) hpn

end Iwasawa
end Roots
end MathlibExpansion
