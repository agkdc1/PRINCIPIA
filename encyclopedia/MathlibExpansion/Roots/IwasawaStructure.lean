import MathlibExpansion.Roots.Iwasawa.Basic
import MathlibExpansion.Roots.Iwasawa.Pseudo
import MathlibExpansion.Roots.Iwasawa.Distinguished
import MathlibExpansion.Roots.Iwasawa.Elementary
import MathlibExpansion.Roots.Iwasawa.CharacteristicIdeal
import MathlibExpansion.Roots.Iwasawa.StructureTheorem

/-!
# IwasawaStructure — forwarding shim (W9-R10 breach 2026-04-20)

The monolithic 1498-line `IwasawaStructure.lean` has been replaced by the
`Iwasawa/` subdirectory.  This file re-exports everything so that existing
`import MathlibExpansion.Roots.IwasawaStructure` lines continue to compile.

The deprecated original is preserved at:
  `MathlibExpansion.Roots.Deprecated.IwasawaStructure_legacy`

Active development: `MathlibExpansion.Roots.Iwasawa.*`
-/
