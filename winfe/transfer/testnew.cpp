#include <malloc.h>
#include <mem.h>
#include <stdlib.h>
#include <stdio.h>
#include <windows.h>
             
int GUARDSIZE	= 1;
#define GUARDBYTE	0xbb 
#define DELETEDBYTE	0xdd

class MemHeader {
public:
	static void * allocate (size_t s); // set up a memory block
	static void deallocate (void * p); // get rid of a memory block

private:
	static void checkAll ();	// check that the memory setup is consistent
	static void error ();			// an error has happened - good place to put breakpoint

	static int Initialized;
	static MemHeader * Allocated;
	static MemHeader * Deleted;

public:
	MemHeader (size_t s);			// initialize
	MemHeader ();							// only for the global roots

	void unlink ();						// unlink from previous & next blocks
	void link (MemHeader *);	// link other after self

	void check ();						// check the guard bytes
	void checkDeleted ();			// check the contents bytes 

private:
	MemHeader * previous;			// previous block in linked list
	MemHeader * next;					// next block in linked list
	size_t size;							// size of this block
	char guard[1];						// guard bytes in this block

private:
	static void * getmem (size_t s); // allocate a block of memory

	static void * mem; // next available memory block
  static size_t available; // how much is left in it
};

void * operator new (size_t s) {
	return MemHeader::allocate (s);
}

void * operator new (size_t, void * p) {
	return p;
}

void operator delete (void * p) {
	MemHeader::deallocate (p);
}

void * MemHeader::allocate (size_t s) {
	if (Initialized < 2) {
		void * p = getmem (s);
		if (p == NULL) {
			MemHeader::error ();
		}
 			return p;
	}
 //	MemHeader::checkAll ();

	void * block = getmem (s + sizeof (MemHeader) + 2 * GUARDSIZE);
	if (block == NULL) {
		MemHeader::error ();
	} 
	new (block) MemHeader (s);
	MemHeader::Allocated->link ((MemHeader *) block);
	return (void *) (((MemHeader *) block)->guard + GUARDSIZE);
}

void MemHeader::deallocate (void * p) {
	// we never really free anything - either leave it there, or
  // link it onto a list to be checked for modification
	if (Initialized < 2) {
		return;
  }
/*	MemHeader::checkAll ();

	for (MemHeader * h = Allocated->next; h != Allocated; h = h->next) {
		if (h->guard + GUARDSIZE == (char *) p) {
			h->unlink ();
			MemHeader::Deleted->link (h);
			memset (h->guard + GUARDSIZE, DELETEDBYTE, h->size);
			return;
		}
	}
*/
}

void MemHeader::checkAll () {
	MemHeader * p, * op;
	for (op = Allocated, p = op->next; p != Allocated; op = p, p = p->next) {
		if (p->previous != op) {
			MemHeader::error ();
		}
		p->check ();
	}
	for (op = Deleted, p = op->next; p != Deleted; op = p, p = p->next) {
		if (p->previous != op) {
			MemHeader::error ();
		}
		p->check ();
		p->checkDeleted ();
	}
}

void MemHeader::error () {
	abort();
	exit (-1);
}

int MemHeader::Initialized = 0;
static MemHeader TheAllocated;
static MemHeader TheDeleted;
MemHeader * MemHeader::Allocated = &TheAllocated;
MemHeader * MemHeader::Deleted = &TheDeleted;

MemHeader::MemHeader (size_t s) {
	size = s;
	next = NULL;
	previous = NULL;
	memset (guard, GUARDBYTE, GUARDSIZE);
	memset (guard + GUARDSIZE + size, GUARDBYTE, GUARDSIZE);
}

MemHeader::MemHeader () {
	next = this;
	previous = this;
	size = 0;
	Initialized++;
}

void MemHeader::check () {
	unsigned char * p = guard;
	for (int i = 0; i < GUARDSIZE; i++, p++) {
		if (*p != GUARDBYTE) {
			MemHeader::error ();
		}
	}
	p = guard + GUARDSIZE + size;
	for (i = 0; i < GUARDSIZE; i++, p++) {
		if (*p != GUARDBYTE) {
			MemHeader::error ();
		}
	}
}

void MemHeader::checkDeleted () {
	unsigned char * p = guard + GUARDSIZE;
	for (int i = 0; i < size; i++, p++) {
		if (*p != DELETEDBYTE) {
			MemHeader::error ();
		}
	}
}

void MemHeader::unlink () {
	next->previous = previous;
	previous->next = next;
	previous = next = NULL;
}

void MemHeader::link (MemHeader * other) {
	next->previous = other;
	other->previous = this;
	other->next = next;
	next = other;
}

void * MemHeader::mem = NULL;
size_t MemHeader::available = 0;

void * MemHeader::getmem (size_t s) {
	// fprintf(stderr, "+%d ", s);
	if (s > available) {
		mem = GlobalLock (GlobalAlloc (GPTR, available = 32000));
	//	fprintf (stderr, "\n!! ");
		if (s > available) {
			MemHeader::error ();
		}
	}
	available -= s;
	void * result = mem;
	(char *) mem += s;
  return result;
}

