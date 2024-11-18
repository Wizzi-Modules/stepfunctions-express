module "test" {
  source = "../"

  name_prefix = "test"
  environment = "test"
  folder = "sfn"

  definition_file = "rag-genai.asl.json"
  definition_variables = {
    KnowledgeBaseId = "L14I64ZGYG"
  }
}