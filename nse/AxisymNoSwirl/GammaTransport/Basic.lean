import NavierStokes.AxisymNoSwirl.GammaTransport.Carrier

/-!
# NavierStokes.AxisymNoSwirl.GammaTransport.Basic

Compatibility shim for downstream files that were written against a `Basic` entry point.

The live B4 surface now resides in `GammaTransport.Carrier`; this module intentionally
re-exports that file without introducing any new declarations, so downstream imports can
transition incrementally without namespace collisions.
-/
