using SDL2;
using System;

namespace BeefGrunio
{
	class Carrot : Entity
	{
		const float CarrotSpeed = 4f;

		public bool IsWhite;

		Image image;
		bool isInitialized;

		public this()
		{
			posX = 999;
			posY = 999;
		}

		public void Start(int randomNumber, float position)
		{
			IsWhite = randomNumber > 5;
			image = IsWhite ? Images.White : Images.Orange;

			isInitialized = true;
			posX = position;
			posY = 0;
		}

		void Finish()
		{
			isInitialized = false;
			posX = -999;
			posY = -999;
		}

		public override void Draw()
		{
			if (!isInitialized) return;

			float x = posX;
			float y = posY;

			SDL.Rect srcRect = .(0, 0, image.mSurface.w, image.mSurface.h);
			SDL.Rect destRect = .((int32)x, (int32)y, image.mSurface.w * 10, image.mSurface.h * 10);
			SDL.RenderCopy(gGameApp.mRenderer, image.mTexture, &srcRect, &destRect);
		}

		public new void Update()
		{
			if (!isInitialized) return;

			posY = Math.Clamp(posY + CarrotSpeed, 10, gGameApp.mWidth - 10);

			// Detect collision with player and check if the player is a correct character.
			SDL.Rect playerBoundingBox = .(-60, -100, 180, 160);
			if (playerBoundingBox.Contains((.)(posX - gGameApp.ActivePlayer.posX), (.)(posY - gGameApp.ActivePlayer.posY)))
			{
				if (gGameApp.ActivePlayer.isDida && !IsWhite) return;
				if (!gGameApp.ActivePlayer.isDida && IsWhite) return;
				Finish();
				return;
			}

			if (IsOffscreen(16, 16))
			{
				gGameApp.ActivePlayer.Health--;
				Finish();
			}
		}
	}																									
}
