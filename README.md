Seungki Kwak's PhD Thesis
==============================

This research compendium contains the source files for my PhD. It is organised as an R package that contains a function that will render the R markdown files into a single attractive PDF that conforms to the [UW Graduate School requirements for thesis formatting](http://www.grad.washington.edu/students/etd/req-sections.shtml). The thesis chapters, figures and raw data files are in the `inst/rmarkdown` directory.

## Installation

The most convinent way to access the files in this compendium is to download the zip file and unzip on your computer, or clone this repository to your computer with this line at the terminal:

```
git clone https://github.com/SeungkiKwak/kwakthesis
```

Then open the `Kwak_S_PhD_Thesis.RProj` file in RStudio to explore the compendium. The PDF file of the thesis, along with other supporting material, is in the `inst/rmarkdown_template` directory .

To install this as an R package, and access the thesis files, use `devtools`  with the following lines at the R prompt:

```
library(devtools)
devtools::install_github("SeungkiKwak/kwakthesis")
```

##  Build the thesis

If you want to rebuild the PDF file of the thesis, you'll need to make a copy of this repository as indicated above, then change the working directory  in R to `inst/rmarkdown_template` and use the function `rmd2pdf` to make a PDF file of the thesis, like this:

```
rmd2pdf("thesis.Rmd")
```

## Dependencies

You may need to install some additional software before you can build the PDF. In particular, the process depends on [Xelatex](http://en.wikipedia.org/wiki/XeTeX) and [pandoc](http://johnmacfarlane.net/pandoc/installing.html). You can check to see if you have these by running these lines at a shell prompt:

```
which pandoc
which xelatex
which biber
```

## Acknowledgements

For acknowledgements relating to the PhD project, please see the PDF in `inst/rmarkdown_template`. Here I acknowledge projects that I have drawn from to create this repository (and not the PhD thesis). This compedium contains source code and formatting ideas from the following sources:

* [Latex, Knitr, and RMarkdown templates for UC Berkeley's graduate thesis](https://github.com/stevenpollack/ucbthesis)
* [Jim Fox's LaTeX Class file for University of Washington thesis formatting](https://github.com/UWIT-IAM/UWThesis)
* [Dissertate: a LaTeX dissertation template to support the production and typesetting of a PhD dissertation at Harvard, Princeton, and NYU](https://github.com/suchow/Dissertate) 

