#include <owl.h>
#include <xanadu.hxx>
#include <stdio.h>
#include <stdlib.h>
#include <fstream.h>
#include <string.h>
#pragma hdrstop

#include "xint2set.hxx"

/* Draft code for the FEInt2Set abstraction.
   Rob Jellinghaus, August-September 1992 */


FEInt2Set* FEInt2Set::make ()
{
	FEInt2Set* newI2S = new FEInt2Set();
    newI2S->myEdition = XuEdition::empty(XuIntegerSpace::make());
    return newI2S;
}

FEInt2Set* FEInt2Set::make (XuSetP initialContents)
{
	FEInt2Set* newI2S = new FEInt2Set();

	XuEditionP edition = XuEdition::fromArray
		(initialContents->edition()->stepper()->stepMany());

	newI2S->myEdition = edition;
	return newI2S;
}

FEInt2Set* FEInt2Set::make (FEInt2Set* otherSet)
{
	FEInt2Set* newI2S = new FEInt2Set();
    newI2S->myEdition = otherSet->myEdition;
    return newI2S;
}

XuIntVar FEInt2Set::positionOf (XuRangeElementP element)
{
	XuIntValueP pos =
		XuInteger::cast(myEdition->positionsOf(element)->theOne())->value();
	pos->force();
	if (pos->isFulfilled()) {
		return pos->asInt();
	} else if (element->isFulfilled()) {
		return -1;
	} else {
   	return -2;
  }
}

XuRangeElementP FEInt2Set::get (XuIntVar pos)
{
	XuRangeElementP result = myEdition->get(pos);
  result->force();
	if (result->isBroken()) {
		return XU_NULL;
	} else {
		return result;
	}
}

XuIntVar FEInt2Set::add (XuRangeElementP element)
{
	/* The idea here is we create the region of positions above 0 at
	   which nothing is stored; we then store element at the first
	   such position. */
	XuIntegerRegionP unused =
	 XuIntegerRegion::cast
		(XuIntegerSpace::make()->above(0, XuIntValue::true())
		 ->intersect(myEdition->domain()->complement()));
	XuIntValueP newPos = unused->start();
	myEdition = myEdition->with(newPos, element);
	newPos->force();
	return newPos->asInt();
}

void FEInt2Set::addAt (XuIntVar pos, XuRangeElementP element)
{
    myEdition = myEdition->with(pos, element);
}

void FEInt2Set::remove (XuRangeElementP element)
{
    XuIntVar pos = positionOf(element);
    if (pos != -1) myEdition = myEdition->without(pos);
}

void FEInt2Set::removeAt (XuIntVar pos)
{
    myEdition = myEdition->without(pos);
}

XuIntegerRegionP FEInt2Set::domain ()
{
    return XuIntegerRegion::cast(myEdition->domain());
}

XuSetP FEInt2Set::contents ()
{
	// TODO: stepMAny might not get all elements.
	return XuSet::make(XuPtrArray::cast(myEdition->stepper()->stepMany()));
}

XuIntVar FEInt2Set::count()
{
	XuIntValueP count = myEdition->count();
	count->force();
	return count->asInt();
}


