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
		Skybox skybox ~ delete _;
		World world ~ delete _;

		List <Entity> entities = new List<Entity>() ~ DeleteContainerAndItems!(_);
		Player player;

		bool isSwitchKeyDown;

		public this()
		{
			gGameApp = this;

			skybox = new Skybox();
			world = new World();
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
			skybox.Draw();
			world.Draw();

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

			if (IsKeyDown(.Right) && !player.IsTouchingRightSide())
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

			// Sky box movement
			skybox.posX -= Math.Clamp(skybox.posX - Skybox.SkyboxSpeed, 2, mWidth - 10);
		}
	}
}
