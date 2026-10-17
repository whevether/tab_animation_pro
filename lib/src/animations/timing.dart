/// Normalized progress within an interval, including degenerate intervals.
double intervalProgress(double t, double begin, double end) {
  if (end <= begin) return t >= end ? 1 : 0;
  return ((t - begin) / (end - begin)).clamp(0.0, 1.0);
}
