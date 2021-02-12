---
layout: note
title: "Fail Fast Bash Scripting"
---

[Fail-fast](https://en.wikipedia.org/wiki/Fail-fast) code makes errors apparent and therefore easier to fix.
Bash's [set builtin](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)
has a few options to help you write fail-fast scripts.

# Summary

Put this at the top of your fail-fast Bash scripts:

```bash
#!/bin/bash
set -euo pipefail
shopt -s inherit_errexit
```

Use `[[ $# -gt 0 ]]` to test existence of positional parameters.

To understand why, read on.


# set -e

`set -e` tells Bash to exit on non-zero status. example1.sh terminates
before `cut`, since `ls` returns a non-zero status when given an invalid directory argument.


```bash
#!/bin/bash
# example1.sh
set -e
ls /invalidDirectory  > out.txt
cut -c 1 out.txt
```

Output:

```bash
$ ./example1.sh
ls: cannot access '/invalidDirectory': No such file or directory
```

However, `set -e` is complicated[^1]. The next sections will try to deal with some of the gotchas.


### Gotcha: Pipelines

In a [pipeline](https://www.gnu.org/software/bash/manual/html_node/Pipelines.html), `set -e` might not
behave as you expect.

```bash
#!/bin/bash
# pipeline1.sh - runs to completion
set -e
ls /invalidDirectory | cut -c 1
echo COMPLETE
```

Output:

```bash
$ ./pipeline1.sh
ls: cannot access '/invalidDirectory': No such file or directory
COMPLETE
```

Why does pipeline1.sh run to completion? After all, `ls` returned a non-zero status. The answer is that Bash uses the status of the *last* command in the pipeline as the status for the entire pipeline. In this case, the last command in the pipeline is `cut`, which returns status zero.

Each individual pipeline command's status is stored [PIPESTATUS](https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html). Changing pipeline1.sh to print out the
PIPESTATUS:

```bash
#!/bin/bash
# pipeline1-with-status.sh - runs to completion, print statuses
set -e
ls /invalidDirectory | cut -c 1
echo COMPLETE pipeline_status=$? ls_status=${PIPESTATUS[0]} cut_status=${PIPESTATUS[1]}
```

Output:

```bash
$ ./pipeline1-with-status.sh
ls: cannot access '/invalidDirectory': No such file or directory
COMPLETE pipeline_status=0 ls_status=2 cut_status=0
```

### Gotcha: Command Substitution

`set -e` does not affect subshells created by [Command Substitution](https://www.gnu.org/software/bash/manual/html_node/Command-Substitution.html). This rule is stated in [Command Execution Environment](https://www.gnu.org/software/bash/manual/html_node/Command-Execution-Environment.html):

> Subshells spawned to execute command substitutions inherit the value of the -e option from the parent shell. When not in POSIX mode, Bash clears the -e option in such subshells.

This rule means that the following script will run to completion, in spite of INVALIDCOMMAND.

```bash
#!/bin/bash
# command-substitution.sh
set -e
MYVAR=$(echo -n Start; INVALIDCOMMAND; echo -n End)
echo "MYVAR is $MYVAR"
```

Output:

```bash
./command-substitution.sh: line 4: INVALIDCOMMAND: command not found
MYVAR is StartEnd
```

# set -o pipefail

To change the default behavior of Bash so that it treats any non-zero status in a pipeline like a total pipeline failure, use `set -o pipefail`. Running a modified pipeline1.sh that uses `set -o pipefail`:

```bash
#!/bin/bash
# pipeline2.sh - exits due to ls failure
set -e
set -o pipefail
ls /invalidDirectory | cut -c 1
echo COMPLETE
```

Output:

```bash
$ ./pipeline2.sh
ls: cannot access '/invalidDirectory': No such file or directory
```

# shopt -s inherit_errexit

`shopt -s inherit_errexit`, [added in Bash 4.4](https://lists.gnu.org/archive/html/bug-bash/2016-09/msg00018.html)
allows you to have command substitution parameters inherit your `set -e` from the parent script.

From the [Shopt Builtin documentation](https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html):

> If set, command substitution inherits the value of the errexit option, instead of unsetting it in the subshell environment. This option is enabled when POSIX mode is enabled.

So, modifying command-substitution.sh above, we get:

```bash
#!/bin/bash
# command-substitution-inherit_errexit.sh
set -e
shopt -s inherit_errexit
MYVAR=$(echo -n Start; INVALIDCOMMAND; echo -n End)
echo "MYVAR is $MYVAR"
```

Output:

```bash
./command-substitution-inherit_errexit.sh: line 5: INVALIDCOMMAND: command not found
```

# set -u
Using `set -u` causes Bash to exit if you use an unbound variable. For example, the following script:

```bash
#!/bin/bash
# unbound.sh - causes unbound variable error
set -u
echo Print Unbound $MYUNBOUNDVARIABLE
echo COMPLETE
```

Output:

```bash
$ ./unbound.sh
./unbound.sh: line 4: MYUNBOUNDVARIABLE: unbound variable
```

### Gotcha: Testing Positional Parameters

While useful, terminating on unbound variables does cause some headaches, most notably when testing positional parameters. For example, in positional-unbound1.sh below, I'd like to provide a useful error message to the script user if they forget to supply a positional parameter:

```bash
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
```

Output:

```bash
$ ./positional-unbound.sh
./positional-unbound.sh: line 5: $1: unbound variable
```


To get around this, you can temporarily disable `set -u` with `set +u` or you can change your code to test the number of
remaining positional parameters, like so:


```bash
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
```

Output:

```bash
$ ./positional-unbound-fixed.sh
Missing ARG1
Usage: command <ARG1> <ARG2>
```

# References
- [Bash Reference Manual: Special Parameters](https://www.gnu.org/software/bash/manual/html_node/Special-Parameters.html)
- [Command substitution is stripping set -e from options](https://lists.gnu.org/archive/html/bug-bash/2015-10/msg00003.html)
- [Safer bash scripts with 'set -euxo pipefail'](https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/)
- [Why doesn't set -e (or set -o errexit, or trap ERR) do what I expected?](https://mywiki.wooledge.org/BashFAQ/105)..


# Footnotes

[^1]: Some bash scripters recommend against using `set -e` and instead suggest scripts check every status code they're interested in.

