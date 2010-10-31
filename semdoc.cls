%% LaTeX2e Formatklasse fuer Seminarbeitraege
%% 
%% Autor: Roland Bless                              -*-Mode: LaTeX;-*-
%% -------------------------------------------------------------------
%% (falls die Umlaute nicht richtig dargestellt werden: 
%%  der benutzte Zeichensatz ist ISO 8859-1!)
%% Hinweis für Literatur zu LaTeX 2e:
%% 1. Leslie Lamport: "Das LaTeX-Handbuch", Addison-Wesley 1995
%% 2. Goosens, Mittelbach, Samarin: "Der LaTeX-Begleiter"
%% Referenz und Grundbefehle sind in 1. zu finden, 2. erklärt
%% Zusatz-Pakete, die einem Dokument ein individuelleres Aussehen verleihen
%% können.
%%
% -----------------------------------------------------------------
% $Id: semdoc.cls,v 1.17 2000/05/23 12:14:05 bless Exp $
% -----------------------------------------------------------------
% $Log: semdoc.cls,v $
% Revision 1.17  2000/05/23 12:14:05  bless
% Neues Makro für Abbildungen \Abbildungf.
%
% Revision 1.16  2000/05/23 11:26:46  bless
% Diverse Kommentare, bessere PDF-Unterstützung.
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}[1995/12/01] % Sorry, wir brauchen LaTeX2e!

\ProvidesClass{semdoc}[2000/05/22 Seminarbeitrag] 
\LoadClass[a4paper,11pt,twoside]{article} % diese Klasse basiert auf ``article''
\RequirePackage{ngerman}[1998/07/08] % (v2.5e) Neue Rechtschreibung 
\usepackage[latin1]{inputenc} % Eingabe nach ISO 8859-1 (Latin1)
                              % siehe Emacs: iso-accents-mode
\usepackage[final]{graphicx}  % um Graphiken einzubinden (Standard Graphik-Paket)
\usepackage{ae}               % Für vernünftige Type-1-Fonts in PDFs
\usepackage{vmargin}          % Seitenränder einstellen leichtgemacht
%
% Benutze ``Cork'' FontEncoding, damit jeder Umlaut ein eigenes
% Zeichen bekommt (vorher war er durch Zeichen mit Akzent dargestellt). 
% Dadurch ist es möglich, daß Wörter mit Umlauten automatisch 
% getrennt werden können. 
\usepackage[T1]{fontenc}
% Postscript Fonts
% times, palatino, newcent, bookman, garamond, basker, 
% lucid, lucidbrb, lucidbry (Kommerzielle Fonts von Y&Y)
% \usepackage{newcent}      %for sophisticated font style
\usepackage{array}          % fuer aufwändigere Tabellen
\usepackage{colortbl}       % farbige Tabellen (v. D. Carlisle)
\usepackage{longtable}      % seitenübergreifende Tabellen
%% ---------------- end of usepackages -------------
%%
%%
% Optionen:
% alltogether - Zum Zusammenbinden der einzelnen Teilbeiträge zu einem Bericht
%
% draft - Läßt Titelseite, Inhaltsverzeichnis, Index, etc. weg.
%         Dafür muß allerdings die Unterstützung in der LaTeX Hauptdatei
%         vorhanden sein (\ifnotdraft{\include{bla...}}).
% relaxed - erlaubt etwas unschönere Abstände für automatische Zeilenumbrüche
%
% nolot   - Unterdrückt ein Tabellenverzeichnis am Ende eines jeden Beitrags
% nolof   - Unterdrückt ein Abbildungsverzeichnis am Ende eines jeden Beitrags
% citeall - Listet auch nicht-referenzierte Literatur auf
% pdf     - erzwingt bestimmte Einstellungen für PDF, wird automatisch bei
%           Aufruf von PDFlatex gesetzt (sollte zumindest)
\DeclareOption{alltogether}{\@alltogethertrue}
\DeclareOption{draft}{\let\@draft\@empty}
\DeclareOption{relaxed}{\tolerance=2000 \emergencystretch=20pt}
\DeclareOption{nolot}{\@uselotfalse}
\DeclareOption{nolof}{\@useloffalse}
\DeclareOption{citeall}{\def\@citeall{\nocite{*}}}
\DeclareOption{pdf}{\@usepdfttrue}
%% Default values and Option Processing
\newif\if@alltogether \@alltogetherfalse % no compound document
\newif\if@uselot \@uselottrue % create list of figures after every part
\newif\if@uselof \@useloftrue % create list of tables after every part
\newif\if@usepdf \@usepdffalse % not pdf ready
\let\@draft\@undefined        % no draft
\let\@shorttitle\@empty       % no shorttitle
\let\@citeall\relax           % do not cite all bibliography
\ProcessOptions
%%

%% Optionale URL für Autor, z.B. Aufruf nach \author{}
\let\@authorurl\@empty
\newcommand{\authorURL}[1]{\def\@authorurl{#1}}
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% alltogether option
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\if@alltogether
 %% Für den Gesamtband aktivieren wir die \chapter Makros
 \newcommand\chapter{\secdef\@chapter\@schapter}

 %% \chapter{} erzeugt lediglich einen Eintrag im Inhaltsverzeichnis
 \def\@chapter[#1]#2{\let\@author\@xauthor % We want a clean author, added by R.Bless%
                         \refstepcounter{chapter}%
                         \ifx\@author\@empty
                         \else
                         \let\OldWriteBookmarks\WriteBookmarks
                         \let\WriteBookmarks\relax
                         \addcontentsline{toc}{author}{\@author} % added by R.Bless
                         \let\WriteBookmarks\OldWriteBookmarks
                         \fi
                          \addcontentsline{toc}{chapter}{#1}%
}
 
 %% \chapter*{} erzeugt einen Eintrag im Inhaltsverzeichnis, führt einen
 %% Seitenvorschub aus und setzt eine Überschrift in \Large und \bf
 \def\@schapter#1{\cleardoublepage
                  \thispagestyle{plain}%
                  \markboth{#1}
                  \global\@topnum\z@
                  \@afterindentfalse
                  \let\tmp@xauthor\@xauthor
                  \let\@xauthor\@empty
                  \@dblarg{\@chapter}{#1}
                  \let\@xauthor\tmp@xauthor
                  {\normalfont\Large\bfseries #1}\par%
                  \vskip 2.3ex \@plus.2ex
 }
 % es ist wichtig, dass dies hier _vor_ dem hyperref-Paket
 % eingebunden wird, damit das Inhaltsverzeichnis nachher stimmt
 % (nur wenn \thechapter definiert ist, wird in Abhängigkeit von diesem
 % gezählt)
 \newcounter{chapter} 
 \renewcommand\thechapter{\@Alph\c@chapter}
 % Der section-counter wird bei Hochzählen durch \chapter wieder zurückgesetzt
 \@addtoreset{section}{chapter}

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % docbegin
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 \newcommand{\docbegin}{%
 \renewcommand\thechapter{\@arabic\c@chapter}
 \renewcommand\thesection{\@arabic\c@section}
 \setcounter{subsection}{0}
 \setcounter{figure}{0}
 \setcounter{table}{0}
 \let\etalchar\@undefined % if including multiple bibfiles
 } % end \docbegin
 \AtBeginDocument{\opentmptocs}
 \AtEndDocument{\closetmptocs}
 %
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % docend
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 \newcommand{\docend}{%
 \setcounter{tocdepth}{1}
 \if@uselof
  \addcontentsline{toc}{section}{\listfigurename}
  \tmplistoffigures
 \fi
 \if@uselot
  \addcontentsline{toc}{section}{\listtablename}
  \tmplistoftables
 \fi
 \clearpage{\pagestyle{empty}\cleardoublepage}
 \setcounter{tocdepth}{2}
 \let\@shorttitle\@empty
 } % end \docend
\else % single document
 \newcommand{\docbegin}{\begin{document}\@citeall}%
 \newcommand{\docend}{\end{document}}
 \relax
\fi % endif if@alltogether
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end alltogether option
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PDF dependent stuff (inspired by Frank Pählke)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ifx\pdftexversion\@undefined % kein PDFTeX aktiv
\newcommand\pdfinfo[1]{}
\else
\@usepdftrue % switch automatically to PDF mode
\fi

\if@usepdf
 \usepackage{ae}      % erzeuge lesbare Schriften (mit cmps-Fonts)
 \usepackage{color}   % für farbige Hyperlinks benötigt
 \usepackage[raiselinks=true,%
             bookmarks=true,%
             pdfborder={0 0 0.5}]{hyperref} % erzeuge Hyperlinks z.B. für pdflatex
 \usepackage{thumbpdf}
 \pdfcompresslevel=9   % scheint zwar nichts zu bringen, aber was soll's
 % Hyperref verträgt sich leider nicht richtig mit chapterbib.sty
 % In chapterbib gibt es aber hooks, die jetzt verwendet werden sollen.
 \gdef\@extra@binfo{}
 % we should redefine this because of chapterbib
 \def\bibcite#1#2{%
    \@newl@bel{b}{#1\@extra@binfo}{\hyper@@link[cite]{}{cite.#1}{#2}}%
 }%
\fi

\newif\if@usehyperref
\ifx\href\@undefined % Wenn kein hyperref Paket geladen
\@usehyperreffalse % hyperref used
\else
\@usehyperreftrue % hyperref used
\fi

\if@usehyperref
\newcommand{\urltext}[1]{\href{#1}{#1}} % URL die im Text ausgegeben wird.
\else
% Einige Dummy-Makros als Ersatz für das hyperref-Paket:
\newcommand{\href}[2]{#2}
\newcommand{\hyperbaseurl}[1]{}
\newcommand{\hyperimage}[1]{[IMAGE: #1]}
\newcommand{\hyperdef}[2]{}
\newcommand{\hyperref}[4]{#4}
\newcommand{\hyperlink}[2]{#2}
\newcommand{\hypertarget}[2]{#2}
\let\pdfbookmark\@gobbletwo
\newcommand{\urltext}[1]{#1}
\fi

%% Einstellungen für Verzeichnisse
\setcounter{secnumdepth}{3} % Numerierung auch für \subsubsection
\setcounter{tocdepth}{2}    % Nur Autor und Titel, keine sections etc.
\bibliographystyle{itmalpha}  % Für bibtex

% Für float Paket
%\floatstyle{ruled}
%\restylefloat{figure}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Seitengröße/-ränder mit vmargin-Paket einstellen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\setpapersize{A4}
% \setmarginsrb{randlinks}{randoben}{randrechts}{randunten}
%              {hoehekopf}{abstkopf}{hoehefuss}{abstfuss}
\setmarginsrb{2.75cm}{1cm}{2.75cm}{1cm}{6mm}{7mm}{5mm}{15mm}

%% Stil
\parindent 0cm                     % Absatzanfang wird nicht eingerückt
\parskip1.5ex plus0.5ex minus0.5ex % Abstand zwischen zwei Absätzen

\renewenvironment{quotation}
               {\list{}{\listparindent 0em%
                        \itemindent    \listparindent
                        \rightmargin   \leftmargin
                        \parsep        1.5ex plus0.5ex minus0.5ex}%
                \item\relax}
               {\endlist}


\renewcommand\paragraph[1]{\@startsection{paragraph}{4}{\z@}%
                                    {3.25ex \@plus1ex \@minus.2ex}%
                                    {-0.5em}%
                                    {\normalfont\normalsize\slshape}{#1\hspace{0.8em}---}}

%% Schusterjungen und Hurenkinder verhindern.
%% Siehe deutsches TeX-FAQ (6.1.3)
\clubpenalty = 10000
\widowpenalty = 10000
\displaywidowpenalty = 10000

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% New Commands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ignore}[1]{}

%% Graphik, 
%% 3 Argumente: Datei, Label, Unterschrift
\newcommand{\Abbildung}[3]{%
\begin{figure}[tbh] %
\centerline{\includegraphics*{#1}} %
\caption{#3} %
\label{#2} %
\end{figure} %
}

%% Graphik, Angabe der Position, frei wählbares Argument für includegraphics
%% 5 Argumente: Position, Optionen, Datei, Label, Unterschrift
\newcommand{\Abbildungf}[5]{%
\begin{figure}[#1]%
\begin{center}
\includegraphics*[#2]{#3}%
\caption{#5}%
\label{#4}%
\end{center}
\end{figure}%
}


\newcommand{\shorttitle}[1]{\def\@shorttitle{#1}}
\newcommand{\ifnotdraft}[1]{\ifx\@draft\@undefined #1 \fi}
\newcommand{\PBS}[1]{\let\temp=\\#1\let\\=\temp} % PreserveBackSlash für Tabellen mit \raggedright
%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Inhaltsverzeichnis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\renewcommand\tableofcontents{%
    {\normalfont\Large\bfseries\contentsname}%
    \pdfbookmark{\contentsname}{\contentsname}
    \setcounter{tocdepth}{0}    % Nur Autor und Titel, keine sections etc.
    \@starttoc{toc}%
    \setcounter{tocdepth}{2}    % 
    }
%\def\@pnumwidth{1.55em}
%\def\@tocrmarg {2.55em}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% \author
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Redefiniere \author, damit Fußnoten im \author kein Unheil anrichten
% (by R. Bless)
\def\author#1{\gdef\@author{#1}%
\let\oldfootnote=\footnote\let\footnote\@gobble%
\global\protected@edef\@xauthor{#1}\relax\let\footnote=\oldfootnote%
}

% Für den Autor im Inhaltsverzeichnis
\newcommand*\l@author[2]{%
  \ifnum \c@tocdepth >\m@ne
    \addpenalty{-\@highpenalty}%
    \vskip 1.0em \@plus\p@
    \setlength\@tempdima{1.5em}%
    \begingroup
      \advance\leftskip\@tempdima
      \hskip -\leftskip
      \textit{#1:}\nobreak\hfill\vskip-1.5\bigskipamount%
      \penalty\@highpenalty
    \endgroup
  \fi}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% \title
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Für den Titel im Inhaltsverzeichnis
\newcommand*\l@chapter[2]{%
  \ifnum \c@tocdepth >\m@ne
    \penalty\@highpenalty% (R.Bless) Halte Autor und Titel zusammen
                         % war vorher \addpenalty{-\@highpenalty}% 
    \vskip 1.0em \@plus\p@
    \setlength\@tempdima{1.5em}%
    \begingroup
      \leftskip 0em\relax \rightskip \@tocrmarg \parfillskip -\rightskip
      \parindent \z@ \relax\@afterindenttrue
      \interlinepenalty\@M
      \leavevmode
      \null\nobreak
      \let\temp=\\%
      \let\\=\empty%
      \textbf{#1}\let\\=\temp%
        \nobreak\leaders\hbox{$\m@th \mkern \@dotsep mu\hbox{.}\mkern \@dotsep
        mu$}\hfill
      \nobreak
      \hb@xt@\@pnumwidth{\hss #2}\par
      \penalty\@highpenalty
    \endgroup
  \fi}

% Maketitle muß mehrfach ausgeführt werden können
\if@titlepage
  \renewcommand\maketitle{\begin{titlepage}%
  \let\footnotesize\small
  \let\footnoterule\relax
  \let \footnote \thanks
  \null\vfil
  \vskip 60\p@
  \begin{center}%
    {\LARGE \@title \par}%
    \vskip 3em%
    {\large
     \lineskip .75em%
      \begin{tabular}[t]{c}%
        \@author
      \end{tabular}\par}%
      \vskip 1.5em%
    {\large \@date \par}%       % Set date in \large size.
  \end{center}\par
  \@thanks
  \vfil\null
  \end{titlepage}%
  \setcounter{footnote}{0}%
  \if@alltogether % added by R.Bless
  \else
     \global\let\thanks\relax
     \global\let\maketitle\relax
     \global\let\@thanks\@empty
     \global\let\@author\@empty
     \global\let\@date\@empty
     \global\let\@title\@empty
     \global\let\title\relax
     \global\let\author\relax
     \global\let\date\relax
     \global\let\and\relax
  \fi
}
\else
\renewcommand\maketitle{\par
  \setcounter{footnote}{0} % reset counter for thanks, added by R. Bless
  \begingroup
    \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{\parindent 1em\noindent
            \hb@xt@1.8em{%
                \hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
    \if@twocolumn
      \ifnum \col@number=\@ne
        \@maketitle
      \else
        \twocolumn[\@maketitle]%
      \fi
    \else
      \newpage
      \global\@topnum\z@   % Prevents figures from going at top of page.
      \@maketitle
    \fi
    \thispagestyle{plain}\@thanks
  \endgroup
  \setcounter{footnote}{0}% reset counter for footnotes

  \if@alltogether % added by R.Bless
    \chapter{\@title} % added by R.Bless
    \ifx\@shorttitle\@empty    % added by R.Bless
        \let\@shorttitle\@title% added by R.Bless
    \fi                        % added by R.Bless
    \global\let\@thanks\@empty % stop thanks, added by R. Bless
  \else
    \global\let\thanks\relax
    \global\let\maketitle\relax  
    \global\let\@maketitle\relax 
    \global\let\@thanks\@empty
    \global\let\@author\@empty
    \global\let\@date\@empty
    \global\let\@title\@empty
   \global\let\title\relax
    \global\let\author\relax
    \global\let\date\relax
    \global\let\and\relax
  \fi
}

\def\@maketitle{%
  \newpage
  \null
  \vskip 2em%
  \begin{center}%
  \let \footnote \thanks
    {\Large\textbf{\@title}\par}% %changed by R.Bless
    \vskip 1.5em% 
    {\normalsize\mdseries %changed by R.Bless
      \lineskip .5em%
      \begin{tabular}[t]{c}%
          \href{\@authorurl}{\@author}
      \end{tabular}\par}%
    \vskip 1em%
    % {\large \@date}% %commented out by R.Bless
  \end{center}%
  \par
  \vskip 1.5em
}
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This is for temporary lof and lot for every part of the report
%% (by R. Bless)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newif\if@tmplofexists
\newif\if@tmplotexists
\newif\if@loforlot
%% new toc for every part
\def\opentmptocs{%
\if@uselof
 \newwrite\@mylof
 \immediate\openout\@mylof\jobname.tlf\relax
 %\typeout{ *** Opening mylof }
\fi
\@tmplofexistsfalse
\if@uselot
 \newwrite\@mylot
 \immediate\openout\@mylot\jobname.tlt\relax
 %\typeout{ *** Opening mylot }
\fi
\@tmplotexistsfalse
}

\def\closetmptocs{%
\if@uselot
 \immediate\closeout\@mylot
\fi
\if@uselof
 \immediate\closeout\@mylof
\fi
}

\let\oldaddtocontents\addtocontents
\long\def\addtocontents#1#2{%
 \oldaddtocontents{#1}{#2}
   \edef\ext{#1}
   \@loforlotfalse
   \ifx\ext\ext@figure
      \@loforlottrue
      \global\@tmplofexiststrue
   \fi
   \ifx\ext\ext@table
      \@loforlottrue
      \global\@tmplotexiststrue
   \fi
   \if@loforlot
      \@ifundefined{@my#1} \relax
      {
        %\typeout{** Writing temporary #1 **}
        \protected@write{\csname @my#1\endcsname}
        {\let\label\@gobble \let\index\@gobble \let\glossary\@gobble}%
        {#2}
      }
   \fi
}

\def\tmplistoffigures{%
\if@tmplofexists
 \section*{\listfigurename}
 {%
  \begingroup
  \markright{\listfigurename}
  \immediate\write\@mylof{\relax}
  \immediate\closeout\@mylof
  \makeatletter
  \@input{\jobname.tlf}
  \endgroup
 }
 \immediate\openout\@mylof\jobname.tlf\relax
 \global\@tmplofexistsfalse
\fi
}

\def\tmplistoftables{%
\if@tmplotexists
 \section*{\listtablename}
 {%
  \begingroup
  \markright{\listtablename}
  \immediate\write\@mylot{\relax}
  \immediate\closeout\@mylot
  \makeatletter
  \@input{\jobname.tlt}
  \endgroup
 }
 \immediate\openout\@mylot\jobname.tlt\relax
 \global\@tmplotexistsfalse
\fi
} %enddef tmplistoftables


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% pagestyle fuer Titelseite:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\titlehead#1{\def\@titlehead{#1}}
\def\titlefoot#1{\def\@titlefoot{#1}}
\def\@titlehead{}
\def\@titlefoot{}

\def\ps@title{%
\headheight 15mm
\footskip   0cm
\addtolength{\textheight}{-15mm}
\let\@mkboth\@gobbletwo%
  \def\@oddhead{\vbox{\hbox to\textwidth{\@titlehead}
                \vskip 1.5mm
                \hbox to\textwidth{\hrulefill}}}
  \def\@oddfoot{\vbox{\hbox to\textwidth{\hrulefill}
                \hbox to\textwidth{\@titlefoot}}}
  \let\@evenhead\@oddhead
  \let\@evenfoot\@oddfoot
}

\renewenvironment{titlepage}
{%
  \let\oldheadheight\headheight
  \let\oldfootskip\footskip
  \let\oldtextheight\textheight
  
   \cleardoublepage
   \if@twocolumn
      \@restonecoltrue\onecolumn
   \else
      \@restonecolfalse\newpage
    \fi
    \thispagestyle{title}%
    \setcounter{page}\@ne
}%
{\if@restonecol\twocolumn \else \newpage \fi
 \if@twoside\else
    \setcounter{page}\@ne
 \fi
 \let\headheight\oldheadheight
 \let\textheight\oldtextheight
 \let\footskip\oldfootskip
}

%% raggedright bibliography
\if@alltogether
\else
 \let\oldbibliography\bibliography
 \renewcommand{\bibliography}[1]{%
 \clearpage
 {\raggedright
  \oldbibliography{#1}}
 }
\fi
%% **** END OF CLASS ****
