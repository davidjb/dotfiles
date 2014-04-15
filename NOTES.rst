Useful information
==================

Bash
----

dotfiles
~~~~~~~~

* Put private bash files into ``.bash_private``. Anything inside this folder
  will be ``source``'d automatically.


Built-ins
~~~~~~~~~

* ``cd -`` returns to previous directory
* ``\command`` - appending a backslash avoids aliasing
* ``basename`` and ``dirname`` for filename and directory respectively
  from a given path

* ``^R`` - reverse history search
* Emacs mode:

  * ``C-p`` and ``C-n`` - previous and next command cycling
  * ``C-f``, ``C-b`` - next/previous characters
  * ``M-f``, ``M-b`` - next/previous word


Vim
---

* ``box`` and ``bbox`` snippets for a comment box
* ``:SyntasticInfo`` - check syntax reporting
* ``:PymodeLintAuto`` - fix PEP8 issues in Python
* ``q[:/?]`` - opens quickedit window for commands, search
* ``;`` is now the ``<leader>`` key


General commands
----------------

* ``chown`` and ``chmod`` can use ``--reference=file`` to copy permissions or
  ownership.
* ``cat /etc/*-release`` will reveal the distribution and version of any
  Linux machine.
