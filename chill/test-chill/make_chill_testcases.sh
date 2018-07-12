#!/bin/bash

is_test_file() {
    if [ -z "`sed -n "s/^destination(.*)/\0/p" $1`" ]; then
        echo 0
    else
        echo 1
    fi
}

is_skip_test() {
    if [ -z "`sed -n "s/^#>SKIP/\0/p" $1`" ]; then
        echo 0
    else
        echo 1
    fi
}

is_exfail_test() {
    if [ -z "`sed -n "s/^#>EXFAIL/\0/p" $1`" ]; then
        echo 0
    else
        echo 1
    fi
}

echo "## autogenerated from test-chill/make_chill_testcases.sh $@" ## make_test_file

chill_exec=$1
test_dir=$2
answers_dir=$3

for test_file_path in `ls $test_dir/*.py`
do
    if [ "`is_test_file $test_file_path`" == 1 ]; then
        test_file=`basename $test_file_path`
        
        run_test_file="test-chill/$test_file.run.test"
        diff_test_file="test-chill/$test_file.diff.test"
        stdout_test_file="test-chill/$test_file.stdout.test"
        stderr_test_file="test-chill/$test_file.stderr.test"
        compile_test_file="test-chill/$test_file.compile.test"

        run_chill_exec="\$SRCDIR/test-chill/runchilltest.sh ./$chill_exec \$SRCDIR/$test_dir/$test_file \$SRCDIR/$answers_dir"
        run_chill_flags=""
        [ `is_skip_test $test_file_path`   == 1            ] && run_chill_flags="$run_chill_flags skip"
        [ `is_exfail_test $test_file_path` == 1            ] && run_chill_flags="$run_chill_flags exfail"
        [ "$chill_exec"                    == "cuda-chill" ] && run_chill_flags="$run_chill_flags cuda"
        
        echo "#!/bin/bash"                                      >  $run_test_file # make new file
        echo "$run_chill_exec check-run  $run_chill_flags"      >> $run_test_file
        echo "exit \$?"                                         >> $run_test_file
        chmod +x $run_test_file
        
        echo "#!/bin/bash"                                      >  $diff_test_file # make new file
        echo "$run_chill_exec check-diff $run_chill_flags"      >> $diff_test_file
        echo "exit \$?"                                         >> $diff_test_file
        chmod +x $diff_test_file

        echo "#!/bin/bash"                                      >  $stdout_test_file # make new file
        echo "$run_chill_exec check-stdout $run_chill_flags"    >> $stdout_test_file
        echo "exit \$?"                                         >> $stdout_test_file
        chmod +x $stdout_test_file

        ## turn stderr off for now
        #echo "#!/bin/bash"                                      >  $stderr_test_file # make new file
        #echo "$run_chill_exec check-stderr $run_chill_flags"    >> $stderr_test_file
        #echo "exit \$?"                                         >> $stderr_test_file
        #chmod +x $stderr_test_file
        
        ## only do compile checks for chill for now
        if [ "$chill_exec" != "cuda-chill" ]; then
            echo "#!/bin/bash"                                      >  $compile_test_file
            echo "$run_chill_exec check-compile $run_chill_flags"   >> $compile_test_file
            echo "exit \$?"                                         >> $compile_test_file
            chmod +x $compile_test_file
        fi
        
        echo "TESTS += $run_test_file"                      ## make_test_file
        if [ `is_skip_test $test_file_path` != 1 ]; then
            echo "TESTS += $diff_test_file"
            echo "TESTS += $stdout_test_file"
            ## turn stderr tests off for now
            # echo "TESTS += $stderr_test_file"
            ## turn cuda chill compilation off for now
            if [ "$chill_exec" != "cuda-chill" ]; then
                echo "TESTS += $compile_test_file"
            fi
        fi
        
    fi
done

