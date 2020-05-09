using SDL2;

namespace BeefGrunio
{
	class World
	{
		public void Draw()
		{
			Image image = Images.World1;

			SDL.Rect srcRect = .(0, 0, image.mSurface.w, image.mSurface.h);
			SDL.Rect destRect = .(0, 0, image.mSurface.w * 14, image.mSurface.h * 14);

			SDL.RenderCopy(gGameApp.mRenderer, image.mTexture, &srcRect, &destRect);
		}
	}
}
