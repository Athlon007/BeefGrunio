namespace BeefGrunio
{
	class Program
	{
		public static void Main()
		{
			let gameApp = scope GameApp();
			gameApp.Init();
			gameApp.Run();
		}
	}
}
