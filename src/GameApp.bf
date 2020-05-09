using System;
using SDL2;
using System.Collections;

namespace BeefGrunio
{
	static
	{
		public static GameApp gGameApp;
	}

	class GameApp : SDLApp
	{
		List <Entity> entities = new List<Entity>() ~ DeleteContainerAndItems!(_);
		Player player;

		bool isSwitchKeyDown;

		public this()
		{
			gGameApp = this;

			player = new Player();
			AddEntity(player);

			player.posX = gGameApp.mWidth / 2;
			player.posY = 550;
		}

		public ~this()
		{
			Images.Dispose();
		}

		public new void Init()
		{
			base.Init();
			Images.Init();
		}

		public override void Draw()
		{
			Draw(Images.Sky, 0, 0);
			Draw(Images.World1, 0, 0);

			for (var entity in entities)
				entity.Draw();
		}

		void AddEntity(Entity e)
		{
			entities.Add(e);
		}

		void HandleInputs()
		{
			// Left-right movement
			float deltaX = 0;
			float moveSpeed = Player.MoveSpeed;

			if (player.moveTime < Player.SprintDelay)
			{
				moveSpeed *= 0.5f;
			}

			if (IsKeyDown(.Left))
			{
				deltaX -= moveSpeed;
				player.isGoingLeft = true;
			}

			if (IsKeyDown(.Right) && !player.IsOffscreen(-150,0))
			{
				deltaX += moveSpeed;
				player.isGoingLeft = false;
			}

			if (deltaX != 0)
			{
				player.posX = Math.Clamp(player.posX + deltaX, 10, mWidth - 10);
				player.isMoving = true;
				player.moveTime += 1;
			}
			else
			{
				player.isMoving = false;
				player.moveTime = 0;
			}

			// Switch
			if (IsKeyDown(.Space) && !isSwitchKeyDown)
			{
				player.isDida ^= true;
				isSwitchKeyDown = true;
			}

			if (!IsKeyDown(.Space))
			{
				isSwitchKeyDown = false;
			}
		}

		public override void Update()
		{
			base.Update();

			HandleInputs();
		}
	}
}
