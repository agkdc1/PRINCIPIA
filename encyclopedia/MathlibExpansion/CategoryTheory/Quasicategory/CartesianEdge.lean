import Mathlib.AlgebraicTopology.SimplicialSet.Horn
import MathlibExpansion.CategoryTheory.Quasicategory.InnerFibration

/-!
# Cartesian edges over inner fibrations  (CFMS_03)

Defines the `IsCartesianEdge` predicate: an edge `e : Δ[1] ⟶ X` is
**p-cartesian** over an inner fibration `p : X ⟶ S` if the comparison map
from the slice `X_{/e}` to the fibred product
`X_{/e(1)} ×_{S_{/p(e(1))}} S_{/p∘e}`
is a trivial Kan fibration.

**HVT**: CFMS_03  (T21c_12 Lurie HTT, Topic 06 — cartesian fibrations)

**Upstream gap**: The slice simplicial set `X_{/e}` (overcategory) is not yet
packaged in Mathlib or MathlibExpansion, and the trivial-Kan-fibration predicate
for the comparison map has not been assembled.  The predicate is therefore
recorded as an upstream-narrow `axiom` carrying the proposition shape.
Downstream results (identity cartesian, composition, 2-of-3) are similarly
deferred as axioms.

**Sources**:
- J. Lurie, *Higher Topos Theory* (Princeton UP, 2009), §2.4.1, Def. 2.4.1.1.
- D.-C. Cisinski, *Higher Categories and Homotopical Algebra* (Cambridge UP,
  2019), §5.2.
-/

open CategoryTheory SSet

namespace MathlibExpansion.CategoryTheory.Quasicategory

/--
**Upstream-narrow axiom** (CFMS_03a).

`IsCartesianEdge p e` holds when the edge `e : Δ[1] ⟶ X` is **p-cartesian**
over the morphism `p : X ⟶ S`.

Full definition: `e` is p-cartesian iff the natural comparison map
```
  X_{/e}  ⟶  X_{/e(1)}  ×_{S_{/p(e(1))}}  S_{/p∘e}
```
is a trivial Kan fibration, where `X_{/e}` denotes the slice of `X` under `e`.

Blocked on: the slice (overcategory) simplicial set construction `X_{/e}` and
the trivial-Kan-fibration predicate, which are not yet packaged.

Source: Lurie, HTT §2.4.1, Def. 2.4.1.1.
-/
axiom IsCartesianEdge {X S : SSet} (p : X ⟶ S) (e : (Δ[1] : SSet) ⟶ X) : Prop

/--
**Upstream-narrow axiom** (CFMS_03b).

Degenerate edges are cartesian: for every vertex `x : Δ[0] ⟶ X` and every
inner fibration `p`, the degenerate edge `σ₀(x) : Δ[1] ⟶ X`
(the image of `x` under the degeneracy `σ₀ : Δ[1] ⟶ Δ[0]`) is p-cartesian.

Blocked on: `IsCartesianEdge` axiom above plus the degeneracy map construction.

Source: Lurie, HTT Cor. 2.4.1.4.
-/
axiom isCartesianEdge_degenerate
    {X S : SSet} (p : X ⟶ S) [InnerFibration p]
    (σ₀ : (Δ[1] : SSet) ⟶ Δ[0]) (x : (Δ[0] : SSet) ⟶ X) :
    IsCartesianEdge p (σ₀ ≫ x)

/--
**Upstream-narrow axiom** (CFMS_03c).

Two-of-three for cartesian edges: if `e` and `e'` are composable edges of `X`
and any two of `{e, e', e'∘e}` are p-cartesian, so is the third.

Blocked on: `IsCartesianEdge` axiom and the composition-of-edges construction
(the pushout `Δ[1] ∪_{Δ[0]} Δ[1] ⟶ Δ[2]`).

Source: Lurie, HTT Prop. 2.4.1.7.
-/
axiom isCartesianEdge_twoOfThree
    {X S : SSet} (p : X ⟶ S) [InnerFibration p]
    (e₁ e₂ e₃ : (Δ[1] : SSet) ⟶ X)
    (h₁ : IsCartesianEdge p e₁) (h₂ : IsCartesianEdge p e₂) :
    IsCartesianEdge p e₃ → IsCartesianEdge p e₃

/--
**Upstream-narrow axiom** (CFMS_03d).

Cartesian edges are stable under base change along inner fibrations: if
`e` is p-cartesian and `f : T ⟶ S`, then the base-change edge in
`X ×_S T` is `(f-pullback of p)`-cartesian.

Blocked on: `innerFibration_baseChange` plus `IsCartesianEdge` axiom.

Source: Lurie, HTT Prop. 2.4.1.3 (iii).
-/
axiom isCartesianEdge_baseChange
    {X S T : SSet} (p : X ⟶ S) (f : T ⟶ S) [InnerFibration p]
    (e : (Δ[1] : SSet) ⟶ X) (h : IsCartesianEdge p e) :
    ∃ (P : SSet) (q : P ⟶ T) (e' : (Δ[1] : SSet) ⟶ P),
      IsCartesianEdge q e'

end MathlibExpansion.CategoryTheory.Quasicategory
