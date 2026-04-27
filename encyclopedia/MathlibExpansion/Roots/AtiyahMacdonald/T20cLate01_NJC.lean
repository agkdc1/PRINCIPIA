import Mathlib.RingTheory.Nakayama
import Mathlib.RingTheory.Jacobson.Ring

/-!
# T20c_late_01 NJC — Nakayama lemma and Jacobson control (DEFER wrapper)

**Classification.** `defer` / `DEFER` tier. Nakayama lemma (Chapter 1 §1.5),
Jacobson radical control (Ch. 2 §§2.5–2.6) are already upstream under the
modern names `Submodule.eq_bot_of_le_smul_of_le_jacobson_bot`,
`Ideal.jacobson`, and `Ideal.IsJacobson`.

**Citation.** Atiyah & Macdonald (1969), Ch. 1 §1.5 pp. 14–15, Ch. 2 §§2.5–2.6
pp. 19–22. Historical parent: Nakayama, "A remark on finitely generated
modules", Nagoya Math. J. 3 (1951); Jacobson, *Structure of Rings*,
AMS Colloquium (1956).
-/

namespace MathlibExpansion
namespace Roots
namespace AtiyahMacdonald
namespace T20cLate01_NJC

/-- **NJC citation marker** (DEFER, 2026-04-24). Nakayama lemma and Jacobson
control are both upstream; pinned in
`Roots/Recon/WP06NakayamaCheck.lean`. -/
theorem njc_covered_marker : True := trivial

end T20cLate01_NJC
end AtiyahMacdonald
end Roots
end MathlibExpansion
