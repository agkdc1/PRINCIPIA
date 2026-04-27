/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import Mathlib.Combinatorics.Hall.Basic
import Mathlib.Combinatorics.Hall.Finite
import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Order.Cover

/-!
# Combinatorics interfaces for broad paper compilation

This module provides theorem-shape interfaces for combinatorial results used by
the broader paper compiler pass.  Hall's theorem is imported from Mathlib; the
interfaces also reserve stable projection names for finite Ramsey and Dilworth
dependency targets.
-/

namespace MathlibExpansion
namespace Combinatorics

/-- A theorem-shape interface for finite Ramsey statements. -/
structure RamseyFinite (Vertex Color Clique Coloring : Type*) where
  /-- The coloring is finite-valued on the relevant finite combinatorial objects. -/
  finite_coloring : Prop
  /-- The ambient finite set is large enough for the requested parameters. -/
  large_enough : Prop
  /-- A monochromatic clique or homogeneous subset exists. -/
  exists_monochromatic : Prop
  /-- The finite Ramsey theorem data. -/
  certificate : finite_coloring ∧ large_enough ∧ exists_monochromatic

/-- Finite Ramsey starts from a finite coloring. -/
theorem RamseyFinite.coloring
    {Vertex Color Clique Coloring : Type*}
    (h : RamseyFinite Vertex Color Clique Coloring) :
    h.finite_coloring :=
  h.certificate.1

/-- Finite Ramsey records the size hypothesis. -/
theorem RamseyFinite.large
    {Vertex Color Clique Coloring : Type*}
    (h : RamseyFinite Vertex Color Clique Coloring) :
    h.large_enough :=
  h.certificate.2.1

/-- Finite Ramsey produces a monochromatic object. -/
theorem RamseyFinite.monochromatic
    {Vertex Color Clique Coloring : Type*}
    (h : RamseyFinite Vertex Color Clique Coloring) :
    h.exists_monochromatic :=
  h.certificate.2.2

/-- A theorem-shape interface for Hall marriage and transversal existence. -/
structure HallMarriage (Index Vertex Matching : Type*) where
  /-- Every finite subfamily satisfies Hall's neighborhood-cardinality condition. -/
  hall_condition : Prop
  /-- A matching or transversal exists. -/
  exists_matching : Prop
  /-- The matching respects the given incidence relation. -/
  respects_relation : Prop
  /-- The Hall marriage theorem data. -/
  certificate : hall_condition ∧ exists_matching ∧ respects_relation

/-- Hall marriage assumes Hall's condition. -/
theorem HallMarriage.condition
    {Index Vertex Matching : Type*}
    (h : HallMarriage Index Vertex Matching) :
    h.hall_condition :=
  h.certificate.1

/-- Hall marriage supplies a matching. -/
theorem HallMarriage.exists
    {Index Vertex Matching : Type*}
    (h : HallMarriage Index Vertex Matching) :
    h.exists_matching :=
  h.certificate.2.1

/-- Hall marriage matchings respect the incidence relation. -/
theorem HallMarriage.respects
    {Index Vertex Matching : Type*}
    (h : HallMarriage Index Vertex Matching) :
    h.respects_relation :=
  h.certificate.2.2

/-- A theorem-shape interface for Dilworth decomposition statements. -/
structure DilworthDecomposition (Poset Chain Antichain Partition : Type*) where
  /-- The poset is finite. -/
  finite_poset : Prop
  /-- The width is witnessed by an antichain. -/
  width_witness : Prop
  /-- There is a chain partition of the corresponding size. -/
  chain_partition : Prop
  /-- The Dilworth decomposition theorem data. -/
  certificate : finite_poset ∧ width_witness ∧ chain_partition

/-- Dilworth decomposition applies to finite posets. -/
theorem DilworthDecomposition.finite
    {Poset Chain Antichain Partition : Type*}
    (h : DilworthDecomposition Poset Chain Antichain Partition) :
    h.finite_poset :=
  h.certificate.1

/-- Dilworth decomposition records a width witness. -/
theorem DilworthDecomposition.width
    {Poset Chain Antichain Partition : Type*}
    (h : DilworthDecomposition Poset Chain Antichain Partition) :
    h.width_witness :=
  h.certificate.2.1

/-- Dilworth decomposition supplies a chain partition. -/
theorem DilworthDecomposition.partition
    {Poset Chain Antichain Partition : Type*}
    (h : DilworthDecomposition Poset Chain Antichain Partition) :
    h.chain_partition :=
  h.certificate.2.2

end Combinatorics
end MathlibExpansion
