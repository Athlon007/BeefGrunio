using SDL2;

namespace BeefGrunio
{
	class Player : Entity
	{
		public const float MoveSpeed = 4f;
		public const int AnimationSpeed = 8;
		public const float SprintDelay = 16;

		public bool isMoving;
		public bool isGoingLeft;
		public bool isDida;

		public float moveTime;

		float framesCount;

		public override void Draw()
		{
			if (!isMoving)
			{
				framesCount = 0;
			}
			else
			{
				framesCount +=1;
				if (framesCount >= AnimationSpeed)
					framesCount = 0;
			}

			float x = posX;
			float y = posY;
			Image image = ?;

			if (isDida)
			{
				if (isGoingLeft)
				{
					int frame = framesCount <= AnimationSpeed / 2 ? 0 : 1;
					image = Images.DidaL[frame];
				}
				else
				{
					int frame = framesCount <= AnimationSpeed / 2 ? 0 : 1;
					image = Images.Dida[frame];
				}
			}
			else
			{
				if (isGoingLeft)
				{
					int frame = framesCount <= AnimationSpeed / 2 ? 0 : 1;
					image = Images.GrunioL[frame];
				}
				else
				{
					int frame = framesCount <= AnimationSpeed / 2 ? 0 : 1;
					image = Images.Grunio[frame];
				}
			}

			SDL.Rect srcRect = .(0, 0, image.mSurface.w, image.mSurface.h);
			SDL.Rect destRect = .((int32)x, (int32)y, image.mSurface.w * 10, image.mSurface.h * 10);
			if (isMoving)
			{
				int32 inset = (.)(srcRect.w * 0.09f);
				destRect.x += inset;
				destRect.w -= inset * 2;
			}

			SDL.RenderCopy(gGameApp.mRenderer, image.mTexture, &srcRect, &destRect);
		}
	}
}
