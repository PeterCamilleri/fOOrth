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
    XfOOrth.virtual_machine.process_file 'my_file.4th'

## Notes

* Tested under ruby 1.9.3p484 (2013-11-22) [i386-mingw32]
* Not sure what version broke minitest, but I'm not changing!
* I have used rdoc 4.0.1 here. Later versions of rdoc look like crap!