David's dotfiles
================

Run the included ``bootstrap.sh`` script and it will install the included settings files
into the current user's home directory::  

     git clone https://github.com/davidjb/dotfiles.git
     ./dotfiles/bootstrap.sh

Pass the script a directory name or path to customise install location::

    ./bootstrap.sh /path/to/install


To Do
=====

* Refinement of vimrc configuration
  
  * Indentation of reST files - changes indent levels but changes
    from implicit to explicit numbering (or unordered to ordered)
  * reST files: backspacing before a nested list double-backspaces
  * Indentation support - eg follow existing indents in Python or
    other data structures
  * YouCompleteMe scratch/preview window open until end parethesis
  * YouCompleteMe syntax highlighting and error detection
  * Python support (refactoring etc)
  * Rykka/riv support for Sphinx documentation (syntax checking, C-E key?)

* Handle private aliases for Bashrc
* Handle private SSH configuration
* Determine other standard dependencies for development
* Automate installation of:

  * Virtualenv-wrapper
  * grin
  *

Copyright
=========

Nope, nothing.  Just use what you'd like, how you'd like to use it.
Spot and report an error and win a gold star.


Notes
=====

* ``box`` and ``bbox`` snippets for a comment box
