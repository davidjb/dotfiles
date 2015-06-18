Useful information
==================

Tmux
----

https://github.com/tmux-plugins/tmux-resurrect
https://github.com/tmux-plugins/tmux-yank
https://github.com/tmux-plugins/tmux-copycat

Firefox
-------

* Adblock Plus
* Session Manger
* Firebug
* VimFx

Chrome
------

* Adblock Plus
* Freshstart Session Manager

Bash
----

* ``apropos`` -- search man pages for commands
* ``cd -`` returns to previous directory
* ``\command`` - appending a backslash avoids aliasing
* ``shopt`` - configure shell options

  * ``shopt -s`` - **sets** a given option
  * ``shopt -u`` - **unsets** a given option

* ``jobs`` - outputs the currently running jobs

  * ``%id`` or ``fg [id]`` - will bring the a given process back into
    foreground
  * ``C^Z`` - will suspend the current process
  * ``bg [id]`` - will place the suspended process into the background

* Put private bash files into ``.bash_private``. Anything inside this folder
  will be ``source``'d automatically.
* ``!$`` - last argument of last command

Default Emacs bindings
~~~~~~~~~~~~~~~~~~~~~~

* ``^/`` - undo
* ``^P``, ``^N`` - previous/next
* ``M+b``, ``M+f`` - move forward backwards, forwards
* ``^w``, ``M+d`` -  - delete word backards, forwards

Vim
---

* ``.vimrc`` files can be locally added to any directory. Files within the
  directory or its children will automatically use that configuration as well
  as the user-level configuration.
* ``box`` and ``bbox`` snippets for a comment box
* ``:SyntasticInfo`` - check syntax reporting
* ``:PymodeLintAuto`` - fix PEP8 issues in Python
* ``pclose`` will close the preview window
* Surroundings:

  + ``yswt`` - the ``t`` is for literal text
  + ``yswe`` - the ``e`` is for strongly emphasised text
  + ``yswf`` - the ``f`` is for functions
  + ``yswt`` - the ``t`` is for markup tags

* Windows:

  + Resize with ``<c-w>_ | =``
  + Swap with ``<c-w>R``
  + Break out into tab: ``<c-w>T``
  + Close all windows except current: ``<c-w>o``
  + Save state with ``:Obsession /save/path``

Vim and Buildout
----------------

#. See https://github.com/davidjb/buildout-vim for a how-to.

Pass
----

::

    pass init [GPG key IDs]
    pass git init

Mass editing files
------------------

Use ``grepedit`` to easily modify a whole bunch of files using your configured
EDITOR.

Ubuntu on Macbook
-----------------

* https://help.ubuntu.com/community/AppleKeyboard#Corrections
* https://help.ubuntu.com/community/MacBook4-1
