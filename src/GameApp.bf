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
		int score;
		public int Score
		{
			get
			{
				return score;
			}
			set
			{
				score = value;

				if (score > 2)
				{
					HardMode = true;
				}
			}
		}
		public bool HardMode;


		List <Entity> entities = new List<Entity>() ~ DeleteContainerAndItems!(_);
		List <Carrot> carrots = new List<Carrot>() ~ DeleteContainerAndItems!(_);

		bool isSwitchKeyDown;

		// Carrots data
		const float CarrotSpawnFrequency = 120;
		float currentSpawnerTimer;
		int lastCarrot;

		Random randomizer ~ delete _;

		Font font ~ delete _;

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
			font = new Font();
			font.Load("font.ttf", 24);
		}

		public enum TextAlign { Left, Center, Right };
		public void DrawString(float x, float y, String str, SDL.Color color, TextAlign align = TextAlign.Left)
		{
			var x;

			SDL.SetRenderDrawColor(mRenderer, 255, 255, 255, 255);
			let surface = SDLTTF.RenderUTF8_Blended(font.mFont, str, color);
			let texture = SDL.CreateTextureFromSurface(mRenderer, surface);
			SDL.Rect srcRect = .(0, 0, surface.w, surface.h);

			if (align != TextAlign.Left)
			{
				if (align == TextAlign.Center)
					x -= surface.w / 2;
				else if (align == TextAlign.Right && str.Length > 1)
					x -= 25 * str.Length;
			}

			SDL.Rect destRect = .((int32)x, (int32)y, surface.w * 2, surface.h * 2);
			SDL.RenderCopy(mRenderer, texture, &srcRect, &destRect);
			SDL.FreeSurface(surface);
			SDL.DestroyTexture(texture);
		}

		public void DrawHUD()
		{
			// Black background
			SDL.SetRenderDrawColor(mRenderer, 0, 0, 0, 0);
			SDL.Rect blackRect = .(0, 0, mWidth, 64);
			SDL.RenderFillRect(mRenderer, &blackRect);
			// White strip
			SDL.SetRenderDrawColor(mRenderer, 255, 255, 255, 255);
			SDL.Rect whiteRect = .(0, blackRect.h, mWidth, 8);
			SDL.RenderFillRect(mRenderer, &whiteRect);

			// Drawing hearts
			int hearts = ActivePlayer.Health;
			Image image = Images.Heart;

			for (int i = 0; i < hearts; i++)
			{
				float x = 8 + i * 54;
				float y = 8;
	
				SDL.Rect srcRect = .(0, 0, image.mSurface.w, image.mSurface.h);
				SDL.Rect destRect = .((int32)x, (int32)y, image.mSurface.w * 9, image.mSurface.h * 9);
				SDL.RenderCopy(gGameApp.mRenderer, image.mTexture, &srcRect, &destRect);
			}

			// Score
			float scoreX = gGameApp.mWidth - 50;
			float scoreY = 8;
			SDL.Color color = .(255, 255 ,255 , 255);
			DrawString(scoreX, scoreY, scope String()..AppendF("{}", Score), color, TextAlign.Right);
		}

		public override void Draw()
		{
			skybox.Draw();
			world.Draw();

			for (var entity in entities)
				entity.Draw();

			DrawHUD();
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
			skybox.posX -= Math.Clamp(skybox.posX - Skybox.SkyboxSpeed, 1, mWidth - 10);
			HandleInputs();

			CarrotSpawner();
			for (var carrot in carrots)
				carrot.Update();
		}

		void CarrotSpawner()
		{
			float spawnFrequency = CarrotSpawnFrequency;
			if (HardMode)
				spawnFrequency /= 2;

			currentSpawnerTimer++;
			if (currentSpawnerTimer < spawnFrequency)
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
