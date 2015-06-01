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

## Contributing

1. Fork it
2. Switch to the development branch ('git branch development')
3. Create your feature branch ('git checkout -b my-new-feature')
4. Commit your changes ('git commit -am "Add some feature"')
5. Push to the branch ('git push origin my-new-feature')
6. Create new Pull Request

It is strongly encouraged to apply all new coding efforts to the
development branch and not master.

For more details on the branching strategy, please see:
http://nvie.com/posts/a-successful-git-branching-model/

