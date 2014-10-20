#' @title
#' Parse YAML Markup (generic)
#'
#' @description 
#' Parses YAML markup as identified by \code{\link[yamlr]{getYaml}}.
#' 
#' @template yaml-syntax
#'   	
#' @param yaml \strong{Signature argument}.
#'    Object containing identified YAML markup as returned by 
#'    \code{\link[yamlr]{getYaml}}.
#' @template threedots
#' @example inst/examples/parseYaml.r
#' @seealso \code{
#'   	\link[yamlr]{parseYaml-function-YamlContext.ObjectReference.S3-method}
#' }
#' @template author
#' @template references
setGeneric(
  name = "parseYaml",
  signature = c(
    "yaml"
  ),
  def = function(
    yaml,
    ...
  ) {
    standardGeneric("parseYaml")       
  }
)

#' @title
#' Parse YAML Markup (ObjectReferenceYaml.S3)
#'
#' @description 
#' See generic: \code{\link[yamlyaml]{parseYaml}}
#'      
#' @inheritParams parseYaml
#' @param yaml \code{\link{ObjectReferenceYaml.S3}}.
#' @return \code{\link{ObjectReferenceYamlParsed.S3}}. 
#'    Parsed YAML markup.
#' @example inst/examples/parseYaml.r
#' @seealso \code{
#'    \link[yamlyaml]{parseYaml}
#' }
#' @template author
#' @template references
#' @export
#' @import yaml
#' @aliases parseYaml-ObjectReferenceYaml.S3-method
setMethod(
  f = "parseYaml", 
  signature = signature(
    yaml = "ObjectReferenceYaml.S3"
  ), 
  definition = function(
    yaml,
    ...
  ) {
        
  if (!length(yaml$original)) {
    stop("Empty YAML markup field (`original`)")
  }  
    
  nms <- vector("character", length(yaml$original))
  parsed <- lapply(seq(along=yaml$original), function(ii) {
    parsed <- yaml::yaml.load(yaml$original[ii])[[1]]
    if (is.null(parsed$where)) {
      parsed$where <- as.name("where")
    } else {
      parsed$where <- as.name(parsed$where)
    }
    if (is.null(parsed$as)) {
      parsed$as <- as.name(parsed$id)
    } else {
      parsed$as <- as.name(parsed$as)
    }
    nms[[ii]] <<- parsed$id
    parsed$index <- yaml$index[ii]
    parsed$expr <- new.env(parent = emptyenv())
    parsed
  })
  names(parsed) <- nms
  out <- yamlr::ObjectReferenceYamlParsed.S3(
    original = yaml$original,
    parsed = parsed,
    index = yaml$index,
    src = yaml$src
  )
  return(out)
  
  }
)
