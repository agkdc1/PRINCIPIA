import Mathlib.MeasureTheory.Constructions.BorelSpace.Real
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import Mathlib.MeasureTheory.Measure.NullMeasurable

open MeasureTheory

namespace MathlibExpansion
namespace MeasureTheory

/-- `BLMB_02`: Borel-measurable real sets are null-measurable for volume. -/
theorem borel_measurable_implies_nullMeasurable {s : Set ℝ}
    (hs : MeasurableSet s) : NullMeasurableSet s (volume : Measure ℝ) :=
  hs.nullMeasurableSet

theorem nullMeasurable_Icc (a b : ℝ) :
    NullMeasurableSet (Set.Icc a b) (volume : Measure ℝ) :=
  (measurableSet_Icc : MeasurableSet (Set.Icc a b)).nullMeasurableSet

theorem nullMeasurable_Ioi (a : ℝ) :
    NullMeasurableSet (Set.Ioi a) (volume : Measure ℝ) :=
  (measurableSet_Ioi : MeasurableSet (Set.Ioi a)).nullMeasurableSet

theorem nullMeasurable_Iio (a : ℝ) :
    NullMeasurableSet (Set.Iio a) (volume : Measure ℝ) :=
  (measurableSet_Iio : MeasurableSet (Set.Iio a)).nullMeasurableSet

end MeasureTheory
end MathlibExpansion
