# The goal of this dockerfile is to reproduce an environment where the code build succeeds 
# but the source generators fail to load with the CS8032 warning.
# In order to reproduce the environment where CS8032 is shown...
# change the image base from "mcr.microsoft.com/dotnet/sdk:5.0.400" to "mcr.microsoft.com/dotnet/sdk:5.0.200" which is an SDK that 
# doesn't have available Microsoft.CodeAnalysis, Version=3.11.0.0 (required by NSB) 
# nor Microsoft.CodeAnalysis version 3.10 required by NServiceBus.AzureFunctions.Worker.ServiceBus.

# The sample project references NServiceBus.AzureFunctions.Worker.ServiceBus Version 2.0.3-beta.1 which is a package modified
# to make CS8032 warning be treated as an error by the project referencing. 
# This dockerfile also tries to demonstrate that treating that specific code as error is working.

FROM mcr.microsoft.com/dotnet/sdk:5.0.400

USER root

# COPY THE CONTENT WE WANT TO USE AS OUR NUGET SOURCE
COPY lib /lib

# COPY THE SOURCE CODE OF THE Azure Functions Worker PROJECT. Notice it has a package.json file with the custom nuget source.
COPY service-bus-worker_asbfunctionsworker_3/ /src
COPY nuget.config /src

WORKDIR /src
# listing the nuget package sources to see in the output the proof our custom package source is being used. So 
RUN dotnet nuget list source 
RUN dotnet restore

# The following COPY and RUN statements are only required
# when using the base image for SDK 5.0.400 or higher in order to see a succesfull build. NSB 7 requires SDK 3.1 to be present.
# If you are testing with a base iamge version lower than 5.0.400, remove these lines for speed, 
# as there is no need to have the SDK installed since the build will fail treating CS8032 warning as error.
COPY InstallSDK3.1.sh ./
RUN ./InstallSDK3.1.sh

RUN dotnet build -c Release -o /app/build
