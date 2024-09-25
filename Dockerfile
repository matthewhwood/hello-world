FROM mcr.microsoft.com/dotnet/sdk:8.0@sha256:35792ea4ad1db051981f62b313f1be3b46b1f45cadbaa3c288cd0d3056eefb83 AS build-env

WORKDIR /app

# copy everything into 'app'
COPY . ./

# restore as distinct layers
RUN dotnet restore

# build and publish a release to './app/out'
RUN dotnet publish -c Release -o out

# build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0@sha256:6c4df091e4e531bb93bdbfe7e7f0998e7ced344f54426b7e874116a3dc3233ff

# set the working directory
WORKDIR /app

# copy everything from './app/out' into 'app' within the runtime image
COPY --from=build-env /app/out .

# run the code
ENTRYPOINT ["dotnet", "hello-world.dll"]