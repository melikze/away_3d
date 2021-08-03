package 
{
	/**
	 * ...
	 * @author mlkz
	 */
	public class Resource 
	{
		[Embed(source = "assets/beach.jpg")] public static var BEACH:Class;
		[Embed(source = "assets/sky_negX.jpg")] public static var SKY_NEGX:Class;
		[Embed(source = "assets/sky_negY.jpg")] public static var SKY_NEGY:Class;
		[Embed(source = "assets/sky_negZ.jpg")] public static var SKY_NEGZ:Class;
		[Embed(source = "assets/sky_posX.jpg")] public static var SKY_POSX:Class;
		[Embed(source = "assets/sky_posY.jpg")] public static var SKY_POSY:Class;
		[Embed(source = "assets/sky_posZ.jpg")] public static var SKY_POSZ:Class;
		[Embed(source = "assets/pknight1.png")] public static var MODEL_TEXTURE:Class;
		[Embed(source = "assets/pknight.md2", mimeType="application/octet-stream")] public static var MODEL_DATA:Class;
		
		
		public function Resource() 
		
		{
			
		}
		
	}

}