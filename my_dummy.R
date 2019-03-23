library(foreach)
library(doParallel)


my_dummy = function(x, prefix = NULL, sep="_", parallel = T, cores = 3, chunk.size=50){


	temp = unique(unlist(x))
	temp = temp[!is.na(temp)]

	cat("\r", 0, " of ", length(temp), " vars dummy coded" )
	flush.console()
	if(parallel){

		nchunks = ceiling( length(temp)/chunk.size)

		starts = seq(1, length(temp), chunk.size)
		if(nchunks > 1){
			ends = c(seq(chunk.size, length(temp), chunk.size), length(temp))
		} else{
			ends = length(temp)
		}

		library(foreach)
		library(doParallel)


		for(a in 1:nchunks){


			cores = as.integer(cores)

			if(is.null(cores) | is.na(cores)){
				registerDoParallel()
			} else{
				registerDoParallel(cores = cores)
			}


			if( ncol(as.data.frame(x))>1 ){
				chunk_res = foreach(i = starts[a]:ends[a] , .combine=cbind) %dopar% {
					rowSums( ( x == temp[i]), na.rm = T  )>0
				}
			}

			if( ncol(as.data.frame(x))==1 ){
				chunk_res = foreach(i = starts[a]:ends[a] , .combine=cbind) %dopar% {
					x %in% temp[i]
				}
			}

			cat("\r", ends[a], " of ", length(temp), " vars dummy coded" )
			flush.console()

			# cat("\n", ends[a], " of ", length(temp), " vars dummy coded\n" )

			# stopImplicitCluster()
			#
			# invisible(gc())

			if(a == 1){
				r = chunk_res
				rm(chunk_res)
			}

			if(a > 1){
				r = cbind(r, chunk_res)
				rm(chunk_res)
			}


		}


		stopImplicitCluster()
		r = as.data.frame(r)
		colnames(r) = gsub(" ", "_", temp, fixed = T)

		if(!is.null(prefix)){
			colnames(r) = paste(prefix, colnames(r), sep=sep)
		}
	}

	if( !parallel ){

		r = as.data.frame( matrix(NA, nrow = nrow(x), ncol=length(temp)) )
		colnames(r) = gsub(" ", "_", temp, fixed = T)

		if(!is.null(prefix)){
			colnames(r) = paste(prefix, colnames(r), sep=sep)
		}


		for(i in 1:length(temp)){

			if( ncol(as.data.frame(x))>1 ){
				r[, i] = rowSums( ( x == temp[i]), na.rm = T  )>0
			}

			if( ncol(as.data.frame(x))==1 ){
				r[, i] =  x %in% temp[i]
			}


			if(i %% min(c(length(temp), chunk.size))==0){
				cat("\n", i, " of ", length(temp), " vars dummy coded\n" )
			}

		}

	}


	r


}
