import MathlibExpansion.Roots.HeckeViaDoubleCoset
import MathlibExpansion.Roots.ParabolicCohomology
import MathlibExpansion.Roots.ContinuousGaloisCohomology
import MathlibExpansion.RibetConductorDrop
import MathlibExpansion.LocalHeckeAlgebra
import MathlibExpansion.DeligneAttachedRepresentation
import MathlibExpansion.HeckeOperatorReal
import Mathlib.FieldTheory.AbsoluteGaloisGroup
import Mathlib.GroupTheory.GroupAction.ConjAct
import Mathlib.GroupTheory.DoubleCoset
import Mathlib.GroupTheory.QuotientGroup.Defs
import Mathlib.LinearAlgebra.Matrix.GeneralLinearGroup.Defs
import Mathlib.NumberTheory.NumberField.Basic
import Mathlib.RepresentationTheory.GroupCohomology.LowDegree
import Mathlib.RepresentationTheory.Rep
import Mathlib.RingTheory.Ideal.Quotient.Operations
import Mathlib.RingTheory.Localization.AtPrime

open scoped MatrixGroups

namespace MathlibExpansion.TestChecks

open HeckeViaDoubleCoset
open groupCohomology

section P1

def doubleCosetSet
    (Γ : Subgroup SL(2, ℤ)) (α : SL(2, ℤ)) : Set SL(2, ℤ) :=
  Doset.doset α (Γ : Set SL(2, ℤ)) Γ

#check doubleCosetSet

def upgrade_decompStatement_doubleCoset
    (Γ : Subgroup SL(2, ℤ)) (α : SL(2, ℤ))
    (d : DoubleCosetDecomposition Γ α) : Prop :=
  ∀ g : SL(2, ℤ), g ∈ doubleCosetSet Γ α →
    ∃! r : SL(2, ℤ), r ∈ d.cosetReps ∧ ∃ γ : Γ, g = γ.1 * r

#check upgrade_decompStatement_doubleCoset

def upgrade_decompStatement
    (Γ : Subgroup SL(2, ℤ)) (α : SL(2, ℤ))
    (d : DoubleCosetDecomposition Γ α) : Prop :=
  ∀ g : SL(2, ℤ), g ∈ d.cosetReps →
    ∃ r ∈ d.cosetReps, ∃ γ : Γ, g = γ.1 * r

#check upgrade_decompStatement

def upgrade_heckeEquivarianceStatement
    (k : Type*) [CommRing k]
    (M : Type*) [AddCommGroup M] [Module k M]
    (Γ : Subgroup SL(2, ℤ))
    (ρ : Representation k SL(2, ℤ) M)
    (α : SL(2, ℤ))
    (d : DoubleCosetDecomposition Γ α)
    (T : HeckeOperatorOnH1 k M Γ ρ α d) : Prop :=
  ∀ γ : Γ, T.operator.comp (ρ γ.1) = (ρ γ.1).comp T.operator

#check upgrade_heckeEquivarianceStatement

def upgrade_heckeEquivarianceStatement_typed
    (k : Type*) [CommRing k]
    (M : Type*) [AddCommGroup M] [Module k M]
    (Γ : Subgroup SL(2, ℤ))
    (ρ : Representation k SL(2, ℤ) M)
    (α : SL(2, ℤ))
    (d : DoubleCosetDecomposition Γ α)
    (T : HeckeOperatorOnH1 k M Γ ρ α d) : Prop :=
  ∀ γ : Γ, T.toLinearMap.comp (ρ γ.1) = (ρ γ.1).comp T.toLinearMap

#check upgrade_heckeEquivarianceStatement_typed

def upgrade_localizationStatement
    (T : Type*) [CommRing T]
    (H : NumberTheory.LocalHeckeAlgebra)
    (φ : T →+* H.algebra) : Prop :=
  ∃ _ : (Ideal.comap φ (IsLocalRing.maximalIdeal H.algebra)).IsPrime,
    IsLocalHom
      (Localization.localRingHom
        (Ideal.comap φ (IsLocalRing.maximalIdeal H.algebra))
        (IsLocalRing.maximalIdeal H.algebra) φ rfl)

#check upgrade_localizationStatement

def honest_localizationCarrier
    (T : Type*) [CommRing T]
    (m : Ideal T) [m.IsPrime]
    (S : Type*) [CommRing S] [Algebra T S] [IsLocalization.AtPrime S m] :
    T →+* S :=
  algebraMap T S

#check honest_localizationCarrier

theorem honest_localizationCarrier_apply
    (T : Type*) [CommRing T]
    (m : Ideal T) [m.IsPrime]
    (S : Type*) [CommRing S] [Algebra T S] [IsLocalization.AtPrime S m]
    (x : T) :
    honest_localizationCarrier T m S x = algebraMap T S x :=
  rfl

#check honest_localizationCarrier_apply

end P1

section P2

variable (k : Type*) [CommRing k]
variable (M : Type*) [AddCommGroup M] [Module k M]

#check Module.End k M
#check Ideal (Module.End k M)
#check Representation.asAlgebraHom

end P2

section P3

variable (p : ℕ) [Fact p.Prime]
variable (G : Type) [Group G]

#check Rep (ZMod p) G
#check groupCohomology.H1
#check groupCohomology.H2
#check Rep.trivial (ZMod p) G (ZMod p)
#check groupCohomology.H1 (Rep.trivial (ZMod p) G (ZMod p))
#check groupCohomology.H2 (Rep.trivial (ZMod p) G (ZMod p))

end P3

section P7

open Roots.ContinuousGaloisCohomology

#check MathlibExpansion.Roots.ContinuousGaloisCohomology.LocallyConstantH1ProfiniteFactorizationWall
#check ContinuousCohomologyLongExactBoundary
#check continuous_long_exact_sequence_wall

end P7

section P6

variable (A : Type*) [CommRing A]
variable (I : Ideal A)

#check MulAction.orbitRel
#check (MulAction.orbitRel (ConjAct (GL (Fin 2) A)) (GL (Fin 2) A))
#check (QuotientGroup.mk : GL (Fin 2) A → GL (Fin 2) A ⧸ (⊥ : Subgroup (GL (Fin 2) A)))

def congruenceOneCandidate : Set (GL (Fin 2) A) :=
  { g | ∀ i j, ((g : Matrix (Fin 2) (Fin 2) A) i j - if i = j then 1 else 0) ∈ I }

#check congruenceOneCandidate
#check (show Set (GL (Fin 2) A) from congruenceOneCandidate (A := A) I)

end P6

section P1c

open NumberTheory
open RibetConductorDrop

def ribet_typedConductorDropStatement
    (E : WeierstrassCurve ℤ) (ℓ N N' : ℕ) (hℓ : Nat.Prime ℓ) : Prop :=
  NumberTheory.conductor E = N ∧
    conductorExponentAt E ℓ hℓ = 1 ∧
    N' = N / ℓ

#check ribet_typedConductorDropStatement

def ribet_typedConductorDropPackage
    (E : WeierstrassCurve ℤ) (ℓ N N' : ℕ) (hℓ : Nat.Prime ℓ) : Type :=
  { h : RibetConductorDropAtPrime E ℓ hℓ //
      ribet_typedConductorDropStatement E ℓ N N' hℓ }

#check ribet_typedConductorDropPackage

end P1c

section Mazur1977Job4

open NumberTheory
open NumberTheory.HeckeOperatorReal
open MathlibExpansion.Roots.ParabolicCohomology
open CongruenceSubgroup

/-- Concrete prime-away-from-`N` Hecke generators inside `Module.End`. -/
noncomputable def analyticPrimeAwayFamily (N : ℕ) (k : ℤ) :
    {q : ℕ // q.Prime ∧ Nat.Coprime q N} →
      Module.End ℂ (ModularForm (Gamma0 N) k)
  | q => primeHeckeOperator N q.1 k q.2.1 q.2.2

/-- The Hecke carrier generated by concrete prime Hecke operators on modular forms. -/
noncomputable def analyticHeckeCarrier (N : ℕ) (k : ℤ) :
    Subalgebra ℂ (Module.End ℂ (ModularForm (Gamma0 N) k)) :=
  Algebra.adjoin ℂ (Set.range (analyticPrimeAwayFamily N k))

#check analyticPrimeAwayFamily
#check analyticHeckeCarrier

variable {k : Type} [CommRing k]
variable {Γ : Type} [Group Γ]
variable (A : Rep k Γ) {ι : Type} (P : ι → Subgroup Γ)

/-- Concrete endomorphism family on parabolic cohomology from ambient preserving maps. -/
def parabolicHeckeFamily
    (ιq : Type*) (Tq : ιq → ParabolicPreservingEndomorphism A P) :
    ιq → Module.End k (ParabolicCohomology A P)
  | q => (Tq q).restrict

/-- The Hecke carrier generated inside the honest parabolic-cohomology endomorphism ring. -/
noncomputable def parabolicHeckeCarrier
    (ιq : Type*) (Tq : ιq → ParabolicPreservingEndomorphism A P) :
    Subalgebra k (Module.End k (ParabolicCohomology A P)) :=
  Algebra.adjoin k (Set.range (parabolicHeckeFamily (A := A) (P := P) ιq Tq))

#check parabolicHeckeFamily
#check parabolicHeckeCarrier

end Mazur1977Job4

section Mazur1977Job7

open NumberTheory
open NumberTheory.HeckeOperatorReal
open MathlibExpansion.Roots.ParabolicCohomology
open CongruenceSubgroup

variable (ℓ : ℕ) [Fact ℓ.Prime]
variable (Γ : Type) [Group Γ]

/-- The algebraic parabolic-cohomology substrate specializes to residual coefficients. -/
def residualParabolicCarrier
    (A : Rep (ZMod ℓ) Γ) {ι : Type*} (P : ι → Subgroup Γ) :
    Submodule (ZMod ℓ) (groupCohomology.H1 A) :=
  ParabolicCohomology A P

#check residualParabolicCarrier

/-- A residual comparison statement can already target `GL₂(ZMod ℓ)` at signature level. -/
def residualGaloisStatement
    (ρ : Γ →* GL (Fin 2) (ZMod ℓ)) : Prop :=
  True

#check residualGaloisStatement

variable (T : Type) [CommRing T]
variable (m : Ideal T)

/-- Quotient coefficients `T/m` are accepted by the algebraic `Rep`/`H¹` surface. -/
def quotientParabolicCarrier
    (A : Rep (T ⧸ m) Γ) {ι : Type*} (P : ι → Subgroup Γ) :
    Submodule (T ⧸ m) (groupCohomology.H1 A) :=
  ParabolicCohomology A P

#check quotientParabolicCarrier

/-- The analytic prime Hecke operator remains hard-wired to complex coefficients. -/
noncomputable def analyticPrimeHeckeEnd
    (N : ℕ) (k : ℤ) :
    {q : ℕ // q.Prime ∧ Nat.Coprime q N} →
      Module.End ℂ (ModularForm (Gamma0 N) k)
  | q => primeHeckeOperator N q.1 k q.2.1 q.2.2

#check analyticPrimeHeckeEnd

end Mazur1977Job7

end MathlibExpansion.TestChecks
