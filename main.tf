provider "docker" {
    host = "unix:///var/run/docker.sock"
}

resource "docker_container" "elasticsearch-dock" {
    name    = "elasticsearch-dock"
    image   = "elasticsearch:7.6.0"
    ports {
        internal  = 9200
        external  = 9200
    }
    ports {
        internal  = 9300
        external  = 9300
    }
    volumes {
        container_path  = "/usr/share/elasticsearch/data"
        host_path       = var.local_path
    }
    env   = ["discovery.type=single-node"]
    start = true
}

resource "docker_container" "kibana-dock" {
    name    = "kibana-dock"
    image   = "kibana:7.6.0"
    ports {
        internal  = 5601
        external  = 5601
    }
    links   = [join(":", [docker_container.elasticsearch-dock.hostname, "elasticsearch"])]
    //links   = [docker_container.elasticsearch-dock.hostname]
    start = true
}

variable "local_path" {
    description = "Local path to send data to.."
}

