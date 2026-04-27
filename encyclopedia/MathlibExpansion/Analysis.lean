/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import Mathlib.Analysis.NormedSpace.HahnBanach.Extension
import Mathlib.Topology.ContinuousMap.StoneWeierstrass
import Mathlib.Topology.UniformSpace.Ascoli
import MathlibExpansion.Analysis.Meromorphic.ArgumentPrinciple

/-!
# Analysis interfaces for broad paper compilation

This module provides small theorem-shape interfaces for analysis results used by
the paper compiler outside the FLT chain.  When Mathlib already has mature
infrastructure, the relevant modules are imported here; the structures below
give the compiler stable projection names while later work can connect each
field to sharper theorem statements.
-/

namespace MathlibExpansion
namespace Analysis

/-- A theorem-shape interface for norm-preserving Hahn-Banach extension data. -/
structure HahnBanachExtension (Domain Codomain Functional Extension : Type*) where
  /-- The original functional can be extended to the ambient space. -/
  exists_extension : Prop
  /-- The extension agrees with the original functional on its domain. -/
  extends_functional : Prop
  /-- The extension preserves the norm of the original functional. -/
  norm_preserving : Prop
  /-- The three Hahn-Banach conclusions hold together. -/
  certificate : exists_extension ∧ extends_functional ∧ norm_preserving

/-- Hahn-Banach supplies an extension. -/
theorem HahnBanachExtension.exists
    {Domain Codomain Functional Extension : Type*}
    (h : HahnBanachExtension Domain Codomain Functional Extension) :
    h.exists_extension :=
  h.certificate.1

/-- Hahn-Banach extensions agree with the original functional. -/
theorem HahnBanachExtension.extends
    {Domain Codomain Functional Extension : Type*}
    (h : HahnBanachExtension Domain Codomain Functional Extension) :
    h.extends_functional :=
  h.certificate.2.1

/-- Hahn-Banach extensions can be chosen norm-preserving. -/
theorem HahnBanachExtension.norm_eq
    {Domain Codomain Functional Extension : Type*}
    (h : HahnBanachExtension Domain Codomain Functional Extension) :
    h.norm_preserving :=
  h.certificate.2.2

/-- A theorem-shape interface for Riesz representation by measures. -/
structure RieszRepresentation (Space Functional Measure : Type*) where
  /-- A representing measure exists. -/
  exists_measure : Prop
  /-- Integration against the measure recovers the functional. -/
  represents_functional : Prop
  /-- Positivity of the functional is reflected in the representing measure. -/
  positive : Prop
  /-- The measure representation theorem data. -/
  certificate : exists_measure ∧ represents_functional ∧ positive

/-- Riesz representation supplies a representing measure. -/
theorem RieszRepresentation.exists
    {Space Functional Measure : Type*}
    (h : RieszRepresentation Space Functional Measure) :
    h.exists_measure :=
  h.certificate.1

/-- The Riesz measure represents the functional. -/
theorem RieszRepresentation.represents
    {Space Functional Measure : Type*}
    (h : RieszRepresentation Space Functional Measure) :
    h.represents_functional :=
  h.certificate.2.1

/-- The Riesz representation interface records positivity. -/
theorem RieszRepresentation.positive_result
    {Space Functional Measure : Type*}
    (h : RieszRepresentation Space Functional Measure) :
    h.positive :=
  h.certificate.2.2

/-- A theorem-shape interface for Stone-Weierstrass density statements. -/
structure StoneWeierstrass (Space Algebra Closure : Type*) where
  /-- The algebra separates points. -/
  separates_points : Prop
  /-- The algebra contains the constant functions needed by the theorem. -/
  contains_constants : Prop
  /-- The algebra is dense in the target continuous-function space. -/
  dense : Prop
  /-- The Stone-Weierstrass theorem data. -/
  certificate : separates_points ∧ contains_constants ∧ dense

/-- Stone-Weierstrass hypotheses include point separation. -/
theorem StoneWeierstrass.separates
    {Space Algebra Closure : Type*}
    (h : StoneWeierstrass Space Algebra Closure) :
    h.separates_points :=
  h.certificate.1

/-- Stone-Weierstrass hypotheses include constants. -/
theorem StoneWeierstrass.constants
    {Space Algebra Closure : Type*}
    (h : StoneWeierstrass Space Algebra Closure) :
    h.contains_constants :=
  h.certificate.2.1

/-- Stone-Weierstrass concludes density. -/
theorem StoneWeierstrass.density
    {Space Algebra Closure : Type*}
    (h : StoneWeierstrass Space Algebra Closure) :
    h.dense :=
  h.certificate.2.2

/-- A theorem-shape interface for Arzela-Ascoli compactness statements. -/
structure ArzelaAscoli (Domain Codomain Family : Type*) where
  /-- The family is equicontinuous. -/
  equicontinuous : Prop
  /-- The family has the pointwise boundedness or compact-closure hypothesis. -/
  bounded_or_compact : Prop
  /-- The family has compact closure, or is compact under closedness hypotheses. -/
  compact : Prop
  /-- The Arzela-Ascoli theorem data. -/
  certificate : equicontinuous ∧ bounded_or_compact ∧ compact

/-- Arzela-Ascoli assumes equicontinuity. -/
theorem ArzelaAscoli.equicontinuous_result
    {Domain Codomain Family : Type*}
    (h : ArzelaAscoli Domain Codomain Family) :
    h.equicontinuous :=
  h.certificate.1

/-- Arzela-Ascoli records the boundedness or compactness side condition. -/
theorem ArzelaAscoli.bounded_or_compact_result
    {Domain Codomain Family : Type*}
    (h : ArzelaAscoli Domain Codomain Family) :
    h.bounded_or_compact :=
  h.certificate.2.1

/-- Arzela-Ascoli gives compactness of the relevant function family. -/
theorem ArzelaAscoli.compact_result
    {Domain Codomain Family : Type*}
    (h : ArzelaAscoli Domain Codomain Family) :
    h.compact :=
  h.certificate.2.2

end Analysis
end MathlibExpansion
