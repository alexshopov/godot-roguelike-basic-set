using Godot;

/// <summary>
/// Main class that executes when the game launches
/// </summary>
public partial class Main : Node3D
{
	[Export]
	public Node3D Player { get; set; }
	[Export]
	public Camera3D Camera { get; set; }
	[Export]
	public float MoveSpeed { get; set; } = 2f;
	
	private Tween _tween;

	public override void _Ready() { }

	/// <summary>
	/// Called once per frame. Handle player click-to-move logic
	/// </summary>
	/// <param name="delta">Time elapsed since the previous frame.</param>
	public override void _Process(double delta)
	{
		if (Input.IsActionJustPressed("left_click"))
		{
			// prevent starting a new tween if one is already running
			if (_tween != null && _tween.IsRunning())
				return;

			Vector3 playerPos = Player.GlobalPosition;
			Vector3 worldPos = GetMouseXZPlanePosition();

			// determine the player's direction of movement
			Vector3 direction = worldPos - playerPos;
			direction.Y = 0f;

			// ignore tiny clicks
			if (direction.Length() < 0.1f)
				return;

			// normalize the direction so player only moves 1 unit
			direction = direction.Normalized();

			// calculate the target position we want the player to move to
			Vector3 targetPos = playerPos + direction;

			// rotate the player to face its direction of movement
			Player.LookAt(targetPos, Vector3.Up);

			// animate the player sliding into its new position
			_tween = GetTree().CreateTween();
			_tween.TweenProperty(Player, "global_position", targetPos, 1 / MoveSpeed)
				.SetTrans(Tween.TransitionType.Sine)
				.SetEase(Tween.EaseType.InOut);
		}
	}

	/// <summary>
	/// Casts a ray from the mouse cursor and returns the intersection point with the XZ plane
	/// </summary>
	/// <returns>The 3D world position under the mouse cursor in the XZ plane.</returns>
	public Vector3 GetMouseXZPlanePosition()
	{
		Vector2 mousePos = GetViewport().GetMousePosition();
		Vector3 rayStart = Camera.ProjectRayOrigin(mousePos);
		Vector3 rayDirection = Camera.ProjectRayNormal(mousePos);

		float t = -rayStart.Y / rayDirection.Y;
		return rayStart + rayDirection * t;
	}
}
