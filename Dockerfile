FROM mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim AS base
WORKDIR /app
EXPOSE 80

ENV ASPNETCORE_URLS=http://+:80

FROM mcr.microsoft.com/dotnet/sdk:5.0-focal AS build
WORKDIR /src
COPY ["DockerAPI.csproj", "./"]
RUN dotnet restore "DockerAPI.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "DockerAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DockerAPI.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DockerAPI.dll"]
