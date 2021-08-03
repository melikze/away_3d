package
{
	import away3d.animators.VertexAnimationSet;
	import away3d.animators.VertexAnimator;
	import away3d.animators.states.IVertexAnimationState;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.assets.AssetType;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.SkyBox;
	import away3d.textures.BitmapCubeTexture;
	import away3d.utils.Cast;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import away3d.library.AssetLibrary;
	import away3d.loaders.parsers.MD2Parser;
	
	/**
	 * ...
	 * @author mlkz
	 */
	public class Main extends Sprite 
	{
		private var _view:View3D;
		private var _ground:Mesh;
		private var _cubeTexture:BitmapCubeTexture;
		private var _skybox:SkyBox;
		private var _modelMesh:away3d.entities.Mesh;
		private var _animationSet:away3d.animators.VertexAnimationSet;
		private var _player:ObjectContainer3D;
		private var _animator:VertexAnimator;
		private var _camera:HoverController;
		private var _moveForward:Boolean, _moveBack:Boolean, _moveLeft:Boolean, _moveRight:Boolean;
		private var _mouseDown:Boolean;
		private var _previousMouse:Point;
		
		
		
		public function Main():void
		
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void		
		
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			initView();
			createGround();
			createSkybox();
			createPlayer();
			
			_moveForward = _moveBack = _moveRight = _moveLeft = false;
			_mouseDown = false;
			_previousMouse = new Point();
			
		}
		
		private function update(e:Event):void
		{
			if (_moveForward)
			{
				_player.moveForward(24);
				_animator.play("run");
			}
			else
			if (_moveBack)
			{
				_player.moveBackward(24);
				_animator.play("run");
			}
			else
			if(_moveLeft)
			{
				_player.moveLeft(24);
				_animator.play("run");
			}
			else
			if (_moveRight)
			{
				_player.moveRight(24);
				_animator.play("run");
			}
			else
			{
				_animator.play("stand");
			}
			
			if (_mouseDown)
			{
				var xDif:Number = stage.mouseX - _previousMouse.x;
				var xDif:Number = stage.mouseY - _previousMouse.y;
				
				if (xDif > 10)
				xDif = 10;
				
				if (xDif < 10)
				xDif = -10;
				
				_camera.panAngle += xDif;
				_player.rotationY += xDif;
				
				_camera.tiltAngle += xDif;
				
				_previousMouse.x = stage.mouseX;
				_previousMouse.y = stage.mouseY;
				
			}
			
			_view.render();
		}
		
		private function createPlayer():void
		{
			var model:*= new Resource.MODEL_DATA();
			
			AssetLibrary.enableParser(MD2Parser);
			AssetLibrary.loadData(model);
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetReady);
			AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceReady);
			
			
		}
		
		private function onAssetReady(e:AssetEvent):void
		{
			if (e.asset.assetType == AssetType.MESH)
			{
				_modelMesh = e.asset as Mesh;
				AssetLibrary.removeEventListener(AssetEvent.ASSET_COMPLETE, onAssetReady);
				
			}
			else if (e.asset.assetType == AssetType.ANIMATION_SET)
			{
				_animationSet = e.asset as VertexAnimationSet;
			}
		}
		private function onResourceReady(e:LoaderEvent):void
		{
			AssetLibrary.removeEventListener (LoaderEvent.RESOURCE_COMPLETE, onResourceReady);
			
			var texture:Bitmap = new Resource.MODEL_TEXTURE() as Bitmap;
			var material:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(texture.bitmapData));
			
			_modelMesh.material = material;
			_modelMesh.scale(4);
			
			_player = new ObjectContainer3D();
			_player.addChild(_modelMesh);
			
			_view.scene.addChild(_player);
			
			_modelMesh.y = 100;
			_modelMesh.rotationY = -90;
			_modelMesh.animator = new VertexAnimator(_animationSet);
			_animator = VertexAnimator(_modelMesh.animator);
			
			_animator.play("flip");
			
			createCamera();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			
			
			
			
			addEventListener(Event.ENTER_FRAME, update);
			
			
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			switch(e.keyCode)
			{
				case 87: _moveForward = true; break//w
				case 83: _moveBack = true; break //s
				case 65: _moveLeft = true; break //a
				case 68: _moveRight = true; break//d
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void 
		{
			switch(e.keyCode)
			{
				case 87: _moveForward = false; break//w
				case 83: _moveBack = false; break //s
				case 65: _moveLeft = false; break //a
				case 68: _moveRight = false; break//d
			}
		}
		private function onMouseDown(e:MouseEvent):void
		{
			_mouseDown = true;
			_previousMouse.x = e.stageX;
			_previousMouse.y = e.stageY;
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			_mouseDown = false;
		}
		private function createCamera():void
		{
			_camera = new HoverController(_view.camera, _player, 180, 45, 400);
			_camera.steps = 12;
			_camera.minTiltAngle = 5;
			_camera.maxTiltAngle = 33;
			_camera.wrapPanAngle = true;
			
		}
		private function createSkybox():void
		{
			var posx:Bitmap = new Resource.SKY_POSX () as Bitmap;
			var negx:Bitmap = new Resource.SKY_NEGX () as Bitmap;
			var posy:Bitmap = new Resource.SKY_POSY () as Bitmap;
			var negy:Bitmap = new Resource.SKY_NEGY () as Bitmap;
			var posz:Bitmap = new Resource.SKY_POSZ () as Bitmap;
			var negz:Bitmap = new Resource.SKY_NEGZ () as Bitmap;
			
			_cubeTexture = new BitmapCubeTexture(posx.bitmapData,
			                                     negx.bitmapData,
												 posy.bitmapData,
												 negy.bitmapData,
												 posz.bitmapData,
												 negz.bitmapData);
											
			_skybox = new SkyBox(_cubeTexture);
			
			_view.scene.addChild(_skybox);
												 
			
		}
		private function createGround():void
		{
			var ground:Bitmap = new Resource.BEACH() as Bitmap;
			var textureMat: TextureMaterial = new TextureMaterial (Cast.bitmapTexture(ground.bitmapData), true, true);
			
			_ground = new Mesh(new PlaneGeometry(10240, 10240, 4, 4), textureMat);
			_view.scene.addChild(_ground);
			
		}
		
		private function initView():void
		{
			_view = new View3D();
			_view.backgroundColor = 0x0;
			_view.antiAlias = 4;
			addChild(_view);
			
			_view.camera.z =-170;
			_view.camera.y = 150;
			_view.camera.lookAt(new Vector3D());
			
			_view.camera.lens = new PerspectiveLens(90);
			_view.camera.lens.far = 4000;
			
		
			
			
			
		}
		
	}
	
}