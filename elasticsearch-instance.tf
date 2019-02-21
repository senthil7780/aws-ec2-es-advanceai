resource "aws_instance" "elasticsearch_instance" {
  ami           = "ami-04677bdaa3c2b6e24"
  instance_type = "${var.aws_instance_type}"
  key_name =  "${var.ami_key_pair_name}"
  security_groups = ["${aws_security_group.elasticsearch_cluster_sg.name}"]
  iam_instance_profile = "${aws_iam_instance_profile.elasticsearch_profile.name}"
  user_data = "${file("elasticsearch-node-setup.sh")}"
  count = "1"

  tags {
    Name = "elasticsearch_cluster_${count.index}"
  }
}