using System.IO;
using System;

namespace BeefGrunio
{
	class Save
	{
		const String SaveFile = "save.txt";

		public static void SaveScore(int score)
		{
			String text = "";
			score.ToString(text);
			File.WriteAllText(SaveFile, text, true);
		}

		public static int GetTopScore()
		{
			// Unfortunately, support for file reading is not implemented into the BEEF as the time of writing this file,
			// so I cannot implement proper score save feature :(
			return 0;
			if (!File.Exists(SaveFile))
			{
				 return 0;
			}

			String fileContent = "";
			File.ReadAllText(SaveFile, fileContent);

			if (fileContent == "")
			{
				return 0;
			}

			return int.Parse(fileContent);
		}
	}
}
