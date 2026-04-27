import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_09 AFGQA — Arithmetic Fuchsian Groups from Quaternion Algebras (Shimura 1971 §9, novel_theorem, B4-SIDEBRANCH)
    **Classification.** novel_theorem — NOT just a sidecar lemma lane. Quaternion orders, reduced
    norm/order API, split real-place embeddings, discreteness, covolume, and quotient geometry
    are a full arithmetic-group stack. Side branch off the FLT-critical chain but priced as
    max-tier arithmetic-group build.
    **Citation.** Shimura §9.1-9.5 (quaternion-algebra arithmetic Fuchsian groups, discreteness
    via split real place, compact/cocompact quotients); Eichler 1938 *Über die Idealklassenzahl
    hyperkomplexer Systeme*; Shimura 1967 *Construction of class fields and zeta functions of
    algebraic curves* II §3; Vignéras *Arithmétique des algèbres de quaternions* LNM 800 (1980). -/
namespace MathlibExpansion
namespace Roots
namespace Shimura
namespace T20cLate09_AFGQA

/-- **AFGQA_01** quaternion algebra `B/F` over totally real field with exactly one split real
    place; reduced norm/order API + maximal order `𝒪 ⊂ B` (Shimura §9.1-9.2; Eichler 1938). -/
axiom afgqa_quaternion_order_split_real_place_marker : True

/-- **AFGQA_02** group of units `𝒪¹ = {x ∈ 𝒪 : nrd(x) = 1}` embeds discretely in `SL₂(ℝ)` via
    the split real place (Shimura §9.3, Prop 9.2). -/
axiom afgqa_discrete_embedding_in_sl2_marker : True

/-- **AFGQA_03** arithmetic Fuchsian quotient `𝒪¹ \ ℍ` has finite hyperbolic volume; compact
    ⟺ `B` is a division algebra over `F` (Shimura §9.4-9.5, Thm 9.7; Vignéras LNM 800). -/
axiom afgqa_cofinite_compact_quotient_marker : True

end T20cLate09_AFGQA
end Shimura
end Roots
end MathlibExpansion
