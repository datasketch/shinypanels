context("layout")

test_that("Layout",{


  f <- function(title = NULL, ...){
    # if(missing(..1))
    #   stop("need ui components")
    # if(!is.null(formals()["title"])){
    #   message("no title")
    #   contents <- c(as.list(environment()), list(...))
    #   return(list(title = NULL, contents = contents))
    # }
    # contents <- list(...)
    # list(title = title, contents = contents)
   # "title" %in% names(formals())
    #list(formals(), list(...), list(..0),list(..1))
    #list(formals(), list(...),list(..1))
    #formals()[["title"]]
    #as.list(environment())
    #c(as.list(environment()), list(...))
    #match.call(expand.dots = TRUE)
    #sapply(match.call(expand.dots=TRUE)[-1], deparse)
    names(match.call())
  }
  a <- f(title = "TITLE")
  a
  b <- f("x",'s')
  b
  c <- f(title = "title", c(1,3),"fdsa")
  c


  sideBarStep(p("sidebar step2"))

  sideBarStep(title = "STEP2",
              p("sidebar step2")
  )


  ##

  steps <- list(
    stepPanel(id="first",
              sideBarStep(title = "STEP1",
                          p("sidebar step1")
              ),
              mainStep(
                p("main step1")
              )
    ),
    stepPanel(id="second",
              sideBarStep(
                          p("sidebar step2")
              ),
              mainStep(
                p("main step2")
              )
    )
  )


  steps



  stepsPage(
    useShinyjs(),
    verbatimTextOutput("debug"),
    stepsetPanel(
      stepPanel(id="first",
                sideBarStep(title = "STEP1",
                            p("sidebar step1")
                ),
                mainStep(
                  p("main step1")
                )
      ),
      stepPanel(id="second",
                sideBarStep(title = "STEP2",
                            p("sidebar step2")
                ),
                mainStep(
                  p("main step2")
                )
      )
    )
  )




})
