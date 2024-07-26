provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_deployment" "express_app" {
  metadata {
    name = "express-app"
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "express-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "express-app"
        }
      }
      spec {
        container {
          name  = "fetch-con-node-app"
          image = "strtwalker/bdiplus-demo-app:v1"
          port {
            container_port = 8080
          }
          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "0.1"
              memory = "256Mi"
            }
          }
          env {
            name = "PG_HOST"
            value_from {
              config_map_key_ref {
                name = "postgres-service-ip"
                key  = "PG_HOST"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "express_app_service" {
  metadata {
    name = "express-app-service"
  }
  spec {
    selector = {
      app = "express-app"
    }
    port {
      protocol = "TCP"
      port     = 8080
      target_port = 8080
    }
    type = "LoadBalancer"
  }
}

resource "kubernetes_deployment" "postgres_deployment" {
  metadata {
    name = "postgres-deployment"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "postgres"
      }
    }
    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }
      spec {
        container {
          name  = "postgres"
          image = "postgres:latest"
          port {
            container_port = 5432
          }
          resources {
            limits = {
              cpu    = "1.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "1"
              memory = "256Mi"
            }
          }
          env {
            name  = "POSTGRES_DB"
            value = "testdb"
          }
          env {
            name  = "POSTGRES_USER"
            value = "postgres"
          }
          env {
            name = "POSTGRES_PASSWORD"
            value = "postgres" 
            /* value_from {
              secret_key_ref {
                name = "postgres-credentials-secret"
                key  = "postgres-password"
              }
            }
            */
          }
        }
      }
    }
  }
}

# Get internal IP of the postgres service
data "kubernetes_service" "postgres_service" {
  metadata {
    name = kubernetes_service.postgres_nodeport.metadata.0.name
  }
  depends_on = [
    kubernetes_service.postgres_nodeport
  ]
}

# create a config map to store the IP of the postgres service
resource "kubernetes_config_map" "postgres_service_ip" {
  metadata {
    name = "postgres-service-ip"
  }
  data = {
    PG_HOST = data.kubernetes_service.postgres_service.spec.0.cluster_ip
  }
  depends_on = [
    kubernetes_deployment.postgres_deployment
  ]
}

resource "kubernetes_service" "postgres_nodeport" {
  metadata {
    name = "postgres-nodeport"
  }
  spec {
    type = "NodePort"
    port {
      port       = 5432
      target_port = 5432
      node_port  = 30007
    }
    selector = {
      app = "postgres"
    }
  }
}

resource "kubernetes_secret" "postgres_credentials_secret" {
  metadata {
    name = "postgres-credentials-secret"
  }
  data = {
    postgres-password = "cG9zdGdyZXM="  # base64-encoded value for "postgres"
  }
  type = "Opaque"
}

resource "kubernetes_deployment" "ui_app" {
  metadata {
    name = "ui-app"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "ui-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "ui-app"
        }
      }
      spec {
        container {
          name  = "ui-container"
          image = "strtwalker/bdiplus-demo-ui:v1"
          port {
            container_port = 3000
          }
          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "0.1"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "ui_app_service" {
  metadata {
    name = "ui-app-service"
  }
  spec {
    selector = {
      app = "ui-app"
    }
    port {
      protocol = "TCP"
      port     = 3000
      target_port = 3000
    }
    type = "LoadBalancer"
  }
}
