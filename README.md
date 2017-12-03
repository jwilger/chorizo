# ChorizoCore

Implements the core functionality for Chorizo, a gamified family
chore-tracker that rewards initiative and cooperation. The top-level
`ChorizoCore` module defines the public API for this Elixir application.
External programs that depend on ChorizoCore should use only the functions
defined directly on `ChorizoCore`; other modules within this application are
intended only for internal usage and are therefore subject to breaking changes
without notice.

## Why is it called Chorizo

Well, I needed a name. And "chore" and "chorizo" start with the same sound. And
this is the first project I've ever built with Elixir. So much like sausage, you
might not want to see how it's made. :-)

## A Learning Project

As stated above, this is the first project I've ever attempted using Elixir. As
such, there may be stuff in here that could easily be done using another
library. I've chosen to create my own implementations of things vs. looking for
external libraries in may cases, because that ends up being a good way to learn.
