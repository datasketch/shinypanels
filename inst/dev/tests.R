


tabsetPanel(id = "tabs", type = "pills",
            tabPanel(id = "main_step1", "Datos",
                     fluidRow(
                       p("dataMain")

                     )
            ),
            tagList(tabPanel(id = "main_step2", "Visualización",
                     fluidRow(
                       p("debugViz")
                     )
            ))
)



main <- tagList(
  tabPanel(id = "main_step2", "Dta",
           fluidRow(
             p("debugViz")
           )),
  tabPanel(id = "main_step3", "Visualización",
           fluidRow(
             p("debugViz")
           ))

)
tabsetPanel(id = "tabs", type = "pills",
            #div(id = "main",
            main
)

do.call("tabsetPanel", c(id = "tabs", type = "pills", main))


tabsetPanel(id = "tabs", type = "pills",
            #div(id = "main",
            tabPanel(id = "main_step2", "Visualización",
                     fluidRow(
                       p("debugViz")
                     ))
)




