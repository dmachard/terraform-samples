
provider "http" {
}

variable "post_title" {
  type    = string
  default ="Post 1"
}

# http get
data "http" "get_posts" {
  url = "http://my-json-server.typicode.com/typicode/demo/posts?title=${urlencode(var.post_title)}"
}

locals {
  postid = jsondecode(data.http.get_posts.body)[0].id
}


# second http get with local variable reused
data "http" "get_comments" {
  url = "http://my-json-server.typicode.com/typicode/demo/comments?postId=${local.postid}"

   depends_on = [ data.http.get_posts ]
}


//  return comment as output
output "comment" {
    value = jsondecode(data.http.get_comments.body)[0].body
}
