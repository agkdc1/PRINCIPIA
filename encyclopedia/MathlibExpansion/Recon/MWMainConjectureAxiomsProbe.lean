import MathlibExpansion.MazurWiles1984.MainConjecture

/-!
# Axioms probe for the Mazur–Wiles main conjecture hydra-cuts

Verifies the boundary structure after:

* 2026-04-22 (phase 1): split of `mazurWilesMainConjecture` equality into two
  per-direction inclusion axioms.
* 2026-04-23 hydra-cut A (sibling session, forward direction): split of
  `mazurWilesDivisibility` via the opaque `mazurWilesBridgeIdeal` into
  `char_le_mazurWilesBridge` and `mazurWilesBridge_le_Lp`.
* 2026-04-23 hydra-cut B (this session, reverse direction): split of
  `iwasawaAnalyticClassNumberFormula` into `iwasawaAnalyticWeierstrassMatch`
  (analytic side) and `reverseCharIdealInclusion_of_weierstrassMatch`
  (algebraic side).

Expected:
* `mazurWilesMainConjecture` — theorem, closes over `char_le_mazurWilesBridge`,
  `mazurWilesBridge_le_Lp`, `iwasawaAnalyticWeierstrassMatch`,
  `reverseCharIdealInclusion_of_weierstrassMatch`, plus inherited Iwasawa
  boundaries (`iwasawaFreeTorsionSplit`, `iwasawaTorsionUpgradeOfSplit`) and
  core kernel axioms.
* `mazurWilesDivisibility` — theorem, closes over the two bridge axioms.
* `iwasawaAnalyticClassNumberFormula` — theorem, closes over the two Phase 2
  sub-axioms plus inherited Iwasawa boundaries.
-/

#print axioms MazurWiles1984.mazurWilesMainConjecture
#print axioms MazurWiles1984.mazurWilesDivisibility
#print axioms MazurWiles1984.iwasawaAnalyticClassNumberFormula
#print axioms MazurWiles1984.char_le_mazurWilesBridge
#print axioms MazurWiles1984.mazurWilesBridge_le_Lp
#print axioms MazurWiles1984.iwasawaAnalyticWeierstrassMatch
#print axioms MazurWiles1984.reverseCharIdealInclusion_of_weierstrassMatch
#print axioms MazurWiles1984.charIdeal_dvd_Lp
#print axioms MazurWiles1984.charIdeal_eq_unit_mul_Lp
