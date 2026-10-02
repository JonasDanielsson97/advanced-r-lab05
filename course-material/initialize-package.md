# Initialize Package

## Project structure

Aim for something like:

```text
advanced-r-lab05/
├── advanced-r-lab05.Rproj
├── DESCRIPTION
├── NAMESPACE
├── R/
├── tests/
└── README.md
```

Keep the actual package name in `DESCRIPTION`, for example:

```text
Package: lab05
```

## Git and GitHub

Initialize Git locally and make an initial commit.

Create an empty GitHub repository, for example:

```text
advanced-r-lab05
```

Then connect it:

```bash
git remote add origin https://github.com/JonasDanielsson97/advanced-r-lab05.git
git push -u origin main
```

Verify with:

```bash
git remote -v
```

## Clean the RStudio skeleton

Remove the default files if they exist:

```text
R/hello.R
man/hello.Rd
```

Delete the original skeleton `NAMESPACE` and let `devtools::document()` regenerate it later.

## DESCRIPTION

Update:

- Title
- Version
- Authors
- Description
- `Encoding: UTF-8`
- License

For MIT:

```r
usethis::use_mit_license()
```

Add package dependencies later when needed:

```r
usethis::use_package("package")
```

## README

```r
usethis::use_readme_md()
```

## Tests

Set up testthat:

```r
usethis::use_testthat()
```

Put test files in:

```text
tests/testthat/
```

## Package data

Only if the lab needs package data:

```r
usethis::use_data_raw()
```

and later:

```r
usethis::use_data(my_data)
```

## Ignore files

Remember to review and update:

```text
.gitignore
.Rbuildignore
```

Use `.gitignore` for files Git should not track.

Use `.Rbuildignore` for files that may stay in the repository but should not be included when the R package is built.

## Documentation and checks

Once functions and roxygen comments exist:

```r
devtools::document()
devtools::load_all()
devtools::test()
devtools::check()
```

## GitHub Actions

Wait until the package is reasonably functional, then add CI:

```r
usethis::use_github_action("check-standard")
```

## Final setup check

Before starting the actual assignment, make sure:

```bash
git status
git remote -v
```

look sensible and the repository is connected to the correct GitHub repo.
