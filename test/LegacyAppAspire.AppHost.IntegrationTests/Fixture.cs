namespace LegacyAppAspire.AppHost.IntegrationTests;

public class Fixture
{
    public async Task Test(Func<HttpClient, Task> f)
    {
        // Arrange
        var appHost = await DistributedApplicationTestingBuilder.CreateAsync<Projects.LegacyAppAspire_AppHost>();
        appHost.Services.ConfigureHttpClientDefaults(clientBuilder =>
        {
            clientBuilder.AddStandardResilienceHandler();
        });
        // To output logs to the xUnit.net ITestOutputHelper, consider adding a package from https://www.nuget.org/packages?q=xunit+logging

        await using var app = await appHost.BuildAsync();
        var resourceNotificationService = app.Services.GetRequiredService<ResourceNotificationService>();
        await app.StartAsync();

        // Act
        var httpClient = app.CreateHttpClient("web");
        await resourceNotificationService.WaitForResourceAsync("web", KnownResourceStates.Running).WaitAsync(TimeSpan.FromSeconds(30));

        // Assert
        await f(httpClient);
    }
}
