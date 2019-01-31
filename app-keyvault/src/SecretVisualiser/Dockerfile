FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY ["SecretVisualiser/SecretVisualiser.csproj", "SecretVisualiser/"]
RUN dotnet restore "SecretVisualiser/SecretVisualiser.csproj"
COPY . .
WORKDIR "/src/SecretVisualiser"
RUN dotnet build "SecretVisualiser.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "SecretVisualiser.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "SecretVisualiser.dll"]