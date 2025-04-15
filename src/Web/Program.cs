using Microsoft.Data.SqlClient;

var builder = WebApplication.CreateBuilder(args);

builder.AddServiceDefaults();
builder.AddSqlServerClient(connectionName: "database");
if (!builder.Environment.IsDevelopment())
{
    builder
        .Configuration
        .AddAzureKeyVaultSecrets(connectionName: "key-vault");
}

var app = builder.Build();

app.MapDefaultEndpoints();

app.MapGet("/", () => "Hello World!");

app.MapGet("/test", (SqlConnection sql) => {
    return Results.Ok(sql.State);
});

app.Run();
