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

# Product

The Product container is a base-level concept. This is a single container that can
represent an Equity or EquityOption. There is sufficient flexibility built-in
to allow it to represent Futures, Options Futures, Bonds, and other types.

This container presents a single interface to all its consumers regardless
of its contents (Equity or EquityOption).

# Quote

The Quote container was originally split into Quote::Equity and Quote::EquityOption,
however this design wasn't right. When it came time to build the Leg 
interface (see below), each Leg had to contain a Quote and pass all of the
tests for a Quote. The problem was that a Leg could contain either a
Quote::Equity or Quote::EquityOption but not at the same time. Testing
the Leg for the correct interface was therefore impossible _unless_ the
Leg concept was similarly split into Leg::Equity and Leg::EquityOption. Further,
a Leg can be either a Leg::Position or Leg::Order, so now the combinations
grow to 4 (Leg::Position::Equity, Leg::Position::EquityOption, 
Leg::Order::Equity, Leg::Order::EquityOption). Every additional Quote type
would double this number.

At this time, I do not believe that is the best choice.

So, Quote contains the same interface for equities and options. The methods
that return Greeks just return 0 for Equities and the proper values for
EquityOptions. Every Quote contains a Product, so we can easily differentiate.

# Leg

A Leg can be either a Leg::Position or a Leg::Order. The interfaces are
exactly the same. However, not all fields in a Leg::Order are populated.
For a Position, the quantity, paid price, execution
time, side, and status are all easily determined. Several Leg::Position
objects related together create a Legs::Position where we can determine
aggregate characteristics from the Leg objects.

A Leg::Order is different in that it doesn't necessarily have a specific
price particularly when it's part of a spread. The Legs::Order has the
aggregate price but determining the Leg price at any given moment is
pointless. We want the Spread to execute at a particular value; the Leg
values are a means to that end.

# Legs

These are collection containers that aggregate information from 
Leg::Position or Leg::Order objects. In the case of a Legs::Position,
the value of the container is determined by its constituent Leg objects.
In the case of a Legs::Order, the container itself has a value while
the Leg objects do not; that is, the container value is not aggregated
from the Leg objects.

That last sentence is only partially true. It's completely true for the
target execution price of a Legs::Order. But each Leg contains a Quote
which is updated by the current market so we can see the market value
of the container change as its Leg values change.

The same is true for a Legs::Position. We have a locked value from the
price we paid, but there's also a current market value determined by
the Leg Quotes.

A Leg::Order can be opening or closing. Using that value plus the long /
short sides of the legs determines buy_to_open, buy_to_close, sell_to_open,
and sell_to_close. 