;; dot.emacs -- Fichier de configuration EMACS -*- lisp -*-

; Author: Micha�l Le Barbier Gr�newald
; Date: Sun Sep 10 11:37:56 CEST 2006
; Lang: fr_FR.ISO8859-15

; Le programme EMACS est un �diteur de texte tr�s populaire parmi les
; utilisateurs de syst�mes UNIX. Le programme EMACS est un programme
; versatile et souple. � chacun de ses d�marrages il lit le fichier
; `dot.emacs' (ce fichier) situ� dans le r�pertoire personnel de
; l'utilisateur.

; Pour en apprendre plus au sujet d'EMACS, on peut lire les documents
;  * (emacs)Intro
;  * le ``Developers Handbook'', qui contient un passage consacr� �
;    l'utilisation d'EMACS pour le d�veloppement;
;  * enfin, le r�pertoire /usr/local/share/emacs/21.3/etc contient un
;    grand nombre de fichiers dont certains peuvent se r�v�ler
;    int�ressants.
;
; Pour lire ces documents:
;   $ info emacs Intro
;   $ lynx file://localhost/usr/share/doc/en_US.ISO8859-1/books/developers-handbook/emacs.html

; Outre les entr�es pr�sentes dans ce fichier, on peut am�nager
; certaines fonctionnalit�s d'un int�r�t moins g�n�ral, notamment la
; configuration des modes majeurs. Un mode majeur pour EMACS est un
; ensemble de fonctions sp�cialis� pour l'�dition de tel ou tel format
; de fichier, par exemple les fichiers HTML, PHP, les programmes C,
; JAVA, assembleur, etc.
;
; Le mode PSGML est sp�cialis� pour l'�dition des fichiers SGML/XML,
; comme par exemple les fichier Docbook ou les fichiers HTML.
;
; Le mode GNUS est un client MAIL/NEWS, on peut lire et envoyer son
; courrier �l�ctronique depuis EMACS, et lire et participer aux
; newsgroups.

; La suite de ce fichier est une liste de r�glages pour EMACS,
; accompagn�s de quelques nots d'explication et parfois de r�f�rences
; � une documentation plus compl�te.


;; scroll-bar-mode
; Lorsqu'EMACS est utilis� sous une interface graphique, la fen�tre
; principale de l'�diteur pr�sente des barres de
; d�filements. Celles-ci sont moches et peut utiles, on peut les
; supprimer.
(scroll-bar-mode 'nil)

;; set-frame-font
; La taille implicite des caract�res est *un peu* petite pour un
; affichage sur une format plus grand que "1024x768". La valeur
; suivante convient pour un affichage en "1280x1024". Pour choisir une
; autre fonte lorsque Emacs est lanc�, on peut bien s�r utiliser la
; fonction `set-frame-font', ou utiliser le menu
;   Opions => Mule => Set font/fontset
; accessible aussi par la combinaison
;   <S-down-mouse-1>
; en en choisissant une valeur convenable du `popup' qui appara�t
; alors. Sous le syst�me X on peut modifier la fonte utilis�e dans la
; fen�tre principale au moyen de ressources X, d�finies dans le
; fichier `dot.Xresources'.
;(set-frame-font "-adobe-courier-medium-r-normal--*-180-*-*-m-*-iso8859-1")

;; visible-bell
; Lorsque la variable `visible-bell' est positionn�e sur 't, Emacs
; fait son possible pour remplacer l'alerte sonore par une alerte
; visuelle. Puisque l'alerte sonore est fr�quemment utilis�e par
; EMACS, ce r�glage est presque n�cessaire.
(setq visible-bell 't)

;; column-number-mode
; Num�ro de colonne visible dans la modeline.
(custom-set-variables '(column-number-mode 't))

;; load-path
; Un bon endroit o� entreposer les fichiers Emacs lisp personnels est
; le catalogue "~/share/emacs/site-lisp". Il est en effet souhaitable
; que la hi�rarchie sous "~" puisse-t-�tre trait�e comme les
; hi�rarchies "/usr" et "/usr/local", et les fichiers elisp de Emacs
; sont stock�s dans "/usr/local/share/emacs/site-lisp". Le choix de ce
; lieu concorde avec les directions dessin�es dans hier(7) puisque
; "share" re�oit les fichiers "architecture independant" ce qui est le
; cas des fichiers elisp et de leurs versions "byte-compiled". Un
; choix tr�s naturel est "~/lib/elisp", auquel on doit pr�f�rer
; "~/share/emacs/site-lisp" � cause des raisons �voqu�es.
(add-to-list 'load-path "~/share/emacs/site-lisp")

;; backup-directory-alist
; Avec ses param�tres naturels, Emacs �crit ses fichiers de sauvegarde
; dans le m�me catalogue que le fichier �dit�. Quoique la gestion de
; ces fichiers dispers�s est assez facile, gr�ce � find(1), la
; pr�sence de ces fichiers peut �tre ennuyeuse lorsque on travaille
; avec des "Makefile" ou CVS. Il ne co�te rien de les regrouper dans
; un catalogue, par exemple "~/.emacs.d/backup".
(setq backup-directory-alist '((".*" . "~/.emacs.d/backup")))

;; set-keyboard-coding-system
; An exceirpt from (emacs) Specify Coding:
;
;   By default, keyboard input is not translated at all.
;
; We here selects a keyboard-coding-system that seems accurate. If
; this choice turns out to be irrelevant, you can still use the
; set-keyboard-coding-system function to 'none, with C-x RET k none.
; It might be useful to write a function that guess the correct
; keyboard coding system.
; SEE ALSO: (emacs) Specify Coding, (emacs) Window Systems
(if (not window-system) (set-keyboard-coding-system 'iso-latin-9))
;(set-keyboard-coding-system 'iso-latin-9)

;; Info-directory-list
; La valeur par d�faut oublie le catalogue X11R6.
(setq Info-directory-list 
      '("/usr/local/info/" "/usr/share/info/" "/usr/X11R6/info/")
)

;; yes-or-no-p
; 
; On remplace `yes-or-no-p' par `y-or-no-p' puisque les mots "yes" et;
; "no" sont si longs et si difficiles � taper.
(fset 'yes-or-no-p 'y-or-n-p)

;; custom-file
; O� inscrire les `customizations', de fa�on � garder ce fichier propre.
; Note: � moins que les `customizations' ne soient situ�es dans le
; fichier `.emacs' (param�tres ordinaires de Emacs), il faut charger
; explicitement ce fichier pour que les modifications soient prises en
; compte.
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 't)

;; auto-compression-mode
; Acc�s transparent aux fichiers compress�s.
;
; SeeAlso: gzip(1), gunzip(1), bzip2(1), bumzip2(1).
(auto-compression-mode 1)

;; narrow-to-region
; La commande `narrow-to-region' (C-x n n, C-x n w) est nortmalement
; d�sactiv�e (on se demande bien pourquoi).
; Limiter la zone d�dition est particuli�rement utile lors des
; traitements par expressions rationelles.
(put 'narrow-to-region 'disabled nil)

;; font-lock-mode
; Hey EMACS! Transforme donc tous mes fichiers en salade de fruit d�s
; que tu t'en sens capable.
(global-font-lock-mode t)

;; turn-on-auto-fill
; Le programme EMACS est capable de r�orgamiser automatiquement les
; mots d'un paragraphe apr�s qu'une insertion ait eu lieu, il peut
; aussi deviner la valeur d'un pr�fixe � ins�rer apr�s un retour de
; ligne automatique, comme par exemple une famille d'espaces. Ces
; fonctions sont appel�es ``fonctions de remplissage des
; paragraphes''. Ces fonctions ne produisent pas toujours des
; r�sultats tr�s satisfaisants, le module filladapt permet les modifie
; pour les rendre plus pertinentes (cf. infra).
;
; On peut activer le mode mineur filladapt automatiquement
; lorsqu'EMACS entre dans certains modes majeurs en ins�rant ici des
; commandes resemblant aux la suivante.
;
; SeeAlso: (emacs)Filling.
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'lisp-mode-hook 'turn-on-auto-fill)
(add-hook 'sh-mode-hook 'turn-on-auto-fill)
(add-hook 'c-mode-hook 'turn-on-auto-fill)
(add-hook 'makefile-mode-hook 'turn-on-auto-fill)


;; filladapt
; Les fonctions qu'EMACS utilise pour reremplir les paragraphes, comme
; `fill-paragraph' ne produisent pas toujours de bons r�sultats. Les
; fonctions d�finies dans filladapt am�liorent un peut cette
; situation.
;(require 'filladapt)
;(setq-default filladapt-mode t)


;; ispell
; Le programme `ispell' est un assistant � la correction
; orthographique. Ce programme d�tecte les mots ne figurant pas dans
; son dictionnaire et propose le cas �ch�ant une correction. Les
; possibilit�s limit�es de ce genre de programme restreint leur
; utilisation au rep�rage des fautes de saisie. Le programme EMACS
; dispose d'un mode mineur interfa�ant EMACS et ispell, le premier
; proposant � l'utilisateur les services rendus par le second.
;
; D'autres programmes du m�me type existent, comme aspell. En ce qui
; concerne EMACS, certains utilisateurs appr�cient la variante
; flyspell (spleeling ont the fly) du mode mineur ispell.

(require 'ispell)

;(defun ispell-decode-string (str)
;   "Decodes multibyte character strings.
;Protects against bogus binding of `enable-multibyte-characters' in XEmacs."
;  (if (and (or xemacsp
; 	       (and (boundp 'enable-multibyte-characters)
; 		    enable-multibyte-characters))
; 	   (fboundp 'decode-coding-string)
; 	   (ispell-get-coding-system))
;       (decode-coding-string str buffer-file-coding-system)
;     str))

; Les utilisateurs fran�ais souhaitent bien certainement avoir le
; fran�ais comme dictionnaire initial avec ispell. On peut le changer
; temporairement avec la commande M-x ispell-change-dictionary, et on
; peut explicitement s�lectionner un dictionnaire pour un fichier
; donn� gr�ce aux syst�mes des variables locales de EMACS.
;
; SeeAlso: ispell(1), (emacs)Spelling, (emacs)Locals.
(custom-set-variables '(ispell-local-dictionary "francais"))


;;; MODIFICATION DES MODES MAJEURS

; La variable `auto-mode-alist' est une liste associative d�crivant le
; mode majeur � utiliser pour tel ou tel fichier. Pour pouvoir ajouter
; facilement des valeurs � cette variable, on peut utiliser la fonction
; `mg-set-auto-mode'

(defun mg-set-auto-mode (REGEXP MODE)
  "mg-set-auto-mode REGEXP MODE adds this entry to the auto-mode-alist"
  (setq auto-mode-alist (cons (cons REGEXP MODE) auto-mode-alist))
  )


;; sh-mode
; Le mode SH est sp�cialis� dans l'�dition des scripts SHELL. Il
; conna�t les dialectes de SHELL les plus r�pandus, comme le shell de
; Bourne, le shell C, le shell K et le shell Z, et il assiste
; l'utilisateur dans la r�alisation d'une belle pr�sentation pour le
; dialecte de SHELL employ�.
;
; Le mode majeur int�rroge la base de donn�e des utilisateurs pour se
; pr�parer �diter un script dans le dialecte du SHELL de connexion de
; l'utilisateur. Par exemple pour les utilisateurs ayant le shell C
; comme shell de connexion, le mode sh-mode se pr�pare automatiquement
; � �diter un script dans le dialecte du shell C.
;
; Si on �dite la plupart du temps des fichiers de script dans le
; dialecte de Bourne, on peut utiliser la commande suivante.
(setq sh-shell-file "/bin/sh")

;; subversion
; Le programme SUBVERSION est un programme de contr�le des versions et
; des r�visions, � l'instar de son pr�decesseur CVS. Si vous n'avez
; jamais utilisez ce type de syst�me auparavant, vous pouvez
; consid�rer SUBVERSION comme une machine � voyager dans le temps qui
; vous permet de comparer l'�tat actuel d'un de vos fichiers de
; travail avec un �tat ant�rieur de ce fichier, par exemple il y a
; deux jours ou il y a trois mois.

; Le moduler PSVN fournit une interface entre EMACS et SVN. On utilise
; cette interface gr�ce � la commande `svn-examine'.
(require 'psvn)

; Lorsqu'on d�cide d'utiliser SUBVERSION avec PSVN, il est n�cessaire
; de positionner correctement des variables d'environnement pour que
; SUBVERSION tienne compte des diff�rents syst�mes de
; codage. Cependant, certaines fonctions de l'interface insistent pour
; que les messages �mis par SUBVERSION soient en anglais. Le
; d�veloppeur de l'interface obtient cet effet en �x�cutant SUBVERSION
; dans une environnement o� la variable LANG est li�e � la valeur C,
; mais SUBVERSION croit alors que les messages en entr�e sont en
; ASCII7 et n'arrive pas � convertir les caract�res accentu�s en
; UTF-8, format dans lequel il stocke les messages. Pour obtenir le
; comportement souhait� --- messages en anglais et recodage des ``log
; messages'' --- on peut remplacer la liaison "LANG=C" par la liaison
; "LC_MESSAGES=C" qui produit l'effet souhait� sur les messages sans
; masquer notre variable "LANG" qui indique le code utilis� pour
; transmettre le ``log message''.
(setq svn-status-svn-environment-var-list '("LC_MESSAGES=C"))

;; psgml
; Psgml est un mode sp�cialis� pour l'�dition des fichiers SGML et
; XML, il est en particulier d'une grande utilit� pour �diter les
; fichiers HTML (les pages web).

(require 'psgml-startup)

; La d�finition de la variable `sgml-catalog-files' d�clar�e par le
; programme `psgml' est fausse. Sur le syst�me Llea le catalogue des
; entit�s XML est un catalogue XML et ne peut �tre lu par `psgml'.

(setq sgml-catalog-files '("catalog" "/usr/local/share/sgml/catalog"))


;(autoload 'sgml-mode "psgml" "Major mode to edit SGML files." t)
;(autoload 'xml-mode "psgml" "Major mode to edit XML files." t)

;(setq sgml-custom-dtd
;      '(
;	("HTML 4.01"
;	 "<?xml version=\"1.0\" encoding=\"ISO-8859-15\"?>\n<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01//EN\">"
;	 sgml-default-dtd-file "~/.emacs.d/psgml/html_4.01.cdtd"
;	 sgml-indent-data t
;	 )
;	)
;      )

;(mg-set-auto-mode "\\.\\(ht\\|sg\\|x\\)ml$" 'psgml-mode)
(mg-set-auto-mode "\\.\\(ht\\|sg\\|x\\)ml$" 'sgml-mode)



;; tuareg
; Tuareg est un mode sp�cialis� pour l'�dition de fichiers du langage
; Objective Caml.

(require 'tuareg)
(autoload 'tuareg-mode "tuareg"
  "Major mode for editing and running Caml programs" t)
(mg-set-auto-mode "\\.ml\\(l\\|i\\|y\\)?$" 'tuareg-mode)


;; css-mode
(autoload 'css-mode "css-mode")
(mg-set-auto-mode "\\.css\\'" 'css-mode)
(setq cssm-mirror-mode 'nil)
(setq cssm-indent-function #'cssm-c-style-indenter)


;; emake
; Extra Make
(require 'emake)
(global-set-key '[f2] 'emake-all)
(global-set-key '[f3] 'emake-install)
(global-set-key '[f4] 'emake-clean)
(global-set-key '[f5] 'emake-run)

;; auc-tex
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)

;; ruby-mode
;; Taken from the comment section in inf-ruby.el
(autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files")
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))
(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook '(lambda () (inf-ruby-keys)))

;; �dition des fichiers sources BRID TeX
(add-to-list 'auto-mode-alist '("\\.\\(cls\\|sty\\|mac\\)$" . plain-TeX-mode))


;; Circonvention du BUG
(setenv "LANG" "fr_FR.ISO8859-1")

;;; End of file `dot.emacs'
