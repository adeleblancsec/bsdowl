### environ.csh -- Environnement pour le test des Makefile

# Author: Michael Grünewald
# Date: Ven 14 mar 2008 11:01:08 CET
# Cookie: SYNOPSIS TARGET VARIABLE EN DOCUMENTATION

# BSDMake Pallàs Scripts (http://home.gna.org/bsdmakepscripts/)
# This file is part of BSDMake Pallàs Scripts
#
# Copyright (C) 2006-2009, 2013 Michael Grünewald
#
# This file must be used under the terms of the CeCILL-B.
# This source file is licensed as described in the file COPYING, which
# you should have received as part of this distribution. The terms
# are also available at
# http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt

set makedir=${HOME}/Work/makefile
setenv MAKEFLAGS\
    "-I ${makedir}/make -I ${makedir}/misc -I ${makedir}/ocaml -I ${makedir}/text"

### End of file `environ.csh'
