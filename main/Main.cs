using System;
using Godot;

/// <summary>
/// Main class that executes when the game launches
/// </summary>
public partial class Main : Node3D
{
    private const int MAP_WIDTH = 40;
    private const int MAP_HEIGHT = 24;

	private GameMap _gameMap;
	private Camera3D _camera;

	public override void _Ready()
	{
		_gameMap = GetNode<GameMap>("GameMap");
		_gameMap?.Init(MAP_WIDTH, MAP_HEIGHT);

		_camera = GetNode<Camera3D>("CameraRig/Camera3D");
	}

	public override void _Input(InputEvent @event)
	{
		if (@event.IsActionPressed("left_click"))
		{
			Vector3 worldPos = GetMouseXZPlanePosition();
			EventManager.MouseClickedInWorld?.Invoke(worldPos);
		}
	}

	public Vector3 GetMouseXZPlanePosition()
	{
		Vector2 mousePos = GetViewport().GetMousePosition();
		Vector3 rayStart = _camera.ProjectRayOrigin(mousePos);
		Vector3 rayDirection = _camera.ProjectRayNormal(mousePos);

		float t = -rayStart.Y / rayDirection.Y;
		return rayStart + rayDirection * t;
	}
}
