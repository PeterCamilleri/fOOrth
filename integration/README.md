# The Integration Test Suite.

While the tests folder mostly focuses on the internals of fOOrth, and in fact
does not even load the run time libraries, the integration test suite loads
the entire fOOrth language in order to be able to conduct testing on the
system as a whole.

This is done via the following rake command:

    rake integration

Most of the integration testing is done in fOOrth itself.

TODO: From minitest 4.7.5 to 5.5.0 things got broken in a very bad way. Bad
as in ALL tests failing bad! Need to figure how they managed to F this up
so very badly and FIX IT!
