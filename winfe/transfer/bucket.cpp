#include <owl.h>
#include <xanadu.hxx>
#include <stdio.h>
#include <stdlib.h>
#include <fstream.h>
#include <string.h>
#pragma hdrstop

// Null definitions for the bucket stuff.

#include "bucket.h"

void FEBucketManager::show (int index) {}
void FEBucketManager::follow (int index) {}

int FEBucketManager::deleteItem (int index) {}

void FEBucketManager::info (int index) {}

int FEBucketManager::count () { return myCount; }

char* FEBucketManager::description (int index) {}

XuWorkP FEBucketManager::work (int index) {}

void FEBucketManager::setDescription (int index, char* newDesc) {}

void FEBucketManager::closeWindow () {}
