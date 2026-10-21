job "hubspot" {
  datacenters = ["dc1"]
  type        = "service"

  group "app" {
    count = 1

    network {
      mode = "host"
      port "http" { static = 5104 }
    }

    service {
      name     = "hubspot"
      port     = "http"
      provider = "consul"
      check {
        type     = "http"
        path     = "/scan/health"
        interval = "30s"
        timeout  = "10s"
      }
    }

    task "app" {
      driver = "docker"
      config {
        image        = "hubspot-company:staging"
        network_mode = "host"
      }
      env {
        FLASK_ENV    = "staging"
        PORT         = "5104"
        DATABASE_URL = "postgresql://user:password@localhost:5432/hubspot_db"
      }
      resources {
        cpu    = 1500
        memory = 768
      }
    }
  }
}
