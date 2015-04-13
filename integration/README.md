# The Integration Test Suite.

While the tests folder mostly focuses on the internals of fOOrth, and in fact
does not even load the run time libraries, the integration test suite loads
the entire fOOrth language in order to be able to conduct testing on the
system as a whole.

This is done via the following rake command:

    rake integration

Most of the integration testing is done in fOOrth itself.
