### www.sgml.mk -- Production HTML via SGML

# Author: Micha�l Le Barbier Gr�newald
# Date: Jeu 13 mar 2008 21:58:28 CET
# Lang: fr_FR.ISO8859-15

# $Id$

# BSDMake Pall�s Scripts (http://home.gna.org/bsdmakepscripts/)
# This file is part of BSDMake Pall�s Scripts
# 
# Copyright (C) Micha�l Le Barbier Gr�newald - 2009
# 
# This file must be used under the terms of the CeCILL-B.
# This source file is licensed as described in the file COPYING, which
# you should have received as part of this distribution. The terms
# are also available at
# http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt


### SYNOPSIS

# Attention: il ne s'agit pas d'un syst�me DOCBOOK!

# WWW = index.html
# SRCS = index.sgml
# SRCS+= head-css.sgml
# SRCS+= head-title.sgml
# SRCS+= body-content.sgml
# SRCS+= body-nav.sgml
#
# WWWDIR = ${WWWBASE}/subdir
#
# .include "www.sgml.mk"



#
# Description des variables
#

# WWW
#
#   �num�re les fichiers � produire � partir des sources SGML
#
#   Chaque terme a sa propre variable SRCS, et la variable SRCS
#   g�n�rale y est ajout�e.


# WWWMAIN
#
#    Nom du fichier principal
#
#    Pour produire plusieurs fichiers, il faut utiliser la forme
#    sp�cialis�e de cette variable.


# WWWBASE
#
#   R�pertoire racine du document cible (la version install�e)
#
#   Lorsque cette variable a une valeur, cette valeur est transmise
#   aux sous-processus MAKE, de cette fa�on elle peut �tre utilis�e
#   pour d�finir correctement WWWDIR.

# WWWOWN, WWWGRP, WWWMODE, WWWDIR
#
#   Param�tres de la proc�dure d'installation
#
#   Ces param�tres sont document�s dans le module bps.files.mk.

# INCLUDE
#
#   �num�re les entit�s � inclure
#
#   Il s'agit des entit�s de type param�tre don la valeur doit �tre
#   positionn�e � INCLUDE.

# SEARCH
#
#   �num�re les dossiers de recherche

# CATALOG
#
#   �num�re les catalogues � inclure pour la r�solution des entit�s

.include "bps.init.mk"

.SUFFIXES: .sgml

WWWNORMALIZE?= sgmlnorm -d
WWWINPUT?= ascii
WWWTIDY?= tidy -q -${WWWINPUT}

.for variable in SEARCH CATALOG INCLUDE
.if defined(${variable})&&!empty(${variable})
.MAKEFLAGS: ${variable}="${${variable}}"
.else
${variable}=
.endif
.endfor

WWWNORMALIZETOOL = ${WWWNORMALIZE} 
.for search in ${SEARCH}
WWWNORMALIZETOOL+= -D${search}
.PATH.sgml: ${search}
.endfor
.for catalog in ${CATALOG}
WWWNORMALIZETOOL+= -c${catalog}
.endfor
.for include in ${INCLUDE}
WWWNORMALIZETOOL+= -i${include}
.endfor

.for file in ${WWW}
.if defined(WWWMAIN)&&!empty(WWWMAIN)
WWWMAIN.${file:T} = ${WWWMAIN}
.endif
.if !defined(WWWMAIN.${file:T}) && exists(${file:.html=.sgml})
WWWMAIN.${file:T} = ${file:.html=.sgml}
.endif
.if !defined(WWWMAIN.${file:T}) || empty(WWWMAIN.${file:T})
.error "No main file for ${file}"
.endif
SRCS.${file:T}?= ${WWWMAIN.${file:T}}
.if empty(SRCS.${file:T}:M${WWWMAIN.${file:T}})
SRCS.${file:T}+= ${WWWMAIN.${file:T}}
.endif
.endfor

.if defined(SRCS)&!empty(SRCS)
.for file in ${WWW}
SRCS.${file:T}+= ${SRCS}
.endfor
.endif

.for file in ${WWW}
CLEANFILES+= ${file}
.if exists(${file}.pre)
CLEANFILES += ${file}.pre
.endif
${file}: ${SRCS.${file:T}}
	${WWWNORMALIZETOOL} ${WWWMAIN.${file:T}} | ${WWWTIDY} > ${.TARGET}.pre
	${MV} ${.TARGET}.pre ${.TARGET}
.endfor

.include "www.files.mk"

### End of file `www.files.mk'
