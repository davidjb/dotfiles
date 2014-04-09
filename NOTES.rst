Useful information
==================

Bash
----

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


Vim
---

* ``box`` and ``bbox`` snippets for a comment box
* ``:SyntasticInfo`` - check syntax reporting
* ``:PymodeLintAuto`` - fix PEP8 issues in Python

  
