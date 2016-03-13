##http://blog.fens.me/r-class-s4/

setClass("BMI", representation(weight="numeric", size="numeric"))
setMethod("show", "BMI", function(object){cat("BMI=",object@weight/(object@size^2)," \n ")})

### Creation of an object for me, and posting of my BMI
(myBMI <- new("BMI",weight=85,size=1.84))
### Creation of an object for her, and posting of her BMI
(herBMI <- new("BMI",weight=62,size=1.60))

myBMI@weight
show(myBMI)


setGeneric("Warnning",
           function(obj){
             BMI<- obj@weight/((obj@size)^2)
             if(BMI>35){
               cat("You are over-weight")
             }else{cat("You are normal")}
           }
           )
Warnning(myBMI)

##膥┯
library(pryr)
setClass("Person",slots=list(name="character",age="numeric"))
father<-new("Person",name="F",age=44)

setClass("Son",slots=list(father="Person",mother="Person"),contains="Person")
father<-new("Person",name="F",age=44)
mother<-new("Person",name="M",age=39)
son<-new("Son",name="S",age=16,father=father,mother=mother)
son@age
son@father
slot(son,"mother")

##砞﹚箇砞
setClass("Person",slots=list(name="character",age="numeric"),prototype = list(age = 20))
new("Person",name="b")

##砞﹚耞
setValidity("Person",function(object) {
  if (object@age <= 0) stop("Age is negative.")
  })

n1<-new("Person",name="n1",age=19);n1
##ㄌ酚n1ミэname
n2<-initialize(n1,name="n2");n2

a<-new("Person",name="a")
slot(a, "name")
a@name

work<-function(x) cat(x, "is working")
work('Conan')

setClass("Person",slots=list(name="character",age="numeric"))
##﹚竡獂ㄧ计 work
setGeneric("work",function(object) standardGeneric("work"))
##﹚竡ㄧ计﹚把计摸Person
setMethod("work", signature(object = "Person"), function(object) cat(object@name , "is working") )
a<-new("Person",name="Conan",age=16)
work(a)

ftype(work)
work
showMethods(work)
getMethod("work", "Person")
selectMethod("work", "Person")
existsMethod("work", "Person")
hasMethod("work", "Person")

setClass("Shape",slots=list(name="character"))
setClass("Circle",contains="Shape",slots=list(radius="numeric"),prototype=list(radius = 1))
setValidity("Circle",function(object) {
  if (object@radius <= 0) stop("Radius is negative.")
  })

c1<-new("Circle",name="c1")
c2<-new("Circle",name="c2",radius=5)
##獂ㄧ计钡
setGeneric("area",function(obj,...) standardGeneric("area"))
##ㄧ计龟瞷
setMethod("area","Circle",function(obj,...){
  print("Area Circle Method")
  pi*obj@radius^2
  })
area(c1)
area(c2)

setGeneric("circum",function(obj,...) standardGeneric("circum"))
setMethod("circum","Circle",function(obj,...){
  2*pi*obj@radius
  })

circum(c1)
circum(c2)

setClass("Ellipse",contains="Shape",slots=list(radius="numeric"),prototype=list(radius=c(1,1)))

##喷靡radius
setValidity("Ellipse",function(object) {
  if (length(object@radius) != 2 ) stop("It's not Ellipse.")
  if (length(which(object@radius<=0))>0) stop("Radius is negative.")
  })

e1<-new("Ellipse",name="e1")
e2<-new("Ellipse",name="e2",radius=c(5,1))

setMethod("area", "Ellipse",function(obj,...){
  print("Area Ellipse Method")
  #prod(4:6) #4 ⊙ 5 ⊙ 6
  #prod(x)  #3.2 ⊙ 5 ⊙ 4.3
  pi * prod(obj@radius)
  })

area(e1)
area(e2)

setMethod("circum","Ellipse",function(obj,...){
  cat("Ellipse Circum :\n")
  2*pi*sqrt((obj@radius[1]^2+obj@radius[2]^2)/2)
  })
circum(e1)
circum(e2)

setClass("Shape",slots=list(name="character",shape="character"))
setClass("Ellipse",contains="Shape",slots=list(radius="numeric"),prototype=list(radius=c(1,1),shape="Ellipse"))
setClass("Circle",contains="Ellipse",slots=list(radius="numeric"),prototype=list(radius = 1,shape="Circle"))
setGeneric("area",function(obj,...) standardGeneric("area"))
setMethod("area","Ellipse",function(obj,...){
  cat("Ellipse Area :\n")
  pi * prod(obj@radius)
  })
setMethod("area","Circle",function(obj,...){
  cat("Circle Area :\n")
  pi*obj@radius^2
  })
setGeneric("circum",function(obj,...) standardGeneric("circum"))
setMethod("circum","Ellipse",function(obj,...){
  cat("Ellipse Circum :\n")
  2*pi*sqrt((obj@radius[1]^2+obj@radius[2]^2)/2)
  })
setMethod("circum","Circle",function(obj,...){
  cat("Circle Circum :\n")
  2*pi*obj@radius
  })
e1<-new("Ellipse",name="e1",radius=c(2,5))
c1<-new("Circle",name="c1",radius=2)
area(e1)
circum(e1)
area(c1)
circum(c1)

