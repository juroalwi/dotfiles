% This class requuires 2e version of latex.
\NeedsTeXFormat{LaTeX2e}

% Name of the class and last update date.
\ProvidesPackage{mydocumentclass}[2022/18/08 Math notes class]

% Beginning of preamble.

% Base class.
\LoadClass[answers,12pt,a4paper]{exam}

%---------------- Language and writing ----------------%
% Default languages.
\RequirePackage[english,spanish]{babel} 
% Accents
\RequirePackage[utf8]{inputenc}  
% Syllables.
\RequirePackage[T1]{fontenc}  
% Font.
\RequirePackage{lmodern}  

%---------------- Page and text format ----------------%
% Margins.
\RequirePackage[margin=3cm,tmargin=4cm,bmargin=6cm]{geometry}
% Indentation.
\setlength{\parindent}{0pt} 
% Space between paragraphs.
\setlength{\parskip}{8pt} 
% Espacio entre líneas
\renewcommand{\baselinestretch}{1.5}
% Espacio entre líneas dentro del entorno 'align'
\setlength{\jot}{16pt}

% Titles options % (titlesec package must go before titleps!):
\RequirePackage[nobottomtitles*]{titlesec}
% Avoid titles at the bottom of the page
\renewcommand{\bottomtitlespace}{0.5\textheight}
% Formats
\titleformat{\section}
{\normalfont\LARGE \bfseries}{\thesection}{1em}{}
\titleformat{\subsection}
{\normalfont\Large \bfseries}{\thesubsection}{1em}{}
\titleformat{\subsubsection}
{\normalfont\large \bfseries}{\thesubsubsection}{1em}{}

% Encabezado y pie de página:
% Define command for changing header title outside of the preamble
\newcommand{\unittitle}{}
% Define counters for header title and lesson number 
\newcounter{lessoncounter}
% Guardar comandos
\RequirePackage{savesym}
% Evitar que los comandos \headrule y \footrule de 'exams' y de 'titleps' 
% entren en conflicto 
\savesymbol{headrule}
\savesymbol{footrule}
\RequirePackage{titleps}
\restoresymbol{TITLEPS}{headrule}
\restoresymbol{TITLEPS}{footrule}
% Definir un nuevo formato de encabezado y pie de página
\newpagestyle{mypagestyle}
{
\TITLEPSheadrule
\TITLEPSfootrule
\sethead{\ifnum\value{section}>0{\MakeUppercase{\thesection.\quad \unittitle}}\else\fi}
{}{\thepage}
\setfoot{}{}{\ifnum\value{lessoncounter}>0{Clase \thelessoncounter}\else\fi}
}
\settitlemarks{section,subsection,subsubsection}
\pagestyle{mypagestyle}




% Herramientas matemáticas:
% Aditional lists and resume lists enumeration.
\RequirePackage{enumitem}
% Símbolos matemáticos
\RequirePackage{amsmath,amsthm,amssymb,mathtools,mathrsfs}
% Tachar relaciones en forma centrada
\RequirePackage{centernot}

% Entornos matemáticos y sus formatos (teoría):
% Color de entornos matemáticos 
\RequirePackage[svgnames,x11names]{xcolor}
% Entornos matemáticos recuadrados y línea vertical a izquierda para demostraciones 
\RequirePackage{mdframed}
% Mostrar el número indicador al comienzo
\swapnumbers
% Define styles 
\mdfdefinestyle{mytheoremstyle1}{
nobreak,
linewidth=1pt,
backgroundcolor=GhostWhite,
}
\mdfdefinestyle{mytheoremstyle2}{
topline=false,
rightline=false,
bottomline=false,
linewidth=1pt,
rightmargin=-10
}
\mdfdefinestyle{mytheoremstyle3}{
hidealllines=true,
leftmargin=-10,
rightmargin=-10
}
% Teoremas, proposiciones, lemas, definiciones y corolarios 
\mdtheorem[style=mytheoremstyle1]{theorem}{Teorema}[section]
\mdtheorem[style=mytheoremstyle1]{axiom}[theorem]{Axioma}
\mdtheorem[style=mytheoremstyle1]{proposition}[theorem]{Proposición}
\mdtheorem[style=mytheoremstyle1]{lemma}[theorem]{Lema}
\mdtheorem[style=mytheoremstyle1]{corollary}[theorem]{Corolario}
\mdtheorem[style=mytheoremstyle1]{definition}[theorem]{Definición}
\mdtheorem[style=mytheoremstyle1]{notation}[theorem]{Notación}
\mdtheorem[style=mytheoremstyle1]{remark}[theorem]{Observación}
% Demostraciones
\mdtheorem[style=mytheoremstyle2]{PROOF}{Demostración}
% Ejemplos y ejercicios
\mdtheorem[style=mytheoremstyle3]{example}[theorem]{Ejemplo}
\mdtheorem[style=mytheoremstyle3]{exercise}[theorem]{Ejercicio}
% Insert a diamond at the end of examples and exercises
\RequirePackage{etoolbox}
\AtEndEnvironment{example}{\null\hfill$\diamond$}
\AtEndEnvironment{exercise}{\null\hfill$\diamond$}
% Ommit symbol at the end of proofs
\renewcommand\qedsymbol{}

% Entornos matemáticos y sus formatos (práctica):
% Ejercicios
\qformat{\textbf{Ejercicio \thequestion.} \hfill}
% Incisos
\renewcommand{\thepartno}{\textbf{\alph{partno}}}
\renewcommand{\partlabel}{\thepartno.}
% Subincisos
\renewcommand{\thesubpart}{\large \textbf{\roman{subpart}}}
\renewcommand{\subpartlabel}{\thesubpart.}
% Subsubincisos
\renewcommand{\thesubsubpart}{\boldmath{\small \greeknum{subsubpart}}}
\renewcommand{\subsubpartlabel}{\thesubsubpart.}
% Soluciones
\renewcommand{\solutiontitle}{\textbf{Solución.}\newline}
\unframedsolutions

% Redefine display math \[ \] enviroment to be equivalent to a centered equation.
\protected\def\[#1\]{\begin{align*}#1\end{align*}}

% Reset equation numbering after each section
\counterwithin*{equation}{section}

% Definir comando para flechas en distintas direcciones (\shortarrow{i}, i entre 0 y 7):
\RequirePackage{stmaryrd,graphicx}
\makeatletter
\newcommand{\fixed@sra}{$\vrule height 2\fontdimen22\textfont2 width 0pt\shortrightarrow$}
\newcommand{\shortarrow}[1]{\mathrel{\text
{\rotatebox[origin=c]{\numexpr#1*45}{\fixed@sra}}}}
\makeatother

% Top and bottom integral symbols.
\def\uint{\mathchoice%
    {\mkern13mu\overline{\vphantom{\intop}\mkern7mu}\mkern-20mu}%
    {\mkern7mu\overline{\vphantom{\intop}\mkern7mu}\mkern-14mu}%
    {\mkern7mu\overline{\vphantom{\intop}\mkern7mu}\mkern-14mu}%
    {\mkern7mu\overline{\vphantom{\intop}\mkern7mu}\mkern-14mu}%
  \int}
\def\lint{\mkern3mu\underline{\vphantom{\intop}\mkern7mu}\mkern-10mu\int}

% Allow line breaks in display math mode.
\allowdisplaybreaks[1]

% Fin del preámbulo

\endinput
