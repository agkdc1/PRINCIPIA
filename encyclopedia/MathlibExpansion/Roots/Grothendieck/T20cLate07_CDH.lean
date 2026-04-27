import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_07 CDH — Cohomological Descent and Hypercovers (SGA 4 Exp. V bis, substrate_gap)

    **Citation.** Grothendieck–Verdier, *SGA 4* Exp. V bis (Saint-Donat, *Techniques de
    descente cohomologique*); simplicial hypercovers, cohomological descent, spectral
    sequence of a hypercover.
    Historical parent: Deligne (*Théorie de Hodge II*, 1971, for hypercover technique). -/
namespace MathlibExpansion
namespace Roots
namespace Grothendieck
namespace T20cLate07_CDH

/-- **CDH_01** simplicial hypercover of a topos (trivial Kan condition at each level)
    marker (SGA 4 V bis 1). -/
axiom simplicial_hypercover_marker : True
/-- **CDH_02** cohomological-descent theorem: `Rf_* ≃ Rf_{•*}` for a hypercover `f_•`
    (SGA 4 V bis 4) marker. -/
axiom cohomological_descent_theorem_marker : True
/-- **CDH_03** descent spectral sequence `E₁^{p,q} = Hᵠ(U_p, F_p) ⇒ Hⁿ(X, F)` for a
    hypercover (SGA 4 V bis 3) marker. -/
axiom hypercover_spectral_sequence_marker : True

end T20cLate07_CDH
end Grothendieck
end Roots
end MathlibExpansion
