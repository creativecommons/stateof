# stateof

Static copy of legacy Creative Commons (CC) State of the Commons (SotC) sites:
- https://stateof.creativecommons.org/ (2017)
- https://stateof.creativecommons.org/2016/
- https://stateof.creativecommons.org/2015/


## Overview

The legacy State of the Commons sites were a collection of three (3) seperate
WordPress sites. They were converted to static content using the [Initial
Creation](#initial-creation) process, below.

**For a complete list of CC Annual Reports / State of the Commons, see:
[Creative Commons Annual Report Archives - Creative
Commons][tag-annual-report].**

[tag-annual-report]: https://creativecommons.org/tag/creative-commons-annual-report/


## Data Files

Data files for the 2015-2017 State of the Commons reports can be found in:
- [cc-archive/sotc-2015](https://github.com/cc-archive/sotc-2015)
- [cc-archive/sotc-2016](https://github.com/cc-archive/sotc-2016)
- [cc-archive/sotc-2017](https://github.com/cc-archive/sotc-2017)


## Initial Creation

:warning: **The commands below should NOT be run again.** Any corrections
should be incorporated into new scripts.

This static copy was created by:
1. Mirroring the site with `wget`:
    ```shell
    ./bin/mirror_with_wget.sh
    ```
   - [GNU Wget Manual](http://www.gnu.org/software/wget/manual/wget.html)
2. Updating the files using GNU sed
    ```shell
    ./bin/create_static_site.sh
    ```
   - [sed, a stream editor](https://www.gnu.org/software/sed/manual/sed.html)
     (manual)


## Copying & License


### Bin Scripts Copying

[![CC0 1.0 Universal (CC0 1.0) Public Domain Dedication
button][cc-zero-png]][cc-zero]

[`bin/COPYING`](bin/COPYING): The bin scripts within this repository are
dedicated to the public domain under the [CC0 1.0 Universal (CC0 1.0) Public
Domain Dedication][cc-zero].

[cc-zero-png]: https://licensebuttons.net/l/zero/1.0/88x31.png "CC0 1.0 Universal (CC0 1.0) Public Domain Dedication button"
[cc-zero]: https://creativecommons.org/publicdomain/zero/1.0/


### Docs Content License

[![CC BY 4.0 license button][cc-by-png]][cc-by]

[`LICENSE`](LICENSE): Except where otherwise stated, content on this site is
licensed under a [Creative Commons Attribution 4.0 International
License][cc-by].

[cc-by-png]: https://licensebuttons.net/l/by/4.0/88x31.png#floatleft "CC BY 4.0 license button"
[cc-by]: https://creativecommons.org/licenses/by/4.0/ "Creative Commons Attribution 4.0 International License"
