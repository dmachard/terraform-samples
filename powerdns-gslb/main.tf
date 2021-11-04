terraform {
  required_providers {
    powerdns-gslb = {
      source = "dmachard/powerdns-gslb"
      version = "1.3.1"
    }
  }
}

provider "powerdns-gslb" {
    server        = "10.0.0.210"
    key_name      = "test."
    key_algo      = "hmac-sha256"
    key_secret    = "SxEKov9vWTM+c7k9G6ho5nK.....n5nND5BOHzE6ybvy0+dw=="
}

resource "powerdns-gslb_lua" "svc1" {
  zone = "home.internal."
  name = "test_lua"
  record {
    rrtype = "A"
    ttl = 5
    snippet = "ifportup(8082, {'10.0.0.1', '10.0.0.2'})"
  }
}

resource "powerdns-gslb_lua" "svc2" {
  zone = "test.internal."
  name = "pdnslua"
  record {
    rrtype = "A"
    ttl = 5
    snippet = "ifurlup('https://httpbin.org/status/200', {{'54.91.118.50'}})"
  }
}

resource "powerdns-gslb_pickrandom" "foo" {
  zone = "home.internal."
  name = "test_pickrandom"
  record {
    rrtype = "A"
    ttl = 5
    addresses = [ 
      "127.0.0.1",
      "127.0.0.2",
    ]
  }
}
