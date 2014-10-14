#' @title
#' Get YAML Markup (generic)
#'
#' @description 
#' Identifies lines that correspond to YAML markup.
#'   	
#' @template yaml-syntax
#'     
#' @param from \strong{Signature argument}.
#'    Object containing YAML markup.
#' @param ctx \strong{Signature argument}.
#'    Markup proecessing context.
#' @param where \code{\link{environment}}.
#'    Environment in which to assign the function in the \code{src} field of 
#'    class \code{\link[yamlr]{ObjectReferenceYaml.S3}}. Only relevant 
#'    in case the YAML has been provided via comments instead of an 
#'    inline string as this involves some additional transformation steps.
#' @template threedots
#' @example inst/examples/getYaml.r
#' @seealso \code{
#'   	\link[yamlr]{getYaml-function-YamlContext.ObjectReference.S3-method}
#' }
#' @template author
#' @template references
setGeneric(
  name = "getYaml",
  signature = c(
    "from",
    "ctx"
  ),
  def = function(
    from,
    ctx = NULL,
    where = parent.frame(),
    ...
  ) {
    standardGeneric("getYaml")       
  }
)

#' @title
#' Get YAML Markup (function-YamlContext.ObjectReference.S3)
#'
#' @description 
#' See generic: \code{\link[yamlr]{getYaml}}
#'      
#' @inheritParams getYaml
#' @param from \code{\link{missing}}.
#' @return \code{\link{character}}. Identified YAML markup.
#' @example inst/examples/getYaml.r
#' @seealso \code{
#'    \link[yamlr]{getYaml}
#' }
#' @template author
#' @template references
#' @aliases getYaml-function-YamlContext.ObjectReference.S3-method
#' @export
setMethod(
  f = "getYaml", 
  signature = signature(
    from = "function",
    ctx = "YamlContext.ObjectReference.S3"
  ), 
  definition = function(
    from,
    ctx,
    where,
    ...
  ) {
    
  ## Identification pattern //    
  pattern <- ctx$pattern
  
  ## Store initial form of `from` //
  from_0 <- from
  
  from <- body(from_0)
  in_body <- TRUE  
  
  index <- which(sapply(from, function(from) {
    any(grepl(pattern, from))
  }))
  if (!length(index)) {
    ## Try if YAML was specified as comment //
    code <- capture.output(from_0)
    index <- which(sapply(code, function(from) {
      any(grepl(pattern, from))
    }))
    if (length(index)) {
      ## Transform expression //
      code[index] <- paste0("\"", gsub("\\s*#\\s*", "", code[index]), "\"")
      expr_char <- paste(c("quote({", paste(rep("expr", length(code[-1]))), "})"),
                         collapse = "\n")
      tmp <- function() expr
      body(tmp) <- eval(parse(text = expr_char))
      for(ii in seq(along = code[-1])) {
        body(tmp)[[ii+1]] <- substitute(CODE, list(CODE = parse(text = code[-1][[ii]])[[1]]))
      }
      from_0 <- tmp
      environment(from_0) <- where
      from <- body(from_0)
      index <- which(sapply(from, function(from) {
        any(grepl(pattern, from))
      }))
      in_body <- TRUE
    }
  }
  if (length(index)) {
    ObjectReferenceYaml.S3(
      original = unname(sapply(index, function(idx) from[[idx]])),
      index = index,
      src = from_0
    )
  } else {
    ObjectReferenceYaml.S3()
  }
  
  }
)
