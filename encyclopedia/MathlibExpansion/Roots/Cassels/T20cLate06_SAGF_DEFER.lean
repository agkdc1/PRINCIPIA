import Mathlib.Algebra.Group.Defs

/-!
# T20c_late_06 SAGF_DEFER — Semisimple algebraic groups, Galois forms (defer)

**Classification.** `defer` / DEFER. Chapter X novel-heavy sidecar: semisimple
algebraic `K`-group forms classified by `H^1(Gal(K̄/K), Aut(G_{K̄}))`,
Tits's classification over arbitrary fields via `*`-action, non-abelian `H^1`
sidecar. Off the current CFT-critical fireline — not on the opening firing
lane.

**Citation.** Cassels–Fröhlich, *Algebraic Number Theory* (1967), Chapter X
(Serre, "Galois cohomology" / Kneser appendix). Historical parents: Serre
(1964 Bourbaki / 1964 *Cohomologie galoisienne*) §III (non-abelian `H^1`,
classifying forms); Tits (1966) "Classification of algebraic semisimple
groups"; Kneser (1965) *Hasse principle for H^1 of simply connected groups
over number fields*; Steinberg (1965) "Regular elements of semisimple
algebraic groups".
-/

namespace MathlibExpansion
namespace Roots
namespace Cassels
namespace T20cLate06_SAGF

/-- **SAGF_01** (DEFER) non-abelian `H^1` + form classification marker.
For `G_0` a quasi-split semisimple algebraic `K`-group with split form
`G_0 ×_K K^{sep}`, the pointed set of `K`-forms of `G_0` (up to `K`-iso) is
in bijection with `H^1(Gal(K^{sep}/K), Aut(G_0)_{K^{sep}})` (Galois
cohomology with `Aut(G_0)` as pointed `Γ_K`-set, not abelian group in
general). Extends to Tits's classification by outer-form `*`-action.
This row is DEFERRED from the current Cassels–Fröhlich Step 6 fireline.
Citation: Cassels–Fröhlich Ch. X (Serre); Serre *Cohomologie galoisienne*
(1964) §III.1–§III.5; Tits (1966) *Algebraic Groups and Discontinuous
Subgroups* (Proc. Sympos. Pure Math. 9); Kneser (1965); Steinberg (1965). -/
axiom semisimple_galois_form_classification_marker : True

end T20cLate06_SAGF
end Cassels
end Roots
end MathlibExpansion
