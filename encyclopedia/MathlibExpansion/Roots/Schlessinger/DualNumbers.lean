import MathlibExpansion.Roots.Schlessinger.SmallExtensions

/-!
# Dual Numbers as an Artinian Local k-Algebra

`DualNumber k = k[ε]/(ε²) = TrivSqZeroExt k k` is the tangent-space
object in Art_k: the unique small extension of k by k.
-/

namespace MathlibExpansion.Roots.Schlessinger

universe u

open IsLocalRing CategoryTheory

/-- `maximalIdeal (DualNumber k) = ker (fstHom).toRingHom`.

Proof: `mem_maximalIdeal` reduces to `nonunits`, which via
`TrivSqZeroExt.isUnit_iff_isUnit_fst` plus `isUnit_iff_ne_zero` reduces to
`x.fst = 0`, and the RHS unfolds to the same via `mem_ker` and
`fstHom_apply`. -/
private lemma dualNumber_maximalIdeal_eq_ker (k : Type u) [Field k] :
    IsLocalRing.maximalIdeal (DualNumber k) =
    RingHom.ker (TrivSqZeroExt.fstHom k k k).toRingHom := by
  ext x
  simp only [IsLocalRing.mem_maximalIdeal, mem_nonunits_iff,
             RingHom.mem_ker, AlgHom.toRingHom_eq_coe, AlgHom.coe_toRingHom,
             TrivSqZeroExt.fstHom_apply, TrivSqZeroExt.isUnit_iff_isUnit_fst,
             isUnit_iff_ne_zero, ne_eq, not_not]

/-- The residue field of `DualNumber k` is canonically isomorphic to k.

Strategy: compose `quotientEquivAlgOfEq` (re-tags the ideal as
`ker(fstHom)`) with `quotientKerAlgEquivOfSurjective`. The outer return
type `ResidueField (DualNumber k)` is definitionally
`DualNumber k ⧸ maximalIdeal (DualNumber k)`, so elaboration unifies
without explicit `show`. -/
noncomputable def dualNumberResidueEquiv (k : Type u) [Field k] :
    IsLocalRing.ResidueField (DualNumber k) ≃ₐ[k] k :=
  (Ideal.quotientEquivAlgOfEq k (dualNumber_maximalIdeal_eq_ker k)).trans
    (Ideal.quotientKerAlgEquivOfSurjective
      (TrivSqZeroExt.fst_surjective (R := k) (M := k)))

/-- `DualNumber k` as an object of Art_k. -/
noncomputable def dualNumberObj (k : Type u) [Field k]
    [inst : IsArtinianRing (DualNumber k)] : ArtinLocalAlg k where
  carrier       := DualNumber k
  instCommRing  := inferInstance
  instAlgebra   := Algebra.compHom (DualNumber k) (algebraMap k k)
  instIsArtinian := inst
  instIsLocal   := inferInstance
  residueEquiv  := (dualNumberResidueEquiv k).toRingEquiv

/-- Convenience: `dualNumberObj` with `IsArtinianRing` discharged by `inferInstance`. -/
noncomputable def dualNumberObjDefault (k : Type u) [Field k]
    [IsArtinianRing (DualNumber k)] : ArtinLocalAlg k :=
  dualNumberObj k

end MathlibExpansion.Roots.Schlessinger
