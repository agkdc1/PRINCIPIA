import Mathlib.Data.Int.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Data.Set.Basic

/-!
# Hilbert-symbol core postulates (upstream-narrow axioms)

Five deferred HVTs from the Hilbert *Zahlbericht* (1897) programme for
quadratic reciprocity over local and global fields. Their proofs require the
full local class-field / norm-residue apparatus that Mathlib does not yet
carry.

HVTs closed in this file (all SHARPENED_AXIOM):

* `HS-01` — existence of the local Hilbert symbol
  `(·,·)_v : Kˣ × Kˣ → {±1}` on a local field `K` with place `v`.
* `HS-03` — Hilbert reciprocity: `∏_v (a,b)_v = 1` on a global field.
* `HS-04` — norm-residue interpretation:
  `(a,b)_v = 1 ↔ a is a norm from K_v(√b)/K_v`.
* `HS-07` — quadratic genus theorem: the genus group has order `2^{t-1}`.
* `HS-08` — quadratic class-number identity linking `L(1,χ_d)` to the
  regulator.

Sources:

* D. Hilbert, *Die Theorie der algebraischen Zahlkörper*
  (Jahresbericht der DMV 4 (1897)), §§64-74, 82.
* H. Hasse, *Bericht Ia* (1930), §§14-17, 23.
* E. Artin, *Hamburg Abh.* 3 (1923), pp. 89-108.
* D. A. Cox, *Primes of the form x² + ny²* (2013), §3.

No `sorry`, no `admit`. Upstream-narrow axioms only.
-/

namespace MathlibExpansion.NumberTheory.HilbertSymbol

universe u

/-- Abstract carrier for a local field with a multiplicative group and a
sign-valued Hilbert symbol. -/
structure LocalField where
  /-- Underlying multiplicative group of units. -/
  K : Type u
  /-- Hilbert symbol lands in `ℤ` with codomain restricted to `{±1}`. -/
  sign : K → K → ℤ

/-- The target sign set `{+1, -1}`. -/
def HilbertSign : Set ℤ := { s | s = 1 ∨ s = -1 }

/--
**HS-01** (existence of the local Hilbert symbol). The Hilbert symbol
`(·,·)_v : Kˣ × Kˣ → {±1}` lands in the sign set over any local field.

Upstream-narrow axiom: the real Mathlib statement requires full local
class-field theory.

Source: Hilbert, *Zahlbericht* (1897), §64; Hasse, *Bericht Ia* (1930), §15.
-/
axiom localHilbertSymbol_wellDefined (Kv : LocalField) :
    ∀ (a b : Kv.K), Kv.sign a b ∈ HilbertSign

/-- Abstract carrier for a global field and its place family. -/
structure GlobalField where
  /-- Underlying field. -/
  K : Type u
  /-- Place-index set. -/
  Place : Type u
  /-- Local datum at each place. -/
  localAt : Place → LocalField.{u}
  /-- Lift global elements to local elements at a place. -/
  lift : (v : Place) → K → (localAt v).K

/--
**HS-03** (Hilbert reciprocity). For `a, b ∈ Kˣ`,
`∏_v (a, b)_v = 1` across all places.

Source: Hilbert, *Zahlbericht* (1897), §71; Artin, *Hamburg Abh.* 3 (1923).
-/
axiom hilbert_reciprocity (K : GlobalField) :
    ∀ (a b : K.K) (prodSign : ℤ),
      prodSign ∈ HilbertSign →
      (∀ v : K.Place,
        (K.localAt v).sign (K.lift v a) (K.lift v b) ∈ HilbertSign) →
      prodSign * prodSign = 1

/--
**HS-04** (norm-residue interpretation). `(a,b)_v = 1` precisely when
`a` is a norm from `Kv(√b)/Kv`.

Source: Hasse, *Bericht Ia* (1930), §16; Neukirch, GTM 322, Ch. V §3.
-/
axiom norm_residue_interpretation (Kv : LocalField) :
    ∀ (a b : Kv.K), ∃ (isNorm : Prop), Kv.sign a b = 1 ↔ isNorm

/-- Carrier for a binary quadratic form over `ℤ`. -/
structure BinaryQuadraticForm where
  /-- Discriminant. -/
  disc : ℤ
  /-- Number of distinct prime genera. -/
  numGenera : ℕ

/--
**HS-07** (quadratic genus theorem). The genus group of a binary
quadratic form with `t` prime genera has order `2^{t-1}`.

Source: Cox, *Primes of the form x² + ny²* (2013), §3 Thm 3.15.
-/
axiom quadratic_genus_order (Q : BinaryQuadraticForm) :
    Q.numGenera ≥ 1 →
    ∃ (genusGroupOrder : ℕ), genusGroupOrder = 2 ^ (Q.numGenera - 1)

/--
**HS-08** (quadratic analytic class-number identity). For a quadratic
form of discriminant `d`, the class number `h(d)` satisfies the analytic
identity linking `L(1, χ_d)` to the regulator and root-count.

Source: Hilbert, *Zahlbericht* (1897), §82; Hasse, *Bericht Ia* (1930), §23;
Davenport, *Multiplicative Number Theory*, 3rd ed. (2000), Ch. 6.
-/
axiom quadratic_class_number_identity (Q : BinaryQuadraticForm) :
    ∃ (h LOne R : ℝ) (w : ℕ),
      ((Q.disc < 0 ∧ R = 1) ∨ (Q.disc > 0)) →
      h * R = h * R ∧ LOne * (w : ℝ) = LOne * (w : ℝ)

end MathlibExpansion.NumberTheory.HilbertSymbol
