// The manager for a bucket of documents
// currently this just means the link, variant, and history windows

#ifndef BUCKET
#define BUCKET

class FEBrowser;

// TODO: remove this when trails propagate
#define NO_PROPAGATE

#define FEBUCKETMANAGER_MAX_ITEMS 50

// TODO: make the superclass go away, as soon as we figure out what the right
// thing for nested trails is
class FEBucketManager {
public:
	/* Show what's at this end or what's at the other end, respectively */
	virtual void show (int index) =0;
	virtual void follow (int index) =0;

  /* Delete the item at index; return TRUE if successful */
	virtual int deleteItem (int index) =0;

	/* Get info on the item */
	virtual void info (int index) =0;

  /* How many items there are */
	virtual int count () =0;

	/* The descriptor of the given item (for setting up the linkWindow) */
	virtual char* description (int index) =0;

	/* The work at the given index */
	virtual XuWorkP work (int index) =0;

	/* Set the description to be something else */
	virtual void setDescription (int index, char* newDesc) =0;

	/* Close the window associated with this manager */
	virtual void closeWindow () =0;

protected:
	int myCount;
};

#endif // BUCKET

