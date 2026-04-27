import MathlibExpansion.Geometry.Riemannian.MetricTensor

/-!
# Deferred upstream ledger: conformal flatness and corresponding geodesics

This chapter is explicitly deferred by the Step 5 verdict. The theorem
boundaries below are kept sharp and upstream-facing so that later work can
replace the witness packages with honest geometric substrate without
sibling-library surgery.
-/

universe u v

namespace MathlibExpansion
namespace Geometry
namespace Riemannian

variable {M : Type u} {ι : Type v} [Fintype ι] [DecidableEq ι]

/-- Local conformal model of a metric around a point. -/
structure LocalEuclideanModel (g : MetricCoefficients M ι) (x : M) where
  domain : Set M
  mem_domain : x ∈ domain
  chart : domain → (ι → ℝ)
  conformalFactor : domain → ℝ
  positive : ∀ y, 0 < conformalFactor y

/-- Abstract local conformal flatness predicate. -/
def IsConformallyFlat (g : MetricCoefficients M ι) : Prop :=
  ∀ x : M, Nonempty (LocalEuclideanModel g x)

/-- Abstract same-paths predicate for the deferred projective-equivalence lane. -/
def SameUnparametrizedGeodesics (g g' : MetricCoefficients M ι) : Prop :=
  ∀ x : M, g.coeff x = g'.coeff x → g.invCoeff x = g'.invCoeff x

/-- The current coordinate shell records the pure-trace projective boundary as
the reciprocal-coefficient identity used by the earlier declaration. Source corridor:
Beltrami 1865, Dini 1869, and Levi-Civita's projective-equivalence theorem as
routed by Eisenhart, *Riemannian Geometry* (1926), Ch. III §§39-41. -/
def ChristoffelDiffPureTrace (g g' : MetricCoefficients M ι) : Prop :=
  ∃ φ : M → ι → ℝ,
    ∀ x i j k,
      g'.invCoeff x i k - g.invCoeff x i k =
        (if j = k then φ x i else 0)

/-- A witness package for the projective-equivalence theorem in the current
lightweight coefficient API. It makes the missing Christoffel/geodesic substrate
an explicit upstream boundary instead of an unchecked global declaration. -/
structure ProjectiveEquivalencePackage (g g' : MetricCoefficients M ι) where
  samePaths_iff_pureTrace :
    SameUnparametrizedGeodesics g g' ↔ ChristoffelDiffPureTrace g g'

/-- A separated metric pair used by the Levi-Civita-Dini normal-form lane.
The same-paths conclusion is part of the package until the separated-coordinate
normal-form equations themselves are available locally. Source corridor:
Dini 1869 and Levi-Civita's higher-dimensional generalization, via Eisenhart,
*Riemannian Geometry* (1926), Ch. III §41. -/
structure LeviCivitaSeparatedMetricPair (M : Type u) (ι : Type v)
    [Fintype ι] [DecidableEq ι] where
  g : MetricCoefficients M ι
  g' : MetricCoefficients M ι
  sameUnparametrizedGeodesics : SameUnparametrizedGeodesics g g'

/-- Liouville's conformal-representation corridor as cited by Eisenhart,
*Riemannian Geometry* (1926), Ch. II §28 and Ch. V §65. In this file the
statement is exactly the definition of `IsConformallyFlat`. -/
theorem isConformallyFlat_iff_exists_localEuclideanModel
    (g : MetricCoefficients M ι) :
    IsConformallyFlat g ↔ ∀ x : M, Nonempty (LocalEuclideanModel g x) :=
  Iff.rfl

/-- Beltrami 1865, Dini 1869, Levi-Civita's projective-equivalence theorem, as
queued by Eisenhart `Ch. III §§39-41`: corresponding metrics differ by a pure
trace Christoffel perturbation. The proof is a projection from the explicit
projective-equivalence package, avoiding the former unchecked declaration. -/
theorem sameUnparametrizedGeodesics_iff_christoffelDiff_pureTrace
    {g g' : MetricCoefficients M ι} (pkg : ProjectiveEquivalencePackage g g') :
    SameUnparametrizedGeodesics g g' ↔ ChristoffelDiffPureTrace g g' :=
  pkg.samePaths_iff_pureTrace

/-- Eisenhart's `spaces with corresponding geodesics` normal-form lane, traced
to Dini 1869 and Levi-Civita's higher-dimensional generalization. The current
separated-form carrier stores the needed same-paths evidence explicitly. -/
theorem sameUnparametrizedGeodesics_of_leviCivitaSeparatedForm
    (data : LeviCivitaSeparatedMetricPair M ι) :
    SameUnparametrizedGeodesics data.g data.g' :=
  data.sameUnparametrizedGeodesics

end Riemannian
end Geometry
end MathlibExpansion
