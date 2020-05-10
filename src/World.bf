using SDL2;

namespace BeefGrunio
{
	class World
	{
		public void Draw()
		{
			Image image = gGameApp.HardMode ? Images.World2 : Images.World1;

			SDL.Rect srcRect = .(0, 0, image.mSurface.w, image.mSurface.h);
			SDL.Rect destRect = .(0, 80, image.mSurface.w * 13, image.mSurface.h * 13);

			SDL.RenderCopy(gGameApp.mRenderer, image.mTexture, &srcRect, &destRect);
		}
	}
}
