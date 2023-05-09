## ---- include = FALSE, echo = FALSE, message =  FALSE, warning=FALSE----------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
withr:::defer({Sys.unsetenv('EDP_PROFILE')}, parent.frame(n=2))

## ----tltr_1-------------------------------------------------------------------
library(quartzbio.edp)
library(dplyr)
Sys.setenv(EDP_PROFILE = "vsim-dev_rw")
v <- Vault_create('_vignettes',  description = 'quartzbio.edp vignettes',  tags = list('please_removed'))
src_dir <- Folder_create(vault_id = v, 'src') 
datasets_dir <- Folder_create(vault_id = v, 'datasets')


## ----ds-1---------------------------------------------------------------------
irisp <- file.path(tempdir(), 'iris.csv')
write.csv(iris[1:10,], irisp)
vpath <- 'data/iris/v1/iris_10.csv'
firis <- File_upload(v, irisp, vpath )
File_query(firis)

# templating is mandatory
iris10_ds <- Dataset_create(v, 'iris_10.ds')

#fields <- quartzbio.edp:::infer_fields_from_df(iris)
fields <- list(Sepal.Length = list(name = "Sepal.Length", title = "Sepal.Length", 
    data_type = "double", description = NULL, ordering = 0), 
    Sepal.Width = list(name = "Sepal.Width", title = "Sepal.Width", 
        data_type = "double", description = NULL, ordering = 1), 
    Petal.Length = list(name = "Petal.Length", title = "Petal.Length", 
        data_type = "double", description = NULL, ordering = 2), 
    Petal.Width = list(name = "Petal.Width", title = "Petal.Width", 
        data_type = "double", description = NULL, ordering = 3), 
    Species = list(name = "Species", title = "Species", data_type = "string", 
        description = NULL, ordering = 4))


# does not work
# imp1 <- Dataset_import(iris10_ds, 
#   object_id = firis$id,
#   target_fields = fields,
#   sync = TRUE)


imp <- DatasetImport.create(dataset_id = iris10_ds$id,
                            object_id = firis$id,
                            target_fields = fields )
Dataset.activity(iris10_ds$id)

a10 <- Dataset_query(iris10_ds, limit= 2) # it's an append
Dataset_query(iris10_ds)


## ----ds-2---------------------------------------------------------------------
iris_2 <- Dataset_create(v, 'iris_2.ds')
iris_2$full_path
iris_2$object_type

import_res <- Dataset_import(iris_2, df = iris[1:2, ], sync = TRUE)
iris_2 <- Dataset(vault_id = v, path = iris_2$path)

## ----ds-3---------------------------------------------------------------------
genes_1 <- Dataset_create(v, 'genes.ds', 
  description = "genes hits",
  metadata = list(DEV = TRUE), 
  tags = list("QBP", "EDP"), 
  storage_class = "Temporary", capacity = "small")

records <- list(
  list(gene = "CFTR", importance = 1, sample_count = 2104),
  list(gene = "BRCA2", importance = 1, sample_count = 1391),
  list(gene = "CLIC2", importance = 5, sample_count = 14)
)

import_res <- Dataset_import(genes_1, records = records, sync = TRUE)
g1 <- Dataset_query(genes_1, limit = 1)
fetch_all(g1)

## ----ds-4---------------------------------------------------------------------
nobs <- Dataset_create(v, 'dna_gurus.ds')
authors <- list(
    list(name='Francis Crick'),
    list(name='James Watson'),
    list(name='Rosalind Franklin')
)
# additional firt and last name fields to be created
target_fields <- list(
  list(
    name="first_name",
    description="Adds a first name column based on name column",
    data_type="string",
    expression="record.name.split(' ')[0]"
  ),
  list(
    name="last_name",
    description="Adds a last name column based on name column",
    data_type="string",
    expression="record.name.split(' ')[-1]"
  )
)
res <- Dataset_import(nobs, records = authors, 
  target_fields = target_fields, 
  sync = TRUE)
Dataset_query(nobs)

## ----ds-5---------------------------------------------------------------------
# fetch the first row
f1r_ds <- Dataset_query(iris_2, limit=1)

fetch_next(f1r_ds)

fetch_all(f1r_ds)

# Filters acts on column fields that matches the data.frame import.
Dataset_query(iris_2, filters= filters('Species contains "setosa"'))

Dataset_query(iris_2, filters= filters('Sepal.Length >= 5.1'))

Dataset_query(iris_2, filters= filters('(Sepal.Length >= 5.1) OR  (Sepal.Width <= 3.0)'))

# Keep fields
Dataset_query(iris_2, 
  fields = c('Petal.Width', 'Species'),
  filters= filters('(Sepal.Length >= 5.1) OR  (Sepal.Width <= 3.0)'))

# Exclude fields
Dataset_query(iris_2, 
  exclude_fields = c('Petal.Width', 'Species'),
  filters= filters('(Sepal.Length >= 5.1) OR  (Sepal.Width <= 3.0)'))

# Ordering
Dataset_query(iris_2, 
   ordering = 'Sepal.Length')

delete(v)

