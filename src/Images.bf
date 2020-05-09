using System;
using SDL2;
using System.Collections;

namespace BeefGrunio
{
	static class Images
	{
		// World
		public static Image World1;
		public static Image Sky;

		// Player
		public static List<Image> Grunio = new .() ~ delete _;
		public static List<Image> GrunioL = new .() ~ delete _;
		public static List<Image> Dida = new .() ~ delete _;
		public static List<Image> DidaL = new .() ~ delete _;

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
			World1 = Try!(Load("images/world1.png"));
			Sky = Try!(Load("images/sky.bmp"));

			Grunio.Add(Try!(Load("images/grunio_0.png")));
			Grunio.Add(Try!(Load("images/grunio_1.png")));
			GrunioL.Add(Try!(Load("images/grunio_0_l.png")));
			GrunioL.Add(Try!(Load("images/grunio_1_l.png")));

			Dida.Add(Try!(Load("images/dida_0.png")));
			Dida.Add(Try!(Load("images/dida_1.png")));
			DidaL.Add(Try!(Load("images/dida_0_l.png")));
			DidaL.Add(Try!(Load("images/dida_1_l.png")));
			return .Ok;
		}

		public static void Dispose()
		{
			ClearAndDeleteItems(images);
		}
	}
}
