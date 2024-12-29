#  ---------------------------------------------------------------------------
#  Description: This file holds all my ZSH exports.
#  Note:        Intended to be used in concert with Oh My Zsh
#  ---------------------------------------------------------------------------
#  Sections:
#  1.  Language & Encoding
#  2.  Python
#  3.  Tokens
#  4.  Manpager
#  5.  Editor
#  ---------------------------------------------------------------------------

#  --------------------------------------------------
#   1.  Language & Encoding
#  --------------------------------------------------

    # Prefer US English and use UTF-8
    export LANG='en_US.UTF-8';
    export LC_ALL='en_US.UTF-8';

#  --------------------------------------------------
#   2.  Python
#  --------------------------------------------------

    # Make Python use UTF-8 encoding for output
    # to stdin, stdout, and stderr.
    export PYTHONIOENCODING='UTF-8';
 
#  --------------------------------------------------
#   3. Tokens
#  --------------------------------------------------

    export GITHUB_API_TOKEN="GITHUB API TOKEN HERE"

#  --------------------------------------------------
#   4. Manpage
#  --------------------------------------------------

    # Don’t clear the screen after quitting a manual page.
    export MANPAGER='less -X';

#  --------------------------------------------------
#   5. Editor
#  --------------------------------------------------

    # Preferred editor for local and remote sessions
    if [[ -n $SSH_CONNECTION ]]; then
        export EDITOR='nano'
    else
        export EDITOR='subl'
    fi