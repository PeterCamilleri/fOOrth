# The fOOrth Language gem.

This file contains the read-me for the fOOrth language gem. The fOOrth
language is an experimental variant of FORTH that attempts to incorporate
object oriented and functional programming concepts.

As an aside, there can be no doubt that the fOOrth project is an utter waste
of anyone's time, unless one counts the insights gained into the inner
workings of Ruby and meta programming.

## Usage
Adding fOOrth can be as simple as:

    require 'fOOrth'
    XfOOrth.main

This will launch an interactive fOOrth session. Alternatively this can be
done with:

    rake run

Be sure to be in the folder that contains the rakefile in order for this
command to work.

<br>If, instead, a non-interactive facility is required, use:

    require 'fOOrth'
    XfOOrth.virtual_machine.process_string '1 2 +'

where the string is fOOrth code to be executed, or for a file of code, use:

    require 'fOOrth'
    XfOOrth.virtual_machine.process_file 'my_file.foorth'

## Further Documentation

The fOOrth Language System is documented in The fOOrth User Guide. This is
currently only available in Open Office format, and is still also very much
a work in progress. Please see The_fOOrth_User_Guide.odt in the docs folder.

As each version of fOOrth is made available, expect to see portable document
format versions of the guide for each released version.

## Areas of effort

* A great deal of work is needed to make the fOOrth User Guide completed even
to version 0.0.3
* The compile methods (:, !:, .:, and .::) only work in execute mode. A major effort
is required to make these methods at least behave in a consistent manner.
* The fOOrth language needs to be tested (and made operational) under current
versions of both Rubinius and JRuby.

## Latest Victories

* 2015-04-13 The test and integration suites now work correctly with minitest
5.5.1 in both Ruby versions 1.9.3 and 2.1.5! Finally! Yay!

## Notes

* Tested under ruby 1.9.3p484 (2013-11-22) [i386-mingw32]
* I have used rdoc 4.0.1 here. Will need to examine rdoc styling options as later
versions do not have a pleasing layout.


