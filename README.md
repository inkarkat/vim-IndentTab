INDENT TAB
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

This plugin allows you to use your normal tab settings ('tabstop',
'smarttabstop', 'expandtab') for the beginning of the line (up to the first
non-whitespace character), and have &lt;Tab&gt; expanded to the appropriate number
of spaces (i.e. like :set expandtab) anywhere else. This effectively
distinguishes "indenting" from "alignment"; the characters inserted by &lt;Tab&gt;
depend on the local context.

### HOW IT WORKS

This plugin overrides the default behavior of the &lt;Tab&gt; and &lt;BS&gt; keys in
insert mode.

### RELATED WORKS

- ctab.vim ([vimscript #231](http://www.vim.org/scripts/script.php?script_id=231)) by Michael Geddes exists since 2002. It also
  offers global and buffer-local mappings, but uses a slightly different
  approach, does not handle comment[prefixes], instead has some
  filetype-specific stuff. It also remaps &lt;CR&gt;, o and O, and additionally
  offers a :RetabIndent command.
- http://vim.wikia.com/wiki/Converting_tabs_to_spaces

USAGE
------------------------------------------------------------------------------

    The indent tab can be en-/disabled globally or only for a particular buffer.
        call IndentTab#Set( isTurnOn, isGlobal )
    You probably want to define your own mappings / commands for that, or do this
    for certain filetypes only.

    <Tab>                   Uses normal tab settings at the beginning of the line
                            (before the first non-whitespace character), and
                            inserts spaces otherwise.
    <BS>                    Uses normal tab settings to delete tabs at the
                            beginning of the line; elsewhere it also removes
                            "space-expanded" tabs as if 'softtabstop' were
                            enabled.
                            The exact circumstances under which the normal tab
                            settings apply are configured by the
                            g:IndentTab_scopes setting.

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-IndentTab
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim IndentTab*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.030 or
  higher.

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

Determine where the buffer's indent settings are applied. Elsewhere, spaces
are used for alignment. Comma-separated list of the following values:
    indent:         Initial whitespace at the beginning of a line.
    commentprefix:  Initial whitespace after a comment prefix, in case the line
                    begins with the comment prefix, not any indent.
    comment:        Inside comments, as determined by syntax highlighting.
    string:         Inside strings, as determined by syntax highlighting. >
    let g:IndentTab_scopes = 'indent,commentprefix,string'

INTEGRATION
------------------------------------------------------------------------------

To determine whether the 'indenttab' setting is active in the current buffer,
you can call IndentTab#Info#IndentTab(), which yields a boolean value. This
can be used as a replacement for a hypothetical ":set indenttab?", e.g. in a
custom 'statusline'.

### SUPERTAB INTEGRATION

Plugins like SuperTab ([vimscript #1643](http://www.vim.org/scripts/script.php?script_id=1643)) overload the &lt;Tab&gt; key with
insert-mode completion and fall back to inserting a literal &lt;Tab&gt; character.
This is in conflict with this plugin's maps. To integrate, set

    let g:IndentTab_IsSuperTab = 1

This avoids that IndentTab overrides the &lt;Tab&gt; mapping. Inside SuperTab,
instead of returning a literal &lt;Tab&gt;, you need to use the function
IndentTab#SuperTabIntegration#GetExpr() instead.

TODO
------------------------------------------------------------------------------

- Implement better way of en-/dis-abling. :IndentTab[!] :IndentTabLocal[!]?

### CONTRIBUTING

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-IndentTab/issues or email (address below).

HISTORY
------------------------------------------------------------------------------

##### 1.11    RELEASEME
- ENH: Support a:stopItemPattern in ingointegration#IsOnSyntaxItem(). Stop
  looking for comment syntax name below /FoldMarker$/.

__You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.037!__

##### 1.10    02-May-2013
- The scope tests that use syntax highlighting can be wrong when there's no
  separating whitespace. To properly detect the scope, we need to first insert
  whitespace, then perform the scope tests that use syntax highlighting.
- FIX: In IndentTab#SuperTabIntegration#GetExpr(), prefer buffer-local setting
  over global one to correctly implement the precedence.
- Add dependency to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)).

##### 1.00    28-Sep-2012
- First published version.

##### 0.01    20-Aug-2008
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2008-2022 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
