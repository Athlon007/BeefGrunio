using System;
using SDL2;
using System.Collections;

namespace BeefGrunio
{
	class Sounds	
	{
		public static Sound Menu;

		static List<Sound> sounds = new .() ~ delete _;

		public static void Dispose()
		{
			ClearAndDeleteItems(sounds);
		}

		public static Result<Sound> Load(StringView fileName)
		{
			Sound sound = new Sound();
			if (sound.Load(fileName) case .Err)
			{
				delete sound;
				return .Err;
			}

			sounds.Add(sound);
			return sound;
		}

		public static Result<void> Init()
		{
			Menu = Try!(Load("sounds/menu.wav"));
			return .Ok;
		}
	}
}
