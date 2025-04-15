namespace LegacyAppAspire.AppHost;
public static class Extensions
{
    public static T Tap<T>(this T self, Func<T,T> f)
     => f(self);   
    
}
