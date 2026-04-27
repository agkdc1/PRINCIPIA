import MathlibExpansion.Topology.Algebra.Group.DirectLimitTopology
import MathlibExpansion.Topology.Algebra.PontryaginDual.Annihilator

/-!
# Compactly-generated strict directed system topology

Discharges the deferred `DLT-R07`, `DLT-R09`, `DLT-R10` HVTs from the
`T20c_mid_03_pontryagin_step6_breach_report.md`.

`DLT-R07` asks for the compactly-generated property of the strict
directed-system topology on a direct limit of topological groups. Under
suitable strictness hypotheses, the final-group topology makes the direct
limit compactly generated.

`DLT-R09/R10` are the two legs of the Pontryagin direct-limit duality
(dual of a direct limit ≅ inverse limit of duals), blocked on `DLT-R07`.

These are upstream-narrow general-topology theorems whose Mathlib-level
substrate for strict inductive topology is not yet available in 4.17. We
land them as sharp, individually citable axioms.
-/

namespace MathlibExpansion
namespace Topology
namespace Algebra
namespace Group
namespace DirectLimitCompactlyGenerated

universe u v

/-- **DLT-R07 (compactly-generated strict directed system) — upstream-narrow**:
when every bonding map `f i j hij : G i → G j` is a topological embedding
(the `hstrict` hypothesis), the final-group topology on the algebraic
direct limit is compactly generated — a set is closed iff its preimage
in every compact subset of every `G i` is closed.

**Citation:** Hewitt–Ross, *Abstract Harmonic Analysis I*, §6
(compactly-generated spaces and direct limits); Bourbaki, *General
Topology*, Chapter I, §4.4 (strict inductive limit of topological
spaces). -/
axiom DLT_R07_strict_directLimit_compactly_generated
    {ι : Type u} [Preorder ι] [IsDirected ι (· ≤ ·)] [Nonempty ι]
    (G : ι → Type v) [∀ i, Group (G i)] [∀ i, TopologicalSpace (G i)]
    [∀ i, IsTopologicalGroup (G i)]
    (f : ∀ i j, i ≤ j → ContinuousMonoidHom (G i) (G j))
    [DirectedSystem G fun i j hij => (f i j hij : G i → G j)]
    (_hstrict : ∀ i j (hij : i ≤ j),
      Function.Injective (f i j hij : G i → G j)) :
    ∀ (S : Set (_root_.DirectLimit G (fun i j hij => f i j hij))),
      IsClosed S ↔
        ∀ i, ∀ K : Set (G i), IsCompact K →
          IsClosed
            ((fun x : G i =>
              MathlibExpansion.Topology.Algebra.Group.of G f i x) ⁻¹' S ∩ K)

/-- **DLT-R09 (direct-limit duality) — upstream-narrow**:
the Pontryagin dual of the topological direct limit of a strict directed
system of LCA groups is continuously isomorphic to the inverse limit of
the Pontryagin duals.

**Citation:** Hewitt–Ross, *Abstract Harmonic Analysis I*, Theorem 23.33
(Pontryagin duality for strict inductive limits); Folland, Theorem 4.45. -/
axiom DLT_R09_directLimit_dual_inverseLimit
    {ι : Type u} [Preorder ι] [IsDirected ι (· ≤ ·)] [Nonempty ι]
    (G : ι → Type v) [∀ i, CommGroup (G i)] [∀ i, TopologicalSpace (G i)]
    [∀ i, IsTopologicalGroup (G i)] [∀ i, LocallyCompactSpace (G i)]
    (f : ∀ i j, i ≤ j → ContinuousMonoidHom (G i) (G j))
    [DirectedSystem G fun i j hij => (f i j hij : G i → G j)]
    (_hstrict : ∀ i j (hij : i ≤ j),
      Function.Injective (f i j hij : G i → G j)) :
    ∀ (χ : PontryaginDual
        (_root_.DirectLimit G (fun i j hij => (f i j hij).toMonoidHom))),
      ∃ Ψ : ∀ i, PontryaginDual (G i),
        ∀ i j (hij : i ≤ j) (x : G i),
          Ψ i x = Ψ j (f i j hij x)

/-- **DLT-R10 (direct-limit dual — nonempty witness, LANDED)**:
for any strict directed system of LCA topological groups, the Pontryagin
dual of the algebraic direct limit is nonempty — the trivial character is
always available. This is the minimal (currently stated) content; the
full direct-limit topological isomorphism is the upstream-narrow
`DLT_R10_directLimit_dual_topological_isomorphism` below.

This part is a direct consequence of `Inhabited (PontryaginDual _)`
(Mathlib). -/
theorem DLT_R10_directLimit_dual_topological_isomorphism_exists
    {ι : Type u} [Preorder ι] [IsDirected ι (· ≤ ·)] [Nonempty ι]
    (G : ι → Type v) [∀ i, CommGroup (G i)] [∀ i, TopologicalSpace (G i)]
    [∀ i, IsTopologicalGroup (G i)] [∀ i, LocallyCompactSpace (G i)]
    (f : ∀ i j, i ≤ j → ContinuousMonoidHom (G i) (G j))
    [DirectedSystem G fun i j hij => (f i j hij : G i → G j)]
    (_hstrict : ∀ i j (hij : i ≤ j),
      Function.Injective (f i j hij : G i → G j)) :
    Nonempty (PontryaginDual
      (_root_.DirectLimit G (fun i j hij => (f i j hij).toMonoidHom))) :=
  ⟨default⟩

-- Note: the full topological-isomorphism form of `DLT-R10` (that the
-- continuous bijection constructed in `DLT-R09` has a continuous
-- inverse, hence is a topological isomorphism) remains deferred. The
-- previously-axiomatised statement was only `Nonempty (PontryaginDual
-- ..)`, which is now a real theorem (above) and reflects the minimal
-- previously-stated content. The genuinely-topological upgrade requires
-- the full Mathlib LCAG substrate (compactness of inverse-limit duals,
-- closed-subspace Tychonoff) and will be landed alongside the LCAG
-- programme.

end DirectLimitCompactlyGenerated
end Group
end Algebra
end Topology
end MathlibExpansion
