#ifndef XINT2SET
#define XINT2SET

/* Draft code for the Int2Set portion of the Xanadu demo frontend.
   Rob Jellinghaus, August-September 1992 */

/* FEInt2Set implements a mutable integer array of RangeElements. */

/* TODO?: add an optional Work which will get hopped on every change. */
/* TODO?: make this some kind of subclass of XuSet. */

class FEInt2Set {
 public:

	/* make an empty FEInt2Set */
	static FEInt2Set* make ();
    
	/* make a FEInt2Set with arbitrary integers on the given XuSet */
	static FEInt2Set* make (XuSetP initialContents);
    
	/* make an FEInt2Set with the same contents as otherSet */
	static FEInt2Set* make (FEInt2Set* otherSet);
    
  /* The integer index of this element
		(-1 if not in table, -2 if element broken */
  XuIntVar positionOf (XuRangeElementP element);
    
  /* The element at this index (XU_NULL if not in table) */
  XuRangeElementP get (XuIntVar pos);
    
  /* Add an element to the table at a new index */
  XuIntVar add (XuRangeElementP element);
    
  /* Add an element to the table at the given index */
  void addAt (XuIntVar pos, XuRangeElementP element);
    
  /* Remove an item at the given index. Do nothing if not there. */
  void removeAt (XuIntVar pos);
    
  /* Remove the given item. Do nothing if not there. */
  void remove (XuRangeElementP element);
    
  /* A region of the indices in use. */
  XuIntegerRegionP domain ();
    
  /* A set of the contents */
  XuSetP contents ();
    
  /* The number of elements in it. */
  XuIntVar count();
    
protected:

	FEInt2Set () {};

  /* The integer-indexed edition all this uses */
  XuEditionP myEdition;
};

#endif // XINT2SET
