# 🎓 北京交通大学研究生学位论文 LaTeX 模板

还在对着 Word 模板调间距、改字号、把自己逼成排版工人？试试这个模板吧。

## 为什么要做这个模板？

学校官方 LaTeX 模板年久失修——宏包定义繁杂、格式与《论文撰写规范》存在出入，且不同学位类型需要分别维护。今年工程硕博士培养改革专项试点（卓工）又新增了两种模板，亟需一个统一的 LaTeX 模板。

于是，本项目对照《北京交通大学博士、硕士学位论文撰写规范》和各学位类型官方 Word 模板，从头重构了 LaTeX 项目，将研究生全部 **6 种论文/成果报告**统一在同一套模板下，切换学位类型只需改一个参数。

虽然已尽全力逐项校验，难免仍有疏漏，欢迎大家一起完善，希望最终能将本项目建设成为学校官方推荐使用的 LaTeX 模板！

**后续计划：**

- [ ] 盲审模式（一键隐藏作者、导师等个人信息）
- [ ] 本科毕业设计模板
- [ ] 课程实验报告模板

有任何问题请提 Issue，觉得有用的话也请点个 ⭐Star！

---

## 📅 最新动态

- **2026-03-19** 🔧 v0.1.1 修复外封信息居中对齐、内封信息值紧贴冒号后且折行正确对齐、修复页眉样式及双面空白页等问题
- **2026-03-17** 🎉 v0.1.0 发布，支持研究生全部 6 种类型论文/成果报告，对照撰写规范和各学位 Word 模板完整校验

---

## 📋 支持的论文/成果报告类型

| 参数 | 学位类型 |
|------|---------|
| `AcMaster` | 学术型硕士（默认） |
| `EnMaster` | 专业型硕士 |
| `Doctor` | 学术型博士 |
| `ProDoctor` | 专业型博士 |
| `SpecialEnMaster` | 工程硕博士培养改革专项试点·硕士专业学位 |
| `PracticeReport` | 工程硕博士培养改革专项试点·硕士专业学位实践成果总结报告 |

仓库根目录的 [`main.pdf`](https://github.com/LaoKing233/BJTU-Omni-Thesis-Template/blob/main/main.pdf) 为”学术型硕士，双面打印”的示例编译结果，可直接查看排版效果。

---

## 🚀 快速开始

### 第零步：阅读撰写规范

本项目已配置好所有格式，示例章节也对规范中的重要内容做了详尽展示。但强烈推荐先花时间读一遍[《北京交通大学博士、硕士学位论文撰写规范》](https://gs.bjtu.edu.cn/docs/2025-01/14cedd9a314e43e295baaf192d9d8ba8.doc)——规范里描述了论文各章节应该写什么、以及一些细枝末节的格式要求，快速通读一遍对撰写论文很有帮助。

### 第一步：选学位类型

打开 `main.tex`，第一行改成你的学位类型：

```latex
\documentclass[degree=AcMaster]{BJTU-thesis}           % 学术硕士，单面
\documentclass[degree=Doctor, twoside]{BJTU-thesis}    % 学术博士，双面
```

> 📌 规范 §3.18：正文 60 页以上用双面打印，加 `twoside` 参数即可，其余不变。

### 第二步：填封面信息

打开 `main.tex`，按注释说明填写对应字段即可，不用的字段留着不影响编译。

### 第三步：编译

> ⚠️ 保留项目根目录的 `latexmkrc` 文件，编译配置全在里面，不要删除。

本项目已在 **TeX Live 2025** 下编译通过，推荐以下方案：

**本地编译：** VS Code + [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop) 插件 + TeX Live 2025（完整版）

**线上编译：**
- [Overleaf](https://www.overleaf.com)：打包上传整个项目直接编译
- [overleaf-toolkit](https://github.com/overleaf/toolkit)：自部署 Overleaf，同样基于 TeX Live 完整版

---

## 📖 示例章节

`chapters/chapter_example.tex` 是完整的 LaTeX 使用示例，覆盖标题、图表、公式、列表、代码、参考文献引用等论文写作中的常见场景，所有示例均严格遵循撰写规范。

保留此章有两个用途：一是便于作者随时查阅用法；二是便于 AI agent 生成符合规范的论文内容。**撰写期间请勿删除**，提交前将 `main.tex` 中对应的 `\include{chapters/chapter_example}` 行注释掉即可。

---

## 📁 项目结构

```
BJTU-thesis-template/
├── main.tex               # 从这里开始，填信息、组织章节
├── BJTU-thesis.cls        # 样式文件，一般不用动
├── chapters/
│   ├── acknowledgements.tex   # 致谢
│   ├── abstract.tex           # 中文摘要
│   ├── abstract_en.tex        # 英文摘要
│   ├── preface.tex            # 序言（可选）
│   ├── chapter_example.tex    # LaTeX 使用示例（提交前注释掉 include 行）
│   ├── chapter01~05.tex       # 正文章节
│   ├── appendix01.tex         # 附录
│   ├── index.tex              # 索引（可选）
│   ├── resume.tex             # 作者简历及研究成果
│   ├── dataset.tex            # 学位论文数据集
│   └── evaluation.tex         # 企业评价意见（专项专硕/实践报告）
├── figures/               # 把图放这里
├── fonts/                 # 宋体、黑体、楷体、华文中宋
├── reference/ref.bib      # 参考文献
├── scripts/               # 工具脚本
│   ├── word_count.sh      # 字数统计（Linux/macOS）
│   └── word_count.ps1     # 字数统计（Windows PowerShell）
├── outputs/               # 脚本输出（字数统计结果等）
└── schoolName.pdf         # 外封用的学校名称图
```

---

## 🧹 清理中间文件

```bash
latexmk -c
```

---

## 📊 字数统计

依赖 `texcount`（TeX Live 自带），递归统计所有章节文件的正文字数。在项目根目录下运行：

**Linux/macOS：**
```bash
bash scripts/word_count.sh
```

**Windows PowerShell：**
```powershell
scripts\word_count.ps1
```

统计摘要直接打印到终端，完整结果保存至 `outputs/main.wordcnt`。

---

## 📄 版权

本项目基于 MIT 协议开源，学校标志版权归北京交通大学所有。


---

## 🙏 致谢

感谢以下项目的工作，本模板在参考其思路和实现的基础上重构而来：

- [PangSMPang/bjtuthesis](https://github.com/PangSMPang/bjtuthesis) — 北京交通大学本科毕业设计 LaTeX 模板
- [anabioticsoul/BJTU-thesis-template](https://github.com/anabioticsoul/BJTU-thesis-template) — 北京交通大学研究生学位论文 LaTeX 模板