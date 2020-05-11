using System;
using SDL2;
using System.Collections;

namespace BeefGrunio
{
	static class Images
	{
		// Menus
		public static Image Title;
		public static Image Credits;
		public static Image GameOver;
		public static List<Image> GuineaPigs = new .() ~ delete _;
		public static List<Image> GrunioResult = new .() ~ delete _;
		public static List<Image> DidaResult = new .() ~ delete _;

		// World
		public static Image World1;
		public static Image World2;
		public static Image Sky;

		// Player
		public static List<Image> Grunio = new .() ~ delete _;
		public static List<Image> GrunioL = new .() ~ delete _;
		public static List<Image> Dida = new .() ~ delete _;
		public static List<Image> DidaL = new .() ~ delete _;

		// Carrots
		public static Image Orange;
		public static Image White;

		// Heart
		public static Image Heart;

		static List<Image> images = new .() ~ delete _;

		public static Result<Image> Load(StringView fileName)
		{
			Image image = new Image();
			if (image.Load(fileName) case .Err)
			{
				delete image;
				return .Err;
			}

			images.Add(image);
			return image;
		}

		public static Result<void> Init()
		{
			Title = Try!(Load("images/title.bmp"));
			Credits = Try!(Load("images/credits.bmp"));
			GameOver = Try!(Load("images/gameover.bmp"));
			World1 = Try!(Load("images/world1.png"));
			World2 = Try!(Load("images/world2.png"));
			Sky = Try!(Load("images/sky.bmp"));

			GuineaPigs.Add(Try!(Load("images/sleep1.png")));
			GuineaPigs.Add(Try!(Load("images/sleep2.png")));

			GrunioResult.Add(Try!(Load("images/gruniores0.png")));
			GrunioResult.Add(Try!(Load("images/gruniores1.png")));
			DidaResult.Add(Try!(Load("images/didares0.png")));
			DidaResult.Add(Try!(Load("images/didares1.png")));

			Grunio.Add(Try!(Load("images/grunio_0.png")));
			Grunio.Add(Try!(Load("images/grunio_1.png")));
			GrunioL.Add(Try!(Load("images/grunio_0_l.png")));
			GrunioL.Add(Try!(Load("images/grunio_1_l.png")));

			Dida.Add(Try!(Load("images/dida_0.png")));
			Dida.Add(Try!(Load("images/dida_1.png")));
			DidaL.Add(Try!(Load("images/dida_0_l.png")));
			DidaL.Add(Try!(Load("images/dida_1_l.png")));

			Orange = Try!(Load("images/orange.png"));
			White = Try!(Load("images/white.png"));

			Heart = Try!(Load("images/heart.png"));
			
			return .Ok;
		}

		public static void Dispose()
		{
			ClearAndDeleteItems(images);

		}
	}
}
