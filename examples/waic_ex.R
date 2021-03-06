data(fung)

# prep data
fung.detect <- fung %>%
  dplyr::select(1:4)

site.df <- fung %>%
  dplyr::select(-sample, -pcr1, -pcr2) %>%
  dplyr::distinct(site, .keep_all = TRUE) %>%
  dplyr::arrange(site)

sample.df <- fung %>%
  dplyr::select(-pcr1, -pcr2) %>%
  dplyr::arrange(site, sample)

# fit intercept model at all three levels use beta-binomial sampler
fung_mod1 <- msocc_mod(wide_data = fung.detect, progress = T,
                       site = list(model = ~ 1, cov_tbl = site.df),
                       sample = list(model = ~ 1, cov_tbl = sample.df),
                       rep = list(model = ~ 1, cov_tbl = sample.df), # covariates aggregated at sample level
                       num.mcmc = 1000, beta_bin = T)

# model sample level occurence by frog density
fung_mod2 <- msocc_mod(wide_data = fung.detect, progress = T,
                       site = list(model = ~ 1, cov_tbl = site.df),
                       sample = list(model = ~ frogs, cov_tbl = sample.df),
                       rep = list(model = ~ 1, cov_tbl = sample.df),
                       num.mcmc = 1000, beta_bin = T)

# compare
waic(fung_mod1)
waic(fung_mod2)
