### ocaml.dirs.mk -- Handling lookup paths

# Author: Michael Grünewald
# Date: Sat Jul  7 20:26:31 CEST 2007

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


### SYNOPSIS


# DIRS+= ../library
#
# .include "ocaml.init.mk"
# .include "ocaml.dirs.mk"


### DESCRIPTION

# This module takes care of initialising the _OCAML_DIRS variable,
# holding a private version of DIRS that can be pasten on the command
# line.  It also knows where the standard library is installed.
#
# This module is intended to be included by other modules rather than
# to serve as is to the end user.


### DESCRIPTION

# Variables:
#
#  DIRS
#   Lookup path for OCaml object files
#
#   This list of paths is appended to OCaml suite's tools options and
#   to Make's internal lookup paths.
#
#
#  OCAMLROOTDIR
#    Path to the standard library


.if !target(__<ocaml.dirs.mk>__)
__<ocaml.dirs.mk>__:

.if defined(DIRS)&&!empty(DIRS)
_OCAML_DIRS=${DIRS:C/^/-I /}
# Compiled interfaces files probably never appear on the command line
# and also probably do not need to be looked up by make, so the .cmi
# suffix is omitted from the next list.
#.PATH.cmi: ${DIRS}
.PATH.cmo: ${DIRS}
.PATH.cmx: ${DIRS}
.PATH.cmxa: ${DIRS}
.PATH.cma: ${DIRS}
.PATH.a: ${DIRS}
.PATH.o: ${DIRS}
.endif

OCAMLROOTDIR?=/usr/local/lib/ocaml
.PATH.cmo: ${OCAMLROOTDIR}
.PATH.cmx: ${OCAMLROOTDIR}
.PATH.cmxa: ${OCAMLROOTDIR}
.PATH.cma: ${OCAMLROOTDIR}
.PATH.a: ${OCAMLROOTDIR}
.PATH.o: ${OCAMLROOTDIR}

.if defined(_OCAML_DIRS) && !empty(_OCAML_DIRS)
.for tool in MLCI MLCB MLCN MLLB MLLN MLDEP
${tool}FLAGS+=${_OCAML_DIRS}
.endfor
.endif

.endif # !target(__<ocaml.dirs.mk>__)

### End of file `ocaml.dirs.mk'
