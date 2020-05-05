options(stringsAsFactors=FALSE)
options(scipen = 99)
options(install.packages.compile.from.source = "always")
options(repos = list(CRAN = 'https://cran.us.r-project.org'))

#alert if package updates are available
local({

	old = utils::old.packages()
	
	if(!is.null(old)){
		message("package updates are available")
		print(old[, c("Package", "Installed", "ReposVer")])
		message("package updates are available")
		
		pkg = old[, "Package"]
		pkg = paste0("'", paste0(pkg, sep="', '", collapse = ""))
		pkg = gsub(", \\'$","" , pkg)
		
		message(paste0("install.packages(c(",  pkg, "), Ncpus = 6)"))
		
	}
		
})
