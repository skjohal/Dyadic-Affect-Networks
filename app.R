library(shiny)
library(shinybrowser)
library(magick)

# Define UI for application that visualizes dyadic networks
ui <- fluidPage(

    # Application title
    titlePanel("Visualization of Dyadic Affect Networks Over Time"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "dyadNumber",
                        label = "Select Dyad",
                        choices = paste0("Dyad ", 1:127),
                        multiple = FALSE),
            p("After selecting a dyad, you will be able to view the
              lag-1 relations between the positive affect (PA) and negative
              affect (NA) with respect to the romantic relationship of each member of the couple"),
            p("Solid blue lines indicate positive relations, while dashed red lines
              indicate negative relations"),
            p("The thickness of the line is proportional to the strength
              of the lag-1 effect")
        ),
        # mainPanel(
        #     imageOutput("selected_dyad")
        # )
        mainPanel(
            htmlOutput(outputId = "selected_dyad"),
            shinybrowser::detect()
        )

    )
)
    

# Define server logic required to draw a histogram
server <- function(input, output) {

    # Will have to renderText here, and then the output in the ui will
    # be outputHTML (text = link to dyadic network)
    #sprintf is function that is alternative to paste
    
    # link to the GitHub page for the network of the selected dyad

    output$selected_dyad = renderText({
        file = sprintf(fmt = "https://raw.githubusercontent.com/skjohal/Dyadic-Affect-Networks/main/Dyad%%20GIFs/%s_NetworkGIF.gif?token=GHSAT0AAAAAAB3JQBU4FWHHO7VTBKI44TUIY34BUBQ",
                        gsub(" ", "", input$dyadNumber))
        dims = image_info(image_read(file))
        screen_wdth = shinybrowser::get_width()
        img_wdth = screen_wdth*.5
        img_ht = (img_wdth*dims$height)/dims$width
        return(c('<center><img src="',file,'" width="', img_wdth, '" height="', img_ht,'"></center>', sep = ""))

    })

    # output$selected_dyad = renderImage({
    #     list(src = sprintf(fmt = "Dyad GIFs/%s_NetworkGIF.gif",
    #                        gsub(" ", "", input$dyadNumber)),
    #          width = 500, height = 500,
    #          deleteFile = FALSE)
    # })


}

# Run the application 
shinyApp(ui = ui, server = server)


