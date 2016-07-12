df <- data.frame(x = c(a = 1, b = 2, c = 3))
df %>% tbl_df()
df %>% nrow()
df %>% tbl_df() %>% add_rownames()
df %>% tibble::rownames_to_column()

##重複取26次，simplify=T時會變一整個matrix
l <- replicate(26, sample(100), simplify = FALSE)
names(l) <- letters
