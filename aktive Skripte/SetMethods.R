
##Run these code chunks, to set the methods. class them like: U_I <- as(df, "realRatingMatrix")
library(recommenderlab)
setAs("data.frame", "realRatingMatrix", function(from) {
  user	<- from[, 1]
  item	<- from[, 2]
  if (ncol(from) >= 3)
    rating <- as.numeric(from[, 3])
  else
    rating <- rep(1, length(item))
  
  i <- factor(user)
  j <- factor(item)
  
  dgT <-
    new(
      "dgTMatrix",
      i = as.integer(i) - 1L,
      j = as.integer(j) - 1L,
      x = rating,
      Dim = c(length(levels(i)), length(levels(j))),
      Dimnames = list(levels(i), levels(j))
    )
  
  as(dgT, "realRatingMatrix")
})


setAs("realRatingMatrix", "data.frame", function(from) {
  trip <- as(from, "dgTMatrix")
  data.frame(user = rownames(from)[trip@i + 1L],
             item = colnames(from)[trip@j + 1L],
             rating = trip@x)[order(trip@i),]
})

setMethod("getList", signature(from = "realRatingMatrix"),
          function(from,
                   decode = TRUE,
                   ratings = TRUE,
                   ...) {
            trip <- as(from, "dgTMatrix")
            
            lst <- split(trip@j , trip@i)
                                            
            
            if (decode)
              lst <- lapply(lst, function(y)
                colnames(from)[y])
            
            else
              names(lst) <- NULL
            
            if (!ratings)
              return(lst)
            
            rts <- split(trip@x, f = trip@i)
            
              
            
                                        
            for (i in 1:length(rts)) {
              names(rts[[i]]) <- lst[[i]]
              
                }
            
            rts
          })

####### tm
TextDocumentMeta <-
  function(author, datetimestamp, description, heading, id, language, origin, ...,
           meta = NULL)
  {
    if (is.null(meta))
      meta <- list(author = author, datetimestamp = datetimestamp,
                   description = description, heading = heading, id = id,
                   language = language, origin = origin, ...)
    
    stopifnot(is.list(meta))
    if (!is.null(meta$author) && !inherits(meta$author, "person"))
      meta$author <- as.character(meta$author)
    if (!is.null(meta$datetimestamp) && !inherits(meta$datetimestamp, "POSIXt"))
      meta$datetimestamp <- as.character(meta$datetimestamp)
    if (!is.null(meta$description))
      meta$description <- as.character(meta$description)
    if (!is.null(meta$heading))
      meta$heading <- as.character(meta$heading)
    if (!is.null(meta$id))
      meta$id <- as.character(meta$id)
    if (!is.null(meta$language))
      meta$language <- as.character(meta$language)
    if (!is.null(meta$origin))
      meta$origin <- as.character(meta$origin)
    
    class(meta) <- "TextDocumentMeta"
    meta
  }











