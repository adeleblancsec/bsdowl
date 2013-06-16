### test.ocaml.prog.mk

# Author: Michael Grünewald
# Date: Jeu 13 mar 2008 21:58:28 CET

# BSDMake Pallàs Scripts (http://home.gna.org/bsdmakepscripts/)
# This file is part of BSDMake Pallàs Scripts
#
# Copyright (C) 2008-2009, 2013 Michael Grünewald
#
# This file must be used under the terms of the CeCILL-B.
# This source file is licensed as described in the file COPYING, which
# you should have received as part of this distribution. The terms
# are also available at
# http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt


PROG =	pamplemousse
SRCS+=	jojosh.ml
SRCS+=	basic_types.ml basic_lexer.mll basic_parser.mly
SRCS+=	startrek.ml
LIBS+=  unix

.include "../ocaml/ocaml.prog.mk"

### End of file `test.ocaml.prog.mk'
