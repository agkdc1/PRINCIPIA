import Mathlib.Algebra.Group.Hom.End
import Mathlib.Topology.Algebra.Group.Basic
import Mathlib.Algebra.Group.Action.Defs

/-!
# Continuous representations on topological abelian groups

A minimal bundled type for continuous G-representations used in R7 Hodge-Tate
theory. We use additive group endomorphisms (not R-linear maps) to avoid
semilinearity complications intrinsic to the Galois-twisted Cp action.
-/

namespace MathlibExpansion.Roots.HodgeTate

universe u v

/-- A continuous representation of a topological group `G` on a topological
abelian group `V`: each group element acts by an additive group automorphism,
and the evaluation map `G × V → V` is jointly continuous.

Using `AddMonoid.End V` (= `V →+ V` with composition) rather than bare
functions ensures the representation map is a genuine monoid homomorphism into
the endomorphism monoid of V. -/
structure ContinuousRepresentation
    (G : Type u) [Group G] [TopologicalSpace G]
    (V : Type v) [AddCommGroup V] [TopologicalSpace V] where
  /-- The homomorphism sending each g to its action on V. -/
  smul : G →* AddMonoid.End V
  /-- Joint continuity: (g, v) ↦ g · v is continuous. -/
  continuous_smul : Continuous (fun gv : G × V => smul gv.1 gv.2)

namespace ContinuousRepresentation

variable {G : Type u} [Group G] [TopologicalSpace G]
    {V : Type v} [AddCommGroup V] [TopologicalSpace V]

/-- The identity element acts as the identity map on V. -/
theorem smul_one (ρ : ContinuousRepresentation G V) (v : V) :
    ρ.smul 1 v = v := by
  have h : ρ.smul 1 = 1 := ρ.smul.map_one
  simp [h]

/-- The action is multiplicative: (gh) acts as g ∘ h. -/
theorem smul_mul (ρ : ContinuousRepresentation G V) (g h : G) (v : V) :
    ρ.smul (g * h) v = ρ.smul g (ρ.smul h v) :=
  DFunLike.congr_fun (ρ.smul.map_mul g h) v

/-- Each group element acts additively. -/
theorem smul_add (ρ : ContinuousRepresentation G V) (g : G) (u w : V) :
    ρ.smul g (u + w) = ρ.smul g u + ρ.smul g w :=
  (ρ.smul g).map_add u w

/-- Each group element maps zero to zero. -/
theorem smul_zero (ρ : ContinuousRepresentation G V) (g : G) :
    ρ.smul g 0 = 0 :=
  (ρ.smul g).map_zero

/-- Each group element maps negation to negation. -/
theorem smul_neg (ρ : ContinuousRepresentation G V) (g : G) (v : V) :
    ρ.smul g (-v) = -(ρ.smul g v) :=
  (ρ.smul g).map_neg v

/-- nsmul is preserved by the action. -/
theorem smul_nsmul (ρ : ContinuousRepresentation G V) (g : G) (n : ℕ) (v : V) :
    ρ.smul g (n • v) = n • ρ.smul g v :=
  (ρ.smul g).map_nsmul v n

/-- The trivial representation: every g acts as the identity. -/
def trivial : ContinuousRepresentation G V where
  smul := 1
  continuous_smul := by
    simp only [MonoidHom.one_apply]
    exact continuous_snd

end ContinuousRepresentation

end MathlibExpansion.Roots.HodgeTate
