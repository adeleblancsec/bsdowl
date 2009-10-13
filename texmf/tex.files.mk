### tex.files.mk -- Installation de fichiers pour un syst�me TeX

# Author: Micha�l Le Barbier Gr�newald
# Date: Dim  9 sep 2007 17:32:25 CEST
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

# TEXFILES+= lmodern.sty
# TEXFILES+= ts1lmvtt.fd
# ...
# FORMAT = latex
# APPLICATION = lm
# TEXDIR = ${TEXMFDIR}/tex/${FORMAT}${APPLICATIONDIR}
#
# .include "tex.files.ml"


### DESCRIPTION

# Ce module se charge de l'installation de fichiers de macros dans un
# syst�me TeX. La liste des fichiers � installer doit �tre �mum�r�e
# dans TEXFILES. Le r�pertoire de destination est calcul� � partir de
# la valeur des variables APPLICATION et FORMAT.
#
# Le module r�clame la mise-�-jour des bases de donn�es `ls-R'
# n�cessaires.

#
# Description des variables
#

# TEXFILES
#
#  �num�re les fichiers de macros � installer

# FORMAT (generic)
#
#  Format pour lequel les macros sont �crites
#
#  Les valeurs courantes sont: amstex, context, generic, latex, plain.
#  Ce nom est utilis� pour calculer le dossier d'installation
#  TEXFILESDIR. 

# APPLICATION (misc)
#
#  Application d�signant les macros
#
#  Ce nom est utilis� pour calculer le dossier d'installation
#  TEXFILESDIR. 

# MKTEXLSR (mktexlsr)
#
#  Programme utilis� pour mettre � jour la base de donn�es `ls-R'

### IMPL�MENTATION

.include "bps.init.mk"
.include "texmf.init.mk"

MKTEXLSR?= mktexlsr
FILESGROUPS+= TEXFILES
FORMAT?= generic
APPLICATION?= misc
TEXDOCDIR?= ${TEXMFDIR}/doc/${FORMAT}${APPLICATIONDIR}
TEXFILESDIR?= ${TEXMFDIR}/tex/${FORMAT}${APPLICATIONDIR}

.if defined(TEXFILES)&&!empty(TEXFILES)
post-install: post-install-mktexlsr
post-install-mktexlsr:
	${MKTEXLSR} ${TEXMFDIR}
.endif

.include "bps.files.mk"
.include "bps.usertarget.mk"

### End of file `tex.files.mk'
