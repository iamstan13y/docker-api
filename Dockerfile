#Get the base SDK from Microsoft
FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build-env
WORKDIR /app

#Copy the CSPROJ file and restore any dependencies (via NuGet)
COPY *.csproj ./
RUN dotnet restore

#Copy the project files and build our release
COPY . ./
RUN dotnet publish -c Release -o out

#Generate runtime image
FROM mcr.microsoft.com/dotnet/core/sdk:2.2
WORKDIR /app
EXPOSE 80
COPY --from=build-env /app/out .
ENTRYPOINT [ "dotnet", "DockerAPI.dll"]