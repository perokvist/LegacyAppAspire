using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Diagnostics.HealthChecks;

var builder = WebApplication.CreateBuilder(args);

builder.AddServiceDefaults();

if (!builder.Environment.IsDevelopment())
    builder.Configuration.AddAzureKeyVaultSecrets(connectionName: "key-vault");
else
    builder.Configuration.AddUserSecrets<Program>();

builder.AddSqlServerClient(connectionName: "database");

builder.Services
    .AddHealthChecks()
    .AddCheck("test", () => HealthCheckResult.Healthy("ok"));

var app = builder.Build();

app.MapDefaultEndpoints();

app.MapGet("/", () => "Hello World!");

app.MapGet("/test", (SqlConnection sql) => {
    return Results.Ok(sql.State);
});

app.Run();
