import MathlibExpansion.Roots.Schlessinger.ArtinLocalOver
import MathlibExpansion.Roots.Schlessinger.DeformationFunctorOver
import MathlibExpansion.Roots.Schlessinger.ProRepOver

/-!
# BCDT 2001 — Bucket 3: Complete local O-algebra typed surface

Thin refinement of `Schlessinger.CompleteLocalNoetherianAlgOver` specialized to
the BCDT setting, plus typed max-ideal helpers and an explicit
`Λ`-algebra morphism bundle. No new axioms. Consumed by Buckets 2, 5, 6.

**Poison dodge.** Imports only `Roots/Schlessinger/*`. No
`DeligneAttachedRepresentation`, `EighthGap`, `Roots/HeckeViaDoubleCoset`,
`Roots/FontaineLaffaille*`, `Roots/ValenceFormula`, `Quarantine/*`, or any
poisoned sibling.

**T0/T1-discharge/T1-caller-data classification.** Every exported primitive
below is T0 (data-carrying, honest) or T1-caller-data (typed predicate
consumed by caller-supplied data). No T2/T3 poison-class primitives.
-/

namespace MathlibExpansion.Roots.BCDT2001

universe u

open MathlibExpansion.Roots.Schlessinger IsLocalRing

/-- **BCDT complete local O-algebra carrier.** Alias of
`Schlessinger.CompleteLocalNoetherianAlgOver` — the Mazur 1989 boundary
surface — fixed to the BCDT naming convention. T0 (data). -/
abbrev OAlg (Λ k : Type u) [CommRing Λ] [Field k] [Algebra Λ k] : Type (u+1) :=
  CompleteLocalNoetherianAlgOver Λ k

variable {Λ k : Type u} [CommRing Λ] [Field k] [Algebra Λ k]

/-- **O-algebra morphism.** Typed `Λ`-algebra homomorphism between the
carriers of two `OAlg` objects. T0 (data). -/
structure OAlgHom (R S : OAlg Λ k) where
  toAlgHom : R.carrier →ₐ[Λ] S.carrier

namespace OAlgHom

/-- Identity morphism. -/
def id (R : OAlg Λ k) : OAlgHom R R where
  toAlgHom := AlgHom.id Λ R.carrier

/-- Composition of morphisms. -/
def comp {R S T : OAlg Λ k} (g : OAlgHom S T) (f : OAlgHom R S) : OAlgHom R T where
  toAlgHom := g.toAlgHom.comp f.toAlgHom

/-- Surjectivity of the underlying `Λ`-algebra homomorphism. T1-caller-data. -/
def Surjective {R S : OAlg Λ k} (φ : OAlgHom R S) : Prop :=
  Function.Surjective φ.toAlgHom.toFun

/-- Kernel of the underlying `Λ`-algebra homomorphism as an ideal in `R`. -/
noncomputable def kernel {R S : OAlg Λ k} (φ : OAlgHom R S) : Ideal R.carrier :=
  RingHom.ker φ.toAlgHom.toRingHom

end OAlgHom

/-! ## Maximal ideal helper -/

/-- **Maximal ideal** of an `OAlg` carrier, produced via the local-ring
instance. T0 (data, derived from `instIsLocal`). -/
noncomputable def OAlg.maxIdeal (R : OAlg Λ k) : Ideal R.carrier :=
  IsLocalRing.maximalIdeal R.carrier

/-! ## Residue field accessor (re-exposed) -/

/-- **Residue field** of an `OAlg` carrier as a concrete equivalence to `k`.
T0 (data, re-exposed for convenience). -/
noncomputable def OAlg.residueEquivTo_k (R : OAlg Λ k) :
    IsLocalRing.ResidueField R.carrier ≃+* k := R.residueEquiv

/-! ## T1 completeness predicate (re-exposed, not new) -/

/-- **Adic-completeness** at the maximal ideal — already part of the
`CompleteLocalNoetherianAlgOver` bundle. Re-exposed as a named helper.
T1-caller-data. -/
def OAlg.IsComplete (R : OAlg Λ k) : Prop :=
  IsAdicComplete R.maxIdeal R.carrier

/-- The completeness predicate is discharged by the bundle field. -/
theorem OAlg.isComplete (R : OAlg Λ k) : R.IsComplete := R.isAdicComplete

/-! ## Integration handle for `DeformationFunctorOver` consumption -/

/-- A **pro-representing datum** for a deformation functor `D` on
`ArtinLocalAlgOver Λ k` is an `OAlg Λ k` together with the restricted
natural transformation `HomFunctorOver R ⟶ D.F` witnessing bijectivity
componentwise. Direct re-packaging of
`Schlessinger.ProRepresentedByOver` into typed data. T0. -/
structure ProReprDatum (D : DeformationFunctorOver Λ k) where
  represent   : OAlg Λ k
  witness     : ProRepresentedByOver D represent

end MathlibExpansion.Roots.BCDT2001
