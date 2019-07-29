FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY mvcmovie/*.csproj ./mvcmovie/
RUN dotnet restore

# copy everything else and build app
COPY mvcmovie/. ./mvcmovie/
WORKDIR /app/mvcmovie
RUN dotnet publish -o out /p:PublishWithAspNetCoreTargetManifest="false"

FROM microsoft/dotnet:2.2-runtime AS runtime
ENV ASPNETCORE_URLS http://*:5000 # <--- THIS LINE IS MISSING AND NEEDS ADDING!
WORKDIR /app
COPY --from=build /app/mvcmovie/out ./
ENTRYPOINT ["dotnet", "mvcmovie.dll"]