### misc.elisp.mk -- Manage Emacs Lisp Directories

# Author: Micha�l Le Barbier Gr�newald
# Date: Fri Feb 10 17:59:16 2006
# Lang: fr_FR.ISO8859-15

# $Id$

# BSDMake Pall�s Scripts (http://home.gna.org/bsdmakepscripts/)
# This file is part of BSDMake Pall�s Scripts
# 
# Copyright (C) Micha�l Le Barbier Gr�newald - 2006-2009
# 
# This file must be used under the terms of the CeCILL-B.
# This source file is licensed as described in the file COPYING, which
# you should have received as part of this distribution. The terms
# are also available at
# http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt


### SYNOPSIS

# SRCS+= module1.el
# SRCS+= module2.el
#
# ELISPC.module1.elc = A command to compile my elisp thing
# ELISPMODE.module2.elc = 400
#
# ELISP_INSTALL_SRC.module2.el = no
#
# .include "misc.elisp.mk"


### DESCRIPTION

# Ce module compile et installe des modules EMACS LISP. Le r�pertoire
# d'installation est d�termin� par la valeur de ELISPDIR
# (/share/emacs/site-lisp).
#
# La variable ELISP_INSTALL_SRC (yes) contr�le l'installation des
# fichiers source avec les fichiers byte-code.

FILESGROUPS+= ELISP
ELISP_INSTALL_SRC = yes

ELISPDIR?= ${PREFIX}/share/emacs/site-lisp
ELISPC?= emacs -batch -f batch-byte-compile

.if defined (SRCS) && !empty(SRCS:M*.el)

ELISP+=		${SRCS:M*.el:.el=.elc}

.for file in ${SRCS:M*.el}

#
# Installation des fichiers sources
#

.if !defined(ELISP_INSTALL_SRC.${file})
ELISP_INSTALL_SRC.${file}=${ELISP_INSTALL_SRC}
.endif

.if ${ELISP_INSTALL_SRC.${file}} == yes
ELISP+=${file}
.endif
.endfor


.for obj in ${SRCS:M*.el:.el=.elc}

#
# Fichiers � nettoyer
#

CLEANFILES+= ${obj}

#
# Calcul de la ligne de compilation
#

.if !defined(ELISPC.${obj})
ELISPC.${obj} = ${ELISPC}
.endif

${obj}: ${obj:.elc=.el}
	${ELISPC.${obj}} ${.ALLSRC}


.endfor

.endif

.include "bps.init.mk"
.include "bps.clean.mk"
.include "bps.files.mk"
.include "bps.usertarget.mk"

### End of file `misc.elisp.mk'
