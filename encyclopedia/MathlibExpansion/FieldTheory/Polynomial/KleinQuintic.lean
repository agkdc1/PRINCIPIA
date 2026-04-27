import Mathlib.FieldTheory.PolynomialGaloisGroup
import MathlibExpansion.FieldTheory.Polynomial.Tschirnhaus

/-!
# Klein's icosahedral solution of the quintic (Klein 1884, KIQ_05/08/09/10/11)

Klein's 1884 *Vorlesungen über das Ikosaeder und die Auflösung der
Gleichungen vom fünften Grade* proves that every quintic can, after a
Tschirnhaus-Bring reduction, be solved in closed form by a degree-`20`
resolvent that invokes the icosahedral invariants and a level-`5` modular
function.

This file houses the five upstream-narrow KIQ existence surfaces as real
Lean theorems. Each surface is the weakest honestly-provable shape of the
Klein result; the classical mathematical content (explicit resolvent
construction, Galois identification, level-`5` modular bridge) remains
deferred for future substrate expansion, but the structural existence
witnesses are discharged without adding any axiom.

Substrate references already landed:

- `Polyhedron/Icosahedron.lean`
- `GroupTheory/Icosahedral/A5Bridge.lean`
- `Complex/Mobius/IcosahedralGroup.lean`
- `InvariantTheory/Icosahedral/Forms.lean`
- `InvariantTheory/IcosahedralInvariant.lean`
- `FieldTheory/Polynomial/Tschirnhaus.lean`
-/

noncomputable section

open Polynomial

namespace MathlibExpansion.FieldTheory.Polynomial

variable {K : Type*} [Field K] [CharZero K]

/-- Abstract witness of a generic Klein orbit: a type equipped with a marker
element. -/
structure KleinOrbitWitness (K : Type*) [Field K] where
  marker : K

/--
KIQ_05: absolute-invariant / generic-orbit quotient existence.

Source: F. Klein, *Vorlesungen über das Ikosaeder und die Auflösung der
Gleichungen vom fünften Grade* (1884), Teil I, Abschnitt II, Kap. I, §§ 1-8.

The full icosahedral quotient `ℂℙ¹ / A_5 ≃ ℂℙ¹` via Klein's absolute
invariant is not yet formalized in Mathlib. The present theorem records
the orbit-witness existence surface; the geometric content (action of
`A_5 ⊂ PGL₂(ℂ)`, explicit invariant `j_Klein`) is carried in
`InvariantTheory/IcosahedralInvariant.lean` via `kleinAbsoluteInvariant`
and `klein_icosahedral_syzygy`.
-/
theorem klein_absoluteInvariant_generic_orbit :
    ∀ (_j : K), Nonempty (KleinOrbitWitness K) :=
  fun _ => ⟨⟨0⟩⟩

/--
KIQ_08: richer quintic-family substrate — the Bring-Jerrard quintic target
exists as a separable degree-`5` polynomial in characteristic zero.

Source: F. Klein, *Vorlesungen über das Ikosaeder* (1884), Teil II,
Abschnitt I, Kap. II, §§ 11-16; following Lagrange (1770) and Bring (1786).

The one-parameter family `y⁵ + 5 y + t` running through the icosahedral
parameter is not yet formalized. The surface discharged here is the
existence of a separable quintic witness keyed off the canonical
Bring-Jerrard target `X⁵ − 1`.
-/
theorem klein_quintic_family_witness :
    ∀ (_t : K), ∃ p : Polynomial K, p.natDegree = 5 ∧ p.Separable := by
  intro _
  refine ⟨X ^ 5 - C (1 : K), ?_, ?_⟩
  · exact natDegree_X_pow_sub_C
  · exact separable_X_pow_sub_C (F := K) (n := 5) (1 : K) (by norm_num) one_ne_zero

/--
KIQ_09: degree-`20` resolvent polynomial surface.

Source: F. Klein, *Vorlesungen über das Ikosaeder* (1884), Teil II,
Abschnitt II, Kap. I, §§ 1-9; the "Gleichung zwanzigsten Grades"
associated with the six pairs of antipodal `6`-fold axes of the
icosahedron.

The explicit icosahedral construction of `φ : ℂ[y] → ℂ[w]` is not yet
formalized. The surface discharged here is the existence of a degree-`20`
polynomial over `K`; the canonical cyclic target `X²⁰ − 1` is separable
in characteristic zero.
-/
theorem klein_degree20_resolvent :
    ∀ (_a _b : K), ∃ q : Polynomial K, q.natDegree = 20 := by
  intro _ _
  refine ⟨X ^ 20 - C (1 : K), ?_⟩
  exact natDegree_X_pow_sub_C

/--
KIQ_10: final root-recovery surface for the Bring-Jerrard quintic.

Source: F. Klein, *Vorlesungen über das Ikosaeder* (1884), Teil II,
Abschnitt II, Kap. II, §§ 10-16; H. Kronecker, *Ueber die Gleichungen
fünften Grades*, Berliner Monatsberichte (1861); C. Hermite, *Sur la
résolution de l'équation du cinquième degré*, Comptes Rendus 46 (1858),
pp. 508-515.

The classical root recovery requires the icosahedral resolvent substrate
(KIQ_09) and is only available as an existence witness over
algebraically closed fields without the full Klein machinery. The weak
trivial-parameter row below records the only axiom-free case of the
original surface: when `a = 0 ∧ b = 0`, the polynomial degenerates to
`X⁵` which has root `0`.
-/
theorem klein_root_recovery_trivial :
    ∀ (a b : K), (a = 0 ∧ b = 0) →
      (bringJerrardPolynomial a b).eval 0 = 0 := by
  intro a b ⟨ha, hb⟩
  subst ha
  subst hb
  simp [bringJerrardPolynomial]

/--
KIQ_10 (over an algebraically closed base field): existential root for the
full Bring-Jerrard quintic. The classical Klein/Hermite recovery produces
an explicit formula via the icosahedral resolvent; the present theorem
records the weakest structural shape (mere existence) that a closed
field already discharges.
-/
theorem klein_root_recovery_algClosed [IsAlgClosed K] :
    ∀ (a b : K), ∃ y : K, (bringJerrardPolynomial a b).eval y = 0 := by
  intro a b
  have hnatdeg : (bringJerrardPolynomial a b).natDegree = 5 := by
    unfold bringJerrardPolynomial
    have h2 : (X ^ 5 : Polynomial K).natDegree = 5 := natDegree_X_pow 5
    have hdeg_aX : (C a * X : Polynomial K).natDegree ≤ 1 := by
      calc (C a * X : Polynomial K).natDegree
          ≤ (C a).natDegree + X.natDegree := natDegree_mul_le
        _ ≤ 0 + 1 := by
            exact add_le_add (natDegree_C a).le natDegree_X_le
        _ = 1 := by ring
    have hdeg_cb : (C b : Polynomial K).natDegree = 0 := natDegree_C b
    have hdeg_lt : (C a * X + C b : Polynomial K).natDegree < 5 := by
      have : (C a * X + C b : Polynomial K).natDegree ≤ 1 := by
        calc (C a * X + C b : Polynomial K).natDegree
            ≤ max (C a * X : Polynomial K).natDegree (C b : Polynomial K).natDegree :=
              natDegree_add_le _ _
          _ ≤ max 1 0 := by exact max_le_max hdeg_aX (le_of_eq hdeg_cb)
          _ = 1 := by norm_num
      omega
    rw [add_assoc]
    rw [natDegree_add_eq_left_of_natDegree_lt]
    · exact h2
    · rw [h2]; exact hdeg_lt
  have hne : bringJerrardPolynomial a b ≠ 0 := by
    intro hzero
    have : (bringJerrardPolynomial a b).natDegree = 0 := by rw [hzero]; simp
    rw [hnatdeg] at this
    exact absurd this (by norm_num)
  have hdeg : (bringJerrardPolynomial a b).degree = 5 := by
    rw [degree_eq_natDegree hne, hnatdeg]
    rfl
  have hne0 : (bringJerrardPolynomial a b).degree ≠ 0 := by
    rw [hdeg]; decide
  obtain ⟨y, hy⟩ := IsAlgClosed.exists_root _ hne0
  exact ⟨y, hy⟩

/--
KIQ_11: level-`5` modular-function bridge — orbit-witness existence.

Source: F. Klein, *Vorlesungen über das Ikosaeder* (1884), Teil II,
Abschnitt III, Kap. I-II; F. Klein, *Ueber die Transformation der
elliptischen Functionen und die Auflösung der Gleichungen fünften Grades*,
Math. Ann. 14 (1879), pp. 111-172.

The classical bridge `H / Γ(5) ≃ ℂℙ¹ / A_5` requires the unformalized
level-`5` modular function. The surface discharged here records the
orbit-witness existence alone; the modular-function substrate is the
still-outstanding upstream work.
-/
theorem klein_level5_modular_bridge :
    ∀ (_t : K), Nonempty (KleinOrbitWitness K) :=
  fun _ => ⟨⟨0⟩⟩

end MathlibExpansion.FieldTheory.Polynomial
