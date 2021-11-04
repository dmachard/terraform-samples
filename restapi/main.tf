
terraform {
  required_providers {
    restapi = {
      source = "github.com/mastercard/restapi"
      version = "1.15.0"
    }
  }
}

provider "restapi" {
  uri                  = "https://reqres.in/"
  debug                = true
  write_returns_object = true
}

data "restapi_object" "Janet" {
  path = "/api/users"
  results_key = "data"
  search_key = "id"
  search_value = "2"
}


output "last_name" {
    value = jsondecode(data.restapi_object.Janet.api_response).data.last_name
}

resource "restapi_object" "Foo" {
  path = "/api/users"
  data = "{ \"name\": \"Denis\", \"job\": \"God\" }"

  depends_on = [ data.restapi_object.Janet ]
}

output "new_id" {
    value = jsondecode(restapi_object.Foo.api_response).id
}
