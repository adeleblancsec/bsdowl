### bps.project.mk -- Maintenance pour de petits projets

# Author: Micha�l Le Barbier Gr�newald
# Date: Sam 19 avr 2008 16:27:56 CEST
# Lang: fr_FR.ISO8859-1

# $Id$

# BSDMake Pall�s Scripts (http://home.gna.org/bsdmakepscripts/)
# This file is part of BSDMake Pall�s Scripts
# 
# Copyright (C) Micha�l Le Barbier Gr�newald - 2008-2009
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
# assistance pour les op�rations suivantes:
#  -- la pr�paration d'archives `tar';
#  -- la publication de ces archives (avec signature).
#
# La publication des archives et des signatures se fait vers un point du
# syst�me de fichiers, la publication vers un serveur ouvert au public
# n�cessite en g�n�ral des manipulations suppl�mentaires.


#
# Description des variables
#

# PROJECTVERSION
#
#   Version du projet, par exemple: 1.1
#
#   Si cette variable n'est pas initialis�e mais que VERSION l'est,
#   cette derni�re est utilis�e pour initialiser PROJECTVERSION. En
#   l'absence d'initialisation explicite, la valeur 0.0 est
#   implicitement affect�e � PROJECTVERSION.

# PROJECTNAME
#
#   Nom du projet, par exemple: bsdmakepscript
#
#   Si cette variable n'est pas initialis�e mais que APPLICATION,
#   PROJECT ou NAME l'est, cette variable est utilis�e pour
#   initialiser PROJECTNAME. En l'absence d'initialisation
#   explicite, une valeur d�duite du nom du r�pertoire racine du
#   projet est implicitement affect�e � PROJECTNAME.

# PROJECTAUTHOR
#
#   Auteur du projet, par exemple: Micha�l Gr�newald
#
#   La valeur de cette variable est utilis�e lors de l'�tape de
#   signature pour d�terminer la clef � utiliser.
#
#   Si cette variable n'est pas initialis�e mais que AUTHOR l'est,
#   cette derni�re est utilis�e pour initialiser PROJECTAUTHOR. En
#   l'absence d'initialisation explicite, la variable n'est pas
#   initialis�e et la valeur de USE_PROJECT_GPG est positionn�e � no.

# PROJECTDISTDIR
#
#   Dossier o� sont plac�es les archives avant d'�tre publi�es. Ce
#   dossier re�oit aussi les fichiers de signature.
#
#   Si cette variable n'est pas initialis�e mais que DISTDIR l'est,
#   cette derni�re est utilis�e pour initialiser PROJECTDISTDIR. En
#   l'absence d'initialisation explicite, la valeur ${.OBJDIR}
#   implicitement affect�e � PROJECTDISTDIR.

# PROJECTDISTNAME
#
#   Le nom des archives, qui est aussi le nom du dossier racine
#   apparaissant dans l'archive.
#
#   La valeur implicite de PROJECTDISTNAME est
#   ${PROJECTNAME}-${PROJECTVERSION}.

# PROJECTDIST
#
#   Liste de fichiers suppl�mentaires devant aussi faire l'objet d'une
#   publication non sign�e.
#
#   Les fichiers enum�r�s dans cette variable sont publi�s aux c�t�s
#   des archives et des signatures des archives.

# PROJECTDISTSIGN
#
#   Liste de fichiers suppl�mentaires devant aussi faire l'objet d'une
#   publication sign�e.
#
#   Les fichiers enum�r�s dans cette variable sont publi�s aux c�t�s
#   des archives et des signatures des archives.

# PROJECTDISTEXCLUDE
#
#   Liste de fichiers � ne pas inclure dans les archives publi�es.
#   Le module ajoute automatiquement les fichiers objets produits par
#   le script configure � cette liste (voir bps.autoconf.mk).

# USE_PROJECT_GPG
#
#   Cont�le l'utilisation de GPG pour signer les fichiers publi�s. Si
#   cette variable est positionn�e � une autre valeur que yes, les
#   fichiers sont publi�s sans �tre pr�alablement sign�s.

# PROJECTENV
#
#   �num�re les variables d'environnement export�es vers les sous-shells

# PROJECTBASE
#
#   Dossier principal du projet
#
#   Cette variable est initialis�e automatiquement � partir de .CURDIR.

#
# Description des cibles
#

# Toutes les cibles sont d�compos�es en �tapes `pre-do-post' pour
# pouvoir accueillir le plus hospitali�rement possible les
# modifications de l'utilisateur.

# dist:
#
#   Cr�e les archives destin�es � la publication.
#   Ces archives sont plac�es dans le dossier PROJECTDISTDIR.
#
#   Note importante: Le programme GNU tar ne dispose pas d'une option
#   �d�r�f�rencer les liens pr�sents sur la ligne de commande�. � cause de
#   cette restriction, il est interdit d'utiliser un lien symbolique dans
#   l'arbre des sources d'un projet.

# publish:
#
#   Pr�pare les archives, les signe, et les publie.

# prepublish:
#
#   Comme publish, mais s'arr�te juste avant la publication proprement
#   dite.

# shell:
#
#   Ouvre un shell pour le d�veloppeur
#
#   L'environnement du shell ouvert par cette cible contient les
#   liaisons �num�r�es dans PROJECTENV.

### IMPL�MENTATION

.if !target(__<bps.project.mk>__)
__<bps.project.mk>__:

#
# Initialistion des variables
#
.if !defined(PROJECTNAME)&&defined(APPLICATION)
PROJECTNAME = ${APPLICATION}
.endif
.if !defined(PROJECTNAME)&&defined(PROJECT)
PROJECTNAME = ${PROJECT}
.endif
.if !defined(PROJECTNAME)&&defined(NAME)
PROJECTNAME = ${NAME}
.endif
.if !defined(APPLICATION)&&defined(PROJECTNAME)
APPLICATION = ${PROJECTNAME}
.endif
# La d�finition possible de APPLICATIONDIR ci-dessous est redondante
# de celle figurant dans `bps.init.mk' mais il se peut que la variable
# APPLICATIONDIR ait tout-juste �t� d�finie.
.if defined(APPLICATION)&&!empty(APPLICATION)
APPLICATIONDIR?= /${APPLICATION}
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
# PROJECT ont toutes �t� positionn�es, on passe � l'initialistion �
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
# Fichiers � omettre dans l'archive
#

.for f in CVS .cvsignore .svn
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
# Pr�paration de la distribution
#

do-dist-projectdistdir:
	${INSTALL_DIR} ${PROJECTDISTDIR}


#
# Hospitalit�
#

.for t in dist prepublish publish
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
# Ouverture d'un shell pour le d�veloppeur
#

PROJECTENV = MAKEFLAGS="${.MAKEFLAGS:C|-I||:C|^/|-I/|:C|^\.|-I.|}"
# La substitution de la variable MAKEFLAGS est modifi�e pour que les
# options de type `-I' de make apparaissent sous forme compacte. Pour
# cela, elle fait l'hypoth�se que les termes commen�ant par un `/' ou
# un `.' sont des chemins � traiter comme arguments pour `-I'.

# La variable SHELL est d�finie dans l'environnement de l'utilisateur.
shell:
	${INFO} "Entering developper's subshell"
	${ENVTOOL} ${PROJECTENV} ${SHELL}
	${INFO} "Exiting developper's subshell"


.endif # !target(__<bps.project.mk>__)

### End of file `bps.project.mk'
