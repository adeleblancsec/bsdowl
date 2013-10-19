### bps.project.mk -- Maintenance pour de petits projets

# Author: Michael Grünewald
# Date: Sam 19 avr 2008 16:27:56 CEST
# Cookie: SYNOPSIS TARGET VARIABLE EN DOCUMENTATION

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


### SYNOPSIS

# PROJECTVERSION =	1.1
# PROJECTNAME =		projectpublication
# PROJECTAUTHOR =	The name of the GPG guy
# PROJECTDISTDIR =	/attic
#
# .include "bps.project.mk"


### DESCRIPTION

# Le support de maintenance pour de petits projets fournit une
# assistance pour les opérations suivantes:
#  -- la préparation d'archives `tar';
#  -- la publication de ces archives (avec signature).
#
# La publication des archives et des signatures se fait vers un point du
# système de fichiers, la publication vers un serveur ouvert au public
# nécessite en général des manipulations supplémentaires.


#
# Description des variables
#

# PROJECTVERSION
#
#   Version du projet, par exemple: 1.1
#
#   Si cette variable n'est pas initialisée mais que VERSION l'est,
#   cette dernière est utilisée pour initialiser PROJECTVERSION. En
#   l'absence d'initialisation explicite, la valeur 0.0 est
#   implicitement affectée à PROJECTVERSION.

# PROJECTNAME
#
#   Nom du projet, par exemple: bsdmakepscript
#
#   Si cette variable n'est pas initialisée mais que PACKAGE,
#   PROJECT ou NAME l'est, cette variable est utilisée pour
#   initialiser PROJECTNAME. En l'absence d'initialisation
#   explicite, une valeur déduite du nom du répertoire racine du
#   projet est implicitement affectée à PROJECTNAME.

# PROJECTAUTHOR
#
#   Auteur du projet, par exemple: Michael Grünewald
#
#   La valeur de cette variable est utilisée lors de l'étape de
#   signature pour déterminer la clef à utiliser.
#
#   Si cette variable n'est pas initialisée mais que AUTHOR l'est,
#   cette dernière est utilisée pour initialiser PROJECTAUTHOR. En
#   l'absence d'initialisation explicite, la variable n'est pas
#   initialisée et la valeur de USE_PROJECT_GPG est positionnée à no.

# PROJECTDISTDIR
#
#   Dossier où sont placées les archives avant d'être publiées. Ce
#   dossier reçoit aussi les fichiers de signature.
#
#   Si cette variable n'est pas initialisée mais que DISTDIR l'est,
#   cette dernière est utilisée pour initialiser PROJECTDISTDIR. En
#   l'absence d'initialisation explicite, la valeur ${.OBJDIR}
#   implicitement affectée à PROJECTDISTDIR.

# PROJECTDISTNAME
#
#   Le nom des archives, qui est aussi le nom du dossier racine
#   apparaissant dans l'archive.
#
#   La valeur implicite de PROJECTDISTNAME est
#   ${PROJECTNAME}-${PROJECTVERSION}.

# PROJECTDIST
#
#   Liste de fichiers supplémentaires devant aussi faire l'objet d'une
#   publication non signée.
#
#   Les fichiers enumérés dans cette variable sont publiés aux côtés
#   des archives et des signatures des archives.

# PROJECTDISTSIGN
#
#   Liste de fichiers supplémentaires devant aussi faire l'objet d'une
#   publication signée.
#
#   Les fichiers enumérés dans cette variable sont publiés aux côtés
#   des archives et des signatures des archives.

# PROJECTDISTEXCLUDE
#
#   Liste de fichiers à ne pas inclure dans les archives publiées.
#   Le module ajoute automatiquement les fichiers objets produits par
#   le script configure à cette liste (voir bps.autoconf.mk).

# USE_PROJECT_GPG
#
#   Contôle l'utilisation de GPG pour signer les fichiers publiés. Si
#   cette variable est positionnée à une autre valeur que yes, les
#   fichiers sont publiés sans être préalablement signés.

# PROJECTENV
#
#   Énumère les variables d'environnement exportées vers les sous-shells

# PROJECTBASE
#
#   Dossier principal du projet
#
#   Cette variable est initialisée automatiquement à partir de .CURDIR.

# PROJECTLIBRARY
#
#   Bibliothèque du projet
#
#   Nom d'un dossier «bibliothèque» contenant des sous-dossiers pour
#   les modèles utilisés dans le projet, les makefiles spécifiques,
#   etc.

# PROJECTLIBRARYMAKE
#
#   Bibliothèque de fichiers Make


#
# Description des cibles
#

# Toutes les cibles sont décomposées en étapes `pre-do-post' pour
# pouvoir accueillir le plus hospitalièrement possible les
# modifications de l'utilisateur.

# dist:
#
#   Crée les archives destinées à la publication.
#   Ces archives sont placées dans le dossier PROJECTDISTDIR.
#
#   Note importante: Le programme GNU tar ne dispose pas d'une option
#   «déréférencer les liens présents sur la ligne de commande». À cause de
#   cette restriction, il est interdit d'utiliser un lien symbolique dans
#   l'arbre des sources d'un projet.

# publish:
#
#   Prépare les archives, les signe, et les publie.

# prepublish:
#
#   Comme publish, mais s'arrête juste avant la publication proprement
#   dite.

# subshell:
#
#   Ouvre un sous-shell pour le développeur
#
#   L'environnement du shell ouvert par cette cible contient les
#   liaisons énumérées dans PROJECTENV.
#
#   Si cette variable est définie, entre dans le dossier SUBSHELLDIR
#   avant d'éxécuter ce nouveau shell.

# update:
#
#   Permet la mise à jour automatique des sources du projet
#
# Cette cible n'est associée à aucune rectette, mais l'utilisateur
# peut en assigner une, s'il souahite automatiser automatiquement les
# soruces de son projet.


### IMPLÉMENTATION

.if !target(__<bps.project.mk>__)
__<bps.project.mk>__:

#
# Initialistion des variables
#
.if !defined(PROJECTNAME)&&defined(PACKAGE)
PROJECTNAME = ${PACKAGE}
.endif
.if !defined(PROJECTNAME)&&defined(PROJECT)
PROJECTNAME = ${PROJECT}
.endif
.if !defined(PROJECTNAME)&&defined(NAME)
PROJECTNAME = ${NAME}
.endif
.if !defined(PACKAGE)&&defined(PROJECTNAME)
PACKAGE = ${PROJECTNAME}
.endif
# La définition possible de PACKAGEDIR ci-dessous est redondante
# de celle figurant dans `bps.init.mk' mais il se peut que la variable
# PACKAGEDIR ait tout-juste été définie.
.if defined(PACKAGE)&&!empty(PACKAGE)
PACKAGEDIR?= /${PACKAGE}
.endif
.if !defined(PROJECTAUTHOR)&&defined(AUTHOR)
PROJECTAUTHOR = ${AUTHOR}
.endif
.if !defined(PROJECTVERSION)&&defined(VERSION)
PROJECTVERSION = ${VERSION}
.endif
.if !defined(PROJECTDISTDIR)&&defined(DISTDIR)
PROJECTDISTDIR = ${DISTDIR}
.endif
# Les variables permettant de deviner les valeurs pour le module
# PROJECT ont toutes été positionnées, on passe à l'initialistion à
# l'aide de valeurs implicites.
.if !defined(PROJECTNAME)||empty(PROJECTNAME)
PROJECTNAME = ${.CURDIR:T}
.endif
.if !defined(PROJECTVERSION)||empty(PROJECTVERSION)
PROJECTVERSION = 0.0
.endif
.if !defined(PROJECTAUTHOR)||empty(PROJECTAUTHOR)
USE_PROJECT_GPG = no
.endif
GPG?= gpg
USE_PROJECT_GPG?= yes
PROJECTDIST?=
PROJECTDISTSIGN?=
PROJECTDISTNAME?= ${PROJECTNAME}-${PROJECTVERSION}
PROJECTDISTDIR?= ${.OBJDIR}


#
# Structures pour le module de compression
#

_PROJECT_COMPRESS_TOOLS?=bzip2 gzip
_PROJECT_COMPRESS.suffix.none =
_PROJECT_COMPRESS.suffix.gzip = .gz
_PROJECT_COMPRESS.suffix.bzip2 = .bz2
_PROJECT_COMPRESS.flag.none =
_PROJECT_COMPRESS.flag.gzip = -z
_PROJECT_COMPRESS.flag.bzip2 = -j


#
# Production des archives
#  initialisation
#

.for t in ${_PROJECT_COMPRESS_TOOLS}
.for f in ${PROJECTDISTNAME}.tar${_PROJECT_COMPRESS.suffix.${t}}
PROJECTDISTSIGN+= ${PROJECTDISTDIR}/${f}
PROJECTDISTEXCLUDE+= ${f}
.endfor
.endfor


#
# Fichiers à omettre dans l'archive
#

.for f in CVS .cvsignore .svn .gitignore .git
.if exists(${f})
PROJECTDISTEXCLUDE+=${f}
.endif
.endfor

.if target(__<bps.autoconf.mk>__)
.if defined(CONFIGURE)&&!empty(CONFIGURE:M*.in)
.for f in ${CONFIGURE:M*.in}
PROJECTDISTEXCLUDE+=${PROJECTDISTNAME}/${f:.in=}
.endfor
.endif
.endif


#
# Production des archives
#  pour de bon
#

.for t in ${_PROJECT_COMPRESS_TOOLS}
${PROJECTDISTDIR}/${PROJECTDISTNAME}.tar${_PROJECT_COMPRESS.suffix.${t}}::
	${LN} -s ${.CURDIR} ${PROJECTDISTDIR}/${PROJECTDISTNAME}
	${TAR} -c\
	${_PROJECT_COMPRESS.flag.${t}}\
	-f ${.TARGET}\
	-C ${PROJECTDISTDIR}\
	-h\
	${PROJECTDISTEXCLUDE:S/^/--exclude /}\
	--exclude ${PROJECTDISTNAME}/${PROJECTDISTNAME}\
	${PROJECTDISTNAME}
	${RM} -f ${PROJECTDISTDIR}/${PROJECTDISTNAME}
.endfor


#
# Production des signatures
#

.for f in ${PROJECTDISTSIGN}
${f:=.sig}: ${f}
	cd ${PROJECTDISTDIR};\
	${GPG} -u '${PROJECTAUTHOR}' -b ${.ALLSRC}
.endfor


#
# Préparation de la distribution
#

do-dist-projectdistdir:
	${INSTALL_DIR} ${PROJECTDISTDIR}


#
# Hospitalité
#

.for t in dist prepublish publish update
.if target(pre-${t})
${t}: pre-${t}
.endif
${t}: do-${t}
.if target(post-${t})
${t}: post-${t}
.endif
.endfor


#
# Distribution
#

do-dist: do-dist-projectdistdir

.if !empty(PROJECTDIST)
do-dist: ${PROJECTDIST}
.endif

.if !empty(PROJECTDISTSIGN)
do-dist: ${PROJECTDISTSIGN}
.endif


#
# Publication
#

.if ${USE_PROJECT_GPG} == yes
do-prepublish: ${PROJECTDISTSIGN:=.sig}
.endif

#
# Initialisation de PROJECTBASE
#

.if !defined(PROJECTBASE)
PROJECTBASE = ${.CURDIR}
.MAKEFLAGS: PROJECTBASE="${PROJECTBASE}"
.endif


#
# Initialisation de PROJECTLIBRARY
#

.if !defined(PROJECTLIBRARY) && exists(${PROJECTBASE}/Library)
PROJECTLIBRARY = ${PROJECTBASE}/Library
.endif

.if defined(PROJECTLIBRARY)
.MAKEFLAGS: PROJECTLIBRARY="${PROJECTLIBRARY}"
.endif


#
# Initialisation de PROJECTLIBRARYMAKE
#

.if !defined(PROJECTLIBRARYMAKE)
.if defined(PROJECTLIBRARY) && exists(${PROJECTLIBRARY}/Make)
PROJECTLIBRARYMAKE = ${PROJECTLIBRARY}/Make
.elif defined(PROJECTLIBRARY) && exists(${PROJECTLIBRARY}/Mk)
PROJECTLIBRARYMAKE = ${PROJECTLIBRARY}/Mk
.elif defined(PROJECTBASE) && exists(${PROJECTBASE}/Mk)
PROJECTLIBRARYMAKE = ${PROJECTBASE}/Mk
.endif
.endif

.if defined(PROJECTLIBRARYMAKE)
.MAKEFLAGS: PROJECTLIBRARYMAKE="${PROJECTLIBRARYMAKE}"
.MAKEFLAGS: -I"${PROJECTLIBRARYMAKE}"
.endif



#
# Reading project configuration
#

.if exists(${PROJECTLIBRARYMAKE}/project.mk)
.include "${PROJECTLIBRARYMAKE}/project.mk"
.endif


#
# Initialisation de PROJECTLIBRARYSHELL
#

.if !defined(PROJECTLIBRARYSHELL)
.if defined(PROJECTLIBRARY) && exists(${PROJECTLIBRARY}/Ancillary)
PROJECTLIBRARYSHELL = ${PROJECTLIBRARY}/Ancillary
.elif defined(PROJECTBASE) && exists(${PROJECTBASE}/Ancillary)
PROJECTLIBRARYSHELL = ${PROJECTBASE}/Ancillary)
.endif
.endif


#
# Ouverture d'un sous-shell pour le développeur
#

PROJECTENV = MAKEFLAGS="${.MAKEFLAGS:C|-I||:C|^/|-I/|:C|^\.|-I.|}"
# La substitution de la variable MAKEFLAGS est modifiée pour que les
# options de type `-I' de make apparaissent sous forme compacte. Pour
# cela, elle fait l'hypothèse que les termes commençant par un `/' ou
# un `.' sont des chemins à traiter comme arguments pour `-I'.

.if defined(PROJECTEXPORT)&&!empty(PROJECTEXPORT)
.for v in ${PROJECTEXPORT}
PROJECTENV+= $v="${$v}"
.endfor
.endif

.if defined(PROJECTLIBRARYSHELL)
PROJECTENV+= PATH="${PROJECTLIBRARYSHELL}:${PATH}"
.endif


# La variable SHELL est définie dans l'environnement de l'utilisateur.
SUBSHELLDIR?= .
subshell:
	${INFO} "Entering developper's subshell"
	@cd ${SUBSHELLDIR}; ${ENVTOOL} ${PROJECTENV} ${SHELL}
	${INFO} "Exiting developper's subshell"

.endif # !target(__<bps.project.mk>__)

.include "bps.subdir.mk"

### End of file `bps.project.mk'
