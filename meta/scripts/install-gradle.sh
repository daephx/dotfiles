sudo sh -c 'apt update && apt install openjdk-17-jdk'

VERSION=8.1.1
wget https://services.gradle.org/distributions/gradle-${VERSION}-bin.zip -P /tmp
sudo unzip -d /opt/gradle /tmp/gradle-${VERSION}-bin.zip
sudo ln -s /opt/gradle/gradle-${VERSION} /opt/gradle/latest

# Write gradle env config to /etc/profile.d
sudo tee -a /etc/profile.d/gradle.sh &> /dev/null << EOF
export GRADLE_HOME=/opt/gradle/latest
export PATH=\${GRADLE_HOME}/bin:\${PATH}
EOF

sudo chmod +x /etc/profile.d/gradle.sh

source /etc/profile.d/gradle.sh

if [ "$(gradle -v | sed -ne 's/Gradle //p')" = "$VERSION" ]; then
  echo "Gradle has successfully been installed!"
fi
