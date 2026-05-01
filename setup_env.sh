#!/bin/bash

# DevOps Lab Environment Setup Script (Ubuntu Optimized)
# This script ensures Java 21, Maven 3.9+, Gradle 8.12, Jenkins, and Ansible are installed.

set -e

echo "------------------------------------------------"
echo "   DevOps Lab Environment Setup & Upgrade"
echo "------------------------------------------------"

# 1. OS Check
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" != "ubuntu" ]; then
        echo "[WARN] This script is optimized for Ubuntu. For $NAME, please install tools manually:"
        echo "- Java 21: https://adoptium.net/"
        echo "- Maven 3.9+: https://maven.apache.org/download.cgi"
        echo "- Gradle 8.12: https://gradle.org/install/"
        echo "- Jenkins: https://www.jenkins.io/doc/book/installing/"
        echo "- Ansible: https://docs.ansible.com/ansible/latest/installation_guide/index.html"
        exit 1
    fi
else
    echo "[ERROR] Could not detect OS. Please install requirements manually."
    exit 1
fi

echo "[INFO] Ubuntu detected. Proceeding with checks..."

# 2. Update package lists
sudo apt-get update -y

# 3. Java 21 Check/Install
if command -v java >/dev/null 2>&1; then
    JAVA_VER=$(java -version 2>&1 | head -n 1 | cut -d '"' -f 2 | cut -d '.' -f 1)
    if [ "$JAVA_VER" -lt 21 ]; then
        echo "[INFO] Upgrading Java to version 21..."
        sudo apt-get install -y openjdk-21-jdk
    else
        echo "[OK] Java 21+ already installed."
    fi
else
    echo "[INFO] Installing Java 21..."
    sudo apt-get install -y openjdk-21-jdk
fi

# 4. Maven 3.9+ Check/Install
INSTALL_MAVEN=false
if command -v mvn >/dev/null 2>&1; then
    MVN_VER=$(mvn -version | head -n 1 | cut -d ' ' -f 3)
    MVN_MAJOR=$(echo $MVN_VER | cut -d '.' -f 1)
    MVN_MINOR=$(echo $MVN_VER | cut -d '.' -f 2)
    if [ "$MVN_MAJOR" -lt 3 ] || ([ "$MVN_MAJOR" -eq 3 ] && [ "$MVN_MINOR" -lt 9 ]); then
        INSTALL_MAVEN=true
    else
        echo "[OK] Maven $MVN_VER already installed."
    fi
else
    INSTALL_MAVEN=true
fi

if [ "$INSTALL_MAVEN" = true ]; then
    echo "[INFO] Installing/Upgrading Maven to 3.9.9..."
    wget -q https://archive.apache.org/dist/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz -P /tmp
    sudo tar -xzf /tmp/apache-maven-3.9.9-bin.tar.gz -C /opt
    sudo ln -sf /opt/apache-maven-3.9.9/bin/mvn /usr/local/bin/mvn
    echo "[OK] Maven 3.9.9 installed to /usr/local/bin/mvn"
fi

# 5. Gradle 8.12 Check/Install
INSTALL_GRADLE=false
if command -v gradle >/dev/null 2>&1; then
    GRADLE_VER=$(gradle -v | grep 'Gradle' | cut -d ' ' -f 2)
    GRADLE_MAJOR=$(echo $GRADLE_VER | cut -d '.' -f 1)
    if [ "$GRADLE_MAJOR" -lt 8 ]; then
        INSTALL_GRADLE=true
    fi
else
    INSTALL_GRADLE=true
fi

if [ "$INSTALL_GRADLE" = true ]; then
    echo "[INFO] Installing/Upgrading Gradle to 8.12..."
    wget -q https://services.gradle.org/distributions/gradle-8.12-bin.zip -P /tmp
    sudo unzip -oq /tmp/gradle-8.12-bin.zip -d /opt
    sudo ln -sf /opt/gradle-8.12/bin/gradle /usr/local/bin/gradle
    echo "[OK] Gradle 8.12 installed to /usr/local/bin/gradle"
fi

# 6. Jenkins Check/Install
if ! command -v jenkins >/dev/null 2>&1; then
    echo "[INFO] Installing Jenkins..."
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install -y jenkins
    sudo systemctl enable jenkins
    sudo systemctl start jenkins
    echo "[OK] Jenkins installed and started."
else
    echo "[OK] Jenkins already installed."
fi

# 7. Ansible Check/Install
if ! command -v ansible >/dev/null 2>&1; then
    echo "[INFO] Installing Ansible..."
    sudo apt-get install -y ansible
    echo "[OK] Ansible installed."
else
    echo "[OK] Ansible already installed."
fi

echo "------------------------------------------------"
echo "   Setup Complete! Current Versions:"
echo "------------------------------------------------"
java -version 2>&1 | head -n 1
mvn -version | head -n 1
gradle -v | grep 'Gradle'
ansible --version | head -n 1
systemctl is-active jenkins
echo "------------------------------------------------"
