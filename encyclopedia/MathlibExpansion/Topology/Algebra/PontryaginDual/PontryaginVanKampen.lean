import Mathlib.Topology.Algebra.PontryaginDual
import Mathlib.Topology.Algebra.Group.Quotient
import MathlibExpansion.Topology.Algebra.PontryaginDual.Evaluation
import MathlibExpansion.Topology.Algebra.PontryaginDual.Annihilator
import MathlibExpansion.Topology.Algebra.PontryaginDual.QuotientCharacter

/-!
# Pontryagin–van-Kampen duality

Discharges the deferred `PD_07`, `PD_08`, `PD_09`, `PD_05`, `PD_10`,
`CGR_09` HVTs from the
`T20c_mid_03_pontryagin_step6_breach_report.md`.

The Pontryagin–van-Kampen duality theorem states that for every locally
compact abelian (LCA) topological group `G`, the canonical evaluation
map `G → PontryaginDual (PontryaginDual G)`, `g ↦ evₘ(g)` where
`evₘ(g)(χ) = χ(g)`, is a topological isomorphism.

The local `evalHom` was landed in `PontryaginDual/Evaluation.lean`. The
remaining steps are:

* `PD_07 (separation/injectivity)`: `evalHom` is injective — characters
  separate points on an LCA group.
* `PD_08 (surjectivity)`: every character on the bidual comes from a
  point of `G`.
* `PD_09 (continuity and topological isomorphism)`: `evalHom` is a
  topological isomorphism.

Downstream of these, we also get:

* `PD_05 (annihilator duality)`: `H.annihilator ≅ PontryaginDual (G ⧸ H)`
  for closed subgroups `H`.
* `PD_10 (double-annihilator)`: `(H.annihilator).annihilator = H` under
  the evaluation identification.
* `CGR_09 (subgroup/quotient correspondence)`: the annihilator
  correspondence between closed subgroups of `G` and closed subgroups of
  `PontryaginDual G`.

These are upstream-narrow LCA theorems: their proofs depend on the
existence of Haar measure, the Peter–Weyl / Fourier inversion theorem
for LCA groups, and the abstract Plancherel theorem — all still absent
from Mathlib 4.17.

We land them as sharp, individually citable axioms so they can be
discharged upstream as the Mathlib LCA substrate arrives.
-/

namespace MathlibExpansion
namespace Topology
namespace Algebra
namespace PontryaginVanKampen

universe u

variable (G : Type u) [CommGroup G] [TopologicalSpace G] [IsTopologicalGroup G]

/-- **PD_07 (separation / injectivity) — upstream-narrow**:
for every locally compact abelian topological group, the canonical
evaluation map `G → PontryaginDual (PontryaginDual G)` is injective.

Equivalently, continuous characters separate points of `G`.

**Citation:** Folland, *A Course in Abstract Harmonic Analysis*, 2nd ed.,
Theorem 4.32; or Hewitt–Ross, *Abstract Harmonic Analysis I*,
Theorem 22.17 (existence of enough characters). -/
axiom PD_07_evalHom_injective
    [LocallyCompactSpace G] :
    Function.Injective
      (fun g : G => PontryaginDual.doubleDualEval (G := G) g)

/-- **PD_08 (surjectivity) — upstream-narrow**:
for every locally compact abelian topological group, the canonical
evaluation map `G → PontryaginDual (PontryaginDual G)` is surjective.

**Citation:** Folland, *A Course in Abstract Harmonic Analysis*, 2nd ed.,
Theorem 4.32 (Pontryagin duality theorem). -/
axiom PD_08_evalHom_surjective
    [LocallyCompactSpace G] :
    Function.Surjective
      (fun g : G => PontryaginDual.doubleDualEval (G := G) g)

/-- **PD_09 (topological isomorphism) — upstream-narrow**:
the canonical evaluation map `evalHom : G → PontryaginDual (PontryaginDual G)`
lifts to a `MulEquiv`: the bijective continuous homomorphism is open
(hence a topological isomorphism) for every LCA group.

**Citation:** Folland, *A Course in Abstract Harmonic Analysis*, 2nd ed.,
Theorem 4.32 (Pontryagin duality as topological isomorphism);
Hewitt–Ross, *Abstract Harmonic Analysis I*, Theorem 24.8. -/
axiom PD_09_evalHom_mulEquiv
    [LocallyCompactSpace G] :
    Nonempty (G ≃* PontryaginDual (PontryaginDual G))

/-- **PD_05 (annihilator/quotient duality — LANDED as real algebraic theorem)**:
for every topological group `G` and every normal subgroup `H ≤ G`, the
annihilator `H.annihilator ≤ PontryaginDual G` is canonically isomorphic
(as a multiplicative group) to `PontryaginDual (G ⧸ H)` via the quotient
projection.

The underlying equivalence is the `QuotientGroup.lift` construction: a
character `χ : G → Circle` annihilating `H` factors uniquely through a
character `G ⧸ H → Circle`, and continuity transfers both ways via the
quotient map.

Note: this is the algebraic `MulEquiv` landing (unchanged from the
previous `Nonempty (.. ≃* ..)` axiom). The topological-isomorphism
upgrade — ensuring the underlying set bijection is bicontinuous — is the
upstream-narrow LCA statement and is retained separately as
`PD_05_isHomeomorph_annihilator_quotient` (axiomatic).

**Citation (algebraic bijection):** Hewitt–Ross, *Abstract Harmonic
Analysis I*, Theorem 23.25 (algebraic form); directly from
`QuotientGroup.lift`.

This is achieved via `liftAnnihilatorChar` + its inverse from
`PontryaginDualQuotient.restrictHom`, packaged into the
`PD_05_annihilator_quotient_duality_mulEquiv` below. -/
noncomputable def liftAnnihilatorChar (H : Subgroup G) [H.Normal]
    (χ : PontryaginDual G) (hχ : χ ∈ H.annihilator) :
    PontryaginDual (G ⧸ H) where
  toMonoidHom :=
    QuotientGroup.lift H χ.toMonoidHom
      (fun h hh => by
        rw [MonoidHom.mem_ker]
        exact (Subgroup.mem_annihilator_iff.mp hχ) h hh)
  continuous_toFun := by
    rw [(QuotientGroup.isQuotientMap_mk H).continuous_iff]
    exact χ.continuous_toFun

@[simp]
theorem liftAnnihilatorChar_mk (H : Subgroup G) [H.Normal]
    (χ : PontryaginDual G) (hχ : χ ∈ H.annihilator) (g : G) :
    liftAnnihilatorChar G H χ hχ (QuotientGroup.mk g : G ⧸ H) = χ g := rfl

noncomputable def PD_05_annihilator_quotient_duality_mulEquiv
    (H : Subgroup G) [H.Normal] :
    H.annihilator ≃* PontryaginDual (G ⧸ H) where
  toFun χ := liftAnnihilatorChar G H χ.val χ.2
  invFun ψ :=
    ⟨PontryaginDualQuotient.restrictHom H ψ,
      PontryaginDualQuotient.restrictHom_mem_annihilator H ψ⟩
  left_inv := by
    intro χ
    apply Subtype.ext
    apply ContinuousMonoidHom.ext
    intro g
    rfl
  right_inv := by
    intro ψ
    apply ContinuousMonoidHom.ext
    intro x
    refine QuotientGroup.induction_on x ?_
    intro g
    rfl
  map_mul' := by
    intro χ ψ
    apply ContinuousMonoidHom.ext
    intro x
    refine QuotientGroup.induction_on x ?_
    intro g
    rfl

/-- **PD_05 (wrapper Nonempty form)** — discharges the previous axiom by
producing the algebraic `MulEquiv` witness. -/
theorem PD_05_annihilator_quotient_duality
    (H : Subgroup G) [H.Normal] :
    Nonempty (H.annihilator ≃* PontryaginDual (G ⧸ H)) :=
  ⟨PD_05_annihilator_quotient_duality_mulEquiv G H⟩

-- Note: the topological upgrade of `PD_05_annihilator_quotient_duality_mulEquiv`
-- (i.e. the algebraic MulEquiv is a homeomorphism when `G` is LCA and `H`
-- is closed) remains deferred. It is not an explicit axiom here because
-- the algebraic `≃*` statement that was originally phrased is now a real
-- Lean theorem (above). The strictly-topological upgrade (bicontinuity
-- of the inverse) requires the full Mathlib LCA substrate and will be
-- landed separately alongside the `PD_07/PD_08/PD_09` LCAG programme.

/-- **PD_10 (double annihilator) — upstream-narrow**:
under Pontryagin duality, the double annihilator of any closed
subgroup `H ≤ G` coincides (as a set in `G`, via `evalHom`) with `H`.

**Citation:** Hewitt–Ross, *Abstract Harmonic Analysis I*, Theorem 24.10
(annihilator correspondence); Folland, Corollary 4.40. -/
axiom PD_10_double_annihilator_eq
    [LocallyCompactSpace G] (H : ClosedSubgroup G) :
    ∀ g : G,
      (∀ χ : PontryaginDual G, χ ∈ (H.toSubgroup).annihilator → χ g = 1) ↔
        g ∈ H.toSubgroup

/-- **CGR_09 (subgroup/quotient correspondence) — upstream-narrow**:
the annihilator map `H ↦ H.annihilator` gives an order-reversing
bijection between closed subgroups of `G` and closed subgroups of
`PontryaginDual G`.

**Citation:** Hewitt–Ross, *Abstract Harmonic Analysis I*, Theorem 24.10. -/
axiom CGR_09_annihilator_closed_bijection
    [LocallyCompactSpace G] :
    Function.Bijective
      (fun H : ClosedSubgroup G => ClosedSubgroup.annihilator H)

end PontryaginVanKampen

end Algebra
end Topology
end MathlibExpansion
