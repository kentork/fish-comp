function decomp
    if test (count $argv) -lt 1; or test $argv[1] = '-h'; or  test $argv[1] = '--help'
        show_decomp_document
        return
    else if test $argv[1] = '-v'; or  test $argv[1] = '--version'
        show_decomp_version
        return
    end
    if test $argv[1] = '_'
        set argv[1] 'auto'
    end
    if ! contains $argv[1] 'auto' 'gz' 'bz2' 'xz' 'zst' 'tar.gz' 'tar.bz2' 'tar.xz' 'tar.zst' 'zip' '7z'
        set -p argv 'auto'
    end
    if ! test -e $argv[2]; or ! test -f $argv[2]
        echo 'decomp error: An archive file is not exists : '$argv[2]
        return -1
    end
    if test (count $argv) -lt 3
        set -a argv './'
    end
    if test -e $argv[3]; and ! test -d $argv[3]
        echo 'decomp error: Target path is not a directory : '$argv[2]
        return -1
    end
    if ! test -e $argv[3]
        echo 'decomp error: Target directory is not exists : '$argv[3]
        read -l -P '  Create a new directory? [y/N] ' confirm
        switch $confirm
            case Y y
                mkdir -p $argv[3]
                echo ''
            case '' N n
                echo ''
                echo 'decomp error: Aborted'
                return -1
        end
    end

    # `file` command can not detect zst file type
    if test (string sub -s -3 $argv[2]) = 'zst'
        set argv[1] 'zst'
        if test (string sub -s -7 -l 3 $argv[2]) = 'tar'
           set argv[1] 'tar.'$argv[1]
       end
    end

    if test $argv[1] = 'auto'
        switch (file $argv[2] -b | cut -f 1 -d ' ')
            case '7-zip'
                set argv[1] '7z'
            case 'Zip'
                set argv[1] 'zip'
            case 'gzip'
                set argv[1] 'gz'
            case 'bzip2'
                set argv[1] 'bz2'
            case 'XZ'
                set argv[1] 'xz'
            case '*'
                echo 'decomp error: Can not detect file type. Please specify the compression type'
                return -1
        end

        if contains $argv[1] 'gz' 'bz2' 'xz'; and test (file $argv[2] -b -z | cut -f 2 -d ' ') = 'tar'
           set argv[1] 'tar.'$argv[1]
        end
    end

    if test (count $argv) -gt 3
       set options $argv[4..-1]
    else
       set options
    end

    switch $argv[1]
        case 'gz'
            set target (join_path $argv[3] (string replace -r '.gz$' '' $argv[2]))
            pv $argv[2] -N $argv[2] | pigz -d $options > $target
        case 'bz2'
            set target (join_path $argv[3] (string replace -r '.bz2$' '' $argv[2]) )
            pv $argv[2] -N $argv[2] | lbzip2 -d $options > $target
        case 'xz'
            set target (join_path $argv[3] (string replace -r '.xz$' '' $argv[2]) )
            pv $argv[2] -N $argv[2] | pixz -d $options > $target
        case 'zst'
            set target (join_path $argv[3] (string replace -r '.zst$' '' $argv[2]) )
            pv $argv[2] -N $argv[2] | pzstd -d $options > $target
        case 'tar.gz'
            pv $argv[2] -N $argv[2] | tar xf - --use-compress-prog=pigz -C $argv[3]
        case 'tar.bz2'
            pv $argv[2] -N $argv[2] | tar xf - --use-compress-prog=lbzip2 -C $argv[3]
        case 'tar.xz'
            pv $argv[2] -N $argv[2] | tar xf - --use-compress-prog=pixz -C $argv[3]
        case 'tar.zst'
            pv $argv[2] -N $argv[2] | tar xf - --use-compress-prog=pzstd -C $argv[3]
        case 'zip'
            7za x -tzip -o(echo $argv[3]) $options $argv[2]
        case '7z'
            7za x -t7z -o(echo $argv[3]) $options $argv[2]
    end
end

function join_path
    set directory (string replace -r '/$' '' $argv[1])
    string join / $directory $argv[2]
end

function show_decomp_version
    echo "decomp v0.1.0"
end

function show_decomp_document
  echo "\
  Usage:
    decomp <file or directory> [options]
    decomp <COMPRESSION TYPE> <file or directory> [options]

    -h, --help         show help of comp
    -v, --version      show version of comp

  COMPRESSION TYPE
    gz                 decompress from the gzip file using pigz
    bz2                decompress from the bzip2 file using lbzip2
    xz                 decompress from the xz file using pixz
    zst                decompress from the zst file using pzstd
    tar.gz             decompress from the gzip file using pigz and extract from the tar archive
    tar.bz2            decompress from the bzip2 file using lbzip2 and extract from the tar archive
    tar.xz             decompress from the xz file using pixz and extract from the tar archive
    tar.zst            decompress from the zst file using pzstd and extract from the tar archive
    zip                decompress from the zip file using p7zip
    7z                 decompress from the 7zip file using p7zip

    ( if empty, decomp will detect automatically )

  OPTIONS FOR gz, tar.gz
    Options are passed to pigz. Confirm 'pigz -h' for details.

  OPTIONS FOR bz2, tar.bz2
    Options are passed to lbzip2. Confirm 'lbzip2 -h' for details.

  OPTIONS FOR xz, tar.xz
    Options are passed to pixz. Confirm 'pixz -h' for details.

  OPTIONS FOR zst, tar.zst
    Options are passed to pzstd. Confirm 'pzstd -h' for details.

  OPTIONS FOR zip
    Options are passed to p7zip. Confirm '7za -h' for details.
    ( -tzip is already specified )

  OPTIONS FOR 7z
    Options are passed to p7zip. Confirm '7za -h' for details.
    ( -t7z is already specified )

  DEPENDENCIES
    This command uses 'pv' 'pigz', 'lbzip2', 'pixz', 'zstd', 'p7zip' internally.
    So you should install them before use this.
    If you use Debian/Ubuntu, you can install like this

      sudo apt-get install -y pv pigz lbzip2 pixz zstd p7zip-full
  "
end
