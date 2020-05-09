using SDL2;
using System;

namespace BeefGrunio
{
	class Skybox
	{
		public const float SkyboxSpeed = 2;

		public float posX;

		public ~this()
		{
			posX = 0;
		}

		public void Draw()
		{
			float x = posX;
			Image image = Images.Sky;

			SDL.Rect srcRect = .(0, 0, image.mSurface.w, image.mSurface.h);
			SDL.Rect destRect = .((int32)x, 0, image.mSurface.w * 14, image.mSurface.h * 14);

			SDL.RenderCopy(gGameApp.mRenderer, image.mTexture, &srcRect, &destRect);

			if (x - gGameApp.mScreen.w <= image.mSurface.w * -14)
			{
				posX = 0;
			}
		}
	}
}
