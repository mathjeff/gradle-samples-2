This project demonstrates a race condition in DefaultFileSystemAccess.snapshot

Specifically, if DefaultFileSystemAccess.snapshot is simultaneously updating a parent and child directory, then DefaultFileSystemAccess.snapshot might find knownExactSnapshot != null

Then, even if filter != null, knownExactSnapshot is returned anyway, and the unfiltered snapshot is considered to be the filtered snapshot.

Run test.sh to reproduce
