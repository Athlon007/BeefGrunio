using System;
using SDL2;
using System.Collections;

namespace BeefGrunio
{
	class Sounds	
	{
		public static SDLMixer.Music* Menu;
		public static SDLMixer.Music* GameOver;

		public static Sound Accept;
		public static Sound Select;

		static List<Sound> sounds = new .() ~ delete _;
		static List<SDLMixer.Music*> musics = new .() ~ ClearAndDeleteItems(_);

		public static void Dispose()
		{
			ClearAndDeleteItems(sounds);
			//ClearAndDeleteItems(musics);
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

		public static Result<SDLMixer.Music*> LoadMusic(char8* fileName)
		{
			SDLMixer.Music* music = SDLMixer.LoadMUS(fileName);
			if (music == null)
			{
				delete music;
				return .Err;
			}

			musics.Add(music);
			return music;
		}

		public static Result<void> Init()
		{
			Menu = Try!(LoadMusic("sounds/menu.wav"));
			GameOver = Try!(LoadMusic("sounds/gameover.wav"));
			Accept = Try!(Load("sounds/accept.wav"));
			Select = Try!(Load("sounds/select.wav"));
			return .Ok;
		}
	}
}
