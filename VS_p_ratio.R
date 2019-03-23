p_to_bf = function(p){

  bf = 1 / ( (-exp(1)) * p * log(p)  )
  
  bf[p > 0.37] = NA
  
  if(any(p > 0.37)){
    message("Only valid for p </= 0.37")
  }
  
  bf
  
}



