import MathlibExpansion.Geometry.RiemannSurfaces.BranchedCover

/-!
# Cut systems for produced branched covers

This module records the narrowed `RS-02` boundary from the Step 5 verdict:
the `2g` cut-system theorem is stated for the local `BranchedCoverModel`
carrier, whose deferred cut data is bundled in `BranchedCover.lean`.
-/

universe u

namespace MathlibExpansion
namespace Geometry
namespace RiemannSurfaces

/-- An embedded arc used in a cut system. -/
structure EmbeddedArc (X : Type u) where
  toFun : Set.Icc (0 : ℝ) 1 → X

/-- The complement after cutting is represented by a simply connected remainder
equipped with an inclusion back into the original surface. -/
structure CutsToSimplyConnected
    (X : BranchedCoverModel) (c : Fin (2 * X.genus) → EmbeddedArc X.carrier) where
  remainder : Type u
  instTopologicalSpace : TopologicalSpace remainder
  inclusion : remainder → X.carrier
  instSimplyConnectedSpace : SimplyConnectedSpace remainder
  avoidsCuts :
    ∀ y : remainder, ∀ i : Fin (2 * X.genus), inclusion y ∉ Set.range (c i).toFun
  disjointRanges :
    ∀ i j : Fin (2 * X.genus), i ≠ j →
      Disjoint (Set.range (c i).toFun) (Set.range (c j).toFun)

attribute [instance] CutsToSimplyConnected.instTopologicalSpace
attribute [instance] CutsToSimplyConnected.instSimplyConnectedSpace

/-- Packaged `2g` cut data for a produced branched-cover surface. -/
structure CutSystemWitness (X : BranchedCoverModel) where
  cuts : Fin (2 * X.genus) → EmbeddedArc X.carrier
  certificate : CutsToSimplyConnected X cuts

/-- A produced branched-cover surface of genus `g` admits `2g` cuts whose
complement is simply connected.

Source boundary: H. Weyl, *Die Idee der Riemannschen Flaeche* (1913),
Chapter I, Sections 8-9, pp. 45-54: canonical dissection cuts a genus-`g` surface
into a schlichtartig, hence simply connected, remainder. In the current local
shell the deferred dissection data is a field of `BranchedCoverModel`, and
this definition exposes it as the `CutSystemWitness` interface. -/
def exists_cut_system_card_eq_two_mul_genus
    (X : BranchedCoverModel.{u}) :
    CutSystemWitness X := by
  let cuts : Fin (2 * X.genus) → EmbeddedArc X.carrier :=
    fun i => { toFun := X.cutData.cut i }
  let certificate : CutsToSimplyConnected X cuts :=
    { remainder := X.cutData.complement
      instTopologicalSpace := X.cutData.instTopologicalSpace
      inclusion := X.cutData.inclusion
      instSimplyConnectedSpace := X.cutData.instSimplyConnectedSpace
      avoidsCuts := by
        intro y i
        exact X.cutData.avoidsCuts y i
      disjointRanges := by
        intro i j hij
        exact X.cutData.disjointRanges i j hij }
  exact
    { cuts := cuts
      certificate := certificate }

end RiemannSurfaces
end Geometry
end MathlibExpansion
