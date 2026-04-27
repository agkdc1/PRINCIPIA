/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import Mathlib.Analysis.Normed.Operator.Banach
import Mathlib.Analysis.Normed.Operator.BanachSteinhaus
import Mathlib.Analysis.InnerProductSpace.Spectrum
import Mathlib.Analysis.InnerProductSpace.LaxMilgram
import Mathlib.LinearAlgebra.Matrix.Spectrum

/-!
# Functional analysis interfaces for broad paper compilation

This module imports Mathlib's functional-analysis theorem modules and provides
stable theorem-shape interfaces for downstream generated formalizations.  The
structures reserve projection names for open mapping, closed graph,
Banach-Steinhaus, spectral theorem, and Lax-Milgram dependencies.
-/

namespace MathlibExpansion
namespace FunctionalAnalysis

/-- A theorem-shape interface for open mapping theorem consequences. -/
structure OpenMappingTheorem (Domain Codomain Operator Quotient : Type*) where
  /-- The operator is surjective under the theorem hypotheses. -/
  surjective : Prop
  /-- The operator maps open sets to open sets. -/
  open_map : Prop
  /-- The induced quotient map has the expected mapping property. -/
  quotient_map : Prop
  /-- The open mapping theorem data. -/
  certificate : surjective ∧ open_map ∧ quotient_map

/-- The open mapping interface records surjectivity. -/
theorem OpenMappingTheorem.surjective_result
    {Domain Codomain Operator Quotient : Type*}
    (h : OpenMappingTheorem Domain Codomain Operator Quotient) :
    h.surjective :=
  h.certificate.1

/-- The open mapping theorem gives openness. -/
theorem OpenMappingTheorem.open_map_result
    {Domain Codomain Operator Quotient : Type*}
    (h : OpenMappingTheorem Domain Codomain Operator Quotient) :
    h.open_map :=
  h.certificate.2.1

/-- The open mapping interface records the quotient mapping result. -/
theorem OpenMappingTheorem.quotient_map_result
    {Domain Codomain Operator Quotient : Type*}
    (h : OpenMappingTheorem Domain Codomain Operator Quotient) :
    h.quotient_map :=
  h.certificate.2.2

/-- A theorem-shape interface for the closed graph theorem. -/
structure ClosedGraphTheorem (Domain Codomain Operator Graph : Type*) where
  /-- The graph is closed. -/
  closed_graph : Prop
  /-- The operator is continuous. -/
  continuous : Prop
  /-- The operator is bounded in the normed-space setting. -/
  bounded_operator : Prop
  /-- The closed graph theorem data. -/
  certificate : closed_graph ∧ continuous ∧ bounded_operator

/-- The closed graph theorem starts from a closed graph. -/
theorem ClosedGraphTheorem.closed_graph_result
    {Domain Codomain Operator Graph : Type*}
    (h : ClosedGraphTheorem Domain Codomain Operator Graph) :
    h.closed_graph :=
  h.certificate.1

/-- The closed graph theorem gives continuity. -/
theorem ClosedGraphTheorem.continuous_result
    {Domain Codomain Operator Graph : Type*}
    (h : ClosedGraphTheorem Domain Codomain Operator Graph) :
    h.continuous :=
  h.certificate.2.1

/-- The closed graph theorem gives boundedness. -/
theorem ClosedGraphTheorem.bounded_operator_result
    {Domain Codomain Operator Graph : Type*}
    (h : ClosedGraphTheorem Domain Codomain Operator Graph) :
    h.bounded_operator :=
  h.certificate.2.2

/-- A theorem-shape interface for Banach-Steinhaus uniform boundedness. -/
structure BanachSteinhaus (Index Domain Codomain Family : Type*) where
  /-- The family is pointwise bounded. -/
  pointwise_bounded : Prop
  /-- The family is uniformly bounded on bounded sets or in operator norm. -/
  uniformly_bounded : Prop
  /-- The resulting continuity or boundedness conclusion is recorded. -/
  bounded_conclusion : Prop
  /-- The Banach-Steinhaus theorem data. -/
  certificate : pointwise_bounded ∧ uniformly_bounded ∧ bounded_conclusion

/-- Banach-Steinhaus assumes pointwise boundedness. -/
theorem BanachSteinhaus.pointwise_bounded_result
    {Index Domain Codomain Family : Type*}
    (h : BanachSteinhaus Index Domain Codomain Family) :
    h.pointwise_bounded :=
  h.certificate.1

/-- Banach-Steinhaus concludes uniform boundedness. -/
theorem BanachSteinhaus.uniformly_bounded_result
    {Index Domain Codomain Family : Type*}
    (h : BanachSteinhaus Index Domain Codomain Family) :
    h.uniformly_bounded :=
  h.certificate.2.1

/-- Banach-Steinhaus records the boundedness conclusion. -/
theorem BanachSteinhaus.bounded_conclusion_result
    {Index Domain Codomain Family : Type*}
    (h : BanachSteinhaus Index Domain Codomain Family) :
    h.bounded_conclusion :=
  h.certificate.2.2

/-- A theorem-shape interface for spectral theorem data. -/
structure SpectralTheorem (Space Operator Spectrum Decomposition : Type*) where
  /-- The operator is self-adjoint or normal under the theorem hypotheses. -/
  self_adjoint : Prop
  /-- The space decomposes into orthogonal spectral subspaces. -/
  orthogonal_decomposition : Prop
  /-- The relevant spectrum has the expected real-valued property. -/
  real_spectrum : Prop
  /-- The spectral theorem data. -/
  certificate : self_adjoint ∧ orthogonal_decomposition ∧ real_spectrum

/-- The spectral theorem interface records self-adjointness. -/
theorem SpectralTheorem.self_adjoint_result
    {Space Operator Spectrum Decomposition : Type*}
    (h : SpectralTheorem Space Operator Spectrum Decomposition) :
    h.self_adjoint :=
  h.certificate.1

/-- The spectral theorem supplies an orthogonal decomposition. -/
theorem SpectralTheorem.orthogonal_decomposition_result
    {Space Operator Spectrum Decomposition : Type*}
    (h : SpectralTheorem Space Operator Spectrum Decomposition) :
    h.orthogonal_decomposition :=
  h.certificate.2.1

/-- The spectral theorem records the real-spectrum result. -/
theorem SpectralTheorem.real_spectrum_result
    {Space Operator Spectrum Decomposition : Type*}
    (h : SpectralTheorem Space Operator Spectrum Decomposition) :
    h.real_spectrum :=
  h.certificate.2.2

/-- A theorem-shape interface for Lax-Milgram. -/
structure LaxMilgram (Space Form Functional Solution : Type*) where
  /-- The bilinear or sesquilinear form is bounded. -/
  bounded : Prop
  /-- The form is coercive. -/
  coercive : Prop
  /-- A unique solution or representing vector exists. -/
  exists_unique_solution : Prop
  /-- The Lax-Milgram theorem data. -/
  certificate : bounded ∧ coercive ∧ exists_unique_solution

/-- Lax-Milgram assumes boundedness. -/
theorem LaxMilgram.bounded_result
    {Space Form Functional Solution : Type*}
    (h : LaxMilgram Space Form Functional Solution) :
    h.bounded :=
  h.certificate.1

/-- Lax-Milgram assumes coercivity. -/
theorem LaxMilgram.coercive_result
    {Space Form Functional Solution : Type*}
    (h : LaxMilgram Space Form Functional Solution) :
    h.coercive :=
  h.certificate.2.1

/-- Lax-Milgram gives a unique solution. -/
theorem LaxMilgram.exists_unique_solution_result
    {Space Form Functional Solution : Type*}
    (h : LaxMilgram Space Form Functional Solution) :
    h.exists_unique_solution :=
  h.certificate.2.2

end FunctionalAnalysis
end MathlibExpansion
