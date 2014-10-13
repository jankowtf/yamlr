\dontrun{

## Example YAML //
yaml <- getYaml(
  from = function() {
    "reactive-ref: {id: x_1, where:.GlobalEnv, as: ref_1}"
    ref_1
  },
  ctx = ReactiveReferenceYamlContext.S3()  
)  
  
## Informal use (intended mainly for rapid prototyping) //
## Takes *any* object and simply changes the class attributes
ReactiveReferenceYamlParsed.S3(
  list(
    yaml = yaml$yaml,
    yaml_parsed = list(
      id = "x_1", 
      where = as.name("where"), 
      as = as.name("ref_1"),
      index = 2
    ),
    index = yaml$index,
    src = yaml$src
  )
)  
ReactiveReferenceYamlParsed.S3(TRUE)  

## Formal use (explicitly using 'fields') //
res <- ReactiveReferenceYamlParsed.S3()
ls(res)
res <- ReactiveReferenceYamlParsed.S3(
  yaml = yaml$yaml,
  yaml_parsed = list(
    id = "x_1", 
    where = as.name("where"), 
    as = as.name("ref_1"),
    index = 2
  ),
  index = yaml$index,
  src = yaml$src
)
res$yaml
res$yaml_parsed
res$index
res$src

## Recommended: include namespace //
## Regardless if you plan on using this class in an informal or formal way
fromyaml::ReactiveReferenceYamlParsed.S3()

}
