function comp
    if test (count $argv) -lt 1; or test $argv[1] = '-h'; or  test $argv[1] = '--help'
        show_comp_document
        return
    else if test $argv[1] = '-v'; or  test $argv[1] = '--version'
        show_comp_version
        return
    else if test (count $argv) -lt 2
        echo 'comp error: Please specify a file or directory'
        return -1
    end
    if ! contains $argv[1] 'gz' 'bz2' 'xz' 'zst' 'tar.gz' 'tar.bz2' 'tar.xz' 'tar.zst' 'zip' '7z' 'zip.crypt' 'zip.aes' '7z.aes'
        echo 'comp error - Specified type is an unknown compression type : gz, bz2, xz, zst, tar.gz, tar.bz2, tar.xz, tar.zst, zip, 7z, zip.crypt, zip.aes, 7z.aes'
        return -1
    end
    if ! test -e $argv[2]
        echo 'comp error: A file or directory is not exists : '$argv[2]
        return -1
    end
    if contains $argv[1] 'gz' 'bz2' 'xz' 'zst'; and ! test -f $argv[2]
        echo 'comp error: Given path is not a file : '$argv[2]
        return -1
    end
    if contains $argv[1] 'tar.gz' 'tar.bz2' 'tar.xz' 'tar.zst'; and ! test -d $argv[2]
        echo 'comp error: Given path is not a directory : '$argv[2]
        return -1
    end

    if test (count $argv) -gt 2
       set options $argv[3..-1]
    else
       set options
    end

    switch $argv[1]
        case 'gz'
            pv $argv[2] -N (get_filename $argv[2]).gz | pigz $options > (get_filename $argv[2]).gz
        case 'bz2'
            pv $argv[2] -N (get_filename $argv[2]).bz2 | lbzip2 $options > (get_filename $argv[2]).bz2
        case 'xz'
            pv $argv[2] -N (get_filename $argv[2]).xz | pixz $options > (get_filename $argv[2]).xz
        case 'zst'
            pv $argv[2] -N (get_filename $argv[2]).zst | pzstd $options > (get_filename $argv[2]).zst
        case 'tar.gz'
            tar cf - $argv[2] | pv -s (command du -sb $argv[2] | cut -f 1) -N (get_filename $argv[2]).tar.gz | pigz $options > (get_filename $argv[2]).tar.gz
        case 'tar.bz2'
            tar cf - $argv[2] | pv -s (command du -sb $argv[2] | cut -f 1) -N (get_filename $argv[2]).tar.bz2 | lbzip2 $options > (get_filename $argv[2]).tar.bz2
        case 'tar.xz'
            tar cf - $argv[2] | pv -s (command du -sb $argv[2] | cut -f 1) -N (get_filename $argv[2]).tar.xz | pixz $options > (get_filename $argv[2]).tar.xz
        case 'tar.zst'
            tar cf - $argv[2] | pv -s (command du -sb $argv[2] | cut -f 1) -N (get_filename $argv[2]).tar.zst | pzstd $options > (get_filename $argv[2]).tar.zst
        case 'zip'
            7z a -tzip -r $options (get_filename $argv[2]).zip $argv[2]
        case 'zip.aes'
            read -p'echo "Password: "' -s pswd
            7z a -tzip -mem=AES256 -p(echo $pswd) -r- $options (get_filename $argv[2]).zip $argv[2]
        case 'zip.crypt'
            read -p'echo "Password: "' -s pswd
            7z a -tzip -mem=ZipCrypto -p(echo $pswd) -r- $options (get_filename $argv[2]).zip $argv[2]
        case '7z'
            7z a -t7z -m0=LZMA2 -r- $options (get_filename $argv[2]).7z $argv[2]
        case '7z.aes'
            read -p'echo "Password: "' -s pswd
            7z a -t7z -m0=LZMA2 -p(echo $pswd) -mhe=on -r- $options (get_filename $argv[2]).7z $argv[2]
    end
end

function get_filename
    if test -d $argv[1]
        basename (realpath $argv[1])
    else
        basename $argv[1]
    end
end

function show_comp_version
    echo "comp v0.1.0"
end

function show_comp_document
  echo "\
  Usage:
    comp <COMPRESSION TYPE> <file or directory> [OPTIONS]

    -h, --help         show help of comp
    -v, --version      show version of comp

  COMPRESSION TYPE
    gz                 compress to gzip using pigz
    bz2                compress to bzip2 using lbzip2
    xz                 compress to xz using pixz
    zst                compress to zstd using pzstd
    tar.gz             create a tar archive and compress to gzip using pigz
    tar.bz2            create a tar archive and compress to bzip2 using lbzip2
    tar.xz             create a tar archive and compress to xz using pixz
    tar.zst            create a tar archive and compress to zstd using pzstd
    zip                compress to zip using p7zip
    zip.crypt          compress to zip and encrypt ZipCrypt, using p7zip
    zip.aes            compress to zip and encrypt AES, using p7zip
    7z                 compress to 7z using p7zip
    7z.aes             compress to 7z and encrypt AES, using p7zip

  OPTIONS FOR gz, tar.gz
    Options are passed to pigz. Confirm 'pigz -h' for details.

  OPTIONS FOR bz2, tar.bz2
    Options are passed to lbzip2. Confirm 'lbzip2 -h' for details.

  OPTIONS FOR xz, tar.xz
    Options are passed to pixz. Confirm 'pixz -h' for details.

  OPTIONS FOR zst, tar.zst
    Options are passed to pzstd. Confirm 'pzstd -h' for details.

  OPTIONS FOR zip, zip.crypt, zip.aes
    Options are passed to p7zip. Confirm '7za -h' for details.
    ( -tzip is already specified )

  OPTIONS FOR 7z, 7z.aes
    Options are passed to p7zip. Confirm '7z -h' for details.
    ( -t7z -r -m0=LZMA2 is already specified )

  DEPENDENCIES
    This command uses 'pv' 'pigz', 'lbzip2', 'pixz', 'zstd', 'p7zip' internally.
    So you should install them before use this.
    If you use Debian/Ubuntu, you can install like this

      sudo apt-get install -y pv pigz lbzip2 pixz zstd p7zip-full
  "
end
