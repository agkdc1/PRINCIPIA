import Mathlib
import MathlibExpansion.Roots.Mazur1977.PrimeLevelHecke

/-!
# Localized prime-level Hecke algebra (Mazur 1977 §6 — Ribet-consumed fragment)

Packages the localization `T_𝔪` of the prime-level Hecke algebra at a
maximal ideal `𝔪 ⊂ T`. The Mazur 1977 Gorenstein boundary
(`MultiplicityOne.lean`, historical filename) is formulated with respect to
this localized algebra.

**Shape.** We keep the localization carrier `algebra : Type*` existential,
so the consumer can supply either `Localization.AtPrime` or a concrete
quotient-and-localization chain. The key typed fields are:
- `maximalIdeal : Ideal C.T`, paired with `isMaximal : IsMaximal`.
- `algebra : Type*` with `CommRing` + `Algebra C.T algebra`.
- `atPrime : IsLocalization.AtPrime algebra maximalIdeal` — the Mathlib
  `IsLocalization.AtPrime` type-class, which is a genuine typed
  predicate on the concrete algebra map, NOT a bare `Prop`.

**Doctrine v2.** No `(statement : Prop, proof : statement)` laundering.
The old T1-site `LocalHeckeAlgebraAtMaximal.localizationStatement` in
`MathlibExpansion/LocalHeckeAlgebra.lean` is superseded here; demolition
of that site is tracked separately (see breach report).
-/

namespace MathlibExpansion.Roots.Mazur1977

universe u v w x

variable {R : Type u} {M : Type v} [CommRing R] [AddCommGroup M] [Module R M]
variable {p : ℕ}

/-- **Localized prime-level Hecke algebra** at a maximal ideal `𝔪 ⊂ T`.

Carries the maximal-ideal data, the localized algebra `T_𝔪` (as an
existential type `algebra : Type*` with `CommRing` + `Algebra C.T algebra`
instances), and a genuine `IsLocalization.AtPrime` witness. -/
structure PrimeLevelLocalizedHecke
    (C : PrimeLevelHeckeCarrier.{u,v,w} R M p) where
  /-- The maximal ideal of `T` at which we localize. -/
  maximalIdeal : Ideal C.T
  /-- The maximality witness. -/
  isMaximal : maximalIdeal.IsMaximal
  /-- The localized algebra `T_𝔪`. -/
  algebra : Type x
  /-- `T_𝔪` is a commutative ring. -/
  instCommRing : CommRing algebra
  /-- `T_𝔪` is a `T`-algebra (via the localization map). -/
  instAlgebra : Algebra C.T algebra
  /-- The algebra map `T → T_𝔪` is a localization at `𝔪`. -/
  atPrime : IsLocalization.AtPrime algebra maximalIdeal

attribute [instance] PrimeLevelLocalizedHecke.isMaximal
                     PrimeLevelLocalizedHecke.instCommRing
                     PrimeLevelLocalizedHecke.instAlgebra
                     PrimeLevelLocalizedHecke.atPrime

end MathlibExpansion.Roots.Mazur1977
