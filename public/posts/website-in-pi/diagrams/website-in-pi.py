from diagrams import Cluster, Diagram
from diagrams.aws.compute import EC2
from diagrams.aws.database import RDS
from diagrams.aws.network import ELB
from diagrams.gcp.network import DNS
from diagrams.azure.network import DNSZones
from diagrams.aws.compute import LambdaFunction
from diagrams.azure.compute import VMLinux
from diagrams.aws.database import RDSPostgresqlInstance
from diagrams.aws.storage import SimpleStorageServiceS3Bucket


with Diagram("tanggalnya.com architecture", show=True):
    with Cluster("Services"):
        svc_group = [
            VMLinux("Vultr Classic VM"),
            VMLinux("Orange Pi 5"),
            VMLinux("Orange Pi 5"),
            VMLinux("Raspberry Pi 4"),
            VMLinux("Raspberry Pi 4"),
        ]

    DNSZones("Cloudflare") >> LambdaFunction("Cloudflare Workers") >> svc_group
    svc_group >> RDSPostgresqlInstance("Vultr Classic VM")
    svc_group >> SimpleStorageServiceS3Bucket("storj.io")
