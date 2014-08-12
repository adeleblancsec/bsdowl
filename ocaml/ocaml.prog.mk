### ocaml.prog.mk -- Préparation de programmes avec Objective Caml

# Author: Michael Grünewald
# Date: Tue Apr  5 12:31:04 CEST 2005

# BSDMake Pallàs Scripts (http://home.gna.org/bsdmakepscripts/)
# This file is part of BSDMake Pallàs Scripts
#
# Copyright (C) 2005-2009, 2013 Michael Grünewald
#
# This file must be used under the terms of the CeCILL-B.
# This source file is licensed as described in the file COPYING, which
# you should have received as part of this distribution. The terms
# are also available at
# http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt


### SYNOPSIS

# PROG =	basicrun
# SRCS+=	main.ml
# SRCS+=	basic_types.ml
# SRCS+=	basic_parser.mly basic_lexer.mll
# SRCS+=	basic_process.ml basic_run.ml
# LIBS =	unix
# TARGET =	native_code

# If you have many small programs that share a common set of modules,
# and do not want ship these modules as a library, you can use the
# following:
#
# PROG =	client server
# SRCS =        protocol.ml
# LIBS =	unix
#
# If files client.ml and server.ml do exist, they are appended to the
# automatic value of SRCS.client and SRCS.server, so that after the
# treatment you end up with the following values:
#
# SRCS.client = ${SRCS} client.ml
# SRCS.server = ${SRCS} server.ml
#
# This scheme is useful when writing on programs testing a
# functionality or regression tests, so that you can keep all of them
# in a single directory.

### DESCRIPTION

# Variables:
#
#
#  PROGRAM or PROG
#   Name of the program
#
#   This can actually be a list of programs.  In this case the SRCS
#   variables holds source files that will be compiled and linked to
#   all programs and for each `program` the variable `SRCS.program`
#   should specify files that will only be compiled and linked in
#   `program`.
#
#
#  SRCS
#   Files that must be compiled and linked in the program
#
#   It can list implementation files, interface files, lexer and
#   parser definitions. It is not necessary to specify interface file
#   if an implementation is present.
#
#
#  LIBS
#   Libraries that must be linked in the program
#
#
#  DIRS
#   Directories that are searched for libraries or compiled modules
#
#
#  PKGS
#   OCamlfind packages that are used in the program
#
#
#  BINOWN, BINGRP, BINMODE, BINDIR, BINNAME
#   Parameters of the program installation
#
#   See `bps.own.mk` for a closer description of these variables.


### MAGIC STUFF

.include "bps.init.mk"
.include "ocaml.init.mk"

.if defined(PROG)&&!empty(PROG)
PROGRAM?= ${PROG}
.endif

.if !defined(PROGRAM)||empty(PROGRAM)
.error The ocaml.prog.mk module expects you to set the PROGRAM or the PROG variable to a sensible value.
.endif

## DU MODE SINGLETON AU MODE ENSEMBLE

.for item in ${PROGRAM}
_OCAML_SRCS+=SRCS.${item:T}
.if !defined(SRCS.${item:T})
SRCS.${item:T} = ${SRCS}
.if exists(${item}.ml)
SRCS.${item:T}+= ${item}.ml
.endif
.endif
.if defined(_OCAML_COMPILE_NATIVE)
SRCS.${item:T}.native?=${SRCS.${item:T}}
_OCAML_CN+=${item:T}.native
.endif
.if defined(_OCAML_COMPILE_BYTE)
SRCS.${item:T}.byte?=${SRCS.${item:T}}
_OCAML_CB+=${item:T}.byte
.endif
.if defined(LIBS)&&!empty(LIBS)
LIBS.${item:T}.byte?=${LIBS:=.cma}
LIBS.${item:T}.native?=${LIBS:=.cmxa}
.endif
.endfor

.include "ocaml.main.mk"

### AUXILLIARY TARGETS

.for item in ${PROGRAM}
BIN+=${item}
CLEANFILES+=${item}
.if defined(_OCAML_COMPILE_NATIVE)
${item}: ${item}.native
	${CP} ${item}.native ${item}
_OCAML_SRCS.${item}.native=${.ALLSRC}
.if !empty(LIBS.${item}.native)
${item}.native: ${LIBS.${item}.native}
.endif
.if !empty(SRCS.${item}.native)
${item}.native: ${SRCS.${item}.native:C/\.ml[ly]/.ml/:M*.ml:.ml=.cmx}
.endif
.endif
.if defined(_OCAML_COMPILE_BYTE) && !target(${item})
${item}: ${item}.byte
	${CP} ${item}.byte ${item}
_OCAML_SRCS.${item}.byte=${.ALLSRC}
.if !empty(LIBS.${item}.byte)
${item}.byte: ${LIBS.${item}.byte}
.endif
.if !empty(SRCS.${item}.byte)
${item}.byte: ${SRCS.${item}.byte:C/\.ml[ly]/.ml/:M*.ml:.ml=.cmo}
.endif
.endif
.endfor

.include "bps.clean.mk"
.include "bps.files.mk"
.include "bps.usertarget.mk"

### End of file `ocaml.prog.mk'
