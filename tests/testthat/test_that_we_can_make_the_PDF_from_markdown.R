library(kwakthesis)
context("Can we make the PDF file?")

test_that("we can make the PDF file ok", {
  
  # store the time so we can check the file mod time
  time_before_making_PDF <- Sys.time()
  
  # set us in the directory of the actual thesis files
  thesis_rmd <- system.file("rmarkdown_template", "thesis.Rmd", package="kwakthesis")
  setwd(gsub("thesis.Rmd", "", thesis_rmd))
  
  # attempt to make the PDF
  rmd2pdf(thesis_rmd) 
  
  # get file modification time
  PDF_modification_time <- file.info("thesis.pdf")$mtime 
  
  # see if PDF was altered, a crude check the something happened
  expect_more_than(PDF_modification_time, time_before_making_PDF)
  
  # open PDF to have a look 
  browseURL("thesis.pdf")
  
})
