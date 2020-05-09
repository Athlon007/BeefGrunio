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

		public Player ActivePlayer;

		List <Entity> entities = new List<Entity>() ~ DeleteContainerAndItems!(_);
		List <Carrot> carrots = new List<Carrot>() ~ DeleteContainerAndItems!(_);

		bool isSwitchKeyDown;

		// Carrots data
		const float CarrotSpawnFrequency = 120;
		float currentSpawnerTimer;
		int lastCarrot;

		Random randomizer ~ delete _;

		public this()
		{
			gGameApp = this;

			skybox = new Skybox();
			world = new World();
			ActivePlayer = new Player();
			AddEntity(ActivePlayer);

			ActivePlayer.posX = gGameApp.mWidth / 2;
			ActivePlayer.posY = 550;

			randomizer = new Random(DateTime.Now.Millisecond);
			currentSpawnerTimer = CarrotSpawnFrequency;

			for (int i = 0; i <= 10; i++)
			{
				Carrot carrot = new Carrot();
				carrots.Add(carrot);
				entities.Add(carrot);
			}
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

			for (var carrot in carrots)
				carrot.Update();
		}

		void CarrotSpawner()
		{
			currentSpawnerTimer++;
			if (currentSpawnerTimer < CarrotSpawnFrequency)
				return;

			currentSpawnerTimer = 0;

			Carrot carrot = carrots[lastCarrot];
			carrot.Start(GetRandomNumber(), GetRandomPosition());

			lastCarrot++;
			if (lastCarrot > carrots.Count - 1)
				lastCarrot = 0;
		}

		int GetRandomNumber()
		{
			return randomizer.Next(0, 11);
		}

		float GetRandomPosition()
		{
			return (float)randomizer.Next(0, mWidth - 60);
		}
	}
}
