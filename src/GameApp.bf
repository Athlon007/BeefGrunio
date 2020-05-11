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
		// Game management
		public enum GameStates { Title, Menu, Game, Score, Credits };
		public GameStates ActiveState = GameStates.Title;

		// Main Menu
		const int32 maxMenuValue = 2;
		int32 activeOption;
		int32 ActiveOption
		{
			get
			{
				return activeOption;
			}
			set
			{
				activeOption = value;
				if (activeOption > maxMenuValue)
					activeOption = 0;

				if (activeOption < 0)
					activeOption = maxMenuValue;
			}
		}
		bool isMoveKeyHeld;
		const int CreditsAnimationSpeed = 128;
		int creditsFramesCount;
		const int ScoreAnimationSpeed = 60;
		int scoreFramesCount;

		// World
		Skybox skybox ~ delete _;
		World world ~ delete _;

		// Score
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

				if (score >= 50)
				{
					HardMode = true;
				}
			}
		}

		public bool HardMode;


		// Entities
		public Player ActivePlayer;
		bool isSwitchKeyDown;
		List <Entity> entities = new List<Entity>() ~ DeleteContainerAndItems!(_);
		List <Carrot> carrots = new List<Carrot>() ~ DeleteContainerAndItems!(_);

		// Carrots data
		const float CarrotSpawnFrequency = 120;
		float currentSpawnerTimer;
		int lastCarrot;

		// Misc
		Random randomizer ~ delete _;
		Font font ~ delete _;

		public this()
		{
			gGameApp = this;
		}

		public ~this()
		{
			Images.Dispose();
			Sounds.Dispose();
		 	ClearAndDeleteItems(carrots);
		}

		public new void Init()
		{
			base.Init();
			Images.Init();
			Sounds.Init();
			font = new Font();
			font.Load("font.ttf", 24);
			skybox = new Skybox();
			world = new World();
			randomizer = new Random(DateTime.Now.Millisecond);

			ActivePlayer = new Player();
			AddEntity(ActivePlayer);

			for (int i = 0; i <= 3; i++)
			{
				Carrot carrot = new Carrot();
				carrots.Add(carrot);
				entities.Add(carrot);
			}
		}

		void LoadMenu()
		{
			SDLMixer.PauseMusic();
			SDLMixer.PlayMusic(Sounds.Menu, -1);
			ActiveState = GameStates.Menu;
			ActiveOption = 0;
		}

		void LoadCredits()
		{
			creditsFramesCount = 0;
			ActiveState = GameStates.Credits;
			ClearAndDeleteItems(carrots);
		}

		void LoadGame()
		{
			HardMode = false;
			score = 0;

			ActivePlayer.Init();

			currentSpawnerTimer = CarrotSpawnFrequency;
			ActiveState = GameStates.Game;
		}

		public void GameOver()
		{
			scoreFramesCount = 0;
			ActiveState = GameStates.Score;
			SDLMixer.PauseMusic();
			SDLMixer.PlayMusic(Sounds.GameOver, 0);

			for (var carrot in carrots)
				carrot.Init();
		}

		public enum TextAlign { Left, Center, Right };
		public void DrawString(float x, float y, String str, SDL.Color color, int32 fontScale, TextAlign align = TextAlign.Left)
		{
			var x;

			SDL.SetRenderDrawColor(mRenderer, 255, 255, 255, 255);
			let surface = SDLTTF.RenderUTF8_Blended(font.mFont, str, color);
			let texture = SDL.CreateTextureFromSurface(mRenderer, surface);
			SDL.Rect srcRect = .(0, 0, surface.w, surface.h);

			if (align != TextAlign.Left)
			{
				if (align == TextAlign.Center)
					x -= surface.w / 2 * fontScale;
				else if (align == TextAlign.Right && str.Length > 1)
					x -= 25 * str.Length;
			}

			SDL.Rect destRect = .((int32)x, (int32)y, surface.w * fontScale, surface.h * fontScale);
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
			float scoreX = mWidth - 50;
			float scoreY = 8;
			SDL.Color color = .(255, 255, 255, 255);
			DrawString(scoreX, scoreY, scope String()..AppendF("{}", Score), color, 2, TextAlign.Right);
		}

		void DrawMenu()
		{
			SDL.Color color = .(0, 0, 0, 255);
			DrawString(mWidth / 2 + 10, 50, "GRUNIOŻERCA", color, 3, TextAlign.Center);
			DrawString(925, 125, "BEEF Edition", color, 1, TextAlign.Right);
			DrawString(mWidth / 2 + 10, 200, "START", color, 2, TextAlign.Center);
			DrawString(mWidth / 2 + 10, 350, "CREDITS", color, 2, TextAlign.Center);
			DrawString(mWidth / 2 + 10, 500, "EXIT", color, 2, TextAlign.Center);

			// Tip
			DrawString(mWidth / 2 + 10, 600, "Up/Down - Navigate", color, 1, TextAlign.Center);
			DrawString(mWidth / 2 + 10, 630, "Space - Accept", color, 1, TextAlign.Center);

			// Credits
			DrawString(30, mHeight - 50, "Copyright © Athlon 2020", color, 1);

			DrawString(mWidth - 50, mHeight - 50, "1.0", color, 1, TextAlign.Right);

			// Draw indicator															  .
		 	Image image = Images.Grunio[0];
			SDL.Rect srcRect = .(0, 0, image.mSurface.w, image.mSurface.h);
			SDL.Rect destRect = .(250, 200 + 150 * ActiveOption, image.mSurface.w * 5, image.mSurface.h * 5);
			SDL.RenderCopy(mRenderer, image.mTexture, &srcRect, &destRect);
		}

		void DrawCredits()
		{
			Image title = Images.Credits;
			SDL.Rect srcRect = .(0, 0, title.mSurface.w, title.mSurface.h);
			SDL.Rect destRect = .(0, 0, mWidth, mHeight);
			SDL.RenderCopy(mRenderer, title.mTexture, &srcRect, &destRect);

			SDL.Color color = .(0, 0, 0, 255);
			DrawString(mWidth / 2, 250, "Made by Konrad \"Athlon\" Figura", color, 1, TextAlign.Center);
			DrawString(mWidth / 2, 350, "athlon.kkmr.pl", color, 1, TextAlign.Center);
			DrawString(mWidth / 2, 450, "Original game made by arhn.eu", color, 1, TextAlign.Center);

			// Sleeping guinea pigs
			creditsFramesCount++;
			if (creditsFramesCount >= CreditsAnimationSpeed)
				creditsFramesCount = 0;

			Image sleep = creditsFramesCount >= CreditsAnimationSpeed / 2 ? Images.GuineaPigs[1] : Images.GuineaPigs[0];
			SDL.Rect sleepSrcRect = .(0, 0, sleep.mSurface.w, sleep.mSurface.h);
			SDL.Rect sleepDestRect = .(50, 560, (int32)(mWidth * 0.3f), (int32)(mHeight * 0.2f));
			SDL.RenderCopy(mRenderer, sleep.mTexture, &sleepSrcRect, &sleepDestRect);
		}

		void DrawGameOver()
		{
			Image gameOver = Images.GameOver;
			SDL.Rect srcRect = .(0, 0, gameOver.mSurface.w, gameOver.mSurface.h);
			SDL.Rect destRect = .(0, 0, mWidth, mHeight);
			SDL.RenderCopy(mRenderer, gameOver.mTexture, &srcRect, &destRect);

			SDL.Color color = .(255, 255, 255, 255);
			DrawString(mWidth / 2, 300, scope String()..AppendF("YOUR SCORE: {}", Score), color, 2, TextAlign.Center);
			// DrawString(mWidth / 2, 350, scope String()..AppendF("TOP SCORE: {}", Save.GetTopScore()), color, 2, TextAlign.Center);
			// TODO: Implement top score saving when the score saving finally gets implemented.

			scoreFramesCount++;
			if (scoreFramesCount >= ScoreAnimationSpeed)
				scoreFramesCount = 0;

			Image grunio = scoreFramesCount >= ScoreAnimationSpeed / 2 ? Images.GrunioResult[1] : Images.GrunioResult[0];
			SDL.Rect grunioSrcRect = .(0, 0, grunio.mSurface.w, grunio.mSurface.h);
			SDL.Rect grunioDestRect = .(50, 550, (int32)(mWidth * 0.24f), (int32)(mHeight * 0.2f));
			SDL.RenderCopy(mRenderer, grunio.mTexture, &grunioSrcRect, &grunioDestRect);

			Image dida = scoreFramesCount >= ScoreAnimationSpeed / 2 ? Images.DidaResult[1] : Images.DidaResult[0];
			SDL.Rect didaDestRect = .(728, 550, (int32)(mWidth * 0.24f), (int32)(mHeight * 0.2f));
			SDL.RenderCopy(mRenderer, dida.mTexture, &grunioSrcRect, &didaDestRect);
		}

		public override void Draw()
		{
			skybox.Draw();

			switch (ActiveState)
			{
			case GameStates.Title:
				Image title = Images.Title;
				SDL.Rect srcRect = .(0, 0, title.mSurface.w, title.mSurface.h);
				SDL.Rect destRect = .(0, 0, mWidth, mHeight);
				SDL.RenderCopy(mRenderer, title.mTexture, &srcRect, &destRect);
			case GameStates.Menu:
				DrawMenu();
			case GameStates.Credits:
				DrawCredits();
			case GameStates.Score:
				DrawGameOver();
			case GameStates.Game:
				world.Draw();
				for (var entity in entities)
					entity.Draw();

				DrawHUD();
			default:
				return;
			}

		}

		void AddEntity(Entity e)
		{
			entities.Add(e);
		}

		void HandleTitleScreenInput()
		{
			if (IsKeyDown(.Space) && !isSwitchKeyDown)
			{
				isSwitchKeyDown = true;
				LoadMenu();
			}
		}

		void HandleMenuInput()
		{
			if (IsKeyDown(.Space) && !isSwitchKeyDown)
			{
				isSwitchKeyDown = true;
				switch (ActiveOption)
				{
				case 0:
					LoadGame();
				case 1:
					LoadCredits();
				case 2:
					System.GC.Shutdown();
				default:
					LoadMenu();
				}
			}

			if (!isMoveKeyHeld)
			{
				if (IsKeyDown(.Up))
				{
					ActiveOption--;
					isMoveKeyHeld = true;
				}

				if (IsKeyDown(.Down))
				{
					ActiveOption++;
					isMoveKeyHeld = true;
				}
			}

			if (isMoveKeyHeld && (!IsKeyDown(.Up) && !IsKeyDown(.Down)))
			{
				isMoveKeyHeld = false;
			}
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
		}

		public override void Update()
		{
			base.Update();

			// Sky box movement
			skybox.posX -= Math.Clamp(skybox.posX - Skybox.SkyboxSpeed, 1, mWidth - 10);

			switch (ActiveState)
			{
			case GameStates.Menu:
				HandleMenuInput();
			case GameStates.Game:
				HandleInputs();
				CarrotSpawner();
				for (var carrot in carrots)
					carrot.Update();

				if (ActivePlayer.Health <= 0)
				{
					gGameApp.GameOver();
				}
			default:
				HandleTitleScreenInput();
			}

			if (!IsKeyDown(.Space) && isSwitchKeyDown)
			{
				isSwitchKeyDown = false;
			}
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
