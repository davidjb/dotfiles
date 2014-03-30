davidjb's dotfiles
==================

Run the included ``bootstrap.sh`` script and it will install the included settings files
into the current user's home directory::  

     git clone https://github.com/davidjb/dotfiles.git
     ./dotfiles/bootstrap.sh

Pass the script a directory name or path to customise install location::

    ./bootstrap.sh /path/to/install


Copyright
=========

Nope, nothing.  Just use what you'd like, how you'd like to use it.
Spot and report an error and win a gold star.


Notes
=====

* Vim:
  
  * ``box`` and ``bbox`` snippets for a comment box
  * Check syntax reporting with ``:SyntasticInfo``
  * Fix PEP8 issues in Python with ``:PymodeLintAuto``

* Bash:
  
  * Put private bash files into ``.bash_private``. Anything inside this folder
    will be ``source``'d automatically.

To Do
=====

* Support for multiple operating systems (Mac and Linux)
* Refinement of vimrc configuration
  
  * Indentation of reST files - changes indent levels but changes
    from implicit to explicit numbering (or unordered to ordered)
  * reST files: backspacing before a nested list double-backspaces
  * YouCompleteMe scratch/preview window open until end parethesis
  * Python support (refactoring etc)
  * Rykka/riv support for Sphinx documentation (syntax checking, C-E key?)
  * PyMode and Rope for refactoring support

* Handle private aliases for Bashrc
* Handle private SSH configuration
* Determine other standard dependencies for development
* Automate installation of:

  * Virtualenv-wrapper

