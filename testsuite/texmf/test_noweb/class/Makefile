### Makefile -- Prepare Samhain LaTeX classes

# Author: Michael Grünewald
# Date: Fri Nov 28 10:17:37 CET 2014

# BSD Owl Scripts (https://github.com/michipili/bsdowl)
# This file is part of BSD Owl Scripts
#
# Copyright © 2005–2014 Michael Grünewald
#
# This file must be used under the terms of the CeCILL-B.
# This source file is licensed as described in the file COPYING, which
# you should have received as part of this distribution. The terms
# are also available at
# http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt

FILES=			shltx.sty
FILES+=			shthm.sty
FILES+=			sharticle.cls
FILES+=			shplexos.cls
FILES+=			shbook.cls
FILES+=			shpaper.cls
FILES+=			shmetal.sty

NOWEB=			shltxbegin.nw
NOWEB+=			shltx.nw
NOWEB+=			shclasses.nw
NOWEB+=			shmetal.nw
NOWEB+=			shpaper.nw
NOWEB+=			shplexos.nw
NOWEB+=			shthm.nw
NOWEB+=			shltxend.nw

NOTANGLE=		${FILES}

USES+=			noweb

.include "latex.files.mk"

### End of file `Makefile'
