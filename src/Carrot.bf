using SDL2;

namespace BeefGrunio
{
	class Carrot : Entity
	{
		public override void Update()
		{
			SDL.Rect heroBoundingBox = .(-30, -30, 60, 60);
			if (heroBoundingBox.Contains((.)(posX - gGameApp.ActivePlayer.posX), (.)(posY - gGameApp.ActivePlayer.posY)))
			{
				gGameApp.ActivePlayer.Health--;
			}
		}
	}																									
}
