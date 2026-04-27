import Mathlib.FieldTheory.AbsoluteGaloisGroup
import Mathlib.FieldTheory.IsAlgClosed.AlgebraicClosure
import Mathlib.FieldTheory.IsAlgClosed.Basic
import Mathlib.NumberTheory.Cyclotomic.Basic
import Mathlib.NumberTheory.Cyclotomic.CyclotomicCharacter
import Mathlib.NumberTheory.Cyclotomic.PrimitiveRoots
import Mathlib.NumberTheory.Padics.RingHoms
import Mathlib.Topology.Algebra.ContinuousMonoidHom

/-!
# Continuous p-adic cyclotomic characters

This file packages the finite-level cyclotomic characters
`G_K →* (ZMod (p^(n+1)))ˣ` attached to the absolute Galois group of a field `K`
of characteristic different from `p`, and exposes the expected continuous lift to
`ℤ_[p]ˣ`.

The finite-level specialization is proved in this file. The inverse-limit lift
itself is isolated behind a single existence axiom
`exists_padicCyclotomicCharacter`; uniqueness of such a lift is proved here from
Mathlib's extensionality theorem for `ℤ_[p]`.
-/

open scoped Cyclotomic
open IsAlgClosed

noncomputable section

variable (K : Type*) [Field K]
variable (p n : ℕ) [Fact p.Prime]

/-- The positive natural number `p^(n+1)`. -/
abbrev primePowSucc : ℕ+ := by
  refine ⟨p ^ (n + 1), ?_⟩
  exact pow_pos (Nat.Prime.pos (Fact.out : p.Prime)) _

section FiniteLevel

variable [NeZero (p : K)]

/-- If `p` is nonzero in `K`, then so is `p^(n+1)`. -/
lemma primePowSucc_neZero : NeZero (((primePowSucc (p := p) (n := n) : ℕ) : K)) := by
  refine ⟨?_⟩
  simpa [primePowSucc, Nat.cast_pow] using
    pow_ne_zero (n + 1) (NeZero.natCast_ne p K)

/-- The algebraic closure of a field of characteristic different from `p` contains exactly
`p^(n+1)` roots of unity of order dividing `p^(n+1)`. -/
theorem card_rootsOfUnity_algebraicClosure_primePow :
    Fintype.card (rootsOfUnity (p ^ (n + 1)) (AlgebraicClosure K)) = p ^ (n + 1) := by
  letI : NeZero (((primePowSucc (p := p) (n := n) : ℕ) : K)) :=
    primePowSucc_neZero (K := K) (p := p) (n := n)
  letI :
      IsCyclotomicExtension {primePowSucc (p := p) (n := n)} K
        (CyclotomicField (primePowSucc (p := p) (n := n)) K) :=
    CyclotomicField.isCyclotomicExtension (n := primePowSucc (p := p) (n := n)) (K := K)
  letI :
      FiniteDimensional K (CyclotomicField (primePowSucc (p := p) (n := n)) K) :=
    IsCyclotomicExtension.finiteDimensional {primePowSucc (p := p) (n := n)} K
      (CyclotomicField (primePowSucc (p := p) (n := n)) K)
  let ζ : CyclotomicField (primePowSucc (p := p) (n := n)) K :=
    IsCyclotomicExtension.zeta (primePowSucc (p := p) (n := n)) K
      (CyclotomicField (primePowSucc (p := p) (n := n)) K)
  let ι : CyclotomicField (primePowSucc (p := p) (n := n)) K →ₐ[K] AlgebraicClosure K :=
    IsAlgClosed.lift (R := K) (S := CyclotomicField (primePowSucc (p := p) (n := n)) K)
      (M := AlgebraicClosure K)
  have hζ : IsPrimitiveRoot ζ (p ^ (n + 1)) := by
    simpa [primePowSucc] using
      (IsCyclotomicExtension.zeta_spec (primePowSucc (p := p) (n := n)) K
        (CyclotomicField (primePowSucc (p := p) (n := n)) K))
  exact (hζ.map_of_injective ι.injective).card_rootsOfUnity

/-- The finite-level cyclotomic character on the absolute Galois group with values in
`(ℤ/p^(n+1)ℤ)ˣ`. -/
noncomputable def modularCyclotomicCharacterPrimePow :
    Field.absoluteGaloisGroup K →* (ZMod (p ^ (n + 1)))ˣ := by
  letI : NeZero (((primePowSucc (p := p) (n := n) : ℕ) : K)) :=
    primePowSucc_neZero (K := K) (p := p) (n := n)
  let χ :
      (AlgebraicClosure K ≃+* AlgebraicClosure K) →* (ZMod (p ^ (n + 1)))ˣ :=
    ModularCyclotomicCharacter (L := AlgebraicClosure K) (n := p ^ (n + 1))
      (card_rootsOfUnity_algebraicClosure_primePow (K := K) (p := p) (n := n))
  let χRing :
      Field.absoluteGaloisGroup K →* (AlgebraicClosure K ≃+* AlgebraicClosure K) :=
    { toFun := AlgEquiv.toRingEquiv
      map_one' := rfl
      map_mul' _ _ := rfl }
  exact χ.comp χRing

/-- Reduction of a `p`-adic unit modulo `p^n`. -/
noncomputable def padicUnitReduction (m : ℕ) : ℤ_[p]ˣ →* (ZMod (p ^ m))ˣ :=
  Units.map (PadicInt.toZModPow (p := p) m)

/--
Upstream-narrow existence axiom for the continuous `p`-adic cyclotomic character.

Citation: Tobias Wiese, 2024, *Galois Representations*, §1.3,
Proposition 1.3.1 and the preceding construction of the Tate module
`T_l(K^×)`: the compatible Galois actions on `l^n`-power roots of unity define
the `l`-adic cyclotomic character `G_K → ℤ_lˣ`. In this file Mathlib supplies
the finite character and `ℤ_[p]` inverse-limit extensionality; the remaining
missing upstream construction is the continuous existence of the compatible
`ℤ_[p]ˣ`-valued lift.
-/
axiom exists_padicCyclotomicCharacter :
    ∃ χ : ContinuousMonoidHom (Field.absoluteGaloisGroup K) ℤ_[p]ˣ,
      ∀ m : ℕ,
        (padicUnitReduction (p := p) (m + 1)).comp χ.toMonoidHom =
          modularCyclotomicCharacterPrimePow (K := K) (p := p) (n := m)

/--
There is a unique continuous lift of the finite-level cyclotomic characters to `ℤ_[p]ˣ`.

The existence is the upstream axiom `exists_padicCyclotomicCharacter`; uniqueness
is formal because two `p`-adic integers are equal if all reductions modulo `p^n`
are equal.
-/
theorem existsUnique_padicCyclotomicCharacter :
    ∃! χ : ContinuousMonoidHom (Field.absoluteGaloisGroup K) ℤ_[p]ˣ,
      ∀ m : ℕ,
        (padicUnitReduction (p := p) (m + 1)).comp χ.toMonoidHom =
          modularCyclotomicCharacterPrimePow (K := K) (p := p) (n := m) := by
  classical
  obtain ⟨χ, hχ⟩ := exists_padicCyclotomicCharacter (K := K) (p := p)
  refine ⟨χ, hχ, ?_⟩
  intro ψ hψ
  apply ContinuousMonoidHom.ext
  intro g
  apply Units.ext
  apply (PadicInt.ext_of_toZModPow).mp
  intro k
  cases k with
  | zero =>
      haveI : Subsingleton (ZMod (p ^ 0)) := by
        simpa using (inferInstance : Subsingleton (ZMod 1))
      exact Subsingleton.elim _ _
  | succ m =>
      have hχm :
          ((padicUnitReduction (p := p) (m + 1)).comp χ.toMonoidHom) g =
            modularCyclotomicCharacterPrimePow (K := K) (p := p) (n := m) g := by
        rw [hχ m]
      have hψm :
          ((padicUnitReduction (p := p) (m + 1)).comp ψ.toMonoidHom) g =
            modularCyclotomicCharacterPrimePow (K := K) (p := p) (n := m) g := by
        rw [hψ m]
      have hred :
          padicUnitReduction (p := p) (m + 1) (ψ g) =
            padicUnitReduction (p := p) (m + 1) (χ g) := by
        exact hψm.trans hχm.symm
      simpa [padicUnitReduction] using congrArg Units.val hred

/-- The continuous `p`-adic cyclotomic character. -/
noncomputable def PadicCyclotomicCharacter :
    ContinuousMonoidHom (Field.absoluteGaloisGroup K) ℤ_[p]ˣ :=
  Classical.choose (existsUnique_padicCyclotomicCharacter (K := K) (p := p)).exists

namespace PadicCyclotomicCharacter

/-- Compatibility of the continuous `p`-adic cyclotomic character with the finite-level
cyclotomic characters. -/
theorem spec (m : ℕ) :
    (padicUnitReduction (p := p) (m + 1)).comp
        (PadicCyclotomicCharacter (K := K) (p := p)).toMonoidHom =
      modularCyclotomicCharacterPrimePow (K := K) (p := p) (n := m) :=
  Classical.choose_spec (existsUnique_padicCyclotomicCharacter (K := K) (p := p)).exists m

/-- Uniqueness of the continuous `p`-adic cyclotomic character under the expected finite-level
compatibility condition. -/
theorem unique
    (χ : ContinuousMonoidHom (Field.absoluteGaloisGroup K) ℤ_[p]ˣ)
    (hχ : ∀ m : ℕ,
      (padicUnitReduction (p := p) (m + 1)).comp χ.toMonoidHom =
        modularCyclotomicCharacterPrimePow (K := K) (p := p) (n := m)) :
    χ = PadicCyclotomicCharacter (K := K) (p := p) :=
  ExistsUnique.unique
    (existsUnique_padicCyclotomicCharacter (K := K) (p := p))
    hχ
    (spec (K := K) (p := p))

end PadicCyclotomicCharacter

end FiniteLevel
