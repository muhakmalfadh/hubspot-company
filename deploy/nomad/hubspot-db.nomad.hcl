job "hubspot-db" {
  datacenters = ["dc1"]
  type        = "service"

  group "db" {
    network {
      mode = "host"
      port "pg" { static = 5432 }
    }

    service {
      name     = "hubspot-db"
      port     = "pg"
      provider = "consul"
      check {
        type     = "tcp"
        interval = "10s"
        timeout  = "3s"
      }
    }

    task "postgres" {
      driver = "docker"
      config {
        image        = "postgres:15-alpine"
        network_mode = "host"
      }
      env {
        POSTGRES_USER     = "user"
        POSTGRES_PASSWORD = "password"
        POSTGRES_DB       = "hubspot_db"
      }
      resources {
        cpu    = 500
        memory = 512
      }
    }
  }
}
