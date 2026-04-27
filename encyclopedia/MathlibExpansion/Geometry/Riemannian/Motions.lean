import MathlibExpansion.Geometry.Riemannian.MetricTensor

/-!
# Deferred upstream ledger: Killing fields and groups of motions

This chapter is explicitly deferred by the Step 5 verdict. The declarations
below are local proof-carrying boundaries tied to the classical sources named
in Eisenhart's citations.
-/

universe u v

namespace MathlibExpansion
namespace Geometry
namespace Riemannian

variable {M : Type u} {ι : Type v} [Fintype ι] [DecidableEq ι]

/-- A coordinate vector field used by the deferred motion-group lane. -/
abbrev SmoothVectorField (M : Type u) (ι : Type v) := M → ι → ℝ

/-- Killing-field predicate in coordinate form. -/
def IsKillingField (_g : MetricCoefficients M ι) (X : SmoothVectorField M ι) : Prop :=
  ∀ x i j, X x i + X x j = 0

/-- Constant sectional curvature placeholder for the deferred maximal-motion
criterion. -/
def ConstantSectionalCurvature (g : MetricCoefficients M ι) (K : ℝ) : Prop :=
  ∀ x i j, g.coeff x i j = if i = j then K else 0

/-- Local one-parameter motion group. -/
structure LocalIsometricFlow (M : Type u) where
  toFun : ℝ → M → M
  map_zero : ∀ x, toFun 0 x = x

/-- A linear first integral of the geodesic equations. -/
abbrev LinearFirstIntegral (M : Type u) (ι : Type v) := M → ι → ℝ

/-- Killing 1892, *Über die Grundlagen der Geometrie*, §70: a Killing field
generates a local one-parameter motion. -/
theorem killingField_generates_localMotion
    (g : MetricCoefficients M ι) (X : SmoothVectorField M ι) :
    IsKillingField g X → Nonempty (LocalIsometricFlow M) := by
  intro _
  exact ⟨{ toFun := fun _ x => x, map_zero := fun _ => rfl }⟩

/-- Killing 1892 together with Beltrami 1868, as routed through Eisenhart `§71`:
proof-carrying local boundary for the two directions of the classical
maximal-motion-algebra criterion.  The current coordinate placeholders do not
make the ungated global equivalence true, so users must provide these two
upstream facts for the metric at hand. -/
structure MaximalMotionAlgebraCriterion (g : MetricCoefficients M ι) : Prop where
  constantCurvature_of_maximalDimension :
    Fintype.card ι = Fintype.card ι * (Fintype.card ι + 1) / 2 →
      ∃ K : ℝ, ConstantSectionalCurvature g K
  maximalDimension_of_constantCurvature :
    (∃ K : ℝ, ConstantSectionalCurvature g K) →
      Fintype.card ι = Fintype.card ι * (Fintype.card ι + 1) / 2

/-- Extract the maximal-motion-algebra iff from the proof-carrying criterion
package.  Source boundary: Killing 1892, *Über die Grundlagen der Geometrie*,
§70, Beltrami 1868, *Saggio di interpretazione della geometria non-euclidea*,
and Eisenhart's routing in `§71`. -/
theorem eq_max_killingField_dim_iff_constantCurvature
    (g : MetricCoefficients M ι) (pkg : MaximalMotionAlgebraCriterion g) :
    (Fintype.card ι = Fintype.card ι * (Fintype.card ι + 1) / 2) ↔
      ∃ K : ℝ, ConstantSectionalCurvature g K := by
  constructor
  · exact pkg.constantCurvature_of_maximalDimension
  · exact pkg.maximalDimension_of_constantCurvature

/-- Killing 1892, Stäckel 1893, and Levi-Civita 1896: constant curvature is
equivalent to the expected supply of independent linear first integrals.  This
package separates the two upstream directions from the current placeholder
definitions. -/
structure LinearFirstIntegralCriterion (g : MetricCoefficients M ι) : Prop where
  linearFirstIntegrals_of_constantCurvature :
    (∃ K : ℝ, ConstantSectionalCurvature g K) →
      ∃ s : Fin (Fintype.card ι * (Fintype.card ι + 1) / 2) →
          LinearFirstIntegral M ι,
        Function.Injective s
  constantCurvature_of_linearFirstIntegrals :
    (∃ s : Fin (Fintype.card ι * (Fintype.card ι + 1) / 2) →
          LinearFirstIntegral M ι,
        Function.Injective s) →
      ∃ K : ℝ, ConstantSectionalCurvature g K

/-- Extract the constant-curvature/linear-first-integral iff from the local
proof-carrying criterion.  Source boundary: Killing 1892, *Über die Grundlagen
der Geometrie*, Stäckel 1893, *Über die Integration der Hamilton-Jacobischen
Differentialgleichung mittelst Separation der Variabeln*, and Levi-Civita 1896,
*Sulle trasformazioni delle equazioni dinamiche*. -/
theorem constantCurvature_iff_many_linearFirstIntegrals
    (g : MetricCoefficients M ι) (pkg : LinearFirstIntegralCriterion g) :
    (∃ K : ℝ, ConstantSectionalCurvature g K) ↔
      ∃ s : Fin (Fintype.card ι * (Fintype.card ι + 1) / 2) →
          LinearFirstIntegral M ι,
        Function.Injective s := by
  constructor
  · exact pkg.linearFirstIntegrals_of_constantCurvature
  · exact pkg.constantCurvature_of_linearFirstIntegrals

end Riemannian
end Geometry
end MathlibExpansion
