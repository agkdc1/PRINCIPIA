import Mathlib.Topology.Connected.Basic
import Mathlib.Topology.MetricSpace.HausdorffDistance

namespace MathlibExpansion
namespace Topology
namespace Metric

open Set

noncomputable section

/--
Lower distance between two sets, retained under Hausdorff's textbook-facing name.

This is the point-to-set infimum distance
`inf_{x in s} Metric.infDist x t`, using Mathlib's `Metric.infDist`.
Historical source: Hausdorff, *Grundzuege der Mengenlehre* (1914), Kap. VII,
SS 6, chain/`rho`-connectedness discussion.
-/
noncomputable def lowerDist {α : Type*} [PseudoMetricSpace α] (s t : Set α) : ℝ :=
  ⨅ x : s, _root_.Metric.infDist (x : α) t

/--
Hausdorff's `rho`-connectedness carrier, formalized as finite epsilon-chain
connectedness for every `epsilon > rho`.

Historical source: Hausdorff, *Grundzuege der Mengenlehre* (1914), Kap. VII,
SS 6, definition of `rho`-connected point sets.
-/
def RhoConnected {α : Type*} [PseudoMetricSpace α] (ρ : ℝ) (s : Set α) : Prop :=
  ∀ ε > ρ, ∀ x ∈ s, ∀ y ∈ s,
    Relation.ReflTransGen (fun a b : α => a ∈ s ∧ b ∈ s ∧ dist a b < ε) x y

/-- `0`-connectedness is the `ρ = 0` specialization. -/
def ZeroConnected {α : Type*} [PseudoMetricSpace α] (s : Set α) : Prop :=
  RhoConnected 0 s

/--
Hausdorff's union theorem for `rho`-connected families whose pairwise lower
distance is bounded by `rho`.

Historical source: Hausdorff, *Grundzuege der Mengenlehre* (1914), Kap. VII,
SS 6, union theorem for `rho`-connected systems.
-/
theorem RhoConnected.sUnion
    {α : Type*} [PseudoMetricSpace α] {ρ : ℝ} {S : Set (Set α)}
    (hρ : ∀ s ∈ S, RhoConnected ρ s)
    (hoverlap : ∀ s ∈ S, ∀ t ∈ S, lowerDist s t ≤ ρ) :
    RhoConnected ρ (⋃₀ S) := by
  intro ε hρε x hx y hy
  rcases hx with ⟨s, hsS, hxs⟩
  rcases hy with ⟨t, htS, hyt⟩
  letI : Nonempty s := ⟨⟨x, hxs⟩⟩
  have htne : t.Nonempty := ⟨y, hyt⟩
  have hld_lt : lowerDist s t < ε := lt_of_le_of_lt (hoverlap s hsS t htS) hρε
  have hci : (⨅ z : s, _root_.Metric.infDist (z : α) t) < ε := by
    simpa [lowerDist] using hld_lt
  rcases exists_lt_of_ciInf_lt hci with ⟨a, haε⟩
  rcases (_root_.Metric.infDist_lt_iff htne).mp haε with ⟨b, hbt, habε⟩
  have hxs' :
      Relation.ReflTransGen
        (fun a b : α => a ∈ ⋃₀ S ∧ b ∈ ⋃₀ S ∧ dist a b < ε) x a := by
    exact (hρ s hsS ε hρε x hxs a a.property).mono
      (fun u v huv => ⟨⟨s, hsS, huv.1⟩, ⟨s, hsS, huv.2.1⟩, huv.2.2⟩)
  have hab :
      Relation.ReflTransGen
        (fun a b : α => a ∈ ⋃₀ S ∧ b ∈ ⋃₀ S ∧ dist a b < ε) a b :=
    Relation.ReflTransGen.single ⟨⟨s, hsS, a.property⟩, ⟨t, htS, hbt⟩, habε⟩
  have hby :
      Relation.ReflTransGen
        (fun a b : α => a ∈ ⋃₀ S ∧ b ∈ ⋃₀ S ∧ dist a b < ε) b y := by
    exact (hρ t htS ε hρε b hbt y hyt).mono
      (fun u v huv => ⟨⟨t, htS, huv.1⟩, ⟨t, htS, huv.2.1⟩, huv.2.2⟩)
  exact hxs'.trans (hab.trans hby)

/--
The ambient `0`-component carrier used by later compact-metric coincidence rows.

This wrapper is Mathlib's connected component for the topology induced by the
pseudometric. Historical source: Hausdorff, *Grundzuege der Mengenlehre*
(1914), Kap. VII, SS 6, `0`-components and connected components in compact
metric settings.
-/
def zeroComponent {α : Type*} [PseudoMetricSpace α] (x : α) : Set α :=
  connectedComponent x

end

end Metric
end Topology
end MathlibExpansion
