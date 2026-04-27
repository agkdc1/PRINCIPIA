import MathlibExpansion.Roots.LanglandsTunnell.ResidualModularity

/-!
# Axiom accounting — Langlands-Tunnell breach

Runs `#print axioms` on every declaration introduced by the LT breach to verify
the 1-axiom budget lock.

**Expected output for `langlandsTunnellResidualModular`:**
- `MathlibExpansion.Roots.LanglandsTunnell.langlandsTunnellResidualModular`
  (the boundary axiom itself)

**Expected output for `langlandsTunnell_discharges_bcdt_axiom3`:**
- `MathlibExpansion.Roots.LanglandsTunnell.langlandsTunnellResidualModular`
  (discharge theorem calls the axiom directly — no additional axioms)

**Expected output for `lt_breach_sentinel`:**
- No axioms (proved by `trivial`; kernel axioms not surfaced for closed proofs)

Any axiom outside this list is a budget violation.
-/

namespace MathlibExpansion.Roots.LanglandsTunnell.AxiomsCheck

/-! ## LT boundary axiom -/

#print axioms MathlibExpansion.Roots.LanglandsTunnell.langlandsTunnellResidualModular

/-! ## BCDT Axiom 3 discharge theorem -/

#print axioms MathlibExpansion.Roots.LanglandsTunnell.langlandsTunnell_discharges_bcdt_axiom3

/-! ## Sentinel -/

#print axioms MathlibExpansion.Roots.LanglandsTunnell.lt_breach_sentinel

end MathlibExpansion.Roots.LanglandsTunnell.AxiomsCheck
