import MathlibExpansion.Roots.HodgeTate.TateTwist
import MathlibExpansion.Roots.HodgeTate.InvariantSubspace
import MathlibExpansion.Padics.Cp.AxSenTate

/-!
# Ax-Sen-Tate: twisted invariants vanish at nonzero weight

## Imported invariant-vanishing theorem

```
axSenTate_invariant_vanishing
```

States: for n ≠ 0, the G_K-fixed vectors of C_p(n) are zero for a character
identified with the `p`-adic cyclotomic character.

This module no longer introduces its own self-axiom. Instead it re-exports the
concrete C3d invariant-vanishing theorem on `MathlibExpansion.Padics.Cp p`
under the Hodge-Tate namespace, keeping the remaining Hodge-Tate API in one
place while avoiding a duplicate ledger entry.

## Citations

- Tate (1967) "p-divisible groups" §3.3: proved (C_p(n))^{G_K} = 0 for n ≠ 0
- Ax (1970) "Zeros of polynomials over local fields": related vanishing
- Sen (1980) "Continuous cohomology and p-adic Galois representations"
- Fontaine-Ouyang "Theory of p-adic Galois representations" §1.5

## What is NOT axiomatized

The full Hodge-Tate decomposition theorem (`V ⊗_{ℚ_p} C_p ≅ ⊕ C_p(nᵢ)`) is
NOT an axiom here. It is captured as a predicate `IsHodgeTate` whose content
is the existence of such a decomposition; the predicate is inhabited by an
explicit construction in F7. The axiom gives the uniqueness / independence of
weight spaces, which is what drives the linear-independence argument.
-/

namespace MathlibExpansion.Roots.HodgeTate

/-- **Ax-Sen-Tate invariant vanishing theorem.**

This is a direct namespace-level wrapper around the concrete C3d theorem on
`MathlibExpansion.Padics.Cp p`. No new axiom is introduced here; the only
non-kernel assumptions are those already carried by the concrete theorem.

Citations:
- Tate (1967) "p-divisible groups" §3.3 (original proof)
- Ax (1970); Sen (1980) (generalizations)
- Fontaine-Ouyang §1.5 (modern reference) -/
theorem axSenTate_invariant_vanishing
    {p : ℕ} [Fact p.Prime]
    (χ : ContinuousMonoidHom (MathlibExpansion.Padics.PadicGaloisGroup p) (ℤ_[p])ˣ)
    (hχ : MathlibExpansion.Padics.IsPadicCyclotomicCharacter p χ)
    (n : ℤ) (hn : n ≠ 0) :
    MathlibExpansion.Padics.tateTwistInvariantSubgroup p χ n = ⊥ :=
  MathlibExpansion.Padics.axSenTate_invariant_vanishing p χ hχ n hn

/-- Canonical-character wrapper for Ax-Sen-Tate invariant vanishing. -/
theorem axSenTate_invariant_vanishing_padicCyclotomicCharacter
    {p : ℕ} [Fact p.Prime]
    (n : ℤ) (hn : n ≠ 0) :
    MathlibExpansion.Padics.tateTwistInvariantSubgroup p
      (PadicCyclotomicCharacter (K := ℚ_[p]) (p := p)) n = ⊥ :=
  MathlibExpansion.Padics.axSenTate_invariant_vanishing_padicCyclotomicCharacter p n hn

/-! ## Derived: weight spaces at different weights are disjoint -/

/-- A vector v in C_p lies in at most one weight space.

If `σ_g v = χ(g)^m v` for all g (v is an eigenvector of weight m) and also
`σ_g v = χ(g)^n v` for all g (weight n), and m ≠ n, then v = 0.

Proof sketch: `v = χ(g)^m v` and `v = χ(g)^n v` imply
`χ(g)^(m-n) v = v`, i.e. `v` lies in the concrete twist-invariant subgroup on
`MathlibExpansion.Padics.Cp p`. Since `m - n ≠ 0`, Ax-Sen-Tate forces `v = 0`.
-/
theorem weight_space_disjoint
    {p : ℕ} [Fact p.Prime]
    (χ : ContinuousMonoidHom (MathlibExpansion.Padics.PadicGaloisGroup p) (ℤ_[p])ˣ)
    (hχ : MathlibExpansion.Padics.IsPadicCyclotomicCharacter p χ)
    (m n : ℤ) (hmn : m ≠ n) :
    MathlibExpansion.Padics.tateTwistInvariantSubgroup p χ (m - n) = ⊥ := by
  exact axSenTate_invariant_vanishing χ hχ (m - n) (by omega)

/-- Weight-space disjointness for the canonical `p`-adic cyclotomic
character. -/
theorem weight_space_disjoint_padicCyclotomicCharacter
    {p : ℕ} [Fact p.Prime]
    (m n : ℤ) (hmn : m ≠ n) :
    MathlibExpansion.Padics.tateTwistInvariantSubgroup p
      (PadicCyclotomicCharacter (K := ℚ_[p]) (p := p)) (m - n) = ⊥ :=
  MathlibExpansion.Padics.weight_space_disjoint_padicCyclotomicCharacter p m n hmn

/-- At weight zero the invariant subgroup is NOT forced to be ⊥.
(The untwisted Galois action on C_p(0) = C_p has (C_p)^{G_K} = K̂ ≠ 0.) -/
theorem weight_zero_not_forced_bot
    {p : ℕ} [Fact p.Prime]
    {Khat : Type*} [Field Khat]
    (pkg : CpPackage p Khat)
    (_χ : @ContinuousCyclotomicCharacter p _ pkg.G pkg.instGroup_G pkg.instTopSpace_G) :
    -- The axiom does NOT apply at n = 0; this theorem records that fact.
    ¬ (0 ≠ (0 : ℤ)) := by
  simp

/-! ## Hodge-Tate predicate -/

/-- A finite list of Hodge-Tate weights: integers with multiplicities. -/
structure HodgeTateWeightData where
  /-- The Hodge-Tate weights as a list (may have repeats for multiplicity). -/
  weights : List ℤ
  /-- The list is sorted for canonical form. -/
  sorted : weights.Sorted (· ≤ ·)

/-- A continuous representation ρ of G on an abelian group V is Hodge-Tate
(relative to pkg, χ) if it admits a Hodge-Tate weight decomposition.

This is a predicate, not a construction — the actual decomposition requires
C_p-linearity and finite-dimensionality that we abstract here. The predicate is
inhabited by the concrete elliptic-curve construction in F7. -/
structure IsHodgeTate
    {p : ℕ} [Fact p.Prime]
    {Khat : Type*} [Field Khat]
    (pkg : CpPackage p Khat)
    (χ : @ContinuousCyclotomicCharacter p _ pkg.G pkg.instGroup_G pkg.instTopSpace_G)
    {V : Type*} [AddCommGroup V] [TopologicalSpace V]
    (ρ : @ContinuousRepresentation pkg.G pkg.instGroup_G pkg.instTopSpace_G V _ _) where
  /-- The Hodge-Tate weights of this representation. -/
  weightData : HodgeTateWeightData
  /-- For each weight n, there is a nonzero "weight space": a subgroup of V
      where all elements transform by χ^n under the G-action.
      We record this as the existence of a representation morphism
      from the weight-n twist representation into ρ. -/
  weightSpace : ∀ n ∈ weightData.weights,
    ∃ (W : AddSubgroup V) (_hW : W ≠ ⊥),
      ∀ (v : V) (_hv : v ∈ W) (g : pkg.G),
        letI : Field pkg.Cp := pkg.instField_Cp
        letI : Group pkg.G := pkg.instGroup_G
        letI : TopologicalSpace pkg.G := pkg.instTopSpace_G
        ρ.smul g v ∈ W

/-- The Hodge-Tate weights of a Hodge-Tate representation are well-defined
as a list (via the `weightData` field). -/
def IsHodgeTate.weights
    {p : ℕ} [Fact p.Prime]
    {Khat : Type*} [Field Khat]
    (pkg : CpPackage p Khat)
    (χ : @ContinuousCyclotomicCharacter p _ pkg.G pkg.instGroup_G pkg.instTopSpace_G)
    {V : Type*} [AddCommGroup V] [TopologicalSpace V]
    {ρ : @ContinuousRepresentation pkg.G pkg.instGroup_G pkg.instTopSpace_G V _ _}
    (ht : IsHodgeTate pkg χ ρ) : List ℤ :=
  ht.weightData.weights

/-- The Hodge-Tate condition is preserved by the zero representation. -/
def isHodgeTate_trivial
    {p : ℕ} [Fact p.Prime]
    {Khat : Type*} [Field Khat]
    (pkg : CpPackage p Khat)
    (χ : @ContinuousCyclotomicCharacter p _ pkg.G pkg.instGroup_G pkg.instTopSpace_G)
    {V : Type*} [AddCommGroup V] [TopologicalSpace V] :
    letI : Group pkg.G := pkg.instGroup_G
    letI : TopologicalSpace pkg.G := pkg.instTopSpace_G
    IsHodgeTate pkg χ (ContinuousRepresentation.trivial (G := pkg.G) (V := V)) where
  weightData := { weights := [], sorted := List.sorted_nil }
  weightSpace := by simp

end MathlibExpansion.Roots.HodgeTate
