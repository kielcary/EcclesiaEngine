FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY EcclesiaEngine/*.csproj ./EcclesiaEngine/
RUN dotnet restore

# copy everything else and build app
COPY EcclesiaEngine/. ./EcclesiaEngine/
WORKDIR /app/EcclesiaEngine
RUN dotnet publish -c Release -o out


FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS runtime
ENV ASPNETCORE_URLS http://*:5000
WORKDIR /app
COPY --from=build /app/EcclesiaEngine/out ./
ENTRYPOINT ["dotnet", "EcclesiaEngine.dll"]