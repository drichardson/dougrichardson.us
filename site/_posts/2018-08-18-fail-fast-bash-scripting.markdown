---
layout: post
title: "Fail Fast Bash Scripting"
---
[Fail-fast](https://en.wikipedia.org/wiki/Fail-fast) code makes errors apparent and therefore easier to fix.
Bash's [set builtin](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)
allows script writers to terminate Bash when an error occurs.

However, there are some gotchas.

# set -e

`set -e` tells Bash to exit on non-zero status. example1.sh terminates
before `cut`, since `ls` returns a non-zero status when given an invalid directory argument.


    #!/bin/bash
    # example1.sh
    set -e
    ls /invalidDirectory  > out.txt
    cut -c 1 out.txt

Output

    $ ./example1.sh
    ls: cannot access '/invalidDirectory': No such file or directory


### Pipeline Gotcha

However, in a [pipeline](https://www.gnu.org/software/bash/manual/html_node/Pipelines.html), `set -e` might not
behave as you expect.

    #!/bin/bash
    # pipeline1.sh - runs to completion
    set -e
    ls /invalidDirectory | cut -c 1
    echo COMPLETE

Output

    $ ./pipeline1.sh
    ls: cannot access '/invalidDirectory': No such file or directory
    COMPLETE

Why does pipeline1.sh run to completion? After all, `ls` returned a non-zero status. The answer is that `cut` returned
a zero status and Bash uses the status of the last command in the pipeline as the status for the entire pipeline.

You can view each individual pipeline command's status using the [PIPESTATUS](https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html#Bash-Variables) array variable. For example, changing pipeline1.sh to print out the
PIPESTATUS:

    #!/bin/bash
    # pipeline1-with-status.sh - runs to completion, print statuses
    set -e
    ls /invalidDirectory | cut -c 1
    echo COMPLETE pipeline_status=$? ls_status=${PIPESTATUS[0]} cut_status=${PIPESTATUS[1]}

Output

    $ ./pipeline1-with-status.sh
    ls: cannot access '/invalidDirectory': No such file or directory
    COMPLETE pipeline_status=0 ls_status=2 cut_status=0
    

# set -o pipefail

To change the default behavior of Bash so that it treats any non-zero status in a pipeline like a total pipeline failure, use `set -o pipefail`. Running a modified pipeline1.sh that uses `set -o pipefail`:

    #!/bin/bash
    # pipeline2.sh - exits due to ls failure
    set -e
    set -o pipefail
    ls /invalidDirectory | cut -c 1
    echo COMPLETE

produces the following output:

    $ ./pipeline2.sh
    ls: cannot access '/invalidDirectory': No such file or directory

# set -u
Using `set -u` causes Bash to exit if you use an unbound variable. For example, the following script:

    #!/bin/bash
    # unbound.sh - causes unbound variable error
    set -u
    echo Print Unbound $MYUNBOUNDVARIABLE
    echo COMPLETE

produces:

    $ ./unbound.sh
    ./unbound.sh: line 4: MYUNBOUNDVARIABLE: unbound variable

### Gotcha: Testing Positional Parameters

While useful, this does cause some headaches, most notibly when testing positional parameters. For example, positional-unbound1.sh below, I'd like to provide a useful error message to the script user if they forgot to supply a positional parameter:


    #!/bin/bash
    # positional-unbound.sh - unbound variable terminates script before message printed
    set -u
    
    ARG1=$1
    shift
    
    if [[ -z $ARG1 ]]; then
        echo "Missing arugment."
        exit 1
    fi
    
    echo "COMPLETE ARG1=$ARG1"

running with no arguments produces:

    $ ./positional-unbound.sh
    ./positional-unbound.sh: line 5: $1: unbound variable


To get around this, you can temporarily disable `set -u` with `set +u` or you can change your code to test the number of
remaining positional parameters.


    #!/bin/bash
    # positional-unbound-fixed.sh
    set -u
    
    usage() {
        echo "Usage: command <ARG1> <ARG2>"
    }
    
    missingPositional() {
        echo Missing $1
        usage
        exit 1
    }
    
    [[ $# -gt 0 ]] || missingPositional ARG1
    ARG1=$1
    shift
    
    [[ $# -gt 0 ]] || missingPositional ARG2
    ARG2=$1
    shift
    
    echo "COMPLETE ARG1=$ARG1 ARG2=$ARG2"

Now running with no arguments outputs the error message:

    $ ./positional-unbound-fixed.sh
    Missing ARG1
    Usage: command <ARG1> <ARG2>





## See Also

- [Bash Reference Manual: The Set Builtin](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)
- [Bash Reference Manual: Special Parameters](https://www.gnu.org/software/bash/manual/html_node/Special-Parameters.html#Special-Parameters)
- [Safer bash scripts with 'set -euxo pipefail'](https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/)
- [What is the difference between test, \[ and \[\[ ?](https://mywiki.wooledge.org/BashFAQ/031)





