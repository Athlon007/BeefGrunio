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
		public Player ActivePlayer;

		bool isSwitchKeyDown;

		public this()
		{
			gGameApp = this;

			skybox = new Skybox();
			world = new World();
			ActivePlayer = new Player();
			AddEntity(ActivePlayer);

			ActivePlayer.posX = gGameApp.mWidth / 2;
			ActivePlayer.posY = 550;
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

			if (ActivePlayer.moveTime < Player.SprintDelay)
			{
				moveSpeed *= 0.5f;
			}

			if (IsKeyDown(.Left))
			{
				deltaX -= moveSpeed;
				ActivePlayer.isGoingLeft = true;
			}

			if (IsKeyDown(.Right) && !ActivePlayer.IsTouchingRightSide())
			{
				deltaX += moveSpeed;
				ActivePlayer.isGoingLeft = false;
			}

			if (deltaX != 0)
			{
				ActivePlayer.posX = Math.Clamp(ActivePlayer.posX + deltaX, 10, mWidth - 10);
				ActivePlayer.isMoving = true;
				ActivePlayer.moveTime += 1;
			}
			else
			{
				ActivePlayer.isMoving = false;
				ActivePlayer.moveTime = 0;
			}

			// Switch
			if (IsKeyDown(.Space) && !isSwitchKeyDown)
			{
				ActivePlayer.isDida ^= true;
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

			// Sky box movement
			skybox.posX -= Math.Clamp(skybox.posX - Skybox.SkyboxSpeed, 2, mWidth - 10);
			HandleInputs();
			CarrotSpawner();		
		}

		void CarrotSpawner()
		{

		}
	}
}
