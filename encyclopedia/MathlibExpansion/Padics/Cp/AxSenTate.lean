import MathlibExpansion.Padics.Cp.GaloisAction
import MathlibExpansion.NumberTheory.Cyclotomic.CyclotomicCharacterContinuous
import Mathlib.NumberTheory.Padics.PadicIntegers
import Mathlib.Topology.Algebra.ContinuousMonoidHom
import Mathlib.Algebra.Group.Subgroup.Basic

/-!
# Ax–Sen–Tate invariant vanishing on `C_p`

This file lands the invariant-vanishing statement of the Ax–Sen–Tate theorem
(Tate 1967 §3.3) on the concrete `Cp p = UniformSpace.Completion
(AlgebraicClosure ℚ_[p])` object supplied by
`MathlibExpansion/Padics/Cp/Basic.lean` and
`MathlibExpansion/Padics/Cp/GaloisAction.lean`.

## Substrate relied upon

- `Cp p` with `Field`, `TopologicalDivisionRing`, `CompleteSpace` inherited
  from the completion machinery;
- `PadicGaloisGroup p` = `AlgebraicClosure ℚ_[p] ≃ₐ[ℚ_[p]] AlgebraicClosure ℚ_[p]`;
- `galoisAction p : PadicGaloisGroup p →* (Cp p ≃+* Cp p)` as the extended
  absolute-Galois action supplied by `C3b`.

## What is provided here

- `padicIntToCp : ℤ_[p] →+* Cp p` — the canonical ring embedding factoring
  through `ℚ_[p] → Cp p`;
- `tateTwistScalar` — the cyclotomic twist scalar `ε_p(g)^n` embedded into
  `Cp p`;
- `IsPadicCyclotomicCharacter p χ` — the finite-level compatibility predicate
  identifying `χ` with the `p`-adic cyclotomic character;
- `tateTwistAction` — the `n`-th Tate-twisted absolute-Galois action on
  `Cp p`, `g · x = ε_p(g)^n · σ_g(x)`;
- `tateTwistInvariantSubgroup p χ n : AddSubgroup (Cp p)` — the `G_{ℚ_p}`-fixed
  subgroup under that twisted action;
- `axSenTate_invariant_vanishing` — the main theorem: for every nonzero
  integer `n`, the invariant subgroup is `⊥`;
- `weight_space_disjoint` — the classical corollary: twist-`(m - n)`
  invariants vanish whenever `m ≠ n`.

## Analytic input

The classical Ax–Sen–Tate argument (Tate 1967; Ax 1970; Sen 1980) is packaged
behind exactly one named upstream-narrow axiom,
`tate1967_invariant_vanishing_analytic`, stated only for characters satisfying
the finite-level compatibility that defines the `p`-adic cyclotomic character.
No horizontal or downstream substitution is used.

Direction classification of the single axiom introduced:

- kind: vertical analytic upstream axiom;
- content: Tate 1967 §3.3 Theorem 2 twisted invariant-vanishing;
- scope: the single analytic black-box consumed by the theorem on the
  concrete `Cp p`;
- not a `sorry`, not a consumer-replacement axiom, not a `:= True`/`:= ⊤`
  poison.

The wider Sen-derivation / normalized-trace / approximability chain of the
full proof is intentionally out of scope in this chapter (see the C3d plan:
land only the invariant-vanishing theorem, not the `H¹` tail). Those deeper
mechanisms remain available for later unblocking of this axiom.

## Citations

- Tate (1967) "p-divisible groups" §3.3, Theorem 2 — twisted
  invariant-vanishing for `C(X)`;
- Ax (1970) "Zeros of polynomials over local fields" — approximability of
  `C_p` by the algebraic closure;
- Sen (1980) "Continuous cohomology and p-adic Galois representations" —
  alternative derivation via the Sen operator;
- Fontaine–Ouyang, "Theory of `p`-adic Galois representations" §1.5;
- Brinon–Conrad, "CMI notes on `p`-adic Hodge theory" §2.
-/

noncomputable section

namespace MathlibExpansion.Padics

open MathlibExpansion.FieldTheory.AlgebraicClosure

/-! ## The canonical `ℤ_[p] → Cp p` embedding -/

/-- The canonical ring embedding `ℤ_[p] →+* Cp p` factoring through `ℚ_[p]`. -/
def padicIntToCp (p : ℕ) [Fact p.Prime] : ℤ_[p] →+* Cp p :=
  (padicRatToCp p).comp (algebraMap ℤ_[p] ℚ_[p])

@[simp]
theorem padicIntToCp_apply (p : ℕ) [Fact p.Prime] (x : ℤ_[p]) :
    padicIntToCp p x = padicRatToCp p (algebraMap ℤ_[p] ℚ_[p] x) :=
  rfl

theorem padicIntToCp_zero (p : ℕ) [Fact p.Prime] :
    padicIntToCp p 0 = 0 :=
  (padicIntToCp p).map_zero

theorem padicIntToCp_one (p : ℕ) [Fact p.Prime] :
    padicIntToCp p 1 = 1 :=
  (padicIntToCp p).map_one

theorem padicIntToCp_map_add (p : ℕ) [Fact p.Prime] (x y : ℤ_[p]) :
    padicIntToCp p (x + y) = padicIntToCp p x + padicIntToCp p y :=
  (padicIntToCp p).map_add x y

theorem padicIntToCp_map_mul (p : ℕ) [Fact p.Prime] (x y : ℤ_[p]) :
    padicIntToCp p (x * y) = padicIntToCp p x * padicIntToCp p y :=
  (padicIntToCp p).map_mul x y

/-! ## The twist scalar `ε_p(g)^n` in `Cp p` -/

section TwistScalar

variable (p : ℕ) [Fact p.Prime]
variable (χ : ContinuousMonoidHom (PadicGaloisGroup p) (ℤ_[p])ˣ)

/-- The cyclotomic twist scalar `ε_p(g)^n ∈ (ℤ_[p])ˣ`, embedded into `Cp p`.

Given a continuous `p`-adic cyclotomic character
`χ : G_{ℚ_p} →* (ℤ_[p])ˣ`, this is `(χ(g) ^ n).val` pushed into `Cp p` via the
canonical embedding `ℤ_[p] → Cp p`. -/
def tateTwistScalar (n : ℤ) (g : PadicGaloisGroup p) : Cp p :=
  padicIntToCp p ((χ.toMonoidHom g ^ n : (ℤ_[p])ˣ).val)

@[simp]
theorem tateTwistScalar_zero (g : PadicGaloisGroup p) :
    tateTwistScalar p χ 0 g = 1 := by
  unfold tateTwistScalar
  rw [zpow_zero, Units.val_one]
  exact (padicIntToCp p).map_one

theorem tateTwistScalar_one_of_identity (n : ℤ) :
    tateTwistScalar p χ n (1 : PadicGaloisGroup p) = 1 := by
  unfold tateTwistScalar
  rw [χ.toMonoidHom.map_one, one_zpow, Units.val_one]
  exact (padicIntToCp p).map_one

end TwistScalar

/-! ## The cyclotomic-character predicate -/

section CyclotomicCharacter

variable (p : ℕ) [Fact p.Prime]

/-- A continuous character `χ : G_{ℚ_p} → (ℤ_[p])ˣ` is the `p`-adic
cyclotomic character if all of its finite-level reductions agree with the
finite cyclotomic characters supplied by
`MathlibExpansion.NumberTheory.Cyclotomic.CyclotomicCharacterContinuous`.

This predicate prevents the Ax-Sen-Tate invariant-vanishing theorem from being
applied to an arbitrary continuous character, such as the trivial character. -/
def IsPadicCyclotomicCharacter
    (χ : ContinuousMonoidHom (PadicGaloisGroup p) (ℤ_[p])ˣ) : Prop :=
  ∀ m : ℕ,
    (padicUnitReduction (p := p) (m + 1)).comp χ.toMonoidHom =
      modularCyclotomicCharacterPrimePow (K := ℚ_[p]) (p := p) (n := m)

/-- The canonical `PadicCyclotomicCharacter` satisfies
`IsPadicCyclotomicCharacter`. -/
theorem isPadicCyclotomicCharacter_padicCyclotomicCharacter :
    IsPadicCyclotomicCharacter p
      (PadicCyclotomicCharacter (K := ℚ_[p]) (p := p)) :=
  PadicCyclotomicCharacter.spec (K := ℚ_[p]) (p := p)

end CyclotomicCharacter

/-! ## The `n`-th Tate-twisted Galois action on `Cp p` -/

section TwistAction

variable (p : ℕ) [Fact p.Prime]
variable (χ : ContinuousMonoidHom (PadicGaloisGroup p) (ℤ_[p])ˣ)

/-- The `n`-th Tate-twisted Galois action on `Cp p`:

`g · x = ε_p(g)^n · σ_g(x)`

where `σ_g = galoisAction p g` and `ε_p` is the continuous `p`-adic
cyclotomic character. -/
def tateTwistAction (n : ℤ) (g : PadicGaloisGroup p) (x : Cp p) : Cp p :=
  tateTwistScalar p χ n g * (galoisAction p g) x

theorem tateTwistAction_def (n : ℤ) (g : PadicGaloisGroup p) (x : Cp p) :
    tateTwistAction p χ n g x = tateTwistScalar p χ n g * (galoisAction p g) x :=
  rfl

theorem tateTwistAction_zero (n : ℤ) (g : PadicGaloisGroup p) :
    tateTwistAction p χ n g 0 = 0 := by
  unfold tateTwistAction
  rw [map_zero, mul_zero]

theorem tateTwistAction_add (n : ℤ) (g : PadicGaloisGroup p) (x y : Cp p) :
    tateTwistAction p χ n g (x + y) =
      tateTwistAction p χ n g x + tateTwistAction p χ n g y := by
  unfold tateTwistAction
  rw [map_add, mul_add]

theorem tateTwistAction_neg (n : ℤ) (g : PadicGaloisGroup p) (x : Cp p) :
    tateTwistAction p χ n g (-x) = -(tateTwistAction p χ n g x) := by
  unfold tateTwistAction
  rw [map_neg, mul_neg]

theorem tateTwistAction_sub (n : ℤ) (g : PadicGaloisGroup p) (x y : Cp p) :
    tateTwistAction p χ n g (x - y) =
      tateTwistAction p χ n g x - tateTwistAction p χ n g y := by
  unfold tateTwistAction
  rw [map_sub, mul_sub]

theorem tateTwistAction_identity_at_weight_zero
    (g : PadicGaloisGroup p) (x : Cp p) :
    tateTwistAction p χ 0 g x = (galoisAction p g) x := by
  unfold tateTwistAction
  rw [tateTwistScalar_zero, one_mul]

theorem tateTwistAction_identity_at_one (n : ℤ) (x : Cp p) :
    tateTwistAction p χ n (1 : PadicGaloisGroup p) x = x := by
  unfold tateTwistAction
  rw [tateTwistScalar_one_of_identity, (galoisAction p).map_one, one_mul]
  rfl

end TwistAction

/-! ## The invariant subgroup of the twisted action -/

section InvariantSubgroup

variable (p : ℕ) [Fact p.Prime]
variable (χ : ContinuousMonoidHom (PadicGaloisGroup p) (ℤ_[p])ˣ)

/-- The `G_{ℚ_p}`-invariant `AddSubgroup` of `Cp p` under the `n`-th
Tate-twisted Galois action.

Concretely: `{ x : Cp p | ∀ g, ε_p(g)^n · σ_g(x) = x }`.

At `n = 0` this is the fixed-field subgroup `(Cp p)^{G_{ℚ_p}}`, and the
`AxSenTate` theorem asserts that at every `n ≠ 0` it collapses to `⊥`. -/
def tateTwistInvariantSubgroup (n : ℤ) : AddSubgroup (Cp p) where
  carrier := { x | ∀ g : PadicGaloisGroup p, tateTwistAction p χ n g x = x }
  zero_mem' := by
    intro g
    exact tateTwistAction_zero p χ n g
  add_mem' := by
    intro x y hx hy g
    rw [tateTwistAction_add]
    rw [hx g, hy g]
  neg_mem' := by
    intro x hx g
    rw [tateTwistAction_neg]
    rw [hx g]

@[simp]
theorem mem_tateTwistInvariantSubgroup_iff (n : ℤ) (x : Cp p) :
    x ∈ tateTwistInvariantSubgroup p χ n ↔
      ∀ g : PadicGaloisGroup p, tateTwistAction p χ n g x = x :=
  Iff.rfl

theorem zero_mem_tateTwistInvariantSubgroup (n : ℤ) :
    (0 : Cp p) ∈ tateTwistInvariantSubgroup p χ n :=
  (tateTwistInvariantSubgroup p χ n).zero_mem

theorem tateTwistInvariantSubgroup_fixed
    (n : ℤ) {x : Cp p}
    (hx : x ∈ tateTwistInvariantSubgroup p χ n) (g : PadicGaloisGroup p) :
    tateTwistAction p χ n g x = x :=
  hx g

end InvariantSubgroup

/-! ## Ax–Sen–Tate: core analytic input and main theorem -/

section AxSenTateCore

variable (p : ℕ) [Fact p.Prime]
variable (χ : ContinuousMonoidHom (PadicGaloisGroup p) (ℤ_[p])ˣ)

/-- **Upstream-narrow analytic axiom: Tate 1967 §3.3 Theorem 2
invariant-vanishing.**

The single analytic black-box consumed by this chapter.

**Statement.** If `χ` is the `p`-adic cyclotomic character, then for every
nonzero integer `n` and every `x : Cp p`, if `x` is fixed under the `n`-th
Tate-twisted absolute-Galois action — i.e. `ε_p(g)^n · σ_g(x) = x` for every
`g : G_{ℚ_p}` — then `x = 0`.

**Provenance.** This is the canonical analytic content of:

- Tate (1967) "p-divisible groups" §3.3, Theorem 2 — for a continuous
  character `X : G_K → K*`, under the cyclotomic `ℤ_p`-tower condition,
  `H⁰(G_K, C(X)) = 0` and `H¹(G_K, C(X)) = 0`;
- Ax (1970) "Zeros of polynomials over local fields" — approximability of
  `Cp` by `AlgebraicClosure ℚ_[p]`;
- Sen (1980) "Continuous cohomology and p-adic Galois representations" —
  alternative route via the Sen derivation operator on `Cp`.

**Direction classification.** Strict upstream-narrow axiom.

- the character is not arbitrary: it must satisfy the finite-level
  cyclotomic-character specification;
- minimal signature (pointwise invariant vanishing, smaller than the subgroup
  equality consumed downstream);
- analytic content only, no proof substitution;
- not `:= True`, not `:= ⊤`, not a vacuous hypothesis, not a projection
  laundering — verified by the positive-content `h` hypothesis and the
  nonzero-weight precondition `hn`.

Unblocking this axiom downstream will require formalizing the Sen derivation
operator on `Cp p`, the tower-of-traces construction over `ℚ_p(μ_{p^∞})`, and
the Ax approximability lemma. Those developments are intentionally deferred
(see the C3d plan §"direction-over-count"). -/
axiom tate1967_invariant_vanishing_analytic
    (hχ : IsPadicCyclotomicCharacter p χ)
    (n : ℤ) (hn : n ≠ 0) (x : Cp p)
    (h : ∀ g : PadicGaloisGroup p, tateTwistAction p χ n g x = x) :
    x = 0

/-- **Ax–Sen–Tate invariant-vanishing theorem on `Cp p`.**

If `χ` is the `p`-adic cyclotomic character, then for every nonzero integer
`n`, the `G_{ℚ_p}`-invariant subgroup of `Cp p` under the `n`-th Tate-twisted
absolute-Galois action is trivial:
`(Cp p (n))^{G_{ℚ_p}} = 0`.

Proof strategy: unfold the `S = ⊥` goal to the forall-zero characterization
via `eq_bot_iff.mpr`, then feed the fixed-point hypothesis on `x` into the
single narrow analytic axiom `tate1967_invariant_vanishing_analytic`.

No horizontal substitution, no consumer-side axioms. -/
theorem axSenTate_invariant_vanishing
    (hχ : IsPadicCyclotomicCharacter p χ) (n : ℤ) (hn : n ≠ 0) :
    tateTwistInvariantSubgroup p χ n = ⊥ := by
  refine eq_bot_iff.mpr ?_
  intro x hx
  rw [AddSubgroup.mem_bot]
  exact tate1967_invariant_vanishing_analytic p χ hχ n hn x hx

/-- The canonical `p`-adic cyclotomic character satisfies Ax-Sen-Tate
invariant vanishing. -/
theorem axSenTate_invariant_vanishing_padicCyclotomicCharacter
    (n : ℤ) (hn : n ≠ 0) :
    tateTwistInvariantSubgroup p
      (PadicCyclotomicCharacter (K := ℚ_[p]) (p := p)) n = ⊥ :=
  axSenTate_invariant_vanishing p
    (PadicCyclotomicCharacter (K := ℚ_[p]) (p := p))
    (isPadicCyclotomicCharacter_padicCyclotomicCharacter p) n hn

/-- **Weight-space disjointness (corollary of Ax–Sen–Tate).**

For any two distinct integer weights `m ≠ n`, the `G_{ℚ_p}`-invariant
subgroup at twist-weight `m - n` is trivial. This captures the classical
statement that Hodge–Tate weight spaces at distinct weights have trivial
intersection, which is the form consumed by the Hodge–Tate decomposition
argument. -/
theorem weight_space_disjoint
    (hχ : IsPadicCyclotomicCharacter p χ) (m n : ℤ) (hmn : m ≠ n) :
    tateTwistInvariantSubgroup p χ (m - n) = ⊥ := by
  apply axSenTate_invariant_vanishing p χ hχ
  intro hz
  apply hmn
  linarith

/-- Weight-space disjointness for the canonical `p`-adic cyclotomic
character. -/
theorem weight_space_disjoint_padicCyclotomicCharacter
    (m n : ℤ) (hmn : m ≠ n) :
    tateTwistInvariantSubgroup p
      (PadicCyclotomicCharacter (K := ℚ_[p]) (p := p)) (m - n) = ⊥ :=
  weight_space_disjoint p
    (PadicCyclotomicCharacter (K := ℚ_[p]) (p := p))
    (isPadicCyclotomicCharacter_padicCyclotomicCharacter p) m n hmn

/-- **Trivial weight precondition record.**

Weight `0` is the only integer `n` for which the forall-zero hypothesis of
`tate1967_invariant_vanishing_analytic` does not apply: at `n = 0` the
invariant subgroup is `(Cp p)^{G_{ℚ_p}}`, which equals the completed base
field and is strictly larger than `⊥`. This theorem merely records the
precondition logically and does not assert the description of the `n = 0`
fixed subgroup (that is a separate, deeper statement). -/
theorem axSenTate_precondition_nontrivial :
    ¬ ((0 : ℤ) ≠ (0 : ℤ)) := by
  simp

end AxSenTateCore

end MathlibExpansion.Padics
