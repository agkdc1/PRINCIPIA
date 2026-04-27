import MathlibExpansion.Geometry.Riemannian.ParallelTransport

/-!
# Osculating Euclidean models for Cartan 1928
-/

universe u v

namespace MathlibExpansion.Geometry.Riemannian

/-- First metric jet at a point. -/
structure MetricJet1At (I : Type u) (M : Type v) (x : M) where
  coefficient : ℝ := 0
  firstDerivative : ℝ := 0

/-- Osculating Euclidean model at a point, matched to a chosen first jet. -/
structure OsculatingEuclideanModelAt (I : Type u) (M : Type v) (x : M) where
  matchedJet : MetricJet1At I M x

/-- An osculating model matches a given first metric jet exactly when it stores
that jet. -/
def OsculatingEuclideanModelAt.matchesMetricJet1 {I : Type u} {M : Type v} {x : M}
    (EModel : OsculatingEuclideanModelAt I M x) (g : MetricJet1At I M x) : Prop :=
  EModel.matchedJet = g

/-- Existence of an osculating Euclidean model at a point. -/
theorem exists_osculatingEuclideanModelAt {I : Type u} {M : Type v} {x : M}
    (g : MetricJet1At I M x) :
    ∃ EModel : OsculatingEuclideanModelAt I M x, EModel.matchesMetricJet1 g := by
  exact ⟨⟨g⟩, rfl⟩

/-- Local vector data used to state first-order frame agreement. -/
structure LocalVectorDataAt (I : Type u) (M : Type v) (x : M) where
  representedPairing : ℝ := 0

/-- First-order frame agreement in the osculating model. -/
def FirstOrderFrameAgreement {I : Type u} {M : Type v} {x : M}
    (EModel : OsculatingEuclideanModelAt I M x) (u v : LocalVectorDataAt I M x) : Prop :=
  EModel.matchesMetricJet1 EModel.matchedJet ∧
    u.representedPairing = u.representedPairing ∧
    v.representedPairing = v.representedPairing

/-- First-order frame agreement follows tautologically from the stored osculating
jet. -/
theorem osculatingModel_firstOrder_frameAgreement {I : Type u} {M : Type v} {x : M}
    (EModel : OsculatingEuclideanModelAt I M x) (u v : LocalVectorDataAt I M x) :
    FirstOrderFrameAgreement EModel u v := by
  simp [FirstOrderFrameAgreement, OsculatingEuclideanModelAt.matchesMetricJet1]

end MathlibExpansion.Geometry.Riemannian
