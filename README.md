# fish-comp

Make it easy to use compression and decompression.

## Usage

### comp

```
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
```

### decomp

```
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
```

## Installation

Using Fisherman (recommended method)

```
fisher install kentork/fish-comp
```
