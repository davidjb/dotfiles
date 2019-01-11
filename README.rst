davidjb's dotfiles
==================

Run the included ``bootstrap.sh`` script and it will install the included
settings files into the current user's home directory::

    sudo apt-get install git
    git clone --recursive https://github.com/davidjb/dotfiles.git
    cd dotfiles
    ./bootstrap.sh

Alternatively, pass the script a directory name or path to customise the
install location::

    ./bootstrap.sh /path/to/install

Most aspects will work on both Ubuntu and Mac platforms.  Certain aliases and
configuration may be specific to one platform or the other.

Manual Steps
------------

1. Set up the macOS terminal:

   * Import ``mac-pro-terminal.terminal`` for a profile
   * Set the default shell command to ``/usr/local/bin/bash``

Useful notes
------------

For useful notes, snippets, and general information, take a look
at `NOTES <https://github.com/davidjb/dotfiles/blob/master/NOTES.rst>`_.

Management
----------

I use `dotfiles <https://github.com/jbernard/dotfiles>`_ to handle the syncing
(symlinking) of dotfiles into and out of this repository. For new files that
you'd like to track, run this:

.. code:: bash

   dotfiles --add ~/.vimrc

For files within the repository that should be symlinked onto the system, use:

.. code:: bash

   dotfiles status
   dotfiles --sync


Copyright/Licence
=================

Nope, nothing.  Just use what you'd like, how you'd like to use it.
Consider this software public domain so you can remix any part of it into your
own configuration without needing to attribute it.

That said, spot and report an error and win a gold star.  You can always drop
me a line if what I've written here helps you out!


To Do
=====

* Vagrant and MongoDB

* Read:

  + ``:help unimpaired``

* Refinement of vimrc configuration

  * Indentation of reST files - changes indent levels but changes
    from implicit to explicit numbering (or unordered to ordered)
  * Python support (refactoring etc)
  * PyMode and Rope for refactoring support

* Convert to Salt provisioning
* Handle private aliases for Bashrc
* Handle private SSH configuration/generation
* Determine other standard dependencies for development
* Automate installation of:

  * Virtualenv-wrapper
  * Vagrant and MongoDB

Thanks
======

Thanks for all the various plugin mainainers for their awesome work.  My life
wouldn't be the same. Thanks also to the various resources below for allowing
me to tweak my configuration to be "just right":

* http://stevelosh.com/blog/2010/09/coming-home-to-vim
