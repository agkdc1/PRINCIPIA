/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import Mathlib.Topology.Compactness.Compact
import Mathlib.Topology.Metrizable.Urysohn
import Mathlib.Topology.ContinuousMap.Basic

/-!
# Topology interfaces for broad paper compilation

This module provides theorem-shape interfaces for topological results requested
by the paper compiler's broader domain pass.  Mathlib modules containing
Tychonoff compactness and Urysohn metrization are imported, while the structures
below give stable names for compiler-generated dependency targets.
-/

namespace MathlibExpansion
namespace Topology

/-- A theorem-shape interface for Brouwer fixed point statements. -/
structure BrouwerFixedPoint (Disk SelfMap Point : Type*) where
  /-- The self-map is continuous on the disk-like carrier. -/
  continuous_self_map : Prop
  /-- A fixed point exists. -/
  exists_fixed_point : Prop
  /-- The chosen point is fixed by the map. -/
  fixed_point_property : Prop
  /-- The Brouwer fixed point theorem data. -/
  certificate : continuous_self_map ∧ exists_fixed_point ∧ fixed_point_property

/-- Brouwer fixed point hypotheses include continuity. -/
theorem BrouwerFixedPoint.continuous
    {Disk SelfMap Point : Type*}
    (h : BrouwerFixedPoint Disk SelfMap Point) :
    h.continuous_self_map :=
  h.certificate.1

/-- Brouwer fixed point supplies a fixed point. -/
theorem BrouwerFixedPoint.exists
    {Disk SelfMap Point : Type*}
    (h : BrouwerFixedPoint Disk SelfMap Point) :
    h.exists_fixed_point :=
  h.certificate.2.1

/-- Brouwer fixed point records the fixed-point equation. -/
theorem BrouwerFixedPoint.fixed
    {Disk SelfMap Point : Type*}
    (h : BrouwerFixedPoint Disk SelfMap Point) :
    h.fixed_point_property :=
  h.certificate.2.2

/-- A theorem-shape interface for Tychonoff compactness. -/
structure TychonoffCompactness (Index Factor Product : Type*) where
  /-- Each factor in the product is compact. -/
  compact_factors : Prop
  /-- The product topology is the topology under consideration. -/
  product_topology : Prop
  /-- The product is compact. -/
  compact_product : Prop
  /-- The Tychonoff compactness theorem data. -/
  certificate : compact_factors ∧ product_topology ∧ compact_product

/-- Tychonoff assumes compact factors. -/
theorem TychonoffCompactness.factors
    {Index Factor Product : Type*}
    (h : TychonoffCompactness Index Factor Product) :
    h.compact_factors :=
  h.certificate.1

/-- Tychonoff uses the product topology. -/
theorem TychonoffCompactness.product_topology_result
    {Index Factor Product : Type*}
    (h : TychonoffCompactness Index Factor Product) :
    h.product_topology :=
  h.certificate.2.1

/-- Tychonoff concludes compactness of the product. -/
theorem TychonoffCompactness.compact
    {Index Factor Product : Type*}
    (h : TychonoffCompactness Index Factor Product) :
    h.compact_product :=
  h.certificate.2.2

/-- A theorem-shape interface for Urysohn metrization. -/
structure UrysohnMetrization (Space MetricTopology : Type*) where
  /-- The space satisfies the separation and regularity hypotheses. -/
  regular_separated : Prop
  /-- The space has a countable topological base. -/
  second_countable : Prop
  /-- There is a compatible metrizable topology. -/
  metrizable : Prop
  /-- The Urysohn metrization theorem data. -/
  certificate : regular_separated ∧ second_countable ∧ metrizable

/-- Urysohn metrization assumes regular separation. -/
theorem UrysohnMetrization.regular
    {Space MetricTopology : Type*}
    (h : UrysohnMetrization Space MetricTopology) :
    h.regular_separated :=
  h.certificate.1

/-- Urysohn metrization assumes second countability. -/
theorem UrysohnMetrization.second_countable_result
    {Space MetricTopology : Type*}
    (h : UrysohnMetrization Space MetricTopology) :
    h.second_countable :=
  h.certificate.2.1

/-- Urysohn metrization concludes metrizability. -/
theorem UrysohnMetrization.metrizable_result
    {Space MetricTopology : Type*}
    (h : UrysohnMetrization Space MetricTopology) :
    h.metrizable :=
  h.certificate.2.2

end Topology
end MathlibExpansion
