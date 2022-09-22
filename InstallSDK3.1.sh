# Install dependencies 
apt-get install wget &&
wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb &&
dpkg -i packages-microsoft-prod.deb

# Install .NET SDK 3.1
apt-get update && 
apt-get install -y apt-transport-https &&
apt-get update &&
apt-get install -y dotnet-sdk-3.1 &&
dotnet --version 