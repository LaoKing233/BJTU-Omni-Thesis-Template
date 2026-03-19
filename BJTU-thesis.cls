%% BJTU-thesis.cls
%% 北京交通大学研究生学位论文 LaTeX 模板
%% 支持学位类型：学硕、专硕、学博、专博、专项专硕、专项专硕实践总结报告
%%
%% 编译方式：XeLaTeX → Biber → XeLaTeX → XeLaTeX
%%
%% 格式依据：《北京交通大学博士、硕士学位论文撰写规范》（2014年5月）
%%           下文注释中简称"规范"，以"规范§X.X"形式引用对应章节。

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{BJTU-thesis}[2026/03/14 BJTU Graduate Thesis Template]

%% ====================================================================
%% 一、文档选项
%% ====================================================================

\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=BJTU, prefix=BJTU@}

%% 学位类型选项（degree=...），可选值：
%%   AcMaster       — 学术型硕士学位（默认）
%%   EnMaster       — 专业型硕士学位
%%   Doctor         — 学术型博士学位
%%   ProDoctor      — 专业型博士学位
%% --------卓工专用--------
%%   SpecialEnMaster — 工程硕博士培养改革专项试点·硕士专业学位
%%   PracticeReport  — 工程硕博士培养改革专项试点·硕士专业学位实践成果总结报告
\DeclareStringOption[AcMaster]{degree}

%% 双面打印选项（twoside=true/false）
%% 规范§3.18：正文60页以上用双面打印（twoside=true），60页以下用单面打印（twoside=false，默认）
\DeclareBoolOption[false]{twoside}

\ProcessKeyvalOptions*

%% 根据 twoside 选项加载基类
%% 规范§3.18：纸张为A4（210×297mm），zihao=-4 即正文默认小四号
\ifBJTU@twoside
    \LoadClass[zihao=-4, a4paper, twoside, openright, UTF8, space=auto]{ctexbook}
\else
    \LoadClass[zihao=-4, a4paper, oneside, openany, UTF8, space=auto]{ctexbook}
\fi

%% 双面模式：\openright 强制章节从奇数页开始，\openany 允许任意页开始
%% 单面模式：两者均为空操作，章节起始页行为由基类 openany 统一控制
\ifBJTU@twoside
    \newcommand{\openright}{\@openrighttrue}
    \newcommand{\openany}{\@openrightfalse}
\else
    \newcommand{\openright}{}
    \newcommand{\openany}{}
\fi

%% 便捷条件判断（由字符串选项派生）
\newif\if@Doctor
\newif\if@ProDoctor
\newif\if@AcMaster
\newif\if@EnMaster
\newif\if@SpecialEnMaster
\newif\if@PracticeReport

\def\BJTU@tmp{\BJTU@degree}
\ifx\BJTU@tmp\@empty\else
    \expandafter\csname @\BJTU@degree true\endcsname
\fi

%% ====================================================================
%% 二、基础宏包
%% ====================================================================

%% 数学
\RequirePackage{amsmath, amsthm, amsfonts, amssymb, bm, mathrsfs, upgreek}

%% 字体与排版
\RequirePackage{fontspec}
\RequirePackage{array, indentfirst, multirow, makecell}

%% 页面布局
\RequirePackage{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{setspace}
\RequirePackage{ragged2e}
\RequirePackage{afterpage}

%% 表格
\RequirePackage{booktabs}
\RequirePackage{tabularx}
\RequirePackage{longtable}
\RequirePackage{tabularray}

%% 图形
\RequirePackage{graphicx}
\RequirePackage{caption}
\RequirePackage{subcaption}
\RequirePackage{floatrow}
\RequirePackage{float}
\RequirePackage{wrapfig}

%% 颜色
\RequirePackage[dvipsnames]{xcolor}


%% 列表
\RequirePackage{enumitem}
\RequirePackage{circledsteps}

%% 代码
\RequirePackage{listings}

%% 目录
\RequirePackage{titletoc}

%% 计数器
\RequirePackage{chngcntr}

%% 工具
\RequirePackage{etoolbox}
\RequirePackage{xifthen}
\RequirePackage{calc}
\RequirePackage{adjustbox}
\RequirePackage{ulem}

%% 算法
\RequirePackage{algorithm}
\RequirePackage{algpseudocode}

%% 参考文献（biblatex + biber）
%% 规范§3.11：引文标注遵照 GB/T 7714-2005，采用顺序编码制
\RequirePackage[
    backend    = biber,
    style      = gb7714-2015,
    gbalign    = left,
    gbbiblabel = bracket,
    natbib     = true,
]{biblatex}
\addbibresource{reference/ref.bib}

%% 超链接（XeLaTeX 专用，无需引擎判断）
\RequirePackage[
    colorlinks      = true,
    linkcolor       = black,
    citecolor       = black,
    urlcolor        = black,
    anchorcolor     = black,
    bookmarksnumbered = true,
    pdfstartview    = FitH,
]{hyperref}

%% ====================================================================
%% 三、页面设置
%% ====================================================================

%% 规范§3.18：页边距要求
%%   上边距（天头）：30mm   下边距（地脚）：25mm
%%   左/右边距：25mm        装订线：10mm
%%   页眉距页面顶端：16mm   页脚距页面底端：15mm
%%
%% 正文区位置由 top/bottom 决定，与页眉位置解耦：
%%   页眉内容距页面顶端 = top(30mm) - headsep - headheight
%%   调整 headsep 只影响页眉线与正文间距，不影响正文区位置
\geometry{
    top           = 30mm,   %% 页面顶端到正文顶端 30mm
    bottom        = 25mm,   %% 下边距 25mm
    left          = 25mm,   %% 左边距 25mm（装订线另计）
    right         = 25mm,   %% 右边距 25mm
    bindingoffset = 10mm,   %% 装订线 10mm
    headheight    = 4mm,    %% 页眉内容区高度（五号字约3.7mm）
    headsep       = 10mm,   %% 页眉底线到正文顶端（页眉距页面顶端 = 30-10-4 = 16mm ✓）
    footskip      = 15mm,   %% 正文底端到页脚基线距离
}

%% 规范§3.18：字体与间距——行间距设置为固定值20磅（Word"固定值20磅"= 20pt）
\AtBeginDocument{\setlength{\baselineskip}{20pt}}

%% 图片搜索路径
\DeclareGraphicsExtensions{.pdf,.eps,.png,.jpg,.jpeg}
\graphicspath{{figures/}{pics/}{pictures/}}

%% ====================================================================
%% 四、字体设置
%% ====================================================================

%% 规范§3.18：西文字体为小四号 Times New Roman
%% setmainfont 设置全局西文字体，中文字体由下方 setCJK* 命令管理
\setmainfont{Times New Roman}

%% 中文字体：SimSun（宋体）、SimHei（黑体），字体文件置于 fonts/ 目录
%% AutoFakeBold：无真实粗体时通过描边模拟，数值为描边宽度（pt）
\setCJKmainfont{simsun.ttc}[Path=fonts/, AutoFakeBold=2.5]
\setCJKsansfont{simhei.ttf}[Path=fonts/, AutoFakeBold=2]
\setCJKfamilyfont{zhsong}{simsun.ttc}[Path=fonts/, AutoFakeBold=2.5]
\setCJKfamilyfont{zhhei}{simhei.ttf}[Path=fonts/, AutoFakeBold=2]
%% 楷体：字体文件置于 fonts/ 目录
\setCJKfamilyfont{zhkai}{simkai.ttf}[Path=fonts/]
%% 华文中宋：用于封面校名等特殊场合
\setCJKfamilyfont{hwzs}{stzhongs.ttf}[Path=fonts/]

%% ====================================================================
%% 五、封面信息命令
%% ====================================================================

%% 标签
\def\BJTU@label@schoolNumber{学校代码：}
\def\BJTU@label@classification{密级：}
\def\BJTU@label@author{作者姓名：}
\def\BJTU@label@studentNumber{学\hspace{2\ccwd}号：}
\def\BJTU@label@advisor{导师姓名：}
\def\BJTU@label@advisorTitle{职\hspace{2\ccwd}称：}
\def\BJTU@label@engineeringMasterField{专业学位类别（领域）：}
\def\BJTU@label@degreeLevel{学位级别：}
\def\BJTU@label@degreeType{学位类别：}
\def\BJTU@label@major{学科专业：}
\def\BJTU@label@researchArea{研究方向：}
\def\BJTU@label@company{联合培养企业：}
\def\BJTU@label@keyField{关键领域：}
\def\BJTU@label@schoolAdvisor{校内导师姓名：}
\def\BJTU@label@schoolAdvisorTitle{职\hspace{2\ccwd}称：}
\def\BJTU@label@enterpriseAdvisor{企业导师姓名：}
\def\BJTU@label@enterpriseAdvisorTitle{职\hspace{2\ccwd}称：}

%% 默认值
\def\BJTU@value@schoolNumber{10004}
\def\BJTU@value@classification{公开}
\def\BJTU@value@author{XXXX}
\def\BJTU@value@studentNumber{XXXX}
\def\BJTU@value@advisor{XXXX}
\def\BJTU@value@advisorTitle{XXXX}
\def\BJTU@value@engineeringMasterField{XXXX}
\def\BJTU@value@degreeType{XXXX}
\def\BJTU@value@major{XXXX}
\def\BJTU@value@researchArea{XXXX}
\def\BJTU@value@company{XXXX}
\def\BJTU@value@enterpriseAdvisor{XXXX}
\def\BJTU@value@enterpriseAdvisorTitle{XXXX}
\def\BJTU@value@keyField{XXXX}
\def\BJTU@value@title{中文题目}
\def\BJTU@value@englishtitle{英文题目}
\def\BJTU@value@practiceTitle{实践成果题目}
\def\BJTU@value@englishPracticeTitle{Practice Title}
\def\BJTU@label@datetime{XXXX年XX月}

%% 学位级别（由学位类型自动推导）
\if@Doctor\def\BJTU@value@degreeLevel{博士}\else
\if@ProDoctor\def\BJTU@value@degreeLevel{博士}\else
\def\BJTU@value@degreeLevel{硕士}\fi\fi

%% 用户填写命令
\newcommand\schoolNumber[1]{\def\BJTU@value@schoolNumber{#1}}
\newcommand\classification[1]{\def\BJTU@value@classification{#1}}
\renewcommand\author[1]{\def\BJTU@value@author{#1}}
\newcommand\studentNumber[1]{\def\BJTU@value@studentNumber{#1}}
\newcommand\advisor[1]{\def\BJTU@value@advisor{#1}}
\newcommand\advisorTitle[1]{\def\BJTU@value@advisorTitle{#1}}
\newcommand\engineeringMasterField[1]{\def\BJTU@value@engineeringMasterField{#1}}
\newcommand\degreeType[1]{\def\BJTU@value@degreeType{#1}}
\newcommand\major[1]{\def\BJTU@value@major{#1}}
\newcommand\researchArea[1]{\def\BJTU@value@researchArea{#1}}
\renewcommand\title[1]{\def\BJTU@value@title{#1}}
\newcommand\englishtitle[1]{\def\BJTU@value@englishtitle{#1}}
\newcommand\practiceTitle[1]{\def\BJTU@value@practiceTitle{#1}}
\newcommand\englishPracticeTitle[1]{\def\BJTU@value@englishPracticeTitle{#1}}
\newcommand\datetime[1]{\def\BJTU@label@datetime{#1}}
\newcommand\company[1]{\def\BJTU@value@company{#1}}
\newcommand\enterpriseAdvisor[1]{\def\BJTU@value@enterpriseAdvisor{#1}}
\newcommand\enterpriseAdvisorTitle[1]{\def\BJTU@value@enterpriseAdvisorTitle{#1}}
\newcommand\keyField[1]{\def\BJTU@value@keyField{#1}}

%% ====================================================================
%% 六、封面
%% ====================================================================

%% 题名页字间距辅助命令：在相邻字符之间插入固定间距
%% 规范§3.3/§3.1 docx 实测：题名页"北京交通大学"和"XX学位论文"字间距为加宽3磅
%% 用法：\BJTU@ls{文字} — 对每个字符之间插入 \kern3pt
\newcommand{\BJTU@ls}[1]{%
    \def\BJTU@ls@first{1}%
    \@tfor\BJTU@ls@c:=#1\do{%
        \ifnum\BJTU@ls@first=0 \kern3pt\fi
        \BJTU@ls@c
        \def\BJTU@ls@first{0}%
    }%
}

%% 论文类型标题（外封/内封共用）
%% 规范§3.1/§3.3：二号宋体加粗，居中，字间距加宽3磅
\newcommand{\BJTU@thesistitle}{%
    \if@Doctor \BJTU@ls{博士学位论文}\else
    \if@ProDoctor \BJTU@ls{博士专业学位论文}\else
    \if@PracticeReport
        {\zihao{-2}\BJTU@ls{工程硕博士培养改革专项试点}}\\[-6pt]
        \BJTU@ls{硕士专业学位实践成果总结报告}\\[-6pt]
        （产品设计）%
    \else
    \if@SpecialEnMaster
        {\zihao{-2}\BJTU@ls{工程硕博士培养改革专项试点}}\\[-6pt]
        \BJTU@ls{硕士专业学位论文}%
    \else
    \if@AcMaster \BJTU@ls{硕士学位论文}\else
    \BJTU@ls{硕士专业学位论文}%
    \fi\fi\fi\fi\fi
}

%% 正文题目（外封/内封共用）
%% 规范§3.3：论文题目不超过25字，小三号宋体，居中；
%%           英文题目小三号 Times New Roman，居中
\newcommand{\BJTU@thesisbody}{%
    \if@PracticeReport
        {\songti\zihao{-3}\BJTU@value@practiceTitle\\}
        \vspace{15pt}
        {\zihao{-3}\BJTU@value@englishPracticeTitle\\}
    \else
        {\songti\zihao{-3}\BJTU@value@title\\}
        \vspace{15pt}
        {\zihao{-3}\BJTU@value@englishtitle\\}
    \fi
}

%% 外封作者信息
%% 规范§3.1：外封包含作者姓名、导师姓名（四号宋体），居中
\newcommand{\BJTU@coverauthortable}{%
    \if@SpecialEnMaster
        {\songti\zihao{4}\BJTU@label@author\BJTU@value@author}\\[10pt]
        {\songti\zihao{4}\BJTU@label@company\BJTU@value@company}\\[10pt]
        {\songti\zihao{4}校内导师：\BJTU@value@advisor}\\[10pt]
        {\songti\zihao{4}\BJTU@label@enterpriseAdvisor\BJTU@value@enterpriseAdvisor}%
    \else\if@PracticeReport
        {\songti\zihao{4}\BJTU@label@author\BJTU@value@author}\\[10pt]
        {\songti\zihao{4}\BJTU@label@company\BJTU@value@company}\\[10pt]
        {\songti\zihao{4}校内导师：\BJTU@value@advisor}\\[10pt]
        {\songti\zihao{4}\BJTU@label@enterpriseAdvisor\BJTU@value@enterpriseAdvisor}%
    \else
        {\songti\zihao{4}\BJTU@label@author\BJTU@value@author}\\[10pt]
        {\songti\zihao{4}\BJTU@label@advisor\BJTU@value@advisor}%
    \fi\fi
}

%% 外封
\newcommand{\makecover}{
    \newpage\thispagestyle{empty}
    \vspace{50pt}
    \begin{figure}
        \centering\vspace{60pt}
        \includegraphics[width=10.77cm, height=2.78cm]{schoolName}
    \end{figure}
    \vspace{18pt}
    \begin{center}
        {\songti\zihao{2}\bfseries\BJTU@thesistitle\\}  %% 规范§3.1：二号宋体加粗，居中
        \vspace{44pt}
        \BJTU@thesisbody
        \vspace{90pt}
        \BJTU@coverauthortable
        \vfill
        {\songti\zihao{4}北京交通大学\\\vspace{14pt}\BJTU@label@datetime}  %% 四号宋体
    \end{center}
}

%% ====================================================================
%% 七、内封
%% ====================================================================

%% 内封信息表
%% 规范§3.3：内封各项信息均为四号宋体
\newlength{\BJTU@labelwidth}
\newcommand{\BJTU@infocell}[3]{%
    %% 单个信息格：标签正常输出，值放入 parbox，折行自动对齐到冒号后
    %% #1=总宽度，#2=标签，#3=值
    \settowidth{\BJTU@labelwidth}{#2}%
    \leavevmode#2\parbox[t]{\dimexpr#1-\BJTU@labelwidth\relax}{#3}%
}
\newcommand{\BJTU@inforow}[4]{%
    %% 普通学位：左右各占 0.5\textwidth
    \BJTU@infocell{0.5\textwidth}{#1}{#2}\BJTU@infocell{0.5\textwidth}{#3}{#4}\\[10pt]
}
\newcommand{\BJTU@inforowwide}[4]{%
    %% 专项专硕/实践报告：左列 0.55\textwidth，右列 0.4\textwidth，中间 0.05\textwidth 间距
    \BJTU@infocell{0.55\textwidth}{#1}{#2}\hspace{0.05\textwidth}\BJTU@infocell{0.4\textwidth}{#3}{#4}\\[10pt]
}
\newcommand{\BJTU@infoauthortable}{%
    \if@SpecialEnMaster
        \BJTU@inforowwide{\BJTU@label@author}{\BJTU@value@author}{\BJTU@label@studentNumber}{\BJTU@value@studentNumber}
        \BJTU@inforowwide{\BJTU@label@company}{\BJTU@value@company}{\BJTU@label@keyField}{\BJTU@value@keyField}
        \BJTU@inforowwide{\BJTU@label@engineeringMasterField}{\BJTU@value@engineeringMasterField}{\BJTU@label@degreeLevel}{\BJTU@value@degreeLevel}
        \BJTU@inforowwide{\BJTU@label@schoolAdvisor}{\BJTU@value@advisor}{\BJTU@label@schoolAdvisorTitle}{\BJTU@value@advisorTitle}
        \BJTU@inforowwide{\BJTU@label@enterpriseAdvisor}{\BJTU@value@enterpriseAdvisor}{\BJTU@label@enterpriseAdvisorTitle}{\BJTU@value@enterpriseAdvisorTitle}
    \else\if@PracticeReport
        \BJTU@inforowwide{\BJTU@label@author}{\BJTU@value@author}{\BJTU@label@studentNumber}{\BJTU@value@studentNumber}
        \BJTU@inforowwide{\BJTU@label@company}{\BJTU@value@company}{\BJTU@label@keyField}{\BJTU@value@keyField}
        \BJTU@inforowwide{\BJTU@label@engineeringMasterField}{\BJTU@value@engineeringMasterField}{\BJTU@label@degreeLevel}{\BJTU@value@degreeLevel}
        \BJTU@inforowwide{\BJTU@label@schoolAdvisor}{\BJTU@value@advisor}{\BJTU@label@schoolAdvisorTitle}{\BJTU@value@advisorTitle}
        \BJTU@inforowwide{\BJTU@label@enterpriseAdvisor}{\BJTU@value@enterpriseAdvisor}{\BJTU@label@enterpriseAdvisorTitle}{\BJTU@value@enterpriseAdvisorTitle}
    \else\if@EnMaster
        \BJTU@inforow{\BJTU@label@author}{\BJTU@value@author}{\BJTU@label@studentNumber}{\BJTU@value@studentNumber}
        \BJTU@inforow{\BJTU@label@advisor}{\BJTU@value@advisor}{\BJTU@label@advisorTitle}{\BJTU@value@advisorTitle}
        \BJTU@inforow{\BJTU@label@engineeringMasterField}{\BJTU@value@engineeringMasterField}{\BJTU@label@degreeLevel}{\BJTU@value@degreeLevel}
    \else\if@ProDoctor
        \BJTU@inforow{\BJTU@label@author}{\BJTU@value@author}{\BJTU@label@studentNumber}{\BJTU@value@studentNumber}
        \BJTU@inforow{\BJTU@label@advisor}{\BJTU@value@advisor}{\BJTU@label@advisorTitle}{\BJTU@value@advisorTitle}
        \BJTU@inforow{\BJTU@label@engineeringMasterField}{\BJTU@value@engineeringMasterField}{\BJTU@label@degreeLevel}{\BJTU@value@degreeLevel}
    \else
        \BJTU@inforow{\BJTU@label@author}{\BJTU@value@author}{\BJTU@label@studentNumber}{\BJTU@value@studentNumber}
        \BJTU@inforow{\BJTU@label@advisor}{\BJTU@value@advisor}{\BJTU@label@advisorTitle}{\BJTU@value@advisorTitle}
        \BJTU@inforow{\BJTU@label@degreeType}{\BJTU@value@degreeType}{\BJTU@label@degreeLevel}{\BJTU@value@degreeLevel}
        \BJTU@inforow{\BJTU@label@major}{\BJTU@value@major}{\BJTU@label@researchArea}{\BJTU@value@researchArea}
    \fi\fi\fi\fi
}

\newcommand{\makeInfo}{
    \newpage
    \pagenumbering{roman}   %% 规范§3.18：前置部分从中文题名页起用罗马数字单独编页
    \thispagestyle{myStyle}
    {\songti\zihao{5}\noindent\BJTU@label@schoolNumber\BJTU@value@schoolNumber}  %% 规范§3.3：学校代码五号宋体
    \hfill
    {\songti\zihao{5}\BJTU@label@classification\BJTU@value@classification}       %% 规范§3.3：密级五号宋体
    \vspace{31.5pt}
    \begin{center}
        {\kaishu\zihao{0}\BJTU@ls{北京交通大学}\\}     %% 规范§3.3：初号楷体，居中，字间距加宽3磅
        {\songti\zihao{2}\bfseries\BJTU@thesistitle\\} %% 规范§3.3：二号宋体加粗，居中
        \vspace{44pt}
        \BJTU@thesisbody
    \end{center}
    \vspace{48pt}
    {\songti\zihao{4}\BJTU@infoauthortable}  %% 规范§3.3：各项信息四号宋体
    \vfill
    \begin{center}
        {\songti\zihao{4}北京交通大学\\\vspace{10pt}\BJTU@label@datetime}  %% 规范§3.3：四号宋体，居中
    \end{center}
}

%% ====================================================================
%% 八、版权页与评价页
%% ====================================================================

%% 规范§3.2：标题三号黑体，居中，单倍行距，段前24磅，段后18磅；
%%           内容小四号宋体，行距20磅，段前后各为0磅

%% \makeAuthorization：版权使用授权书
%% 根据学位类型自动选取对应正文内容（已内联，无需外部 tex 文件）：
%%   默认  — 学硕（AcMaster）/专硕（EnMaster）/学博（Doctor）/专博（ProDoctor）
%%   special  — 专项专硕（SpecialEnMaster）
%%   practice — 实践总结报告（PracticeReport）
\newcommand{\makeAuthorization}{%
    \if@PracticeReport
        \chapter*{实践成果版权使用授权书}
    \else
        \chapter*{学位论文版权使用授权书}
    \fi
    \thispagestyle{empty}%
    \if@PracticeReport
        %% 适用学位：专项专硕实践总结报告（PracticeReport）
        本实践成果是研究生在北京交通大学与联合培养企业攻读工程硕博士专项硕士研究生学位期间完成的成果，依托北京交通大学与联合培养企业的科研合作及平台开展，知识产权归属北京交通大学与联合培养企业共同所有。

        本实践成果总结报告作者、导师及联合培养企业完全了解北京交通大学有关保留、使用实践成果总结报告的规定。特授权北京交通大学可以将实践成果总结报告的全部或部分内容编入有关数据库进行检索，提供阅览服务，并采用影印、缩印或扫描等复制手段保存、汇编以供查阅和借阅。同意学校向国家有关部门或机构送交总结报告的复印件和磁盘。学校可以为存在馆际合作关系的兄弟高校用户提供文献传递服务和交换服务。

        （保密的实践成果总结报告在解密后适用本授权说明）\par
        \vspace{72pt}

        \begin{minipage}[t]{0.5\textwidth}
        作者签名：

        签字日期：\hspace{4\ccwd}年\hspace{2\ccwd}月\hspace{2\ccwd}日
        \end{minipage}
        \hfill
        \begin{minipage}[t]{0.5\textwidth}
        校内导师签名：

        签字日期：\hspace{4\ccwd}年\hspace{2\ccwd}月\hspace{2\ccwd}日
        \end{minipage}

        \vspace{2\baselineskip}

        \begin{minipage}[t]{0.5\textwidth}
        企业导师签名：

        签字日期：\hspace{4\ccwd}年\hspace{2\ccwd}月\hspace{2\ccwd}日
        \end{minipage}
        \hfill
        \begin{minipage}[t]{0.5\textwidth}
        联合培养企业：

        盖章日期：\hspace{4\ccwd}年\hspace{2\ccwd}月\hspace{2\ccwd}日
        \end{minipage}
    \else\if@SpecialEnMaster
        %% 适用学位：专项专硕（SpecialEnMaster）
        本学位论文是研究生在北京交通大学与联合培养企业攻读工程硕博士专项硕士研究生学位期间完成的成果，依托北京交通大学与联合培养企业的科研合作及平台开展，知识产权归属北京交通大学与联合培养企业共有。

        本学位论文作者、导师及联合培养企业完全了解北京交通大学有关保留、使用学位论文的规定。特授权北京交通大学可以将学位论文的全部或部分内容编入有关数据库进行检索，提供阅览服务，并采用影印、缩印或扫描等复制手段保存、汇编以供查阅和借阅。同意学校向国家有关部门或机构送交论文的复印件和磁盘。学校可以为存在馆际合作关系的兄弟高校用户提供文献传递服务和交换服务。

        （保密的学位论文在解密后适用本授权说明）\par
        \vspace{72pt}

        \begin{minipage}[t]{0.5\textwidth}
        学位论文作者签名：

        \vspace{4ex}
        签字日期：\hspace{4\ccwd}年\hspace{2\ccwd}月\hspace{2\ccwd}日
        \end{minipage}
        \hfill
        \begin{minipage}[t]{0.5\textwidth}
        校内导师签名：

        \vspace{4ex}
        签字日期：\hspace{4\ccwd}年\hspace{2\ccwd}月\hspace{2\ccwd}日
        \end{minipage}

        \vspace{2\baselineskip}

        \begin{minipage}[t]{0.5\textwidth}
        企业导师签名：

        \vspace{4ex}
        签字日期：\hspace{4\ccwd}年\hspace{2\ccwd}月\hspace{2\ccwd}日
        \end{minipage}
        \hfill
        \begin{minipage}[t]{0.5\textwidth}
        联合培养企业：

        \vspace{4ex}
        盖章日期：\hspace{4\ccwd}年\hspace{2\ccwd}月\hspace{2\ccwd}日
        \end{minipage}
    \else
        %% 适用学位：学硕（AcMaster）、专硕（EnMaster）、学博（Doctor）、专博（ProDoctor）
        本学位论文作者完全了解北京交通大学有关保留、使用学位论文的规定。特授权北京交通大学可以将学位论文的全部或部分内容编入有关数据库进行检索，提供阅览服务，并采用影印、缩印或扫描等复制手段保存、汇编以供查阅和借阅。同意学校向国家有关部门或机构送交论文的复印件和磁盘。学校可以为存在馆际合作关系的兄弟高校用户提供文献传递服务和交换服务。

        （保密的学位论文在解密后适用本授权说明）\par
        \vspace{72pt}

        \begin{minipage}[t]{0.5\textwidth}
        学位论文作者签名：\vspace{4ex}

        签字日期：\hspace{4\ccwd}年\hspace{2\ccwd}月\hspace{2\ccwd}日
        \end{minipage}
        \hfill
        \begin{minipage}[t]{0.5\textwidth}
        导师签名：\vspace{4ex}

        签字日期：\hspace{4\ccwd}年\hspace{2\ccwd}月\hspace{2\ccwd}日
        \end{minipage}
    \fi\fi
}

%% \makeEvaluation：联合培养企业评价意见
%% 仅专项专硕（SpecialEnMaster）和实践报告（PracticeReport）使用
%% 其他学位类型在 main.tex 中不调用此命令
\newcommand{\makeEvaluation}{%
    \chapter*{联合培养企业评价意见}%
    \thispagestyle{empty}%
    \vspace{20pt}%
    \input{chapters/evaluation}%
}

%% ====================================================================
%% 九、页眉页脚
%% ====================================================================

%% 规范§3.18：页眉内容
%%   单面印制：左对齐"北京交通大学…学位论文"，右对齐各章章名
%%   双面印制：偶数页居中为论文类型名，奇数页居中为各章章名
%%   页眉字号为五号宋体，页眉之下有一条下划线（fancyhdr 默认有页眉线）
\newcommand{\BJTU@headertitle}{%
    \if@Doctor 北京交通大学博士学位论文\else
    \if@ProDoctor 北京交通大学博士专业学位论文\else
    \if@PracticeReport 北京交通大学硕士专业学位实践成果总结报告\else
    \if@SpecialEnMaster 北京交通大学硕士专业学位论文\else
    \if@AcMaster 北京交通大学硕士学位论文\else
    北京交通大学硕士专业学位论文%
    \fi\fi\fi\fi\fi
}

%% 正文页眉页脚
%% 规范§3.18：
%%   单面印制：左对齐论文类型名，右对齐各章章名
%%   双面印制：偶数页居中论文类型名，奇数页居中各章章名
\fancypagestyle{BJTU@heading}{
    \fancyhf{}
    \ifBJTU@twoside
        %% 双面：偶数页[CE]居中排论文类型名，奇数页[CO]居中排章名
        \fancyhead[CE]{\songti\zihao{5}\BJTU@headertitle}
        \fancyhead[CO]{\songti\zihao{5}\leftmark}
    \else
        %% 单面：左对齐[L]排论文类型名，右对齐[R]排章名
        \fancyhead[L]{\songti\zihao{5}\BJTU@headertitle}
        \fancyhead[R]{\songti\zihao{5}\leftmark}
    \fi
    \fancyfoot[C]{\zihao{-5}\thepage}  %% 规范§3.18：小五号，页码居中（Times New Roman 由 setmainfont 保证）
}

%% 无页眉横线样式（内封、致谢用）
\fancypagestyle{myStyle}{
    \fancyhf{}
    \renewcommand{\headrulewidth}{0pt}
    \fancyfoot[C]{\zihao{-5}\thepage}  %% 规范§3.18：小五号页码
}

\pagestyle{BJTU@heading}
\renewcommand{\chaptermark}[1]{\markboth{#1}{}}

%% 双面模式下 \openright 自动插入的空白页设为完全空白（无页眉页脚）
\renewcommand{\cleardoublepage}{%
    \clearpage
    \if@twoside
        \ifodd\c@page\else
            \hbox{}\thispagestyle{empty}\newpage
        \fi
    \fi
}

%% ====================================================================
%% 十、章节标题格式
%% ====================================================================

%% 规范§3.10.2 + docx模板实测：各级标题格式（段前24磅，段后18磅，单倍行距）
%%   一级（章）：三号黑体，居中
%%   二级（节）：小三号黑体，居左
%%   三级（条）：四号黑体，居左
%%   四级（款）：小四号黑体，居左
\ctexset{
    chapter = {
        name        = {},
        number      = {\arabic{chapter}},
        format      = {\heiti\centering\zihao{3}},   %% 三号黑体居中
        aftername   = {\hspace{1\ccwd}},             %% 规范§3.10.2：序号与题名之间空两格（1\ccwd = 一个汉字宽 = 两个半角空格）
        pagestyle   = {BJTU@heading},
        beforeskip  = 24bp,   %% 规范：段前24磅（章首无上级 afterskip，直接用24bp）
        afterskip   = 18bp,   %% 规范：段后18磅
        fixskip     = true,
    },
    section = {
        format      = {\raggedright\heiti\zihao{-3}},  %% 小三号黑体居左
        aftername   = {\hspace{1\ccwd}},               %% 规范§3.10.2：序号与题名之间空两格
        beforeskip  = 24bp,                            %% 规范：段前24磅
        afterskip   = 18bp,                            %% 规范：段后18磅
        fixskip     = true,
    },
    subsection = {
        format      = {\raggedright\heiti\zihao{4}},   %% 四号黑体居左
        aftername   = {\hspace{1\ccwd}},               %% 规范§3.10.2：序号与题名之间空两格
        beforeskip  = 24bp,                            %% 规范：段前24磅
        afterskip   = 18bp,                            %% 规范：段后18磅
        fixskip     = true,
    },
    subsubsection = {
        format      = {\raggedright\heiti\zihao{-4}},  %% 小四号黑体居左
        aftername   = {\hspace{1\ccwd}},               %% 规范§3.10.2：序号与题名之间空两格
        beforeskip  = 24bp,                            %% 规范：段前24磅
        afterskip   = 18bp,                            %% 规范：段后18磅
        fixskip     = true,
    },
}

%% 规范§3.10.4/3.10.5：图、表编号格式为"章-序号"，如图1-1、表2-3
%% 规范§3.10.12：公式编号格式为"（章-序号）"，如（1-1）
%% 注：\renewcommand\thetable 须在 \numberwithin{table}{chapter} 之后执行，
%%     否则 \numberwithin 会覆盖横线格式为"章.序号"（带点）
\renewcommand\theequation{\arabic{chapter}-\arabic{equation}}
\renewcommand\thefigure{\arabic{chapter}-\arabic{figure}}

%% 浮动体参数放宽，减少图表孤立成页的情况
\renewcommand{\textfraction}{0.15}
\renewcommand{\topfraction}{0.85}
\renewcommand{\bottomfraction}{0.65}
\renewcommand{\floatpagefraction}{0.60}

%% ====================================================================
%% 十一、图表标题
%% ====================================================================

%% 规范§3.10.4：图题采用中英文对照，中文宋体五号，英文 Times New Roman 五号，居中，中文在上
%% 规范§3.10.5：表题同图题，置于表的上方；图题置于图的下方
\DeclareCaptionLabelSeparator{zhspace}{\hspace{1\ccwd}}
%% 五号字（中文宋体由 ctex 隐式保证，英文 Times New Roman 由 setmainfont 保证）
\DeclareCaptionFont{capfont}{\zihao{5}}
\captionsetup{
    font          = capfont,
    labelsep      = zhspace,
    justification = centering,  %% 规范§3.10.4/3.10.5：图题、表题居中
    singlelinecheck = false,     %% 单行题注也强制居中（默认单行时自动居中可能不一致）
}
\captionsetup[table]{
    position  = top,    %% 规范§3.10.5：表题在表上方
    aboveskip = 6bp,
    belowskip = 6bp,
}
%% floatrow 包会接管 caption 位置，需用 \floatsetup 显式指定表题在上方
\floatsetup[table]{capposition=top}
\captionsetup[figure]{
    position  = bottom, %% 规范§3.10.4：图题在图下方
    aboveskip = 6bp,
    belowskip = 6bp,
}
%% 规范§3.10.4：分图号用 a)、b) 表示，分图题置于分图之下，中文在上，英文在下
%% labelformat=empty：隐藏自动标签，由 \subfigcaption 统一控制输出格式
\captionsetup[subfigure]{
    labelformat = empty,
    font        = capfont,
}
\newcommand\thesubfigurenum{\alph{subfigure})} %% 供 \subfigcaption 调用，输出 a)、b)
\numberwithin{table}{chapter}
%% \numberwithin 会将 \thetable 重置为"章.序号"，在此处重新定义为"章-序号"
\renewcommand\thetable{\arabic{chapter}-\arabic{table}}

%% 中英文对照题注辅助命令
%% 规范§3.10.4/3.10.5：图题、表题采用中英文对照，中文在上，英文在下
%% 用法：\figcaption{中文题目}{English Title}
%%       \tabcaption{中文题目}{English Title}
%% 中英文之间自动换行，无需手动插入 \\
\newcommand{\figcaption}[2]{\caption{#1 \\ Fig~\arabic{chapter}-\arabic{figure}\hspace{1\ccwd}#2}}
\newcommand{\tabcaption}[2]{\caption{#1 \\ Table~\arabic{chapter}-\arabic{table}\hspace{1\ccwd}#2}}
%% 子图中英文对照题注：中文在上，英文在下，两行均带分图编号（如 a)）
\newcommand{\subfigcaption}[2]{\caption{\thesubfigurenum\hspace{0.5\ccwd}#1 \\ \thesubfigurenum\hspace{0.5\ccwd}#2}}

%% ====================================================================
%% 十二、目录
%% ====================================================================

%% 规范§3.7：目录内容为小四号宋体，单倍行距，段前6磅，段后0磅，两端对齐，页码右对齐
%% 规范未明文规定各级目录缩进，参考 docx 模板实测：每次级比上一级多缩进 1\ccwd（一个汉字宽）
%%   章级（目录1）：0\ccwd；节级（目录2）：1\ccwd；条级（目录3）：2\ccwd
\addtocontents{toc}{\protect\hypersetup{hidelinks}}
\addtocontents{lot}{\protect\hypersetup{hidelinks}}
\addtocontents{lof}{\protect\hypersetup{hidelinks}}

%% \titlecontents{level}[left]{above-code}{label-fmt}{no-label-fmt}{filler}[below-code]
\titlecontents{chapter}[0pt]{\addvspace{6bp}\songti\zihao{-4}}
    {\thecontentslabel\hspace{1\ccwd}}{}
    {\hspace{.5em}\titlerule*{.}\contentspage}

\titlecontents{section}[1\ccwd]{\addvspace{6bp}\songti\zihao{-4}}
    {\thecontentslabel\hspace{1\ccwd}}{}
    {\hspace{.5em}\titlerule*{.}\contentspage}

\titlecontents{subsection}[2\ccwd]{\addvspace{6bp}\songti\zihao{-4}}
    {\thecontentslabel\hspace{1\ccwd}}{}
    {\hspace{.5em}\titlerule*{.}\contentspage}

%% 规范§3.7：目录标题为三号黑体，居中（由 chapter* 样式统一处理）
%%           目录内容为单倍行距（规范§3.7，区别于正文20磅固定行距）
\renewcommand\tableofcontents{%
    \chapter*{\contentsname}%
    \@mkboth{\MakeUppercase\contentsname}{\MakeUppercase\contentsname}%
    \pdfbookmark[0]{目录}{bittoc}%
    {\linespread{1.0}\selectfont\@starttoc{toc}}%
}

%% ====================================================================
%% 十三、后置部分公共格式
%% ====================================================================

%% 规范§3.11-§3.15：参考文献、附录、作者简历、索引、独创性声明等后置章节
%% 内容统一为五号宋体，行距16磅，段前后各为0磅
\newcommand{\backmatterformat}{%
    \zihao{5}\songti\setlength{\baselineskip}{16pt}%
}

%% ====================================================================
%% 十四、参考文献
%% ====================================================================

%% 规范§3.11：标题三号黑体，居中；内容五号宋体，行距16磅，段前后各为0磅
\defbibheading{bibtoc}[\bibname]{%
    \chapter*{#1}%
    \markboth{#1}{#1}%
    \addcontentsline{toc}{chapter}{#1}%
}

%% 规范§3.11：参考文献内容五号宋体，行距16磅
\AtBeginBibliography{\backmatterformat}


%% ====================================================================
%% 十四、附录
%% ====================================================================

%% 规范§3.12：附录依序用大写英文字母 A、B、C……编序号
%%            标题三号黑体，居中；内容五号宋体，行距16磅
%% 五号 = 10.5pt，linespread = 16/10.5 ≈ 1.524
\let\BJTU@appendix\appendix
\renewcommand{\appendix}{%
    \BJTU@appendix
    \counterwithin{table}{chapter}
    \counterwithin{figure}{chapter}
    \counterwithin{equation}{chapter}
    \renewcommand{\thetable}{\Alph{chapter}-\arabic{table}}
    \renewcommand{\thefigure}{\Alph{chapter}-\arabic{figure}}
    \renewcommand{\theequation}{\Alph{chapter}-\arabic{equation}}
    \renewcommand{\thesection}{\Alph{chapter}.\arabic{section}}
    \renewcommand{\thesubsection}{\Alph{chapter}.\arabic{section}.\arabic{subsection}}
    %% 规范§3.12：附录内容为五号宋体，行距16磅
    \backmatterformat
}

%% ====================================================================
%% 十五、前置环境（摘要、致谢等）
%% ====================================================================

%% 规范§3.5：摘要标题三号黑体，居中，单倍行距，段前24磅，段后18磅；
%%           内容小四号宋体，行距20磅，段前后各为0磅
\newenvironment{abstract}{%
    \chapter*{摘要}%
    \markboth{摘要}{摘要}%
    \addcontentsline{toc}{chapter}{摘要}%
}{}

%% 规范§3.5：ABSTRACT 标题三号 Times New Roman，居中；
%%           内容小四号，行距20磅，段前后各为0磅
\newenvironment{englishabstract}{%
    %% 临时将章标题字体切换为 Times New Roman（规范§3.5）
    \ctexset{chapter/format = {\rmfamily\centering\zihao{3}}}%
    \chapter*{ABSTRACT}%
    %% 恢复正常章标题格式（黑体）
    \ctexset{chapter/format = {\heiti\centering\zihao{3}}}%
    \markboth{ABSTRACT}{ABSTRACT}%
    \addcontentsline{toc}{chapter}{ABSTRACT}%
}{}


%% 规范§3.5：关键词加粗，内容小四号宋体
\newcommand{\keywords}[1]{\songti\textbf{关键词：}#1}
\newcommand{\englishkeywords}[1]{\textbf{KEYWORDS:~}#1}

%% 作者简历
%% 规范§3.14：内容为五号宋体，行距16磅，段前后各为0磅
\newcommand{\authorresumetitle}{%
    \if@Doctor 作者简历及攻读博士学位期间取得的研究成果\else
    \if@ProDoctor 作者简历及攻读博士学位期间取得的研究成果\else
    作者简历及攻读硕士学位期间取得的研究成果%
    \fi\fi
}


%% 独创性声明
%% 规范§3.15：标题三号黑体居中；内容五号宋体，行距16磅
%% 文字因学位类型而异：
%%   PracticeReport   — "实践成果"/"报告"/"校企导师"/"作者签名"
%%   SpecialEnMaster  — 论文类正文，但签名行用"作者签名"
%%   其余学位          — 论文类正文，签名行用"学位论文作者签名"
\newcommand{\makeStatement}{%
    \chapter{独创性声明}%
    \backmatterformat%
    \if@PracticeReport
        \hspace{2\ccwd}本人声明所呈交的实践成果是本人在校企导师指导下进行的研究工作和取得的研究成果，除了报告中特别加以标注和致谢之处外，报告中不包含其他人已经发表或撰写过的研究成果，也不包含为获得北京交通大学或其他教育机构的学位或证书而使用过的材料。对本研究工作作出任何贡献的个人和集体，均已在报告中以明确的方式注明并表示和谢意。

        \vspace{8ex}

        \hspace{2\ccwd}\begin{minipage}[t]{0.5\textwidth}
        作者签名：
        \end{minipage}%
        \begin{minipage}[t]{\dimexpr0.5\textwidth-2\ccwd\relax}
        签字日期：\hspace{4\ccwd}年\hspace{2\ccwd}月\hspace{2\ccwd}日
        \end{minipage}
    \else\if@SpecialEnMaster
        \hspace{2\ccwd}本人声明所呈交的学位论文是本人在导师指导下进行的研究工作和取得的研究成果，除了文中特别加以标注和致谢之处外，论文中不包含其他人已经发表或撰写过的研究成果，也不包含为获得北京交通大学或其他教育机构的学位或证书而使用过的材料。与我一同工作的同志对本研究所做的任何贡献均已在论文中作了明确的说明并表示了谢意。

        \vspace{8ex}

        \hspace{2\ccwd}\begin{minipage}[t]{0.5\textwidth}
        学位论文作者签名： % 专项专硕论文虽属论文类，但签名行用"作者签名"，可能是docx模板的疏忽，需要时可修改为"作者签名"
        \end{minipage}%
        \begin{minipage}[t]{\dimexpr0.5\textwidth-2\ccwd\relax}
        签字日期：\hspace{4\ccwd}年\hspace{2\ccwd}月\hspace{2\ccwd}日
        \end{minipage}
    \else
        \hspace{2\ccwd}本人声明所呈交的学位论文是本人在导师指导下进行的研究工作和取得的研究成果，除了文中特别加以标注和致谢之处外，论文中不包含其他人已经发表或撰写过的研究成果，也不包含为获得北京交通大学或其他教育机构的学位或证书而使用过的材料。与我一同工作的同志对本研究所做的任何贡献均已在论文中作了明确的说明并表示了谢意。

        \vspace{8ex}

        \hspace{2\ccwd}\begin{minipage}[t]{0.5\textwidth}
        学位论文作者签名：
        \end{minipage}%
        \begin{minipage}[t]{\dimexpr0.5\textwidth-2\ccwd\relax}
        签字日期：\hspace{4\ccwd}年\hspace{2\ccwd}月\hspace{2\ccwd}日
        \end{minipage}
    \fi\fi
}

%% ====================================================================
%% 十六、代码环境
%% ====================================================================

\definecolor{lst@dkgreen}{rgb}{0,0.6,0}
\definecolor{lst@gray}{rgb}{0.5,0.5,0.5}
\definecolor{lst@mauve}{rgb}{0.58,0,0.82}

\lstset{
    basicstyle       = \footnotesize\ttfamily,
    numbers          = left,
    numberstyle      = \tiny\color{lst@gray},
    stepnumber       = 1,
    numbersep        = 5pt,
    backgroundcolor  = \color{white},
    showspaces       = false,
    showstringspaces = false,
    showtabs         = false,
    frame            = single,
    rulecolor        = \color{black},
    tabsize          = 4,
    captionpos       = t,
    breaklines       = true,
    breakatwhitespace= false,
    keywordstyle     = \color{blue}\bfseries,
    commentstyle     = \color{lst@dkgreen},
    stringstyle      = \color{lst@mauve},
    escapeinside     = {\%*}{*)},
    keepspaces       = true,
    columns          = flexible,
    xleftmargin      = 2em,
    xrightmargin     = 2em,
    aboveskip        = 1em,
}
\renewcommand{\lstlistingname}{代码}

%% ====================================================================
%% 十七、列表
%% ====================================================================

%% 规范§3.10.2：正文标号按 (1)(2)(3)、1)2)3)、①②③ 顺序排列
\setlist[itemize]{noitemsep, topsep=0pt}
\setlist[enumerate]{noitemsep, topsep=0pt}

\endinput
