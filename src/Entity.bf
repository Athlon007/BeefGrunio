namespace BeefGrunio
{
	class Entity
	{
		public float posX;
		public float posY;

		public bool ignoreRenderer;

		public bool IsOffscreen(float marginX, float marginY)
		{
			return ((posX < -marginX) || (posX >= gGameApp.mWidth + marginX) ||
				(posY < -marginY) || (posY >= gGameApp.mHeight + marginY));
		}

		public virtual void Update() {}

		public virtual void Draw() {}
	}
}
