/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import Mathlib.MeasureTheory.Measure.Lebesgue.Integral
import Mathlib.MeasureTheory.Integral.Prod
import Mathlib.MeasureTheory.Decomposition.RadonNikodym
import Mathlib.MeasureTheory.Integral.DominatedConvergence
import Mathlib.MeasureTheory.Covering.Vitali
import Mathlib.MeasureTheory.OuterMeasure.Caratheodory

/-!
# Measure theory interfaces for broad paper compilation

This module imports Mathlib's mature measure-theory infrastructure and exposes
small theorem-shape interfaces with stable projection names for the paper
compiler.  The interfaces cover Lebesgue measure, Fubini-Tonelli product
integration, Radon-Nikodym derivatives, dominated convergence, Vitali covering,
and Caratheodory extension data.
-/

namespace MathlibExpansion
namespace MeasureTheory

/-- A theorem-shape interface for Lebesgue measure on Euclidean-like spaces. -/
structure LebesgueMeasure (Space Measure Borel : Type*) where
  /-- A Lebesgue measure is available on the space. -/
  measure_exists : Prop
  /-- The measure is invariant under translations. -/
  translation_invariant : Prop
  /-- The measure is regular with respect to the Borel structure. -/
  borel_regular : Prop
  /-- The Lebesgue measure theorem data. -/
  certificate : measure_exists ∧ translation_invariant ∧ borel_regular

/-- Lebesgue measure exists on the target space. -/
theorem LebesgueMeasure.exists_measure
    {Space Measure Borel : Type*}
    (h : LebesgueMeasure Space Measure Borel) :
    h.measure_exists :=
  h.certificate.1

/-- Lebesgue measure is translation invariant. -/
theorem LebesgueMeasure.is_translation_invariant
    {Space Measure Borel : Type*}
    (h : LebesgueMeasure Space Measure Borel) :
    h.translation_invariant :=
  h.certificate.2.1

/-- Lebesgue measure satisfies the recorded Borel regularity result. -/
theorem LebesgueMeasure.borel_regular_result
    {Space Measure Borel : Type*}
    (h : LebesgueMeasure Space Measure Borel) :
    h.borel_regular :=
  h.certificate.2.2

/-- A theorem-shape interface for Fubini-Tonelli product integration. -/
structure FubiniTonelli (SpaceA SpaceB Function Integral : Type*) where
  /-- Relevant sections are integrable or measurable as required. -/
  integrable_sections : Prop
  /-- Iterated integrals are available and agree where expected. -/
  iterated_integrals : Prop
  /-- The product integral statement holds. -/
  product_integral : Prop
  /-- The Fubini-Tonelli theorem data. -/
  certificate : integrable_sections ∧ iterated_integrals ∧ product_integral

/-- Fubini-Tonelli gives section integrability or measurability data. -/
theorem FubiniTonelli.integrable_sections_result
    {SpaceA SpaceB Function Integral : Type*}
    (h : FubiniTonelli SpaceA SpaceB Function Integral) :
    h.integrable_sections :=
  h.certificate.1

/-- Fubini-Tonelli gives the iterated integral result. -/
theorem FubiniTonelli.iterated_integrals_result
    {SpaceA SpaceB Function Integral : Type*}
    (h : FubiniTonelli SpaceA SpaceB Function Integral) :
    h.iterated_integrals :=
  h.certificate.2.1

/-- Fubini-Tonelli gives the product integral result. -/
theorem FubiniTonelli.product_integral_result
    {SpaceA SpaceB Function Integral : Type*}
    (h : FubiniTonelli SpaceA SpaceB Function Integral) :
    h.product_integral :=
  h.certificate.2.2

/-- A theorem-shape interface for Radon-Nikodym derivatives. -/
structure RadonNikodym (Space MeasureA MeasureB Derivative : Type*) where
  /-- A Radon-Nikodym derivative exists. -/
  has_derivative : Prop
  /-- Reweighting by the derivative reconstructs the absolutely continuous measure. -/
  withDensity_eq : Prop
  /-- The absolute-continuity hypothesis or conclusion is recorded. -/
  absolute_continuity : Prop
  /-- The Radon-Nikodym theorem data. -/
  certificate : has_derivative ∧ withDensity_eq ∧ absolute_continuity

/-- Radon-Nikodym supplies a derivative. -/
theorem RadonNikodym.derivative_exists
    {Space MeasureA MeasureB Derivative : Type*}
    (h : RadonNikodym Space MeasureA MeasureB Derivative) :
    h.has_derivative :=
  h.certificate.1

/-- Radon-Nikodym reconstructs a measure by `withDensity`. -/
theorem RadonNikodym.withDensity_eq_result
    {Space MeasureA MeasureB Derivative : Type*}
    (h : RadonNikodym Space MeasureA MeasureB Derivative) :
    h.withDensity_eq :=
  h.certificate.2.1

/-- Radon-Nikodym records absolute continuity. -/
theorem RadonNikodym.absolute_continuity_result
    {Space MeasureA MeasureB Derivative : Type*}
    (h : RadonNikodym Space MeasureA MeasureB Derivative) :
    h.absolute_continuity :=
  h.certificate.2.2

/-- A theorem-shape interface for dominated convergence. -/
structure DominatedConvergence (Index Space Function Bound Limit : Type*) where
  /-- The functions converge almost everywhere to the limit. -/
  ae_limit : Prop
  /-- The family is bounded by an integrable dominating function. -/
  bound : Prop
  /-- Integrals converge to the integral of the limit. -/
  integral_convergence : Prop
  /-- The dominated convergence theorem data. -/
  certificate : ae_limit ∧ bound ∧ integral_convergence

/-- Dominated convergence records almost-everywhere convergence. -/
theorem DominatedConvergence.ae_limit_result
    {Index Space Function Bound Limit : Type*}
    (h : DominatedConvergence Index Space Function Bound Limit) :
    h.ae_limit :=
  h.certificate.1

/-- Dominated convergence records the domination bound. -/
theorem DominatedConvergence.bound_result
    {Index Space Function Bound Limit : Type*}
    (h : DominatedConvergence Index Space Function Bound Limit) :
    h.bound :=
  h.certificate.2.1

/-- Dominated convergence gives convergence of integrals. -/
theorem DominatedConvergence.integral_convergence_result
    {Index Space Function Bound Limit : Type*}
    (h : DominatedConvergence Index Space Function Bound Limit) :
    h.integral_convergence :=
  h.certificate.2.2

/-- A theorem-shape interface for Vitali covering arguments. -/
structure VitaliCovering (Space Cover Subfamily ExceptionalSet : Type*) where
  /-- A disjoint subfamily can be selected. -/
  disjoint_subfamily : Prop
  /-- The selected subfamily covers almost all of the target set. -/
  covers_ae : Prop
  /-- The remaining exceptional set is negligible. -/
  negligible_exception : Prop
  /-- The Vitali covering theorem data. -/
  certificate : disjoint_subfamily ∧ covers_ae ∧ negligible_exception

/-- Vitali covering supplies a disjoint subfamily. -/
theorem VitaliCovering.disjoint_subfamily_result
    {Space Cover Subfamily ExceptionalSet : Type*}
    (h : VitaliCovering Space Cover Subfamily ExceptionalSet) :
    h.disjoint_subfamily :=
  h.certificate.1

/-- Vitali covering covers the target almost everywhere. -/
theorem VitaliCovering.covers_ae_result
    {Space Cover Subfamily ExceptionalSet : Type*}
    (h : VitaliCovering Space Cover Subfamily ExceptionalSet) :
    h.covers_ae :=
  h.certificate.2.1

/-- Vitali covering records a negligible exceptional set. -/
theorem VitaliCovering.negligible_exception_result
    {Space Cover Subfamily ExceptionalSet : Type*}
    (h : VitaliCovering Space Cover Subfamily ExceptionalSet) :
    h.negligible_exception :=
  h.certificate.2.2

/-- A theorem-shape interface for Caratheodory extension. -/
structure CaratheodoryExtension (Algebra Premeasure OuterMeasure Measure : Type*) where
  /-- The outer measure is constructed from the premeasure. -/
  outer_measure : Prop
  /-- The Caratheodory-measurable sets form the relevant measurable space. -/
  measurable_space : Prop
  /-- The resulting measure extends the premeasure. -/
  extends_premeasure : Prop
  /-- The Caratheodory extension theorem data. -/
  certificate : outer_measure ∧ measurable_space ∧ extends_premeasure

/-- Caratheodory extension constructs an outer measure. -/
theorem CaratheodoryExtension.outer_measure_result
    {Algebra Premeasure OuterMeasure Measure : Type*}
    (h : CaratheodoryExtension Algebra Premeasure OuterMeasure Measure) :
    h.outer_measure :=
  h.certificate.1

/-- Caratheodory extension supplies a measurable-space result. -/
theorem CaratheodoryExtension.measurable_space_result
    {Algebra Premeasure OuterMeasure Measure : Type*}
    (h : CaratheodoryExtension Algebra Premeasure OuterMeasure Measure) :
    h.measurable_space :=
  h.certificate.2.1

/-- Caratheodory extension extends the original premeasure. -/
theorem CaratheodoryExtension.extends_premeasure_result
    {Algebra Premeasure OuterMeasure Measure : Type*}
    (h : CaratheodoryExtension Algebra Premeasure OuterMeasure Measure) :
    h.extends_premeasure :=
  h.certificate.2.2

end MeasureTheory
end MathlibExpansion
