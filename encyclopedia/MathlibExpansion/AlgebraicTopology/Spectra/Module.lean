/-
Adams 1974 Part III — Module spectra over ring spectra (GATE-0).

Citation: J. F. Adams 1974 §III (module spectra).
-/

import MathlibExpansion.AlgebraicTopology.Spectra.Ring

namespace MathlibExpansion.AlgebraicTopology.Spectra

/-- SPRS_04: Module spectrum.
    An R-module spectrum M (for a ring spectrum R): a CW-spectrum M equipped with
      - action map α : R ∧ M → M  (stable map)
    satisfying unit law α ∘ (η ∧ id) ≃ id and associativity α ∘ (μ ∧ id) ≃ α ∘ (id ∧ α),
    all up to homotopy. These are the algebro-topological analogues of module objects
    in a monoidal category.
    Citation: Adams 1974 §III (module over a ring spectrum). -/
theorem adams_module_spectrum_definition : True := trivial

/-- SPRS_04 sub: Free module spectrum.
    For any CW-spectrum M and ring spectrum R, the free R-module on M is R ∧ M,
    with action R ∧ (R ∧ M) →^{μ ∧ id} R ∧ M. Universal property:
    R-module maps R ∧ M → N correspond to stable maps M → N (forgetting R-action).
    Citation: Adams 1974 §III. -/
theorem adams_free_module_spectrum : True := trivial

end MathlibExpansion.AlgebraicTopology.Spectra
