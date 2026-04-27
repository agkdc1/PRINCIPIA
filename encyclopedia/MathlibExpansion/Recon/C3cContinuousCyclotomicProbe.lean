import Mathlib.FieldTheory.AbsoluteGaloisGroup
import Mathlib.FieldTheory.IsAlgClosed.Basic
import Mathlib.FieldTheory.IsAlgClosed.AlgebraicClosure
import Mathlib.NumberTheory.Cyclotomic.Basic
import Mathlib.NumberTheory.Cyclotomic.CyclotomicCharacter
import Mathlib.NumberTheory.Cyclotomic.PrimitiveRoots
import Mathlib.NumberTheory.Padics.RingHoms
import Mathlib.Topology.Algebra.ContinuousMonoidHom

open scoped Cyclotomic

open IsAlgClosed

namespace MathlibExpansion.Recon.C3cContinuousCyclotomicProbe

noncomputable section

variable (K : Type*) [Field K]
variable (p n : ℕ)
variable [Fact p.Prime]

abbrev pPowSucc : ℕ+ := by
  refine ⟨p ^ (n + 1), ?_⟩
  exact pow_pos (Nat.Prime.pos (Fact.out : p.Prime)) _

#check Field.absoluteGaloisGroup K
#check @IsAlgClosed.lift
#check @IsCyclotomicExtension.zeta
#check IsPrimitiveRoot.map_of_injective
#check IsPrimitiveRoot.card_rootsOfUnity
#check ModularCyclotomicCharacter
#check ModularCyclotomicCharacter.spec
#check ModularCyclotomicCharacter.unique
#check PadicInt.ofIntSeq
#check PadicInt.toZModPow
#check PadicInt.ofIntSeq
#check continuous_of_continuousAt_one

theorem card_rootsOfUnity_algClosure_pPowSucc [NeZero (((pPowSucc (p := p) (n := n) : ℕ) : K))] :
    Fintype.card (rootsOfUnity (p ^ (n + 1)) (AlgebraicClosure K)) = p ^ (n + 1) := by
  letI :
      IsCyclotomicExtension {pPowSucc (p := p) (n := n)} K
        (CyclotomicField (pPowSucc (p := p) (n := n)) K) :=
    CyclotomicField.isCyclotomicExtension (n := pPowSucc (p := p) (n := n)) (K := K)
  letI :
      FiniteDimensional K (CyclotomicField (pPowSucc (p := p) (n := n)) K) :=
    IsCyclotomicExtension.finiteDimensional {pPowSucc (p := p) (n := n)} K
      (CyclotomicField (pPowSucc (p := p) (n := n)) K)
  let ζ : CyclotomicField (pPowSucc (p := p) (n := n)) K :=
    IsCyclotomicExtension.zeta (pPowSucc (p := p) (n := n)) K
      (CyclotomicField (pPowSucc (p := p) (n := n)) K)
  let ι : CyclotomicField (pPowSucc (p := p) (n := n)) K →ₐ[K] AlgebraicClosure K :=
    IsAlgClosed.lift (R := K) (S := CyclotomicField (pPowSucc (p := p) (n := n)) K)
      (M := AlgebraicClosure K)
  have hζ : IsPrimitiveRoot ζ (p ^ (n + 1)) := by
    simpa [pPowSucc] using
      (IsCyclotomicExtension.zeta_spec (pPowSucc (p := p) (n := n)) K
        (CyclotomicField (pPowSucc (p := p) (n := n)) K))
  have hιζ : IsPrimitiveRoot (ι ζ) (p ^ (n + 1)) :=
    hζ.map_of_injective ι.injective
  exact hιζ.card_rootsOfUnity

example [NeZero (((pPowSucc (p := p) (n := n) : ℕ) : K))] :
    Field.absoluteGaloisGroup K →* (ZMod (p ^ (n + 1)))ˣ :=
  let χ :
      (AlgebraicClosure K ≃+* AlgebraicClosure K) →* (ZMod (p ^ (n + 1)))ˣ :=
    ModularCyclotomicCharacter (L := AlgebraicClosure K) (n := p ^ (n + 1))
      (card_rootsOfUnity_algClosure_pPowSucc (K := K) (p := p) (n := n))
  let χRing :
      Field.absoluteGaloisGroup K →* (AlgebraicClosure K ≃+* AlgebraicClosure K) :=
    { toFun := AlgEquiv.toRingEquiv
      map_one' := rfl
      map_mul' _ _ := rfl }
  χ.comp χRing

end

end MathlibExpansion.Recon.C3cContinuousCyclotomicProbe
