/*
There basically are several interrelated tables we are
keeping, and it needs to be simple to obtain a few
important relations.

Link string descriptions in a link pane
Link records: descriptors of each end, titles of each end,
	title of the link
Work table: given a work, get/make a browser on it

All right.  We assume that we can drop link records as their link pane
vanishes--that is, link records are meaningful only from a particular link
pane.  Requests for titles will be handled quickly enough by the backend,
since if you've just accessed it it will be there immediately.

This means that we need a titleTM for link panes, and another for the
overall work table.  The overall work title table becomes a kind of
TrailManager that exports its domain, and when links get filled a different
method gets called with the title and the original Work.

The titleTM is basically a mapping from link record indices to title
works.  No... it _expands_ the link record when a title is found, and
calls the thing with the new title (and its index in the link table?).
To do this, there needs to be some easy way to get the link record and
its table index, given just the link edition.  An Int2Set is probably
the way to go.

So we have:
	An Int2Set in which browsed works are stored.
  		-- theBrowserSet
	A table of browsers indexed according to the Int2Set.
  		-- theBrowserTable
	An FETitleManager which gets its domain filled in by clients with Works
		to watch out for, and which calls a particular "retitle" method of a
		Work's browser when a title appears for that Work.  (If another title
		appears, it will be ignored.)  (What is the deal with titles on link-
		ends?  Do we require that they be available?  If so, there may need to
		be some separate table for them, or something... as I can't think of how
		this particular FETitleManager could both keep the Work table going
		_and_ notify particular link panes.)
			-- theBrowserTitleManager

	An Int2Set in which link works are kept for the link pane.
	A table of link records indexed according to the Int2Set.
	A mapping from link record indices onto indices in the link pane.
	Functions to atomically add to and update the link pane as a function of
  	changes in the link record table.
	A FELinkTitleManager which has as its DomainTM a FELinkManager. When
		link works come in, the FELinkTitleManager stores them in an
		internal FEInt2Set.  When a title link
		work comes in, the FELinkTitleManager makes a new FELinkRecord for
		the work, determines the index of the work, and atomically tests and
		sets the link record slot (redisplaying the link descriptor if need
		be, also atomically).

Now deleting a Work becomes a matter of dropping the Work from the Int2Set
and removing its clubs (inside a XuDelay for atomicity) and from the
browser table--and probably also from the FETitleManager, however that is
done.  (For starters we just don't do that.)

Deleting a link is deleting it from the link pane, from the Int2Set, and
from the mapping from Int2Set indices to link pane indices.  And eventually
also from the FELinkTitleManager.

One hairball issue is _changing titles_... how fast does that propagate?
In the limit, each link and each work is continuously revision tracked,
and as titles are changed the backend sends events which inform everything.
BUT NOT YET, IF EVER.  For now, titles show up and then are just there,
except in cases where you can directly edit them in one place.  (For
example, browser title resetting is easy... there's only one browser on
a particular Work.  Changing the title of a link in a given link pane is
also easy.  But changing the title of a Work, and having that change
immediately propagate to the descriptor of a link in a completely different
pane... _that_ is hard.  Seems like revision detectors which got called
with the Work that was revised would be a big help.  Oh well, for now we
just change titles in the browser or the single link pane, and leave it
at that.  Algorithms are obvious.

What are incremental pieces?  Well, the browser title table is probably
the best place to start, albeit it needs link-work trails working... then
the UI for the titles in the browser.  Then will come the grand titling
of the link system, which will be moderately hairy.  Yes yes, but it will
be oh so very nice when trails propagate properly!

We could use a Preferences dialog box for setting the style of link
descriptor!  Also ellipses...

