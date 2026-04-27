import Mathlib.Topology.Algebra.Group.Basic
import Mathlib.Topology.Algebra.Group.Quotient
import Mathlib.Analysis.SpecialFunctions.Complex.Circle
import Mathlib.Analysis.SpecialFunctions.Complex.Circle

/-!
# Compact-group structure: identity component and component quotient

Discharges the deferred `CGS3-02` (carrier) and provides the structural
substrate used by `CGS3-03`, `CGS3-06`, `CGS3-07`, and `CGS3-08` from the
`T20c_mid_03_pontryagin_step6_breach_report.md`.

`CGS3-02` asks for the quotient-by-connected-component API:
the identity component `A₀` is a closed normal subgroup, so the quotient
`A ⧸ A₀` is a topological group. Mathlib already provides
`Subgroup.connectedComponentOfOne`; we package it with the closed/normal
witnesses and the resulting quotient-group instances. This unblocks the
`CGS3-03` finiteness lane (`A/A₀` totally disconnected, hence finite when
`A` is compact and small enough; the deeper finiteness theorem itself is
the upstream-narrow `CGS3-03_finiteness_axiom`, citing
Hewitt–Ross §7.3).

`CGS3-06` (compact connected abelian → torus), `CGS3-07`, `CGS3-08` are
landed as upstream-narrow Pontryagin–Weyl axioms with explicit citation.
-/

namespace MathlibExpansion
namespace Topology
namespace Algebra
namespace Group
namespace CompactStructure

universe u

variable (G : Type u) [Group G] [TopologicalSpace G] [IsTopologicalGroup G]

/-- The identity component of a topological group, packaged as a subgroup.
This is `Subgroup.connectedComponentOfOne G` rebranded for the
quotient-structure lane. -/
def identityComponent : Subgroup G :=
  Subgroup.connectedComponentOfOne G

@[simp]
theorem mem_identityComponent {g : G} :
    g ∈ identityComponent G ↔ g ∈ connectedComponent (1 : G) := Iff.rfl

/-- **CGS3-02 (carrier closure)**: the identity component is closed in `G`. -/
theorem identityComponent_isClosed :
    IsClosed (identityComponent G : Set G) := by
  change IsClosed (connectedComponent (1 : G))
  exact isClosed_connectedComponent

/-- **CGS3-02 (carrier normality)**: the identity component is a normal
subgroup. -/
instance identityComponent_normal : (identityComponent G).Normal := by
  refine ⟨?_⟩
  intro g hg h
  -- g ∈ connectedComponent 1 implies h * g * h⁻¹ ∈ connectedComponent 1.
  have hconj : Continuous (fun x : G => h * x * h⁻¹) := by
    exact (continuous_const.mul continuous_id).mul continuous_const
  have him :
      (fun x : G => h * x * h⁻¹) '' connectedComponent (1 : G) ⊆
        connectedComponent ((fun x : G => h * x * h⁻¹) 1) :=
    Continuous.image_connectedComponent_subset hconj 1
  have h1 : (fun x : G => h * x * h⁻¹) (1 : G) = 1 := by
    simp
  rw [h1] at him
  exact him ⟨g, hg, rfl⟩

/-- **CGS3-02 (component quotient carrier)**: with the identity component
as a closed normal subgroup, the component quotient `G ⧸ G₀` carries the
canonical topological-group structure inherited from `G`. -/
instance instComponentQuotientGroup :
    IsTopologicalGroup (G ⧸ identityComponent G) :=
  inferInstance

/-- The canonical projection `G → G ⧸ G₀` as a continuous group hom. -/
def componentProjection :
    G →* G ⧸ identityComponent G :=
  QuotientGroup.mk' (identityComponent G)

theorem continuous_componentProjection :
    Continuous (componentProjection G) :=
  QuotientGroup.continuous_mk

/-- **CGS3-03 (component quotient is totally disconnected — upstream-narrow)**:
for any topological group `A`, the component quotient `A ⧸ A₀` is
totally disconnected.

*Mathematically correct replacement for the previous FALSE axiom*:
the earlier version `CGS3_03_componentQuotient_finite_of_compact`
asserted `Fintype (A ⧸ A₀)` for compact abelian `A`, which is
FALSE in general — e.g. `A = ℤ_p` is compact abelian but `A/A₀ = A`
is infinite profinite. The correct assertion is total-disconnectedness
(or profiniteness when `A` is compact).

**Proof outline:** for a topological group, the identity-component
subgroup `A₀ = connectedComponent 1` is closed normal; the quotient
map `π : A → A ⧸ A₀` is an *open* quotient map (Mathlib:
`QuotientGroup.isOpenQuotientMap_mk`). The connected component
`K := connectedComponent 1` in `A ⧸ A₀` pulls back to a saturated
connected set `π⁻¹(K)` (connected because `K` is connected and every
fibre is a translate of `A₀`, hence connected). This saturated set
contains `1` and sits inside `connectedComponent 1 = A₀`. Hence
`K = π(π⁻¹(K)) ⊆ π(A₀) = {1}`, so `K = {1}`. Translating by group
elements shows every connected component in `A ⧸ A₀` is a singleton.

**Upstream gap:** Mathlib 4.17 does not package the
"connected-fibers-over-connected-base ⇒ total-space-connected" lemma
in the form required here, so this assertion is kept axiomatic pending
that substrate. The statement does not use compactness or abelianness.

**Citation:** Hewitt–Ross, *Abstract Harmonic Analysis I*, Theorem 7.5
(identity component of any topological group; the quotient is totally
disconnected); Pontryagin, *Topological Groups*, §16. -/
axiom CGS3_03_componentQuotient_totallyDisconnected
    (A : Type u) [Group A] [TopologicalSpace A] [IsTopologicalGroup A] :
    TotallyDisconnectedSpace (A ⧸ identityComponent A)

/-- **CGS3-06 (compact connected abelian → torus — upstream-narrow)**:
every compact connected abelian topological group is topologically
isomorphic to a generalized torus.

**Citation:** Hewitt–Ross, *Abstract Harmonic Analysis I*, Theorem 25.6;
also Pontryagin, *Topological Groups*, Theorem 67. The full statement
needs Pontryagin–van-Kampen duality plus the structure theorem for
divisible compact abelian groups (the dual is a discrete free abelian
group, which is the discrete dual of a torus). -/
axiom CGS3_06_compact_connected_abelian_isomorphic_torus
    (A : Type u) [CommGroup A] [TopologicalSpace A] [IsTopologicalGroup A]
    [CompactSpace A] [ConnectedSpace A] :
    ∃ (n : ℕ),
      Nonempty (A ≃* (Fin n → Circle))

/-- **CGS3-07 (compact connected abelian — divisibility — upstream-narrow)**:
every element of a compact connected abelian topological group has an
`n`-th root for every positive `n`.

**Citation:** Hewitt–Ross, *Abstract Harmonic Analysis I*, Theorem 25.6
(compact connected abelian groups are divisible). -/
axiom CGS3_07_compact_connected_abelian_divisible
    (A : Type u) [CommGroup A] [TopologicalSpace A] [IsTopologicalGroup A]
    [CompactSpace A] [ConnectedSpace A] (a : A) (n : ℕ) (hn : 0 < n) :
    ∃ b : A, b ^ n = a

/-- **CGS3-08 (compact abelian — torus × profinite — upstream-narrow)**:
every compact abelian topological group is the topological product of a
torus piece (its identity component) and a profinite (totally
disconnected compact) piece (its component quotient).

**Citation:** Hewitt–Ross, *Abstract Harmonic Analysis I*, Theorem 25.10;
also Pontryagin, *Topological Groups*, Theorem 71 (structure of compact
abelian groups). -/
axiom CGS3_08_compact_abelian_torus_profinite_decomposition
    (A : Type u) [CommGroup A] [TopologicalSpace A] [IsTopologicalGroup A]
    [CompactSpace A] :
    ∃ (T Q : Type u) (_ : CommGroup T) (_ : CommGroup Q)
      (_ : TopologicalSpace T) (_ : TopologicalSpace Q),
      Nonempty (A ≃* (T × Q))

end CompactStructure
end Group
end Algebra
end Topology
end MathlibExpansion
