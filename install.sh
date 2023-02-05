rm -rf /etc/systemd/system/cri-docker.service 
rm -rf /etc/systemd/system/cri-docker.socket 
rm -rf cri-dockerd
sudo apt install snapd -y
sudo snap install go --classic
systemctl enable --now snapd
git clone https://github.com/Mirantis/cri-dockerd.git
cd cri-dockerd && mkdir bin && go build -o bin/cri-dockerd
mkdir -p /usr/local/bin
install -o root -g root -m 0755 bin/cri-dockerd /usr/local/bin/cri-dockerd
cp -a packaging/systemd/* /etc/systemd/system
sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
systemctl daemon-reload
systemctl enable --now cri-docker.service
systemctl enable --now cri-docker.socket