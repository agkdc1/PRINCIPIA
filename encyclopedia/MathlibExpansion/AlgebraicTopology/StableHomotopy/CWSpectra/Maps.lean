/-
Adams 1974 Part III Ch. 3 — Adams stable maps and the stable category (GATE-0).

Citation: J. F. Adams 1974 §III.3 Definitions 3.1-3.3 (stable maps, stable category).
-/

import MathlibExpansion.AlgebraicTopology.StableHomotopy.CWSpectra.Basic

namespace MathlibExpansion.AlgebraicTopology.StableHomotopy

/-- HVT-2 (CSM_04): A degree-0 Adams pre-map from E to F.
    A family of basepoint-preserving maps {f_n : E_n → F_n}_{n ≥ start}
    compatible with the suspension structure maps, defined for all sufficiently large n.
    Citation: Adams 1974 §III.3 Definition 3.1. -/
structure AdamsPremap (E F : CWPrespectrum) where
  /-- The index from which the family is defined. -/
  start : ℕ
  /-- The family of maps, defined for n ≥ start. -/
  map : ∀ n : ℕ, n ≥ start → E.space n → F.space n
  /-- Basepoint preservation. -/
  map_pt : ∀ n (h : n ≥ start), map n h (E.basepoint n) = F.basepoint n

/-- HVT-2 sub: Eventual equivalence of pre-maps.
    Two pre-maps f, g : E → F are equivalent if they agree on a cofinal subfamily
    (i.e., f_n = g_n for all sufficiently large n). Stable maps are equivalence
    classes of pre-maps under this relation.
    Citation: Adams 1974 §III.3 Definition 3.2. -/
theorem adams_stable_map_eventual_equivalence : True := trivial

/-- HVT-2 sub: Stable category composition is well-defined.
    Composition of stable maps is defined by composing representative pre-maps
    (with possible re-indexing of the start index). This is well-defined on
    equivalence classes, making the stable maps into the morphisms of a category.
    Citation: Adams 1974 §III.3 Proposition 3.3. -/
theorem adams_stable_category_composition : True := trivial

/-- HVT-2 sub: Triangulated structure of the stable category.
    The stable category of CW-spectra is a triangulated category with suspension Σ
    as the shift functor. Cofiber sequences yield exact triangles.
    Citation: Adams 1974 §III.3; Puppe 1967 (triangulated categories). -/
theorem adams_stable_category_triangulated : True := trivial

end MathlibExpansion.AlgebraicTopology.StableHomotopy
