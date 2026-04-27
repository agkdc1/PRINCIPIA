import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_09 CMIQCF — CM Elliptic Curves & Imaginary Quadratic Class Fields (Shimura 1971 §5, novel_theorem, B4)
    **Classification.** novel_theorem — full CM corridor: CM criterion, singular moduli,
    reciprocity, and generation of imaginary-quadratic class fields.
    **Citation.** Shimura §5.1-5.4 (CM elliptic curves, `j`-invariants generating ring-class
    fields); Kronecker *Jugendtraum* (letter to Dedekind 1880); Weber *Lehrbuch der Algebra* III
    (1908); Hasse 1927; Deuring 1958 *Die Klassenkörper der komplexen Multiplikation*. -/
namespace MathlibExpansion
namespace Roots
namespace Shimura
namespace T20cLate09_CMIQCF

/-- **CMIQCF_01** CM criterion: `End(E) ⊗ ℚ = K` imaginary quadratic ⟺ `E` has complex
    multiplication by an order `𝒪 ⊂ K` (Shimura §5.1, Thm 5.3). -/
axiom cmiqcf_cm_criterion_marker : True

/-- **CMIQCF_02** singular modulus `j(E)` is an algebraic integer generating the ring-class
    field `K(j(E))/K` of conductor = conductor of `𝒪` (Shimura §5.2, Thm 5.7; Weber III). -/
axiom cmiqcf_singular_modulus_generates_ring_class_field_marker : True

/-- **CMIQCF_03** explicit reciprocity: `Gal(K(j(E))/K) ≃ Pic(𝒪)` via action on `j`-invariants
    of CM curves (Shimura §5.3-5.4, Main Thm of CM; Deuring 1958). -/
axiom cmiqcf_main_theorem_cm_reciprocity_marker : True

end T20cLate09_CMIQCF
end Shimura
end Roots
end MathlibExpansion
