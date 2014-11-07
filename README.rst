davidjb's dotfiles
==================

Run the included ``bootstrap.sh`` script and it will install the included
settings files into the current user's home directory::

    sudo apt-get install git
    git clone https://github.com/davidjb/dotfiles.git
    ./dotfiles/bootstrap.sh

Alternatively, pass the script a directory name or path to customise the
install location::

    ./bootstrap.sh /path/to/install


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

   dotfiles --check
   dotfiles --sync


Copyright
=========

Nope, nothing.  Just use what you'd like, how you'd like to use it.
Consider this software public domain.

Spot and report an error and win a gold star.


To Do
=====

* txmux over screen
* Vagrant and MongoDB
* Read:

  + ``:help unimpaired``

* Support for multiple operating systems (Mac and Linux)
* Refinement of vimrc configuration
  
  * Indentation of reST files - changes indent levels but changes
    from implicit to explicit numbering (or unordered to ordered)
  * YouCompleteMe scratch/preview window open until end parethesis
  * Python support (refactoring etc)
  * PyMode and Rope for refactoring support

* Handle private aliases for Bashrc
* Handle private SSH configuration
* Determine other standard dependencies for development
* Automate installation of:

  * Virtualenv-wrapper
  * zest.releaser with aliases

Thanks
======

Thanks for all the various plugin mainainers for their awesome work.  My life
wouldn't be the same. Thanks also to the various resources below for allowing
me to tweak my configuration to be "just right":

* http://stevelosh.com/blog/2010/09/coming-home-to-vim
