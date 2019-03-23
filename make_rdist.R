make_rdist = function(x, name, by=NULL){
	
	
	vals = unique(x)
	vals = vals[!is.na(vals)]
	
	probs = sapply(vals, function(z) mean(x == z, na.rm = T))
	
	
	func <- function(n=10){
		sample(vals, n, replace=T, prob = probs)
	}
	
	assign(name, func, envir = .GlobalEnv)
	
	
}
