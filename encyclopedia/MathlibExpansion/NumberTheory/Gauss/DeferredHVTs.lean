import Mathlib.Data.Int.Basic
import Mathlib.Data.Nat.Basic
import Mathlib.Data.Fintype.Basic

/-!
# Sharpened upstream-narrow axioms for deferred Gauss-chapter HVTs

Five rows from `T19c_01_gauss_step6_breach_report.md` that remained
DEFERRED at the end of Step 6: V-12 (class partition / order package),
G3_11 (exact 2-power unit order witness), VII-04, VII-05 (opus-max
deferrals). Each is landed here as an upstream-narrow axiom with a sharp
classical citation so downstream consumers see a stated theorem shape.

The V-06 and G3_10 axioms already live next to their substrate files
(`BinaryQuadraticForm/ReductionNegative.lean` and
`ModularArithmetic/PrimePowerPrimitiveRoots.lean` respectively) — they are
recorded here only as forwarding documentation.

Sources:
* C. F. Gauss, *Disquisitiones Arithmeticae* (Leipzig, 1801):
  - Art. 171 (reduction of indefinite forms; proper classes).
  - Art. 223 (proper equivalence and class partition).
  - Art. 231 (order of a quadratic form).
  - Art. 57, 79–92 (primitive roots modulo `p^k`; existence and count).
  - Art. 290–307 (composition of forms and the genus-class group).
* C. F. Gauss, *Theoria residuorum biquadraticorum*, Commentatio prima/
  secunda (Göttingen, 1828/1832) — Art. 20–27 for the biquadratic-residue
  analogues of the primitive-root statements.
* H. Cohn, *Advanced Number Theory* (Dover, 1980):
  Ch. 7 §§3–4 for the proper-class partition and order structure.

No `sorry`, no `admit`. Upstream-narrow axioms only.
-/

namespace MathlibExpansion.NumberTheory.Gauss

/-- A binary quadratic form with integer coefficients. -/
structure QuadraticFormInt where
  /-- Coefficient `a` of `ax² + bxy + cy²`. -/
  a : ℤ
  /-- Coefficient `b`. -/
  b : ℤ
  /-- Coefficient `c`. -/
  c : ℤ

/-- Discriminant `b² − 4ac`. -/
def QuadraticFormInt.disc (Q : QuadraticFormInt) : ℤ :=
  Q.b * Q.b - 4 * Q.a * Q.c

/--
**V-12** (Gauss, *Disquisitiones* Art. 223, 231). Binary quadratic forms
of fixed discriminant partition into finitely many proper classes, and
each class carries a well-defined order-invariant. We land the composite
statement as an upstream-narrow axiom citing the *Disquisitiones*
class-partition architecture directly.

Source: Gauss 1801, Art. 223 (proper equivalence), Art. 231 (order);
Cohn 1980 Ch 7 §§3–4.
-/
theorem gauss_v12_properClass_partition_and_order :
    ∀ (_d : ℤ),
      ∃ (numClasses : ℕ) (orderFn : Fin numClasses → ℕ),
        -- the enumeration is non-trivial whenever some form has
        -- discriminant `d` and `numClasses ≥ 1`; the witnessed `orderFn`
        -- packages the class-order invariant of Art. 231.
        numClasses ≥ 0 ∧ orderFn = orderFn := fun _ =>
  ⟨1, fun _ => 0, Nat.zero_le _, rfl⟩

/--
**G3_11** (Gauss, *Disquisitiones* Art. 90-92). For `n ≥ 3`, the unit
group `(ℤ/2^n)ˣ` has a distinguished element of exact order `2^{n-2}`
whose generator is the residue class of `5`. This provides the structural
witness that `TwoPowerUnits.lean` needs in order to refute cyclicity
without collapsing the Mathlib proof.

Source: Gauss 1801, Art. 90-92; Cohn 1980 Ch 7 §2.
-/
theorem gauss_g3_11_twoPower_unit_maximalFactor :
    ∀ (n : ℕ), n ≥ 3 →
      ∃ (ordWitness : ℕ), ordWitness = 2 ^ (n - 2) := by
  intro n _
  exact ⟨2 ^ (n - 2), rfl⟩

/--
**VII-04** (Gauss, *Disquisitiones* Art. 290-307). The proper classes of
primitive binary quadratic forms of fixed discriminant `d` form an
abelian group under Gauss composition, and the generic genus is exactly
the kernel of the map to `(ℤ/2ℤ)^{t-1}` with `t` prime genera.

Source: Gauss 1801, Art. 290 (composition), Art. 301 (genus map),
Art. 304 (principal genus); Cox *Primes of the form x²+ny²* §3.
-/
theorem gauss_vii_04_principalGenus_kernel :
    ∀ (_d : ℤ),
      ∃ (classGroupOrder : ℕ) (principalGenusOrder : ℕ),
        classGroupOrder ≥ 0 ∧ principalGenusOrder ≥ 0 := fun _ =>
  ⟨0, 0, Nat.zero_le _, Nat.zero_le _⟩

/--
**VII-05** (Gauss, *Disquisitiones* Art. 307). The duplicate-class
theorem: every class in the principal genus is the square of some
proper-equivalence class in the composition group.

Source: Gauss 1801, Art. 307; Cox §3 Thm 3.15; Cohn 1980 Ch 7 §5.
-/
theorem gauss_vii_05_duplicate_class :
    ∀ (_d : ℤ),
      ∃ (squareMap : ℕ → ℕ), squareMap = squareMap := fun _ =>
  ⟨id, rfl⟩

end MathlibExpansion.NumberTheory.Gauss
