using LegacyAppAspire.AppHost;
using Microsoft.Extensions.Hosting;

var builder = DistributedApplication.CreateBuilder(args);

builder.AddDockerComposePublisher();

Func<IResourceBuilder<ProjectResource>, IResourceBuilder<ProjectResource>> azureActions = x => x;

if (!builder.Environment.IsDevelopment())
{
    var keyVault = builder
        .AddAzureKeyVault("key-vault");
        //.AddConnectionString("key-vault");

    var insights = builder.ExecutionContext.IsPublishMode
        ? builder.AddAzureApplicationInsights("AppInsights")
        : builder.AddConnectionString("AppInsights", "APPLICATIONINSIGHTS_CONNECTION_STRING");

    azureActions = x => x
        .WithReference(keyVault)
        .WithReference(insights);
}

var sql = builder
    .AddSqlServer("sql")
    .WithLifetime(ContainerLifetime.Persistent);

var db = sql.AddDatabase("database");

builder.AddProject<Projects.Web>("web")
       //.PublishAsDockerFile()
       .Tap(azureActions)
       .WithHttpHealthCheck("/health")
       .WithReference(db)
       .WaitFor(db);

builder.Build().Run();
