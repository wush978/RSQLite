context("encoding")

test_that("write tables whose colnames or contents are BIG5 encoded", {
  skip_if(.Platform$OS.type != "windows")
  .loc <- Sys.getlocale("LC_COLLATE")
  Sys.setlocale(locale = "cht")
  con <- dbConnect(SQLite())
  on.exit({
    Sys.setlocale(locale = .loc)
    dbDisconnect(con)
  })

  . <- rawToChar(as.raw(c(0xa4, 0xa4, 0xa4, 0xe5)))
  df <- structure(
    list(V1 = 1:3),
    class = "data.frame",
    row.names = 1:3)
  colnames(df) <- .
  dbWriteTable(con, "a", df)
  res <- dbReadTable(con, "a")
  expect_identical(res, df)

  df <- structure(
    list(V1 = 1:3, V2 = rep(., 3)),
    class = "data.frame",
    row.names = 1:3)
  colnames(df) <- paste(., 1:2, sep = "")
  dbWriteTable(con, "b", df)
  res <- dbReadTable(con, "b")
  expect_identical(res, df)
})

test_that("write tables whose colnames and contents are UTF-8 encoded", {
  .loc <- Sys.getlocale("LC_COLLATE")
  if (.Platform$OS.type == "windows") {
    Sys.setlocale(locale = "cht")
  } else {
    Sys.setlocale(locale = "zh_TW.UTF-8")
  }
  con <- dbConnect(SQLite())
  on.exit({
    Sys.setlocale(locale = .loc)
    dbDisconnect(con)
  })

  . <- rawToChar(as.raw(c(0xe4, 0xb8, 0xad, 0xe6, 0x96, 0x87)))
  Encoding(.) <- "UTF-8"
  df <- structure(
    list(V1 = 1:3),
    class = "data.frame",
    row.names = 1:3)
  colnames(df) <- .
  dbWriteTable(con, "a", df)
  res <- dbReadTable(con, "a")
  expect_identical(res, df)

  df <- structure(
    list(V1 = 1:3, V2 = rep(., 3)),
    class = "data.frame",
    row.names = 1:3)
  colnames(df) <- paste(., 1:2, sep = "")
  dbWriteTable(con, "b", df)
  res <- dbReadTable(con, "b")
  expect_identical(res, df)
})

test_that("list the field of tables whose colnames are BIG5 encoded", {
  skip_if(.Platform$OS.type != "windows")
  .loc <- Sys.getlocale("LC_COLLATE")
  if (.Platform$OS.type == "windows") {
    Sys.setlocale(locale = "cht")
  } else {
    Sys.setlocale(locale = "zh_TW.UTF-8")
  }
  con <- dbConnect(SQLite())
  on.exit({
    Sys.setlocale(locale = .loc)
    dbDisconnect(con)
  })

  . <- rawToChar(as.raw(c(0xa4, 0xa4, 0xa4, 0xe5)))
  df <- structure(
    list(V1 = 1:3),
    class = "data.frame",
    row.names = c(NA, -3L))
  colnames(df) <- .
  dbWriteTable(con, "a", df)
  expect_identical(dbListFields(con, "a"), colnames(df))
  df <- structure(
    list(V1 = 1:3, V2 = rep(., 3)),
    class = "data.frame",
    row.names = 1:3)
  colnames(df) <- paste(., 1:2, sep = "")
  dbWriteTable(con, "b", df)
  expect_identical(dbListFields(con, "b"), colnames(df))

})

test_that("list the field of tables whose colnames are UTF-8 encoded", {
  .loc <- Sys.getlocale("LC_COLLATE")
  if (.Platform$OS.type == "windows") {
    Sys.setlocale(locale = "cht")
  } else {
    Sys.setlocale(locale = "zh_TW.UTF-8")
  }
  con <- dbConnect(SQLite())
  on.exit({
    Sys.setlocale(locale = .loc)
    dbDisconnect(con)
  })

  . <- rawToChar(as.raw(c(0xe4, 0xb8, 0xad, 0xe6, 0x96, 0x87)))
  Encoding(.) <- "UTF-8"
  df <- structure(
    list(V1 = 1:3),
    class = "data.frame",
    row.names = c(NA, -3L))
  colnames(df) <- .
  dbWriteTable(con, "a", df)
  expect_identical(dbListFields(con, "a"), colnames(df))
  df <- structure(
    list(V1 = 1:3, V2 = rep(., 3)),
    class = "data.frame",
    row.names = 1:3)
  colnames(df) <- paste(., 1:2, sep = "")
  dbWriteTable(con, "b", df)
  expect_identical(dbListFields(con, "b"), colnames(df))

})

test_that("append tables whose colnames are UTF-8 encoded", {
  .loc <- Sys.getlocale("LC_COLLATE")
  if (.Platform$OS.type == "windows") {
    Sys.setlocale(locale = "cht")
  } else {
    Sys.setlocale(locale = "zh_TW.UTF-8")
  }
  con <- dbConnect(SQLite())
  on.exit({
    Sys.setlocale(locale = .loc)
    dbDisconnect(con)
  })

  df <- structure(
    list(V1 = 1:3),
    class = "data.frame",
    row.names = c(NA, -3L))
  . <- rawToChar(as.raw(c(0xe4, 0xb8, 0xad, 0xe6, 0x96, 0x87)))
  Encoding(.) <- "UTF-8"
  colnames(df) <- .
  dbWriteTable(con, "a", df)
  dbWriteTable(con, "a", df, append = TRUE)
  df <- structure(
    list(V1 = 1:3, V2 = rep(., 3)),
    class = "data.frame",
    row.names = 1:3)
  colnames(df) <- paste(., 1:2, sep = "")
  dbWriteTable(con, "b", df)
  dbWriteTable(con, "b", df, append = TRUE)
})


