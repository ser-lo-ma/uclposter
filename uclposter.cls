%% uclposter.cls
%% A0 portrait research poster following the UCL PowerPoint template
%% "UCL-A0_Poster_Template-Portrait.pptx" (2025 UCL brand: new logo, UCL Sans).
%%
%% Sizes and colours are selected to replicate the official .pptx UCL templates
%% (slide masters, layouts and theme). Positions are in mm from the top-left page corner.
%%
%% Compile with LuaLaTeX or XeLaTeX to get UCL Sans. pdfLaTeX works but it will not
%% let you select the UCL fonts.
%%
%% Unofficial: this is not produced or endorsed by UCL. Class code released under MIT.
%% The UCL logo files are UCL's property and are subject to UCL brand rules.
%% The UCL Sans font files are under the SIL Open Font License (fonts/OFL.txt).

\NeedsTeXFormat{LaTeX2e}[2020/10/01]
\RequirePackage{fix-cm}
\ProvidesClass{uclposter}[2026/10/06 v1.0 UCL A0 portrait poster (2025 brand template)]

%% ---------------------------------------------------------------- options
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=uclposter,prefix=uclposter@}
\DeclareStringOption[dark]{banner}      % dark | light
\DeclareStringOption[]{font}            % override the font family (system font name)
\DeclareStringOption[fonts/]{fontdir}   % folder searched for UCLSans-*.otf / .ttf
\DeclareBoolOption[true]{sansmath}      % sans-serif maths
\DeclareBoolOption[false]{showgrid}     % draw the template guides and the 12x6 grid
\ProcessKeyvalOptions*
\LoadClass{article}

\RequirePackage{iftex}
\RequirePackage{etoolbox}
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{tikz}
\RequirePackage[poster]{tcolorbox}
\RequirePackage{enumitem}
\RequirePackage{caption}

%% ---------------------------------------------------------------- geometry
%% Slide: 841 x 1189 mm. Side margins 40 mm; content boxes run from
%% y = 200.5 mm to y = 1088.5 mm (template guides).
\RequirePackage[paperwidth=841mm,paperheight=1189mm,
  left=40mm,right=40mm,top=200.5mm,bottom=100.5mm,
  headheight=0pt,headsep=0pt,footskip=0pt,marginparwidth=0pt,marginparsep=0pt]{geometry}
\pagestyle{empty}
\setlength\parindent{0pt}
\setlength\topskip{0pt}
\setlength\parskip{0pt}

%% ---------------------------------------------------------------- colours
%% Theme "UCL CMYK" in the template (PowerPoint theme slot in brackets).
\definecolor{UCLDarkPurple}{HTML}{240E3C}   % [text 2]   banner, all text
\definecolor{UCLWhite}{HTML}{FAFAFA}        % [bg 1]     page, text on banner
\definecolor{UCLPalePurple}{HTML}{F1EAEF}   % [accent 3] content boxes
\definecolor{UCLLightPurple}{HTML}{DBD1DE}  % [accent 2]
\definecolor{UCLMidPurple}{HTML}{9E8CB6}    % [bg 2]
\definecolor{UCLPurple}{HTML}{8068A0}       % [accent 1]
\definecolor{UCLBlue}{HTML}{63C3DA}         % [accent 4]
\definecolor{UCLPink}{HTML}{ED367D}         % [accent 6]
\definecolor{UCLLink}{HTML}{2F91FA}         % [hyperlink]
\definecolor{UCLLogoPurple}{HTML}{9370B0}   % portico in the logo artwork
\pagecolor{UCLWhite}

%% ---------------------------------------------------------------- fonts
%% Template: UCL Sans (body) and UCL Sans SemiBold (title, authors, headings).
%% Official fallback is Aptos. Last resort here: TeX Gyre Heros (Arial-like;
%% Arial is the template's theme font).
\newcommand\uclposter@fontused{}
\ifPDFTeX
  \RequirePackage[T1]{fontenc}
  \RequirePackage{helvet}
  \renewcommand\familydefault{\sfdefault}
  \IfFileExists{t1lmtt.fd}{\renewcommand\ttdefault{lmtt}}{}% scalable \texttt
  \renewcommand\uclposter@fontused{Helvetica clone (pdfLaTeX)}
  \AtEndDocument{\ClassWarningNoLine{uclposter}{pdfLaTeX cannot load UCL Sans.
    Compile with LuaLaTeX or XeLaTeX for the brand typeface}}
\else
  \RequirePackage[no-math]{fontspec}  % maths fonts are handled further down
  % #1 = family name as the system knows it. Uses "<name> SemiBold" for bold
  % when it exists.
  \newcommand\uclposter@byname[1]{%
    \IfFontExistsTF{#1 SemiBold}{%
      \IfFontExistsTF{#1 SemiBold Italic}{%
        \setsansfont{#1}[Ligatures=TeX,BoldFont={#1 SemiBold},BoldItalicFont={#1 SemiBold Italic}]%
      }{%
        \setsansfont{#1}[Ligatures=TeX,BoldFont={#1 SemiBold}]%
      }%
    }{\setsansfont{#1}[Ligatures=TeX]}%
    \renewcommand\uclposter@fontused{#1}}
  % #1 = extension. Files UCLSans-Regular, -Italic, -SemiBold, -SemiBoldItalic.
  \newcommand\uclposter@byfile[1]{%
    \setsansfont{UCLSans}[Ligatures=TeX,Path=\uclposter@fontdir,Extension=#1,
      UprightFont=*-Regular,ItalicFont=*-Italic,
      BoldFont=*-SemiBold,BoldItalicFont=*-SemiBoldItalic]%
    \renewcommand\uclposter@fontused{UCL Sans (from \uclposter@fontdir)}}
  \ifdefempty{\uclposter@font}{%
    \IfFontExistsTF{UCL Sans}{\uclposter@byname{UCL Sans}}{%
      \IfFileExists{\uclposter@fontdir UCLSans-Regular.otf}{\uclposter@byfile{.otf}}{%
        \IfFileExists{\uclposter@fontdir UCLSans-Regular.ttf}{\uclposter@byfile{.ttf}}{%
          \IfFontExistsTF{Aptos}{\uclposter@byname{Aptos}}{%
            \setsansfont{texgyreheros}[Ligatures=TeX,Extension=.otf,
              UprightFont=*-regular,ItalicFont=*-italic,
              BoldFont=*-bold,BoldItalicFont=*-bolditalic]%
            \renewcommand\uclposter@fontused{TeX Gyre Heros}%
            \AtEndDocument{\ClassWarningNoLine{uclposter}{UCL Sans not found
              (neither installed nor in `\uclposter@fontdir'), and no Aptos.
              Using TeX Gyre Heros instead}}%
          }}}}%
  }{\expandafter\uclposter@byname\expandafter{\uclposter@font}}
  \renewcommand\familydefault{\sfdefault}
\fi
%% One typeface throughout: \rmfamily (used e.g. by siunitx) is the same font.
\edef\rmdefault{\sfdefault}
\AtEndDocument{\typeout{uclposter: text font = \uclposter@fontused}}

%% Sizes. Template: body 36 pt, footer 28.6 pt, nothing below 24 pt except
%% captions. Line spacing in the template is PowerPoint's "0.9 lines".
\renewcommand\normalsize{\@setfontsize\normalsize{36pt}{42pt}%
  \abovedisplayskip 24pt \@plus 6pt \@minus 10pt
  \abovedisplayshortskip 8pt \@plus 6pt
  \belowdisplayshortskip 16pt \@plus 6pt \@minus 6pt
  \belowdisplayskip \abovedisplayskip
  \let\@listi\@listI}
\renewcommand\small{\@setfontsize\small{28.6pt}{34pt}}
\renewcommand\footnotesize{\@setfontsize\footnotesize{24pt}{29pt}}
\renewcommand\scriptsize{\@setfontsize\scriptsize{20pt}{24pt}}
\renewcommand\tiny{\@setfontsize\tiny{16pt}{19pt}}
\renewcommand\large{\@setfontsize\large{48pt}{54pt}}
\renewcommand\Large{\@setfontsize\Large{60pt}{66pt}}
\renewcommand\LARGE{\@setfontsize\LARGE{72pt}{78pt}}
\renewcommand\huge{\@setfontsize\huge{96pt}{102pt}}
\renewcommand\Huge{\@setfontsize\Huge{120pt}{126pt}}
\DeclareMathSizes{16}{16}{12}{10}
\DeclareMathSizes{20}{20}{15}{12}
\DeclareMathSizes{24}{24}{18}{14}
\DeclareMathSizes{28.6}{28.6}{21}{16}
\DeclareMathSizes{36}{36}{26}{20}
\DeclareMathSizes{48}{48}{34}{26}
\DeclareMathSizes{60}{60}{42}{32}
\DeclareMathSizes{72}{72}{50}{38}
\DeclareMathSizes{96}{96}{68}{50}
\DeclareMathSizes{120}{120}{84}{62}
\normalsize

%% Fonts for the fixed template elements. \renewcommand any of these in the
%% preamble to move within the ranges the template allows.
\newcommand\ucltitlefont{\fontsize{72pt}{78pt}\bfseries\selectfont}        % 72 pt, max 3 lines
\newcommand\uclauthorfont{\fontsize{36pt}{40pt}\bfseries\selectfont}       % 36-48 pt, max 3 lines
\newcommand\uclaffiliationfont{\fontsize{36pt}{40pt}\mdseries\selectfont}  % 24-36 pt
\newcommand\uclfooterfont{\fontsize{28.6pt}{34pt}\mdseries\selectfont}     % 28.6 pt
\newcommand\uclheadingfont{\fontsize{48pt}{54pt}\bfseries\selectfont}      % box headings: bold

%% Maths. With sansmath (default) the mathastext package sets letters and
%% digits in maths from the text font, so equations match the body text on
%% every engine. Symbols and Greek stay Computer Modern. No unicode-math, so
%% bm, amssymb, mathtools, physics etc. load as usual.
\RequirePackage{amsmath}
% amsmath caps cmex at 24.88 pt; let big operators scale to poster sizes
\DeclareFontShape{OMX}{cmex}{m}{n}{<-7.5>cmex7<7.5-8.5>cmex8<8.5-9.5>cmex9<9.5->cmex10}{}
\ifuclposter@sansmath
  \RequirePackage[italic,defaultmathsizes]{mathastext}
\fi

%% ---------------------------------------------------------------- metadata
\newcommand\uclposter@affiliation{}
\newcommand\uclposter@contact{}
\newcommand\uclposter@footerlogos{}
\newcommand\affiliation[1]{\renewcommand\uclposter@affiliation{#1}}
\newcommand\institute[1]{\renewcommand\uclposter@affiliation{#1}}  % tikzposter/beamer name
\newcommand\contact[1]{\renewcommand\uclposter@contact{#1}}
\newcommand\footerlogos[1]{\renewcommand\uclposter@footerlogos{#1}}
\title{}\author{}\date{}
\renewcommand\maketitle{}  % the banner is drawn on every page

%% Logo. Template: 142.2 x 40 mm at (40, 35.5). "Logo size and position
%% should not be altered", so these are not options.
\newcommand\uclposter@logo{}
\newcommand\ucllogofile[1]{\renewcommand\uclposter@logo{#1}}

\newif\ifuclposter@dark
\def\uclposter@tmp{dark}
\ifx\uclposter@banner\uclposter@tmp
  \uclposter@darktrue
  \ucllogofile{logos/ucl-logo-on-dark}
  \colorlet{uclbannertext}{UCLWhite}
\else
  \def\uclposter@tmp{light}
  \ifx\uclposter@banner\uclposter@tmp\else
    \ClassError{uclposter}{Unknown banner `\uclposter@banner'}{Use banner=dark or banner=light.}
  \fi
  \ucllogofile{logos/ucl-logo-on-light}
  \colorlet{uclbannertext}{UCLDarkPurple}
\fi

%% ---------------------------------------------------------------- page furniture
%% Drawn in the shipout background, in template coordinates:
%% x to the right, y downwards, both in mm from the top-left paper corner.
%% PowerPoint text boxes have a 2.54 mm side inset and 1.27 mm top inset.
\tikzset{
  uclposter text/.style 2 args={anchor=north west,inner xsep=2.54mm,inner ysep=1.27mm,
    outer sep=0pt,align=flush left,text width=#1mm-5.08mm,font=#2},
}
\newcommand\uclposter@furniture{%
  \begin{tikzpicture}[overlay,x=1mm,y=-1mm]
    \ifuclposter@dark
      \fill[UCLDarkPurple] (0,0) rectangle (841,180.4);
    \fi
    \node[anchor=north west,inner sep=0pt,outer sep=0pt] at (40,35.5)
      {\includegraphics[width=142.2mm,height=40mm]{\uclposter@logo}};
    \begin{scope}[text=uclbannertext]
      \node[uclposter text={570.1}{\ucltitlefont}] at (230.5,35.5) {\@title};
      \node[uclposter text={311.1}{\uclauthorfont}] at (230.5,127.3) {\@author};
      \node[uclposter text={247.0}{\uclaffiliationfont}] at (553.5,127.3) {\uclposter@affiliation};
    \end{scope}
    \begin{scope}[text=UCLDarkPurple]
      \node[uclposter text={369.7}{\uclfooterfont}] at (40.8,1103.5) {\uclposter@contact};
      \node[uclposter text={370.1}{\uclfooterfont}] at (430.5,1103.5) {\uclposter@footerlogos};
    \end{scope}
  \end{tikzpicture}}
\AddToHook{shipout/background}{\put(0,0){\normalfont\normalsize\hyphenpenalty=10000\relax\uclposter@furniture}}

%% Template guides (View > Guides in PowerPoint), for checking a layout.
\newcommand\uclposter@guides{%
  \begin{tikzpicture}[overlay,x=1mm,y=-1mm]
    \draw[UCLPink,line width=0.6mm,dash pattern=on 6mm off 4mm]
      (39.5,35.5) rectangle (800.5,1153.5)
      (0,180.4) -- (841,180.4)  (0,200.5) -- (841,200.5)
      (0,1088.5) -- (841,1088.5)  (230.5,35.5) -- (230.5,180.4);
  \end{tikzpicture}}
\ifuclposter@showgrid
  \AddToHook{shipout/foreground}{\put(0,0){\uclposter@guides}}
\fi

%% ---------------------------------------------------------------- content grid
%% 12 columns x 6 rows with 12 mm gutters over the content area: the same
%% guides the PowerPoint layouts are drawn on (span=6 gives 374.5 mm, the
%% template's two-column box; rowspan=3 gives 438 mm, its half-height box).
\tcbset{poster/.cd,columns=12,rows=6,spacing=12mm}
\tcbset{
  ucl box/.style={enhanced,sharp corners,boxrule=0pt,boxsep=0pt,
    colframe=UCLPalePurple,colback=UCLPalePurple,colbacktitle=UCLPalePurple,
    colupper=UCLDarkPurple,collower=UCLDarkPurple,coltitle=UCLDarkPurple,
    left=10mm,right=10mm,top=10mm,bottom=10mm,
    toptitle=10mm,bottomtitle=0mm,titlerule=0pt,
    fonttitle=\uclheadingfont\raggedright,
    fontupper=\normalsize,valign=top,
    before upper={\raggedright\setlength\parskip{0.5\baselineskip}},
    % fixed-height boxes do not grow: report content that does not fit
    finish={\ifdim\tcbheightspace<-1pt\relax
        \ClassWarning{uclposter}{Box content is about
          \strip@pt\dimexpr-0.3515\dimexpr\tcbheightspace\relax\relax\space mm
          too tall for its box and spills out of it}%
        \ifuclposter@showgrid
          \fill[UCLPink] (frame.south west) rectangle ([yshift=4mm]frame.south east);
        \fi
      \fi},
  },
  % dark purple box with light text
  ucl dark/.style={colframe=UCLDarkPurple,colback=UCLDarkPurple,colbacktitle=UCLDarkPurple,
    colupper=UCLWhite,collower=UCLWhite,coltitle=UCLWhite},
  % no fill: for a figure or logo strip sitting straight on the page
  ucl plain/.style={colframe=UCLWhite,colback=UCLWhite,colbacktitle=UCLWhite,
    left=0mm,right=0mm,top=8mm,bottom=0mm,toptitle=0mm},
}
\ifuclposter@showgrid \tcbset{poster/.cd,showframe=true} \fi

\newenvironment{uclposter}[1][]
  {\noindent\begin{tcbposter}[boxes={ucl box},#1]}
  {\end{tcbposter}}

%% ---------------------------------------------------------------- body defaults
\setlist{leftmargin=*,labelsep=0.5em,topsep=0.3\baselineskip,partopsep=0pt,
  itemsep=0.3\baselineskip,parsep=0pt}
\setlist[itemize,1]{label=\textbullet}
\setlist[itemize,2]{label=\textendash}
\captionsetup{font=footnotesize,labelfont=bf,justification=raggedright,
  singlelinecheck=false,skip=6mm}
\AtBeginDocument{\@ifpackageloaded{hyperref}{\hypersetup{hidelinks}}{}}
\endinput
