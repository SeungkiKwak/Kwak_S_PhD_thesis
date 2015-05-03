Seungki Kwak's PhD Thesis
==============================

The thesis chapter and figures in the `inst/rmarkdown` directory.

## Installation

To install this as an R package, and access the thesis files, use `devtools`  with the following lines at the R prompt:

```
library(devtools)
devtools::install_github("SeungkiKwak/kwakthesis")
```

or you can  clone this repo and build the package manually, with this line at the terminal:

```
git clone https://github.com/SeungkiKwak/kwakthesis
```

##  Build the thesis

One you have the R package, use the function `rmd2pdf` to make a PDF file of the thesis. 


## Dependencies

You may need to install some additional software before you can build the PDF. In particular, the process depends on xelatex and [pandoc](http://johnmacfarlane.net/pandoc/installing.html). You can check to see if you have these by running these lines at a shell prompt:

```
which pandoc
which xelatex
which biber
```

