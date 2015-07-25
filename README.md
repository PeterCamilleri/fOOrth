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

Also for those who do not have or don't want Open Office: As each major
version of fOOrth is made available, expect to see portable document format
(pdf) versions of the guide. (In the docs folder in the repository)

## Contributing

#### Plan A

1. Fork it
2. Switch to the development branch ('git branch development')
3. Create your feature branch ('git checkout -b my-new-feature')
4. Commit your changes ('git commit -am "Add some feature"')
5. Push to the branch ('git push origin my-new-feature')
6. Create new Pull Request


For more details on the branching strategy, please see:
http://nvie.com/posts/a-successful-git-branching-model/


#### Plan B

Go to the GitHub repository and raise an issue calling attention to some
aspect that could use some TLC or a suggestion or an idea. Apply labels
to the issue that match the point you are trying to make. Then follow
your issue and keep up-to-date as it is worked on. All input are greatly
appreciated.
