FROM mcr.microsoft.com/dotnet/core/sdk
COPY ./PublishOutput/ /app/
EXPOSE 80 8080 5000
WORKDIR /app
ENTRYPOINT ["dotnet", "pipelines-dotnet-core.dll"]
