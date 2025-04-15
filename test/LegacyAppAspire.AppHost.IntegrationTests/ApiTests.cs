namespace LegacyAppAspire.AppHost.IntegrationTests;
public class ApiTests(Fixture fixture) : IClassFixture<Fixture>
{
    [Fact]
    public Task GetWebResourceRootReturnsOkStatusCode()
      => fixture.Test(async http =>
      {
          var response = await http.GetAsync("/test");

          Assert.Equal(HttpStatusCode.OK, response.StatusCode);
      });
}
