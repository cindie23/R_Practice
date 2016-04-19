library(shiny)
runExample("01_hello")
setwd('D:\\abc\\wjhong\\projects\\R_practice')
#runApp(“資料夾名稱")

#自ui.R中的輸入元件給定一個樣本數(input$obs)
#傳到server.R裡面的反應函數(renderPlot)進行計算
#最後傳回ui.R的輸出元件(output$distPlot)畫出圖片
runApp('shiny_practice')

runApp('shiny_practice2')
runApp('shiny_practice3')
runApp('shiny_practice4')
