# TTK-Container

The shared interface that all vendor containers must implement to be compatible with ttk-core.

# Purpose

This is the result of the first major step towards "make it right" after having already "make it work." It turns out that this is the lynchpin for making a multi-broker / multi-vendor system function. The high-level constructs in TTK-Core simply can't be peppered with specific knowledge about each vendor.

The abstractions offered in this gem carry through-out the entire ecosystem. This gem provides the basic abstraction for a `Product`, `Expiration`, `Quote`, `Leg`, `Order`, and `Position`. Further, it centralizes the logic for taking a bundle of `Legs` and classifying them as a `Single` or `Combo`. Under `Combo`, it can identify a collection of legs as:

* vertical spread
* calendar spread
* reverse calendar spread
* diagonal spread
* reverse diagonal spread
* spread roll in
* spread roll out
* front ratio spread
* back ratio spread
* iron condor
* butterfly
* jade lizard
* twisted sister
* etc

Not all spreads will be coded up initially, but over time they can all be represented here.

The vendor gem can apply this logic directly to its collection of order legs. The logic is more complex for classifying an unbundled set of position legs.
