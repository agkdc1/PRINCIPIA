import Mathlib.Algebra.CharP.ExpChar
import Mathlib.Algebra.CharP.IntermediateField
import Mathlib.FieldTheory.Perfect

/-!
# Steinitz maximal perfect subfield boundary

This chapter lands the owner surface for Steinitz `PFRPC_07`.

Mathlib v4.17 already has:
- perfect fields and Frobenius surjectivity;
- absolute perfect closures;
- relative perfect closures inside extensions.

What it does not export as a named object is Steinitz's intrinsic "greatest
perfect subfield contained in a field". Here it is defined as the supremum of
all perfect subfields, and its perfectness is proved by Frobenius-surjectivity
on the generated subfield.

Primary source:
- E. Steinitz (1910), *Algebraische Theorie der Koerper*, `Sec. 12(3)`,
  pp. 226-227.
-/

noncomputable section

open scoped Classical

namespace MathlibExpansion.FieldTheory.Perfect

variable (K : Type*) [Field K]

/-- Steinitz's maximal perfect subfield of `K`.

This is the supremum of all perfect subfields of `K`, as in Steinitz (1910),
*Algebraische Theorie der Koerper*, `Sec. 12(3)`, pp. 226-227. -/
def maximalPerfectSubfield : Subfield K :=
  ⨆ L : {L : Subfield K // PerfectField L}, L.1

private theorem maximalPerfectSubfield_eq_closure :
    maximalPerfectSubfield K =
      Subfield.closure (⋃ L : {L : Subfield K // PerfectField L}, (L.1 : Set K)) := by
  rw [maximalPerfectSubfield, Subfield.closure_iUnion]
  simp

/-- Any perfect subfield of `K` is contained in Steinitz's maximal perfect
subfield. -/
theorem le_maximalPerfectSubfield (L : Subfield K) [PerfectField L] :
    L <= maximalPerfectSubfield K := by
  exact le_iSup (fun L : {L : Subfield K // PerfectField L} => L.1) ⟨L, inferInstance⟩

/-- The Steinitz maximal perfect subfield is itself perfect. -/
theorem maximalPerfectSubfield_perfect :
    PerfectField (maximalPerfectSubfield K) := by
  let P : Subfield K := maximalPerfectSubfield K
  obtain ⟨p, hpExp⟩ := ExpChar.exists K
  haveI : ExpChar K p := hpExp
  rcases hpExp with _ | hp
  · haveI : CharZero K := inferInstance
    exact PerfectField.ofCharZero
  · haveI : Fact p.Prime := ⟨hp⟩
    haveI : ExpChar P p := Subfield.expChar P p
    haveI : PerfectRing P p := PerfectRing.ofSurjective P p (by
      intro x
      let U : Set K := ⋃ L : {L : Subfield K // PerfectField L}, (L.1 : Set K)
      have hP : P = Subfield.closure U := by
        dsimp [P, U]
        exact maximalPerfectSubfield_eq_closure K
      have hxClosure : (x : K) ∈ Subfield.closure U := by
        simpa [hP] using x.2
      have hroot : ∃ y : P, (y : K) ^ p = (x : K) := by
        refine Subfield.closure_induction (s := U)
          (p := fun z _hz => ∃ y : P, (y : K) ^ p = z) ?mem ?one ?add ?neg ?inv ?mul
          hxClosure
        · intro z hz
          rcases Set.mem_iUnion.mp hz with ⟨L, hzL⟩
          haveI : PerfectField L.1 := L.2
          haveI : ExpChar L.1 p := Subfield.expChar L.1 p
          haveI : PerfectRing L.1 p := PerfectField.toPerfectRing (K := L.1) p
          rcases (surjective_frobenius L.1 p ⟨z, hzL⟩) with ⟨w, hw⟩
          refine ⟨⟨(w : K), le_maximalPerfectSubfield (K := K) L.1 w.2⟩, ?_⟩
          exact congrArg Subtype.val hw
        · exact ⟨1, by simp⟩
        · intro x y hx hy hxroot hyroot
          rcases hxroot with ⟨a, ha⟩
          rcases hyroot with ⟨b, hb⟩
          refine ⟨a + b, ?_⟩
          calc
            ((a + b : P) : K) ^ p = (a : K) ^ p + (b : K) ^ p := by
              simpa [frobenius] using (frobenius_add (R := K) p (a : K) (b : K))
            _ = x + y := by rw [ha, hb]
        · intro x hx hxroot
          rcases hxroot with ⟨a, ha⟩
          refine ⟨-a, ?_⟩
          calc
            ((-a : P) : K) ^ p = -((a : K) ^ p) := by
              simpa [frobenius] using (frobenius_neg (R := K) p (a : K))
            _ = -x := by rw [ha]
        · intro x hx hxroot
          rcases hxroot with ⟨a, ha⟩
          refine ⟨a⁻¹, ?_⟩
          calc
            ((a⁻¹ : P) : K) ^ p = ((a : K) ^ p)⁻¹ := by
              simp [frobenius]
            _ = x⁻¹ := by rw [ha]
        · intro x y hx hy hxroot hyroot
          rcases hxroot with ⟨a, ha⟩
          rcases hyroot with ⟨b, hb⟩
          refine ⟨a * b, ?_⟩
          calc
            ((a * b : P) : K) ^ p = (a : K) ^ p * (b : K) ^ p := by
              simpa [frobenius] using (frobenius_mul (R := K) p (a : K) (b : K))
            _ = x * y := by rw [ha, hb]
      rcases hroot with ⟨y, hy⟩
      refine ⟨y, ?_⟩
      apply Subtype.ext
      simpa [frobenius] using hy)
    exact PerfectRing.toPerfectField P p

end MathlibExpansion.FieldTheory.Perfect
