# stateof

Static copy of legacy State of the Commons site


## Overview

The legacy State of the Commons site was a combination of three (3) seperate
WordPress sites.

This static copy was created by:
1. Mirroring the site with `wget`:
    ```shell
    ./bin/mirror_with_wget.sh
    ```
   - [GNU Wget Manual](http://www.gnu.org/software/wget/manual/wget.html)
2. Updating the files using GNU sed
    ```shell
    ./bin/update_for_static.sh
    ```

These commands should ***not*** be run again. Any corrections should be
incorporated into a new script.


## Copying & License


### Bin Scripts Copying

[![CC0 1.0 Universal (CC0 1.0) Public Domain Dedication
button][cc-zero-png]][cc-zero]

[`COPYING`](COPYING): The bin scripts within this repository is dedicated to
the public domain under the [CC0 1.0 Universal (CC0 1.0) Public Domain
Dedication][cc-zero].

[cc-zero-png]: https://licensebuttons.net/l/zero/1.0/88x31.png "CC0 1.0 Universal (CC0 1.0) Public Domain Dedication button"
[cc-zero]: https://creativecommons.org/publicdomain/zero/1.0/


### Docs Content License

[![CC BY 4.0 license button][cc-by-png]][cc-by]

Except where otherwise stated, content on this site is licensed under a
[Creative Commons Attribution 4.0 International License][cc-by].

[cc-by-png]: https://licensebuttons.net/l/by/4.0/88x31.png#floatleft "CC BY 4.0 license button"
[cc-by]: https://creativecommons.org/licenses/by/4.0/ "Creative Commons Attribution 4.0 International License"
